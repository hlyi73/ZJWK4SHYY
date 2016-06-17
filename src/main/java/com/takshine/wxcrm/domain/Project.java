package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.ProjectModel;

/**
 * 项目 DTO
 * @author liulin
 *
 */
public class Project extends ProjectModel{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String rowid;
	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	private String firstchar;
	private String name = null; //项目名称
	private String startdate = null;//开始时间
	private String enddate = null;//结束时间
	private String status;//项目状态
	private String desc;//说明
	private String priority;//优先级
	private String assigner;//责任人
	private String assignerid;//责任人名称
	private String optype;////操作类型,修改(upd)/分配(allot)默认为 upd
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



	public String getOptype() {
		return optype;
	}

	public void setOptype(String optype) {
		this.optype = optype;
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

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
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

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

	public String getFirstchar() {
		return firstchar;
	}

	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}

	
}
