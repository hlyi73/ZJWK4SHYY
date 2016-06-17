package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 传递给crm 新增日程接口的 参数
 * @author 刘淋
 *
 */
public class CustomerAdd extends BaseCrm{
	
	private String rowid;//数据在crm系统的主键
	private String name;//客户名称
	private String customer_code;//客户编码
	private String phoneoffice;//办公室电话:
	private String website;//网站
	private String phonefax;//传真
	private String addresstype;//地址类型
	private String street;//街道
	private String city;//城市
	private String province;//省
	private String postalcode;//邮编
	private String country;//国家
	private String accnttype;//客户类型
	private String industry;//行业
	private String annualrevenue;//年营业额
	private String employees;//员工数
	private String siccode;//Sic代码
	private String tickersymbol;//股票代码
	private String campaigns;//市场活动
	private String rating;//评分
	private String desc ;//说明
	private String assigner ;//责任人
	private String assignerid;//责任人ID
	private String creater ;//创建人
	private String createdate ;//创建时间
	private String modifier ;//修改人
	private String modifyDate ;//修改时间
	private String industryname;//行业名称
	private String accnttypename;//客户类型名称
	private String campaignsname;// 市场活动
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String parentid;
	private String parenttype;
	private String starflag; // 星标客户标识
	private String oper; // 操作类型
	private String tagName; // 标签名称
	private String star;
	private String state; //客户状态：系统推荐，潜在客户，成单客户，睡眠客户

	public String getStar() {
		return star;
	}
	public void setStar(String star) {
		this.star = star;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parentype) {
		this.parenttype = parenttype;
	}
	private String flag;//标志位,用来区分合作伙伴或者竞争对手
	private String optype;//操作类型,修改(upd)/分配(allot)
	
	private List<OpptyAdd> oppties = new ArrayList<OpptyAdd>();//业务机会列表
	
	private List<ScheduleAdd> tasks = new ArrayList<ScheduleAdd>();//任务列表
	
	private List<ContractAdd> cons = new ArrayList<ContractAdd>();//合同列表
	
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();//跟进列表
	
	private ContactAdd contact;

