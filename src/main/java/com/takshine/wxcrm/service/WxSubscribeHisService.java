package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;

/**
 * 考勤签到
 *
 */
public interface WxSubscribeHisService extends EntityService{
	
	/**
	 * 添加微信订阅记录 
	 */
	public void addWxSubscribeHis(String openid, String subtype);
	
	/**
	 * 查询微信订阅记录
	 */
	public boolean searchWxSubHisExits(String openid);
	
	/**
	 * 取消关注的时候  发送手机短信 
	 */
	public void cannelSubSendPhoneMsg(String openId);
}
