package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.service.CacheOpptyService;

/**
 * 商机前端缓存
 * @author liulin
 *
 */
@Service("cacheOpptyService")
public class CacheOpptyServiceImpl extends BaseServiceImpl implements CacheOpptyService{

	@Override
	protected String getDomainName() {
		return "CacheOppty";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheOpptySql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheOppty transf(String orgId, OpptyAdd add){
		CacheOppty cache = new CacheOppty();
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
		String proabability = add.getProbability();
		if(null == proabability || "".equals(proabability)){
			proabability = "0";
		}
		cache.setProbability(proabability);
		cache.setAssigner_id(add.getAssigner());
		cache.setStage(add.getSalesstage());
		cache.setAmount(add.getAmount());
		cache.setClose_date(add.getDateclosed());
		cache.setAccount_id(add.getCustomerid());
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public OpptyAdd invstransf(CacheOppty cache){
		OpptyAdd add = new OpptyAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		add.setName(cache.getName());
		//字段信息
		add.setProbability(cache.getProbability());
		add.setAssigner(cache.getAssigner_name());
		add.setSalesstage(getLovCacheVal(cache.getOrg_id(), "sales_stage_dom", cache.getStage()));
		add.setDateclosed(cache.getClose_date());
		add.setAmount(cache.getAmount());
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
	public CacheOppty getCrmIdByRowId(String rowId){
		CacheOppty cache = new CacheOppty();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheOppty)rst;
			//return cache.getCrm_id();
		}
		return new CacheOppty();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheOppty> findCacheOpptyListByCrmId(CacheOppty cache) {
		return getSqlSession().selectList("cacheOpptySql.findCacheOpptyListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheOppty cache) {
		getSqlSession().update("cacheOpptySql.updateEnabledFlag", cache);
	}
	
}
