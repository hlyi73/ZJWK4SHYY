/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 消息统一入口管理
 * 
 * 
 */
@Controller
@RequestMapping("/msgentr")
public class MsgEntranceController {
	
	private static Logger logger = Logger.getLogger(MsgEntranceController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 统一访问 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/access")
	public String access(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("msgentr access = >");
		String redirectUrl = request.getParameter("redirectUrl");
		logger.info("redirectUrl = >" + redirectUrl);
		
		//非空
		if(StringUtils.isNotNullOrEmptyStr(redirectUrl)){
			//取session
			if(UserUtil.hasCurrUser(request)){
				//不做处理
				logger.info("msgentr ---------------has session = >");
			}
			//取cookie
			else if(StringUtils.isNotNullOrEmptyStr(UserUtil.getUserCookie(request))){
				String party_user_id = UserUtil.getUserCookie(request);
				WxuserInfo wxuser = new WxuserInfo();
				wxuser.setParty_row_id(party_user_id);
				wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
				if(StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
					UserUtil.setCurrUser(request, wxuser.getOpenId(), cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
				}else{
					logger.info("msgentr ---------------wx auth1 = >");
					return "redirect:"+UserUtil.getAuthUrl(request, PropertiesUtil.getAppContext("app.content")+redirectUrl);
				}
			}
			//隐示授权
			else{
				logger.info("msgentr ---------------wx auth2 = >");
				return "redirect:"+UserUtil.getAuthUrl(request, PropertiesUtil.getAppContext("app.content")+redirectUrl);
			}
			return "redirect:/" + redirectUrl;
		}else{
			return UserUtil.getAuthUrl(request, PropertiesUtil.getAppContext("app.content")+redirectUrl);
		}
	}
	
	/**
	 * 微信图文消息访问
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/menu")
	public String menu(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("MsgEntranceController menu access = >");
		String redirectUrl = request.getParameter("redirectUrl");
		String openId = request.getParameter("userid");
		logger.info("redirectUrl = >" + redirectUrl);
		logger.info("openId = >" + openId);
		WxuserInfo wxuser = null;
		//非空
		if (StringUtils.isNotNullOrEmptyStr(redirectUrl)) {
			// 取session
			if (UserUtil.hasCurrUser(request)) {
				wxuser = UserUtil.getCurrUser(request);
				// 不做处理
				logger.info("msgentr ---------------has session = >");
			}
			// 取cookie
			else if (StringUtils.isNotNullOrEmptyStr(UserUtil.getUserCookie(request))) {
				String party_user_id = UserUtil.getUserCookie(request);
				wxuser = new WxuserInfo();
				wxuser.setParty_row_id(party_user_id);
				wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
				if (StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())) {
					UserUtil.setCurrUser(request, wxuser.getOpenId(),cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
				} else {
					logger.info("msgentr ---------------wx auth1 = >");
					return "redirect:" + UserUtil.getAuthUrl(request,PropertiesUtil.getAppContext("app.content") + redirectUrl);
				}
			}
			// 根据openId查询
			else if (StringUtils.isNotNullOrEmptyStr(openId)) {
				String party_user_id = cRMService.getWxService().getWxUserinfoService().getPartyRowId(openId);
				wxuser = new WxuserInfo();
				wxuser.setParty_row_id(party_user_id);
				wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
				if (StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())) {
					UserUtil.setCurrUser(request, wxuser.getOpenId(),cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
				} else {
					logger.info("msgentr ---------------wx auth1 = >");
					return "redirect:" + UserUtil.getAuthUrl(request, PropertiesUtil.getAppContext("app.content") + redirectUrl);
				}
			}
			// 隐示授权
			else {
				logger.info("msgentr ---------------wx auth2 = >");
				return "redirect:"+ UserUtil.getAuthUrl(request,PropertiesUtil.getAppContext("app.content") + redirectUrl);
			}
			
			//获取用户名片信息
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(wxuser.getParty_row_id());
			bc.setStatus("0");
			List<BusinessCard> cardList = cRMService.getDbService().getBusinessCardService().getList(bc);
        	if(cardList.size() > 0){
        		bc = (BusinessCard)cardList.get(0);
        		//没有电话，需要完善名片
        		if(!StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
        			return "redirect:/businesscard/card?redirectUrl="+URLEncoder.encode(redirectUrl, "UTF-8");
        		}
        	}
			
			return "redirect:/" + redirectUrl;
		} else {
			throw new Exception(ErrCode.ERR_CODE_999999_MSG);
		}
	}
	
}