/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.PlatformStatistics;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.userinfo.UserInfo;

/**
 * 统一入口管理
 * 
 * 
 */
@Controller
@RequestMapping("/entr")
public class EntranceController {
	
	private static Logger logger = Logger.getLogger(EntranceController.class.getName());
	
	// users 日志
	private static Log log = LogFactory.getLog("users");
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 外部入口
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/access")
	public String accessCount(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		log.info("EntranceController  -- access -- begin");
		String fopenId = request.getParameter("fopenId");
		String row_id = request.getParameter("parentId");
		String model = request.getParameter("parentType");
		String schetype = request.getParameter("schetype");
		String orgId = request.getParameter("orgId");
		schetype = (null == schetype ? "" : schetype);

		//判断
		if (null == model || "".equals(model) || null == row_id || "".equals(row_id)) {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
		}
		
		log.info("EntranceController  -- access --  fopenId = >" + fopenId);
		log.info("EntranceController  -- access --  row_id = >" + row_id);
		log.info("EntranceController  -- access --  model = >" + model);

		//微信授权返回的code
		String code = request.getParameter("code");

		log.info("EntranceController  -- access --  code = >" + code);
		String openId = null;
		boolean friend = false;
		String crmId = "";
		String party_user_id = "";
		String nickname = "";
		
		// 如查是微信授权过来的
		if (null != code && !"".equals(code)) {
			log.info("EntranceController  -- access -- code -- is not null");
			AuthorizeInfo auth = WxUtil.getAccessToken(Constants.APPID,Constants.APPSECRET, code);
			openId = auth.getOpenId();

			log.info("EntranceController  -- access --  to openId = >" + openId);

			AuthorizeInfo authRefresh = WxUtil.refreshToken(Constants.APPID,auth.getRefreshToken());
			// 获取微信用户信息
			UserInfo u = WxUtil.getSnsUserinfo(authRefresh.getOpenId(),authRefresh.getAccessToken());
			log.info("EntranceController  -- access --  获取微信信息, nickname 01  = >" + u.getNickname());
			log.info("EntranceController  -- access --  获取微信信息, unionid 01  = >" + u.getUnionid());
			//
			WxuserInfo user = new WxuserInfo();
			user.setOpenId(openId);

			user.setNickname(u.getNickname());
			user.setCountry(u.getCountry());
			user.setCity(u.getCity());
			user.setProvince(u.getProvince());
			user.setSex(String.valueOf(u.getSex()));
			user.setUnionid(u.getUnionid());

			if (null != u.getHeadImgurl()) {
				user.setHeadimgurl(u.getHeadImgurl());
				user.setHeadimgstr(WxUtil.httpsRequestImger(u.getHeadImgurl()));
			}
			nickname = user.getNickname();
			log.info("EntranceController  -- access --  获取微信信息, nickname = >" + nickname);
			cRMService.getWxService().getWxUserinfoService().saveOrUptUserInfo(user);
			
			// 注册账号，如果有账户，则返回账户ID，如果没有，则创建账户
			String synchrst = cRMService.getWxService().getWxUserinfoService().synchroUserData(openId, u.getUnionid(), "share");
			log.info("synchrst = >" + synchrst);
			JSONObject synrobj = JSONObject.fromObject(synchrst);
			crmId = synrobj.getString("crmId");
			log.info("crmId = >" + crmId);
			log.info("EntranceController  -- access --  开户，crmId = >" + crmId);
			party_user_id = synrobj.getString("party_user_id");
			log.info("EntranceController  -- access --  开户，party_user_id = >" + party_user_id);
			
			//设置缓存
			if(StringUtils.isNotNullOrEmptyStr(party_user_id)){
				UserUtil.setUserCookie(response,party_user_id);
			}
			
		}else{
			log.info("EntranceController  -- access -- code is null ----");
			//从cookie中获取partyId;
			boolean isExists = false;
			party_user_id = UserUtil.getUserCookie(request);
			if(StringUtils.isNotNullOrEmptyStr(party_user_id)){
				isExists = true;
			}
			log.info("EntranceController  -- access -- isExists is  ----" + isExists);
			//如果不存在缓存
			if(!isExists){
				log.info("EntranceController  -- access -- isExists is false ----");
				//根据不同类型，跳转到微显示授权，获取用户信息
				model = (null == model ? "" : model);
				String return_url = PropertiesUtil.getAppContext("app.content");
				//客户
				if("customer".equals(model)){
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				//任务
				else if("schedule".equals(model)){
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model+"&schetype="+schetype;
				}
				//联系人
				else if("contact".equals(model)){
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				//名片
				else if("businesscard".equals(model)){
					return_url += "/entr/access?fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				//工作计划
				else if("workplan".equals(model)){
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				//讨论组
				else if("discuGroup".equals(model)){
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				else if ("resource".equals(model))
				{
					return_url += "/entr/access?orgId="+orgId+"&fopenId="+fopenId+"&parentId="+row_id+"&parentType="+model;
				}
				else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
				}
				//
				return_url = PropertiesUtil.getAppContext("zjwk.short.url") +"/share?u=" + ZJWKUtil.shortUrl(return_url);
				log.info("EntranceController  -- access -- return_url ----" + return_url);
				String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
				log.info("EntranceController  -- access -- url ----" + url);
				return "redirect:"+url;
			}
			log.info("EntranceController  -- access -- party_user_id is  ----" + party_user_id);
			//获取用户信息
			WxuserInfo user = new WxuserInfo();
			user.setParty_row_id(party_user_id);
			user = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(user);
			
			openId = user.getOpenId();
			nickname = user.getNickname();
			log.info("EntranceController  -- access -- openId is  ----" + openId);
			log.info("EntranceController  -- access -- nickname is  ----" + nickname);
			//获取默认组织的CRMID
			crmId = cRMService.getWxService().getWxUserinfoService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			log.info("EntranceController  -- access -- crmId is  ----" + crmId);
		}
		log.info("EntranceController  -- access -- crmId 02 is  ----" + crmId);
		//判断是否有CRMID
		if (null == crmId || "".equals(crmId) || null == party_user_id || "".equals(party_user_id)) {
			log.info("EntranceController  -- 没有找到CRMID或PartyId");
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//判断当前登陆人是否是记录责任人
		boolean isowner = false;
		
		Object recordCrmid = null;
		//客户
		if("customer".equals(model)){
			recordCrmid = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(row_id).getCrm_id();
		}
		//任务
		else if("schedule".equals(model)){
			recordCrmid =  cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(row_id).getCrm_id();
		}
		//联系人
		else if("contact".equals(model)){
			recordCrmid = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(row_id).getCrm_id();
		}
		//业务机会
		else if("oppty".equals(model)){
			recordCrmid = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(row_id).getCrm_id();
		}
		//名片 //工作计划
		else if("businesscard".equals(model) || "workplan".equals(model)){
			recordCrmid = crmId;
		}
		//讨论组
		else if("discuGroup".equals(model) ){
			recordCrmid = crmId;
		}
		else if ("resource".equals(model))
		{
			recordCrmid = crmId;
		}
		else{
			log.info("EntranceController  -- model未找到或类型不对 -- model="+model);
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
		}
		
		log.info("EntranceController  -- recordCrmid --  recordCrmid is" + recordCrmid);
		
		//if(!"businesscard".equals(model)){
			//
			if(null == recordCrmid){
				log.info("EntranceController  -- 根据rowid未能找到责任人 -- row_id="+row_id);
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
			}
			//一个openid 可以对应多个crmid 但是一个crmid 只可能对一个openid
			String recordOpenId = cRMService.getWxService().getWxUserinfoService().getOpenIdByCrmId(recordCrmid.toString());
			log.info("EntranceController  -- recordOpenId -- is" + recordOpenId);
			if(!StringUtils.isNotNullOrEmptyStr(recordOpenId)){
				log.info("EntranceController  -- 根据crmId未能找到openId -- recordCrmid="+recordCrmid);
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
			}else{
				fopenId = recordOpenId;
				if(fopenId.equals(openId)){
					isowner = true;
				}
			}
		//}
		log.info("EntranceController  -- fopenId -- is" + fopenId);
		log.info("EntranceController  -- isowner -- is" + isowner);
		
		//平台统计
		PlatformStatistics ps = new PlatformStatistics();
		ps.setParty_row_id(party_user_id);
		ps.setUser_name(nickname);
		ps.setOpenId(openId);
		ps.setModel(model);
		ps.setOrgId(orgId);
		ps.setType(""); //
		ps.setRela_id(row_id);
		ps.setR_type("in");
		ps.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
		
		
		if(!isowner){
			log.info("EntranceController  -- owner? --  false");
			// 获取分享者的账户信息
			WxuserInfo ownerWxuinfo = new WxuserInfo();
			ownerWxuinfo.setOpenId(fopenId);
			Object ownerObj = cRMService.getWxService().getWxUserinfoService().findObj(ownerWxuinfo);
	
			if (ownerObj == null) {
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_999999 + "，错误描述：" + ErrCode.ERR_CODE_999999_MSG);
			}
			ownerWxuinfo = (WxuserInfo) ownerObj;
	
			log.info("EntranceController  -- access --  From party_row_id = >" + ownerWxuinfo.getParty_row_id());
			
			log.info("EntranceController  -- access --  判断是不是好友");
			// 判断是不是好友
			UserRela urela = new UserRela();
			urela.setUser_id(ownerWxuinfo.getParty_row_id());
			urela.setRela_user_id(party_user_id);
			urela.setType("whitelist");
			Object urelarst = cRMService.getDbService().getUserRelaService().findObj(urela);
	
			if (urelarst != null) {
				log.info("EntranceController  -- access --  已注册，是好友");
				friend = true;
			} else {
				friend = false;
				log.info("EntranceController  -- access --  已注册，不是好友");
			}
	
			if (!friend && !"dcCrm".equals(model)) {
				// 建立好友关系
				UserRela rela = new UserRela();
				rela.setUser_id(ownerWxuinfo.getParty_row_id());
				rela.setRela_user_id(party_user_id);
				rela.setType("whitelist");
				rela.setCurrpages(new Integer(0));
				Object relaobj = cRMService.getDbService().getUserRelaService().findObj(rela);
				if (relaobj == null) {
					log.info("relation not exsitis one=>");
					rela.setId(Get32Primarykey.getRandom32PK());
					cRMService.getDbService().getUserRelaService().addObj(rela);
				}
				// 关联关系
				rela = new UserRela();
				rela.setUser_id(party_user_id);
				rela.setRela_user_id(ownerWxuinfo.getParty_row_id());
				rela.setType("whitelist");
				rela.setCurrpages(new Integer(0));
				relaobj = cRMService.getDbService().getUserRelaService().findObj(rela);
				if (relaobj == null) {
					log.info("relation not exsitis sec=>");
					rela.setId(Get32Primarykey.getRandom32PK());
					rela.setCreate_date(DateTime.currentDate(DateTime.DateFormat1));
					cRMService.getDbService().getUserRelaService().addObj(rela);
				}
				log.info("EntranceController  -- access --  建立好友关系");
			}
	
			// 判断共享记录是否有此用户,如果没有，添加关系
			TeamPeason tp = new TeamPeason();
			tp.setOpenId(openId);
			tp.setRelaId(row_id);
			tp.setNickName(nickname);
			tp.setRelaModel(model);
			tp.setCreateTime(DateTime.currentDate());
			Object rsttp = cRMService.getDbService().getTeamPeasonService().findObj(tp);
	
			log.info("EntranceController  -- access --  判断共享记录是否有此用户,如果没有，添加关系 ");
	
			if (null == rsttp) {
				log.info("EntranceController  -- access --  添加团队记录 ");
				tp.setId(Get32Primarykey.getRandom32PK());
				tp.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
				cRMService.getDbService().getTeamPeasonService().addObj(tp);
				log.info("EntranceController  -- access --  添加团队记录成功 ");
			}
	
			//设置会话
			UserUtil.setCurrUser(request, openId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());
			
			String url = getRedirectUrl(row_id, model, fopenId, schetype, nickname,openId, orgId);
	
			log.info("EntranceController  -- access --  跳转url= " + url);
			
			//记录分享操作日志
			ps.setUrl(url);
			savePlatformStatistics(ps);
			
			// 跳转到业务模块
			return "redirect:" + url + "&flag=share";
		}
		//自己
		else{
			log.info("EntranceController  -- owner? --  yes");
			String url = getRedirectUrl(row_id, model, fopenId, schetype, "","", orgId);
			
			//记录分享操作日志
			ps.setUrl(url);
			savePlatformStatistics(ps);
			
			log.info("EntranceController  -- access --  跳转url= " + url);
			// 跳转到业务模块
			return "redirect:" + url;
		}
	}

	//记录分享操作日志
	private void savePlatformStatistics(PlatformStatistics ps){
		try {
			cRMService.getDbService().getPlatformStatisticsService().saveStatistics(ps);
		} catch (Exception e) {
			logger.error("记录分享操作日志失败！");
		}
	}
	
	/**
	 * 获得跳转URL
	 * @param rowId
	 * @param model
	 * @return
	 */
	private String getRedirectUrl(String rowId, String model,String openId,String schetype,String attennickname,String attenopenid,String orgId){
		log.info("getRedirectUrl = >");
		log.info("rowId = >" + rowId);
		log.info("model = >" + model);
       if(StringUtils.isNotNullOrEmptyStr(attenopenid) && !"businesscard".equals(model)){
    	   openId=attenopenid;
       }
		logger.info("-----------------------entr---------------openId===="+openId);
		logger.info("-----------------------entr---------------attenopenid===="+attenopenid);
        if("businesscard".equals(model)){
//        	String partyId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId).getParty_row_id();
//        	String attenPartyId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(attenopenid).getParty_row_id();
//        	logger.info("-----------------------entr---------------partyId===="+partyId);
//        	logger.info("-----------------------entr---------------attenPartyId===="+attenPartyId);
//        	return "/out/user/card?flag=RM&orgId="+orgId+"&partyId="+partyId+"&atten_partyId="+attenPartyId;
        	return "/"+ model + "/detail?partyId="+rowId+"&flag=Change";
        }else{
        	return "/"+ model + "/detail?orgId="+orgId+"&rowId=" + rowId+"&schetype="+schetype+"&openId="+openId+"&atten_openid="+attenopenid+"&atten_nickname="+attennickname+"&publicId="+PropertiesUtil.getAppContext("app.publicId");
        }
		
	}
}