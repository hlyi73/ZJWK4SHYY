package com.takshine.wxcrm.base.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.WxUserinfoService;

public class UserUtil {
	
	private static Logger log = Logger.getLogger(UserUtil.class.getName());
	
	
	public static final WxuserInfo getSessionWxuserInfo(HttpServletRequest request){
		Object currUser = request.getSession().getAttribute(Constants.ZJWK_SESSION+request.getSession().getId());
		if (currUser instanceof WxuserInfo){
			return (WxuserInfo)currUser;
		}
		return null;
	}
	public static final void setSessionWxuserInfo(HttpServletRequest request,WxuserInfo user){
		request.getSession().setAttribute(Constants.ZJWK_SESSION+request.getSession().getId(), user);
		//设置session失效时间，如果是手机端访问，Session失效时间为1天，如果其他设备访问，则失效时间为30分钟
		if(ZJWKUtil.isMobileAccess(request)){
			request.getSession().setMaxInactiveInterval(1 * 24 * 60 * 60);
		}else{
			request.getSession().setMaxInactiveInterval(30 * 60);
		}
	}
	
	
	/**
	 * 获取会话信息
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static WxuserInfo getCurrUser(HttpServletRequest request) throws Exception{
		WxuserInfo currUser = getSessionWxuserInfo(request);
		if(null == currUser){
			String refresh_url = getUrl(request);
			log.info("refresh_url = >" + refresh_url);
			request.setAttribute("refresh_url", refresh_url);
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述：" + ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		return currUser;
	}
	
	/**
	 * 获取当前登陆用户的partyid
	 * @param request
	 * @return partyId
	 * @throws Exception
	 */
	public static String getCurrUserId(HttpServletRequest request) throws Exception{
		return getCurrUser(request).getParty_row_id();
	}
	
	/**
	 * 获取当前登陆用户的openid
	 * @param request
	 * @return partyId
	 * @throws Exception
	 */
	public static String getCurrOpenId(HttpServletRequest request) throws Exception{
		return getCurrUser(request).getOpenId();
	}
	
	/**
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static boolean hasCurrUser(HttpServletRequest request) throws Exception{
		WxuserInfo currUser = getSessionWxuserInfo(request);
		if(null == currUser){
			return false;
		}
		return true;
	}
	
	
	/**
	 * 设置用户缓存(openId)
	 * @param request
	 * @throws Exception
	 */
	public static void setCurrUser(HttpServletRequest request,String openId,WxUserinfoService wxuserInfoService,BusinessCardService businessCardService) throws Exception{
		WxuserInfo user = wxuserInfoService.getWxuserInfo(openId);
		if(null == user || !StringUtils.isNotNullOrEmptyStr(user.getParty_row_id())){
			request.setAttribute("refresh_url", getUrl(request));
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述：" + ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		String crmId = wxuserInfoService.getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(user.getParty_row_id());
		bc.setStatus("0");
		List<?> cardList = businessCardService.findObjListByFilter(bc);
		if(null != cardList && cardList.size()>0){
			bc = (BusinessCard)cardList.get(0);
			if(StringUtils.isNotNullOrEmptyStr(bc.getName())){
				user.setName(bc.getName());
				user.setNickname(bc.getName());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getHeadImageUrl())){
				user.setHeadimgurl(bc.getHeadImageUrl());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getEmail())){
				user.setEmail(bc.getEmail());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
				user.setMobile(bc.getPhone());
			}
		}
		user=wxuserInfoService.getUserConfig(user);//获取用户配置信息
		user.setCrmId(crmId);
		setSessionWxuserInfo(request, user);
		
		//获取用户绑定的org
		setBindOrgList(request,businessCardService,openId);
		
