package com.takshine.wxcrm.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleComplete;
import com.takshine.wxcrm.service.CacheScheduleService;

/**
 * 联系人前端缓存
 * @author liulin
 *
 */
@Service("cacheScheduleService")
public class CacheScheduleServiceImpl extends BaseServiceImpl implements CacheScheduleService{

	@Override
	protected String getDomainName() {
		return "CacheSchedule";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheScheduleSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheSchedule transf(String orgId, ScheduleAdd add){
		CacheSchedule cache = new CacheSchedule();
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
		//字段信息
		cache.setSche_type(add.getSchetype());
		cache.setName(add.getTitle());
		cache.setStatus(add.getStatus());
		cache.setStart_date(add.getStartdate());
		cache.setEnd_date(add.getEnddate());
		cache.setRela_id(add.getParentId());
		cache.setRela_name(add.getParentType());
		cache.setRela_type(add.getParentType());
		cache.setIspublic(add.getIspublic());
		return cache;
	}
	
	/**
	 * update 转换
	 * @param add
	 * @return
	 */
	public CacheSchedule transf(String orgId, ScheduleComplete add){
		CacheSchedule cache = new CacheSchedule();
		//String assignerid = add.getAssignerid();
		//if(null != assignerid && !"".equals(assignerid)){
			//cache.setCrm_id(assignerid);
		//}else{
			cache.setCrm_id(add.getCrmaccount());
		//}
		cache.setOrg_id(add.getOrgId());
		cache.setOpen_id(getOpenIdByCrmId(add.getCrmaccount()));
		cache.setRowid(add.getRowid());
		cache.setCreate_date(DateTime.currentDate(DateTime.DateFormat2));
		cache.setCreate_by(add.getCrmaccount());
		
		if(null != orgId && !"".equals(orgId)){
			cache.setOrg_id(orgId);
		}
		//字段信息
		cache.setSche_type(add.getSchetype());
		cache.setStatus(add.getStatus());
		cache.setStart_date(add.getStartdate());
		cache.setEnd_date(add.getEnddate());
		cache.setRela_id(add.getParentId());
		cache.setRela_name(add.getParentType());
		cache.setRela_type(add.getParentType());
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ScheduleAdd invstransf(CacheSchedule cache){
		ScheduleAdd add = new ScheduleAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		add.setAssignerid(cache.getCrm_id());
		add.setAssigner(cache.getAssigner_name());
		
		//字段信息
		add.setSchetype(cache.getSche_type());
		add.setTitle(cache.getName());
		add.setStatus(cache.getStatus());
		//状态名字
		add.setStatusname(getLovCacheVal(cache.getOrg_id(), "status_dom", cache.getStatus()));
		add.setStartdate(cache.getStart_date());
		add.setEnddate(cache.getEnd_date());
		add.setRelarowid(cache.getRela_id());
		add.setRelaname(cache.getRela_name());
		add.setRelamodule(cache.getRela_type());
		add.setOpenId(cache.getOpen_id());
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
	public CacheSchedule getCrmIdByRowId(String rowId){
		CacheSchedule cache = new CacheSchedule();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheSchedule)rst;
			//return cache.getCrm_id();
		}
		return new CacheSchedule();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheSchedule> findCacheScheduleListByCrmId(CacheSchedule cache) {
		return getSqlSession().selectList("cacheScheduleSql.findCacheScheduleListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheSchedule cache) {
		getSqlSession().update("cacheScheduleSql.updateEnabledFlag", cache);
	}

	public void updateScheduleParent(CacheSchedule cache) {
		getSqlSession().update("cacheScheduleSql.updateScheduleParent", cache);
	}

	public List<CacheSchedule> findCacheScheduleListByOpenId(CacheSchedule cache) {
		return getSqlSession().selectList("cacheScheduleSql.findCacheScheduleListByOpenId", cache);
	}
	
}
