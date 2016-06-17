package com.takshine.core.service.business;

import java.util.Date;
import java.util.List;
import java.util.Set;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.domain.Comments;
import com.takshine.wxcrm.domain.WorkReport;


/**
 * 工作计划服务
 * @author Yihailong
 *
 */
public interface WorkPlanService{
	public Set<String> getAllOpenId()throws CRMException;
	public List<WorkReport> getTeamWorkReports(String openid,Date start,Date end) throws CRMException;
	public List<WorkReport> getMyWorkReports(String openid,Date start,Date end) throws CRMException;
	public List<WorkReport> getAllWorkReports(Date start,Date end) throws CRMException;
	public List<WorkReport> getAllWorkReportsByHrManagerCrmId(String crmid,Date start,Date end) throws CRMException;
	

	public List<Comments> getComments(String rowid) throws CRMException;

	
	/**
	 * 导出评级信息，发邮件
	 * @param start
	 * @param end
	 * @throws CRMException
	 */
	void exportAppraise(Date start,Date end)throws CRMException;
	/**
	 * 导出个人评级信息，发邮件
	 * @param openid
	 * @param start
	 * @param end
	 * @throws CRMException
	 */
	void exportAppraise(String openid,Date start,Date end)throws CRMException;
	
	
	/**
	 * 设置该用户为人事部门接口人
	 * @param crmid
	 * @param isHrManager
	 * @throws CRMException
	 */
	void setHRInterface(String crmid,boolean isHrManager)throws CRMException;
	/**
	 * 判断该用户是否为人事部门接口人
	 * @param crmid
	 * @return
	 * @throws CRMException
	 */
	boolean isHRInterface(String crmid)throws CRMException;
	
	/**
	 * 发送提醒信息给用户
	 * @param myreport
	 * @param teamreport
	 * @param allreport
	 * @throws CRMException
	 */
	void sendNotice(String openid,List<WorkReport> myreport,List<WorkReport> teamreport,List<WorkReport> allreport,Date start, Date end)throws CRMException;
}
