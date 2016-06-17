package com.takshine.wxcrm.message.sugar;


/**
 * 传递给sugar 查询用户的 参数
 * @author 刘淋
 *
 */
public class UserAdd {
	/**
	 * 调用sugar接口传递的参数
	 */
	private String userid;//ID
	private String username ;//名字
	private String name ;//名字
	private String title;//职位
	private String department;//部门
	private String email;//邮箱
	private String userstatus;//用户状态(启用或禁用)
	private String adminflag;//管理员标志,1代表admin;
	private String crmAccount =null;//登录用户名
	private String crmPass = null;//登录密码
	private String source = null;//
	private String audit = null;
	private String reportto = null;
	private String registdate = null;
	private String mobile = null;
	private String bindFlag = null;//是否已绑定
	public String getBindFlag() {
		return bindFlag;
	}
	public void setBindFlag(String bindFlag) {
		this.bindFlag = bindFlag;
	}
	//传递给后台sugar系统的参数
	private String crmaccount;//crm账户号
	private String type ;//查询类型
	private String modeltype ;//模块类型
	private String orgId;
	
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getRegistdate() {
		return registdate;
	}
	public void setRegistdate(String registdate) {
		this.registdate = registdate;
	}
	public String getAudit() {
		return audit;
	}
	public void setAudit(String audit) {
		this.audit = audit;
	}
	public String getReportto() {
		return reportto;
	}
	public void setReportto(String reportto) {
		this.reportto = reportto;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getCrmAccount() {
		return crmAccount;
	}
	public void setCrmAccount(String crmAccount) {
		this.crmAccount = crmAccount;
	}
	public String getCrmPass() {
		return crmPass;
	}
	public void setCrmPass(String crmPass) {
		this.crmPass = crmPass;
	}
	public String getCrmaccount() {
		return crmaccount;
	}
	public void setCrmaccount(String crmaccount) {
		this.crmaccount = crmaccount;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getModeltype() {
		return modeltype;
	}
	public void setModeltype(String modeltype) {
		this.modeltype = modeltype;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUserstatus() {
		return userstatus;
	}
	public void setUserstatus(String userstatus) {
		this.userstatus = userstatus;
	}
	public String getAdminflag() {
		return adminflag;
	}
	public void setAdminflag(String adminflag) {
		this.adminflag = adminflag;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}
