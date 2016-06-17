package com.takshine.wxcrm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 短链接进入指尖微客 
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/f")
public class WKEntrController {
	
	protected static Logger logger = Logger.getLogger(CustomerController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询微客 用户信息
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/{shortUrl}")
	public String access(@PathVariable String shortUrl, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("WKEntrController ---> shortUrl = >" + shortUrl);
		if(StringUtils.isNotNullOrEmptyStr(shortUrl)){
			Object url = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, shortUrl);
			logger.info("WKEntrController ---> get url = >" + url);
			if(null != url && !"".equals(url)){
				return "redirect:"+url;
			}else{
				throw new Exception(ErrCode.ERR_CODE_999999_MSG);
			}
		}else{
			throw new Exception(ErrCode.ERR_CODE_999999_MSG);
		}
	}
	
	/**
	 * 从分享进来的
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/share")
	public String access(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("WKEntrController  -- share -- begin ----");
		String code = request.getParameter("code");
		String shortUrl = request.getParameter("u");
		logger.info("WKEntrController  -- share -- code ----" + code);
		logger.info("WKEntrController  -- share -- shortUrl ----" + shortUrl);
		if(StringUtils.isNotNullOrEmptyStr(shortUrl)){
			Object url = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, shortUrl);
			logger.info("WKEntrController ---> get url = >" + url);
			if(null != url && !"".equals(url)){
				logger.info("WKEntrController  -- share -- url ----" + url);
				return "redirect:"+url+"&code="+code;
			}else{
				throw new Exception(ErrCode.ERR_CODE_999999_MSG);
			}
		}else{
			throw new Exception(ErrCode.ERR_CODE_999999_MSG);
		}
	}
	
	/**
	 * 从SMS进来的
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sms")
	public String accessSms(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String shortUrl = request.getParameter("u");
		if(StringUtils.isNotNullOrEmptyStr(shortUrl)){
			Object url = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, shortUrl);
			logger.info("WKEntrController ---> get url = >" + url);
			if(null != url && !"".equals(url))
			{
				String urlStr = (String)url;
				int count=0;
			    for(int i=0;i<urlStr.length();i++)
			    {
			    	 if(urlStr.charAt(i)=='=')
			    	 {
						    count++;
			    	 }
			    }
			    
			    if (count == 2)
			    {
			    	String partyId = urlStr.substring(urlStr.indexOf("=")+1,urlStr.indexOf("&"));//取名片所有人的partyId
			    	String relaPartyId = urlStr.substring(urlStr.lastIndexOf("=")+1,urlStr.length());//取分享人的partyId
					if (StringUtils.isNotNullOrEmptyStr(partyId) && StringUtils.isNotNullOrEmptyStr(relaPartyId))
					{
						UserUtil.setCurrUserByPartyId(request, relaPartyId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
						url = url + "&isSys=1";
					}
			    }
			    else if (count == 1)
			    {
			    	String partyId = urlStr.substring(urlStr.indexOf("=")+1,urlStr.length());//去名片所有人的partyId
			    	if (StringUtils.isNotNullOrEmptyStr(partyId))
					{
			    		url = url + "&isSys=0";
					}
			    }
			    else
			    {
			    	//抛错
			    	throw new Exception(ErrCode.ERR_CODE_999999_MSG);
			    }
			    
			    return "redirect:"+url;
			}
			else
			{
				throw new Exception(ErrCode.ERR_CODE_999999_MSG);
			}
		}else{
			throw new Exception(ErrCode.ERR_CODE_999999_MSG);
		}
	}
	
	/**
	 * 取消关注后，通过短信链接进入
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/e")
	public String smsZjwk(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String shortUrl = request.getParameter("u");
		if(StringUtils.isNotNullOrEmptyStr(shortUrl)){
			Object url = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, shortUrl);
			logger.info("WKEntrController ---> get url = >" + url);
			if(null != url && !"".equals(url))
			{
			    return "redirect:"+url;
			}
			else
			{
				throw new Exception(ErrCode.ERR_CODE_999999_MSG);
			}
		}else{
			throw new Exception(ErrCode.ERR_CODE_999999_MSG);
		}
	}
	
	/**
	 * session过期后进入，隐式授权
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/l")
	public String login(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("WKEntrController ---> login = >");
		String code = request.getParameter("code");
		String shortUrl = request.getParameter("u");
		logger.info("WKEntrController ---> shortUrl = >"+shortUrl +"--------code = >" + code);
		if(StringUtils.isNotNullOrEmptyStr(shortUrl) && StringUtils.isNotNullOrEmptyStr(code)){
			Object url = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, shortUrl);
			logger.info("WKEntrController ---> get url = >" + url);
			if(null != url && !"".equals(url)){
				AuthorizeInfo auth = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET, code);
				logger.info("WKEntrController ---> auth.getopenId() = >"+auth.getOpenId());
				if(StringUtils.isNotNullOrEmptyStr(auth.getOpenId())){
					WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(auth.getOpenId());
					if(null == wxuser){
						return "redirect:"+auth();
					}else{
						UserUtil.setCurrUser(request, wxuser, auth.getOpenId(), cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
						return "redirect:"+url;
					}
				}else{
					return "redirect:"+auth();
				}
			}else{
				return "redirect:"+auth();
			}
		}else{
			return "redirect:"+auth();
		}
	}
	
	
	private String auth(){
		//显示授权
		String return_url = PropertiesUtil.getAppContext("app.content") + "home/index";
		String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
		return url;
	}
}
