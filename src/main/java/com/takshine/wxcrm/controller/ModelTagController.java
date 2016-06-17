package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.model.PrintModel;

/**
 * 模块与标签关联
 * 
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/modelTag")
public class ModelTagController {
	// 日志
	protected static Logger log = Logger.getLogger(ModelTagController.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	/**
	 * 查询  标签
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	@ResponseBody
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("tag start = > ");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String rst = "";
		if(null == crmId || "".equals(crmId)){
			rst = "-1";
		}else{
			String modelId = request.getParameter("modelId");
			String modelType = request.getParameter("modelType");
			Tag mt = new Tag();
			mt.setModelId(modelId);
			if(StringUtils.isNotNullOrEmptyStr(modelType)){
			mt.setModelType(modelType);
			}
			List<Tag> tagList = cRMService.getDbService().getTagModelService().findTagListByModelId(mt);
			if(null != tagList && tagList.size() > 0){
				rst = JSONArray.fromObject(tagList).toString();
			}
		}
		return rst;
	}
	
	/**
	 * 查询  标签
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("tag start = > ");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String rst = "";
		if(null == crmId || "".equals(crmId)){
			rst = "-1";
		}else{
			String modelId = request.getParameter("modelId");
			String modelType = request.getParameter("modelType");
			Tag mt = new Tag();
			mt.setModelId(modelId);
			mt.setModelType(modelType);
			List<Tag> tagList = cRMService.getDbService().getTagModelService().findTagListByModelId(mt);
			if(null != tagList && tagList.size() > 0){
				rst = JSONArray.fromObject(tagList).toString();
			}
		}
		return rst;
	}
	
	/**
	 * 保存标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("modelTagController save  =>");
		
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(null == user){
			return "fail";
		}
		
		String modelId = request.getParameter("modelId"); modelId = (modelId == null) ? "" : modelId;
		String tagName = request.getParameter("tagName");tagName = (tagName == null) ? "" : tagName;
		String modelType = request.getParameter("modelType");modelType = (modelType == null) ? "":modelType;
		log.info("modelid = >" + modelId);
		log.info("tagName  = >" + tagName);
		if (!StringUtils.regZh(tagName))
		{
			tagName = new String(tagName.getBytes("iso-8859-1"),"utf-8");
		}
		
		Tag tag = new Tag();
		tag.setModelId(modelId);
		tag.setModelType(modelType);
		tag.setTagName(tagName);
		tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		tag.setId(Get32Primarykey.getRandom32PK());
		tag.setCreateBy(user.getParty_row_id());
		cRMService.getDbService().getTagModelService().saveTag(tag);
		
		return "success";
	}
	/**
	 * 保存标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/add")
	@ResponseBody
	public String add(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("modelTagController add  =>");
		CrmError crmErr = new CrmError();
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(null == user){
			crmErr.setErrorCode("fail");
			return JSONObject.fromObject(crmErr).toString();
		}
		
		String modelId = request.getParameter("modelId"); modelId = (modelId == null) ? "" : modelId;
		String tagName = request.getParameter("tagName");tagName = (tagName == null) ? "" : tagName;
		String modelType = request.getParameter("modelType");modelType = (modelType == null) ? "":modelType;
		log.info("modelid = >" + modelId);
		log.info("tagName  = >" + tagName);
		
		if (!StringUtils.regZh(tagName))
		{
			tagName = new String(tagName.getBytes("iso-8859-1"),"utf-8");
		}
		Tag tag = new Tag();
		tag.setModelId(modelId);
		tag.setModelType(modelType);
		tag.setTagName(tagName);
		tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		tag.setId(Get32Primarykey.getRandom32PK());
		tag.setCreateBy(user.getParty_row_id());
		cRMService.getDbService().getTagModelService().saveTag(tag);
		crmErr.setErrorCode("success");
		crmErr.setRowId(tag.getId());
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 删除标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("tagModelController delete  =>");
		WxuserInfo user=UserUtil.getCurrUser(request);
	    if(user==null){
	    	//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    String id=request.getParameter("id");
		log.info("rowId = >" + id);
		cRMService.getDbService().getTagModelService().deleteById(id);
		return "success";
	}
	
	/**
	 * 删除标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delTag")
	@ResponseBody
	public String delTag(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("tagModelController delete  =>");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		if(null == crmId || "".equals(crmId)){
			return "fail";
		}
		String tagName =request.getParameter("tagName"); tagName = (tagName == null ) ? "" : tagName;
		String modelId = request.getParameter("modelId"); modelId = (modelId == null) ? "" : modelId;
		String modelType = request.getParameter("modelType");modelType = (modelType == null) ? "":modelType;
		log.info("modelid = >" + modelId);
		
		Tag tag = new Tag();
		tag.setModelId(modelId);
		tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		tag.setModelType(modelType);
		tag.setTagName(tagName);
		boolean rst = cRMService.getDbService().getTagModelService().delStar(tag);
		if(!rst){
			return "fail";
		}
		return "success";
	}
	
	/**
	 *  按标签查询相应客户的列表 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customerList")
	@ResponseBody
	public String customerList(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("modelList start = > ");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String rst = "";
		if(null == crmId || "".equals(crmId)){
			rst = "-1";
		}else{
			String modelId = request.getParameter("modelId");
			String modelType = request.getParameter("modelType");
			Tag  tag = new Tag();
			tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			tag.setModelType(modelType);
			tag.setModelId(modelId);
			List<Customer> customerList = cRMService.getDbService().getTagModelService().findCustomerListByTag(tag);
			if(null != customerList && customerList.size() > 0){
				rst = JSONArray.fromObject(customerList).toString();
			}
		}
		return rst;
	}
	
	/**
	 *  按标签查询相应商机的列表 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/opptyList")
	@ResponseBody
	public String opptyList(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("modelList start = > ");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String rst = "";
		if(null == crmId || "".equals(crmId)){
			rst = "-1";
		}else{
			String modelId = request.getParameter("modelId");
			String modelType = request.getParameter("modelType");
			Tag  tag = new Tag();
			tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			tag.setModelType(modelType);
			tag.setModelId(modelId);
			List<Opportunity> opptyList = cRMService.getDbService().getTagModelService().findOpptyListByTag(tag);
			if(null != opptyList && opptyList.size() > 0){
				rst = JSONArray.fromObject(opptyList).toString();
			}
		}
		return rst;
	}
	
	
	/**
	 *  按标签查询相应联系人的列表 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/contactList")
	@ResponseBody
	public String contactList(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("contactList  start = > ");
		String tagName = request.getParameter("tagName");
		String modelType = request.getParameter("modelType");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String rst = "";
		if(null == crmId || "".equals(crmId)){
			rst = "-1";
		}else{
			Tag  tag = new Tag();
			tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			tag.setModelType(modelType);
			tag.setTagName(tagName);
			List<Contact> contactList = cRMService.getDbService().getTagModelService().findContactListByTag(tag);
			if(null != contactList && contactList.size() > 0){
				rst = JSONArray.fromObject(contactList).toString();
			}
		}
		return rst;
	}
	
	
	/**
     * 
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/taglist")
	public String getTagList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);
	    if(user==null){
	    	//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    Tag tag = new Tag();
	    tag.setCreateBy(user.getParty_row_id());
	    tag.setModelId(user.getParty_row_id());
	    List<Tag> mylist= cRMService.getDbService().getModelTagService().getTagListByMy(tag);
	    List<Tag> otherlist=cRMService.getDbService().getModelTagService().getTagListByOther(tag);
	    PrintModel pm = new PrintModel();
	    pm.setOperativeid(user.getParty_row_id());
	    pm.setObjecttype("TAG");
	    List<Print> printlist=cRMService.getDbService().getPrintService().getListAboutMy(pm);
	    request.setAttribute("myTagList", mylist);
	    request.setAttribute("otherTagList", otherlist);
	    request.setAttribute("printList", printlist);
	    request.setAttribute("user", user);
		return "perslInfo/taglist";
	}
}
