package com.takshine.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.BusinessService;
import com.takshine.core.service.CacheService;
import com.takshine.core.service.business.AccountService;
import com.takshine.core.service.business.ActivityService;
import com.takshine.core.service.business.CalendarService;
import com.takshine.core.service.business.DiscuGroupMainService;
import com.takshine.core.service.business.LOVService;
import com.takshine.core.service.business.WorkPlanService;
import com.takshine.core.service.business.impl.WorkPlanServiceImpl;


/**
 * 业务服务汇总
 * @author yihailong
 *
 */
@Service("businessService")
public class BusinessServiceImpl implements BusinessService {
	
	/**
	 * 客户服务
	 */
	@Autowired
	@Qualifier("accountService")
	public AccountService accountService;
	
	/**
	 * LOV服务
	 */
	@Autowired
	@Qualifier("lOVService")
	public LOVService lovService;
	/**
	 * 日程服务
	 */
	@Autowired
	@Qualifier("calendarCoreService")
	public CalendarService calendarService;
	
	
	/**
	 * 客户服务
	 */
	@Autowired
	@Qualifier("coreBusinessActivityService")
	public ActivityService activityService;
	
	/**
	 * 工作计划服务
	 */
	@Autowired
	@Qualifier("coreBusinessWorkPlanService")
	public WorkPlanService workPlanService;

	/**
	 * 讨论组主服务
	 */
	@Autowired
	@Qualifier("discuGroupMainService")
	public DiscuGroupMainService discuGroupMainService;

	/**
	 * Cache服务
	 */
	@Autowired
	@Qualifier("cacheService")
	public CacheService cacheService;

	public AccountService getAccountService() {
		return accountService;
	}
	public LOVService getLOVService(){
		return lovService;
	}
	public DiscuGroupMainService getDiscuGroupMainService() {
		return discuGroupMainService;
	}
	public CalendarService getCalendarService() {
		return calendarService;
	}
	public ActivityService getActivityService() {
		return activityService;
	}
	public WorkPlanService getWorkPlanService() {
		return workPlanService;
	}
	public CacheService getCacheService() {
		return cacheService;
	}
}
