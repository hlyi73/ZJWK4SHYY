package com.takshine.wxcrm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.userinfo.UserInfo;

/**
 * 微信网页授权回调  页面控制器
 * 
 * @author liulin
 * 
 */
@Controller
@RequestMapping("/oauth2")
public class WxAuthorizeController {
	    // 日志
		protected static Logger log = Logger.getLogger(WxAuthorizeController.class.getName());
		
		/**
	     * 获取url
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/get")
		public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
			log.info("oauth2 get begin=:> ");
			//https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9b487088b37b15b1&redirect_uri=http://115.28.27.20/TAKWxCrmSer/oauth2/response&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
			//snsapi_base: 默认不需要授权, snsapi_userinfo: 显示方式授权
			String url = WxUtil.getAuthCodeUrl("snsapi_base", "1");
			request.setAttribute("url", url);
			return "oauth2/add";
		}

		/**
	     * 微信网页授权回调 方法
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/response")
	    public String response(HttpServletRequest request, HttpServletResponse response) throws Exception{
			log.info("oauth2 response begin=:> ");
	    	//获取请求参数
	    	String code = request.getParameter("code");
	    	String state = request.getParameter("state");
	    	log.info("code =:> " + code);
	    	log.info("state =:> " + state);
	    	
	    	AuthorizeInfo auth = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET, code);
	    	//refresh
	    	AuthorizeInfo authRefresh = WxUtil.refreshToken(Constants.APPID, auth.getRefreshToken());
	    	//获取微信用户信息
	    	UserInfo u = WxUtil.getSnsUserinfo(authRefresh.getOpenId(), authRefresh.getAccessToken());
	    	
	    	log.info(" userInfo openId =:> " + u.getOpenId());
	    	log.info(" userInfo nickName =:> " + u.getNickname());
	    	
	    	log.info("oauth2 response end=:> "); 
	    	
	    	request.setAttribute("openId", u.getOpenId());
	    	request.setAttribute("nickName", u.getNickname());
	    	return "oauth2/response";
	    }
		
		/**
	     * 微博 网页授权回调 方法
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/wbresp")
		public void wbresp(HttpServletRequest request, HttpServletResponse response) throws Exception{
			log.info("oauth2 wbresp begin=:> ");
			//获取请求参数
	    	String code = request.getParameter("code");
	    	String state = request.getParameter("state");
	    	log.info("code =:> " + code);
	    	log.info("state =:> " + state);
	    	
			log.info("oauth2 wbresp end=:> ");
		}
}
