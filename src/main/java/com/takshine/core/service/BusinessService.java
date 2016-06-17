package com.takshine.core.service;

import com.takshine.core.service.business.AccountService;
import com.takshine.core.service.business.ActivityService;
import com.takshine.core.service.business.CalendarService;
import com.takshine.core.service.business.DiscuGroupMainService;
import com.takshine.core.service.business.LOVService;
import com.takshine.core.service.business.WorkPlanService;


/**
 * 业务服务汇总
 * @author yihailong
 *
 */
public interface BusinessService{
	public AccountService getAccountService();
	public LOVService getLOVService();
	public DiscuGroupMainService getDiscuGroupMainService();
	public CalendarService getCalendarService();
	public ActivityService getActivityService();
	public WorkPlanService getWorkPlanService();
	public CacheService getCacheService();
}
