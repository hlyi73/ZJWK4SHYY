package com.takshine.wxcrm.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.UserPerferences;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.sugar.AuthReq;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.UserPerferencesService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 微信用户服务实现
 * @author liulin
 *
 */
@Service("wxUserinfoService")
public class WxUserinfoServiceImpl extends BaseServiceImpl implements WxUserinfoService {
	
	// schedules 日志
	private static Log log = LogFactory.getLog("users");
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "WxuserInfo";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "wxuserInfoSql.";
	}
	
	public BaseModel initObj() {
		return new WxuserInfo();
	}
	
	/**
	 * 保存微信用户的基本信息
	 * @param openId
	 * @param publicId
	 */
	public void saveOrUptUserInfo(WxuserInfo u){
		try {
			//根据ID 查询数据对象
			WxuserInfo searchObj = new WxuserInfo();
			searchObj.setOpenId(u.getOpenId());
			//查询结果集返回对象
			if(null != findObj(searchObj)){
				//更新用户信息数据
				updateObj(u);
			}else{
				addObj(u);
			}
		} catch (Exception e) {
			log.info("saveOrUptUserInfo method =>" + e.getMessage());
		}
	}
	
	/**
	 * 根据openID 获取partyid
	 * @param openId
	 * @return
	 */
	public String getPartyRowId(String openId){
		WxuserInfo searchObj = new WxuserInfo();
		searchObj.setOpenId(openId);
		Object obj = findObj(searchObj);
		if(null != obj){
			searchObj = (WxuserInfo)obj;
			log.info("getPartyRowId = >" + searchObj.getParty_row_id());
			return searchObj.getParty_row_id();
		}
		return "";
	}
	
	/**
	 * 获取微信用户基本信息
	 * @param openId
	 */
	@SuppressWarnings("unchecked")
	public WxuserInfo getWxuserInfo(String openId){
		WxuserInfo u = new WxuserInfo();
		u.setOpenId(openId);
		List<WxuserInfo> ulist = (List<WxuserInfo>)findObjListByFilter(u);
		if(ulist.size() > 0){
			u = ulist.get(0);
		}
		return u;
	}
	
	/**
	 * 获取微信用户基本信息
	 * @param openId
	 */
	@SuppressWarnings("unchecked")
	public WxuserInfo getWxuserInfo(WxuserInfo wxuser){
		WxuserInfo u = new WxuserInfo();
		List<WxuserInfo> ulist = (List<WxuserInfo>)findObjListByFilter(wxuser);
		if(ulist.size() > 0){
			u = ulist.get(0);
		}
		return u;
	}


	/**
	 * 获取用户基本信息
	 * @param openId
	 * @return
	 */
	public UserInfo getUserInfo(String openId) {
		log.info("UserinfoServiceImpl getUserInfo begin=>");
		// 调用接口获取access_token
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		
		log.info("access_token =>" + at.getToken());
		log.info("expires_in =>" + at.getExpiresIn());

		UserInfo userInfo = null;
		if (null != at) {
			// 调用接口获取用户信息
			 userInfo = WxUtil.getUserInfo(openId, at.getToken());

			// 判断获取用户信息结果
			if (null != userInfo)
				log.info("获取用户信息成功！");
			else
				log.info("获取用户信息失败！");
		}
		return userInfo;
	}
	
	/**
	 * 调用接口同步 关注信息到我们的系统
	 * @param source 网站 website, 分享 share, 关注 subscribe
	 */
	public String synchroUserData(String openId,String unionid, String source){
		log.info("==synchroUserData method enter => ");
		 String crmId = "";
		 String party_user_id = "";
		 if(null != openId && !"".equals(openId)){
			
			//注释掉同步 修改为 修改或新增 微信用户数据
			//cRMService.getWxService().getWxUserinfoService().synchroUserData(openId);
			if(!StringUtils.isNotNullOrEmptyStr(unionid)){
				unionid = synchroSingleUserData(openId);
				log.info("----------获取unionid------------"+unionid);
				
				//测试环境没有unionid，先用openId替换
				if(null == unionid || "".equals(unionid)){
					unionid = openId;
					log.info("----------重设unionid------------"+unionid);
				}
			}
			
			//调用指尖统一账户，建立账户
			String url = PropertiesUtil.getAppContext("zjsso.url")+"/out/sso/account_create/" + unionid;
			log.info("----------建立统一账户------------"+url);
			//单次调用sugar接口
			Map<String, String> paramaps = new HashMap<String, String>();
			//调用
			String invokrst = "{\"errorCode\":\"-1\"}";
			try {
				invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
			} catch (Exception e1) {
				log.info(" exception => " + e1.getMessage());
			}
			log.info(" invokrst => " + invokrst);
			JSONObject invokObj = JSONObject.fromObject(invokrst);
			if ("0".equals(invokObj.getString("errorCode"))) {
				party_user_id = invokObj.getString("user_id");
				WxuserInfo wuinfo = null;
				log.info(" party_user_id in=> " + party_user_id);
				if(null != party_user_id && !"".equals(party_user_id)){
					wuinfo = new WxuserInfo();
					wuinfo.setParty_row_id(party_user_id);
					wuinfo.setOpenId(openId);
					wuinfo.setUnionid(unionid);
					saveOrUptUserInfo(wuinfo);
				}
				
				//如果是新建的party账号 则为首次授权
				if("share".equals(source) 
						&& invokObj.get("is_new") != null 
						&& "new".equals(invokObj.getString("is_new"))){
					wuinfo = new WxuserInfo();
					wuinfo.setOpenId(openId);
					Object wuinfoobj  = findObj(wuinfo);
					if(wuinfoobj != null){
						wuinfo = (WxuserInfo)wuinfoobj;
					}
					//关注指尖微客
					cRMService.getDbService().getMessagesService().sendMsg("", "", party_user_id, wuinfo.getNickname(), "感谢您关注指尖微客", "System_Task_Welcome", "", "", "txt", "N", DateTime.currentDate(), "");
					//创建名片任务
					cRMService.getDbService().getMessagesService().sendMsg("", "", party_user_id, wuinfo.getNickname(), "点我完善您的名片信息", "System_Task_CreateCard", "", "", "txt", "N", DateTime.currentDate(), "");
					//关注指尖微客公众号任务
					cRMService.getDbService().getMessagesService().sendMsg("", "", party_user_id, wuinfo.getNickname(), "点我关注指尖微客公众号", "System_ZJWK_Subscribe", "", "", "txt", "N", DateTime.currentDate(), "");
				}
				
				//判断用户是否有名片，如果没有，则创建一张空白名片
				BusinessCard bc = new BusinessCard();
				bc.setPartyId(party_user_id);
				List<?> bcList = cRMService.getDbService().getBusinessCardService().findObjListByFilter(bc);
				//没有名片，创建名片
				wuinfo = getWxuserInfo(openId);
				if((null == bcList || bcList.size() == 0) && null != wuinfo){
					if(StringUtils.isNotNullOrEmptyStr(wuinfo.getNickname())){
						bc.setName(wuinfo.getNickname());
					}else{
						bc.setName("指尖用户");
					}
					bc.setOpenId(openId);
					//将微信图片download到本地服务器
					if(StringUtils.isNotNullOrEmptyStr(wuinfo.getHeadimgurl())){
						bc.setHeadImageUrl(WxUtil.compressImger(wuinfo.getHeadimgurl()));
					}
					cRMService.getDbService().getBusinessCardService().insert(bc);
				}
			}
			log.info(" party_user_id => " + party_user_id);
			
			//TODO 调用指尖威客个人版 并且进行绑定
			//查询openId是否有绑定个人版指尖微客
			OperatorMobile om = new OperatorMobile();
			om.setOpenId(openId);
			om.setOrgId("Default Organization");
			crmId = getSqlSession().selectOne("operatorMobileSql.finCrmIdListByOpenId", om);
			log.info("----------获取CRMID，查看是否绑定------------"+crmId);
			//如果没有，则创建个人版账户
			if(null == crmId || "".equals(crmId)){
				log.info("----------没有CRMID------------");
				WxuserInfo wuser = getWxuserInfo(openId);
				log.info("----------获取微信用户信息-----------nickname--"+wuser.getNickname());
				//调用个人版，创建账户
				AuthReq aq = new AuthReq();
				aq.setModeltype(Constants.MODEL_TYPE_USER);
				aq.setType(Constants.ACTION_ADD);
				aq.setSource(Constants.SYS_SOURCE);
				if(null == wuser.getNickname() || "".equals(wuser.getNickname())){
					aq.setUsername("新用户");
				}else{
					aq.setUsername(wuser.getNickname());
				}
				aq.setCrmaccount(openId);
				aq.setInitorgid("Default Organization");
				//转换为json
				String jsonStr = JSONObject.fromObject(aq).toString();
				log.info("updateUser jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = "";
				try {
					rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr, Constants.INVOKE_MULITY);
				} catch (Exception e) {
					log.info("-----------新建账户 rst exception=> " + e.getMessage());
				}
				log.info("-----------新建账户 rst => rst is : " + rst);
				//解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (null != jsonObject) {
					String errcode = jsonObject.getString("errcode");
					if("0".equals(errcode)){
						String rowid = jsonObject.getString("rowid");
						log.info("----------新账户Id-------------"+rowid);
						//前台绑定
						if(null != rowid && !"".equals(rowid)){
							//创建用户
							DcCrmOperator oper = new DcCrmOperator();
							String opid = Get32Primarykey.getRandom32PK();
							oper.setOpId(opid);
							oper.setOrgId("Default Organization");
							oper.setCrmId(rowid);
							int flag = getSqlSession().insert("DcCrmOperatorSql.insertDcCrmOperator", oper);
							log.info("----------创建DC表-------------"+flag);
							if(flag >0){
								//绑定关系
								om.setOpId(opid);
								om.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
								om.setOrgId("Default Organization");
								om.setId(Get32Primarykey.getRandom32PK());
								om.setCrmId(rowid);
								getSqlSession().insert("operatorMobileSql.insertOperatorMobile",om);
								log.info("----------创建绑定表-------------");
							}
						}
					}else if("100008".equals(errcode)){//数据重复
						String rowid = jsonObject.getString("rowid");
						crmId = rowid;
						log.info("----------已经创建的 账户Id-------------"+rowid);
						
						//用户
						DcCrmOperator oper = new DcCrmOperator();
						oper.setOrgId("Default Organization");
						oper.setCrmId(crmId);
						Object operobj = getSqlSession().selectOne("DcCrmOperatorSql.findDcCrmOperatorListByFilter", oper);
						log.info("----------operobj search-------------");
						if(operobj != null){
							oper = (DcCrmOperator)operobj;
							//绑定关系
							om = new OperatorMobile();
							om.setOpId(oper.getOpId());
							om.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
							om.setOrgId("Default Organization");
							om.setCrmId(crmId);
							om.setOpenId(openId);
							Object rstom = getSqlSession().selectOne("operatorMobileSql.findOperatorMobileListByFilter",om);
							if(rstom == null){
								om.setId(Get32Primarykey.getRandom32PK());
								getSqlSession().insert("operatorMobileSql.insertOperatorMobile",om);
								log.info("----------创建 OperatorMobile 绑定表 完成-------------");
							}
						}else{
							//创建用户
							String opid = Get32Primarykey.getRandom32PK();
							oper.setOpId(opid);
							oper.setOrgId("Default Organization");
							oper.setCrmId(crmId);
							oper.setOpName(wuser.getNickname());
							int flag = getSqlSession().insert("DcCrmOperatorSql.insertDcCrmOperator", oper);
							log.info("----------创建DC表-------------"+flag);
							if(flag >0){
								//判断关系是否存在
								om = new OperatorMobile();
								om.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
								om.setOrgId("Default Organization");
								om.setCrmId(crmId);
								om.setOpenId(openId);
								Object rstom = getSqlSession().selectOne("operatorMobileSql.findOperatorMobileListByFilter",om);
								if(rstom == null){
									om.setId(Get32Primarykey.getRandom32PK());
									om.setOpId(opid);
									getSqlSession().insert("operatorMobileSql.insertOperatorMobile",om);
									log.info("----------创建 OperatorMobile 绑定表 完成-------------");
								}else{
									//更新operid
									OperatorMobile om1 = (OperatorMobile)rstom;
									om1.setOpId(oper.getOpId());
									getSqlSession().update("operatorMobileSql.updateOperatorMobileById",om1);
								}
							}
							
						}
					}else{
						//错误暂未处理
						String errcodeElse = jsonObject.getString("errcode");
						String errmsgElse = jsonObject.getString("errmsg");
						log.info("errcodeElse = >" +  errcodeElse);
						log.info("errmsgElse = >" +  errmsgElse);
					}
				}
			}
		 }
		 
		 return "{\"crmId\":\""+ crmId +"\",\"party_user_id\":\""+ party_user_id +"\"}";
	}
	
	/**
	 * 调用接口同步当个 关注信息到我们的系统
	 */
	public String synchroSingleUserData(String openId){
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		UserInfo uinfo = WxUtil.getUserInfo(openId, at.getToken());
		WxuserInfo wxuser = transuinfo(uinfo);
		if(StringUtils.isNotNullOrEmptyStr(wxuser.getHeadimgurl())){
			wxuser.setHeadimgstr(WxUtil.httpsRequestImger(wxuser.getHeadimgurl()));
		}
		log.info("==synchroUserData single thread uinfo openid => " + uinfo.getOpenId());
		saveOrUptUserInfo(wxuser);
		return uinfo.getUnionid();
	}
	
	private WxuserInfo transuinfo(UserInfo uinfo){
		WxuserInfo wu = new WxuserInfo();
		if(null != uinfo.getSubscribe()){
			wu.setSubscribe(String.valueOf(uinfo.getSubscribe()));
		}
		if(null != uinfo.getSex()){
			wu.setSex(String.valueOf(uinfo.getSex()));
		}
		if(null != uinfo.getSubscribeTime()){
			wu.setSubscribeTime(DateTime.long2Date(uinfo.getSubscribeTime()));
		}
		wu.setOpenId(uinfo.getOpenId());
		wu.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
		wu.setNickname(uinfo.getNickname());
		wu.setCity(uinfo.getCity());
		wu.setCountry(uinfo.getCountry());
		wu.setProvince(uinfo.getProvince());
		wu.setLanguage(uinfo.getLanguage());
		wu.setHeadimgurl(uinfo.getHeadImgurl());
		
		return wu;
	}

	public WxuserInfo getUserConfig(WxuserInfo wxuser) {
		try{
		UserPerferences up = new UserPerferences();
		up.setUser_id(wxuser.getParty_row_id());
		up.setCategory("config");
		List<UserPerferences> uplist = (List<UserPerferences>)cRMService.getDbService().getUserPerferencesService().findObjListByFilter(up);
		if(uplist!=null&&uplist.size()>0){
			up=uplist.get(0);
			String contents = up.getContents();
			if(StringUtils.isNotNullOrEmptyStr(contents)){
				String [] strs=contents.split(",");
				Map<String, String> map = new HashMap<String, String>();
				for(String configs:strs){
					if(StringUtils.isNotNullOrEmptyStr(configs)){
						String []config=configs.split("\\|");
						map.put(config[0], config[1]);
					}
				}
				wxuser.setContactConfig(map.get("contact"));
				wxuser.setMsmConfig(map.get("msm"));
				wxuser.setMessageConfig(map.get("message"));
				wxuser.setValidationConfig(map.get("validation"));
			}
		}}catch(Exception e){
			
		}
		return wxuser;
	}

}
