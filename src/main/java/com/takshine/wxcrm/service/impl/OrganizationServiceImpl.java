package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.service.OrganizationService;

/**
 * 组织
 * @author dengbo
 *
 */
@Service("organizationService")
public class OrganizationServiceImpl extends BaseServiceImpl implements OrganizationService{

	@Override
	protected String getDomainName() {
		return "Organization";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "organizationSql.";
	}
	
	public BaseModel initObj() {
		return new Messages();
	}
}
