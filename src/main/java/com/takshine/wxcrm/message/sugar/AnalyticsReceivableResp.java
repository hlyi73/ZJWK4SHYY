package com.takshine.wxcrm.message.sugar;

/**
 * 查询收款报表接口 从crm响应回来的参数
 * @author dengbo
 *
 */
public class AnalyticsReceivableResp extends BaseCrm{
	
	private String planDate;//计划日期
	private String planAmount;//计划金额
	private String actDate;//实收日期
	private String actAmount;//实收金额
	private String depart;//部门
	private String month;//月份
	private String customer;//客户
	private String customerId;//客户Id
	private String margin;//差额
	private String assigner;//责任人
	
	public String getPlanDate() {
		return planDate;
	}
	public void setPlanDate(String planDate) {
		this.planDate = planDate;
	}
	public String getPlanAmount() {
		return planAmount;
	}
	public void setPlanAmount(String planAmount) {
		this.planAmount = planAmount;
	}
	public String getActDate() {
		return actDate;
	}
	public void setActDate(String actDate) {
		this.actDate = actDate;
	}
	public String getActAmount() {
		return actAmount;
	}
	public void setActAmount(String actAmount) {
		this.actAmount = actAmount;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getMargin() {
		return margin;
	}
	public void setMargin(String margin) {
		this.margin = margin;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	
}
