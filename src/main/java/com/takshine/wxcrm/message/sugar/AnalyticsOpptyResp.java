package com.takshine.wxcrm.message.sugar;



/**
 * 查询业务机会报表接口 从crm响应回来的参数
 * @author dengbo
 */
public class AnalyticsOpptyResp extends BaseCrm{
	private String opptyDate;
	private String opptyAmount;
	private String opptyStage;
	private String opptyFailure;//业务机会失败原因
	private String opptyName;//业务机会名称
	private String customer;//客户
	private String customerid;//客户ID
	private String assigner;//责任人
	private String residence;//停留时间
	private String rowid;
	private String opptyStagename;
	private String opptyFailurename;
	
    
	private String username ; //名字
	private String oldcount ; //上月成交数量
	private String count;    //成单数量
	private String rank;     //成单排名
	private String update;   // 浮动
	private String rate;     //成单几率
	private String yearcompare;   //同比
	private String monthconpare;  //环比

	public String getOldcount() {
		return oldcount;
	}
	public void setOldcount(String oldcount) {
		this.oldcount = oldcount;
	}
	public String getUpdate() {
		return update;
	}
	public void setUpdate(String update) {
		this.update = update;
	}
	public String getOpptyDate() {
		return opptyDate;
	}
	public void setOpptyDate(String opptyDate) {
		this.opptyDate = opptyDate;
	}
	public String getOpptyAmount() {
		return opptyAmount;
	}
	public void setOpptyAmount(String opptyAmount) {
		this.opptyAmount = opptyAmount;
	}
	public String getOpptyStage() {
		return opptyStage;
	}
	public void setOpptyStage(String opptyStage) {
		this.opptyStage = opptyStage;
	}

	public String getOpptyName() {
		return opptyName;
	}
	public void setOpptyName(String opptyName) {
		this.opptyName = opptyName;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getResidence() {
		return residence;
	}
	public void setResidence(String residence) {
		this.residence = residence;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}

	public String getOpptyFailure() {
		return opptyFailure;
	}
	public void setOpptyFailure(String opptyFailure) {
		this.opptyFailure = opptyFailure;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}
	public String getOpptyStagename() {
		return opptyStagename;
	}
	public void setOpptyStagename(String opptyStagename) {
		this.opptyStagename = opptyStagename;
	}
	public String getOpptyFailurename() {
		return opptyFailurename;
	}
	public void setOpptyFailurename(String opptyFailurename) {
		this.opptyFailurename = opptyFailurename;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public String getYearcompare() {
		return yearcompare;
	}
	public void setYearcompare(String yearcompare) {
		this.yearcompare = yearcompare;
	}
	public String getMonthconpare() {
		return monthconpare;
	}
	public void setMonthconpare(String monthconpare) {
		this.monthconpare = monthconpare;
	}
	
	
	
}
