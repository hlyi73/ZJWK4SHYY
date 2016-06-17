package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.WeekReport;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.WeekReportResp;

/**
 * 周报 业务处理接口
 *
 * @author dengbo
 */
public interface WeekReport2SugarService extends EntityService {
	
	/**
	 * 查询周报数据列表
	 * @return
	 */
	public WeekReportResp getWeekReportList(WeekReport wReport,String source);
	
	/**
	 * 查询单个周报数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public WeekReportResp getWeekReportSingle(String rowId, String crmId);
	
	/**
	 * 保存周报信息
	 * @param oppty
	 * @return
	 */
	public CrmError addWeekReport(WeekReport wReport);
	

}
