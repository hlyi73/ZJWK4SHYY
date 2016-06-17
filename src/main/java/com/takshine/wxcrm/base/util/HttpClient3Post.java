package com.takshine.wxcrm.base.util;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
/**
 * 调用短信接口（活动报名的时候，需要填写验证码）
 * @author dengbo
 *
 */
public class HttpClient3Post {
	private static Logger logger = Logger.getLogger(WxHttpConUtil.class.getName());

	/**
	 * 使用http的方式
	 * @param url
	 * @param params
	 * @return
	 */
	public static String request(String url,Map<String, Object> map)throws Exception{
		if(!StringUtils.isNotNullOrEmptyStr(url)){
			url = PropertiesUtil.getMsgContext("service.url1");
		}
		String sn = PropertiesUtil.getMsgContext("service.sn");
		String pwd = PropertiesUtil.getMsgContext("service.pwd");
		pwd = MD5Util.getMD5(sn+pwd);
		String signature = PropertiesUtil.getMsgContext("msg.signature");
		String msgmodule = URLEncoder.encode(map.get("content").toString()+signature, "utf-8");
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new NameValuePair("sn", sn));
		params.add(new NameValuePair("pwd",pwd));
		params.add(new NameValuePair("mobile", map.get("mobile").toString()));
		params.add(new NameValuePair("content",msgmodule));
		params.add(new NameValuePair("ext", ""));
		params.add(new NameValuePair("stime", ""));
		params.add(new NameValuePair("rrid",map.get("code").toString()));
		params.add(new NameValuePair("msgfmt", ""));
		String result = "";
		HttpClient client = new HttpClient();
		PostMethod postMethod = new PostMethod(url);
		logger.info("HttpClient3Post request url ==>"+url);
		logger.info("HttpClient3Post request params ==>"+params);
		postMethod.setRequestBody(params.toArray(new NameValuePair[params.size()]));
		int statusCode = 0;
		try {
			statusCode = client.executeMethod(postMethod);
			logger.info("HttpClient3Post request statusCode ==>"+statusCode);
			if (statusCode == HttpStatus.SC_OK) {
				result = postMethod.getResponseBodyAsString();
				Pattern pattern = Pattern.compile("[0-9]{6}");
				Matcher matcher = pattern.matcher(result);
				while (matcher.find()) {
					result = matcher.group();
				}
				logger.info("HttpClient3Post request result ==>"+result);
				return result;
			} 
		} catch (Exception e) {
			logger.info("HttpClient3Post requests errorMsg ==>"+e.getMessage());
			if(url.contains("2")){
				return result;
			}
			request(PropertiesUtil.getAppContext("service.url2"), map);
		}
		postMethod.releaseConnection();
		return result;
	}
}
