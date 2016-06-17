package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.SocialUserInfo;

/**
 * 第三方平台用户基本信息服务
 * 
 * @author 
 * 
 */
public interface SocialUserinfoService extends EntityService {
	
	/**
	 * 获取微博用户基本信息
	 * @param openId
	 */
	public SocialUserInfo getWbuserInfo(SocialUserInfo u);
	
	/**
	 * 保存用户基本信息
	 * @param WxuserInfo u
	 * @return
	 */
	public void saveOrUptUserInfo(SocialUserInfo u);

}
