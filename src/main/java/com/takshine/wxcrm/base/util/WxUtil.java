package com.takshine.wxcrm.base.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;

import sun.misc.BASE64Encoder;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.message.custresp.CustArticle;
import com.takshine.wxcrm.message.custresp.CustNews;
import com.takshine.wxcrm.message.custresp.CustNewsMessage;
import com.takshine.wxcrm.message.custresp.CustText;
import com.takshine.wxcrm.message.custresp.CustTextMessage;
import com.takshine.wxcrm.message.menu.Menu;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.qrcode.QrCode;
import com.takshine.wxcrm.message.qrcode.QrCodeAction;
import com.takshine.wxcrm.message.qrcode.QrCodeReq;
import com.takshine.wxcrm.message.qrcode.QrCodeScene;
import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.message.tplmsg.TemplateText;
import com.takshine.wxcrm.message.userget.UserGet;
import com.takshine.wxcrm.message.userinfo.UserInfo;

/**
 * 微信 公众平台通用接口工具类
 * 
 * @author liulin
 * @date 2014-02-26
 */
public class WxUtil {
	private static Logger log =  Logger.getLogger(WxUtil.class.getName());

	// 获取access_token的接口地址（GET） 限200（次/天）
	public final static String access_token_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET";

	// 获取jsapi_ticket的接口地址
	public final static String jsapi_ticket_url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi";

	// 菜单创建（POST） 限100（次/天）
	public static String menu_create_url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=ACCESS_TOKEN";
	
	// 用户基本信息接口
	public static String user_info_url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN";
	
	/**
	 * 用户网页授权
	 * 如果用户在微信中（Web微信除外）访问公众号的第三方网页，公众号开发者可以通过此接口获取当前用户基本信息
	 * （包括昵称、性别、城市、国家）。利用用户信息，可以实现体验优化、用户来源统计、帐号绑定、用户身份鉴权等
	 * 功能。请注意，“获取用户基本信息接口是在用户和公众号产生消息交互时，才能根据用户OpenID获取用户基本信
	 * 息，而网页授权的方式获取用户基本信息，则无需消息交互，只是用户进入到公众号的网页，就可弹出请求用户授权
	 * 的界面，用户授权后，就可获得其基本信息（此过程甚至不需要用户已经关注公众号。）”
	 */
	//第一步：用户同意授权，获取code
	public static String authorize_code = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect";
	
	//第二步：通过code换取网页授权access_token
	public static String authorize_access_token = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
	
	//第三步：刷新access_token（如果需要）
	public static String authorize_refresh_token = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN";
	
	//第四步：拉取用户信息(需scope为 snsapi_userinfo)
	public static String authorize_userinfo = "https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN";
	
	//发送客服消息
	public static String custom_send = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=ACCESS_TOKEN";
	
	//发送模板消息
	public static String template_msg_send = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=ACCESS_TOKEN";
	
	//二维码ticket接口
	public static String qrcode_create = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=TOKEN";

	//二维码图片获取接口
	public static String qrcode_show = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=TICKET";
	
	//获取关注着列表
	public static String user_get = "https://api.weixin.qq.com/cgi-bin/user/get?access_token=ACCESS_TOKEN&next_openid=NEXT_OPENID";
	
	//--------------------------LinkedIn--------------------------
	//LinkedIn
	public static String linked_authorize_access_token = "https://api.linkedin.com/uas/oauth/requestToken";
	
