package com.takshine.wxcrm.controller;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.FTPUtil;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.QRCodeUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.SocialUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.SocialContact;
import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;

/**
 * 联系人 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/contact")
public class ContactController {
	// 日志
	protected static Logger logger = Logger.getLogger(ContactController.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 保存最后一次查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savelastsearch")
	@ResponseBody
	public String savelastsearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String assignerid=request.getParameter("assignerid");//获得责任人id
		String conname = request.getParameter("conname");//获得姓名
		String phonemobile =request.getParameter("phonemobile");//获得移动电话
		String crmId = UserUtil.getCurrUser(request).getCrmId();//
		String searchcon=conname+"|"+phonemobile+"|"+assignerid;
		logger.info("ContactController  savelastsearch method crmId =>" + crmId);
		logger.info("ContactController  savelastsearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//删除之前的缓存记录
			RedisCacheUtil.delete("contact_search_last"+crmId);
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("contact_search_last"+crmId, searchList.get(i), i);
				}
				crmErr.setErrorCode("0");
			}catch(Exception e){
				e.printStackTrace();
				crmErr.setErrorCode("9");
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	

	/**
	 * 加载最后一次的查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/searchlastcache")
	@SuppressWarnings("rawtypes")
	@ResponseBody
	public String searchlastcache(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ContactController searchlastcache method crmId =>" + crmId);
		//cache
		List<String> sealist = new ArrayList<String>();
		//获取缓存的查询条件
		Set<String> rs = RedisCacheUtil.getSortedSetRange("contact_search_last"+crmId, 0, 0);
		for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
			String searchcon = (String) iterator.next();
			sealist.add(searchcon);
			logger.info("ContactController searchlastcache method searchcon=>" + searchcon);
		}
		return JSONArray.fromObject(sealist).toString();
	}
	
	
	/**
	 * 保存查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savesearch")
	@ResponseBody
	public String savesearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String assignerid=request.getParameter("assignerid");
		String phonemobile=request.getParameter("phonemobile");
		String conname = request.getParameter("conname");
		String searchname =request.getParameter("searchname");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String searchcon=searchname+"|"+"conname:"+conname+"|"+"phonemobile:"+phonemobile+"|"+"assignerid:"+assignerid;
		logger.info("ContactController  savesearch method crmId =>" + crmId);
		logger.info("ContactController  savesearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("contact_search_"+crmId, searchList.get(i), i);
				}
				crmErr.setErrorCode("0");
			}catch(Exception e){
				e.printStackTrace();
				crmErr.setErrorCode("9");
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	

	/**
	 * 加载缓存的查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/searchcache")
	@SuppressWarnings("rawtypes")
	@ResponseBody
	public String searchcache(HttpServletRequest request,
			HttpServletResponse response) throws Exception{ 
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ContactController searchcache method crmId =>" + crmId);
		
		//cache
		List<String> sealist = new ArrayList<String>();
		//获取缓存的查询条件
		Set<String> rs = RedisCacheUtil.getSortedSetRange("contact_search_"+crmId, 0, 0);
		for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
			String searchcon = (String) iterator.next();
			sealist.add(searchcon);
			logger.info("contact_search_ searchcache method searchcon=>" + searchcon);
		}
		return JSONArray.fromObject(sealist).toString();
	}
	
	
	/**
	 * 清空最后一次的查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/dellastcache")
	@ResponseBody
	public String dellastcache(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ContactController dellastcache method crmId =>" + crmId);
		//获取缓存的查询条件
		if(null != crmId && !"".equals(crmId)){
			RedisCacheUtil.delete("contact_search_last"+crmId);
			return "success";
		}
		return "fail";
	}
	
	/**
	 * 删除查询条件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delcache")
	@ResponseBody
	public String delcache(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String name = request.getParameter("name");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			Set<String> rs = RedisCacheUtil.getSortedSetRange("customer_search_"+ crmId, 0, 0);
			List<String> searchList = new ArrayList<String>();
			if(rs!=null){
				RedisCacheUtil.delete("contact_search_" + crmId);
			}
			try{
				for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
					String searchcon = (String) iterator.next();
					logger.info("ContactController searchcache method searchcon=>"+ searchcon);
					if(!searchcon.contains(name)){
						searchList.add(searchcon);
					}
				}
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("contact_search_"+crmId, searchList.get(i), i);
				}
				crmErr.setErrorCode("0");
			}catch(Exception e){
				e.printStackTrace();
				crmErr.setErrorCode("9");
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	
	
	
	
	/**
	 * 新增 联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	public String save(Contact obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String crmId = getNewCrmId(request);
		String flag = request.getParameter("flag");
		//判断crmId 是否为空
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			String type = obj.getParentType();
			obj.setCrmId(crmId);
			obj.setAssignerId(crmId);
			if (!StringUtils.isNotNullOrEmptyStr(obj.getParentType()))
			{
				obj.setParentType("Contract");
			}
			CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(obj);
			String rowId = crmErr.getRowId();
			if (null != rowId && !"".equals(rowId)) {
				request.setAttribute("rowId", rowId);
				request.setAttribute("success", "ok");
				
				if("addCon".equals(flag)){
					//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
					if(null != obj.getAssignerId() && !crmId.equals(obj.getAssignerId())){
						cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerId(),request.getSession().getAttribute("assigner")+" 分配了一个联系人【"+obj.getConname()+"】给您", "contact/detail?rowId="+obj.getRowid()+"&orgId="+obj.getOrgId());
					}
					if (StringUtils.isNotNullOrEmptyStr(request.getParameter("source")))
					{
						if ("Accounts".equals(obj.getParentType()))
						{
							return "redirect:/customer/detail?rowId=" + obj.getParentId() + "&orgId=" + obj.getOrgId();
						}
						else if ("Opportunities".equals(obj.getParentType()))
						{
							return "redirect:/oppty/detail?rowId=" + obj.getParentId() + "&orgId=" + obj.getOrgId();
						}
					}
					return "redirect:/cbooks/list";//"redirect:/contact/clist?orgId="+obj.getOrgId();
				}
				else if("addRela".equals(flag)){
					return "redirect:/contact/get?parentId="+obj.getParentId()+"&orgId="+obj.getOrgId()+"&parentName="+URLEncoder.encode(obj.getParentName(),"UTF-8")+"&parentType="+obj.getParentType()+"&conname="+URLEncoder.encode(obj.getParentName(),"UTF-8");
				}
				else{
					// 如果类型是业务机会的,跳转到业务机会类型详情页面
					if ("Opportunities".equals(type)) {
						return "redirect:/oppty/detail?rowId="+obj.getParentId()+"&orgId="+obj.getOrgId();
						
					}else if ("Accounts".equals(type)) {
						return "redirect:/customer/detail?rowId=" + obj.getParentId()+"&orgId="+obj.getOrgId();
					}else if("Project".equals(type)){
						return "redirect:/project/detail?rowId=" + obj.getParentId()+"&orgId="+obj.getOrgId();
					}else if("Contract".equals(type)){
						return "redirect:/contract/detail?rowId=" + obj.getParentId()+"&orgId="+obj.getOrgId();
					}else{
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001002 + "，错误描述：" + ErrCode.ERR_MSG_TYPEISNULL);
					}
				}
			}else{
				throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 修改联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String rowId = request.getParameter("rowId");
		logger.info("ContactController modify method openId =>" + openId);
		logger.info("ContactController modify method rowId =>" + rowId);
		String orgId = request.getParameter("orgId");
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = (String)obj;
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ContactResp sResp = cRMService.getSugarService().getContact2SugarService().getContactSingle(rowId,crmId);
			List<ContactAdd> list = sResp.getContacts();
			// 放到页面上
			if (null != list && list.size() > 0) {
				request.setAttribute("sd", list.get(0));
				request.setAttribute("contactName", list.get(0).getConname());

			} else {
				request.setAttribute("sd", new ContactAdd());
			}
			// 获取下拉列表信息和 责任人的用户列表信息
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
					.getLovList(crmId);
			request.setAttribute("timefres", mp.get("contact_freq_list"));
		}
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("crmId", crmId);

		return "contact/modify";
	}

	
	
	/**
	 * 威客系统对外提供的接口 新增 联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/wk_contact_save")
	@ResponseBody
	public String wk_contact_save(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sex = request.getParameter("sex");//性别
		String name = request.getParameter("name");//姓名
		String email = request.getParameter("email");//邮箱
		String address = request.getParameter("address");//地址
		String position = request.getParameter("position");//职位
		String mobile = request.getParameter("mobile");//移动电话
		String phone = request.getParameter("phone");//办公电话
		String crmid = request.getParameter("crmid");//用户id

		if(null == crmid || "".equals(crmid) ||
			null == name || "".equals(name) ||
			null == mobile || "".equals(mobile)){
			return "{\"errorCode\":\"7\",\"errorMsg\":\"参数填写不完整\"}";
		}
		logger.info("wk_contact_save = >");
		logger.info("sex = >" + sex);
		logger.info("name = >" + name);
		logger.info("email = >" + email);
		logger.info("address = >" + address);
		logger.info("position = >" + position);
		logger.info("mobile = >" + mobile);
		logger.info("phone = >" + phone);
		logger.info("crmid = >" + crmid);
		//创建对象
		Contact ct = new Contact();
		ct.setCrmId(crmid);
		ct.setSalutation(sex);
		ct.setConname(name);
		ct.setEmail0(email);
		ct.setConaddress(address);
		ct.setConjob(position);
		ct.setPhonemobile(mobile);
		ct.setPhonework(phone);
		ct.setAssignerId(crmid);
		//保存联系人
		CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(ct);
		String rowId = crmErr.getRowId();
		logger.info("rowId = >" + rowId);
		return "{\"errorCode\":\"0\",\"errorMsg\":\"success\",\"rowId\":\""+ rowId +"\"}";
	}
	
	
	/**
	 * 威客系统对外提供的接口 新增 联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/wk_contact_save_json")
	@ResponseBody
	public String wk_contact_save_json(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ServletInputStream reader=request.getInputStream();
		byte [] buff = new byte[1024];
		int length = 0;
		StringBuffer respRst = new StringBuffer("");
		while ((length = reader.read(buff)) != -1) {
			respRst.append(new String(buff, 0, length,"UTF-8"));
		}
		logger.info("jsonStr = >" + respRst);
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(respRst.toString());
		String sex =jsonObject.getString("sex");//性别
		String name =jsonObject.getString("name");//姓名
		String email = jsonObject.getString("email");//邮箱
		String address = jsonObject.getString("address");//地址
		String position = jsonObject.getString("position");//职位
		String mobile = jsonObject.getString("mobile");//移动电话
		String phone = jsonObject.getString("phone");//办公电话
		String crmid = jsonObject.getString("crmid");//用户id
		String partyid=jsonObject.getString("partyid");
		String orgId=jsonObject.getString("orgId");
		if(partyid!=null&&!"".equals(partyid.trim())){
			//根据partyid查找openId
			WxuserInfo wxuser = new WxuserInfo();
			wxuser.setParty_row_id(partyid);
			wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
			if(!StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
				return "{\"errorCode\":\"-1\",\"errorMsg\":\"同步失败\",\"rowId\":\"\"}";
			}
			
			OperatorMobile obj = new OperatorMobile();
			obj.setOpenId(wxuser.getOpenId());
			obj.setOrgId(orgId);
			List<OperatorMobile> list = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(obj);
			if(list!=null&&list.size()>0){
				crmid = list.get(0).getCrmId();
			}else{
				return "{\"errorCode\":\"-1\",\"errorMsg\":\"同步失败\",\"rowId\":\"\"}";
			}
		}
		if(null == crmid || "".equals(crmid) ||
			null == name || "".equals(name) ||
			null == mobile || "".equals(mobile)){
			return "{\"errorCode\":\"7\",\"errorMsg\":\"参数填写不完整\"}";
		}
		logger.info("wk_contact_save = >");
		logger.info("sex = >" + sex);
		logger.info("name = >" + name);
		logger.info("email = >" + email);
		logger.info("address = >" + address);
		logger.info("position = >" + position);
		logger.info("mobile = >" + mobile);
		logger.info("phone = >" + phone);
		logger.info("crmid = >" + crmid);
		//创建对象
		Contact ct = new Contact();
		ct.setCrmId(crmid);
		ct.setSalutation(sex);
		ct.setConname(name);
		ct.setEmail0(email);
		ct.setConaddress(address);
		ct.setConjob(position);
		ct.setPhonemobile(mobile);
		ct.setPhonework(phone);
		ct.setAssignerId(crmid);
		ct.setOrgId(orgId);
		//保存联系人
		CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(ct);
		String rowId = crmErr.getRowId();
		logger.info("rowId = >" + rowId);
		return "{\"errorCode\":\"0\",\"errorMsg\":\"success\",\"rowId\":\""+ rowId +"\"}";
	}
		
	/**
	 * 保存联系人关系
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/saveContact")
	public String saveContact(Contact obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String crmId = getNewCrmId(request);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setCrmId(crmId);
			CrmError crmErr = cRMService.getSugarService().getContact2SugarService().saveContact(obj);
			String str = crmErr.getErrorCode();
			String type= obj.getParentType();
			if(StringUtils.isNotNullOrEmptyStr(str)){
				if("Accounts".equals(type)){
					return "redirect:/customer/detail?rowId="+obj.getParentId()+"&orgId="+obj.getOrgId();
				}else if("Contract".equals(type)){
					return "redirect:/contract/detail?rowId="+obj.getParentId()+"&orgId="+obj.getOrgId();
				}else{
					return "redirect:/oppty/detail?rowId="+obj.getParentId()+"&orgId="+obj.getOrgId();
				}
			}else{
				throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 客户协同-联系人
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/saveCustRela")
	@ResponseBody
	public String saveCustRela(HttpServletRequest request,
			HttpServletResponse response) throws Exception
	{
		String crmId = getNewCrmId(request);
		if(StringUtils.isNotNullOrEmptyStr(crmId))
		{
			boolean succFlag = true;
			String parentId = request.getParameter("parentId");//获得相关id
			String parentType = request.getParameter("parentType");
			String rowIds = request.getParameter("rowIds");
			String orgId = request.getParameter("orgId");
			if (StringUtils.isNotNullOrEmptyStr(orgId))
			{
				crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
			}
			
			String[] rowIdList = new String[]{};
			if (StringUtils.isNotNullOrEmptyStr(rowIds))
			{
				rowIdList = rowIds.split(",");
			}
			Contact obj = null;
			for (int i=0; i<rowIdList.length;i++)
			{
				obj = new Contact();
				obj.setCrmId(crmId);
				obj.setParentId(parentId);
				obj.setParentType(parentType);
				obj.setRowid(rowIdList[i]);
				obj.setOrgId(orgId);
				CrmError crmErr = cRMService.getSugarService().getContact2SugarService().saveContact(obj);
				String str = crmErr.getErrorCode();
				if (ErrCode.ERR_CODE_0.equals(str))
				{
					continue;
				}
				else
				{
					succFlag = false;
				}
			}
			
			if (!succFlag)
			{
				return "2";//操作失败，部分可能成功
			}
			return "0";//操作成功
		}
		else
		{
			return "1";//操作失败，异常
		}
	}
	

	/**
	 * 删除联系人(只是删除业务机会或者客户的关联关系)
	 * @return
	 */
	@RequestMapping("/delCustRela")
	@ResponseBody
	public String delCustRela(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		String crmId = getNewCrmId(request);
		if(StringUtils.isNotNullOrEmptyStr(crmId))
		{
			boolean succFlag = true;
			String parentId = request.getParameter("parentId");
			String parentType = request.getParameter("parentType");
			String rowIds = request.getParameter("rowIds");
			String orgId = request.getParameter("orgId");
			
			String[] rowIdList = new String[]{};
			if (StringUtils.isNotNullOrEmptyStr(rowIds))
			{
				rowIdList = rowIds.split(",");
			}
			Contact obj = null;
			for (int i=0; i<rowIdList.length;i++)
			{
				obj = new Contact();
				obj.setCrmId(crmId);
				obj.setParentId(parentId);
				obj.setParentType(parentType);
				obj.setRowid(rowIdList[i]);
				obj.setOrgId(orgId);
				
				CrmError crmErr = cRMService.getSugarService().getContact2SugarService().delContact(obj);
				String str = crmErr.getErrorCode();
				if (ErrCode.ERR_CODE_0.equals(str))
				{
					continue;
				}
				else
				{
					succFlag = false;
				}
			}
			
			if (!succFlag)
			{
				return "2";//操作失败，部分可能成功
			}
			return "0";//操作成功
		}
		else
		{
			return "1";//操作失败，异常
		}
	}
	
	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value="/upload")
	@ResponseBody
	public String upload(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;     
        //获得文件：     
        MultipartFile file = multipartRequest.getFile("uploadFile");   
        if(file!=null&&file.getSize()>0){
        	logger.info("ContactController upload method fileName=" + file.getOriginalFilename());
        	String fileName = file.getOriginalFilename(); 
	        try{
	        	//获取上传文件类型的扩展名,先得到.的位置，再截取从.的下一个位置到文件的最后，最后得到扩展名 
		        	Image src = javax.imageio.ImageIO.read(file.getInputStream()); //构造Image对象
		        	BufferedImage tag = new BufferedImage(80,80,BufferedImage.TYPE_INT_RGB);
		        	tag.getGraphics().drawImage(src,0,0,80,80,null);       //绘制缩小后的图
		        	//将生成的缩略成转换成流
		        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
		        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
		        	ImageIO.write(tag,"jpeg",imOut); //scaledImage1为BufferedImage
		        	InputStream is =new ByteArrayInputStream(bs.toByteArray());
		        	
		        	//重新命名
		        	fileName = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32BeginTimePK()+".jpeg";
		        	//ftp上传
		        	FTPUtil fu = new FTPUtil();  
		        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
		        	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.path"), fileName, is)){
		        		fu.closeFTP(ftp);
		        		logger.info("ContactController upload method 上传后文件名！"+fileName);
		        		return "0"+fileName;
		        	}else{
		        		fu.closeFTP(ftp);
		        		logger.info("ContactController upload method -1 上传失败！");
		        		return null;
		        	}
	        }catch(Exception ex){
	        	logger.info("ContactController upload method -3 上传失败！" + ex.toString());
	        	return null;
	        }
        }else{
        	logger.info("ContactController upload method -4 上传失败！");
        	return null;
        }
	}
	
	
	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value="/download")
	@ResponseBody
	public void download(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		try{
			String fileName = request.getParameter("fileName");
			String flag = request.getParameter("flag");
			String contentType = "image/jpeg;charset=GBK";
			OutputStream outputStream = response.getOutputStream();
			FTPUtil fu = new FTPUtil();  
			FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
			if("dccrm".equals(flag)){
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, outputStream);
			}else{
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.service.path"), fileName, outputStream);
			}
	    	response.setContentType(contentType);  
	    	outputStream.flush();  
	        outputStream.close(); 
	        fu.closeFTP(ftp);
		}catch(Exception ex){
			logger.info("ContactController download method 下载图片失败！" + ex.toString());
		}
	}
	
	/**
	 * 异步新增 联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/asynsave", method = RequestMethod.POST)
	@ResponseBody
	public String asynsave(Contact obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ContactController asynsave method id =>" + obj.getId());
		obj.setCreateTime(DateTime.currentDate());// 创建时间
		String crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), obj.getOrgId());
		String add_wb  = request.getParameter("add_wb");
		String token = request.getParameter("access_token");
		String uid = request.getParameter("uid");
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			crmErr = cRMService.getSugarService().getContact2SugarService().addContact(obj);
			String rowId = crmErr.getRowId();
			if("add_wb".equals(add_wb)){
				SocialContact  socialContact = new SocialContact();
				socialContact.setAccess_token(token);
				socialContact.setContactid(rowId);
				socialContact.setUid(uid);
				cRMService.getDbService().getSocialContactService().addObj(socialContact);
			}
			logger.info("ContactController asynsave rowId =>" + rowId);
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		// rowId
		return JSONObject.fromObject(crmErr).toString();
	}

	/**
	 * 联系人 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ContactController detail method begin=>");
		ZJWKUtil.getRequestURL(request);//获取请求的url
		String rowId = request.getParameter("rowId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		logger.info("ContactController detail method rowId =>" + rowId);
		logger.info("ContactController detail method openId =>" + openId);
		String orgId = request.getParameter("orgId");
		String crmId = "";
		if(StringUtils.isNotNullOrEmptyStr(orgId)){
			Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
			if(null==obj || "".equals(obj.toString())){
				crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
			}else{
				crmId = (String)obj;
			}
		}else{
			CacheContact cCon = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(rowId);
			if(!StringUtils.isNotNullOrEmptyStr(cCon.getRowid())){
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001007 + "，错误描述：" + ErrCode.ERR_MSG_1001007);
			}
			crmId = cCon.getCrm_id();
			orgId = cRMService.getDbService().getCacheContactService().getOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), crmId);
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ContactResp sResp = cRMService.getSugarService().getContact2SugarService().getContactSingle(rowId,crmId);
			List<ContactAdd> list = sResp.getContacts();
			// 放到页面上
			if (null != list && list.size() > 0) {
				
				if(SocialUtil.IS_OPEN_SOCIAL==1){
					SocialContact socialContact1 = (SocialContact)cRMService.getDbService().getSocialContactService().findObjById(list.get(0).getRowid());
					if(socialContact1!=null){
						String uid = socialContact1.getUid();
						String accesstoken = socialContact1.getAccess_token();
						if(StringUtils.isNotNullOrEmptyStr(uid)&&StringUtils.isNotNullOrEmptyStr(accesstoken)){
							SocialUserInfo wbuser = SocialUtil.getWBUserInfo(accesstoken,uid);
							if(!StringUtils.isNotNullOrEmptyStr(list.get(0).getFilename())&&StringUtils.isNotNullOrEmptyStr(wbuser.getHeadimgurl())){
								list.get(0).setFilename(wbuser.getHeadimgurl());
								list.get(0).setIswbuser("ok");
							}
							request.setAttribute("wbuser", wbuser);
						}
					}
				}
				request.setAttribute("auditList", list.get(0).getAudits());//联系人跟进数据
				if(list.get(0).getFilename().contains("http:")){
					list.get(0).setIswbuser("ok");
				}
				request.setAttribute("sd", list.get(0));
			} else {
				request.setAttribute("sd", new ContactAdd());
			}

			//查询当前联系人下关联的共享用户
			Share share = new Share();
			share.setParentid(rowId);
			share.setParenttype("Contacts");
			share.setCrmId(crmId);
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			request.setAttribute("shareusers", shareAdds);
			
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("timefres", mp.get("contact_freq_list"));
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("crmId", crmId);
		// 分享控制按钮
		request.setAttribute("shareBtnContol",
				request.getParameter("shareBtnContol"));
		RedisCacheUtil.set("WK_Contacts_"+openId+"_"+rowId,DateTime.currentDateTime(DateTime.DateTimeFormat1));	//缓存最后访问时间	
		return "contact/detail";
	}
	
	/**
	 * 删除联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delContact")
	@ResponseBody
	public String deleteContact(Contact obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    String optype = request.getParameter("optype");
		String rowId = request.getParameter("rowid");
		obj.setRowid(rowId);
		obj.setOptype(optype);
		CrmError crmError  = cRMService.getSugarService().getContact2SugarService().deleteContact(obj);
		return JSONObject.fromObject(crmError).toString();
	}

	/**
	 * 添加联系人关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/get")
	public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String parentId = request.getParameter("parentId");// 关联ID
		String parentType = request.getParameter("parentType");// 关联类型
		String parentName = request.getParameter("parentName");
		String conname = request.getParameter("conname");
		String rowId = request.getParameter("rowId");
		if(null != parentName && !"".equals(parentName)){
			parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(conname)&&!StringUtils.regZh(conname)){
			conname = new String(conname.getBytes("ISO-8859-1"),"UTF-8");
		}
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String orgId = request.getParameter("orgId");
		String crmId = getNewCrmId(request);
		logger.info("ContactController get method crmId =>" + crmId);
		logger.info("ContactController get method parentId =>" + parentId);
		logger.info("ContactController get method parentType =>" + parentType);
		logger.info("ContactController get method parentName =>" + parentName);
		
		//判断crmId 是否存在
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			//关联ID 和类型
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentType", parentType);
			request.setAttribute("parentName", parentName);
			request.setAttribute("crmId", crmId);
			Map<String, Map<String, String>> lovList = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("adapting_change_list", lovList.get("adapting_change_list"));//适应能力
			request.setAttribute("plight_list", lovList.get("plight_list"));//你的处境
			request.setAttribute("contact_role_list", lovList.get("contact_role_list"));//用户角色
			//查询联系人列表
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(pagecount);
			contact.setCurrpage(currpage);
			contact.setParentId(parentId);// 关联ID
			contact.setParentType(parentType);// 关联类型
			contact.setFlag("true");
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact,
					"WEB");
			List<ContactAdd> list = cResp.getContacts();
			// 放到页面上
			if (null != list && list.size() > 0) {
				request.setAttribute("contactList", list);
			} else {
				request.setAttribute("contactList", new ArrayList<ContactAdd>());
			}
			request.setAttribute("conname", conname);
			request.setAttribute("rowId", rowId);
			request.setAttribute("orgId", orgId);
			return "oppty/addcontact";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}

	
	/**
	 * 添加联系人
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	public String add(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String orgId = request.getParameter("orgId");
		String parentType = request.getParameter("parentType");// 关联类型
		String parentId = request.getParameter("parentId");// 关联ID
		String parentName = request.getParameter("parentName");
		if(null != parentName && !"".equals(parentName)){
			parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
		}
		String flag = request.getParameter("flag");
		//查询crmId 是否存在
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ContactController get method crmId =>" + crmId);
		logger.info("ContactController get method orgId =>" + orgId);
		logger.info("ContactController get method parentId =>" + parentId);
		logger.info("ContactController get method parentType =>" + parentType);
		logger.info("ContactController get method parentName =>" + parentName);
		//error 对象
		//判断crmId是否为空
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			
			//获取用户头像数据
			WxuserInfo wxuinfo = UserUtil.getCurrUser(request);
			if(null != wxuinfo){
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//request info
		request.setAttribute("flag", flag);
		request.setAttribute("crmId", crmId);
		request.setAttribute("parentId", parentId);
		request.setAttribute("parentType", parentType);
		request.setAttribute("parentName", parentName);
		request.setAttribute("orgId", orgId);
		
		request.setAttribute("source", request.getParameter("source"));
		
		/*return "contact/add";*/
		return "contact/addForm";
	}
	
	/**
	 * 根据parentId查询联系人
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ContactController acclist method begin=>");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String parentId = request.getParameter("parentId");
		String parentType = request.getParameter("parentType");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ContactController list method currpage =>" + currpage);
		logger.info("ContactController list method pagecount =>" + pagecount);
		logger.info("ContactController list method parentId =>" + parentId);
		logger.info("ContactController list method parentType =>" + parentType);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (StringUtils.isNotNullOrEmptyStr(orgId))
		{
			crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		}
		
		logger.info("crmId:-> is =" + crmId);
		String retStr = StringUtils.isNotNullOrEmptyStr(request.getParameter("retStr")) ? request.getParameter("retStr") : "";
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(pagecount);
			contact.setCurrpage(currpage);
			contact.setParentId(parentId);// 关联ID
			contact.setParentType(parentType);// 关联类型
			contact.setOrgId(orgId);
			ContactResp cResp = new ContactResp();
			
			if (!StringUtils.isNotNullOrEmptyStr(parentId) || !StringUtils.isNotNullOrEmptyStr(parentType))
			{
				cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact, "WEB");
			}
			else
			{
				cResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact,"WEB");				
				request.setAttribute("conCount", cResp.getContacts().size());
			}
					
			List<ContactAdd> list = cResp.getContacts();
			Collections.sort(list,new Comparator<ContactAdd>(){
	            public int compare(ContactAdd arg0, ContactAdd arg1) {
	                return arg0.getConname().compareTo(arg1.getConname());
	            }
	        });
			
			//增加判断，如果是选择联系人则需要过滤掉已关联的联系人
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentType", parentType);
			String myParentId = request.getParameter("myParentId");
			String myParentType = request.getParameter("myParentType");
			if (StringUtils.isNotNullOrEmptyStr(myParentId) && StringUtils.isNotNullOrEmptyStr(myParentType))
			{
				contact.setParentId(myParentId);
				contact.setParentType(myParentType);
				ContactResp myResp = new ContactResp();
				myResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact,"WEB");
				List<ContactAdd> myList = myResp.getContacts();
				List<ContactAdd> tempList = new ArrayList<ContactAdd>();
				
				for (ContactAdd temp : myList)
				{
					for (ContactAdd con : list)
					{
						if (con.getRowid().equals(temp.getRowid()))
						{
							tempList.add(con);
							break;
						}
					}
				}
				
				if (!tempList.isEmpty())
				{
					list.removeAll(tempList);
				}
				
				//避免parenttype丢失，导致跳转不正确
				request.setAttribute("parentId", myParentId);
				request.setAttribute("parentType", myParentType);
			}
			if (StringUtils.isNotNullOrEmptyStr(request.getParameter("source")))
			{
				List<String> charList = new ArrayList<String>();
				if (null != list && list.size() > 0) 
				{
					ContactAdd con = null;
					String firstchar = null;
					for(int i=0;i<list.size();i++)
					{
						con = list.get(i);
						firstchar = ZJWKUtil.getFirstSpell(con.getConname().trim());
						if(firstchar != null && !charList.contains(firstchar))
						{
							charList.add(firstchar);
						}
						con.setFirstname(firstchar);
					}
				} 
				else 
				{
					list = new ArrayList<ContactAdd>();
				}
				
				//获取首字母集合
				//首字母排序
				Collections.sort(charList);
				 
				request.setAttribute("contactList", list);
				request.setAttribute("charList", charList);
				request.setAttribute("tabClass", request.getParameter("tabClass"));
				
				if ("Accounts".equals(parentType))
				{
					retStr = "customer/outlist";
				}
				else if ("Opportunities".equals(parentType))
				{
					retStr = "oppty/outlist";
				}
				else
				{
					retStr = request.getParameter("retStr");
				}
			}
			else
			{
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("contactList", list);
				} else {
					request.setAttribute("contactList", new ArrayList<ContactAdd>());
				}
				
				retStr = "contact/list";
			}
		}
		else
		{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("crmId", crmId);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("orgId", orgId);
		request.setAttribute("retStr", retStr);
		
		return retStr;
	}
	
	/**
	 * 查询所有的联系人
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/clist")
	public String clist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ContactController clist method begin=>");
		String currpage = request.getParameter("currpage");//得到当前页面
		String pagecount = request.getParameter("pagecount");//当前页面显示的记录
		String viewtype = request.getParameter("viewtype");
		String datetime = request.getParameter("datetime");
		String assignerid = request.getParameter("assignerid");
		String timefre = request.getParameter("timefre");
		String conname  = request.getParameter("conname");
		String phonemobile = request.getParameter("phonemobile");
		String orderString = request.getParameter("orderString");
		String contype = request.getParameter("contype");
		String contype_val = request.getParameter("contype_val");
		String tagtype = request.getParameter("tagtype");
		if(StringUtils.isNotNullOrEmptyStr(contype_val)){
			if(!StringUtils.regZh(contype_val)){
				contype_val = new String(contype_val.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		if(StringUtils.isNotNullOrEmptyStr(tagtype)){
			if(!StringUtils.regZh(tagtype)){
				tagtype = new String(tagtype.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		viewtype = (null==viewtype ? "myview":viewtype);
		logger.info("ContactController clist method currpage =>" + currpage);
		logger.info("ContactController clist method pagecount =>" + pagecount);
		logger.info("ContactController clist method viewtype =>" + viewtype);
		logger.info("ContactController clist method datetime =>" + datetime);
		logger.info("ContactController clist method assignerid =>" + assignerid);
		logger.info("ContactController clist method timefre =>" + timefre);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(null);
			contact.setCurrpage(currpage);
			contact.setViewtype(viewtype);
			contact.setTimefre(timefre);
			contact.setAssignerId(assignerid);
			contact.setDatetime(datetime);
			contact.setConname(conname);
			contact.setPhonemobile(phonemobile);
			contact.setOrderByString(orderString);
			contact.setContype(contype);
			contact.setContype_val(contype_val);
			contact.setTagtype(tagtype);
			contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
			List<ContactAdd> list = cResp.getContacts();
			// 放到页面上
			if (null != list && list.size() > 0) {
				request.setAttribute("contactList", list);
				List<String> charList = new ArrayList<String>();
				ContactAdd con = null;
				for(int i=0;i<list.size();i++){
					con = list.get(i);
					if(!charList.contains(con.getFirstname())){
						charList.add(con.getFirstname());
					}
				}
				request.setAttribute("charList", charList);
			} else {
				request.setAttribute("contactList", new ArrayList<ContactAdd>());
				request.setAttribute("charList", new ArrayList<String>());
			}
			//获取首字母集合
			
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		// requestinfo
		request.setAttribute("crmId", crmId);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtype", viewtype);
		return "contact/clist";
	}
	
	/**
	 * 分页查询
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/asyclist")
	@ResponseBody
	public String asyClist(HttpServletRequest request, HttpServletResponse response)throws Exception {
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String orgId = request.getParameter("orgId");
		String crmid = request.getParameter("crmId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		viewtype = (null==viewtype ? "myview":viewtype);
		String firstchar = request.getParameter("firstchar");
		String tagtype = request.getParameter("tagtype");
		if(StringUtils.isNotNullOrEmptyStr(tagtype)){
			if(!StringUtils.regZh(tagtype)){
				tagtype = new String(tagtype.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		logger.info("ContactController list method firstchar =>" + firstchar);
		logger.info("ContactController list method currpage =>" + currpage);
		logger.info("ContactController list method pagecount =>" + pagecount);
		logger.info("ContactController list method viewtype =>" + viewtype);
		// 绑定对象
		String crmId ="";
		if(StringUtils.isNotNullOrEmptyStr(crmid)){
			crmId = crmid;
		}else{
			 crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact contact = new Contact();
			contact.setCrmId(getNewCrmId(request));
			contact.setPagecount(pagecount);
			contact.setCurrpage(currpage);
			contact.setViewtype(viewtype);
			contact.setFirstchar(firstchar);
			contact.setOrgId(orgId);
			contact.setTagtype(tagtype);
			contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,
					"WEB");
			List<ContactAdd> list = cResp.getContacts();
			// 放到页面上
			if (null != list && list.size() > 0) {
				request.setAttribute("contactList", list);
				str = JSONArray.fromObject(list).toString();
				logger.info("str:-> is =" + str);
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtype", viewtype);
		return str;
	}
	
	/**
	 * 查询新的crmid
	 * @param request
	 * @return
	 */
	private String getNewCrmId(HttpServletRequest request) throws Exception{
		String crmId = request.getParameter("crmId");// crmIdID
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			return UserUtil.getCurrUser(request).getCrmId();
		}
		try {
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				String openId = UserUtil.getCurrUser(request).getOpenId();
				logger.info("openId = >" + openId);
				String newCrmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
					return newCrmId;
				}
			}
		} catch (Exception e) {
			logger.info("error mesg = >" + e.getMessage());
		}
		return crmId;
	}
	
	/**
	 * 关系层次结构
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/rela")
	@ResponseBody
	public String rela(HttpServletRequest request, HttpServletResponse response)throws Exception {
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String parentId = request.getParameter("parentId");
		String parentType = request.getParameter("parentType");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ContactController list method currpage =>" + currpage);
		logger.info("ContactController list method pagecount =>" + pagecount);
		logger.info("ContactController list method parentId =>" + parentId);
		logger.info("ContactController list method parentType =>" + parentType);
		logger.info("ContactController list method orgId =>" + orgId);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		crmId = getNewCrmId(request);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(pagecount);
			contact.setCurrpage(currpage);
			contact.setParentId(parentId);// 关联ID
			contact.setParentType(parentType);// 关联类型
			contact.setOrgId(orgId);
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact,"WEB");
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContactAdd> list = cResp.getContacts();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("contactList", list);
					str = JSONArray.fromObject(list).toString();
					logger.info("str:-> is =" + str);
				} else {
					request.setAttribute("contactList", new ArrayList<ContactAdd>());
					str = "[]";
				}
			}else{
				crmErr.setErrorCode(cResp.getErrcode());
				crmErr.setErrorMsg(cResp.getErrmsg());
				str = JSONObject.fromObject(crmErr).toString();
			}
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		// requestinfo
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		
		return str;
	}

	
	/**
	 * 影响力
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/effect")
	public String effect(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("ContactController acclist method begin=>");
		String rowId = request.getParameter("rowId");
		String cname = request.getParameter("cname");
		if(null != cname){
			cname = new String(cname.getBytes("ISO-8859-1"),"UTF-8");
		}

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Map<String, Map<String, String>> lovList = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("relaList", lovList.get("contact_relation_list"));//关系
			request.setAttribute("effectList", lovList.get("contact_effect_list"));//关系			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//获取用户头像数据
		Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(UserUtil.getCurrUser(request).getOpenId());
		if(null != obj1){
			WxuserInfo wxuinfo = (WxuserInfo)obj1;
			request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
		}else{
			request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
		}
		// requestinfo
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("cname", cname);
		
		return "contact/effect";
	}
	
	
	/**
	 * 影响力（异步获取）
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/relation")
	@ResponseBody
	public String relation(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String rowId = request.getParameter("rowId");

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact con = new Contact();
			con.setCrmId(crmId);
			con.setRowid(rowId);
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactRelation(con);
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContactAdd> list = cResp.getContacts();
				// 放到页面上
				if (null != list && list.size() > 0) {
					str = JSONArray.fromObject(list).toString();
					logger.info("str:-> is =" + str);
				} else {
					str = "[]";
				}
			}else{
				crmErr.setErrorCode(cResp.getErrcode());
				crmErr.setErrorMsg(cResp.getErrmsg());
				str = JSONObject.fromObject(crmErr).toString();
			}
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		
		return str;
	}
	
	
	/**
	 * 影响力（异步获取）
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/saverela")
	@ResponseBody
	public String saverela(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String rowid = request.getParameter("rowid");
		String relaid = request.getParameter("relaid");
		String relation = request.getParameter("relation");
		String effect = request.getParameter("effect");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact con = new Contact();
			con.setRowid(rowid);
			con.setRelaid(relaid);
			con.setRelation(relation);
			con.setEffect(effect);
			con.setCrmId(getNewCrmId(request));
			crmErr = cRMService.getSugarService().getContact2SugarService().addContactRelation(con);
			str = JSONObject.fromObject(crmErr).toString();
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		
		return str;
	}
	
	
	/**
	 * 修改影响力
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/updrela")
	@ResponseBody
	public String updrela(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String rowid = request.getParameter("rowid");
		String relaid = request.getParameter("relaid");
		String relation = request.getParameter("relation");
		String effect = request.getParameter("effect");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact con = new Contact();
			con.setCrmId(crmId);
			con.setRowid(rowid);
			con.setRelaid(relaid);
			con.setRelation(relation);
			con.setEffect(effect);
			crmErr = cRMService.getSugarService().getContact2SugarService().updateContectEffect(con);
			str = JSONObject.fromObject(crmErr).toString();
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		
		return str;
	}
	
	
	/**
	 * 修改影响力
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/delrela")
	@ResponseBody
	public String delrela(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String str = "";
		logger.info("ContactController acclist method begin=>");
		String rowid = request.getParameter("rowid");
		String relaid = request.getParameter("relaid");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact con = new Contact();
			con.setCrmId(crmId);
			con.setRowid(rowid);
			con.setRelaid(relaid);
			crmErr = cRMService.getSugarService().getContact2SugarService().deleteContactEffect(con);
			str = JSONObject.fromObject(crmErr).toString();
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		
		return str;
	}
	
	/**
	 * 异步查询联系人个数
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/alist")
	@ResponseBody
	public String alist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		logger.info("ContactController alist method begin=>");
		String parentId = request.getParameter("parentId");
		String parentType = request.getParameter("parentType");
		logger.info("ContactController alist method parentId =>" + parentId);
		logger.info("ContactController alist method parentType =>" + parentType);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setParentId(parentId);// 关联ID
			contact.setParentType(parentType);// 关联类型
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact,
					"WEB");
			List<ContactAdd> list = cResp.getContacts();
			if(list!=null&&list.size()>0){
				crmErr.setErrorCode(ErrCode.ERR_CODE_0);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
				crmErr.setRowCount(list.size() + "");
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString(); 
	}
	
	/**
	 * 修改联系信息
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/update")
	@ResponseBody
	public String update(HttpServletRequest request,HttpServletResponse response) throws Exception{
		logger.info("ContactController alist method begin=>");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String parentId = request.getParameter("parentId");
		String parentType = request.getParameter("parentType");
		String plight = request.getParameter("plight");
		String roles = request.getParameter("roles");
		String adapting = request.getParameter("adapting");
		String rowid = request.getParameter("rowid");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ContactController alist method currpage =>" + currpage);
		logger.info("ContactController alist method pagecount =>" + pagecount);
		logger.info("ContactController alist method parentId =>" + parentId);
		logger.info("ContactController alist method parentType =>" + parentType);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		//错误对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(pagecount);
			contact.setCurrpage(currpage);
			contact.setParentId(parentId);// 关联ID
			contact.setParentType(parentType);// 关联类型
			contact.setAdapting(adapting);
			contact.setPlight(plight);
			contact.setRoles(roles);
			contact.setRowid(rowid);
			crmErr = cRMService.getSugarService().getContact2SugarService().updateContactById(contact);
			str = JSONObject.fromObject(crmErr).toString();
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		return str;
	}
	
	/**
	 * 删除联系人(只是删除业务机会或者客户的关联关系)
	 * @return
	 */
	@RequestMapping("/del")
	public String delContact(Contact contact,HttpServletRequest request,HttpServletResponse response) throws Exception{
		String parentId = contact.getParentId();
		String parentType = contact.getParentType();
		String crmId = request.getParameter("crmId");
		if (null != crmId && !"".equals(crmId)) {
			contact.setCrmId(crmId);
			CrmError crmErr = cRMService.getSugarService().getContact2SugarService().delContact(contact);
			
			if(ErrCode.ERR_CODE_0.equals(crmErr.getErrorCode())){
				request.setAttribute("parentId", parentId);
				request.setAttribute("parentType", parentType);
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		if(contact.getParentType().equals("Accounts")){
			return "redirect:/customer/detail?rowId="+parentId;
		}else if(contact.getParentType().equals("Opportunities")){
			return "redirect:/oppty/detail?rowId="+parentId;
		}else{
			return "redirect:/contact/list?parentType="+parentType+"&parentId="+parentId;
		}
	}
	
	
	/**
	 * 修改联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/updatec")
	public String update(Contact obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String crmId =obj.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
			obj.setCrmId(crmId);
			obj.setRowid(rowId);
			CrmError crmErr = cRMService.getSugarService().getContact2SugarService().updateContact(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/contact/modify?rowId=" + rowId+"&orgId="+obj.getOrgId();
	}
	
	/**
	 * 分配客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/allocation")
	public String allocation(Contact obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String crmId = obj.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
			obj.setOptype("allot");
			CrmError crmErr = cRMService.getSugarService().getContact2SugarService().updateContact(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignerId() && !obj.getCrmId().equals(obj.getAssignerId())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerId(),UserUtil.getCurrUser(request).getName()+" 分配了一个客户【"+obj.getConname()+"】给您", "contact/detail?rowId="+rowId+"&orgId="+obj.getOrgId());
				}
				//
				
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/contact/detail?rowId=" + rowId+"&orgId="+obj.getOrgId();
	}
	
	/**
	 * 生成二维码
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/make")
	public String make(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		logger.info("ContactController detail method begin=>");
		String rowId = request.getParameter("rowId");
		logger.info("ContactController detail method rowId =>" + rowId);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		String path = request.getSession().getServletContext().getRealPath("cache/");
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ContactResp sResp = cRMService.getSugarService().getContact2SugarService().getContactSingle(rowId,
					crmId);
			List<ContactAdd> list = sResp.getContacts();
			if(list!=null&&list.size()>0){
				ContactAdd contactAdd = list.get(0);
				request.setAttribute("conname", contactAdd.getConname());
				String filename = QRCodeUtil.encode(UserUtil.getCurrUser(request).getOpenId(),contactAdd.toVCARDString(), null, true,path);
				if("0".equals(filename)){
					throw new Exception("生成二维码图片失败,请联系管理员!");
				}else{
					if(!StringUtils.isNotNullOrEmptyStr(contactAdd.getFilename())){
						contactAdd.setFilename("");
					}
					request.setAttribute("filename", filename);
					request.setAttribute("contactAdd", contactAdd);
				}
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "contact/msg";
	}
	
	/**
	 * 导入联系人 CSV或vcf
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/impuser")
	public String importcontact(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		
		return "contact/import";
	}
	
	
	/**
	 * 上传后导入联系人
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/uploaduser")
	@ResponseBody
	public String uploaduser(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		logger.info("ContactController uploaduser begin =>");
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;     
        //获得文件：     
        final MultipartFile file = multipartRequest.getFile("uploadFile");
        
        if(file!=null&&file.getSize()>0){
        	//获取用户默认组织的crmid
        	final WxuserInfo wxuser = UserUtil.getCurrUser(request);
        	final String crmId = cRMService.getSugarService().getContact2SugarService().getCrmIdByOrgId(wxuser.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
        	logger.info("ContactController upload method fileName=" + file.getOriginalFilename());
	        try{
	        	InputStream is = file.getInputStream();
	        	InputStreamReader isr = new InputStreamReader(is,"gb2312");
	        	BufferedReader br=new BufferedReader(isr); 
	        	String line;
	        	

	        	final List<Contact> succConList = new ArrayList<Contact>();
	        	final List<Contact> errConList = new ArrayList<Contact>();
	        	final List<Contact> repeatConList = new ArrayList<Contact>();
	        	
	        	int rowCount = 0;
	        	
	        	boolean isValidate = true;
	        	
	        	final List<Thread> threads = new java.util.concurrent.CopyOnWriteArrayList<Thread>();
	        	
	        	while ( (line = br.readLine()) != null ) {
	        		rowCount ++;
	        		//首行不处理
	        		if(rowCount <= 1){
	        			continue;
	        		}
	        		
	        		if(!StringUtils.isNotNullOrEmptyStr(line.trim())){
	        			continue;
	        		}
	        		logger.info("line =>" + line);
	        		final String[] info = line.split(",",17);
	        		
	        		//验证格式
	        		if(null == info || info.length != 17){
	        			isValidate = false;
	        			break;
	        		}
	        		
	        		Thread thread = new Thread(){
	        			public void run(){
	        				try{
		    	        		Contact con =  new Contact();
		    	        		if(info.length >=1 && StringUtils.isNotNullOrEmptyStr(info[0])){
		    	        			if(!StringUtils.regZh(info[0])){
		    	        				con.setConname(new String(info[0].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				con.setConname(info[0]);
		    	        			}
		    	        		}
		    	        		if(info.length >=2 && StringUtils.isNotNullOrEmptyStr(info[1])){
		    	        			if(!StringUtils.regZh(info[1])){
		    	        				con.setCompanyname(new String(info[1].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				con.setCompanyname(info[1]);
		    	        			}
		    	        		}
		    	        		if(info.length >=3 && StringUtils.isNotNullOrEmptyStr(info[2])){
		    	        			con.setPhonemobile(info[2]);
		    	        		}
		    	        		if(info.length >=4 && StringUtils.isNotNullOrEmptyStr(info[3])){
		    	        			if(!StringUtils.regZh(info[3])){
		    	        				con.setConjob(new String(info[3].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				con.setConjob(info[3]);
		    	        			}
		    	        		}
		    	        		if(info.length >=5 && StringUtils.isNotNullOrEmptyStr(info[4])){
		    	        			if(!StringUtils.regZh(info[4])){
		    	        				con.setPhonework(new String(info[4].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				con.setPhonework(info[4]);
		    	        			}
		    	        		}
		    	        		if(info.length >=6 && StringUtils.isNotNullOrEmptyStr(info[5])){
		    	        			con.setEmail0(info[5]);
		    	        		}
		    	        		if(info.length >=7 && StringUtils.isNotNullOrEmptyStr(info[6])){
		    	        			if(!StringUtils.regZh(info[6])){
		    	        				con.setConaddress(new String(info[6].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				con.setConaddress(info[6]);
		    	        			}
		    	        		}
		    	        		
		    	        		
		    	        		if(!StringUtils.isNotNullOrEmptyStr(con.getConname())){
		    	        			errConList.add(con);
		    	        			return;
		    	        		}
		    	        		
		    	        		//保存联系人
		    	        		con.setBatchno(file.getOriginalFilename());
		    	        		con.setCrmId(crmId);
		    	        		con.setOrgId(Constants.DEFAULT_ORGANIZATION);
		    	        		con.setAssignerId(crmId);
		    	        		
		    	        		CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(con);
		    	        		String rowId = crmErr.getRowId();
		    	        		if(!StringUtils.isNotNullOrEmptyStr(rowId)){
		    	        			if("100008".equals(crmErr.getErrorCode())){
		    	        				repeatConList.add(con);
		    	        			}else{
		    	        				con.setEffect(crmErr.getErrorMsg());
		    	        				errConList.add(con);
		    	        			}
		    	        			return;
		    	        		}
		    	        		
		    	        		succConList.add(con);
		    	        		
		    	        		List<String> grpList = new ArrayList<String>();
		    	        		
		    	        		for(int j=7;j<info.length;j++){
		    	        			if(!StringUtils.isNotNullOrEmptyStr(info[j])){
		    	        				continue;
		    	        			}
		    	        			if(!StringUtils.regZh(info[j])){
		    	        				grpList.add(new String(info[j].getBytes("ISO-8859-1"),"UTF-8"));
		    	        			}else{
		    	        				grpList.add(info[j]);
		    	        			}
		    	        		}
		    	        		
		    	        		if(grpList.size() >0){
		    	        			List<Tag> tagList = new ArrayList<Tag>();
		    	        			Tag tag = null;
		    	        			for(int k=0;k<grpList.size();k++){
		    	        				tag = new Tag();
		    	        				tag.setId(Get32Primarykey.getRandom32PK());
		    	        				tag.setModelId(rowId);
		    	        				tag.setTagName(grpList.get(k));
		    	        				tag.setCreateBy(wxuser.getParty_row_id());
		    	        				tag.setOpenId(wxuser.getOpenId());
		    	        				tag.setModelType("Contacts");
		    	        				tagList.add(tag);
		    	        			}
		    	        			//批量增加标签
		    	        			cRMService.getDbService().getModelTagService().batchAddObj(tagList);
		    	        		}
	        				}catch(Exception ec){
	        					ec.printStackTrace();
	        				}finally{
	        					threads.remove(this);
	        				}
	    	        		
	        			}
	        			
	        		};
					threads.add(thread);
	        		thread.start();
	        		while(threads.size()>5){
	        			Thread.sleep(10);
	        		}
	        		
	        	}
        		while(threads.size()>0){
        			Thread.sleep(10);
        		}
	        	
	        	if(!isValidate){
	        		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(wxuser.getOpenId(), "指尖微客导入通知：\r\n 您选择导入的文件【"+file.getOriginalFilename()+"】格式不正确，请选用模板导入，谢谢！", "");
	        		return "success";
	        	}
	        	
	        	if(succConList.size() ==0 && errConList.size() == 0 && repeatConList.size() ==0){
	        		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(wxuser.getOpenId(), "指尖微客导入通知：\r\n 本次导入的文件【"+file.getOriginalFilename()+"】内容为空，请检查！", "");
	        		return "success";
	        	}
	        	
	        	//导入完成后写入通知
	        	if(StringUtils.isNotNullOrEmptyStr(wxuser.getEmail())){
	        		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(wxuser.getOpenId(), "指尖微客导入通知：\r\n 小薇本次为您成功导入"+succConList.size()+"人，失败"+(errConList.size()+repeatConList.size())+"人，导入结果已发送到您的邮箱（"+wxuser.getEmail()+"），请查看！", "");
	        		//导入完成后，发送邮件
	        		//生成CSV文件
	    			File f = reportConlistToCSV(succConList, errConList,repeatConList);
	    			//发送邮件
	    			sendEmail(wxuser.getEmail(), f, wxuser.getNickname(),succConList.size(),errConList.size()+repeatConList.size(),file.getOriginalFilename());
	        	}else{
	        		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(wxuser.getOpenId(), "指尖微客导入通知：\r\n 小薇本次为您成功导入"+succConList.size()+"人，失败"+(errConList.size()+repeatConList.size())+"人。", "");
	        		
	        	}
	        	
	        	//写入通知
	        	Messages msg = new Messages();
	        	msg.setUserId("-1");
	        	msg.setUsername("小薇");
	        	msg.setId(Get32Primarykey.getRandom32PK());
	        	msg.setTargetUId(wxuser.getParty_row_id());
	        	msg.setTargetUName(wxuser.getNickname());
	        	msg.setContent("成功导入"+succConList.size()+"人，失败"+(errConList.size()+repeatConList.size())+"人，具体请查看邮件");
	        	msg.setMsgType("txt");
	        	msg.setRelaModule(Constants.MESSAGE_MODULE_TYPE_BATCH_IMP_CONTACTS);
	        	msg.setReadFlag("N");
	        	cRMService.getDbService().getMessagesService().addObj(msg);
	        	
	        	return "success";
	        	
	        }catch(Exception ex){
	        	logger.info("ContactController upload method -3 上传失败！" + ex.toString());
	        	return "fail";
	        }
        }else{
        	logger.info("ContactController upload method -4 上传失败！");
        	return "fail";
        }
	}
	
	/**
	 * 导入完成后，发送邮件
	 * @param succList
	 * @param errList
	 * @param filename
	 * @return
	 */
	private File reportConlistToCSV(List<Contact> succList,List<Contact> errList,List<Contact> repeatList)
	{
		try 
		{
			File f = new File("test.xls");
			if(!f.exists())
			{
				f.createNewFile();
			}
			FileOutputStream os = new FileOutputStream(f);
			 //创建工作薄
			WritableWorkbook workbook = Workbook.createWorkbook(os);
			//创建新的一页
			WritableSheet sheet = workbook.createSheet("联系人",0);
			sheet.setColumnView(0, 20);
			sheet.setColumnView(1, 20);
			sheet.setColumnView(2, 20);
			sheet.setColumnView(3, 20);
			
			//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
			Label nametxt = new Label(0, 0, "姓名");
			nametxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(nametxt);
			
			Label mobiletxt = new Label(1, 0, "手机");
			mobiletxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(mobiletxt);
			
			Label companytxt = new Label(2, 0, "公司名称");
			companytxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(companytxt);
			
			Label positiontxt = new Label(3, 0, "职位");
			positiontxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(positiontxt);
			
			Label phoneworktxt = new Label(4,0,"固定电话");
			phoneworktxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(phoneworktxt);
			
			Label emailtxt = new Label(5,0,"邮箱");
			emailtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(emailtxt);
			
			Label addrtxt = new Label(6,0,"地址");
			addrtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(addrtxt);
			
			Label resulttxt = new Label(7,0,"导入结果");
			resulttxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(resulttxt);
			
			sheet.setRowView(1, 500);
			
			Contact ca = null;
			for(int i=0;i<succList.size();i++)
			{
				ca = succList.get(i);
				
				Label name = new Label(0, i+1,ca.getConname());
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(name);
				
				Label mobile = new Label(1, i+1,ca.getPhonemobile());
				mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(mobile);
				
				Label company = new Label(2, i+1,ca.getAccountname());
				company.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(company);
				
				Label position = new Label(3,i+1,ca.getConjob());
				position.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(position);
				
				Label phonework = new Label(4,i+1,ca.getPhonework());
				phonework.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(phonework);
				
				Label email = new Label(5,i+1,ca.getEmail0());
				email.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(email);
				
				Label addr = new Label(6,i+1,ca.getConaddress());
				addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(addr);
				
				Label result = new Label(7,i+1,"成功");
				result.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(result);

				sheet.setRowView(1, 500);
			}
			
			int len = succList.size();
			
			for(int i=0;i<errList.size();i++)
			{
				ca = errList.get(i);
				
				Label name = new Label(0, i+len+1,ca.getConname());
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(name);
				
				Label mobile = new Label(1, i+len+1,ca.getPhonemobile());
				mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(mobile);
				
				Label company = new Label(2, i+len+1,ca.getAccountname());
				company.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(company);
				
				Label position = new Label(3,i+len+1,ca.getConjob());
				position.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(position);
				
				Label phonework = new Label(4,i+len+1,ca.getPhonework());
				phonework.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(phonework);
				
				Label email = new Label(5,i+len+1,ca.getEmail0());
				email.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(email);
				
				Label addr = new Label(6,i+len+1,ca.getConaddress());
				addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(addr);
				
				Label result = new Label(7,i+len+1,"导入失败" + (!StringUtils.isNotNullOrEmptyStr(ca.getEffect()) ? "" : "："+ca.getEffect()));
				result.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(result);

				sheet.setRowView(1, 500);
			}
			
			len = succList.size() + errList.size();
			for(int i=0;i<repeatList.size();i++)
			{
				ca = repeatList.get(i);
				
				Label name = new Label(0, i+len+1,ca.getConname());
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(name);
				
				Label mobile = new Label(1, i+len+1,ca.getPhonemobile());
				mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(mobile);
				
				Label company = new Label(2, i+len+1,ca.getAccountname());
				company.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(company);
				
				Label position = new Label(3,i+len+1,ca.getConjob());
				position.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(position);
				
				Label phonework = new Label(4,i+len+1,ca.getPhonework());
				phonework.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(phonework);
				
				Label email = new Label(5,i+len+1,ca.getEmail0());
				email.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(email);
				
				Label addr = new Label(6,i+len+1,ca.getConaddress());
				addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(addr);
				
				Label result = new Label(7,i+len+1,"数据重复");
				result.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(result);

				sheet.setRowView(1, 500);
			}
			
			//把创建的内容写入到输出流中，并关闭输出流
			workbook.write();
			workbook.close();
			os.close();
			
			//返回数据
	        return f;
	        
		} catch (Exception e) 
		{
			return null;
		}
	}
	
	/**
	 * 发送邮件
	 * @param startDate
	 * @param email
	 * @param assigner
	 * @param approvename
	 * @param wdays
	 * @param filePath
	 */
	private void sendEmail(String email,File f,String username,int conSize,int errConSize,String filename)
	{
		SenderInfor senderInfor = new SenderInfor();
        StringBuffer content = new StringBuffer();  
        content.append("亲爱的").append(username).append("，您好！").append("<br/>").append("小薇本次成功导入").append(conSize).append("人，失败").append(errConSize).append("人，感谢您的使用！");
        senderInfor.setToEmails(email);  
        senderInfor.setSubject("【"+filename+"】导入结果");  
        senderInfor.setContent(content.toString());
        Map<String, String> m = new HashMap<String, String>();
        m.put(filename + ".xls", f.getAbsolutePath());
        senderInfor.setAttachments(m);
        MailUtils.sendEmail(senderInfor);
        
        f.delete();
	}
	
	/**
	 * 设置格式
	 * @return
	 */
	private WritableCellFormat getCellFormat(Colour color, Alignment posi ,Integer size)
	{
		try 
		{
			//设置字体;  
			WritableFont font1 = new WritableFont(WritableFont.createFont("微软雅黑"), size, WritableFont.NO_BOLD);
			//WritableFont font1 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.RED);  

			WritableCellFormat cellFormat1 = new WritableCellFormat(font1);  
			//设置背景颜色;  
			//cellFormat1.setBackground(color); 
			//设置自动换行;  
			cellFormat1.setWrap(true);  
			//设置文字居中对齐方式;  
			cellFormat1.setAlignment(posi);  
			//设置垂直居中;  
			cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);
			
			return cellFormat1;
		}
		catch (WriteException e) 
		{
			logger.info(e.getMessage());
			return null;
		} 
	}
}
