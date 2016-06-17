package com.takshine.wxcrm.message.sugar;

import com.takshine.wxcrm.base.common.ErrCode;

/**
 * 基础传输模块
 * @author liulin
 *
 */
public class BaseCrm {
	private String crmaccount;//crm账户号
	private String type ;//查询类型
	private String modeltype ;//模块类型
	private String orgId;
	private String orgUrl;
	
	private String errcode = ErrCode.ERR_CODE_0;
	private String errmsg = ErrCode.ERR_MSG_SUCC;
	
	private String licinfosign = "";//用户公司部门 签名
	private String licinfostr = "";//用户基本信息
	private String orderString;
	private String openId;
	
	
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getOrgUrl() {
		return orgUrl;
	}
	public void setOrgUrl(String orgUrl) {
		this.orgUrl = orgUrl;
	}
	public String getOrderString() {
		return orderString;
	}
	public void setOrderString(String orderString) {
		this.orderString = orderString;
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
	public String getErrcode() {
		return errcode;
	}
	public void setErrcode(String errcode) {
		this.errcode = errcode;
	}
	public String getErrmsg() {
		return errmsg;
	}
	public void setErrmsg(String errmsg) {
		this.errmsg = errmsg;
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
	
}
