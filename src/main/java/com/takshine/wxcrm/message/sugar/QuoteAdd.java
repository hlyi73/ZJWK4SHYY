package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 报价model
 * @author dengbo
 *
 */
public class QuoteAdd extends BaseCrm{
	
	private String rowid;//记录Id
	private String name;//报价名称
	private String quotedate;//报价时间
	private String valid;//有效期
	private String status;//状态
	private String amount;//总价
	private String statusname;//状态名称
	private String assigner;//责任人
	private String assignerid;//责任人Id
	private String creater = "";//创建人
	private String createdate = "";//创建日期
	private String modifier = "";//修改人
	private String modifydate = "";//修改日期
	private String auditor;//审批人ID
	private String parentid;//生意id;
	private String parenttype;
	private String parentname;
	private String quotecode;//报价单编号
	private String validstatus;//有效状态
	private String decount;//总折扣
	private String countmonut;//累计金额
	private String currpage = "1";// 当前页
	private String pagecount = "10";// 每页的条数
	private String viewtype;//视图类型
	private String customername;//客户名称
	private String productname;//产品名称
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String quotestatus;
	private String quotestatusname;
	private String mxrowids;//报价明细rowid列表
	private String optype;//为空:复制;type:重新报价
	//审批字段
	private String commitid = null ; //提交人ID 
	private String commitname = null ; //提交人名字 
	private String approvalid = null ; //提交给谁 
	private String approvalname = null ; //提交给谁的名字 
	private String approvalstatus = null ; //提交的状态 new approving待审批 approved已批准 reject驳回
	private String approvaldesc = null ; //审批的意见 
	private String recordid = null ; //费用记录ID
	private String openId = null;
	
	
	
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	private List<ApproveAdd> approves = new ArrayList<ApproveAdd>();//审批历史
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();//跟进历史
	
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}
	public String getMxrowids() {
		return mxrowids;
	}
	public void setMxrowids(String mxrowids) {
		this.mxrowids = mxrowids;
	}
	public String getQuotestatus() {
		return quotestatus;
	}
	public void setQuotestatus(String quotestatus) {
		this.quotestatus = quotestatus;
	}
	public String getQuotestatusname() {
		return quotestatusname;
	}
	public void setQuotestatusname(String quotestatusname) {
		this.quotestatusname = quotestatusname;
	}
	public String getCustomername() {
		return customername;
	}
	public void setCustomername(String customername) {
		this.customername = customername;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
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
	public String getQuotedate() {
		return quotedate;
	}
	public void setQuotedate(String quotedate) {
		this.quotedate = quotedate;
	}
	public String getValid() {
		return valid;
	}
	public void setValid(String valid) {
		this.valid = valid;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
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
	public String getAuditor() {
		return auditor;
	}
	public void setAuditor(String auditor) {
		this.auditor = auditor;
	}
	public String getQuotecode() {
		return quotecode;
	}
	public void setQuotecode(String quotecode) {
		this.quotecode = quotecode;
	}
	public String getValidstatus() {
		return validstatus;
	}
	public void setValidstatus(String validstatus) {
		this.validstatus = validstatus;
	}
	public String getDecount() {
		return decount;
	}
	public void setDecount(String decount) {
		this.decount = decount;
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
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
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
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getParentname() {
		return parentname;
	}
	public void setParentname(String parentname) {
		this.parentname = parentname;
	}
	public String getCountmonut() {
		return countmonut;
	}
	public void setCountmonut(String countmonut) {
		this.countmonut = countmonut;
	}
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	
}
