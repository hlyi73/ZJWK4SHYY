package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 组织
 * @author liulin
 *
 */
public class OrganizationModel extends BaseModel{
	
	private String name = null;//企业名称
	private String industry = null;//企业所属行业
	private String website = null;//企业网址
	private String crmurl = null;//企业后台对接的CRMURL地址
	private String parentid = null;//关联的父企业
	private String enabled_flag = null;//标志位，是否可用(enabled:可用；disabled:审核中；apply：申请)
	private String address=null;
	private String fullname = null; //企业全称
	private String orgnum = null; //企业账号
	
	
	public String getFullname() {
		return fullname;
	}
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	public String getOrgnum() {
		return orgnum;
	}
	public void setOrgnum(String orgnum) {
		this.orgnum = orgnum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getEnabled_flag() {
		return enabled_flag;
	}
	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getCrmurl() {
		return crmurl;
	}
	public void setCrmurl(String crmurl) {
		this.crmurl = crmurl;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	
}
