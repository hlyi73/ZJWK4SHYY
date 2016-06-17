package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheduleResp;

/**
 * 日程任务  业务处理接口
 *
 * @author liulin
 */
public interface Schedule2SugarService extends EntityService {
	
	/**
	 * 查询 日程数据列表
	 * @return
	 */
	public ScheduleResp getScheduleList(Schedule sche,String source)throws Exception;
	
	/**
	 * 查询单个日程数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ScheduleResp getScheduleSingle(String rowId, String crmId,String schetype)throws Exception;
	
	/**
	 * 保存日程信息
	 * @param obj
	 * @return
	 */
	public CrmError addSchedule(Schedule obj);
	
	/**
	 * 日程的完成操作
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public CrmError updateScheduleComplete(Schedule sche, String crmId);
	
	/**
	 * 
	 * @param sche
	 * @return
	 */
	public CrmError updateScheduleParent(Schedule sche);
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteSchedule(String rowid);
	
}
