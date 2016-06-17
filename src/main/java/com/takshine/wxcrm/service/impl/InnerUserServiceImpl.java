package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Activity;
import com.takshine.wxcrm.domain.InnerUser;
import com.takshine.wxcrm.domain.RssNews;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.service.InnerUserService;
@Service("innerUserService")
public class InnerUserServiceImpl extends BaseServiceImpl implements
		InnerUserService {

	protected String getDomainName() {
		return "InnerUser";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "innerUserSql.";
	}
	
	public BaseModel initObj() {
		return new InnerUser();
	}
	
	public List<InnerUser> getInnerUserByOpenId(String openid,String firstChar)throws Exception {
		InnerUser user = new InnerUser();
		user.setOpenId(openid);
		if(firstChar!=null&&!"".equals(firstChar.trim())){
		user.setFirstChar(firstChar);
		}
		return getSqlSession().selectList("innerUserSql.findInnerUserListByOpenid", user);
	}

	public List<String> getFirstList(String openid) throws Exception {

		List<String> actList = getSqlSession().selectList("innerUserSql.findFirstList", openid);
		return actList;
	}

	public List<InnerUser> getRssUserByOpenId(Subscribe subscribe)
			throws Exception {
		List<InnerUser> actList = getSqlSession().selectList("innerUserSql.findRssUserListByOpenid", subscribe);
		return actList;
	}

}
