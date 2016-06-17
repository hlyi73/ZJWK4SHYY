package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.OpportunityModel;
import com.takshine.wxcrm.model.WeekReportModel;

/**
 * 周报
 * @author dengbo
 *
 */
public class WeekReport extends WeekReportModel{
	
	private String viewtype;//视图类型 myview ,allview
	
	//周报基本信息
	private String rowId;//原始ID
	private String worktype;//类型(重点工作进展)
	private String questtype;//问题类型
	private String content;//具体工作内容
	private String startdate;//开始日期
	private String enddate;//结束日期
	private String summarize;//总结
	private String product;//未交付产品
	private String ordinal;//序号
	private String industry;//所处行业
	private String goal;//主要目标
	private String projectdynamic;//项目动态
	private String qutorsugg;//问题与建议
	private String parenttype;
	private String parentid;
	private String parentname;
	//周报公用字段
	private String orger;//组织
	private String assignerid;//填报人ID
	private String assigner;//责任人名称
	private String department;//部门
	private String date;//填报日期
	private String countweek;//周次
	private String name;//周报名称
	private String reporttype;//周报大类
	
	public String getQuesttype() {
		return questtype;
	}
	public void setQuesttype(String questtype) {
		this.questtype = questtype;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getAssigner() {
		return assigner;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getRowId() {
		return rowId;
	}
	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	public String getWorktype() {
		return worktype;
	}
	public void setWorktype(String worktype) {
		this.worktype = worktype;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	public String getSummarize() {
		return summarize;
	}
	public void setSummarize(String summarize) {
		this.summarize = summarize;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getOrdinal() {
		return ordinal;
	}
	public void setOrdinal(String ordinal) {
		this.ordinal = ordinal;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getGoal() {
		return goal;
	}
	public void setGoal(String goal) {
		this.goal = goal;
	}
	public String getProjectdynamic() {
		return projectdynamic;
	}
	public void setProjectdynamic(String projectdynamic) {
		this.projectdynamic = projectdynamic;
	}
	public String getQutorsugg() {
		return qutorsugg;
	}
	public void setQutorsugg(String qutorsugg) {
		this.qutorsugg = qutorsugg;
	}
	public String getOrger() {
		return orger;
	}
	public void setOrger(String orger) {
		this.orger = orger;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getCountweek() {
		return countweek;
	}
	public void setCountweek(String countweek) {
		this.countweek = countweek;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParentname() {
		return parentname;
	}
	public void setParentname(String parentname) {
		this.parentname = parentname;
	}
	public String getReporttype() {
		return reporttype;
	}
	public void setReporttype(String reporttype) {
		this.reporttype = reporttype;
	}
	
}
