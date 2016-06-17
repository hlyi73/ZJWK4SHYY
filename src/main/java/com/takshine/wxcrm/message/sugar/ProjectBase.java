package com.takshine.wxcrm.message.sugar;



/**
 * 传递给crm 新增项目接口的参数
 * @author lilei
 *
 */
public class ProjectBase extends BaseCrm{
	private String rowid;
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	private String name = null; //项目名称
	private String startdate = null;//开始时间
	private String enddate = null;//结束时间
	private String status;//项目状态
	private String desc;//说明
	private String priority;//优先级
	private String priorityname;
	private String assigner;//责任人
	private String assignerid;//责任人名称
	private String optype;//操作类型,修改(upd)/分配(allot)默认为 upd
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
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priorityid) {
		this.priority = priorityid;
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
