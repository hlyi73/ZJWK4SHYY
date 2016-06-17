package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.sugar.ContactAdd;

/**
 * 联系人前端缓存
 * @author liulin
 *
 */
public interface CacheContactService extends EntityService{
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheContact transf(String orgId, ContactAdd add);
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ContactAdd invstransf(CacheContact cache);
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheContact getCrmIdByRowId(String rowId);
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContact> findCacheContactListByCrmId(CacheContact cache);
	
	/**
	 * 更新可用标志
	 * @param cache
	 */
	public void updateEnabledFlag(CacheOppty cache);
	
	/**
	 * 手工分组 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<Tag> findHandGroupCacheContactListByFilter(CacheContact cache);
	
	/**
	 * 手工分组列表详情 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContact> findTagCacheContactListByFilter(CacheContact cache);
	
}
