package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.message.sugar.ContractAdd;

/**
 * 合同前端缓存
 * @author liulin
 *
 */
public interface CacheContractService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheContract transf(String orgId, ContractAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ContractAdd invstransf(CacheContract cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheContract getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContract> findCacheContractListByCrmId(CacheContract cache);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheContract cache);
}
