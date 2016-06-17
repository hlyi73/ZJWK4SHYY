package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.PlatformStatistics;

/**
 * 平台统计
 *
 */
public interface PlatformStatisticsService extends EntityService{

	public boolean saveStatistics(PlatformStatistics ps) throws Exception;
}