	//下载图片
	public static String download_media="http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=ACCESS_TOKEN&media_id=MEDIA_ID";
	/**
	 * 发起https请求并获取结果
	 * 
	 * @param requestUrl
	 *            请求地址
	 * @param requestMethod
	 *            请求方式（GET、POST）
	 * @param outputStr
	 *            提交的数据
	 * @return JSONObject(通过JSONObject.get(key)的方式获取json对象的属性值)
	 */
	public static JSONObject httpsRequest(String requestUrl, String requestMethod, String outputStr) {
		JSONObject jsonObject = null;
		StringBuffer buffer = new StringBuffer();
		try {
			// 创建SSLContext对象，并使用我们指定的信任管理器初始化
			TrustManager[] tm = { new WxX509TrustManager() };
			SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");
			sslContext.init(null, tm, new java.security.SecureRandom());
			// 从上述SSLContext对象中得到SSLSocketFactory对象
			SSLSocketFactory ssf = sslContext.getSocketFactory();

			URL url = new URL(requestUrl);
			HttpsURLConnection httpUrlConn = (HttpsURLConnection) url
					.openConnection();
			httpUrlConn.setSSLSocketFactory(ssf);

			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setUseCaches(false);
			// 设置请求方式（GET/POST）
			httpUrlConn.setRequestMethod(requestMethod);

			if ("GET".equalsIgnoreCase(requestMethod))
				httpUrlConn.connect();

			// 当有数据需要提交时
			if (null != outputStr) {
				OutputStream outputStream = httpUrlConn.getOutputStream();
				// 注意编码格式，防止中文乱码
				outputStream.write(outputStr.getBytes("UTF-8"));
				outputStream.close();
			}

			// 将返回的输入流转换成字符串
			InputStream inputStream = httpUrlConn.getInputStream();
			InputStreamReader inputStreamReader = new InputStreamReader(
					inputStream, "utf-8");
			BufferedReader bufferedReader = new BufferedReader(
					inputStreamReader);

			String str = null;
			while ((str = bufferedReader.readLine()) != null) {
				buffer.append(str);
			}
			bufferedReader.close();
			inputStreamReader.close();
			// 释放资源
			inputStream.close();
			inputStream = null;
			httpUrlConn.disconnect();
			log.info("WxUtil ----------- httpsRequest --> " + buffer.toString());
			jsonObject = JSONObject.fromObject(buffer.toString());
			
		} catch (ConnectException ce) {
			log.error("Weixin server connection timed out.");
		} catch (Exception e) {
			log.error("https request error:{}", e);
		}
		return jsonObject;
	}
	
	/** 
     * 发起http get请求获取网页源代码 
     *  
     * @param requestUrl 
     * @return 
     */  
    public static String httpRequest(String requestUrl) {  
        StringBuffer buffer = null;  
  
        try {  
            // 建立连接  
            URL url = new URL(requestUrl);  
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();  
            httpUrlConn.setDoInput(true);  
            httpUrlConn.setRequestMethod("GET");  
  
            // 获取输入流  
            InputStream inputStream = httpUrlConn.getInputStream();  
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");  
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);  
  
            // 读取返回结果  
            buffer = new StringBuffer();  
            String str = null;  
            while ((str = bufferedReader.readLine()) != null) {  
                buffer.append(str);  
            }  
  
            // 释放资源  
            bufferedReader.close();  
            inputStreamReader.close();  
            inputStream.close();  
            httpUrlConn.disconnect();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return buffer.toString();  
    }
    
    /**
     * 获取百度天气
     * @param requestUrl
     * @return
     */
    public static JSONObject httpsRequest(String requestUrl,String requestMethod) {  
        StringBuffer buffer = null;  
        JSONObject jsonObject = null;
        try {  
            // 建立连接  
            URL url = new URL(requestUrl);  
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();  
            httpUrlConn.setDoInput(true);  
            httpUrlConn.setRequestMethod(requestMethod);  
  
            // 获取输入流  
            InputStream inputStream = httpUrlConn.getInputStream();  
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");  
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);  
  
            // 读取返回结果  
            buffer = new StringBuffer();  
            String str = null;  
            while ((str = bufferedReader.readLine()) != null) {  
                buffer.append(str);  
            }  
  
            // 释放资源  
            bufferedReader.close();  
            inputStreamReader.close();  
            inputStream.close();  
            httpUrlConn.disconnect();  
            jsonObject = JSONObject.fromObject(buffer.toString());
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return jsonObject;  
    }

