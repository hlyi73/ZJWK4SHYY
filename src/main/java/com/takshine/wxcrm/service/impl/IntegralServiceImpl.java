package com.takshine.wxcrm.service.impl;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.AccessLogsHis;
import com.takshine.wxcrm.service.IntegralService;

/**
 * 积分
 * @author liulin
 *
 */
@Service("integralService")
public class IntegralServiceImpl extends BaseServiceImpl implements IntegralService{

	private static Logger log = Logger.getLogger(IntegralServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "Integral";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "integralSql.";
	}
	
	public BaseModel initObj() {
		return new AccessLogsHis();
	}
	
	
}
