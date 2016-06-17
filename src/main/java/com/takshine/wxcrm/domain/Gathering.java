package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.GatheringModel;

/**
 * 收款DTO
 * @author dengbo
 *
 */
public class Gathering extends GatheringModel{
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String title; //收款名称
	private String parentId;//相关ID
	private String parentType;//相关类型(客户/业务机会/任务)
	private String parentName;//相关名称
	private String planDate;//收款日期
	private String planAmount;//收款金额
	private String type;//类型(尾款/第一笔款/...)
	private String receivedDate;//实收日期
	private String receivedAmount;//实收金额
	private String contractId;//合同ID
	private String contractName;//合同名称
	private String desc;//说明
	private String status;//状态
	private String assigner;//责任人
	private String depart; //部门
	private String margin;//应收款与实收款的差额 
	private String modifydate;//修改日期
	private String month;//月份2014-07
	private String startDate;//开始日期
	private String endDate;//结束日期
	private String assignerId;//责任人ID
	private String verifityStatus;//整条记录的核销状态
	private String rowid;//回款记录ID
	
	//财务核销
	private String verifityDate ;//核销日期
	private String verifityAmount ;//核销金额
	private String verStatus;//核销状态
	private String invoicedAmount;//开票金额
	private String invociedDate;//开票日期
	private String verifityRst;//核销说明
	private String invoicedId;//针对某条回款记录的ID
	
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getParentType() {
		return parentType;
	}
	public void setParentType(String parentType) {
		this.parentType = parentType;
	}
	public String getParentName() {
		return parentName;
	}
	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	public String getPlanDate() {
		return planDate;
	}
	public void setPlanDate(String planDate) {
		this.planDate = planDate;
	}
	public String getPlanAmount() {
		return planAmount;
	}
	public void setPlanAmount(String planAmount) {
		this.planAmount = planAmount;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getReceivedDate() {
		return receivedDate;
	}
	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}
	public String getReceivedAmount() {
		return receivedAmount;
	}
	public void setReceivedAmount(String receivedAmount) {
		this.receivedAmount = receivedAmount;
	}
	public String getContractId() {
		return contractId;
	}
	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	public String getContractName() {
		return contractName;
	}
	public void setContractName(String contractName) {
		this.contractName = contractName;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getMargin() {
		return margin;
	}
	public void setMargin(String margin) {
		this.margin = margin;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
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
	public String getVerifityStatus() {
		return verifityStatus;
	}
	public void setVerifityStatus(String verifityStatus) {
		this.verifityStatus = verifityStatus;
	}
	public String getVerifityDate() {
		return verifityDate;
	}
	public void setVerifityDate(String verifityDate) {
		this.verifityDate = verifityDate;
	}
	public String getVerifityAmount() {
		return verifityAmount;
	}
	public void setVerifityAmount(String verifityAmount) {
		this.verifityAmount = verifityAmount;
	}
	public String getVerStatus() {
		return verStatus;
	}
	public void setVerStatus(String verStatus) {
		this.verStatus = verStatus;
	}
	public String getInvoicedAmount() {
		return invoicedAmount;
	}
	public void setInvoicedAmount(String invoicedAmount) {
		this.invoicedAmount = invoicedAmount;
	}
	public String getInvociedDate() {
		return invociedDate;
	}
	public void setInvociedDate(String invociedDate) {
		this.invociedDate = invociedDate;
	}
	public String getVerifityRst() {
		return verifityRst;
	}
	public void setVerifityRst(String verifityRst) {
		this.verifityRst = verifityRst;
	}
	public String getInvoicedId() {
		return invoicedId;
	}
	public void setInvoicedId(String invoicedId) {
		this.invoicedId = invoicedId;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	
}
