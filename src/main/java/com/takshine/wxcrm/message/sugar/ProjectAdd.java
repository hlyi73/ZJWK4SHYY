package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;


/**
 * 传递给crm 新增项目接口的参数
 * @author dengbo
 *
 */
public class ProjectAdd extends BaseCrm{
	
	private String rowid = null; //记录ID
	private String name = null; //项目名称
	private String startdate = null;//开始时间
	private String enddate = null;//结束时间
	private String status;//项目状态
	private String statusname;
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}
	private String desc;//说明
	private String priority;
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	private String priorityname;//优先级
	private String assigner;//责任人
	private String assignerid;//责任人名称
	private String creater;
	private String createdate;
	private String modifier;
	private String modifydate;
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String opptyid;
	private String opptyname;
	private String customer;
	private String customerid;
	public String getOpptyid() {
		return opptyid;
	}
	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}
	public String getOpptyname() {
		return opptyname;
	}
	public void setOpptyname(String opptyname) {
		this.opptyname = opptyname;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();//跟进列表
	
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getPriorityname() {
		return priorityname;
	}
	public void setPriorityname(String priorityname) {
		this.priorityname = priorityname;
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
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	
}
