package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Register;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.SysApplyAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;

/**
 * @author dengbo
 *
 */
public interface RegisterService extends EntityService{
	
	/**
	 * 创建管理员用户
	 * @param sysApplyAdd
	 * @return
	 */
	public String createAdmin(SysApplyAdd sysApplyAdd);
	
	/**
	 * 保存部门
	 * @param crmId
	 * @param dataColl
	 * @return
	 */
	public CrmError saveDepts(String crmId,String lovVal,String lovKey);
	
	/**
	 * 保存用户
	 * @param userAdd
	 * @return
	 */
	public CrmError saveUser(UserAdd userAdd);
	
	
	public boolean addApply(SysApplyAdd sysApplyAdd);
	
	
	public List<SysApplyAdd> searchApplyOrgs(SysApplyAdd sysApplyAdd);
	
}
