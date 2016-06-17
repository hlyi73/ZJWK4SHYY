package com.takshine.wxcrm.base.util;

import org.apache.log4j.Logger;

import com.takshine.wxcrm.base.common.Constants;

/**
 * 微博 公众平台通用接口工具类
 * 
 * @author liulin
 * @date 2014-03-09
 */
public class WbUtil {
	private static Logger log =  Logger.getLogger(WbUtil.class.getName());
	
	//第一步：用户同意授权，获取code
	public static String authorize_code = "https://api.weibo.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&response_type=code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI";

	// 获取access_token的接口地址（GET） 限200（次/天）
	public final static String access_token_url = "https://api.weibo.com/oauth2/access_token?client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=authorization_code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&code=CODE";
	
	/**
	 * 第一步：用户同意授权，获取code
	 * @param scope
	 * @param state
	 * @return
	 */
	public static String getAuthCodeUrl(String scope, String state){
		//第一步：用户同意授权，获取code
		// 拼装获取code的url
		String url =  authorize_code.replace("YOUR_CLIENT_ID", Constants.CLIENTID).replace("YOUR_REGISTERED_REDIRECT_URI", Constants.WBREDIRECTURI);
		       url =  url.replace("SCOPE", scope).replace("STATE", state);
		log.info("getAuthCodeUrl =:>" + url);
	    //调用接口获取用户信息
		return url;
	}

}
