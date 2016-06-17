package com.takshine.wxcrm.service;

import java.util.List;
import java.util.Map;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.FrstChartsReq;
import com.takshine.wxcrm.message.sugar.FrstChartsResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.userget.UserGet;

/**
 * 从sugar系统获取 LOV和 用户 的服务
 * @author liulin
 *
 */
public interface LovUser2SugarService extends EntityService {
	
	/**
	 * 查询 获取 lov 数据列表
	 * @return
	 */
	public Map<String, Map<String, String>> getLovList(String crmId);
	
	/**
	 * 从sugar系统中 查询 用户的数据列表
	 * @return
	 */
	public UsersResp getUserList(UserReq req) throws Exception;
	
	/**
	 * 从后台CRM系统中 查询 首字母数据列表
	 * @return
	 */
	public FrstChartsResp getFirstCharList(FrstChartsReq req);
	
	/**
	 * 获取关注用户列表
	 * @return
	 */
	public UserGet getAttenUserList(String publicId, String userId, String relaId);
	
	/**
	 * 查询活动首字母
	 * @param req
	 * @return
	 */
	public FrstChartsResp getCampaignsFirstCharList(String openId);
	
	/**
	 * 缓存数据
	 * @param data
	 */
	public void cacheLovData(String orgId, Map<String, Map<String, String>> data);
	
		/**
	 * 修改用户的状态
	 * @param userAdd
	 * @return
	 */
	public CrmError updateUser(UserReq req);
	
	/**
	 * 验证老密码
	 * @param ua
	 * @return
	 */
	public boolean validateUserPassword(UserAdd ua); 
	
	/**
	 * 修改密码
	 * @param ua
	 * @return
	 */
	public boolean updateUserPassword(UserAdd ua);
	
	
	/**
	 * 修改用户信息
	 * @param ua
	 * @return
	 */
	public boolean updateUserInfo(UserAdd ua);
	
	/**
	 * 获取好友列表
	 * @param userId
	 * @return
	 */
	public List<UserRela> getFriendList(String userId);
	
	/**
	 * 从sugar系统中 查询 用户的数据列表
	 * @return
	 */
	public UsersResp getUserList(UserReq req,WxHttpConUtil util) throws Exception;
}
