package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.UserLocation;
import com.takshine.wxcrm.service.WxUserLocationService;

/**
 * 微信 用户地址服务 实现类
 * @author liulin
 *
 */
@Service("wxUserLocationService")
public class WxUserLocationServiceImpl extends BaseServiceImpl implements WxUserLocationService {
	

	@Override
	protected String getDomainName() {
		return "UserLocation";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userLocationSql.";
	}
	
	public BaseModel initObj() {
		return new UserLocation();
	}

}
