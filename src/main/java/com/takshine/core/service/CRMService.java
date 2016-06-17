package com.takshine.core.service;

import java.text.SimpleDateFormat;

/**
 * 所有service的统一调用类
 * @author dengbo
 *
 */
public interface CRMService {

	/**
	 * 数据库service
	 * @return
	 */
	public DbService getDbService();
	
	/**
	 * 微信服务类
	 * @return
	 */
	public WxService getWxService();
	
	/**
	 * sugar服务类
	 * @return
	 */
	public SugarService getSugarService();
	
	/**
	 * 业务服务类
	 * @return
	 */
	public BusinessService getBusinessService();
}
