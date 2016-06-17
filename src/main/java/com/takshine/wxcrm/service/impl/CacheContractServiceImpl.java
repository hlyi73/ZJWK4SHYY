package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.message.sugar.ContractAdd;
import com.takshine.wxcrm.service.CacheContractService;

/**
 * 合同前端缓存
 * @author liulin
 *
 */
@Service("cacheContractService")
public class CacheContractServiceImpl extends BaseServiceImpl implements CacheContractService{

	@Override
	protected String getDomainName() {
		return "CacheContract";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheContractSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheContract transf(String orgId, ContractAdd add){
		CacheContract cache = new CacheContract();
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
		if(null != orgId && !"".equals(orgId)){
			cache.setOrg_id(orgId);
		}
		//其它字段
		cache.setStatus(add.getContractstatus());
		cache.setName(add.getTitle());
		cache.setAssigner_id(add.getCrmaccount());
		cache.setStart_date(add.getStartDate());
		cache.setEnd_date(add.getEndDate());
		cache.setCost(add.getCost());
		cache.setRecived_amount(add.getRecivedAmount());
		
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ContractAdd invstransf(CacheContract cache){
		ContractAdd add = new ContractAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		//其它字段
		add.setContractstatusname(getLovCacheVal(cache.getOrg_id(), "contacts_status_list", cache.getStatus()));
		add.setTitle(cache.getName());
		add.setAssigner(cache.getAssigner_name());
		add.setStartDate(cache.getStart_date());
		add.setEndDate(cache.getEnd_date());
		add.setCost(cache.getCost());
		add.setRecivedAmount(cache.getRecived_amount());
				
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
	public CacheContract getCrmIdByRowId(String rowId){
		CacheContract cache = new CacheContract();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheContract)rst;
			//return cache.getCrm_id();
		}
		return new CacheContract();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheContract> findCacheContractListByCrmId(CacheContract cache) {
		return getSqlSession().selectList("cacheContractSql.findCacheContractListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheContract cache) {
		getSqlSession().update("cacheContractSql.updateEnabledFlag", cache);
	}
}
