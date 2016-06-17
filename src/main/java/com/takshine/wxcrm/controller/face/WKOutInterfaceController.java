package com.takshine.wxcrm.controller.face;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.userget.UserGet;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.Campaigns2ZJMKTService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.PrintService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.UserRelaService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 指尖人脉对外提供的可以访问的接口
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/out")
public class WKOutInterfaceController {
	
	private static Log out01 = LogFactory.getLog("out01");
	
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询微客 用户信息
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/dcrmoper/search/{partyId}")
	@ResponseBody
	public String dcrmoper_search(@PathVariable String partyId, HttpServletRequest request, HttpServletResponse response) throws Exception{
		out01.info("dcrmoper_info  begin=>");
		out01.info("partyId = >" + partyId);
		if(StringUtils.isNotBlank(partyId)){
			//DcCrmOperator dc = dcCrmOperatorService.findDcCrmOperatorByPartyId(partyId);
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(partyId);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			DcCrmOperator dc = new DcCrmOperator();
			if(obj != null){
				bc = (BusinessCard)obj;
				dc.setOpName(bc.getName());
				dc.setOpMobile(bc.getPhone());
				dc.setOpDuty(bc.getPosition());
				dc.setOpCompany(bc.getCompany());
			}
			String rststr = JSONObject.fromObject(dc).toString();
			out01.info("rststr = >" + rststr);
			return rststr;
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}
	
	@RequestMapping("/sync_act")
	@ResponseBody
	public String search_crmid(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String partyId = request.getParameter("partyId");
		String orgId = request.getParameter("orgId");
		String rowId = request.getParameter("rowId");
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(partyId);
		wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
		String openId = wxuser.getOpenId();
		String crmId = "";
		//得到orgId
		if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(orgId)){
			crmId = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
			RedisCacheUtil.set(Constants.ZJWK_ACTIVITY_ORGID+rowId, orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		
		//添加团队成员
		Share share = new Share();
		share.setShareuserid(crmId);
		share.setShareusername(wxuser.getNickname());
		share.setParentid(rowId);
		share.setParenttype("Activity");
		share.setType("share");
		share.setCrmId(crmId);
		cRMService.getSugarService().getShare2SugarService().updShareUser(share);
		
		return "1";
	}
	
	/**
	 * 得到用户图像
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getUserImage")
	@ResponseBody
	public String getUserImage(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String crmId = request.getParameter("crmId");
		if(null == crmId || "".equals(crmId)){
			return "";
		}
		OperatorMobile opm = new OperatorMobile();
		opm.setCrmId(crmId);
		List<OperatorMobile> opList =  (List<OperatorMobile>)cRMService.getDbService().getOperatorMobileService().findObjListByFilter(opm);
		
		if(opList.size() == 0){
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(crmId);
			return wu.getHeadimgurl();
		}
		if(opList.size() > 0 ){
			OperatorMobile o = opList.get(0);
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(o.getOpenId());
			return wu.getHeadimgurl();
		}
		return "";
	}
	
	/**
	 * 查询所有的任务列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userlist")
	@ResponseBody
	public String userlist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		out01.info("WKOutInterfaceController list method begin=>");
		String crmId = request.getParameter("crmId");
		String openId = request.getParameter("openId");
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		if(!StringUtils.isNotBlank(crmId)){
			crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmId(openId, publicId);
		}
		String orgId = request.getParameter("orgId");
		if(StringUtils.isNotBlank(orgId)){
			crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
			   currpage = (null == currpage ? "0" : currpage);
			   pagecount = (null == pagecount ? "10" : pagecount);
		String viewtype = request.getParameter("viewtype");
		       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		String firstchar = request.getParameter("firstchar");
		       firstchar = (firstchar == null ) ? "" : firstchar ;
	    String flag = request.getParameter("flag");
		String parentid = request.getParameter("parentid");
		String parenttype = request.getParameter("parenttype");
		out01.info("WKOutInterfaceController list method crmId =>" + crmId);
		out01.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage(currpage);
			uReq.setPagecount(pagecount);
			uReq.setViewtype(viewtype);
			uReq.setFlag(flag);
			uReq.setFirstchar(firstchar);
			uReq.setParentid(parentid);
			uReq.setParenttype(parenttype);
			uReq.setOpenId(openId);
			uReq.setOrgId(orgId);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			String errorCode = uResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<UserAdd> ulist = uResp.getUsers();
				return JSONArray.fromObject(ulist).toString();
			}else{
			    crmErr.setErrorCode(uResp.getErrcode());
			    crmErr.setErrorMsg(uResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 查询关注者列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attenuserlist")
	@ResponseBody
	public String attenuserlist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		out01.info("WKOutInterfaceController list method begin=>");
		String relaId = request.getParameter("relaId");
		String openId = request.getParameter("openId");
		WxuserInfo wxu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId); //UserUtil.getCurrUser(request);
		String partyRowId = wxu.getParty_row_id();
		out01.info("partyRowId = >" + partyRowId);
		UserGet ug =  cRMService.getSugarService().getLovUser2SugarService().getAttenUserList(PropertiesUtil.getAppContext("app.publicId"), partyRowId, relaId);
		List<UserInfo> uinfolist = ug.getUinfolist();
		//用户列表集合
		return JSONArray.fromObject(uinfolist).toString();
	}
	
	/**
	 * 查询微客 用户信息
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/dcrmoper/update")
	@ResponseBody
	public String dcrmoper_update(HttpServletRequest request, HttpServletResponse response) throws Exception{
		out01.info("dcrmoper_update  begin=>");
		String partyId = request.getParameter("partyId");
		String opName = request.getParameter("opName");
		out01.info("partyId = >" + partyId);
		out01.info("opName = >" + opName);
		if(StringUtils.isNotBlank(partyId)){
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(partyId);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(null != obj){
				bc = (BusinessCard)obj;
				bc.setName(opName);
				cRMService.getDbService().getBusinessCardService().updateObj(bc);
				return "{\"errorCode\":\"0\",\"errorMsg\":\"success\"}";
			}
			//DcCrmOperator dc = dcCrmOperatorService.findDcCrmOperatorByPartyId(partyId);
			//out01.info("dc id = >" + dc.getId());
//			if(StringUtils.isNotBlank(dc.getId())){
//				dc.setOpName(opName);
//				dcCrmOperatorService.updateObj(dc);
//				return "{\"errorCode\":\"0\",\"errorMsg\":\"success\"}";
//			}
			return "{\"errorCode\":\"1\",\"errorMsg\":\"user not exsitis\"}";
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}
	
	/**
	 * 添加一条信息
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/msg/add")
	@ResponseBody
	public String msg_add(HttpServletRequest request, HttpServletResponse response) throws Exception{
		out01.info("msg_add  begin=>");
		String userId = request.getParameter("user_id");
		String userName = request.getParameter("user_name");
		String targetUId = request.getParameter("target_uid");
		String targetUName = request.getParameter("target_uname");
		String content = request.getParameter("content");
		String relaModule = request.getParameter("rela_module");
		String relaId = request.getParameter("rela_id");
		String subRelaId = request.getParameter("sub_relaid");
		String msgType = request.getParameter("msg_type");
		if(StringUtils.isNotBlank(msgType)){
			msgType="txt";
		}
		String relaName = request.getParameter("rela_name");
		out01.info("userId = >" + userId);
		out01.info("userName = >" + userName);
		out01.info("targetUId = >" + targetUId);
		out01.info("targetUName = >" + targetUName);
		out01.info("content = >" + content);
		out01.info("relaModule = >" + relaModule);
		out01.info("relaId = >" + relaId);
		out01.info("subRelaId = >" + subRelaId);
		out01.info("msgType = >" + msgType);
		if(StringUtils.isNotBlank(userId) 
				&& StringUtils.isNotBlank(targetUId)
				&& StringUtils.isNotBlank(content)){
			//消息对象
			Messages msg = new Messages();
			msg.setUserId(userId);
			msg.setUsername(userName);
			msg.setTargetUId(targetUId);
			msg.setTargetUName(targetUName);
			msg.setContent(content);
			msg.setRelaModule(relaModule);
			msg.setRelaId(relaId);
			msg.setSubRelaId(subRelaId);
			msg.setMsgType(msgType);
			msg.setReadFlag("N");
			msg.setCreateTime(DateTime.currentDate());
			msg.setRelaName(relaName);
			cRMService.getDbService().getMessagesService().addObj(msg);
			
			return "{\"errorCode\":\"0\",\"errorMsg\":\"success\"}";
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}
	
	/**
	 * 报名成功，同步更新dc用户表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/dccrm/update")
	@ResponseBody
	public String update(HttpServletRequest request, HttpServletResponse response) throws Exception{
		out01.info("update  begin=>");
		String opMobile = request.getParameter("opMobile");
		String opDuty = request.getParameter("opDuty");
		String opCompany = request.getParameter("opCompany");
		String opName = request.getParameter("opName");
		String sourceid = request.getParameter("sourceid");
		out01.info("sourceid = >" + sourceid);
		out01.info("opCompany = >" + opCompany);
		out01.info("opDuty = >" + opDuty);
		out01.info("opMobile = >" + opMobile);
		if(StringUtils.isNotBlank(sourceid)){
			//调用businesscard
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(sourceid);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(null != obj){
				bc = (BusinessCard)obj;
				bc.setPhone(opMobile);
				bc.setCompany(opCompany);
				bc.setPosition(opDuty);
				bc.setName(opName);
				cRMService.getDbService().getBusinessCardService().updateObj(bc);
				return "{\"errorCode\":\"0\",\"errorMsg\":\"success\"}";
			}
//			DcCrmOperator dc = dcCrmOperatorService.findDcCrmOperatorByPartyId(sourceid);
//			dc.setOpMobile(opMobile);
//			dc.setOpCompany(opCompany);
//			dc.setOpDuty(opDuty);
//			dc.setOpName(opName);
//			dcCrmOperatorService.updateDcCrmByCrmId(dc);
			return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}
	
	/**
	 * 获取用户信息数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getWxUserByPartyId/{partyId}")
	@ResponseBody
	public String getWxUserByPartyId(@PathVariable String partyId, HttpServletRequest request, HttpServletResponse response) throws Exception {
		out01.info("getWxUserByPartyId  begin=>");
		out01.info("partyId = >" + partyId);
		if(StringUtils.isNotBlank(partyId)){
			WxuserInfo u = new WxuserInfo();
			u.setParty_row_id(partyId);
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(u);
			out01.info("rst = >" + JSONArray.fromObject(wu).toString());
			return JSONObject.fromObject(wu).toString();
		}
		return "";
	}
	
	/**
	 * 未关注用户同步缓存到wxuser表(从活动过来的数据)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveWxuserInfo")
	@ResponseBody
	public String saveWxuserInfo(HttpServletRequest request,HttpServletResponse response)throws Exception{
		WxuserInfo wxuserInfo = new WxuserInfo();
		String openId = request.getParameter("openId");
		String nickname = request.getParameter("nickname");
		String headimgurl = request.getParameter("headimgurl");
		String city = request.getParameter("city");
		String country = request.getParameter("country");
		String language = request.getParameter("language");
		String unionid = request.getParameter("unionid");
		String party_row_id = request.getParameter("party_row_id");
		String sex = request.getParameter("sex");
		String province = request.getParameter("province");
		if(StringUtils.isNotBlank(nickname)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(nickname)){
			nickname = new String(nickname.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotBlank(city)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(city)){
			city = new String(city.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotBlank(country)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(country)){
			country = new String(country.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotBlank(province)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(province)){
			province = new String(province.getBytes("ISO-8859-1"),"UTF-8");
		}
		out01.info("WKOutInterfaceController saveWxuserInfo openId==>"+openId);
		out01.info("WKOutInterfaceController saveWxuserInfo nickname==>"+nickname);
		out01.info("WKOutInterfaceController saveWxuserInfo headimgurl==>"+headimgurl);
		out01.info("WKOutInterfaceController saveWxuserInfo city==>"+city);
		out01.info("WKOutInterfaceController saveWxuserInfo country==>"+country);
		out01.info("WKOutInterfaceController saveWxuserInfo language==>"+language);
		out01.info("WKOutInterfaceController saveWxuserInfo unionid==>"+unionid);
		out01.info("WKOutInterfaceController saveWxuserInfo party_row_id==>"+party_row_id);
		out01.info("WKOutInterfaceController saveWxuserInfo province==>"+province);
		out01.info("WKOutInterfaceController saveWxuserInfo sex==>"+sex);
		wxuserInfo.setOpenId(openId);
		wxuserInfo.setCity(city);
		wxuserInfo.setCountry(country);
		wxuserInfo.setHeadimgurl(headimgurl);
		wxuserInfo.setNickname(nickname);
		wxuserInfo.setLanguage(language);
		wxuserInfo.setUnionid(unionid);
		wxuserInfo.setParty_row_id(party_row_id);
		wxuserInfo.setSex(sex);
		wxuserInfo.setProvince(province);
		cRMService.getWxService().getWxUserinfoService().saveOrUptUserInfo(wxuserInfo);
		return "success";
	}
	
	/**
	 * 跳转到个人名片
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/user/card")
	public String card(HttpServletRequest request, HttpServletResponse response) throws Exception {
//		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String partyId = request.getParameter("partyId");
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(partyId);
		String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
		//获取openId绑定的CRMID，目前只考虑1个
//		List<String> crmidList = dcCrmOperatorService.getCrmIdArr(openId, publicId, "");
//		String crmId = "";
//		if(null != crmidList && crmidList.size() >0){
//			crmId = crmidList.get(0);
//		}
		String atten_partyId = request.getParameter("atten_partyId");
		if(!com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(atten_partyId)){
			atten_partyId = UserUtil.getCurrUser(request).getParty_row_id();
		}
		WxuserInfo atten_wxuser = new WxuserInfo();
		atten_wxuser.setParty_row_id(atten_partyId);
		String atten_openid = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(atten_wxuser).getOpenId();
		
		out01.info("---------------------out---------------openId==="+openId);
		out01.info("---------------------out---------------atten_openid==="+atten_openid);
		
		String flag = request.getParameter("flag");
		if(StringUtils.isNotBlank(flag)){
			if("RM".equals(flag)){
				if(partyId.equals(atten_partyId)){
					flag = null;
				}
			}
		}
		
		String groupid = request.getParameter("groupid");
		String spm = request.getParameter("spm");
		// 处理消息设置为已读
		cRMService.getBusinessService().getDiscuGroupMainService().handlerMesssageFlag(UserUtil.getCurrUserId(request), partyId);
		return "redirect:/businesscard/detail?flag="+flag+"&partyId="+partyId+"&relaPartyId="+atten_partyId+"&group_id="+groupid+"&spm="+spm;//+"&atten_openid="+atten_openid;
	}
	
	/**
	 * 查询指尖好友关联关系数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/user/rela")
	@ResponseBody
	public String user_rela(HttpServletRequest request, HttpServletResponse response) throws Exception {
		out01.info("user_rela = >");
		String userId = request.getParameter("userId");
		out01.info("userId = >" + userId);
		if(StringUtils.isNotBlank(userId)){
			//威客好友  
			UserRela userRela = new UserRela();
			userRela.setUser_id(userId);
			userRela.setCurrpages(0);
			userRela.setPagecounts(9999);
			@SuppressWarnings("unchecked")
			List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
			out01.info("userRelaList size = >" + userRelaList.size());
			
			Map<String, UserRela> newMargeRelaList = new HashMap<String, UserRela>();
			
			//威客关联用户
			for (int j = 0; j < userRelaList.size(); j++) {
				UserRela sUr = userRelaList.get(j);
				String sUserId = sUr.getUser_id();
				String sReUserId = sUr.getRela_user_id();
				out01.info("sUserId = >" + sUserId);
				out01.info("sReUserId = >" + sReUserId);
				if(!newMargeRelaList.keySet().contains(sReUserId)){
					newMargeRelaList.put(sReUserId, sUr);
				}
			}
			out01.info("newMargeRelaList size = >" + newMargeRelaList.size());
			
			List<UserRela> rstUr = new ArrayList<UserRela>();
			Set<Map.Entry<String, UserRela>> entryseSet = newMargeRelaList.entrySet();
			for (Map.Entry<String, UserRela> entry : entryseSet) {
				UserRela ur = entry.getValue();
				rstUr.add(ur);
			}
			if(rstUr.size() > 0){
				String rst = JSONArray.fromObject(rstUr).toString();
				out01.info("rst = >" + rst);
				return rst;
			}
			return  "{\"errorCode\":\"0\",\"errorMsg\":\"success, size is zero .\"}";
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}
	
	/**
	 *  查询绑定的团队成员列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/asynclist")
	@ResponseBody
	public String asynclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String relaId = request.getParameter("relaId");
		out01.info("asynclist relaId = >" + relaId);
		TeamPeason search = new TeamPeason();
		search.setRelaId(relaId);
		//查询列表是否存在
		List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
		out01.info("asynclist list = >" + list.size());
		return JSONArray.fromObject(list).toString();
	}
	
	/**
	 *  新增 团队成员
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/save")
	@SuppressWarnings("unchecked")
	@ResponseBody
	public String save(HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrmError crmErr = new CrmError();
		String ownerOpenId = request.getParameter("ownerOpenId");
		String openIds = request.getParameter("openIds");
		String nickNames = request.getParameter("nickNames");
		String relaId = request.getParameter("relaId");
		String relaModel = request.getParameter("relaModel");
		String relaName = request.getParameter("relaName");
		String assigner = request.getParameter("assigner");
		String orgId = request.getParameter("orgId");
		if(StringUtils.isNotBlank(relaName)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(relaName)){
			relaName = new String(relaName.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotBlank(assigner)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(assigner)){
			assigner = new String(assigner.getBytes("ISO-8859-1"),"UTF-8");
		}
		//遍历openId
		String [] args = openIds.split(",");
		String [] names = nickNames.split(",");
		for (int i = 0; i < args.length; i++) {
			String openId = args[i];
			String name = names[i];
			if(StringUtils.isNotBlank(name)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(name)){
				name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
			}
			if(null != openId && !"".equals(openId)){
				TeamPeason search = new TeamPeason();
				search.setOpenId(openId);
				search.setRelaId(relaId);
				//查询列表是否存在
				List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
				if(list.size() == 0 ){
					//插入新的数据
					TeamPeason add = new TeamPeason();
					add.setCreateTime(DateTime.currentDate());
					add.setOpenId(openId);
					add.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
					add.setNickName(name);
					add.setRelaId(relaId);
					add.setRelaModel(relaModel);
					add.setRelaName(relaName);
					cRMService.getDbService().getTeamPeasonService().addObj(add);
					//发送客服消息
					sendMsg(orgId,ownerOpenId, openId, name, relaModel, relaId, assigner, relaName, request);
				}
			}
		}
		crmErr.setErrorCode(ErrCode.ERR_CODE_0);
		crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 *  删除 团队成员
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/del")
	@ResponseBody
	public String del( HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String relaId = request.getParameter("relaId");
		CrmError crmErr = new CrmError();
		TeamPeason tp = new TeamPeason();
		tp.setOpenId(openId);
		tp.setRelaId(relaId);
		cRMService.getDbService().getTeamPeasonService().deleteTeamPeason(tp);
		crmErr.setErrorCode(ErrCode.ERR_CODE_0);
		crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 发送客服消息
	 * @param openid 微信用户uID
	 * @param parenttype 关联模块类型
	 * @param rowId 关联模块ID
	 * @param crmname 发送人名字
	 * @param modelname 关联模块ID名字
	 * @param request 请求对象
	 */
	private void sendMsg(String orgId,String ownerOpenId,String openid, String nickname, String parenttype, String rowid, 
			                String crmname, String modelname, HttpServletRequest request){
		String model = "";
		String param = "&orgId="+orgId; //关注用户的openid
		StringBuffer sBuffer = new StringBuffer();
		sBuffer.append(crmname+"共享了");
		if("Accounts".equals(parenttype)){
			model = "/customer";
			sBuffer.append("客户"); 
		}else if("Opportunities".equals(parenttype)){
			model = "/oppty";
			sBuffer.append("业务机会"); 
		}else if("Contacts".equals(parenttype)){
			model = "/contact";
			sBuffer.append("联系人");  
		}else if("Tasks".equals(parenttype)){
			param += "&schetype=" + request.getParameter("schetype");
			model = "/schedule";
			sBuffer.append("任务"); 
		}else if("Contract".equals(parenttype)){
			model = "/contract";
			sBuffer.append("合同");  
		}else if("Project".equals(parenttype)){
			model = "/project";
			sBuffer.append("项目"); 
		}else if("Activity".equals(parenttype)){
			model = "/zjactivity";
			sBuffer.append("指尖活动"); 
			param += "&id=" + rowid+"&source=wkshare&ownerOpenId="+ownerOpenId;
		}
		sBuffer.append("【"+modelname+"】"+"给您"); 
		cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(openid, ownerOpenId, PropertiesUtil.getAppContext("app.publicId"), 
			                                       sBuffer.toString(), model+"/detail?rowId=" + rowid + param);
	}
	
	/**
	 * 增加或者删除共享用户
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/upd")
	@ResponseBody
	public String updshare(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Share obj = new Share();
		obj.setId(request.getParameter("id"));
		obj.setParenttype(request.getParameter("parenttype"));
		obj.setParentid(request.getParameter("parentid"));
		obj.setOpenId(request.getParameter("openId"));
		obj.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
		obj.setShareuserid(request.getParameter("shareuserid"));
		obj.setShareusername(request.getParameter("shareusername"));
		obj.setType(request.getParameter("type"));
		out01.info("WKOutInterfaceController save method id =>" + obj.getId());
		String crmname = request.getParameter("crmname");//当前登录人的名称
		String modelname = request.getParameter("projname");//当前model名称
		String crmId = "";
		if("Activity".equals(obj.getParenttype())){
			String orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+obj.getParentid());
			crmId = cRMService.getSugarService().getShare2SugarService().getCrmIdByOrgId(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		String name = obj.getShareusername();
		if(StringUtils.isNotBlank(name)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
			obj.setShareusername(name);
		}
		if(StringUtils.isNotBlank(crmname)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(crmname)){
			crmname = new String(crmname.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotBlank(modelname)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(modelname)){
			modelname = new String(modelname.getBytes("ISO-8859-1"),"UTF-8");
		}
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotBlank(crmId)){
			obj.setCrmId(crmId);
			String parenttype = obj.getParenttype();
			crmErr = cRMService.getSugarService().getShare2SugarService().updShareUser(obj);
			String param = "";
			if("0".equals(crmErr.getErrorCode())&&"share".equals(obj.getType()) && !crmId.equals(obj.getShareuserid())){
				String model = "";
				StringBuffer sBuffer = new StringBuffer();
				sBuffer.append(crmname+"共享了");
				if("Accounts".equals(parenttype)){
					model = "/customer";
					sBuffer.append("客户"); 
				}else if("Opportunities".equals(parenttype)){
					model = "/oppty";
					sBuffer.append("业务机会"); 
				}else if("Quote".equals(parenttype)){
					model = "/quote";
					sBuffer.append("报价"); 
				}else if("Contacts".equals(parenttype)){
					model = "/contact";
					sBuffer.append("联系人");  
				}else if("Tasks".equals(parenttype)){
					param = "&schetype="+request.getParameter("schetype");
					model = "/schedule";
					sBuffer.append("任务"); 
				}else if("Contract".equals(parenttype)){
					model = "/contract";
					sBuffer.append("合同");  
				}else if("Project".equals(parenttype)){
					model = "/project";
					sBuffer.append("项目"); 
				}else if("Campaigns".equals(parenttype)){
					model = "/campaigns";
					sBuffer.append("市场活动"); 
				}else if("Activity".equals(parenttype)){
					model = "/zjactivity";
					sBuffer.append("活动"); 
					param += "&id="+obj.getParentid()+"&source=wkshare&ownerOpenId="+obj.getOpenId();
				}else if("WeekReport".equals(parenttype)){
					model = "/weekreport";
					sBuffer.append("周报"); 
				}else if("Cases".equals(parenttype)){
					model = "/complaint";
					sBuffer.append("服务"); 
				}else if("Project".equals(parenttype)){
					param = "&schetype=plan";
					model = "/schedule";
					sBuffer.append("任务"); 
				}else if("Quote".equals(parenttype)){
					model = "/quote";
					sBuffer.append("报价");
				}
				sBuffer.append("【"+modelname+"】"+"给您"); 
				String shareid = obj.getShareuserid();
				if(shareid.contains(",")){
					String[] ids = shareid.split(",");
					for(String assgnerid : ids){
						cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(assgnerid,sBuffer.toString(), model+"/detail?rowId="+obj.getParentid()+param);
					}
				}else{
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(shareid,sBuffer.toString(), model+"/detail?rowId="+obj.getParentid()+param);
				}
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 *  查询团队成员列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/getShareUserList")
	@ResponseBody
	public String getShareUserList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String partyId = request.getParameter("partyId");
		String openId = request.getParameter("openId");
		String parenttype = request.getParameter("parenttype");
		if(!StringUtils.isNotBlank(openId)){
			WxuserInfo atten_wxuser = new WxuserInfo();
			atten_wxuser.setParty_row_id(partyId);
			openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(atten_wxuser).getOpenId();
		}
		String orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+rowId);
		String crmId = "";
		if(StringUtils.isNotBlank(orgId)){
			crmId = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		Share share = new Share();
		share.setParentid(rowId);
		share.setParenttype(parenttype);
		share.setCrmId(crmId);
		ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
		List<ShareAdd> sharelist = sresp.getShares();
		List<ShareAdd> shareAdds = new ArrayList<ShareAdd> ();
		for(ShareAdd shareObj:sharelist){
			if(crmId.equals(shareObj.getShareuserid())){
				shareObj.setFlag("N");
			}
			shareAdds.add(shareObj);
		}
		return JSONArray.fromObject(shareAdds).toString();
	}
	
	/**
	 * 创建指尖账号
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/zjaccount_create")
	@ResponseBody
	public String zjaccount_create(HttpServletRequest request, HttpServletResponse response) throws Exception {
		out01.info("zjaccount_create = > ");
		String rst = "{\"crmId\":\"\",\"party_user_id\":\"\"}";
		String openId = request.getParameter("openId");
		String unionid = request.getParameter("unionId");
		out01.info("openId = > " + openId);
		out01.info("unionid = > " + unionid);
		if(StringUtils.isNotBlank(openId)){
			rst = cRMService.getWxService().getWxUserinfoService().synchroUserData(openId, unionid, "out");
		}
		out01.info("zjaccount_create rst = >" + rst);
		return rst;
	}
	
	/**
	 * 活动获取用户信息数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getUser")
	@ResponseBody
	public String getUserInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String partyId = request.getParameter("partyId");
		if(null != partyId && !"".equals(partyId)){
			WxuserInfo wInfo = new WxuserInfo();
			wInfo.setParty_row_id(partyId);
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wInfo);
			return JSONArray.fromObject(wu).toString();
		}
		return "";
	}
	
	/**
	 * 获取用户信息数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getUserByOpenId")
	@ResponseBody
	public String getUserByOpenId(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		if(null != openId && !"".equals(openId)){
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
			return JSONArray.fromObject(wu).toString();
		}
		return "";
	}
	
	
	/**
	 * 添加活动印记
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addActivityPrint")
	@ResponseBody
	public String addActivityPrint(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    String partyId=request.getParameter("partyId");
	    String activityId=request.getParameter("activityId");
	    String activityName=request.getParameter("activityName");
	    String operativeType=request.getParameter("operativeType");
	    Print print= new Print();
		print.setObjectid(activityId);
		print.setOwnid(partyId);
		print.setOperativeid(partyId);
		print.setObjectname(activityName);
		print.setObjecttype("ACTIVITY");
		print.setOperativetype(operativeType);
		cRMService.getDbService().getPrintService().insert(print);//添加印记
		return "0";
	}
}
