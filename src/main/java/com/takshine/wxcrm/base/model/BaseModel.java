package com.takshine.wxcrm.base.model;

import java.util.Date;

import org.apache.commons.lang3.StringUtils;


/**
 * 基础模型
 * @author liulin
 *
 */
public class BaseModel implements java.io.Serializable{
	
	protected String id = null;//主键
	protected String orgId = null;//组织ID
	protected String orgIdNot = null;//不在组织ID
	protected String orgName = null;//组织名字
	protected String shortOrgName = null;//短组织名字
	protected String orgUrl = null;
	
	private String openId = null;//订阅者ID
	private String publicId = null;//微信公众号的原始ID
	private String crmId = null;//crmId（令牌）
	
	protected String createBy = null;
	protected String createName = null;
	protected Date createTime = null;
	protected String updateBy = null;
	protected Date updateTime = null;
	protected String orderByString = null;
	
	private String currpage = "1";
	private String pagecount = "10";
	private Integer currpages = new Integer(0);
	private Integer pagecounts = new Integer(9999);
	
	private String licinfosign = "";//用户公司部门 签名
	private String licinfostr = "";//用户基本信息
	
	
	public String getCreateName() {
		return createName;
	}
	public void setCreateName(String createName) {
		this.createName = createName;
	}
	public String getOrgUrl() {
		return orgUrl;
	}
	public void setOrgUrl(String orgUrl) {
		this.orgUrl = orgUrl;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getOrgName() {
		if(StringUtils.isNotBlank(this.shortOrgName)){
			return this.shortOrgName;
		}
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getOrderByString() {
		return orderByString;
	}
	public void setOrderByString(String orderByString) {
		this.orderByString = orderByString;
	}
	public String getPublicId() {
		return publicId;
	}
	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getCrmId() {
		return crmId;
	}
	public void setCrmId(String crmId) {
		this.crmId = crmId;
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
	public String getLicinfosign() {
		return licinfosign;
	}
	public void setLicinfosign(String licinfosign) {
		this.licinfosign = licinfosign;
	}
	public String getLicinfostr() {
		return licinfostr;
	}
	public void setLicinfostr(String licinfostr) {
		this.licinfostr = licinfostr;
	}
	public String getOrgIdNot() {
		return orgIdNot;
	}
	public void setOrgIdNot(String orgIdNot) {
		this.orgIdNot = orgIdNot;
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
	public String getShortOrgName() {
		return shortOrgName;
	}
	public void setShortOrgName(String shortOrgName) {
		this.shortOrgName = shortOrgName;
	}
	
}
