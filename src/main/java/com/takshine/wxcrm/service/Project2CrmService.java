package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProjectResp;

/**
 * 项目 业务处理接口
 * @author dengbo
 *
 */
public interface Project2CrmService extends EntityService{
	
	/**
	 * 查询 项目数据列表
	 * @return
	 */
	public ProjectResp getProjectList(Project sche, String source)throws Exception;
	
	/**
	 * 查询单个项目数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public ProjectResp getProjectSingle(String rowid,String crmid)throws Exception;
	/**
	 * 新建项目
	 * @param pro
	 * @return
	 * @throws Exception
	 */
	public CrmError addProject(Project pro)throws Exception;
	/**
	 * 更新项目
	 * @return
	 * @throws Exception
	 */
	public CrmError updateProject(Project pro)throws Exception;
}
