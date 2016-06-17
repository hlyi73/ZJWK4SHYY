package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.ExpenseModel;

/**
 * 费用DTO
 * @author liulin
 *
 */
public class Expense extends ExpenseModel{
	
	private String expensedate = null;
	private String expenseamount = null;
	private String assigner = null;
	private String assignid = null;//费用对象ID
	private String desc = null;
	private String expensetype = null;
	private String expensetypeName = null;
	private String expensesubtype = null;
	private String expensesubtypename;
	private String parenttype = null;
	private String parentid = null;
	private String depart = null;
	private String approval = null;
	private String viewtype = null;//视图类型 myview , teamview, focusview, allview
	private String type = null;
	private String rowId = null;
	private String name=null;
	private String modifydate=null;
	private String expUserName = null; //费用对象
	private String department = null; //二级部门
	private String parentdepart = null; //一级部门

	
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	private String approvaemail=null;//审批人邮箱
	
	private String startDate;
	private String endDate;
	
	private String original;//查询原始报销数据

	public String getOriginal() {
		return original;
	}
	public void setOriginal(String original) {
		this.original = original;
	}
	public String getExpensedate() {
		return expensedate;
	}
	public void setExpensedate(String expensedate) {
		this.expensedate = expensedate;
	}
	public String getExpenseamount() {
		return expenseamount;
	}
	public void setExpenseamount(String expenseamount) {
		this.expenseamount = expenseamount;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getAssignid() {
		return assignid;
	}
	public void setAssignid(String assignid) {
		this.assignid = assignid;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getExpensetype() {
		return expensetype;
	}
	public void setExpensetype(String expensetype) {
		this.expensetype = expensetype;
	}
	public String getExpensetypeName() {
		return expensetypeName;
	}
	public void setExpensetypeName(String expensetypeName) {
		this.expensetypeName = expensetypeName;
	}
	public String getExpensesubtype() {
		return expensesubtype;
	}
	public void setExpensesubtype(String expensesubtype) {
		this.expensesubtype = expensesubtype;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getApproval() {
		return approval;
	}
	public void setApproval(String approval) {
		this.approval = approval;
	}
	public String getCommitid() {
		return commitid;
	}
	public void setCommitid(String commitid) {
		this.commitid = commitid;
	}
	public String getCommitname() {
		return commitname;
	}
	public void setCommitname(String commitname) {
		this.commitname = commitname;
	}
	public String getApprovalid() {
		return approvalid;
	}
	public void setApprovalid(String approvalid) {
		this.approvalid = approvalid;
	}
	public String getApprovalname() {
		return approvalname;
	}
	public void setApprovalname(String approvalname) {
		this.approvalname = approvalname;
	}
	public String getApprovalstatus() {
		return approvalstatus;
	}
	public void setApprovalstatus(String approvalstatus) {
		this.approvalstatus = approvalstatus;
	}
	public String getApprovaldesc() {
		return approvaldesc;
	}
	public void setApprovaldesc(String approvaldesc) {
		this.approvaldesc = approvaldesc;
	}
	public String getRecordid() {
		return recordid;
	}
	public void setRecordid(String recordid) {
		this.recordid = recordid;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getRowId() {
		return rowId;
	}
	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	public String getExpensesubtypename() {
		return expensesubtypename;
	}
	public void setExpensesubtypename(String expensesubtypename) {
		this.expensesubtypename = expensesubtypename;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
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
	public String getApprovaemail() {
		return approvaemail;
	}
	public void setApprovaemail(String approvaemail) {
		this.approvaemail = approvaemail;
	}
	public String getExpUserName() {
		return expUserName;
	}
	public void setExpUserName(String expUserName) {
		this.expUserName = expUserName;
	}
	public String getParentdepart() {
		return parentdepart;
	}
	public void setParentdepart(String parentdepart) {
		this.parentdepart = parentdepart;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	
}
