package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Versions;

/**
 * 版本管理接口
 * @author liulin
 *
 */
public interface VersionsService extends EntityService{
	
	/**
	 * 查询最新版本 
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Versions findCurrentVersions();
	
	
}
