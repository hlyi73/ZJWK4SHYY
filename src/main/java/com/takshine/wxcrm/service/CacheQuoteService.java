package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.message.sugar.QuoteAdd;

/**
 * 报价前端缓存
 * @author liulin
 *
 */
public interface CacheQuoteService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheQuote transf(String orgId, QuoteAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public QuoteAdd invstransf(CacheQuote cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheQuote getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheQuote> findCacheQuoteListByCrmId(CacheQuote cache);
	
	/**
	 * 更新可用标志
	 * @param cache
	 */
	public void updateEnabledFlag(CacheOppty cache);
}
