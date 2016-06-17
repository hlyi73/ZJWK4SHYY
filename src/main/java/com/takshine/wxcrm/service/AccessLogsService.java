package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.message.sugar.AccesslogResp;

/**
 * 访问日志接口
 * @author liulin
 *
 */
public interface AccessLogsService extends EntityService{
	
	/**
	 * 查询访问日志 
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<AccessLogs> findAccessLogByFilter(String crmId,String startDate, String endDate, Integer curr, Integer pagecount);
	
	/**
	 * 查询访问日志数量
	 * @param entId
	 * @return
	 */
	public String countAccessLogs(String crmId,String url, String params, String startDate, String endDate);
	
	/**
	 * 访问统计
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<AccessLogs> countAccessLogs(String crmId,String startDate,String endDate,String type);
	
	
	/**
	 * 用户行为统计
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public AccesslogResp addcountAccessLogs(AccessLogs sche , String source);
	
	
}
