package com.takshine.wxcrm.service;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.message.sugar.ScheduleResp;

@RunWith(SpringJUnit4ClassRunner.class)  
@ContextConfiguration(locations = { "classpath:spring-mvc.xml","classpath:applicationContext.xml" }) 
public class Schedule2SugarServiceTest {
	
	protected static Logger log = Logger.getLogger(Schedule2SugarServiceTest.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Test
	public void getScheduleList(){
		Schedule sche = new Schedule();
		// 查询日程列表
		try {
			sche.setViewtype(Constants.SEARCH_VIEW_TYPE_CALENDAR_VIEW);
			sche.setTitle("aa");
			ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche, "WEB");
			System.out.print("");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