		//有些地方还在使用CurrentUser,暂时保留
		user.setName(user.getNickname());
		request.getSession().setAttribute("CurrentUser", user);
	}
	
	
	/**
	 * 设置用户缓存(wxUserInfo)
	 * @param request
	 * @throws Exception
	 */
	public static void setCurrUser(HttpServletRequest request,WxuserInfo wxuser,String openId,WxUserinfoService wxuserInfoService,BusinessCardService businessCardService) throws Exception{
		if(null == wxuser){
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述：" + ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		String crmId = wxuserInfoService.getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(wxuser.getParty_row_id());
		bc.setStatus("0");
		List<?> cardList = businessCardService.findObjListByFilter(bc);
		if(null != cardList && cardList.size()>0){
			bc = (BusinessCard)cardList.get(0);
			if(StringUtils.isNotNullOrEmptyStr(bc.getName())){
				wxuser.setName(bc.getName());
				wxuser.setNickname(bc.getName());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getHeadImageUrl())){
				wxuser.setHeadimgurl(bc.getHeadImageUrl());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getEmail())){
				wxuser.setEmail(bc.getEmail());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
				wxuser.setMobile(bc.getPhone());
			}
		}
		
		wxuser.setCrmId(crmId);
		wxuser=wxuserInfoService.getUserConfig(wxuser);//获取用户配置信息
		setSessionWxuserInfo(request, wxuser);
		
		setBindOrgList(request,businessCardService,openId);
		
		//有些地方还在使用CurrentUser,暂时保留
		wxuser.setName(wxuser.getNickname());
		request.getSession().setAttribute("CurrentUser", wxuser);
	}
	
	
	/**
	 * 设置用户缓存(partyId)
	 * @param request
	 * @throws Exception
	 */
	public static void setCurrUserByPartyId(HttpServletRequest request,String partyId,WxUserinfoService wxuserInfoService,BusinessCardService businessCardService) throws Exception{
		WxuserInfo user = new WxuserInfo();
		user.setParty_row_id(partyId);
		user = wxuserInfoService.getWxuserInfo(user);
		if(!StringUtils.isNotNullOrEmptyStr(user.getOpenId())){
			request.setAttribute("refresh_url", getUrl(request));
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述：" + ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		String crmId = wxuserInfoService.getCrmIdByOrgId(user.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(user.getParty_row_id());
		bc.setStatus("0");
		List<?> cardList = businessCardService.findObjListByFilter(bc);
		if(null != cardList && cardList.size()>0){
			bc = (BusinessCard)cardList.get(0);
			if(StringUtils.isNotNullOrEmptyStr(bc.getName())){
				user.setName(bc.getName());
				user.setNickname(bc.getName());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getHeadImageUrl())){
				user.setHeadimgurl(bc.getHeadImageUrl());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getEmail())){
				user.setEmail(bc.getEmail());
			}
			if(StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
				user.setMobile(bc.getPhone());
			}
			
		}
		
		user=wxuserInfoService.getUserConfig(user);//获取用户配置信息
		user.setCrmId(crmId);
		setSessionWxuserInfo(request, user);
		
		setBindOrgList(request,businessCardService,user.getOpenId());
		
		//有些地方还在使用CurrentUser,暂时保留
		user.setName(user.getNickname());
		request.getSession().setAttribute("CurrentUser", user);
	}
	
	
	/**
	 * 设置当前登陆用户bind的org
	 * @param request
	 * @param orgList
	 */
	public static void setBindOrgList(HttpServletRequest request,BusinessCardService businessCardService,String openId) throws Exception{
		//获取用户绑定的org
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(openId);
		List<OperatorMobile> orglist = businessCardService.getOrgList(obj);
		request.getSession().removeAttribute(Constants.ZJWK_SESSION_ORG+request.getSession().getId());
		request.getSession().setAttribute(Constants.ZJWK_SESSION_ORG+request.getSession().getId(),orglist);
	}
	
	
	/**
	 * 从session中获取绑定的org
	 * @param request
	 * @return
	 */
	public static List<OperatorMobile> getBindOrgList(HttpServletRequest request){
		List<OperatorMobile> orgList = null;
		Object obj = request.getSession().getAttribute(Constants.ZJWK_SESSION_ORG+request.getSession().getId());
		if(null != obj){
			orgList = (List<OperatorMobile>)obj;
		}else{
			orgList = new ArrayList<OperatorMobile>();
		}
		return orgList;
	}
	
	
	/**
	 * 隐式授权页面
	 * @return
	 */
	private static String getUrl(HttpServletRequest request){
		//String return_url = PropertiesUtil.getAppContext("app.content") + "home/index";
		//取当前请求URL地址
		String return_url = request.getRequestURL().toString();
		if(StringUtils.isNotNullOrEmptyStr(request.getQueryString())){
			return_url = return_url + "?" + request.getQueryString();
		}
		log.info("getUrl return_url = >" + return_url);
		return_url = PropertiesUtil.getAppContext("zjwk.short.url")+"/l?u=" + ZJWKUtil.shortUrl(return_url);
		log.info("getUrl return_url 02= >" + return_url);
		try {
			return_url = URLEncoder.encode(return_url,"UTF-8");
			log.info("getUrl return_url03 = >" + return_url);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
		log.info("getUrl url = >" + url);
		return url;
	}
	
	/**
	 * 隐式授权页面
	 * @param request
	 * @return
	 */
	public static String getAuthUrl(HttpServletRequest request,String return_url){
		return_url = PropertiesUtil.getAppContext("zjwk.short.url")+"/l?u=" + ZJWKUtil.shortUrl(return_url);
		try {
			return_url = URLEncoder.encode(return_url,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
		return url;
	}
	
	/**
	 * 从cookie中取partyId
	 * @param request
	 * @return
	 */
	public static String getUserCookie(HttpServletRequest request){
		//从cookie中获取partyId;
		String party_user_id = null;
		Cookie[] cookies = request.getCookies();
		for(int i=0;i<cookies.length;i++){
			if(Constants.COOKIE_ZJWK_PARTYID.equals(cookies[i].getName())){
				party_user_id = cookies[i].getValue();
				break;
			}
		}
		return party_user_id;
	}
	
	
	/**
	 * 设置cookie
	 * @param response
	 */
	public static void setUserCookie(HttpServletResponse response,String party_user_id){
		Cookie cookie = new Cookie(Constants.COOKIE_ZJWK_PARTYID, party_user_id);
		cookie.setMaxAge(Constants.COOKIE_PARTYID_VALIDE_TIME);
		response.addCookie(cookie);
	}
}
