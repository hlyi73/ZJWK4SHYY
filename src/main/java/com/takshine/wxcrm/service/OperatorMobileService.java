package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.message.sugar.AuthResp;

/**
 * 用户和手机绑定关系  业务处理接口
 *
 * @author liulin
 */
public interface OperatorMobileService extends EntityService {
    
	/**
	 * 根据查询条件查询 用户和手机绑定关系列表
	 * @param entId
	 * @return
	 */
	public List<OperatorMobile> getOperMobileListByPara(String orgId);
	
	/**
	 * 根据查询条件查询 用户和手机绑定关系列表数据
	 * @param entId
	 * @return
	 */
	public List<OperatorMobile> getOperMobileListByPara(OperatorMobile obj);
	
	/**
	 * 分页查询用户和手机绑定关系数据信息
	 * @param mobile
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getOperMobileListByPage(String entId, String page, String pageRows);
	
	/**
	 * 根据ID 获取用户和手机绑定关系对象
	 * @param id
	 * @return
	 */
	public OperatorMobile getOperMobileById(String id);
	
	/**
	 * 删除用户和手机绑定关系
	 * @param id
	 */
	public void delOperMobile(String id);
	
	
	/**
	 * 跟进crmId 删除用户和手机绑定关系 
	 * @param id
	 */
	public boolean delOperMobileByCrmId(String crmId);
	
	/**
	 * 修改用户和手机绑定关系
	 * @param obj
	 * @return
	 */
	public OperatorMobile updateOperMobile(OperatorMobile obj);
	
	/**
	 * 帐号绑定
	 * @param obj
	 * @return
	 */
	public AuthResp bindCrmAccount(OperatorMobile obj) throws Exception;
	
	/**
	 * 查询组织列表
	 * @param oper
	 * @return
	 * @throws Exception
	 */
	public List<OperatorMobile> getOrgList(OperatorMobile oper) throws Exception;
	
	/**
	 * 获取所有绑定的系统
	 * @param oper
	 * @return
	 * @throws Exception
	 */
	public List<OperatorMobile> getBindingOrgList(OperatorMobile oper) throws Exception;
	
	
	/**
	 * 获取未绑定的系统
	 * @param oper
	 * @return
	 * @throws Exception
	 */
	public List<OperatorMobile> getNoBindingOrgList(OperatorMobile oper) throws Exception;
	
}