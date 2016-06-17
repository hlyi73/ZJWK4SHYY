package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.WorkReportRelaTask;
import com.takshine.wxcrm.service.WorkPlanRelaTaskService;


/**
 * 工作计划关联任务
 * @author dengbo
 *
 */
@Service("workPlanRelaTaskService")
public class WorkPlanRelaTaskServiceImpl extends BaseServiceImpl implements WorkPlanRelaTaskService{

	@Override
	protected String getDomainName() {
		return "WorkReportRelaTask";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "workReportRelaTaskSql.";
	}
	
	public BaseModel initObj() {
		return new WorkReportRelaTask();
	}
	
}
