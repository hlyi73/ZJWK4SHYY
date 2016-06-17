package com.takshine.wxcrm.message.sugar;

/**
 * 审批列表实体类
 * @author dengbo
 *
 */
public class ApproveListAdd extends BaseCrm{
	
	private String parentid;//相关ID
	private String parentname;//相关名称
	private String parenttype;//相关类型
	private String assignername;//责任人名称
	private String status;//状态
	private String statusname;//状态名称
	private String viewtype;//视图
	private String assignerid;//责任人ID
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String currpage;
	private String pagecount;
	private String approvaldate;//审批日期
	private String openId;//
	
	private String param1;//日期
	private String param2;//金额
	private String param3;
	
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParentname() {
		return parentname;
	}
	public void setParentname(String parentname) {
		this.parentname = parentname;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getAssignername() {
		return assignername;
	}
	public void setAssignername(String assignername) {
		this.assignername = assignername;
	}
	public String getParam1() {
		return param1;
	}
	public void setParam1(String param1) {
		this.param1 = param1;
	}
	public String getParam2() {
		return param2;
	}
	public void setParam2(String param2) {
		this.param2 = param2;
	}
	public String getParam3() {
		return param3;
	}
	public void setParam3(String param3) {
		this.param3 = param3;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
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
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}
	public String getApprovaldate() {
		return approvaldate;
	}
	public void setApprovaldate(String approvaldate) {
		this.approvaldate = approvaldate;
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
	
}
