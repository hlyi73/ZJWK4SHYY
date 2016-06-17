package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.model.UserExperience;
import com.takshine.wxcrm.service.UserExperienceService;


/**
 * 履历实现类
 *
 */
@Service("userExperienceService")
public class UserExperienceServiceImpl extends BaseServiceImpl implements UserExperienceService{

	@Override
	protected String getDomainName() {
		return "UserExperience";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userExperienceSql.";
	}
	
	public BaseModel initObj() {
		return new UserExperience();
	}

}
