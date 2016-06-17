package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.OpportunityModel;

/**
 * 业务机会
 * @author 刘淋
 *
 */
public class Opportunity extends OpportunityModel{
	
	private String viewtype = null;//视图类型 myview , teamview, focusview, allview
	private String firstchar = null;//首字母
	
	//业务机会基本信息
	private String rowId = null;//原始ID
	private String dateclosed = null;//关闭日期
	private String salesstage = null;//销售阶段
	private String amount = null;//销售的调整金额
	private String successEnd = null;//成单结束
	private String loseDesc = null;//丢单描述
	private String closed = null;//关闭业务机会
	private String competitive;//竞争策略
	private String failreason=null;//业务机会失败原因
    private String rate= null; //成单率
	


	private String parentId = null ;//相关Id
	private String parentType = null ;//相关类型

	//业务机会修改
	private String customerid;//客户ID
	private String customername;//客户名称
	private String currency;//货币
	private String opptytype;//业务机会类型
	private String salesstagename;//销售阶段名称
	private String leadsource;//潜在客户来源
	private String probability;//成交概率(%)
	private String nextstep;//下一个步逐
	private String campaigns;//市场活动
	private String campaignsname;//市场活动名称
	private String desc ;//说明
	private String modifydate;//修改日期
	//查询条件
	private String startDate = null;//关闭的开始日期
	private String endDate = null;//关闭的结束日期
	private String assignId = null;//责任人
	private String opptyname = null;//业务机会名称
	private String gxml = null; //关系图
	private String effectxml = null; //影响力
	private String cstartdate;//创建的开始时间
	private String cenddate;//创建的结束时间
	private String factdateclosed; //实际关闭时间
	
	//
	private String contactid = null; //联系人
	
	private String optype;//操作类型,修改业务机会阶段(uptstage)/分配(allot)/修改详情(upd)
	private String tagName; //标签名称
	private String starflag; //是否位星标
	
	private String name;//商机名称
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getFactdateclosed() {
		return factdateclosed;
	}
	public void setFactdateclosed(String factdateclosed) {
		this.factdateclosed = factdateclosed;
	}
	
	
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getFirstchar() {
		return firstchar;
	}
	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	public String getRowId() {
		return rowId;
	}
	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	public String getDateclosed() {
		return dateclosed;
	}
	public void setDateclosed(String dateclosed) {
		this.dateclosed = dateclosed;
	}
	public String getCompetitive() {
		return competitive;
	}
	public void setCompetitive(String competitive) {
		this.competitive = competitive;
	}
	public String getSalesstage() {
		return salesstage;
	}
	public void setSalesstage(String salesstage) {
		this.salesstage = salesstage;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getSuccessEnd() {
		return successEnd;
	}
	public void setSuccessEnd(String successEnd) {
		this.successEnd = successEnd;
	}
	public String getLoseDesc() {
		return loseDesc;
	}
	public void setLoseDesc(String loseDesc) {
		this.loseDesc = loseDesc;
	}
	public String getClosed() {
		return closed;
	}
	public void setClosed(String closed) {
		this.closed = closed;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}
	public String getCustomername() {
		return customername;
	}
	public void setCustomername(String customername) {
		this.customername = customername;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public String getOpptytype() {
		return opptytype;
	}
	public void setOpptytype(String opptytype) {
		this.opptytype = opptytype;
	}
	public String getSalesstagename() {
		return salesstagename;
	}
	public void setSalesstagename(String salesstagename) {
		this.salesstagename = salesstagename;
	}
	public String getLeadsource() {
		return leadsource;
	}
	public void setLeadsource(String leadsource) {
		this.leadsource = leadsource;
	}
	public String getProbability() {
		return probability;
	}
	public void setProbability(String probability) {
		this.probability = probability;
	}
	public String getNextstep() {
		return nextstep;
	}
	public void setNextstep(String nextstep) {
		this.nextstep = nextstep;
	}
	public String getCampaigns() {
		return campaigns;
	}
	public void setCampaigns(String campaigns) {
		this.campaigns = campaigns;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
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
	public String getAssignId() {
		return assignId;
	}
	public void setAssignId(String assignId) {
		this.assignId = assignId;
	}
	public String getOpptyname() {
		return opptyname;
	}
	public void setOpptyname(String opptyname) {
		this.opptyname = opptyname;
	}
	public String getGxml() {
		return gxml;
	}
	public void setGxml(String gxml) {
		this.gxml = gxml;
	}
	public String getFailreason() {
		return failreason;
	}
	public void setFailreason(String failreason) {
		this.failreason = failreason;
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
	public String getCstartdate() {
		return cstartdate;
	}
	public void setCstartdate(String cstartdate) {
		this.cstartdate = cstartdate;
	}
	public String getCenddate() {
		return cenddate;
	}
	public void setCenddate(String cenddate) {
		this.cenddate = cenddate;
	}
	public String getEffectxml() {
		return effectxml;
	}
	public void setEffectxml(String effectxml) {
		this.effectxml = effectxml;
	}
	public String getContactid() {
		return contactid;
	}
	public void setContactid(String contactid) {
		this.contactid = contactid;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public String getTagName() {
		return tagName;
	}
	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	public String getStarflag() {
		return starflag;
	}
	public void setStarflag(String starflag) {
		this.starflag = starflag;
	}
	public String getCampaignsname() {
		return campaignsname;
	}
	public void setCampaignsname(String campaignsname) {
		this.campaignsname = campaignsname;
	}
	
}
