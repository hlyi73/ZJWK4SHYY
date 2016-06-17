package com.takshine.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.BusinessService;
import com.takshine.core.service.CRMService;
import com.takshine.core.service.DbService;
import com.takshine.core.service.SugarService;
import com.takshine.core.service.WxService;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.ServiceUtils;

/**
 * 所有service的统一调用类
 * @author dengbo
 *
 */
@Service("cRMService")
public class CRMServiceImpl extends BaseServiceImpl implements CRMService {
	
	public CRMServiceImpl(){
		ServiceUtils.setCRMService(this);
	}
	/**
	 * 数据库服务类
	 */
	@Autowired
	@Qualifier("dbService")
	public DbService dbService;
	
	/**
	 * 微信服务类
	 */
	@Autowired
	@Qualifier("wxService")
	public WxService wxService;
	
	/**
	 * sugar服务类
	 */
	@Autowired
	@Qualifier("sugarService")
	public SugarService sugarService;
	
	/**
	 * 业务服务类
	 */
	@Autowired
	@Qualifier("businessService")
	public BusinessService businessService;

	public DbService getDbService() {
		return dbService;
	}

	public WxService getWxService() {
		return wxService;
	}

	public SugarService getSugarService() {
		return sugarService;
	}

	public BusinessService getBusinessService() {
		return businessService;
	}
	
}