	public ContactAdd getContact() {
		return contact;
	}
	public void setContact(ContactAdd contact) {
		this.contact = contact;
	}
	private String legal;// 法人
	private String registered;// 注册资本
	private String nature;// 客户性质
	private String naturename;//客户性质名称
	private String product; // 主营产品
	private String customer;// 客户群体
	private String brand;// 品牌名称
	private String source;// 客户来源
	private String sourcename; // 客户来源名称
	private String builddate;// 成立时间
	private String registmark; // 注册号
	private String registadress; // 注册地址
	private String parentcompany; // 母公司
	private String childcompany; // 子公司
	private String firms; // 上下游客户
	private String salesregions; // 主要销售区域
	private String abbreviation; // 客户简称
	private String existvolume;// 已成单生意额
	private String planvolume;// 计划生意额
	private String mustpayment;// 应付款
	private String existpayment; // 已付款
	private String payablepayment;//应付未付

	
	public String getCustomer_code() {
		return customer_code;
	}
	public void setCustomer_code(String customer_code) {
		this.customer_code = customer_code;
	}
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}
	public String getLegal() {
		return legal;
	}
	public void setLegal(String legal) {
		this.legal = legal;
	}
	public String getRegistered() {
		return registered;
	}
	public void setRegistered(String registered) {
		this.registered = registered;
	}
	public String getNature() {
		return nature;
	}
	public void setNature(String nature) {
		this.nature = nature;
	}
	public String getNaturename() {
		return naturename;
	}
	public void setNaturename(String naturename) {
		this.naturename = naturename;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getSourcename() {
		return sourcename;
	}
	public void setSourcename(String sourcename) {
		this.sourcename = sourcename;
	}
	public String getBuilddate() {
		return builddate;
	}
	public void setBuilddate(String builddate) {
		this.builddate = builddate;
	}
	public String getRegistmark() {
		return registmark;
	}
	public void setRegistmark(String registmark) {
		this.registmark = registmark;
	}
	public String getRegistadress() {
		return registadress;
	}
	public void setRegistadress(String registadress) {
		this.registadress = registadress;
	}
	public String getParentcompany() {
		return parentcompany;
	}
	public void setParentcompany(String parentcompany) {
		this.parentcompany = parentcompany;
	}
	public String getChildcompany() {
		return childcompany;
	}
	public void setChildcompany(String childcompany) {
		this.childcompany = childcompany;
	}
	public String getFirms() {
		return firms;
	}
	public void setFirms(String firms) {
		this.firms = firms;
	}
	public String getSalesregions() {
		return salesregions;
	}
	public void setSalesregions(String salesregions) {
		this.salesregions = salesregions;
	}
	public String getAbbreviation() {
		return abbreviation;
	}
	public void setAbbreviation(String abbreviation) {
		this.abbreviation = abbreviation;
	}
	public String getExistvolume() {
		return existvolume;
	}
	public void setExistvolume(String existvolume) {
		this.existvolume = existvolume;
	}
	public String getPlanvolume() {
		return planvolume;
	}
	public void setPlanvolume(String planvolume) {
		this.planvolume = planvolume;
	}
	public String getMustpayment() {
		return mustpayment;
	}
	public void setMustpayment(String mustpayment) {
		this.mustpayment = mustpayment;
	}
	public String getExistpayment() {
		return existpayment;
	}
	public void setExistpayment(String existpayment) {
		this.existpayment = existpayment;
	}
	public String getPayablepayment() {
		return payablepayment;
	}
	public void setPayablepayment(String payablepayment) {
		this.payablepayment = payablepayment;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public String getCampaignsname() {
		return campaignsname;
	}
	public void setCampaignsname(String campaignsname) {
		this.campaignsname = campaignsname;
	}


	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
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
	public String getPhoneoffice() {
		return phoneoffice;
	}
	public void setPhoneoffice(String phoneoffice) {
		this.phoneoffice = phoneoffice;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getPhonefax() {
		return phonefax;
	}
	public void setPhonefax(String phonefax) {
		this.phonefax = phonefax;
	}
	public String getAddresstype() {
		return addresstype;
	}
	public void setAddresstype(String addresstype) {
		this.addresstype = addresstype;
	}
	public String getStreet() {
		return street;
	}
	public void setStreet(String street) {
		this.street = street;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getPostalcode() {
		return postalcode;
	}
	public void setPostalcode(String postalcode) {
		this.postalcode = postalcode;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getAccnttype() {
		return accnttype;
	}
	public void setAccnttype(String accnttype) {
		this.accnttype = accnttype;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getAnnualrevenue() {
		return annualrevenue;
	}
	public void setAnnualrevenue(String annualrevenue) {
		this.annualrevenue = annualrevenue;
	}
	public String getEmployees() {
		return employees;
	}
	public void setEmployees(String employees) {
		this.employees = employees;
	}
	public String getSiccode() {
		return siccode;
	}
	public void setSiccode(String siccode) {
		this.siccode = siccode;
	}
	public String getTickersymbol() {
		return tickersymbol;
	}
	public void setTickersymbol(String tickersymbol) {
		this.tickersymbol = tickersymbol;
	}
	public String getCampaigns() {
		return campaigns;
	}
	public void setCampaigns(String campaigns) {
		this.campaigns = campaigns;
	}
	public String getRating() {
		return rating;
	}
	public void setRating(String rating) {
		this.rating = rating;
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
	public List<OpptyAdd> getOppties() {
		return oppties;
	}
	public void setOppties(List<OpptyAdd> oppties) {
		this.oppties = oppties;
	}
	public List<ScheduleAdd> getTasks() {
		return tasks;
	}
	public void setTasks(List<ScheduleAdd> tasks) {
		this.tasks = tasks;
	}
	public List<ContractAdd> getCons() {
		return cons;
	}
	public void setCons(List<ContractAdd> cons) {
		this.cons = cons;
	}
	public String getIndustryname() {
		return industryname;
	}
	public void setIndustryname(String industryname) {
		this.industryname = industryname;
	}
	public String getAccnttypename() {
		return accnttypename;
	}
	public void setAccnttypename(String accnttypename) {
		this.accnttypename = accnttypename;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getStarflag() {
		return starflag;
	}

	public void setStarflag(String starflag) {
		this.starflag = starflag;
	}
	public String getOper() {
		return oper;
	}
	public void setOper(String oper) {
		this.oper = oper;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}

	
}
