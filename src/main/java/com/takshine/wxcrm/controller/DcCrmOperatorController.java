package com.takshine.wxcrm.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.FTPUtil;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.InvokeUtil;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.QRCodeUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.error.CrmError;

/**
 * crm用户控制器
 * 
 * 
 */
@Controller
@RequestMapping("/dcCrm")
public class DcCrmOperatorController {

	// 日志
	protected static Logger logger = Logger
			.getLogger(DcCrmOperatorController.class.getName());
	

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 根据crmId查询一个CRM用户信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			List<DcCrmOperator> list = (List<DcCrmOperator>) cRMService.getDbService().getDcCrmOperatorService().findDcCrmOperatorListByFilter(crmId);
			DcCrmOperator dcCrmOperator = list.get(0);
			if(!StringUtils.isNotNullOrEmptyStr(dcCrmOperator.getOpImage())){
				dcCrmOperator.setOpImage("");
			}
			if(null == list || list.size() ==0){
				request.setAttribute("operator", new DcCrmOperator());
			}else{
				request.setAttribute("operator",dcCrmOperator );
			}
			request.setAttribute("crmId", crmId);
			
		} else {
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		// 获取用户头像数据
		Object obj = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
		WxuserInfo wxuinfo = null;
		if (null != obj) {
			wxuinfo = (WxuserInfo) obj;
		}
		if (null == obj || null == wxuinfo || null == wxuinfo.getHeadimgurl() || null == wxuinfo.getNickname()) {
			wxuinfo = new WxuserInfo();
			wxuinfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			wxuinfo.setNickname("");
		}
		request.setAttribute("wxuser", wxuinfo);
		
		//指尖人脉信息
		WxuserInfo wxUser = new WxuserInfo();
		wxUser.setOpenId(openId);
		Object rstwxUser = cRMService.getWxService().getWxUserinfoService().findObj(wxUser);
		if(rstwxUser != null){
			wxUser = (WxuserInfo)rstwxUser;
			String party_row_id = wxUser.getParty_row_id();
			logger.info("party_row_id = >" + party_row_id);
			if(null == party_row_id || "".equals(party_row_id)) party_row_id = "-1";
			request.setAttribute("party_row_id", party_row_id);
			//指尖人脉地址信息
			request.setAttribute("zjrm_url", PropertiesUtil.getAppContext("zjrm.url"));
		}

		return "perslInfo/list";
	}
	
	/**
	 * 查询单个CRM用户信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ZJWKUtil.getRequestURL(request);//获取请求的url
		String partyId = request.getParameter("partyId");
		String relaPartyId = request.getParameter("relaPartyId");
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String flag = request.getParameter("flag");
		String crmId = null != request.getParameter("crmId") ? request.getParameter("crmId") : UserUtil.getCurrUser(request).getCrmId();
		//从分享或人脉 进来的
		boolean isfriend = true;
		boolean isMy = true;
		logger.info("---------------1.---------------------flag===="+flag);
		if(StringUtils.isNotNullOrEmptyStr(flag)){
			crmId = request.getParameter("rowId");
			UserRela ur = new UserRela();
			ur.setUser_id(partyId);
			ur.setRela_user_id(relaPartyId);
			DcCrmOperator relaDc = cRMService.getDbService().getDcCrmOperatorService().findDcCrmOperatorByPartyId(ur.getRela_user_id());
			if(StringUtils.isNotNullOrEmptyStr(relaDc.getOpName())){
				ur.setRela_user_name(relaDc.getOpName());
			}else{
				WxuserInfo tmp = new WxuserInfo();
				tmp.setParty_row_id(ur.getRela_user_id());
				tmp = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(tmp);
				ur.setRela_user_name(tmp.getNickname());
			}
			request.setAttribute("userRela", ur);
			//将查看人的基本信息传递到页面 add by zhihe
			request.setAttribute("looker", relaDc);
			//判断是否是好友
			isfriend = cRMService.getDbService().getUserRelaService().isFriendsByPartyId(ur);
			logger.info("---------------2.---------------------isfriend===="+isfriend);
			//如果是从脉过来的
			if("RM".equals(flag)){
				if(!isfriend){
					request.setAttribute("isfriend", isfriend);
					isMy = false;
				}
			}else if("Change".equals(flag)){
				if(!isfriend){
					request.setAttribute("changecardflag", "true");
					isMy = false;
				}
			}
			else if ("group".equals(flag))
			{
				if(!isfriend)
				{
					request.setAttribute("changecardflag", "false");
				}
			}
		}
		
		request.setAttribute("partyId", partyId);
		request.setAttribute("flag", flag);
		request.setAttribute("crmId", crmId);
		//判断是否为自己查看信息
		request.setAttribute("isMy", isMy);
		
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			//获取CRM用户信息
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			
			List<DcCrmOperator> list = (List<DcCrmOperator>) cRMService.getDbService().getDcCrmOperatorService()
					.findDcCrmOperatorListByFilter(crmId);
			DcCrmOperator dc = null;
			if(list!=null&&list.size()>0){
				dc = list.get(0);
				if(!StringUtils.isNotNullOrEmptyStr(dc.getOpMobile())){
					dc.setOpMobile("");
				}
			}
			request.setAttribute("dc", dc);

			// 获取用户头像数据
			WxuserInfo querywx = new WxuserInfo();
			querywx.setParty_row_id(partyId);
			Object obj = cRMService.getWxService().getWxUserinfoService().findObj(querywx);
			WxuserInfo wxuinfo = null;
			if (null != obj) {
				wxuinfo = (WxuserInfo) obj;
			}
			if (null == obj || null == wxuinfo || null == wxuinfo.getHeadimgurl() || null == wxuinfo.getNickname()) {
				wxuinfo = new WxuserInfo();
				wxuinfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") + "/image/defailt_person.png");
				wxuinfo.setNickname("");
			}
			request.setAttribute("wxuser", wxuinfo);

			//指尖人脉信息
//			WxuserInfo wxUser = new WxuserInfo();
//			wxUser.setOpenId(openId);
//			Object rstwxUser = cRMService.getWxService().getWxUserinfoService().findObj(wxUser);
//			if(rstwxUser != null){
//				wxUser = (WxuserInfo)rstwxUser;
//				String party_row_id = wxUser.getParty_row_id();
				/*String party_row_id = request.getParameter("partyId");
				if(!StringUtils.isNotNullOrEmptyStr(party_row_id)){
					WxuserInfo wxUser = new WxuserInfo();
					wxUser.setOpenId(openId);
					party_row_id = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId).getParty_row_id();
				}*/
