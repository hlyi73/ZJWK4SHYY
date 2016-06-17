package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.WorkReport;

/**
 * 工作计划
 * @author dengbo
 *
 */
public interface WorkPlanService extends EntityService{
	
	public boolean updateWorkPlanStatusById(WorkReport wr) throws Exception;
	public List<WorkReport> searchWorkPlanList(WorkReport wr) throws Exception;
	public int updateWorkPlanById(WorkReport workReport)throws Exception;
	public List<WorkReport> searchAnalyticsList(WorkReport wr) throws Exception;
	
	public String checkWorkPlan(WorkReport wr)throws Exception;
	
	/**
	 * 查找工作计划评价，用于微信命令菜单
	 * @param wr
	 * @return
	 * @throws Exception
	 */
	public List<WorkReport> findWorkReportComments(WorkReport wr) throws Exception;
	
}
