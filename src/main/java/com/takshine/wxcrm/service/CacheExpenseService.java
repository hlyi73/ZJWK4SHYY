package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheExpense;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;

/**
 * 费用前端缓存
 * @author liulin
 *
 */
public interface CacheExpenseService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheExpense transf(String orgId, ExpenseAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ExpenseAdd invstransf(CacheExpense cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheExpense getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存列表
	 * @param crmId
	 * @return
	 */
	public List<CacheExpense> findCacheExpenseListByCrmId(CacheExpense cache);
	
	/**
	 * 更新可用标志
	 * @param cache
	 */
	public void updateEnabledFlag(CacheExpense cache);
	
}
