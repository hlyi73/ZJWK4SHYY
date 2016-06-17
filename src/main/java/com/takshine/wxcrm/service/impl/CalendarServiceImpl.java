package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.CalendarRss;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.service.CalendarService;
import com.takshine.wxcrm.service.Schedule2SugarService;
/**
 * 
 * @author lilei
 *
 */
@Service("calendarService")
public class CalendarServiceImpl extends BaseServiceImpl implements
		CalendarService {
	@Autowired
	@Qualifier("schedule2SugarService")
	private Schedule2SugarService schedule2SugarService;
	
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

	public CalendarRss getCalendarRss(Subscribe s,String startDate,String endDate) throws Exception {
	    if("group".equals(s.getType())){//群的时候去查 群活动
	    	
	    }else{
	    	Schedule sche = new Schedule();
			//组装查询条件
			sche.setViewtype("myview");//视图类型
			sche.setCrmId(s.getCrmId());
			sche.setCurrpage("1");
			sche.setPagecount("1000");
			sche.setStartdate(startDate);
			sche.setEnddate(endDate);
			sche.setAssignerId(s.getFeedid());
			//查询日程列表
			ScheduleResp sResp = schedule2SugarService.getScheduleList(sche,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ScheduleAdd> list = sResp.getTasks();
			}
	    }
		return null;
	}
}
