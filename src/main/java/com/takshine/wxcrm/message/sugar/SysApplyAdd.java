package com.takshine.wxcrm.message.sugar;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 个人申请注册实体类
 * @author dengbo
 *
 */
public class SysApplyAdd extends BaseModel{
	
	private String id;//主键ID
	private String open_id;
	private String name;//申请人名称
	private String conname;//联系人名称
	private String mobile;//联系电话
	private String org_id;//企业ID
	private String org_name;//企业名称
	private String desc;//企业描述
	private String industry;//行业
	private String address;//地址	
	private String crm_url;//后台系统链接
	private String create_time;//创建时间
	private Integer currpages = 1;
	private Integer pagecounts = 10;
	private String flag;//标志位，是否为管理员
	private String type ;//查询类型
	private String modeltype ;//模块类型
	private String crmAccount;//管理员用户名
	private String crmPass;//管理员密码
	private String crmaccount; //当前用户
	private String source;
	private String enabledflag ;
	
	public String getEnabledflag() {
		return enabledflag;
	}
	public void setEnabledflag(String enabledflag) {
		this.enabledflag = enabledflag;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getCrmaccount() {
		return crmaccount;
	}
	public void setCrmaccount(String crmaccount) {
		this.crmaccount = crmaccount;
	}
	public String getConname() {
		return conname;
	}
	public void setConname(String conname) {
		this.conname = conname;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
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
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public Integer getCurrpages() {
		return currpages;
	}
	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}
	public Integer getPagecounts() {
		return pagecounts;
	}
	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	
	public String getOrg_id() {
		return org_id;
	}
	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}
	public String getOrg_name() {
		return org_name;
	}
	public void setOrg_name(String org_name) {
		this.org_name = org_name;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOpen_id() {
		return open_id;
	}
	public void setOpen_id(String open_id) {
		this.open_id = open_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCrm_url() {
		return crm_url;
	}
	public void setCrm_url(String crm_url) {
		this.crm_url = crm_url;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	
}	
