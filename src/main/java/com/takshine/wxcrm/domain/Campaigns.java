package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.CampaignsModel;

/**
 * 市场活动
 * @author dengbo
 *
 */
public class Campaigns extends CampaignsModel {

	private String rowId;// 数据在crm系统的主键
	private String name;//名称
	private String status;//状态
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String type;//类型
	private String budget;//预算
	private String budgetcost;//预算成本
	private String expectcost;//预期收入
	private String factcost;//实际成本
	private String impressions;//印象数
	private String goal;//目的
	private String desc;//说明
	private String assigner;// 责任人
	private String assignerid;// 责任人Id
	private String firstchar;//首字母
	private String viewtype;//branch:下属;share:参与;owner:自己负责的
	
	public String getRowId() {
		return rowId;
	}
	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getBudget() {
		return budget;
	}
	public void setBudget(String budget) {
		this.budget = budget;
	}
	public String getBudgetcost() {
		return budgetcost;
	}
	public void setBudgetcost(String budgetcost) {
		this.budgetcost = budgetcost;
	}
	public String getExpectcost() {
		return expectcost;
	}
	public void setExpectcost(String expectcost) {
		this.expectcost = expectcost;
	}
	public String getFactcost() {
		return factcost;
	}
	public void setFactcost(String factcost) {
		this.factcost = factcost;
	}
	public String getImpressions() {
		return impressions;
	}
	public void setImpressions(String impressions) {
		this.impressions = impressions;
	}
	public String getGoal() {
		return goal;
	}
	public void setGoal(String goal) {
		this.goal = goal;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getFirstchar() {
		return firstchar;
	}
	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
}
