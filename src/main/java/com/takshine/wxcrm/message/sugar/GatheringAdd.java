package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 传递给crm 新增收款接口的参数
 * @author dengbo
 *
 */
public class GatheringAdd extends BaseCrm{
	
	private String rowid; //记录ID
	private String title; //收款名称
	private String parentId;//相关ID
	private String parentType;//相关类型(客户/业务机会/任务)
	private String parentName;//相关名称
	private String planDate;//收款日期
	private String planAmount;//收款金额
	private String plantype;
	private String typename;//类型(尾款/第一笔款/...)
	private String gatheringtype;//回款类型(计划/实际)
	private String receivedDate;//实收日期
	private String receivedAmount;//实收金额
	private String desc;//说明
	private String contractId;//合同ID
	private String contractName;//合同名称
	private String assignid;//责任人ID
	private String assigner;//责任人
	private String creater;//创建人
	private String createdate;//创建时间
	private String modifier;//修改人
	private String modifydate;//修改时间
	private String status;//状态
	private String statusname;//状态名称
	private String payments;//付款方式
	private String paymentsname;//付款方式名称
	private String color;//判断应收日期与系统当前时间的大小而显示不同的颜色
	private String margin;//应收款与实收款的差额 
	private String verifityStatus;//整条记录的核销状态
	private String name;//名称
	private String planid;//回款计划ID
	private String flag;//回款计划下是否有回款明细
	
	private String email;//邮箱地址
	private String ccemail;//抄送人地址
	
	//收款下关联的回款修改历史
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();
	
	private String verifityDate ;
	private String verifityAmount ;
	private String verStatus;
	private String invoicedAmount;
	private String invociedDate;
	private String verifityRst;
	private String invoicedId;
	
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
	
	public String getPlantype() {
		return plantype;
	}
	public void setPlantype(String plantype) {
		this.plantype = plantype;
	}
	public String getTypename() {
		return typename;
	}
	public void setTypename(String typename) {
		this.typename = typename;
	}
	public String getGatheringtype() {
		return gatheringtype;
	}
	public void setGatheringtype(String gatheringtype) {
		this.gatheringtype = gatheringtype;
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
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
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
	public String getAssignid() {
		return assignid;
	}
	public void setAssignid(String assignid) {
		this.assignid = assignid;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}
	public String getPayments() {
		return payments;
	}
	public void setPayments(String payments) {
		this.payments = payments;
	}
	public String getPaymentsname() {
		return paymentsname;
	}
	public void setPaymentsname(String paymentsname) {
		this.paymentsname = paymentsname;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getMargin() {
		return margin;
	}
	public void setMargin(String margin) {
		this.margin = margin;
	}
	public String getVerifityStatus() {
		return verifityStatus;
	}
	public void setVerifityStatus(String verifityStatus) {
		this.verifityStatus = verifityStatus;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getCcemail() {
		return ccemail;
	}
	public void setCcemail(String ccemail) {
		this.ccemail = ccemail;
	}
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}
	public String getPlanid() {
		return planid;
	}
	public void setPlanid(String planid) {
		this.planid = planid;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
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
}
