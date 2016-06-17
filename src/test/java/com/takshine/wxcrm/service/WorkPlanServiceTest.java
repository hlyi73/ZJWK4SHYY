package com.takshine.wxcrm.service;

import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.ServiceUtils;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.message.sugar.ScheduleResp;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-mvc.xml",
		"classpath:applicationContext.xml" })
public class WorkPlanServiceTest {

	protected static Logger logger = Logger
			.getLogger(WorkPlanServiceTest.class.getName());

	@Test
	public void exportAppraise() {
		try {

			// 取前一个自然月时间段
			Calendar cal1 = Calendar.getInstance();
			cal1.add(Calendar.MONTH, -1);
			cal1.set(Calendar.DAY_OF_MONTH, 1);
			cal1.set(Calendar.HOUR_OF_DAY, 0);
			cal1.set(Calendar.MINUTE, 0);
			cal1.set(Calendar.SECOND, 0);
			Calendar cal3 = Calendar.getInstance();
			cal3.set(Calendar.DAY_OF_MONTH, 1);
			cal3.set(Calendar.HOUR_OF_DAY, 0);
			cal3.set(Calendar.MINUTE, 0);
			cal3.set(Calendar.SECOND, 0);
			cal3.add(Calendar.SECOND, -1);

			Date start = cal1.getTime();
			Date end = cal3.getTime();
			ServiceUtils.getCRMService().getBusinessService()
					.getWorkPlanService().exportAppraise(start, end);
		} catch (CRMException e) {
			logger.error(e);
		}
	}
}
