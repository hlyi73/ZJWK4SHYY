package com.takshine.wxcrm.message.sugar;


/**
 * 审批
 * @author 刘淋
 *
 */
public class ApproveAdd extends BaseCrm{
	
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	private String approvaldate = null;
	private String commitdate = null;
	private String type = null;//审批类型
	
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
	public String getApprovaldate() {
		return approvaldate;
	}
	public void setApprovaldate(String approvaldate) {
		this.approvaldate = approvaldate;
	}
	public String getCommitdate() {
		return commitdate;
	}
	public void setCommitdate(String commitdate) {
		this.commitdate = commitdate;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
