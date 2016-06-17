package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleComplete;

/**
 * 日程前端缓存
 * @author liulin
 *
 */
public interface CacheScheduleService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheSchedule transf(String orgId, ScheduleAdd add);
	
	/**
	 * update 转换
	 * @param add
	 * @return
	 */
	public CacheSchedule transf(String orgId, ScheduleComplete add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ScheduleAdd invstransf(CacheSchedule cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheSchedule getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheSchedule> findCacheScheduleListByCrmId(CacheSchedule cache);
	
	/**
	 * 更新可用标志
	 * @param cache
	 */
	public void updateEnabledFlag(CacheSchedule cache);
	
	/**
	 * 更新相关
	 * @param cache
	 */
	public void updateScheduleParent(CacheSchedule cache);
	
	
	/**
	 * 查找任务
	 * 用于微信命令字菜单
	 * @param cache
	 * @return
	 */
	public List<CacheSchedule> findCacheScheduleListByOpenId(CacheSchedule cache);
}
