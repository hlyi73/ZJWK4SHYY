package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.UserPerferences;
import com.takshine.wxcrm.service.UserPerferencesService;

/**
 * 个性化设置服务
 * @author liulin
 *
 */
@Service("userPerferencesService")
public class UserPerferencesImpl extends BaseServiceImpl implements UserPerferencesService {

	@Override
	protected String getDomainName() {
		return "UserPerferences";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userPerferencesSql.";
	}
	
	public BaseModel initObj() {
		return new UserPerferences();
	}
	
	public void deleteUserPerferencesByParam(UserPerferences u){
		getSqlSession().delete(getNamespace() + "deleteUserPerferencesByParam", u);
	}
	/**
	 * 自动创建周工作计划
	 */
	public void updateAutoWeekWorkRerportByParam() {
		// TODO Auto-generated method stub
		getSqlSession().insert(getNamespace() + "insertAutoWeekWorkRerportByParam", new UserPerferences());
		
	}
	/**
	 * 自动创建日工作计划
	 */
	public void updateAutoDayWorkRerportByParam() {
		// TODO Auto-generated method stub
		getSqlSession().insert(getNamespace() + "insertAutoDayWorkRerportByParam", new UserPerferences());
	}
	
}
