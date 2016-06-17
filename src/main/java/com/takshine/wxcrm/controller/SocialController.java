package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
import org.springframework.aop.scope.ScopedProxyFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SocialUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.SocialContact;
import com.takshine.wxcrm.domain.SocialTags;
import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.social.SocialUserInfoResp;
import com.takshine.wxcrm.model.SocialContactModel;
import com.takshine.wxcrm.service.SocialContactService;
import com.takshine.wxcrm.service.SocialUserinfoService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 社交化第三方应用
 * 
 * @author [ Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/social")
public class SocialController {
	// 日志
	protected static Logger logger = Logger.getLogger(SocialController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	/*
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/weibo")
	public String weibo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		String openId = request.getParameter("state");
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		logger.info("==SocialController==weibo==code==" + code);
		logger.info("==SocialController==weibo==openId==" + openId);
		logger.info("==SocialController==weibo==publicId==" + publicId);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);		
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(code)) {
				AuthorizeInfo auth = SocialUtil.getWBAccessToken(code);
				logger.info("==SocialController==weibo==access_token==" + auth.getAccessToken());
				logger.info("==SocialController==weibo==expires_in==" + auth.getExpiresIn());
				logger.info("==SocialController==weibo==uid==" + auth.getOpenId());
				request.setAttribute("auth", auth);
				//获取用户信息
				if(null != auth && null != auth.getOpenId()){
					SocialUserInfo wbuser = SocialUtil.getWBUserInfo(auth.getAccessToken(), auth.getOpenId());
					logger.info("==SocialController==weibo==nickname==" + wbuser.getNickname());
					logger.info("==SocialController==weibo==headimgurl==" + wbuser.getHeadimgurl());
					logger.info("==SocialController==weibo==followerscount==" + wbuser.getFollowers_count());
					logger.info("==SocialController==weibo==frientscount==" + wbuser.getFriends_count());
					wbuser.setSocial_type("WEIBO");
					wbuser.setAccess_token(auth.getAccessToken());
					wbuser.setExpires_in(auth.getExpiresIn()+"");
					wbuser.setUid(auth.getOpenId());
					wbuser.setOpenId(openId);
					cRMService.getDbService().getSocialUserinfoService().saveOrUptUserInfo(wbuser);
					request.setAttribute("wbuser", wbuser);
				}
			}
		}else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);

		return "social/sweibo";
	}
	
	
	@RequestMapping("/suser")
	public String userinfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");
		logger.info("==SocialController==userinfo==socialUID==" + socialUID);
		logger.info("==SocialController==userinfo==token==" + token);
		logger.info("==SocialController==userinfo==openId==" + openId);
		logger.info("==SocialController==userinfo==publicId==" + publicId);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);		
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID) && StringUtils.isNotNullOrEmptyStr(token)) {
				SocialUserInfo wbuser = SocialUtil.getWBUserInfo(token,socialUID);
				request.setAttribute("wbuser", wbuser);
			}
		}else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("socialUID", socialUID);
		request.setAttribute("accesstoken", token);
		return "social/suser";
	}
	
	
	/*
	 * 
	 * @param request
	 * 
	 * @param response
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/info")
	public String info(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		logger.info("==SocialController==info==openId==" + openId);
		logger.info("==SocialController==info==publicId==" + publicId);
		logger.info("==SocialController==info==socialUID==" + socialUID);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID)) {
				SocialUserInfo param = new SocialUserInfo();
				param.setUid(socialUID);
				SocialUserInfo wbuser = cRMService.getDbService().getSocialUserinfoService().getWbuserInfo(param);
				logger.info("==SocialController==weibo==nickname==" + wbuser.getNickname());
				logger.info("==SocialController==weibo==headimgurl==" + wbuser.getHeadimgurl());
				logger.info("==SocialController==weibo==followerscount==" + wbuser.getFollowers_count());
				logger.info("==SocialController==weibo==frientscount==" + wbuser.getFriends_count());
				request.setAttribute("wbuser", wbuser);
				
				//一度人脉总数
				int fcount = 0;
				//二度人脉总数
				int scount = 0;
				if(null != wbuser.getUid() && null != wbuser.getAccess_token()){
					fcount = SocialUtil.getWBFirstConnectionCount(wbuser.getAccess_token(), wbuser.getUid());	
					scount = SocialUtil.getWBSecondConnectionCount(wbuser.getAccess_token(), wbuser.getUid());	
				}
				request.setAttribute("fcount", fcount);
				request.setAttribute("scount", scount);
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);

		return "social/sweibo";
	}
	
	
	@RequestMapping("/slist")
	public String slist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");
		String pagecount = request.getParameter("pagecount");
		String currpage = request.getParameter("currpage");
		String type = request.getParameter("type");
		if(null == pagecount || "".equals(pagecount)){
			pagecount = "100";
		}
		if(null == currpage || "".equals(currpage)){
			currpage = "1";
		}
		logger.info("==SocialController==slist==openId==" + openId);
		logger.info("==SocialController==slist==publicId==" + publicId);
		logger.info("==SocialController==slist==socialUID==" + socialUID);
		logger.info("==SocialController==slist==token==" + token);
		logger.info("==SocialController==slist==pagecount==" + pagecount);
		logger.info("==SocialController==slist==currpage==" + currpage);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID) && StringUtils.isNotNullOrEmptyStr(token)) {
				SocialUserInfoResp sresp = null;
				if(null == type || "".equals(type)){
					sresp = SocialUtil.getWBFirstConnectionList(token, socialUID, pagecount, currpage);
				}else{
					sresp = SocialUtil.getWBSecondConnectionList(token, socialUID, pagecount, currpage);
				}
				if(null != sresp && null != sresp.getSlist()){
					request.setAttribute("socialList", sresp.getSlist());
				}else{
					request.setAttribute("socialList", new ArrayList<SocialUserInfo>());
				}
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("accesstoken", token);
		request.setAttribute("socialUID", socialUID);
		request.setAttribute("publicId", publicId);
		request.setAttribute("currpage", currpage);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("type", type);
		return "social/slist";
	}
	
	
	@RequestMapping("/syncslist")
	@ResponseBody
	public String syncslist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");
		String pagecount = request.getParameter("pagecount");
		String currpage = request.getParameter("currpage");
		String type = request.getParameter("type");
		if(null == pagecount || "".equals(pagecount)){
			pagecount = "100";
		}
		if(null == currpage || "".equals(currpage)){
			currpage = "1";
		}
		logger.info("==SocialController==slist==openId==" + openId);
		logger.info("==SocialController==slist==publicId==" + publicId);
		logger.info("==SocialController==slist==socialUID==" + socialUID);
		logger.info("==SocialController==slist==token==" + token);
		logger.info("==SocialController==slist==pagecount==" + pagecount);
		logger.info("==SocialController==slist==currpage==" + currpage);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID) && StringUtils.isNotNullOrEmptyStr(token)) {
				SocialUserInfoResp sresp = null;
				if(null == type || "".equals(type)){
					sresp = SocialUtil.getWBFirstConnectionList(token, socialUID, pagecount, currpage);
				}else{
					sresp = SocialUtil.getWBSecondConnectionList(token, socialUID, pagecount, currpage);
				}
				if(null != sresp && null != sresp.getSlist()){
					return JSONArray.fromObject(sresp.getSlist()).toString();
				}else{
					return "";
				}
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "";
	}
	
	
	@RequestMapping("/search")
	public String search(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");

		logger.info("==SocialController==search==openId==" + openId);
		logger.info("==SocialController==search==publicId==" + publicId);
		logger.info("==SocialController==search==socialUID==" + socialUID);
		logger.info("==SocialController==search==token==" + token);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("accesstoken", token);
		request.setAttribute("socialUID", socialUID);
		request.setAttribute("publicId", publicId);
		return "social/search";
	}
	
	
	@RequestMapping("/syncsearch")
	@ResponseBody
	public String syncsearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");
		String scontent = request.getParameter("scontent");
		String type = request.getParameter("type");
		String count = request.getParameter("count");
		
		if(null == count || "".equals(count)){
			count = "10";
		}
		logger.info("==SocialController==syncsearch==openId==" + openId);
		logger.info("==SocialController==syncsearch==publicId==" + publicId);
		logger.info("==SocialController==syncsearch==socialUID==" + socialUID);
		logger.info("==SocialController==syncsearch==token==" + token);
		logger.info("==SocialController==syncsearch==scontent==" + scontent);
		
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID) && StringUtils.isNotNullOrEmptyStr(token) && StringUtils.isNotNullOrEmptyStr(scontent)) {
				SocialUserInfoResp sresp = null;
				if(null == type || "user".equals(type)){
					sresp = SocialUtil.searchWBUser(token, scontent,count);
				}else if("content".equals(type)){
					sresp = SocialUtil.searchWBUserByContent(token,scontent,count);
				}
				if(null != sresp && null != sresp.getSlist()){
					return JSONArray.fromObject(sresp.getSlist()).toString();
				}else{
					return "";
				}
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "";
	}
	
	
	@RequestMapping("/synctags")
	@ResponseBody
	public String tags(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String socialUID = request.getParameter("socialUID");
		String token = request.getParameter("accesstoken");
		logger.info("==SocialController==slist==openId==" + openId);
		logger.info("==SocialController==slist==publicId==" + publicId);
		logger.info("==SocialController==slist==socialUID==" + socialUID);
		logger.info("==SocialController==slist==token==" + token);
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			if (StringUtils.isNotNullOrEmptyStr(socialUID) && StringUtils.isNotNullOrEmptyStr(token)) {
				List<SocialTags> tagList = null;
				tagList = SocialUtil.getWBUserTags(token, socialUID);
				if(null != tagList){
					return JSONArray.fromObject(tagList).toString();
				}else{
					return "";
				}
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "";
	}
	
	@RequestMapping("/asysave")
	@ResponseBody
	public String asysave(SocialContact  socialContact,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = cRMService.getWxService().getWxUserinfoService().getCrmId(openId, publicId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			if (StringUtils.isNotNullOrEmptyStr(socialContact.getUid()) && StringUtils.isNotNullOrEmptyStr(socialContact.getContactid())) {
				String id = cRMService.getDbService().getSocialContactService().addObj(socialContact);
				if(StringUtils.isNotNullOrEmptyStr(id)){
					return "success";
				}else{
					return "";
				}
			}else{
				return "";
			}
		}else{
			throw new Exception("错误编码:" + ErrCode.ERR_CODE_1001001 + ",错误描述:" + ErrCode.ERR_MSG_UNBIND);
		}
	}
}
