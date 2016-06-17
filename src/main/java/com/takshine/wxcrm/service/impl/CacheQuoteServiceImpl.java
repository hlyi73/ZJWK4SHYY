package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.message.sugar.QuoteAdd;
import com.takshine.wxcrm.service.CacheQuoteService;

/**
 *保教前端缓存
 * @author liulin
 *
 */
@Service("cacheQuoteService")
public class CacheQuoteServiceImpl extends BaseServiceImpl implements CacheQuoteService{

	@Override
	protected String getDomainName() {
		return "CacheQuote";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheQuoteSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheQuote transf(String orgId, QuoteAdd add){
		CacheQuote cache = new CacheQuote();
		String assignerid = add.getAssignerid();
		if(null != assignerid && !"".equals(assignerid)){
			cache.setCrm_id(assignerid);
		}else{
			cache.setCrm_id(add.getCrmaccount());
		}
		cache.setOrg_id(add.getOrgId());
		cache.setOpen_id(getOpenIdByCrmId(add.getCrmaccount()));
		cache.setRowid(add.getRowid());
		cache.setCreate_date(DateTime.currentDate(DateTime.DateTimeFormat1));
		cache.setCreate_by(add.getCrmaccount());
		cache.setName(add.getName());
		if(null != orgId && !"".equals(orgId)){
			cache.setOrg_id(orgId);
		}
		//字段信息
		cache.setAmount(add.getAmount());
		cache.setStatus(add.getStatus());
		cache.setQuotedate(add.getQuotedate());
		cache.setAssigner_id(add.getAssignerid());
		
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public QuoteAdd invstransf(CacheQuote cache){
		QuoteAdd add = new QuoteAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		add.setName(cache.getName());
		//字段信息
		add.setAmount(cache.getAmount());
		add.setStatus(cache.getStatus());
		add.setQuotedate(cache.getQuotedate());
		add.setAssigner(cache.getAssigner_name());
		
		return add;
	}
	
	/**
	 * 获取缓存值
	 * @param orgId
	 * @param key
	 * @return
	 */
	public String getLovCacheVal(String orgId,String name, String key){
		return RedisCacheUtil.getLovCacheVal(orgId, name, key);
	}
	
	/**
	 * 根据rowid查找crmid
	 * @return
	 */
	public CacheQuote getCrmIdByRowId(String rowId){
		CacheQuote cache = new CacheQuote();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheQuote)rst;
			//return cache.getCrm_id();
		}
		return new CacheQuote();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheQuote> findCacheQuoteListByCrmId(CacheQuote cache) {
		return getSqlSession().selectList("cacheQuoteSql.findCacheQuoteListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheOppty cache) {
		getSqlSession().update("cacheQuoteSql.updateEnabledFlag", cache);
	}
	
}