//				logger.info("party_row_id = >" + party_row_id);
//				if(null == party_row_id || "".equals(party_row_id)) party_row_id = "-1";
				request.setAttribute("party_row_id", partyId);
				//指尖人脉地址信息
				request.setAttribute("zjrm_url", PropertiesUtil.getAppContext("zjrm.url"));
				
				//获取标签
				String url = PropertiesUtil.getAppContext("zjrm.url")+"/out/user/getTags/"+partyId;
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
				List<Tag> tagList = new ArrayList<Tag>();
				if(StringUtils.isNotNullOrEmptyStr(rst)){
					//解析JSON数据
					JSONArray jArr = JSONArray.fromObject(rst);
					JSONObject jObj = null;
					Tag tag = null;
					for(int i=0;i<jArr.size();i++){
						jObj = jArr.getJSONObject(i);
						tag = new Tag();
						tag.setId(jObj.getString("id"));
						tag.setTagName(jObj.getString("name"));
						tagList.add(tag);
					}
				}
				request.setAttribute("tagList", tagList);
				
				//用户群加入申请 的前面 是否是提交给自己审批 spm编码
//				String atten_openid = request.getParameter("atten_openid");
//				logger.info("atten_openid = >" + atten_openid);
//				WxuserInfo atwx = new WxuserInfo();
//				atwx.setOpenId(atten_openid);
//				Object atwxrst = cRMService.getWxService().getWxUserinfoService().findObj(atwx);
//				if(atwxrst != null){
//					atwx = (WxuserInfo)atwxrst;
//					String at_party_row_id = atwx.getParty_row_id();
//					logger.info("at_party_row_id = >" + at_party_row_id);
//					request.setAttribute("at_party_row_id", at_party_row_id);
//				}
				request.setAttribute("at_party_row_id", relaPartyId);
				String spm = request.getParameter("spm");
				String group_id = request.getParameter("group_id");
				if (StringUtils.isNotNullOrEmptyStr(group_id)
						&& Constants.SPM_CODE_GROUP_JOIN.equals(spm)) {
					request.setAttribute("group_id", group_id);//提交给自己审核
					request.setAttribute("btnFlag", "approval_group");//提交给自己审核
					String isInGroupFlag = InvokeUtil.isInGroup(group_id, partyId);
					logger.info("isInGroupFlag = >" + isInGroupFlag);
					request.setAttribute("isInGroupFlag", isInGroupFlag);//是否是群里面的标志
				}
