package com.takshine.wxcrm.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PhoneUtil;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJDateUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;

/**
 * 首页页面控制器
 * 
 * @author [ Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/home")
public class MainController {
	// 日志
	protected static Logger logger = Logger.getLogger(MainController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 *
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/index")
	public String index(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String code = request.getParameter("code");
		logger.info(" MainController getCode code => " + code); 
	      
		//防止出现换账号，信息还是原来的问题
		AuthorizeInfo auth = null;
		if (StringUtils.isNotNullOrEmptyStr(code)){
			auth = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET, code);
			
			if(auth == null){
				logger.info(" MainController auth is null");
				//跳转到隐式授权
				String return_url = PropertiesUtil.getAppContext("app.content") + "/home/index";
				logger.info(" return_url = >" + return_url);
				try {
					return_url = URLEncoder.encode(return_url,"UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
				return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
			}else{
				logger.info(" MainController getCode AccessToken => " + auth.getAccessToken());
				logger.info(" MainController getCode  openId => " + auth.getOpenId());
			}
			
			//logger.info(" MainController getCode AccessToken => " + auth.getAccessToken());
			//logger.info(" MainController getCode  openId => " + auth.getOpenId());

			if(UserUtil.hasCurrUser(request)){
				logger.info(" MainController set curruser session => ");
				WxuserInfo wxuser = UserUtil.getCurrUser(request);
				if (wxuser!=null && wxuser.getOpenId()!=null && !wxuser.getOpenId().equals(auth.getOpenId())){
					UserUtil.setSessionWxuserInfo(request, null);
					UserUtil.setUserCookie(response, null);
				}
			}
		}
		
		WxuserInfo user = null;
		//获取cookie;
		String party_user_id = null;//UserUtil.getUserCookie(request);
		//取当前session
		if(UserUtil.hasCurrUser(request)){
			logger.info(" MainController session entr => " + party_user_id);
			party_user_id = UserUtil.getCurrUser(request).getParty_row_id();
		}
		/*//验证cookie
		else if(StringUtils.isNotNullOrEmptyStr(party_user_id)){
			logger.info(" MainController cookies entr => " + party_user_id);
			UserUtil.setCurrUserByPartyId(request, party_user_id, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
		}*/
		//微信授权进来
		else if (auth!=null) {
			logger.info(" MainController auth entr => ------------------");
			String openId = auth.getOpenId();
			//根据openId，获取用户信息
			user = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
			if(null == user || !StringUtils.isNotNullOrEmptyStr(user.getParty_row_id())){
				//没有找到partyId，跳转到显示授权
				String return_url = PropertiesUtil.getAppContext("app.content") + "/home/index";
				try {
					return_url = URLEncoder.encode(return_url,"UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
				return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
			}
			party_user_id = user.getParty_row_id();		
			//设置session
			UserUtil.setCurrUser(request, user, openId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
			//设置缓存
			UserUtil.setUserCookie(response,party_user_id);
			
			
		}else{
			logger.info(" MainController to weixin auth-------------");
			//跳转到隐式授权
			String return_url = PropertiesUtil.getAppContext("app.content") + "/home/index";
			try {
				return_url = URLEncoder.encode(return_url,"UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
		}
		
		// 判断用户是否浏览过版本更新
//		Versions ver = versionsService.findCurrentVersions();
//		if (null != ver && null != ver.getVer_number()) {
//			String userVer = RedisCacheUtil.getString(party_user_id + "_version");
//			if (null == userVer || "".equals(userVer)
//					|| !userVer.equals(ver.getVer_number())) {
//				RedisCacheUtil.setString(party_user_id + "_version",
//						ver.getVer_number());
//				// 获取版本内容
//				VersionsContent vc = new VersionsContent();
//				vc.setVer_id(ver.getId());
//				List<VersionsContent> vcList = versionsContentService
//						.findVersionsContentList(vc);
//				if (null != vcList && vcList.size() > 0) {
//					request.setAttribute("vcSize", vcList.size());
//					request.setAttribute("vcList", vcList);
//					return "/home/guide";
//				}
//			}
//		}

		// 跳转到验证页面 //只有开发和UAT环境有效，生产需要关闭
		String valiflag = PropertiesUtil.getAppContext("zjwk.valiflag");
		if("open".equals(valiflag)){
			String valicodeval = request.getParameter("valicode");
			logger.info("valicodeval = >" + valicodeval);
			if (!StringUtils.isNotNullOrEmptyStr(valicodeval)) {
				String vc = RedisCacheUtil.getString("ZJWK_VALICODE_OPENID_"+ party_user_id);
				logger.info("vc = >" + vc);
				if (StringUtils.isNotNullOrEmptyStr(vc)) {
					valicodeval = vc;
				}
			}
			//
			logger.info("valicode = >" + valiflag);
			logger.info("valicodeval = >" + valicodeval);
			if (!StringUtils.isNotNullOrEmptyStr(valicodeval)) {
				request.setAttribute("partyId", party_user_id);
				return "home/valicode";
			}
		}
		
		//验证用户名片信息是否完善，如果未完善，则引导完善名片
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(party_user_id);
		bc.setStatus("0");
		List<BusinessCard> cardList = cRMService.getDbService().getBusinessCardService().getList(bc);
		boolean isExistsCard = false;
		if(null != cardList && cardList.size() > 0){
			bc = cardList.get(0);
		/*	if(StringUtils.isNotNullOrEmptyStr(bc.getPhone()) && StringUtils.isNotNullOrEmptyStr(bc.getName())){
				isExistsCard = true;
			}*/
			//上药取消手机必填
			if(StringUtils.isNotNullOrEmptyStr(bc.getName())){
				isExistsCard = true;
			}
		}
		if(!isExistsCard){
			String redirectUrl = URLEncoder.encode("home/index", "UTF-8");
			return "redirect:/businesscard/card?redirectUrl="+redirectUrl;
		}
		
		Calendar today = Calendar.getInstance();
		
		ZJDateUtil lunar = new ZJDateUtil(today);
		request.setAttribute("openId", UserUtil.getCurrUser(request).getOpenId());
		request.setAttribute("currtime",DateTime.currentDate("MM月dd日"));
		request.setAttribute("currweek", ZJDateUtil.getWeekOfDate(new Date()));
		request.setAttribute("lunar", lunar.toString());
		request.setAttribute("type", "notice");
		request.setAttribute("partyId", party_user_id);
		request.setAttribute("zjrm_url", PropertiesUtil.getAppContext("zjrm.url"));
		request.setAttribute("zjmarketing_url", PropertiesUtil.getAppContext("zjmarketing.url"));
		request.setAttribute("curr_user", UserUtil.getCurrUser(request));
		
		request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
		
		return "home/mindex";
	}
	
	
	@RequestMapping("/more")
	public String more(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("openId", UserUtil.getCurrUser(request).getOpenId());
		request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("zjrm_url", PropertiesUtil.getAppContext("zjrm.url"));
		request.setAttribute("type", "more");
		return "home/mindex";
	}
	
	/**
	 * 获取天气数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getweather")
	@ResponseBody
	public String getweather(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId = request.getParameter("partyId");
		if(StringUtils.isNotNullOrEmptyStr(partyId)){
			WxuserInfo user = new WxuserInfo();
			user.setParty_row_id(partyId);
			user = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(user);
			String city = "";
			//获取天气数据
			if(StringUtils.isNotNullOrEmptyStr(user.getCity())){
				city = user.getCity();
			}else if(StringUtils.isNotNullOrEmptyStr(user.getMobile())){
				city = PhoneUtil.getCityByPhone(user.getMobile());		
			}
			if(StringUtils.isNotNullOrEmptyStr(city)){
				try {
					city = URLEncoder.encode(city,"UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
				String requestUrl = "http://api.map.baidu.com/telematics/v3/weather?location="+city+"&output=json&ak=134eca242394acd37ffbae329150e589";
				return WxUtil.httpRequest(requestUrl);
			}else{
				return "";
			}
		}
		
		return "";
	}
	
	
	/**
	 *
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/valicode")
	public String valicode(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String valicode = request.getParameter("valicode");
		String valithreshold = PropertiesUtil.getAppContext("zjwk.valithreshold");
		logger.info("partyId = >" + partyId);
		logger.info("valicode = >" + valicode);
		logger.info("valithreshold = >" + valithreshold);
		if(!StringUtils.isNotNullOrEmptyStr(valithreshold)){
			valithreshold = "123";
		}
		logger.info("valithreshold aft= >" + valithreshold);
		if(StringUtils.isNotNullOrEmptyStr(valicode) 
				&& valithreshold.equals(valicode)){
			RedisCacheUtil.setString("ZJWK_VALICODE_OPENID_" + partyId, valicode, 3600 * 24 * 3);//暂定三天有效
			return "home/index";
		}
		return "home/valicode";
	}
}
