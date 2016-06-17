package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.UserRelaService;

/**
 * 用户关联关系
 * @author liulin
 *
 */
@Service("userRelaService")
public class UserRelaServiceImpl extends BaseServiceImpl implements UserRelaService{

	@Override
	protected String getDomainName() {
		return "UserRela";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userRelaSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}

	public List<WxuserInfo> getFriendList(WxuserInfo wx) throws Exception {
		
		return this.getSqlSession().selectList("wxuserInfoSql.findFriendListByFilter", wx);
	}

	public List<String> getFriendFristCharList(String openId) throws Exception {

		List<String> actList = getSqlSession().selectList("wxuserInfoSql.findFriendFirstList", openId);
		return actList;
	}

	public List<WxuserInfo> getRssFriendList(Subscribe subscribe)
			throws Exception {
		return this.getSqlSession().selectList("wxuserInfoSql.findRssFriendListByFilter", subscribe);
	}
	
	/**
	 * 获取用户关列表
	 */
	public List<WxuserInfo> getUserList(String userId) throws Exception {
		return this.getSqlSession().selectList("userRelaSql.findUserListByFilter", userId);
	}

	public boolean isFriendsByPartyId(UserRela userRela) throws Exception {
		List<UserRela> urList = this.getSqlSession().selectList("userRelaSql.isFriendsByPartyId", userRela);
		if(null == urList || urList.size() == 0){
			return false;
		}
		return true;
	}

	/**
	 * 删除关系
	 */
	public boolean removeUserRelaByPartyId(UserRela userRela) throws Exception {
		int flag = this.getSqlSession().delete("userRelaSql.removeFriendByPartyId", userRela);
		if(flag >0){
			return true;
		}
		return false;
	}

	/**
	 * 获取好友首字母集合
	 */
	public List<String> queryFirstCharById(String userId) throws Exception {
		return this.getSqlSession().selectList("userRelaSql.queryFirstCharById", userId);
	}
	
}
