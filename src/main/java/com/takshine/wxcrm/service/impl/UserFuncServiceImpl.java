package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.service.UserFuncService;

/**
 * 用户和手机绑定关系   相关业务接口实现
 *
 * @author liulin
 */
@Service("userFuncService")
public class UserFuncServiceImpl extends BaseServiceImpl implements UserFuncService {
	
	private static Logger log = Logger.getLogger(UserFuncServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "UserFunc";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userFuncSql.";
	}
	
	public BaseModel initObj() {
		return new UserFunc();
	}

	/**
	 * 根据查询条件查询 用户和手机绑定关系列表数据
	 * @param entId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<UserFunc> getUserFuncListByPara(String crmId, String funIdx, String funParentId) {
		log.info("getUserFuncListByPara crmId = " + crmId);
		//search param
		UserFunc obj = new UserFunc();
		if(null != crmId && !"".equals(crmId)) obj.setCrmId(crmId);//CrmId
		if(null != funParentId && !"".equals(funParentId)) obj.setFunParentId(funParentId);//funParentId ID
		if(null != funIdx && !"".equals(funIdx)) obj.setFunIdx(funIdx);//funIdx ID
		return (List<UserFunc>)findObjListByFilter(obj);
	}

	/**
	 * 获取用户权限表
	 */
	public List<UserFunc> getUserFuncListByFilter(UserFunc func) {
		// TODO Auto-generated method stub
		
		List<UserFunc> funcList = getSqlSession().selectList("userFuncSql.findUserFuncList", func);
		return funcList;
	}

	/**
	 * 获取角色列表
	 */
	public List<UserFunc> getRolesList(String orgId) {
		// TODO Auto-generated method stub
		UserFunc obj = new UserFunc();
		if(null != orgId && !"".equals(orgId)) obj.setOrgId(orgId);
		List<UserFunc> funcList = getSqlSession().selectList("userFuncSql.findRolesList", obj);
		return funcList;
	}

	/**
	 * 获取角色用户列表
	 */
	public List<DcCrmOperator> getRoleUsersList(UserFunc func) {
		List<DcCrmOperator> funcList = getSqlSession().selectList("userFuncSql.findRoleUsersList", func);
		return funcList;
	}

	/**
	 * 获取所有用户列表
	 */
	public List<DcCrmOperator> getUsersList(UserFunc func) {
		List<DcCrmOperator> funcList = getSqlSession().selectList("userFuncSql.findUsersList", func);
		return funcList;
	}

	/**
	 * 获取所有权限
	 */
	public List<UserFunc> getAllFuncList(UserFunc func) {
		List<UserFunc> funcList = getSqlSession().selectList("userFuncSql.findALLFuncList", func);
		return funcList;
	}

	/**
	 * 删除角色下的用户
	 */
	public boolean deleteRoleUsers(UserFunc func) {
		// TODO Auto-generated method stub
		try {
			getSqlSession().delete("userFuncSql.deleteRoleUserByOrgId", func);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return false;
		}
		return true;
	}

	/**
	 * 删除角色下的功能
	 */
	public boolean deleteRoleFuncs(UserFunc func) {
		try {
			getSqlSession().delete("userFuncSql.deleteRoleFuncByOrgId", func);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return false;
		}
		return true;
	}

	/**
	 * 保存角色下的用户
	 */
	public boolean saveRoleUsers(List<UserFunc> list) {
		// TODO Auto-generated method stub
		try {
			getSqlSession().insert("userFuncSql.saveRoleUsers", list);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return false;
		}
		return true;
	}

	/**
	 * 保存角色下的功能
	 */
	public boolean saveRoleFuncs(List<UserFunc> list) {
		// TODO Auto-generated method stub
		try {
			getSqlSession().insert("userFuncSql.saveRoleFuncs", list);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return false;
		}
		return true;
	}
	
	
}