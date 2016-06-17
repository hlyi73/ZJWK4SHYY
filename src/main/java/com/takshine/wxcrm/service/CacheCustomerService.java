package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.message.sugar.CustomerAdd;

/**
 * 客户前端缓存
 * @author liulin
 *
 */
public interface CacheCustomerService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheCustomer transf(String orgId, CustomerAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CustomerAdd invstransf(CacheCustomer cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheCustomer getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheCustomer> findCacheCustomerListByCrmId(CacheCustomer cache);
	
	/**
	 * 根据rowid逻辑删除客户
	 * @param rowId
	 */
	public void updCacheCustomerByRowid(String rowId);
}
