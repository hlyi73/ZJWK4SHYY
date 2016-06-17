package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.DcCrmOperator;

/**
 * 德成CRM用户 业务处理接口
 *
 * @author liulin
 */
public interface DcCrmOperatorService extends EntityService {

	/**
	 * 根据查询条件查询 德成CRM用户列表
	 * 
	 * @param entId
	 * @return
	 */
	public List<DcCrmOperator> getDcCrmOperatorListByPara(String orgId);

	
	/**
	 * 根据查询条件查询 德成CRM用户列表
	 * 
	 * @param entId
	 * @return
	 */
	public List<DcCrmOperator> findDcCrmOperatorListByFilter(String crmId);

	
	/**
	 * 分页查询德成CRM用户数据信息
	 * 
	 * @param mobile
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getDcCrmOperatorListByPage(String orgId, String page,
			String pageRows);

	/**
	 * 根据ID 获取德成CRM用户对象
	 * 
	 * @param id
	 * @return
	 */
	public DcCrmOperator getDcCrmOperatorById(String id);
	

	/**
	 * 删除德成CRM用户
	 * 
	 * @param id
	 */
	public void delDcCrmOperator(String id);

	/**
	 * 修改德成CRM用户
	 * 
	 * @param obj
	 * @return
	 */
	public DcCrmOperator updateDcCrmOperator(DcCrmOperator obj);
	
	/**
	 * 修改用户和手机绑定关系 同时更新缓存
	 * @param obj
	 * @return
	 */
	public DcCrmOperator updateDcCrmByCrmId(DcCrmOperator obj);
	
	
	/**
	 * 根据openId 和 OrgId 查找用户名
	 * @param obj
	 * @return
	 */
	public DcCrmOperator findDcCrmOperatorByOpenId(DcCrmOperator obj);
	
	/**
	 * 跟进partyid 查询 德成用户
	 * @param partyId
	 * @return
	 */
	public DcCrmOperator findDcCrmOperatorByPartyId(String partyId);

}