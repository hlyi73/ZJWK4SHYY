package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.AccessLogsHis;

/**
 * 访问日志 历史
 * @author liulin
 *
 */
public interface AccessLogsHisService extends EntityService{
	
	/**
	 * 查询访问日志 历史
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<AccessLogsHis> findAccessLogHisByFilter(String startDate, String endDate);
	
	/**
	 * 查询访问日志数量
	 * @param entId
	 * @return
	 */
	public String countAccessLogsHis(String url, String params, String startDate, String endDate);
	
	/**
	 * 分析访问历史数据 , 统计积分 
	 */
	public void addCalculateIntegralByLogsHis(List<AccessLogsHis> logsHis);
}
