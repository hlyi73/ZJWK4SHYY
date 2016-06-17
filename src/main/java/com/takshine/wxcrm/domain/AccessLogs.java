package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.AccessLogsModel;

/**
 * 访问日志
 * @author liulin
 *
 */
public class AccessLogs extends AccessLogsModel{
	
	private String startDate = null;
	private String endDate = null;
	private Integer currpages = 1;
	private Integer pagecounts = 10;
	private Integer accessCount = 0;
	private String accessModule = null;
	private String opName = null;
	private String addoppty = null;
	private String addtask = null; 
	private String addcustomer = null ;
	private String addcontract = null ; 
	
	
	public String getOpName() {
		return opName;
	}
	public void setOpName(String opName) {
		this.opName = opName;
	}
	public String getAccessModule() {
		return accessModule;
	}
	public void setAccessModule(String accessModule) {
		this.accessModule = accessModule;
	}
	public Integer getAccessCount() {
		return accessCount;
	}
	public void setAccessCount(Integer accessCount) {
		this.accessCount = accessCount;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public Integer getCurrpages() {
		return currpages;
	}
	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}
	public Integer getPagecounts() {
		return pagecounts;
	}
	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	public String getAddoppty() {
		return addoppty;
	}
	public void setAddoppty(String addoppty) {
		this.addoppty = addoppty;
	}
	public String getAddtask() {
		return addtask;
	}
	public void setAddtask(String addtask) {
		this.addtask = addtask;
	}
	public String getAddcustomer() {
		return addcustomer;
	}
	public void setAddcustomer(String addcustomer) {
		this.addcustomer = addcustomer;
	}
	public String getAddcontract() {
		return addcontract;
	}
	public void setAddcontract(String addcontract) {
		this.addcontract = addcontract;
	}
	
}
