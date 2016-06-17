package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.service.CacheContactService;

/**
 * 联系人前端缓存
 * @author liulin
 *
 */
@Service("cacheContactService")
public class CacheContactServiceImpl extends BaseServiceImpl implements CacheContactService{

	@Override
	protected String getDomainName() {
		return "CacheContact";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheContactSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheContact transf(String orgId, ContactAdd add){
		CacheContact cache = new CacheContact();
		String assignerid = add.getAssignerId();
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
		if(null != orgId && !"".equals(orgId)){
			cache.setOrg_id(orgId);
		}
		//字段信息
		cache.setName(add.getConname());
		cache.setSalutation(add.getSalutation());//称谓
		cache.setPosition(add.getConjob());//职位
		cache.setMobile(add.getPhonemobile());//手机号码
		cache.setFilename(add.getFilename());
		cache.setEmail(add.getEmail());
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ContactAdd invstransf(CacheContact cache){
		ContactAdd add = new ContactAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		//字段信息
		add.setConname(cache.getName());
		if(StringUtils.isNotNullOrEmptyStr(cache.getSalutation()) && "Mr.".equals(cache.getSalutation())){
			add.setSalutation("先生");
		}else if(StringUtils.isNotNullOrEmptyStr(cache.getSalutation()) && "Ms.".equals(cache.getSalutation())){
			add.setSalutation("女士");
		}
		
		add.setConjob(cache.getPosition());
		add.setPhonemobile(cache.getMobile());
		add.setFilename(cache.getFilename());		
		add.setFirstname(cache.getFirstname());
		add.setEmail(cache.getEmail());
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
	public CacheContact getCrmIdByRowId(String rowId){
		CacheContact cache = new CacheContact();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheContact)rst;
			//return cache.getCrm_id();
		}
		return new CacheContact();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContact> findCacheContactListByCrmId(CacheContact cache) {
		return getSqlSession().selectList("cacheContactSql.findCacheContactListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheOppty cache) {
		getSqlSession().update("cacheContactSql.updateEnabledFlag", cache);
	}
	
	/**
	 * 手工分组 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<Tag> findHandGroupCacheContactListByFilter(CacheContact cache){
		return getSqlSession().selectList("cacheContactSql.findHandGroupCacheContactListByFilter", cache);
	}
	
	/**
	 * 手工分组列表详情 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContact> findTagCacheContactListByFilter(CacheContact cache){
		return getSqlSession().selectList("cacheContactSql.findTagCacheContactListByFilter", cache);
	}
}
