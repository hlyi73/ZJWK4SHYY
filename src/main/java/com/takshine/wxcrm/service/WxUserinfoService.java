package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.userinfo.UserInfo;

/**
 * 微信用户基本信息服务
 * 
 * @author liulin
 * 
 */
public interface WxUserinfoService extends EntityService {
	
	/**
	 * 获取微信用户基本信息
	 * @param openId
	 */
	public WxuserInfo getWxuserInfo(String openId);
	
	/**
	 * 保存用户基本信息
	 * @param WxuserInfo u
	 * @return
	 */
	public void saveOrUptUserInfo(WxuserInfo u);
	
	/**
	 * 获取用户基本信息
	 * @param openId
	 * @return
	 */
	public UserInfo getUserInfo(String openId);
	
	/**
	 * 调用接口同步 关注信息到我们的系统
	 */
	public String synchroUserData(String openId,String unionid, String source);
	
	/**
	 * 调用接口同步当个 关注信息到我们的系统
	 */
	public String synchroSingleUserData(String openId);
	
	
	/**
	 * 获取用户基本信息
	 * @param openId
	 * @return
	 */
	public WxuserInfo getWxuserInfo(WxuserInfo wxuser);
	
	/**
	 * 根据openID 获取partyid
	 * @param openId
	 * @return
	 */
	public String getPartyRowId(String openId);
	/**
	 * 完善微信用户的配置信息
	 * @return
	 */
	public WxuserInfo getUserConfig(WxuserInfo wxuser);
}
