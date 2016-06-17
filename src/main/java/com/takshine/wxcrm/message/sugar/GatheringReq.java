package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询收款的参数
 * 
 * @author dengbo
 *
 */
public class GatheringReq extends BaseCrm {
	private String viewtype;// 视图类型 myview,teamview,focusview,allview
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String status;
	private String depart;
	private String planDate;
	private String verifityStatus;//核销状态
	private String month;//月份
	private String startDate;
	private String endDate;
	private String assignerId;
	private String contractId;//合同Id
	private String rowid;

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

	public String getCurrpage() {
		return currpage;
	}

	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}

	public String getPagecount() {
		return pagecount;
	}

	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDepart() {
		return depart;
	}

	public void setDepart(String depart) {
		this.depart = depart;
	}

	public String getPlanDate() {
		return planDate;
	}

	public void setPlanDate(String planDate) {
		this.planDate = planDate;
	}

	public String getVerifityStatus() {
		return verifityStatus;
	}

	public void setVerifityStatus(String verifityStatus) {
		this.verifityStatus = verifityStatus;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
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

	public String getAssignerId() {
		return assignerId;
	}

	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
	}

	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	
	
}
