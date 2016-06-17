package com.takshine.core.service.business;

import java.util.List;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;


/**
 * 日程服务
 * @author yihailong
 *
 */
public interface CalendarService{
	public List<ScheduleAdd> getScheduleList(Schedule sche)throws CRMException;
	public ScheduleAdd getSchedule(String rowid)throws CRMException;
	public void addSchedule(Schedule obj)throws CRMException;
	public void deleteSchedule(String rowid)throws CRMException;
	public void updateSchedule(Schedule obj)throws CRMException;
}
