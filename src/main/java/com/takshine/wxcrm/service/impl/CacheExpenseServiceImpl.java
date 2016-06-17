package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheExpense;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.service.CacheExpenseService;

/**
 * 费用前端缓存
 * @author liulin
 *
 */
@Service("cacheExpenseService")
public class CacheExpenseServiceImpl extends BaseServiceImpl implements CacheExpenseService{

	@Override
	protected String getDomainName() {
		return "CacheExpense";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "cacheExpenseSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public CacheExpense transf(String orgId, ExpenseAdd add){
		CacheExpense cache = new CacheExpense();
		String assignerid = add.getAssignid();
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
		cache.setName(add.getName());
		cache.setExpense_date(add.getExpensedate());
		cache.setExpense_status(add.getApprovalstatus());
		cache.setExpense_subtype(add.getExpensesubtype());
		cache.setExpense_type(add.getExpensetype());
		cache.setExpense_amount(Float.parseFloat(add.getExpenseamount()));
		cache.setParent_id(add.getParentid());
		cache.setParent_type(add.getParenttype());
		return cache;
	}
	
	/**
	 * 转换
	 * @param add
	 * @return
	 */
	public ExpenseAdd invstransf(CacheExpense cache){
		ExpenseAdd add = new ExpenseAdd();
		add.setRowid(cache.getRowid());
		add.setCrmaccount(cache.getCrm_id());
		add.setOrgId(cache.getOrg_id());
		add.setCreatedate(cache.getCreate_date());
		add.setCreater(cache.getCreate_by());
		//字段信息
		add.setName(cache.getName());
		add.setExpensedate(cache.getExpense_date());
		add.setExpensestatus(cache.getExpense_status());
		add.setExpensestatusname(getLovCacheVal(cache.getOrg_id(), "expense_status_list", cache.getExpense_status()));
		add.setExpensesubtype(cache.getExpense_subtype());
		add.setExpensesubtypename(getLovCacheVal(cache.getOrg_id(), "expense_sub_type_list", cache.getExpense_subtype()));
		add.setExpensetype(cache.getExpense_type());
		add.setExpensetypename(getLovCacheVal(cache.getOrg_id(), "expense_type_list", cache.getExpense_type()));
		add.setExpenseamount(cache.getExpense_amount() +"");
		add.setParentid(cache.getParent_id());
		add.setParenttype(cache.getParent_type());
		add.setParentname(cache.getParent_name());
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
	public CacheExpense getCrmIdByRowId(String rowId){
		CacheExpense cache = new CacheExpense();
		cache.setRowid(rowId);
		Object rst = findObj(cache);
		if(rst != null){
			return (CacheExpense)rst;
			//return cache.getCrm_id();
		}
		return new CacheExpense();
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheExpense> findCacheExpenseListByCrmId(CacheExpense cache) {
		return getSqlSession().selectList("cacheExpenseSql.findCacheExpenseListByCrmId", cache);
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public void updateEnabledFlag(CacheExpense cache) {
		getSqlSession().update("cacheExpenseSql.updateEnabledFlag", cache);
	}
	
}
