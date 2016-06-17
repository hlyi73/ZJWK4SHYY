package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 传递给crm 新增合同接口的参数
 * @author dengbo
 *
 */
public class ContractAdd extends BaseCrm{
	
	private String rowid; //记录ID
	private String title; //合同名称
	private String contractCode;//合同编号
	private String contract_source;//合同来源
	private String parent_name;//相关名称
	private String parent_id;//相关ID
	private String parent_type;//相关类型
	private String startDate;//履行期限开始日期
	private String endDate;//履行期限结束日期
	private String cost;//价款
	private String duty;//违约责任(合同条款)
	private String desc;//说明
	private String assigner;//责任人
	private String creater;//创建人
	private String createdate;//创建时间
	private String modifier;//修改人
	private String modifydate;//修改时间
	private String contractstatus = "";
	private String contractstatusname = "";
	private String auditor = "";//审批人ID
	private String recivedAmount;//已收款
	private String assignerid;//责任人ID
	private String quoterowids;//报价明细rowids
	
	//合同列表下的回款总计
	private String invamttotal;//开票金额合计
	private String recamttotal;//实收金额合计
	private String reccount;//记录条数
	
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	private String modifiid;//修改人Id
	private String modifiname;//修改人名字
	
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String optype;
	
	private List<ApproveAdd> approves = new ArrayList<ApproveAdd>();//审批历史
	//合同下关联的收款列表
	private List<GatheringAdd> gathering = new ArrayList<GatheringAdd>();
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();//跟进列表
	
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContract_source() {
		return contract_source;
	}
	public void setContract_source(String contract_source) {
		this.contract_source = contract_source;
	}
	public String getContractCode() {
		return contractCode;
	}
	public void setContractCode(String contractCode) {
		this.contractCode = contractCode;
	}
	public String getParent_name() {
		return parent_name;
	}
	public void setParent_name(String parent_name) {
		this.parent_name = parent_name;
	}
	public String getParent_id() {
		return parent_id;
	}
	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}
	public String getParent_type() {
		return parent_type;
	}
	public void setParent_type(String parent_type) {
		this.parent_type = parent_type;
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
	public String getCost() {
		return cost;
	}
	public void setCost(String cost) {
		this.cost = cost;
	}
	public String getDuty() {
		return duty;
	}
	public void setDuty(String duty) {
		this.duty = duty;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
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
	public String getContractstatus() {
		return contractstatus;
	}
	public void setContractstatus(String contractstatus) {
		this.contractstatus = contractstatus;
	}
	public String getContractstatusname() {
		return contractstatusname;
	}
	public void setContractstatusname(String contractstatusname) {
		this.contractstatusname = contractstatusname;
	}
	public String getAuditor() {
		return auditor;
	}
	public void setAuditor(String auditor) {
		this.auditor = auditor;
	}
	public String getRecivedAmount() {
		return recivedAmount;
	}
	public void setRecivedAmount(String recivedAmount) {
		this.recivedAmount = recivedAmount;
	}
	public List<GatheringAdd> getGathering() {
		return gathering;
	}
	public void setGathering(List<GatheringAdd> gathering) {
		this.gathering = gathering;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getInvamttotal() {
		return invamttotal;
	}
	public void setInvamttotal(String invamttotal) {
		this.invamttotal = invamttotal;
	}
	public String getRecamttotal() {
		return recamttotal;
	}
	public void setRecamttotal(String recamttotal) {
		this.recamttotal = recamttotal;
	}
	public String getReccount() {
		return reccount;
	}
	public void setReccount(String reccount) {
		this.reccount = reccount;
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
	public String getModifiid() {
		return modifiid;
	}
	public void setModifiid(String modifiid) {
		this.modifiid = modifiid;
	}
	public List<ApproveAdd> getApproves() {
		return approves;
	}
	public void setApproves(List<ApproveAdd> approves) {
		this.approves = approves;
	}
	public String getModifiname() {
		return modifiname;
	}
	public void setModifiname(String modifiname) {
		this.modifiname = modifiname;
	}
	public String getQuoterowids() {
		return quoterowids;
	}
	public void setQuoterowids(String quoterowids) {
		this.quoterowids = quoterowids;
	}
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	} 
}