	/**
	 * 获取access_token
	 * 
	 * @param appid
	 *            凭证
	 * @param appsecret
	 *            密钥
	 * @return
	 */
	public static AccessToken getAccessToken(String appid, String appsecret) {
		AccessToken accessToken = null;
		
		// 调用接口获取access_token
		String tokenstr = "";
//		Object tokenobj = EhcacheUtil.get("access_token_wx");
//		if(null != tokenobj){
//			tokenstr = (String)tokenobj; 
//			log.info("tokenstr =>" + tokenstr);//访问令牌 过期时间为 2个小时 大于 我们系统的缓存时间
//			accessToken = new AccessToken();
//			accessToken.setToken(tokenstr);
//			return  accessToken;
//		}
		
		String requestUrl = access_token_url.replace("APPID", appid).replace(
				"APPSECRET", appsecret);
		log.info("getAccessToken requestUrl =>  is : " + requestUrl);
		JSONObject jsonObject = httpsRequest(requestUrl, "GET", null);
		log.info("getAccessToken jsonObject =>  is : " + jsonObject);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				accessToken = new AccessToken();
				accessToken.setToken(jsonObject.getString("access_token"));
				accessToken.setExpiresIn(jsonObject.getInt("expires_in"));
			} catch (JSONException e) {
				accessToken = null;
				// 获取token失败
				log.error("获取token失败04 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return accessToken;
	}
	
	/**
	 * 获取access_token str
	 * 
	 * @param appid
	 *            凭证
	 * @param appsecret
	 *            密钥
	 * @return
	 */
	public static String getAccessTokenStr(String appid, String appsecret) {
		log.info("appid = > " + appid);
		log.info("appsecret = > " + appsecret);
		// 调用接口获取access_token
		String access_token = RedisCacheUtil.getString("ACCESS_TOKEN_WX");
		log.info("redis access_token key ACCESS_TOKEN_WX = > " + access_token);
		if(org.apache.commons.lang.StringUtils.isNotBlank(access_token)){
			return access_token;
		}
		//请求url
		String requestUrl = access_token_url.replace("APPID", appid).replace("APPSECRET", appsecret);
		log.info("getAccessTokenStr requestUrl =>  is : " + requestUrl);
		JSONObject jsonObject = httpsRequest(requestUrl, "GET", null);
		log.info("getAccessTokenStr jsonObject =>  is : " + jsonObject);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				access_token = jsonObject.getString("access_token");
				if(org.apache.commons.lang.StringUtils.isNotBlank(access_token)){
					RedisCacheUtil.setString("ACCESS_TOKEN_WX", access_token, 7200);
				}
			} catch (JSONException e) {
				access_token = "";
				log.error("获取token失败05 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		log.info("redis access_token = > " + access_token);
		return access_token;
	}
	
	/**
	 * 获取jsapi_ticket str
	 * 
	 * @param appid
	 *            凭证
	 * @param appsecret
	 *            密钥
	 * @return
	 */
	public static String getJsapiTicket(String access_token) {
		log.info("access_token = > " + access_token);
		// 调用接口获取access_token
		String jsapi_ticket = RedisCacheUtil.getString("JSAPI_TICKET_WX");
		log.info("redis jsapi_ticket key JSAPI_TICKET_WX = > " + jsapi_ticket);
		if(org.apache.commons.lang.StringUtils.isNotBlank(jsapi_ticket)){
			return jsapi_ticket;
		}
		//请求url
		String requestUrl = jsapi_ticket_url.replace("ACCESS_TOKEN", access_token);
		log.info("getJsapiTicket requestUrl =>  is : " + requestUrl);
		JSONObject jsonObject = httpsRequest(requestUrl, "GET", null);
		log.info("getJsapiTicket jsonObject =>  is : " + jsonObject);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				jsapi_ticket = jsonObject.getString("ticket");
				if(org.apache.commons.lang.StringUtils.isNotBlank(jsapi_ticket)){
					RedisCacheUtil.setString("JSAPI_TICKET_WX", jsapi_ticket, 7200);
				}
			} catch (JSONException e) {
				jsapi_ticket = "";
				log.error("获取token失败06 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		log.info(" jsapi_ticket = > " + jsapi_ticket);
		return jsapi_ticket;
	}

	/**
	 * 创建菜单
	 * 
	 * @param menu
	 *            菜单实例
	 * @param accessToken
	 *            有效的access_token
	 * @return 0表示成功，其他值表示失败
	 */
	public static int createMenu(Menu menu, String accessToken) {
		int result = 0;

		// 拼装创建菜单的url
		String url = menu_create_url.replace("ACCESS_TOKEN", accessToken);
		// 将菜单对象转换成json字符串
		String jsonMenu = JSONObject.fromObject(menu).toString();
		log.info("url =>" + url);
		log.info("jsonMenu =>" + jsonMenu);
		// 调用接口创建菜单
		JSONObject jsonObject = httpsRequest(url, "POST", jsonMenu);

		if (null != jsonObject) {
			if (0 != jsonObject.getInt("errcode")) {
				result = jsonObject.getInt("errcode");
				log.error("获取token失败07 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}

		return result;
	}
	
	/**
	 * 获取用户基本信息接口
	 * 
	 * @param openId
	 *            普通用户的标识，对当前公众号唯一
	 * @param accessToken
	 *            有效的access_token
	 * @return 0表示成功，其他值表示失败
	 */
	public static UserInfo getUserInfo(String openId, String accessToken){
		UserInfo userInfo = null;
		// 拼装获取用户基本信息的url
		String url = user_info_url.replace("ACCESS_TOKEN", accessToken).replace("OPENID", openId);
		log.info("getUserInfo url =>" + url);
		//调用接口获取用户信息
		JSONObject jsonObject = httpsRequest(url, "GET", null);
		log.info("getUserInfo rst url =>" + jsonObject.toString());
		// 如果请求成功
		if (null != jsonObject) {
			try {
				userInfo = new UserInfo();
				userInfo.setSubscribe(jsonObject.getInt("subscribe"));
				userInfo.setOpenId(jsonObject.getString("openid"));
				userInfo.setNickname(jsonObject.getString("nickname"));
				userInfo.setSex(jsonObject.getInt("sex"));
				userInfo.setCity(jsonObject.getString("city"));
				userInfo.setCountry(jsonObject.getString("country"));
				userInfo.setProvince(jsonObject.getString("province"));
				userInfo.setLanguage(jsonObject.getString("language"));
				userInfo.setHeadImgurl(jsonObject.getString("headimgurl"));
				userInfo.setSubscribeTime(jsonObject.getLong("subscribe_time"));
				if(null!=jsonObject.get("unionid")){
					userInfo.setUnionid(jsonObject.getString("unionid"));
				}
			} catch (JSONException e) {
				userInfo = null;
				// 获取token失败
				log.error("获取token失败08 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return userInfo;
	}
	
	/**
	 * 第一步：用户同意授权，获取code
	 * @param appId
	 * @param redirectUri
	 * @param scope
	 * @param state
	 */
	public static String getAuthCodeUrl(String scope, String state){
		//第一步：用户同意授权，获取code
		// 拼装获取code的url
		String url =  authorize_code.replace("APPID", Constants.APPID).replace("REDIRECT_URI", Constants.REDIRECTURI);
		       url =  url.replace("SCOPE", scope).replace("STATE", state);
		log.info("getAuthCodeUrl =:>" + url);
	    //调用接口获取用户信息
		return url;
	}
	
	/**
	 * 第二步：通过code换取网页授权access_token
	 * @param appId
	 * @param secret
	 * @param code
	 */
	public static AuthorizeInfo getAccessToken(String appId, String secret, String code){
		AuthorizeInfo auth = null;
		// 第二步：通过code换取网页授权access_token
		// 拼装获取access_token 的url
		String url =  authorize_access_token.replace("APPID", appId).replace("SECRET", secret).replace("CODE", code);
		log.info("getAccessToken url=:>" + url);
		//调用接口获取access_token
		JSONObject jsonObject = httpsRequest(url, "GET", null);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				auth = new AuthorizeInfo();
				auth.setAccessToken(jsonObject.getString("access_token"));
				auth.setExpiresIn(jsonObject.getInt("expires_in"));
				auth.setRefreshToken(jsonObject.getString("refresh_token"));
				auth.setOpenId(jsonObject.getString("openid"));
				auth.setScope(jsonObject.getString("scope"));
				
			} catch (JSONException e) {
				auth = null;
				// 获取token失败
				log.error("获取token失败09 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return auth;
	}
	
	
	/**
	 * 第二步：通过code换取网页授权access_token
	 * @param appId
	 * @param secret
	 * @param code
	 */
	public static AuthorizeInfo getNewAccessToken(String appId, String secret, String code) throws Exception{
		AuthorizeInfo auth = null;
		// 第二步：通过code换取网页授权access_token
		// 拼装获取access_token 的url
		String url =  authorize_access_token.replace("APPID", appId).replace("SECRET", secret).replace("CODE", code);
		log.info("getAccessToken url=:>" + url);
		//调用接口获取access_token
		JSONObject jsonObject = httpsRequest(url, "GET", null);
		// 如果请求成功
		if (null != jsonObject) {
			auth = new AuthorizeInfo();
			auth.setAccessToken(jsonObject.getString("access_token"));
			auth.setExpiresIn(jsonObject.getInt("expires_in"));
			auth.setRefreshToken(jsonObject.getString("refresh_token"));
			auth.setOpenId(jsonObject.getString("openid"));
			auth.setScope(jsonObject.getString("scope"));
		}
		return auth;
	}
	
	
	/**
	 * 获取LinkedIn Access Token
	 * @param appId
	 * @param secret
	 * @param code
	 * @return
	 */
	public static AuthorizeInfo getLinkedInAccessToken(String appId, String secret, String code){
		AuthorizeInfo auth = null;
		// 第二步：通过code换取网页授权access_token
		// 拼装获取access_token 的url
		String url =  linked_authorize_access_token;
		log.info("getLinkedInAccessToken url=:>" + url);
		//调用接口获取access_token
		JSONObject jsonObject = httpsRequest(url, "POST", null);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				auth = new AuthorizeInfo();
				auth.setAccessToken(jsonObject.getString("access_token"));
				auth.setExpiresIn(jsonObject.getInt("expires_in"));
				auth.setRefreshToken(jsonObject.getString("refresh_token"));
				auth.setOpenId(jsonObject.getString("openid"));
				auth.setScope(jsonObject.getString("scope"));
				
			} catch (JSONException e) {
				auth = null;
				// 获取token失败
				log.error("获取 LinkedIn AccessToken失败 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return auth;
	}
	
	
	/**
	 * 第三步：刷新access_token（如果需要）
	 * @param appId
	 * @param refreshToken
	 */
	public static AuthorizeInfo refreshToken(String appId, String refreshToken){
		AuthorizeInfo auth = null;
		//第三步：刷新access_token（如果需要）
		// 拼装刷新access_token 的url
		String url =  authorize_refresh_token.replace("APPID", appId).replace("REFRESH_TOKEN", refreshToken);
		log.info("refreshToken url=:>" + url);
		//调用刷新access_token
		JSONObject jsonObject = httpsRequest(url, "GET", null);
		// 如果请求成功
		if (null != jsonObject) {
			try {
				auth = new AuthorizeInfo();
				auth.setAccessToken(jsonObject.getString("access_token"));
				auth.setExpiresIn(jsonObject.getInt("expires_in"));
				auth.setRefreshToken(jsonObject.getString("refresh_token"));
				auth.setOpenId(jsonObject.getString("openid"));
				auth.setScope(jsonObject.getString("scope"));
				
			} catch (JSONException e) {
				auth = null;
				// 获取token失败
				log.error("获取token失败10 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return auth;
	}
	
	/**
	 * 第四步：拉取用户信息(需scope为 snsapi_userinfo)
	 * @param appId
	 * @param refreshToken
	 */
	public static UserInfo getSnsUserinfo(String openId, String accessToken){
		UserInfo userInfo = null;
		//第四步：拉取用户信息(需scope为 snsapi_userinfo)
		String url =  authorize_userinfo.replace("OPENID", openId).replace("ACCESS_TOKEN", accessToken);
		log.info("getSnsUserinfo url=:>" + url);
		//调用刷新access_token
		JSONObject jsonObject = httpsRequest(url, "GET", null);
		log.info("getSnsUserinfo jsonObject=:>" + jsonObject.toString());
		// 如果请求成功
		if (null != jsonObject) {
			try {
				userInfo = new UserInfo();
				userInfo.setOpenId(jsonObject.getString("openid"));
				userInfo.setNickname(jsonObject.getString("nickname"));
				userInfo.setSex(jsonObject.getInt("sex"));
				userInfo.setCity(jsonObject.getString("city"));
				userInfo.setCountry(jsonObject.getString("country"));
				userInfo.setProvince(jsonObject.getString("province"));
				userInfo.setHeadImgurl(jsonObject.getString("headimgurl"));
				if(null!=jsonObject.get("unionid")){
					userInfo.setUnionid(jsonObject.getString("unionid"));
				}
			} catch (JSONException e) {
				userInfo = null;
				// 获取token失败
				log.error("获取token失败11 errcode:"+ jsonObject.getString("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
		}
		return userInfo;
	}
	
	/**
	 * 发送客服信息
	 * @param accessToken
	 */
	public static void customMsgSend(String accessToken, String openId, String msgContent){
		// 拼装客服消息 的url
		String url =  custom_send.replace("ACCESS_TOKEN", accessToken);
		log.info("customMsgSend url=:>" + url);
		// 将文本消息转换成json字符串
		CustText ct = new CustText();
		ct.setContent(msgContent);
		
		CustTextMessage ctextMsg = new CustTextMessage();
		ctextMsg.setTouser(openId);
		ctextMsg.setMsgtype(WxMsgUtil.RESP_MESSAGE_TYPE_TEXT);
		ctextMsg.setText(ct);
		
		String jsonTextMsg = JSONObject.fromObject(ctextMsg).toString();
		log.info("jsonTextMsg =>" + jsonTextMsg);
		
		// 调用接口发送客服消息
		httpsRequest(url, "POST", jsonTextMsg);
	}
	
	/**
	 * 发送图文客服信息
	 * @param accessToken
	 */
	public static void customArticleMsgSend(String accessToken, String openId, List<Article> list,String tpurl){
		// 拼装客服消息 的url
		String url =  custom_send.replace("ACCESS_TOKEN", accessToken);
		log.info("customMsgSend url=:>" + url);
		// 将文本消息转换成json字符串
		CustArticle[] articles = new CustArticle[list.size()];		
		for(int i=0;i<list.size();i++){
			Article article = list.get(i);
			CustArticle ct = new CustArticle();
			ct.setTitle(article.getTitle());
			ct.setDescription(article.getDescription());
			ct.setPicurl(article.getPicUrl());
			if(StringUtils.isNotNullOrEmptyStr(article.getUrl())){
				ct.setUrl(article.getUrl()+tpurl);
			}else{
				ct.setUrl("");
			}
			articles[i]=ct;
		}
		CustNews custNews = new CustNews();
		custNews.setArticles(articles);
		CustNewsMessage custNewsMessage = new CustNewsMessage();
		custNewsMessage.setTouser(openId);
		custNewsMessage.setMsgtype(WxMsgUtil.RESP_MESSAGE_TYPE_NEWS);
		custNewsMessage.setNews(custNews);
		String jsonTextMsg = JSONObject.fromObject(custNewsMessage).toString();
		log.info("customArticleMsgSend jsonTextMsg =>" + jsonTextMsg);
		// 调用接口发送客服消息
		httpsRequest(url, "POST", jsonTextMsg);
	}
	
	/**
	 * 发送模板信息
	 * @param accessToken
	 */
	public static JSONObject templateMsgSend(TemplateText ct){
		AccessToken acc = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		// 拼装客服消息 的url
		String url =  template_msg_send.replace("ACCESS_TOKEN", acc.getToken());
		log.info("templateMsgSend url=:>" + url);
		String jsonTextMsg = JSONObject.fromObject(ct).toString();
		log.info("jsonTextMsg =>" + jsonTextMsg);
		// 调用接口发送客服消息
		return httpsRequest(url, "POST", jsonTextMsg);
	}
	
	/**
	 * 创建二维码ticket
	 * @param accessToken
	 * @param type 二维码类型，QR_SCENE为临时,QR_LIMIT_SCENE为永久
	 * @return
	 */
	public static QrCode qrcodeCreate(String accessToken, String type){
		QrCode qrCode = null;
		// 拼装创建二维码 的url
		String url =  qrcode_create.replace("TOKEN", accessToken);
		log.info("qrcodeCreate url=:>" + url);
		
		// 将穿件二维码转换成json字符串
		QrCodeScene scene = new QrCodeScene();
		scene.setSceneId("123");
		QrCodeAction action = new QrCodeAction();
		action.setScene(scene);
		QrCodeReq req = new QrCodeReq();
		/*if("QR_SCENE".equals(type))
			req.setExpireSeconds(new Integer(1800));*/
		req.setAction_name(type);
		req.setAction_info(action);
		
		String jsonQrCode = JSONObject.fromObject(req).toString();
		log.info("jsonQrCode =>" + jsonQrCode);
		// 调用接口创建二维码
		JSONObject jsonObject = httpsRequest(url, "POST", jsonQrCode);
		log.info("ticket =>" + jsonObject.getString("ticket"));
		// 如果请求成功
		if (null != jsonObject) {
			log.info("ticket =>" + jsonObject.getString("ticket"));
			try {
				qrCode = new QrCode();
				qrCode.setTicket(jsonObject.getString("ticket"));
				//qrCode.setExpireSeconds(jsonObject.getInt("expire_seconds"));
				log.info("ticket =>" + jsonObject.getString("ticket"));
			} catch (JSONException e) {
				qrCode = null;
				// 获取token失败
				log.error("获取token失败12 errcode:"+ jsonObject.getInt("errcode") +",errmsg:"+ jsonObject.getString("errmsg"));
			}
			log.info("ticket =>" + jsonObject.getString("ticket"));
		}
		log.info("ticket =>" + jsonObject.getString("ticket"));
		return qrCode;
	}
	
	/**
	 * 获取二维码图片信息 下载到本地
	 * @param ticket
	 */
	public static String qrcodeShow(String ticket){
		String filePath = null;
		try {
			System.setProperty ("jsse.enableSNIExtension", "false");
			// 拼装获取二维码图片 的url
			String requestUrl =  qrcode_show.replace("TICKET",  URLEncoder.encode(ticket, "utf-8"));
			log.info("qrcodeShow url=:>" + requestUrl);
			String savePath = PropertiesUtil.getAppContext("app.savePath");
			log.info("qrcodeShow savePath=:>" + savePath);
		
			/*URL url = new URL(requestUrl);
			HttpsURLConnection httpUrlConn = (HttpsURLConnection) url
					.openConnection();
			// 设置请求方式（GET/POST）
			httpUrlConn.setRequestMethod("GET");*/
			
			// 创建SSLContext对象，并使用我们指定的信任管理器初始化
			TrustManager[] tm = { new WxX509TrustManager() };
			SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");
			sslContext.init(null, tm, new java.security.SecureRandom());
			// 从上述SSLContext对象中得到SSLSocketFactory对象
			SSLSocketFactory ssf = sslContext.getSocketFactory();

			URL url = new URL(requestUrl);
			HttpsURLConnection httpUrlConn = (HttpsURLConnection) url
					.openConnection();
			httpUrlConn.setSSLSocketFactory(ssf);

			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setUseCaches(false);
			// 设置请求方式（GET/POST）
			httpUrlConn.setRequestMethod("GET");

			if(!savePath.endsWith("/")){
				savePath += "/";
			}
			//将ticket做为文件名
			filePath = savePath + ticket + ".jpg";
			log.info("qrcodeShow filePath=:>" + filePath);
			//将微信服务器返回的的输入流写入文件
			BufferedInputStream bis = new BufferedInputStream(httpUrlConn.getInputStream());
			log.info("qrcodeShow bis=:>" + bis);
			FileOutputStream fos = new FileOutputStream(new File(filePath));
			log.info("qrcodeShow fos=:>" + fos);
			byte[] buf = new byte[8096];
			int size = 0;
			log.info("qrcodeShow size=:>" + size);
			while((size = bis.read(buf)) != -1){
				fos.write(buf, 0 ,size);
				log.info("qrcodeShow 02=:>");
			}
			log.info("qrcodeShow 01=:>");
			fos.close();
			bis.close();
		}catch (Exception e) {
			filePath = null;
			log.info("error msg =:>" + e.getMessage());
		}
		log.info("qrcodeShow end filePath is =:> " + filePath);
		return filePath;
	}
	
	/**
	 * 获取公众好关注者列表
	 * @param ticket
	 */
	public static UserGet userGet(String nextopenid, AccessToken acc){
		UserGet ug = new UserGet();
		// 拼装客服消息 的url
		String url =  user_get.replace("ACCESS_TOKEN", acc.getToken());
			   url = url.replace("NEXT_OPENID", nextopenid);
		log.info("userGet url=:>" + url);
		//调用刷新access_token
		JSONObject jb = httpsRequest(url, "GET", null);
		String total = jb.getString("total");
		String count = jb.getString("count");
		String next_openid = jb.getString("next_openid");
		JSONObject data = jb.getJSONObject("data");
		JSONArray openid = data.getJSONArray("openid");
		//结果
		List<String> openidlist = new ArrayList<String>();
		for(int i = 0; i < openid.size(); i++){
			String id = openid.getString(i);
			openidlist.add(id);
		}
		ug.setTotal(total);
		ug.setCount(count);
		ug.setNext_openid(next_openid);
		ug.setOpenidlist(openidlist);
		
		return ug;
	}
	
	/**
	 * 将图转换成BASE6位编码
	 * @param imageurl
	 * @return
	 */
	public static String httpsRequestImger(String imageurl) {
		String rst = "";
		BASE64Encoder encoder = new sun.misc.BASE64Encoder();
		try {
			//new一个URL对象  
			URL url = new URL(imageurl);  
			//打开链接  
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
			//设置请求方式为"GET"  
			conn.setRequestMethod("GET");  
			//超时响应时间为5秒  
			conn.setConnectTimeout(5 * 1000);  
			//通过输入流获取图片数据  
			InputStream inStream = conn.getInputStream();  
			//得到图片的二进制数据，以二进制封装得到数据，具有通用性  
			//byte[] data = readInputStream(inStream);  
			
			Image src = javax.imageio.ImageIO.read(inStream); //构造Image对象
        	BufferedImage tag = new BufferedImage(48,48,BufferedImage.TYPE_INT_RGB);
        	tag.getGraphics().drawImage(src,0,0,48,48,null);       //绘制缩小后的图
        	//将生成的缩略成转换成流
        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
        	//String type = fileName.substring(fileName.lastIndexOf("."),fileName.length());
        	ImageIO.write(tag,"jpeg",imOut); //scaledImage1为BufferedImage
        	
			rst = encoder.encodeBuffer(bs.toByteArray()).trim(); 
			
			inStream.close();
		} catch (Exception e) {
			rst = "";
		}
		return rst;
	}
	
	/**
	 * 压缩微信图片
	 * @param imageurl
	 * @return
	 */
	public static String compressImger(String imageurl)
	{
		String rst = "";//返回的信息
		InputStream inStream = null;
		try
		{
			//new一个URL对象  
			URL url = new URL(imageurl);  
			//打开链接  
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
			//设置请求方式为"GET"  
			conn.setRequestMethod("GET");  
			//超时响应时间为5秒  
			conn.setConnectTimeout(5 * 1000);  
			//通过输入流获取图片数据  
			inStream = conn.getInputStream();  
			//得到图片的二进制数据，以二进制封装得到数据，具有通用性  
			//byte[] data = readInputStream(inStream);  
			
			Image src = javax.imageio.ImageIO.read(inStream); //构造Image对象
			
			//压缩
			int width = src.getWidth(null);
			int height = src.getHeight(null);
			if (Constants.NEED_COMPRESS) 
			{
				if (width > Constants.DEFAULT_WIDTH) 
				{
					width = Constants.DEFAULT_WIDTH;
				}
				if (height > Constants.DEFAULT_HEIGHT) 
				{
					height = Constants.DEFAULT_HEIGHT;
				}
				
				Image image = src.getScaledInstance(width, height,
						Image.SCALE_SMOOTH);
				src = image;
			}
			
        	//将生成的缩略成转换成流
        	BufferedImage tag = new BufferedImage(Constants.DEFAULT_WIDTH,Constants.DEFAULT_HEIGHT,BufferedImage.TYPE_INT_RGB);
        	tag.getGraphics().drawImage(src,0,0,Constants.DEFAULT_WIDTH,Constants.DEFAULT_HEIGHT,null);
        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
        	ImageIO.write(tag,"jpeg",imOut); 
        	InputStream in = new ByteArrayInputStream(bs.toByteArray());
        	
        	//将流ftp到服务器
        	String fileName = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32BeginTimePK()+".jpeg";
        	
        	//ftp上传
        	FTPUtil fu = new FTPUtil();  
        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
        	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, in))
        	{
        		fu.closeFTP(ftp);
        		log.info("WxUtil compressImger method 上传后文件名: "+fileName);
        		rst = fileName;
        	}
        	else
        	{
        		fu.closeFTP(ftp);
        		log.info("WxUtil compressImger method 上传失败.");
        		rst = "";
        	}
		} 
		catch (Exception e) 
		{
			rst = "";
		}
		finally
		{
			//关闭流
			if (null != inStream)
			{
				try
				{
					inStream.close();
				}
				catch(Exception ex)
				{
					inStream = null;
				}
			}
		}
		
		return rst;
	}
	
	/**
	 * 下载图片
	 * @param accessToken
	 */
	public static byte[] downloadMedia(String mediaId){
		AccessToken acc = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		// 拼装客服消息 的url
		String url =  download_media.replace("ACCESS_TOKEN", acc.getToken()).replace("MEDIA_ID",mediaId);
		log.info("downloadMedia url=:>" + url);
		
		// 调用接口发送客服消息
		return httpsRequestImage(url);
	}
	
	/**
	 * 将图转换成BASE6位编码
	 * @param imageurl
	 * @return
	 */
	public static byte[] httpsRequestImage(String imageurl) {
		try {
			//new一个URL对象  
			URL url = new URL(imageurl);  
			//打开链接  
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
			//设置请求方式为"GET"  
			conn.setRequestMethod("GET");  
			//超时响应时间为5秒  
			conn.setConnectTimeout(5 * 1000);  
			//通过输入流获取图片数据  
			InputStream inStream = conn.getInputStream();  
			//得到图片的二进制数据，以二进制封装得到数据，具有通用性  
			ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
			byte[] data = new byte[1024];
			int count = -1;  
			while((count = inStream.read(data,0,1024)) != -1)  
	            outStream.write(data, 0, count);  
	          
	        data = null; 
	        // 关闭输入流
	     	inStream.close();
	        return outStream.toByteArray(); 

		} catch (Exception e) {
			log.error(e.toString());;
		}
		return null;
	}
	
	/*
	private static byte[] readInputStream(InputStream inStream) throws Exception {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		// 创建一个Buffer字符串
		byte[] buffer = new byte[1024];
		// 每次读取的字符串长度，如果为-1，代表全部读取完毕
		int len = 0;
		// 使用一个输入流从buffer里把数据读取出来
		while ((len = inStream.read(buffer)) != -1) {
			// 用输出流往buffer里写入数据，中间参数代表从哪个位置开始读，len代表读取的长度
			outStream.write(buffer, 0, len);
		}
		// 关闭输入流
		inStream.close();
		// 把outStream里的数据写入内存
		return outStream.toByteArray();
	}
	*/
}
