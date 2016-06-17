package com.takshine.wxcrm.service.impl;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Versions;
import com.takshine.wxcrm.service.VersionsService;

/**
 * 版本管理
 * @author
 *
 */
@Service("versionsService")
public class VersionsServiceImpl extends BaseServiceImpl implements VersionsService{

	private static Logger log = Logger.getLogger(VersionsServiceImpl.class.getName());


	@Override
	protected String getDomainName() {
		return "Versions";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "versionsSql.";
	}
	
	public BaseModel initObj() {
		return new Versions();
	}
	
	/**
	 * 查询访问日志数量
	 * @param entId
	 * @return
	 */
	public Versions findCurrentVersions(){
		
		Versions v  = new Versions();

		v = getSqlSession().selectOne("versionsSql.findCurrentVersions", v);
		
		return v;
	}
}
