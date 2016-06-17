package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Complaint;
import com.takshine.wxcrm.domain.ServeExecute;
import com.takshine.wxcrm.domain.ServeVisit;
import com.takshine.wxcrm.message.error.CrmError;

public interface ComplaintService extends EntityService {
	
	/**
	 * 查询 客户投诉 数据列表
	 * @param comp
	 * @return
	 */
	public Complaint getComplaintList(Complaint comp);
	
	/**
	 * 查询 服务执行 数据列表
	 * @param comp
	 * @return
	 */
	public ServeExecute getServeExecuteList(ServeExecute exe);
	
	/**
	 * 查询 服务回访 数据列表
	 * @param comp
	 * @return
	 */
	public ServeVisit getServeVisitList(ServeVisit visit);
	
	/**
	 * 保存
	 * @param complaint
	 * @return
	 */
	public CrmError addComplaint(Complaint complaint);
	
	/**
	 * 保存回访
	 * @param complaint
	 * @return
	 */
	public CrmError addVisit(ServeVisit visit);
	
	/**
	 * 保存 执行
	 * @param complaint
	 * @return
	 */
	public CrmError addExec(ServeExecute exec);
	
	/**
	 * 服务派工 以及 状态更新 
	 * @param complaint
	 * @return
	 */
	public CrmError complaintStatusUpd(Complaint complaint);
}
