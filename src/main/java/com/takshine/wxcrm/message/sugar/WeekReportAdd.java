package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 周报
 * @author dengbo
 *
 */
public class WeekReportAdd extends BaseCrm{
	
	private String rowid;//原始ID
	//周报公用字段
	private String orger;//组织
	private String assignerid;//填报人ID
	private String assigner;//责任人名称
	private String department;//部门
	private String date;//填报日期
	private String countweek;//周次
	private String reporttype;//周报类型
	private String creater;
	private String createdate;
	private String modifier;
	private String modifydate;
	private String reporttypename;//周报类型名称
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	private List<WeekReportDetail> details = new ArrayList<WeekReportDetail>();
	
	public String getReporttypename() {
		return reporttypename;
	}
	public void setReporttypename(String reporttypename) {
		this.reporttypename = reporttypename;
	}
	public List<WeekReportDetail> getDetails() {
		return details;
	}
	public void setDetails(List<WeekReportDetail> details) {
		this.details = details;
	}
	public String getReporttype() {
		return reporttype;
	}
	public void setReporttype(String reporttype) {
		this.reporttype = reporttype;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
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
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
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
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}
}
