package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.service.CacheCustomerService;

/**
 * 客户前端缓存
 * @author liulin
 *
 */
@Service("cacheCustomerService")
public class CacheCustomerServiceImpl extends BaseServiceImpl implements CacheCustomerService{

	@Override
	protected String getDomainName() {
		return "CacheCustomer";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheCustomerSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheCustomer transf(String orgId, CustomerAdd add){
		CacheCustomer cache = new CacheCustomer();
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
		cache.setTelephone(add.getPhoneoffice());
		cache.setAccnttype(add.getAccnttype());
		cache.setIndusty(add.getIndustry());
		cache.setAddress(add.getStreet());
		
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CustomerAdd invstransf(CacheCustomer cache){
		CustomerAdd add = new CustomerAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		add.setName(cache.getName());
		//字段信息
		add.setPhoneoffice(cache.getTelephone());
		add.setIndustry(getLovCacheVal(cache.getOrg_id(), "industry_dom", cache.getIndusty()));
		add.setStreet(cache.getAddress());
		add.setAssigner(cache.getAssigner());
		//获取lov值
	    add.setAccnttype(getLovCacheVal(cache.getOrg_id(), "account_type_dom", cache.getAccnttype()));
				
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
	public CacheCustomer getCrmIdByRowId(String rowId){
		CacheCustomer cache = new CacheCustomer();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheCustomer)rst;
			//return cache.getCrm_id();
		}
		return new CacheCustomer();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheCustomer> findCacheCustomerListByCrmId(CacheCustomer cache) {
		return getSqlSession().selectList("cacheCustomerSql.findCacheCustomerListByCrmId", cache);
	}
	
	/**
	 * 根据rowid逻辑删除客户
	 * @param rowId
	 */
	public void updCacheCustomerByRowid(String rowId){
		getSqlSession().update("cacheCustomerSql.deleteCacheCustomerById", rowId);
	}
}
