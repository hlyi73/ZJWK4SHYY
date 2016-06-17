package com.takshine.wxcrm.message.sugar;

import java.util.List;

/**
 *  完成日程操作传递的参数 
 * @author liulin 
 *
 */
public class ScheduleComplete extends BaseCrm{
	
	private String rowid ;//记录ID
	private String startdate ;//开始日期
	private String enddate ;//结束日期
	private String desc ;//说明
	private String status = null ;//状态
	private String driority  = null;//优先级
	private String contact  = null;//联系人
	private List<TaskParent> parent = null ;//相关
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getParentType() {
		return parentType;
	}
	public void setParentType(String parentType) {
		this.parentType = parentType;
	}
	private String parentId = null ;//相关Id
	private String parentType = null ;//相关类型
	private String participant=null;//参与人 
	private String cyclikey = null;//周期键
	private String cyclivalue = null;//周期名字
	private String schetype = null;//
	private String addr = null;//
	private String ispublic;//是否公开 0,1
	private String deleted;//是被删除 0,1
	public String getDeleted() {
		return deleted;
	}
	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
	public String getSchetype() {
		return schetype;
	}
	public void setSchetype(String schetype) {
		this.schetype = schetype;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getParticipant() {
		return participant;
	}
	public void setParticipant(String participant) {
		this.participant = participant;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
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
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDriority() {
		return driority;
	}
	public void setDriority(String driority) {
		this.driority = driority;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getCyclikey() {
		return cyclikey;
	}
	public void setCyclikey(String cyclikey) {
		this.cyclikey = cyclikey;
	}
	public String getCyclivalue() {
		return cyclivalue;
	}
	public void setCyclivalue(String cyclivalue) {
		this.cyclivalue = cyclivalue;
	}
	public String getIspublic() {
		return ispublic;
	}
	public void setIspublic(String ispublic) {
		this.ispublic = ispublic;
	}
	public List<TaskParent> getParent() {
		return parent;
	}
	public void setParent(List<TaskParent> parent) {
		this.parent = parent;
	}
	
}
