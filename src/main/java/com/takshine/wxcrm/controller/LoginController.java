/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.userinfo.UserInfo;

/**
 * 登录 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/login")
public class LoginController {
	// 日志
	protected static Logger logger = Logger.getLogger(LoginController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	
	/**
     * 登录
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/init")
    public String init(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	String rst = "login";
    	//获取请求参数
    	Object logFlg = request.getSession().getAttribute("username");//登录标志 
    	String username = request.getParameter("username");//用户名
    	String password = request.getParameter("password");//密码
    	//判断登录
    	if(logFlg != null ){
    		username = (String)logFlg;
    		return jumpStr(username);
    	} 
    	
    	if(null == username || null == password || "".equals(username) || "".equals(password)){
    		request.setAttribute("errorMsg", "用户名或密码不能为空!");
    		return rst ;
    	}
    	
    	if( (username.equals("admin") 
    			|| username.equals("yintai"))
    			&& "admin".equals(password) ){
    		//验证码判断
    		//if(!checkCode(request)) return rst;
    		
    		request.getSession().setAttribute("username", username);
    		//查询用户的权限
    		//searchUserPermission(request, username);
    		rst = jumpStr(username);;
    	}else{
    		request.setAttribute("errorMsg", "用户名或密码有错误!");
    	}
        return rst;  
    }
    
    /**
     * 退出登录
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/loginOut")
    public String loginOut(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	request.getSession().removeAttribute("username");
    	request.getSession().removeAttribute("PERM");
    	return "login";  
    }
    
   /* *//**
     * 查询用户的权限
     * @param request
     * @param username
     *//*
    @SuppressWarnings("unchecked")
    public void searchUserPermission(HttpServletRequest request, String username){
		//查询权限
		Map<String, Object> p = new HashMap<String, Object>();
		//查询登录用户名的权限列表
		List permList = permissionService.findPermissionByLoginName(username);
		for (Iterator iterator = permList.iterator(); iterator.hasNext();) {
			PermissionTable pt = (PermissionTable) iterator.next();
			p.put(pt.getFunId(), true);
		}
		request.getSession().setAttribute("PERM", p);
    }*/
    
	/**
	 * 检查验证码
	 * 
	 * @param code
	 *            验证码
	 * @return boolean
	 *//*
	public boolean checkCode(HttpServletRequest request) {
		boolean rst = false;
		String code = request.getParameter("valiCode");
		if (code != null) {
			String cookieValue = "";
			Cookie cookie = CookieUtil.getCookie(request, "RandomCheckCode_FG");
			if (null != cookie) {
				cookieValue = cookie.getValue();
			}
			rst =  code.trim().toUpperCase().equals(cookieValue);
			// return code.trim().toUpperCase().equals(ActionContext.getContext().getSession().get("RandomCheckCode"));
		}
		//info
		if(!rst) request.setAttribute("errorMsg", "验证码输入错误!");
		return rst;
	}*/
	
	/**
	 * 跳转逻辑
	 * @param username
	 * @return
	 */
	private String jumpStr(String username){
		String rst = "";
		return rst = ("admin".equals(username))  ? (rst = "index") : (rst = "indexSh") ;
	}
	
	
	/**
     * 网站二维码登录
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/qrcode")
    public String qrcode(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("跳转到微信登陆返回-----------------------==== ");
		String code = request.getParameter("code");
		String cookeid = request.getParameter("cookeid");
		logger.info(" LoginController qrcode code => " + code);
		logger.info(" LoginController qrcode cookeid => " + cookeid);
		String openId = "";

		if (null != code && !"".equals(code)){// && (null == openId || "".equals(openId))) {
			AuthorizeInfo auth = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET, code);
			logger.info(" LoginController qrcode AccessToken => " + auth.getAccessToken());
			logger.info(" LoginController qrcode  openId => " + auth.getOpenId());
			openId = auth.getOpenId();

			// refresh
			AuthorizeInfo authRefresh = WxUtil.refreshToken(Constants.APPID, auth.getRefreshToken());
			logger.info(" LoginController qrcode AccessToken => " + authRefresh.getRefreshToken());
			// 获取微信用户信息
			UserInfo u = WxUtil.getSnsUserinfo(authRefresh.getOpenId(), authRefresh.getAccessToken());
			logger.info(" LoginController qrcode  openId => " + null == u.getOpenId() ? "null" : u.getOpenId());
			logger.info(" LoginController qrcode  image => " + null == u.getHeadImgurl() ? "null" : u.getHeadImgurl());
			logger.info(" LoginController qrcode  nick => " + null == u.getNickname() ? "null" : u.getNickname());
			
			
			//
			if (null != u.getHeadImgurl()) {
				WxuserInfo user = new WxuserInfo();
				user.setOpenId(openId);
				user.setHeadimgurl(u.getHeadImgurl());
				user.setNickname(u.getNickname());
				user.setCountry(u.getCountry());
				user.setCity(u.getCity());
				user.setProvince(u.getProvince());
				user.setSex(String.valueOf(u.getSex()));
				cRMService.getWxService().getWxUserinfoService().saveOrUptUserInfo(user);
			}		
			
			logger.info("判断是否已注册个人账户==== ");
			//判断是否已注册个人账户
			OperatorMobile om = new OperatorMobile();
			om.setOpenId(openId);
			om.setOrgId("Default Organization");
			List<?> omList = cRMService.getDbService().getOperatorMobileService().findObjListByFilter(om);
			if(null == omList || omList.size() == 0){
				logger.info("未注册，给该用户注册账户==== ");
				//注册账号
				cRMService.getWxService().getWxUserinfoService().synchroUserData(openId,u.getUnionid(), "website");
			}
			
			RedisCacheUtil.setString(cookeid, Get32Primarykey.getRandomValiteCode(14)+"_"+openId+"_"+Get32Primarykey.getRandomValiteCode(14));
		}
		//验证用户是否关注
		boolean rstflag = cRMService.getWxService().getWxSubscribeHisService().searchWxSubHisExits(openId);
		//未关注
		if(!rstflag){
			request.setAttribute("focus_url", PropertiesUtil.getAppContext("app_focus_url"));
		}
    	return "qrcode";
    }
	
	
	@RequestMapping("/auth")
	@ResponseBody
    public String auth(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cookeid = request.getParameter("cookeid");
		logger.info("-----------------cookeid-----------------"+cookeid);
		String rst = "";
		if(null == cookeid || "".equals(cookeid)){
			rst = "-1";
		}else{
			rst = RedisCacheUtil.getString(cookeid);
			if(null == rst){
				rst = RedisCacheUtil.getString(cookeid+"_pcid");
				if(null == rst){
					rst = "";
				}else{
					rst = "1";
					RedisCacheUtil.delete(cookeid+"_pcid");
				}
			}else{
				RedisCacheUtil.delete(cookeid);
			}
		}
		logger.info("-----------------openId-----------------"+rst);
		return rst;
	}
	
	
	@RequestMapping("/login")
    public String login(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("进入log-----------------------==== ");
		String cookeid = request.getParameter("cookeid");
		RedisCacheUtil.setString(cookeid+"_pcid", cookeid);
		String return_url = PropertiesUtil.getAppContext("app.content") + "login/qrcode?cookeid="+cookeid;
		try {
			return_url = URLEncoder.encode(return_url,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		logger.info("跳转到微信登陆-----------------------==== ");
		String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
		return "redirect:"+url;
	}
	
	
	@RequestMapping("/{openId}")
	public String login(@PathVariable String openId, HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(StringUtils.isNotBlank(openId) && openId.length() > 50){
			String prefix = openId.substring(0,15);
			String nexfix = openId.substring(openId.length() - 15);
			openId = openId.replace(prefix, "").replace(nexfix, "");
		}
		UserUtil.setCurrUser(request, openId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
		return "redirect:/home/index";
	}
	
	public static void main(String[] args) {
		String openId="123123123123123olwePwqo9LCOphoh20SGVxSszI4Q123123123123123";
		if(StringUtils.isNotBlank(openId) && openId.length() > 50){
			String prefix = openId.substring(0,15);
			String nexfix = openId.substring(openId.length() - 15);
			openId = openId.replace(prefix, "").replace(nexfix, "");
		}
		System.out.println(openId);
		System.out.println("olwePwqo9LCOphoh20SGVxSszI4Q");
	}
}
