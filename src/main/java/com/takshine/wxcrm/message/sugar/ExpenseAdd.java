package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;


/**
 * 费用报销  模型
 * @author 刘淋
 *
 */
public class ExpenseAdd extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String rowid = "";
	private String name = "";
	private String expensestatus = "";
	private String expensestatusname = "";
	private String auditor = "";//审批人ID
	private String expensedate = "";
	private String expenseamount = "";
	private String assigner = "";//费用对象名称
	private String assignid = "";//费用对象ID
	private String desc = "";
	private String expensetype = "";
	private String expensetypename = "";
	private String expensesubtype = "";
	private String expensesubtypename = "";
	private String parenttype = "";
	private String parentid = "";
	private String creater = "";
	private String createdate = "";
	private String modifier = "";
	private String modifydate = "";
	private String parentname = "";
	private String department = "";//费用部门
	private String departmentname = "";//费用部门
	private String expUserName = ""; //费用对象
	private String parentdepart="";//一级部门
	private String parentdepartname="";//一级部门
	private String email;
	
	////操作类别
	private String operType = null;//操作类别
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	
	private List<ApproveAdd> approves = new ArrayList<ApproveAdd>();//审批历史
	
	//日报增加的字段
	private String noticetype;//通知类型
	private String nums;//数量
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public String getExpensesubtypename() {
		return expensesubtypename;
	}
	public void setExpensesubtypename(String expensesubtypename) {
		this.expensesubtypename = expensesubtypename;
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
	public String getAuditor() {
		return auditor;
	}
	public void setAuditor(String auditor) {
		this.auditor = auditor;
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
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getExpensestatus() {
		return expensestatus;
	}
	public void setExpensestatus(String expensestatus) {
		this.expensestatus = expensestatus;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}
	public String getParentname() {
		return parentname;
	}
	public void setParentname(String parentname) {
		this.parentname = parentname;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getOperType() {
		return operType;
	}
	public void setOperType(String operType) {
		this.operType = operType;
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
	public List<ApproveAdd> getApproves() {
		return approves;
	}
	public void setApproves(List<ApproveAdd> approves) {
		this.approves = approves;
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
	public String getExpensetypename() {
		return expensetypename;
	}
	public void setExpensetypename(String expensetypename) {
		this.expensetypename = expensetypename;
	}
	public String getDepartmentname() {
		return departmentname;
	}
	public void setDepartmentname(String departmentname) {
		this.departmentname = departmentname;
	}
	public String getParentdepartname() {
		return parentdepartname;
	}
	public void setParentdepartname(String parentdepartname) {
		this.parentdepartname = parentdepartname;
	}
	public String getExpensestatusname() {
		return expensestatusname;
	}
	public void setExpensestatusname(String expensestatusname) {
		this.expensestatusname = expensestatusname;
	}
	public String getNoticetype() {
		return noticetype;
	}
	public void setNoticetype(String noticetype) {
		this.noticetype = noticetype;
	}
	public String getNums() {
		return nums;
	}
	public void setNums(String nums) {
		this.nums = nums;
	}
	
}
