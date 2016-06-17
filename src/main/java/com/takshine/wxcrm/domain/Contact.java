package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.ContactModel;

/**
 * 合同
 * @author 刘淋
 *
 */
public class Contact extends ContactModel{
	
	private String optype ; //操作类型
	private String firstchar;//首字母
	private String rowid = null;
	private String salutation = null ;//敬称
	private String firstname = null ;//姓
	private String lastname = null ;//名
	private String conname = null ;//姓名
	private String conjob = null ;//职称
	private String department = null ;//部门
	private String accountname = null ;//客户名称
	private String accountid = null ;//客户ID
	private String phonework = null ;//办公电话
	private String phonemobile = null ;//移动电话
	private String email0 = null ;//邮件
	private String conaddress = null ;//地址
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String filename;//图片名称
	private String plight;// 处境
	private String roles;//角色
	private String adapting;//适应能力
	private String plightname;// 处境
	private String rolesname;//角色
	private String adaptingname;//适应能力
	private String desc;
	//更多
	private String phonefax  = null ;//传真
	private String primarystreet = null ;//街道
	private String primarycity = null ;//城市
	private String primarystate = null ;
	private String primarypostalcode = null ;//邮编
	private String primarycountry = null ;
	
	private String assigner  = null ;//责任人
	private String assignerId = null;//责任人ID
	private String parentId ;//相关ID
	private String parentType ;//相关类型
	private String parentName ;//相关的名字
	private String flag;//查询标记(为空,则查询关联联系人;不为空,则为查询没有关联关系的联系人)
	
	private String creater = "";
	private String createdate = "";
	private String modifier = "";
	private String modifydate = "";
	
	private String relation; //关系LOV key
	private String relationname; //关系LOV value
	private String relaid; //关系ID
	
	private String effect;
	private String effectname;
	
	//查詢字段
	private String datetime;
	private String timefre;//時間頻率
	private String timefrename;//時間頻率
	
	private String contype;
	private String contype_val;//具体的查询值
	private String tagtype;//标签类型
	
	private String batchno; //导入批次号
	private String companyname; 
	

	public String getCompanyname() {
		return companyname;
	}
	public void setCompanyname(String companyname) {
		this.companyname = companyname;
	}
	public String getBatchno() {
		return batchno;
	}
	public void setBatchno(String batchno) {
		this.batchno = batchno;
	}
	public String getTagtype() {
		return tagtype;
	}
	public void setTagtype(String tagtype) {
		this.tagtype = tagtype;
	}
	public String getContype() {
		return contype;
	}
	public void setContype(String contype) {
		this.contype = contype;
	}
	//生日
	private String birthdate;
	
	public String getBirthdate() {
		return birthdate;
	}
	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}
	public String getFirstchar() {
		return firstchar;
	}
	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	public String getEffect() {
		return effect;
	}
	public void setEffect(String effect) {
		this.effect = effect;
	}
	public String getEffectname() {
		return effectname;
	}
	public void setEffectname(String effectname) {
		this.effectname = effectname;
	}
	public String getRelation() {
		return relation;
	}
	public void setRelation(String relation) {
		this.relation = relation;
	}
	public String getRelationname() {
		return relationname;
	}
	public void setRelationname(String relationname) {
		this.relationname = relationname;
	}
	public String getRelaid() {
		return relaid;
	}
	public void setRelaid(String relaid) {
		this.relaid = relaid;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
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
	public String getTimefre() {
		return timefre;
	}
	public void setTimefre(String timefre) {
		this.timefre = timefre;
	}
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public String getSalutation() {
		return salutation;
	}
	public void setSalutation(String salutation) {
		this.salutation = salutation;
	}
	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getLastname() {
		return lastname;
	}
	public void setLastname(String lastname) {
		this.lastname = lastname;
	}
	public String getConname() {
		return conname;
	}
	public void setConname(String conname) {
		this.conname = conname;
	}
	public String getConjob() {
		return conjob;
	}
	public void setConjob(String conjob) {
		this.conjob = conjob;
	}
	public String getConaddress() {
		return conaddress;
	}
	public void setConaddress(String conaddress) {
		this.conaddress = conaddress;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getAccountname() {
		return accountname;
	}
	public void setAccountname(String accountname) {
		this.accountname = accountname;
	}
	public String getAccountid() {
		return accountid;
	}
	public void setAccountid(String accountid) {
		this.accountid = accountid;
	}
	public String getPhonework() {
		return phonework;
	}
	public void setPhonework(String phonework) {
		this.phonework = phonework;
	}
	public String getPhonemobile() {
		return phonemobile;
	}
	public void setPhonemobile(String phonemobile) {
		this.phonemobile = phonemobile;
	}
	public String getPhonefax() {
		return phonefax;
	}
	public void setPhonefax(String phonefax) {
		this.phonefax = phonefax;
	}
	public String getPrimarystreet() {
		return primarystreet;
	}
	public void setPrimarystreet(String primarystreet) {
		this.primarystreet = primarystreet;
	}
	public String getPrimarycity() {
		return primarycity;
	}
	public void setPrimarycity(String primarycity) {
		this.primarycity = primarycity;
	}
	public String getPrimarystate() {
		return primarystate;
	}
	public void setPrimarystate(String primarystate) {
		this.primarystate = primarystate;
	}
	public String getPrimarypostalcode() {
		return primarypostalcode;
	}
	public void setPrimarypostalcode(String primarypostalcode) {
		this.primarypostalcode = primarypostalcode;
	}
	public String getPrimarycountry() {
		return primarycountry;
	}
	public void setPrimarycountry(String primarycountry) {
		this.primarycountry = primarycountry;
	}
	public String getEmail0() {
		return email0;
	}
	public void setEmail0(String email0) {
		this.email0 = email0;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
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
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getAssignerId() {
		return assignerId;
	}
	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
	}
	public String getPlight() {
		return plight;
	}
	public void setPlight(String plight) {
		this.plight = plight;
	}
	public String getRoles() {
		return roles;
	}
	public void setRoles(String roles) {
		this.roles = roles;
	}
	public String getAdapting() {
		return adapting;
	}
	public void setAdapting(String adapting) {
		this.adapting = adapting;
	}
	public String getPlightname() {
		return plightname;
	}
	public void setPlightname(String plightname) {
		this.plightname = plightname;
	}
	public String getRolesname() {
		return rolesname;
	}
	public void setRolesname(String rolesname) {
		this.rolesname = rolesname;
	}
	public String getAdaptingname() {
		return adaptingname;
	}
	public void setAdaptingname(String adaptingname) {
		this.adaptingname = adaptingname;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getTimefrename() {
		return timefrename;
	}
	public void setTimefrename(String timefrename) {
		this.timefrename = timefrename;
	}
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public String getContype_val() {
		return contype_val;
	}
	public void setContype_val(String contype_val) {
		this.contype_val = contype_val;
	}
	
}
