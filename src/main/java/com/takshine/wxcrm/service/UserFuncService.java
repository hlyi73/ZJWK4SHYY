package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.UserFunc;

/**
 * 用户和手机绑定关系  业务处理接口
 *
 * @author liulin
 */
public interface UserFuncService extends EntityService {
    
	/**
	 * 根据查询条件查询 用户和手机绑定关系列表
	 * @param entId
	 * @return
	 */
	public List<UserFunc> getUserFuncListByPara(String crmId, String funIndx, String funParentId);
	
	
	/**
	 * 获取用户角色权限表
	 * @param crmId
	 * @param funIndx
	 * @param funParentId
	 * @return
	 */
	public List<UserFunc> getUserFuncListByFilter(UserFunc func);
	
	
	/**
	 * 获取所有权限表
	 * @param crmId
	 * @param funIndx
	 * @param funParentId
	 * @return
	 */
	public List<UserFunc> getAllFuncList(UserFunc func);
	
	
	/**
	 * 获取角色列表
	 * @param orgId
	 * @return
	 */
	public List<UserFunc> getRolesList(String orgId);	
	
	
	/**
	 * 获取角色用户列表
	 * @param orgId
	 * @return
	 */
	public List<DcCrmOperator> getRoleUsersList(UserFunc func);	
	
	
	/**
	 * 获取用户列表
	 * @param orgId
	 * @return
	 */
	public List<DcCrmOperator> getUsersList(UserFunc func);	
	
	/**
	 * 删除角色下的用户
	 * @param func
	 * @return
	 */
	public boolean deleteRoleUsers(UserFunc func);
	
	/**
	 * 删除角色下的功能
	 * @param func
	 * @return
	 */
	public boolean deleteRoleFuncs(UserFunc func);
	
	
	/**
	 * 保存角色下的用户
	 * @param func
	 * @return
	 */
	public boolean saveRoleUsers(List<UserFunc> funcList);
	
	/**
	 * 保存角色下的功能
	 * @param func
	 * @return
	 */
	public boolean saveRoleFuncs(List<UserFunc> funcList);
}
