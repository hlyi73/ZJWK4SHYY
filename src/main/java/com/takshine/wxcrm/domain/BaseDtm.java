package com.takshine.wxcrm.domain;


/**
 * 基础的数据传输模型
 * @author liulin
 *
 */
public class BaseDtm {
	//part01
	private String openid;//订阅者ID
	private String publicid;//微信公众号的原始ID
	private String crmid;//crmId（令牌）
	private String rowid;//行主键id
	private String currpage = "1";
	private String pagecount = "10";
	
	//part02
	private String crmaccount;//crm账户号
	private String type ;//查询类型
	private String modeltype ;//模块类型
	private String errcode = "0";
	private String errmsg = "成功";
	
	//part03 部门查询条件
	private String count = "0";//查询返回数
	private String viewtype = "teamview";//视图类型
	private String start_date = "";//开始时间
	private String end_date = "";//结束时间
	private String assignId = "";//责任人
	private String depart;//部门
	
	//part04
	private String continue_add;//保存并继续添加参数
	
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}
	public String getPublicid() {
		return publicid;
	}
	public void setPublicid(String publicid) {
		this.publicid = publicid;
	}
	public String getCrmid() {
		return crmid;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public void setCrmid(String crmid) {
		this.crmid = crmid;
		this.crmaccount = crmid;
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
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getAssignId() {
		return assignId;
	}
	public void setAssignId(String assignId) {
		this.assignId = assignId;
	}
	public String getContinue_add() {
		return continue_add;
	}
	public void setContinue_add(String continue_add) {
		this.continue_add = continue_add;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	
}
