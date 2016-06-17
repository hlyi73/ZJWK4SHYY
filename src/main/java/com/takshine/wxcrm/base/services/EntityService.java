package com.takshine.wxcrm.base.services;

import java.util.List;

import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.domain.cache.CacheBase;


public interface EntityService {
	
	public abstract BaseModel initObj();

	public abstract List<?> findAllObjList();
	
	public abstract List<?> findObjListByFilter(BaseModel obj);
	
	public abstract List<?> findObjListByFilter(CacheBase obj);
	
	public abstract Page findObjListByPage(QueryFilter filter);
	
	public abstract BaseModel findObj(BaseModel basemodel);
	
	public abstract CacheBase findObj(CacheBase basemodel);
	
	public abstract BaseModel findObjById(String s);
	
	public abstract String addObj(BaseModel basemodel) throws Exception;
	
	public abstract String addObj(CacheBase basemodel) throws Exception;
	
	public abstract void deleteObjById(String s) throws Exception;

	public abstract void updateObj(BaseModel basemodel) throws Exception;
	
	public abstract void updateObj(CacheBase basemodel) throws Exception;
	
	public int countObjByFilter(BaseModel baseModel);
	
    /**
     * 检测绑定
     * @param openId
     * @param publicId
     * @throws Exception
     */
	public OperatorMobile checkBinding(String openId, String publicId) throws Exception;
	
	/**
	 * 检测绑定
	 * @param openId
	 * @param publicId
	 * @throws Exception
	 */
	public OperatorMobile checkBindByOrgId(String openId, String publicId, String orgId) throws Exception ;
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public boolean JudgeBinding(String openId, String publicId);
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public String getCrmId(String openId, String publicId);
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public String getCrmIdByOrgId(String openId, String publicId, String orgId);
	
	/**
	 * 通过openId 和 publicId 查询关联的所有crmId数据
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<String> getCrmIdArr(String openId, String publicId, String orgIdNot);
	
	/**
	 * 得到用户的orgId
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public String getOrgId(String openId,String publicId,String crmId);
	
	/**
	 * 跟进crmId 获得openId
	 * @param crmId
	 * @return
	 */
	public String getOpenIdByCrmId(String crmId);
	
	/**
	 * 取消绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public boolean cancelBinding(String openId,String publicId,String orgId);
	
	/**
     * 查询 德成CRM用户 所拥有的功能菜单列表 
     * @param crmId
     * @throws Exception
     */
	public List<UserFunc> getDcUserFuncList(String crmId, String func, String fType);
	
    /**
     * 查询 德成CRM用户 所拥有的功能菜单列表 
     * @param crmId
     * @param func
     * @throws Exception
     */
	public boolean checkFunc(String crmId, String func);
	
	/**
	 * 根据OpenId获取CRMId及对应的ORGId
	 * @param openId
	 * @param publicId
	 * @param orgIdNot
	 * @return
	 */
	public List<Organization> getCrmIdAndOrgIdArr(String openId, String publicId, String orgIdNot);

}
