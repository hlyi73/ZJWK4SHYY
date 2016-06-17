package com.takshine.wxcrm.controller;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.WxUtil;

@Controller
@RequestMapping("wxjs")
public class WxJsSignController {
	// 日志
	protected static Logger log = Logger.getLogger(WxJsSignController.class.getName());
	
	/**
	 * 添加业务机会
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getsign")
	@ResponseBody
	public String getsign(HttpServletRequest request,HttpServletRequest response) throws Exception  {
		
		String at = WxUtil.getAccessTokenStr(PropertiesUtil.getAppContext("wxcrm.appid"), PropertiesUtil.getAppContext("wxcrm.appsecret"));
		log.info("wxcrm.appid = >" + PropertiesUtil.getAppContext("wxcrm.appid"));
		log.info("wxcrm.appsecret = >" + PropertiesUtil.getAppContext("wxcrm.appsecret"));
		log.info("accesstoken = >" + at);
		String jsapi_ticket = WxUtil.getJsapiTicket(at);
		log.info("jsapi_ticket = >" + jsapi_ticket);
		
		return "success";
	}

    public static Map<String, String> sign(String jsapi_ticket, String url) {
        Map<String, String> ret = new HashMap<String, String>();
        //String nonce_str = create_nonce_str();
        //String timestamp = create_timestamp();
        String timestamp = "1421293201";
        String nonce_str = "e2df797b-26cd-468d-b79f-c65ad1572e35";
        String string1;
        String signature = "";
        log.info("nonce_str => " + nonce_str);
		log.info("timestamp => " + timestamp);
        //注意这里参数名必须全部小写，且必须有序
        string1 = "jsapi_ticket=" + jsapi_ticket +
                  "&noncestr=" + nonce_str +
                  "&timestamp=" + timestamp +
                  "&url=" + url;
        log.info("string1 => " + string1);
        try
        {
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
            crypt.update(string1.getBytes("UTF-8"));
            signature = byteToHex(crypt.digest());
        }catch (NoSuchAlgorithmException e){
            e.printStackTrace();
        }catch (UnsupportedEncodingException e){
            e.printStackTrace();
        }

        ret.put("url", url);
        ret.put("jsapi_ticket", jsapi_ticket);
        ret.put("nonceStr", nonce_str);
        ret.put("timestamp", timestamp);
        ret.put("signature", signature);

        return ret;
    }

    private static String byteToHex(final byte[] hash) {
        Formatter formatter = new Formatter();
        for (byte b : hash)
        {
            formatter.format("%02x", b);
        }
        String result = formatter.toString();
        formatter.close();
        return result;
    }

    private static String create_nonce_str() {
        return UUID.randomUUID().toString();
    }

    private static String create_timestamp() {
        return Long.toString(System.currentTimeMillis() / 1000);
    }
    
    public static void main(String[] args) {
    	String jsapi_ticket = "sM4AOVdWfPE4DxkXGEs8VBcaQw7q-D1hYnkZsFiL88XkoFJ2DJ2qPAQvKTlXtKD3_cdgZ0AFNULH8Ad4CpeYuA";
    	String url = "http://zjwk.takshine.com/ZJWK/oppty/detail?rowId=9673fd9a-de49-4826-3be2-54b79cd0b5b3&openId=oEImns1OmAdJgN9xvuYdTP2wAWv4&publicId=gh_2026ef888e23&orgId=Default%20Organization";
		log.info("url = >" + url);
		Map<String, String> ret = sign(jsapi_ticket, url);
        for (@SuppressWarnings("rawtypes") Map.Entry entry : ret.entrySet()) {
            log.info(entry.getKey() + ", " + entry.getValue());
        }
	}
}
