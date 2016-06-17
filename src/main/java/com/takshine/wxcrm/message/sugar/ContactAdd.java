package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;


/**
 * 联系人
 * @author 邓波
 *
 */
public class ContactAdd extends BaseCrm{
	
	private String rowid = null;//记录ID
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
	private String phonefax  = null ;
	private String primarystreet = null ;
	private String primarycity = null ;
	private String primarystate = null ;
	private String primarypostalcode = null ;
	private String primarycountry = null ;
	private String conaddress = null ;//地址
	private String email0 = null ;
	private String assigner  = null ;
	private String assignerId = null;//责任人ID
	private String parentid ;//相关ID
	private String parenttype ;//相关类型
	private String parentname ;//相关名字
	private String creater = "";
	private String createdate = "";
	private String modifier = "";
	private String modifydate = "";
	private String desc;
	private String plight;// 处境
	private String roles;//角色
	private String adapting;//适应能力
	private String plightname;// 处境
	private String rolesname;//角色
	private String adaptingname;//适应能力
	private String filename;//图片名称
	private String tasknum; //拜访次数
	private String email;//邮箱地址
	private String timefre;//時間頻率
	private String timefrename;//時間頻率
	private String relation; //关系LOV key
	private String relationname; //关系LOV value
	private String relaid; //关系ID
	private String effect;
	private String effectname;
	private String iswbuser;//是否关联微博或者是新增微博用户
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String type; // 联系人类型
	private String soure; //联系人来源
	private String optype;//操作类型
	private String birthdate;//生日
	
	//日报增加的字段
	private String noticetype;//通知类型
	private String school = null ;//
	private String area = null ;//
	private String nums;//数量
	private String batchno; //批资号
	private String companyname; //公司名称（导入外部数据时，缓存中）
	
	
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();// 跟进列表
	
	
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

	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public String getIswbuser() {
		return iswbuser;
	}
	public void setIswbuser(String iswbuser) {
		this.iswbuser = iswbuser;
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
	public String getRelaid() {
		return relaid;
	}
	public void setRelaid(String relaid) {
		this.relaid = relaid;
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
	public String getTimefre() {
		return timefre;
	}
	public void setTimefre(String timefre) {
		this.timefre = timefre;
	}
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
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

	public String getConaddress() {
		return conaddress;
	}

	public void setConaddress(String conaddress) {
		this.conaddress = conaddress;
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

	public String getParentid() {
		return parentid;
	}

	public void setParentid(String parentid) {
		this.parentid = parentid;
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

	public String getAssignerId() {
		return assignerId;
	}

	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
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

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
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

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getTasknum() {
		return tasknum;
	}

	public void setTasknum(String tasknum) {
		this.tasknum = tasknum;
	}
	public String getTimefrename() {
		return timefrename;
	}
	public void setTimefrename(String timefrename) {
		this.timefrename = timefrename;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSoure() {
		return soure;
	}

	public void setSoure(String soure) {
		this.soure = soure;
	}

	
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}

	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}

	public String getOptype() {
		return optype;
	}

	public void setOptype(String optype) {
		this.optype = optype;
	}

	public String getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}

	public String getSchool() {
		return school;
	}

	public void setSchool(String school) {
		this.school = school;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}
	
	public String toVCARDString(){
		StringBuffer sb = new StringBuffer();
		sb.append("BEGIN:VCARD\n");
		sb.append("VERSION:3.0\n");
		sb.append("N:"+this.getConname()+"\n");
    	sb.append("EMAIL:"+this.getEmail0()+"\n");
		sb.append("TEL;WORK,CELL:"+this.getPhonemobile()+"\n");
		sb.append("ADR;TYPE=WORK:"+this.getConaddress()+"\n");
		sb.append("TITLE:"+this.getConjob()+"\n");
		sb.append("ORG:"+this.getDepartment()+"\n");
		sb.append("END:VCARD");
		return sb.toString();
	}

}
