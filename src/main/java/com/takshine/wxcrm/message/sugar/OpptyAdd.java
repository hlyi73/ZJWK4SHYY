package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 业务机会
 * 
 * @author 刘淋
 *
 */
public class OpptyAdd extends BaseCrm {

	private String rowid;// 记录ID
	private String name;// 业务机会名称
	private String customerid;// 客户ID
	private String customername;// 客户名称
	private String currency;// 货币
	private String dateclosed;// 预期完成时间
	private String amount;// 机会金额
	private String opptytype;// 业务机会类型
	private String salesstage;// 销售阶段
	private String salesstagename;// 销售阶段名称
	private String leadsource;// 业务机会来源
	private String probability;// 成交概率(%)
	private String nextstep;// 下一个步逐
	private String campaigns;// 市场活动
	private String desc;// 说明
	private String assigner;// 责任人
	private String assignerid;// 责任人ID
	private String creater;// 创建人
	private String createdate;// 创建时间
	private String modifier;// 修改人
	private String modifyDate;// 修改时间
	private String feedid;// feed rowid
	private String competitive;// 竞争策略
	private String competitiveName;// 竞争策略名称
	private String leadsourcename;// 业务机会来源ID
	private String opptytypename;// 业务机会类型ID
	private String campaignsname;// 市场活动ID
	private String gxml; // 关系评估
	private String effectxml; // 影响力
	private String failreason;// 业务机会失败原因
	private String optype;// 操作类型,修改业务机会阶段(uptstage)/分配(allot)/修改详情(upd)
	private String email;// 邮箱地址
	private String factdateclosed; //实际关闭时间
	private String parentid;
	private String parenttype;
	private String residence;//停留时间
	private String contact; //客户主要联系人
	private String contactphone;//客户主要联系人电话
	private String opptycode; //业务机会编号
	private String tagName; //标签名称
	private String starflag; //是否位星标
	//日报增加的字段
	private String noticetype;//通知类型
	private String nums;//数量
		
	public String getNoticetype() {
			return noticetype;
	}

	public void setNoticetype(String noticetype) {
		this.noticetype = noticetype;
	}

	public String getNums() {
		return nums;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getContactphone() {
		return contactphone;
	}

	public void setContactphone(String contactphone) {
		this.contactphone = contactphone;
	}

	public void setNums(String nums) {
		this.nums = nums;
	}

	public String getParentid() {
		return parentid;
	}

	public void setParentid(String parentid) {
		this.parentid = parentid;
	}

	public String getParentype() {
		return parenttype;
	}

	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}

	// 成单结束等
	private String loseDesc;// 丢单描述
	// 是否有分配权限,Y代表有权限,N代表没有
	private String authority;

	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();// 任务列表
	private List<ContractAdd> cons = new ArrayList<ContractAdd>();// 关联合同

	

	public String getAuthority() {
		return authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}



	public String getOptype() {
		return optype;
	}

	public void setOptype(String optype) {
		this.optype = optype;
	}

	public String getParenttype() {
		return parenttype;
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

	public String getDateclosed() {
		return dateclosed;
	}

	public void setDateclosed(String dateclosed) {
		this.dateclosed = dateclosed;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getOpptytype() {
		return opptytype;
	}

	public void setOpptytype(String opptytype) {
		this.opptytype = opptytype;
	}

	public String getSalesstage() {
		return salesstage;
	}

	public void setSalesstage(String salesstage) {
		this.salesstage = salesstage;
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

	public String getModifyDate() {
		return modifyDate;
	}

	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}

	public List<ContractAdd> getCons() {
		return cons;
	}

	public void setCons(List<ContractAdd> cons) {
		this.cons = cons;
	}

	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}

	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}

	public String getLoseDesc() {
		return loseDesc;
	}

	public void setLoseDesc(String loseDesc) {
		this.loseDesc = loseDesc;
	}

	public String getSalesstagename() {
		return salesstagename;
	}

	public void setSalesstagename(String salesstagename) {
		this.salesstagename = salesstagename;
	}

	public String getFeedid() {
		return feedid;
	}

	public void setFeedid(String feedid) {
		this.feedid = feedid;
	}

	public String getCompetitive() {
		return competitive;
	}

	public void setCompetitive(String competitive) {
		this.competitive = competitive;
	}

	public String getCompetitiveName() {
		return competitiveName;
	}

	public void setCompetitiveName(String competitiveName) {
		this.competitiveName = competitiveName;
	}

	public String getLeadsourcename() {
		return leadsourcename;
	}

	public void setLeadsourcename(String leadsourcename) {
		this.leadsourcename = leadsourcename;
	}

	public String getOpptytypename() {
		return opptytypename;
	}

	public void setOpptytypename(String opptytypename) {
		this.opptytypename = opptytypename;
	}

	public String getCampaignsname() {
		return campaignsname;
	}

	public void setCampaignsname(String campaignsname) {
		this.campaignsname = campaignsname;
	}

	public String getAssignerid() {
		return assignerid;
	}

	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
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

	public String getEffectxml() {
		return effectxml;
	}

	public void setEffectxml(String effectxml) {
		this.effectxml = effectxml;
	}

	public String getFactdateclosed() {
		return factdateclosed;
	}

	public void setFactdateclosed(String factdateclosed) {
		this.factdateclosed = factdateclosed;
	}

	public String getResidence() {
		return residence;
	}

	public void setResidence(String residence) {
		this.residence = residence;
	}

	public String getOpptycode() {
		return opptycode;
	}

	public void setOpptycode(String opptycode) {
		this.opptycode = opptycode;
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
  
	
}
