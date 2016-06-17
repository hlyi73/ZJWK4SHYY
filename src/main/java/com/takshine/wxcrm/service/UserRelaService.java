package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;

/**
 * 用户关联关系
 * @author liulin
 *
 */
public interface UserRelaService extends EntityService{
	public List<WxuserInfo> getFriendList(WxuserInfo wx) throws Exception;
	public List<WxuserInfo> getRssFriendList(Subscribe subscribe) throws Exception;
	public List<String> getFriendFristCharList(String openId) throws Exception;
	
	/**
	 * 查询用户列表
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<WxuserInfo> getUserList(String userId) throws Exception;
	
	public boolean isFriendsByPartyId(UserRela userRela) throws Exception;
	
	public boolean removeUserRelaByPartyId(UserRela userRela) throws Exception;
	
	/**
	 * 获取好友的首字母集合
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<String> queryFirstCharById(String userId) throws Exception;
}
