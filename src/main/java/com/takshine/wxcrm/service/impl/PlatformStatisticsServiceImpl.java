package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.PlatformStatistics;
import com.takshine.wxcrm.service.PlatformStatisticsService;

/**
 * 平台服务
 *
 */
@Service("platformStatisticsService")
public class PlatformStatisticsServiceImpl extends BaseServiceImpl implements PlatformStatisticsService{

	@Override
	protected String getDomainName() {
		return "PlatformStatistics";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "platformStatisticsSql.";
	}
	
	public BaseModel initObj() {
		return new PlatformStatistics();
	}

	public boolean saveStatistics(PlatformStatistics ps) throws Exception{
		ps.setId(Get32Primarykey.getRandom32PK());
		int flag = getSqlSession().insert("platformStatisticsSql.insertPlatformStatistics", ps);
		if(flag > 0){
			return true;
		}
		return false;
	}
	
}
