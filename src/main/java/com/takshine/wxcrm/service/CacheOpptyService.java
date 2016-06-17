package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.sugar.OpptyAdd;

/**
 * 商机前端缓存
 * @author liulin
 *
 */
public interface CacheOpptyService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheOppty transf(String orgId, OpptyAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public OpptyAdd invstransf(CacheOppty cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheOppty getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheOppty> findCacheOpptyListByCrmId(CacheOppty cache);
	
	/**
	 * 更新可用标志
	 * @param cache
	 */
	public void updateEnabledFlag(CacheOppty cache);
	
}