//			}
			
		} else {
			//抛出异常
			/*throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);*/
			WxuserInfo wx = new WxuserInfo();
			wx.setParty_row_id(relaPartyId);
			Object wxobj = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wx);
			if(wxobj != null){
				logger.info("wxobj = >" + wxobj);
				request.setAttribute("bindedFlag", "true");
				request.setAttribute("openId", ((WxuserInfo)wxobj).getOpenId());
			}else{
				request.setAttribute("bindedFlag", "false");
			}
			
			return "perslInfo/detailRet";
		}
		
		//调用生成二维码
		request.setAttribute("makeFlag", true);
		request.setAttribute("friendFlag", isfriend);
		this.make(request, response);
		//end
		
		return "perslInfo/detail";
	}
	
	/**
	 * 申请交换名片
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/changecard")
	@ResponseBody
	public String changecard(Messages msg, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("changecard  = > ");
		
		if(StringUtils.isNotNullOrEmptyStr(msg.getContent())){
			msg.setContent(new String(msg.getContent().getBytes("ISO-8859-1"),"UTF-8"));
		}
		if(StringUtils.isNotNullOrEmptyStr(msg.getUsername())){
			msg.setUsername(new String(msg.getUsername().getBytes("ISO-8859-1"),"UTF-8"));
		}
		msg.setId(Get32Primarykey.getRandom32PK());
		msg.setReadFlag("N");
		//发送消息
		String flag = cRMService.getDbService().getMessagesService().addObj(msg);

		//推送消息
		String url = "/out/user/card?sendMsgFlag=changeCard&flag=Change&partyId="+msg.getUserId()+"&atten_partyId="+msg.getTargetUId();
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(msg.getTargetUId());
		String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, msg.getContent(), url);
		
		if(StringUtils.isNotNullOrEmptyStr(flag)){
			return "success";
		}
		
		return "fail";
	}
	
	/**
	 * 同意交换名片
	 * @param msg
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/agreecard")
	@ResponseBody
	public String agreecard(UserRela userRela, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("agreecard  = > ");
		
		if(!StringUtils.isNotNullOrEmptyStr(userRela.getUser_id()) || !StringUtils.isNotNullOrEmptyStr(userRela.getRela_user_id())){
			return "fail";
		}
		//创建好友关系
		userRela.setType("whitelist");
		String flag = cRMService.getDbService().getUserRelaService().addObj(userRela);
		
		if(!StringUtils.isNotNullOrEmptyStr(flag)){
			return "fail";
		}
		//
		String tmpUserId = userRela.getRela_user_id();
		userRela.setRela_user_id(userRela.getUser_id());
		userRela.setUser_id(tmpUserId);
		userRela.setId(null);
		flag = cRMService.getDbService().getUserRelaService().addObj(userRela);
		
		if(!StringUtils.isNotNullOrEmptyStr(flag)){
			return "fail";
		}
		
		if(StringUtils.isNotNullOrEmptyStr(userRela.getRela_user_name())){
			userRela.setRela_user_name(new String(userRela.getRela_user_name().getBytes("ISO-8859-1"),"UTF-8"));
		}
		
		//发送消息
		Messages msg = new Messages();
		msg.setUserId(userRela.getUser_id());
		msg.setTargetUId(userRela.getRela_user_id());
		msg.setUsername(userRela.getRela_user_name());
		msg.setMsgType("txt");
		msg.setRelaModule("System_AgreeCard");
		msg.setRelaId(userRela.getRela_user_id());
		msg.setReadFlag("N");

		msg.setContent(userRela.getRela_user_name()+"同意与您交换名片！");
		cRMService.getDbService().getMessagesService().addObj(msg);
		
		//推送消息
		String url = "";
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(userRela.getRela_user_id());
		String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, userRela.getRela_user_name()+"同意与您交换名片！", url);
		
		return "success";
	}
	
	/**
	 * 入群同意
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/groupAgree")
	@ResponseBody
	public String groupAgree(Messages msg, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("groupAgree  = > ");
		
		msg.setId(Get32Primarykey.getRandom32PK());
		msg.setRelaModule("System_Group");
		msg.setMsgType(Constants.MESSAGE_TYPE_GROUP_AGREE);
		msg.setReadFlag("N");
		if(StringUtils.isNotNullOrEmptyStr(msg.getUsername())){
			msg.setUsername(new String(msg.getUsername().getBytes("ISO-8859-1"),"UTF-8"));
		}
		//发送消息
		cRMService.getDbService().getMessagesService().addObj(msg);
		//同意入群
		String rst = InvokeUtil.groupAgree(msg.getRelaId(), msg.getTargetUId());
		logger.info("groupAgree rst = >" + rst);
		return "success";
	}
	
	/**
	 * 入群拒绝
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/groupRefuse")
	@ResponseBody
	public String groupRefuse(Messages msg, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("groupRefuse  = > ");
		msg.setId(Get32Primarykey.getRandom32PK());
		msg.setRelaModule("System_Group");
		msg.setMsgType(Constants.MESSAGE_TYPE_GROUP_REJECT);
		msg.setReadFlag("N");
		if(StringUtils.isNotNullOrEmptyStr(msg.getUsername())){
			msg.setUsername(new String(msg.getUsername().getBytes("ISO-8859-1"),"UTF-8"));
		}
		//发送消息
		cRMService.getDbService().getMessagesService().addObj(msg);
		
		return "success";
	}
	
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String crmId = request.getParameter("rowId");
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			
			List<DcCrmOperator> list = (List<DcCrmOperator>) cRMService.getDbService().getDcCrmOperatorService()
					.findDcCrmOperatorListByFilter(crmId);
			DcCrmOperator dc = null;
			if(list!=null&&list.size()>0){
				dc = list.get(0);
				if(!StringUtils.isNotNullOrEmptyStr(dc.getOpMobile())){
					dc.setOpMobile("");
				}
			}
			request.setAttribute("dc", dc);

			// 获取用户头像数据
			Object obj = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			WxuserInfo wxuinfo = null;
			if (null != obj) {
				wxuinfo = (WxuserInfo) obj;
			}
			if (null == obj || null == wxuinfo || null == wxuinfo.getHeadimgurl() || null == wxuinfo.getNickname()) {
				wxuinfo = new WxuserInfo();
				wxuinfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") + "/image/defailt_person.png");
				wxuinfo.setNickname("");
			}
			request.setAttribute("wxuser", wxuinfo);

		} else {
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return "perslInfo/modify";
	}
	
	/**
	 * 修改单个CRM用户信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update")
	public String update(DcCrmOperator obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String opGender = request.getParameter("opGender");
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			obj.setCrmId(crmId);
			obj.setOpGender(opGender);
			DcCrmOperator dc = (DcCrmOperator) cRMService.getDbService().getDcCrmOperatorService()
					.updateDcCrmByCrmId(obj);
			request.setAttribute("dc", dc);
			request.setAttribute("crmId", crmId);
			
			// 获取用户头像数据
			Object o= cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			WxuserInfo wxuinfo = null;
			if (null != o) {
				wxuinfo = (WxuserInfo) o;
			}
			if (null == obj || null == wxuinfo || null == wxuinfo.getHeadimgurl() || null == wxuinfo.getNickname()) {
				wxuinfo = new WxuserInfo();
				wxuinfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
				wxuinfo.setNickname("");
			}
			request.setAttribute("wxuser", wxuinfo);
		} else {
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("dccrm", obj);
		return "perslInfo/modify";
	}
	
	/**
	 * 异步修改单个CRM用户信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asyupdate")
	@ResponseBody
	public String asyupdate(DcCrmOperator obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String opGender = request.getParameter("opGender");
		CrmError crmErr = new CrmError();
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			obj.setCrmId(crmId);
			obj.setOpGender(opGender);
			DcCrmOperator dc = (DcCrmOperator) cRMService.getDbService().getDcCrmOperatorService()
					.updateDcCrmByCrmId(obj);
//			// 获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if (null != currResp.getUsers()
//					&& null != currResp.getUsers().get(0).getUsername()) {
//				request.setAttribute("userName", currResp.getUsers().get(0)
//						.getUsername());
//			}
			request.setAttribute("dc", dc);
			request.setAttribute("crmId", crmId);
			return "ok";
		} else {
			//抛出异常
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			return JSONObject.fromObject(crmErr).toString();
		}
	}
	
	/**
	 * 生成个人名片的二维码
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/make")
	public String make(HttpServletRequest request,HttpServletResponse response)throws Exception{
		ZJWKUtil.getRequestURL(request);
		//是否为内部调用
		Boolean makeFlag = request.getAttribute("makeFlag")!=null?(Boolean)request.getAttribute("makeFlag"):false;
		Boolean isMy = request.getAttribute("isMy")!=null?(Boolean)request.getAttribute("isMy"):false;
		
		String partyId=request.getParameter("partyId");
		String flag = request.getParameter("flag");
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		if(!StringUtils.isNotNullOrEmptyStr(partyId)){
			partyId=user.getParty_row_id();

		}
		String telphone= "";
		String email="";
		String vcard = "";
		if(StringUtils.isNotNullOrEmptyStr(partyId)){
			
			
			 BusinessCard bc = new BusinessCard();
			    bc.setPartyId(partyId);
			    bc.setStatus("0");
			    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
			    if(list!=null&&list.size()>0){
			    	bc=list.get(0);
			    	vcard = bc.toVCARDString();
//				个人主页
//				stringBuffer.append("URL:www.baidu.com;");
				telphone = bc.getPhone();
				email = bc.getEmail();
				request.setAttribute("opname", bc.getName());
				request.setAttribute("dcCrmOperator", bc);
			}
		}
		String logoPath = "";
		if(user!=null){
			logoPath=user.getHeadimgurl();
		}
		String path = request.getSession().getServletContext().getRealPath("cache/");
		logger.info("cache path=============================="+path);
		//当打成war包的时候,路径是这样的
		//String path = System.getProperty("user.dir").replace("bin", "webapps")+PropertiesUtil.getAppContext("qrcache.dir");
		//当在本地运行的时候
//		String path = this.getClass().getResource("/").getPath();
//		path=path.substring(1,path.lastIndexOf("WEB-INF/classes"))+"/cache";
		logger.info(path);
		String filename = QRCodeUtil.encode(partyId,vcard, logoPath, true,path);
		String msg1="";
		if(!StringUtils.isNotNullOrEmptyStr(telphone) || !StringUtils.isNotNullOrEmptyStr(email)){
			msg1 = "您的资料填写不完整，别人无法从二维码获取您的信息哦！" ;
		}
		if("0".equals(filename)){
			throw new Exception("生成二维码图片失败,请联系管理员!");
		}else{
			request.setAttribute("filename", filename);
			request.setAttribute("msg1", msg1);
			request.setAttribute("logoPath", logoPath);
		}
		request.setAttribute("partyId", partyId);
		
		if (makeFlag)
		{
			logger.info("create qrcode success");
			return null;
		}
		else
		{
			return "qrcode/msg";
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
	public String upload(HttpServletRequest request,HttpServletResponse response) throws Exception{
	 MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;     
        //获得文件：     
        MultipartFile file = multipartRequest.getFile("uploadFile");   
        if(file!=null&&file.getSize()>0){
        	logger.info("DcCrmOperatorColltroller upload method fileName=" + file.getOriginalFilename());
        	String fileName = file.getOriginalFilename(); 
	        
	        try{
	        	InputStream inputStream = file.getInputStream();
	        	//String type = fileName.substring(fileName.lastIndexOf("."),fileName.length());
//	        	File tmpFile = new File(fileName);
//	        	file.transferTo(tmpFile);
	        	BufferedImage src = javax.imageio.ImageIO.read(inputStream); //构造Image对象
//	        	int width =src.getWidth();
//	        	int height = src.getHeight();
//	        	if(width>200){
//	        		width = (int)(((new BigDecimal(200).divide(new BigDecimal(height),2,BigDecimal.ROUND_HALF_UP)).doubleValue())*width);
//	        	}
	        	BufferedImage tag = new BufferedImage(80,80,BufferedImage.TYPE_INT_RGB);
	        	tag.getGraphics().drawImage(src,0,0,80,80,null);       //绘制缩小后的图
	        	//将生成的缩略成转换成流
	        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
	        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
	        	//String type = fileName.substring(fileName.lastIndexOf("."),fileName.length());
	        	ImageIO.write(tag,"jpeg",imOut); //scaledImage1为BufferedImage
	        	InputStream is =new ByteArrayInputStream(bs.toByteArray());
	        	//重新命名
	        	fileName = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32BeginTimePK()+".jpeg";
	        	
	        	//ftp上传
	        	FTPUtil fu = new FTPUtil();  
	        	
	        	System.out.println(PropertiesUtil.getAppContext("file.service.userpath")+"--------------------------");
	        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd")); 
	        	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, is)){
	        		fu.closeFTP(ftp);
	        		logger.info("DcCrmOperatorColltroller upload method 上传后文件名！"+fileName);
	        		return "0"+fileName;
	        	}else{
	        		fu.closeFTP(ftp);
	        		logger.info("DcCrmOperatorColltroller upload method -1 上传失败！");
	        		return null;
	        	}
	        }catch(Exception ex){
	        	logger.info("DcCrmOperatorColltroller upload method -3 上传失败！" + ex.toString());
	        	return null;
	        }
        }else{
        	logger.info("DcCrmOperatorColltroller upload method -4 上传失败！");
        	return null;
        }
	}
	
	/**
	 * 个人总结报告
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/psumry")
	public String psumry(DcCrmOperator obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("DCCrmOperatorControl ----->  psumry  ");
		WxuserInfo wx = null;
		String partyId = request.getParameter("partyId");
		logger.info("DCCrmOperatorControl ----->  partyId  " + partyId);
		if(StringUtils.isNotNullOrEmptyStr(partyId)){
			wx = new WxuserInfo();
			wx.setParty_row_id(partyId);
			wx = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wx);
			logger.info("DCCrmOperatorControl ----->  set session  ");
			UserUtil.setCurrUserByPartyId(request, partyId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
		}else{
			wx = UserUtil.getCurrUser(request);
		}
		
		partyId = wx.getParty_row_id();
		String openId = wx.getOpenId();
		
		logger.info("openId = >" + openId);
		logger.info("partyId = >" + partyId);
		
		//添加了${zjfriendcount}个指尖好友
		UserRela ur = new UserRela();
		ur.setUser_id(partyId);
		ur.setCurrpages(Constants.ZERO);
		ur.setPagecounts(Constants.ALL_PAGECOUNT);
		List<UserRela> urlist = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(ur);
		logger.info("urlist size = >" + urlist.size());
		request.setAttribute("zjfriendcount", urlist.size());
		
		//还有${schecount}个日程没有完成.
		//String crmId = cacheScheduleService.getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
		List<String> crmIds = cRMService.getDbService().getCacheScheduleService().getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"),"");
		CacheSchedule casch = new CacheSchedule();
		casch.setCrm_id_in(crmIds);
		casch.setCurrpage(Constants.ZERO);
		casch.setPagecount(Constants.ALL_PAGECOUNT);
		List<CacheSchedule> caschlist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(casch);

		List<String> statusList = new ArrayList<String>();
		statusList.add("In Progress");
		statusList.add("Not Started");
		casch.setStatus_in(statusList);
		logger.info("caschlist size = >" + caschlist.size());
		List<CacheSchedule> caschComplist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(casch);
		logger.info("caschComplist size = >" + caschComplist.size());
		request.setAttribute("schecount", caschlist.size());
		request.setAttribute("schenotfinishcount", caschComplist.size());
		
		//创建了${actcount}个活动
		Campaigns camp = new Campaigns();
		camp.setCurrpage("0");
		camp.setPagecount("999");
		camp.setOpenId(openId);
		camp.setType("owner");
		List<Activity> list = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsList(camp, "WEB");//我发起的活动
		logger.info("cds size = >" + list.size());
		camp.setType("join");
		List<Activity> listJoin = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsList(camp, "WEB");//我参加的活动
		logger.info("cdsJoin size = >" + listJoin.size());
		request.setAttribute("actcount", list.size() + listJoin.size());
		
		//创建和参与了${opptycount}商机.
		CacheOppty caocpph = new CacheOppty();
		caocpph.setCrm_id_in(crmIds);
		caocpph.setCurrpage(new Integer(0));
		caocpph.setPagecount(new Integer(999));
		List<CacheOppty> caopplist = (List<CacheOppty>)cRMService.getDbService().getCacheOpptyService().findObjListByFilter(caocpph);
		float totalAmt = 0;
		float sucAmt = 0;
		float failAmt = 0 ;
		if(null != caopplist && caopplist.size() >0){
			for(int i=0;i<caopplist.size();i++){
				caocpph = caopplist.get(i);
				if("Closed Won".equals(caocpph.getStage())){
					if(StringUtils.isNotNullOrEmptyStr(caocpph.getAmount())){
						totalAmt += Float.parseFloat(caocpph.getAmount());
						sucAmt += Float.parseFloat(caocpph.getAmount());
					}
				}else if("Closed Lost".equals(caocpph.getStage()) || "Abandon".equals(caocpph.getStage())){
					if(StringUtils.isNotNullOrEmptyStr(caocpph.getAmount())){
						totalAmt += Float.parseFloat(caocpph.getAmount());
						failAmt += Float.parseFloat(caocpph.getAmount());
					}
				}else{
					if(StringUtils.isNotNullOrEmptyStr(caocpph.getAmount())){
						totalAmt += Float.parseFloat(caocpph.getAmount());
					}
				}
			}
		}
		logger.info("caopplist size = >" + caopplist.size());
		request.setAttribute("opptycount", caopplist.size());
		request.setAttribute("totalAmt", totalAmt/10000);
		request.setAttribute("sucAmt", sucAmt/10000);
		request.setAttribute("failAmt", failAmt/10000);
		
		//联系人
		CacheContact contact = new CacheContact();
		contact.setCrm_id_in(crmIds);
		contact.setCurrpage(new Integer(0));
		contact.setPagecount(new Integer(999));
		List<CacheContact> conList = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findObjListByFilter(contact);
		logger.info("contactcount size = >" + conList.size());
		request.setAttribute("contactcount", conList.size());
		return "perslInfo/psumry";
	}

	/**
	 * 好友列表邀请
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/frlist")
	public String frlist(DcCrmOperator obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		WxuserInfo wx = UserUtil.getCurrUser(request);
		String openId = wx.getOpenId();
		String partyId = wx.getParty_row_id();
		logger.info("openId = >" + openId);
		logger.info("partyId = >" + partyId);
		
		//还有${schecount}个日程没有完成.
		String crmId = cRMService.getDbService().getCacheScheduleService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext(""), "Default Organization");
		logger.info("crmId = >" + crmId);
		CacheContact casch = new CacheContact();
		casch.setCrm_id(crmId);
		List<CacheContact> caconlist = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findObjListByFilter(casch);
		logger.info("caconlist size = >" + caconlist.size());
		for (int i = 0; i < caconlist.size(); i++) {
			CacheContact cc = caconlist.get(i);
			String mobile = cc.getMobile();
			logger.info("mobile is = >" + mobile);
			boolean rstisf = false;
			
			BusinessCard bc = new BusinessCard();
			bc.setPhone(mobile);
			Object bcobj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(bcobj != null){
				rstisf = true;
			}
			if(!rstisf){
				cc.setIsFriends("not");
			}
		}
		request.setAttribute("caconlist", caconlist);
		return "perslInfo/frlist";
	}
}
