package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.ScheduleModel;

/**
 * 日程
 * @author 刘淋
 *
 */
public class Schedule extends ScheduleModel{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String viewtype = null;//视图类型 myview , teamview, focusview, allview
	private String title = null;//标题
	private String startdate = null ;//开始日期
	private String enddate = null ;//结束日期
	private String status = null ;//状态
	private String desc  = null;//说明
	private String driority  = null;//优先级
	private String contact  = null;//联系人
	private String participant = null ; //参与人
	private List<TaskParent> parent = null ;//相关Id
	private String parentId = null ;//相关Id
	private String parentType = null ;//相关类型
	private String assignerId = null ;//责任人Id
	private String assignerName = null ;//责任人名字
	private String creater  = null;//创建人
	private String createdate = null ;//创建时间
	private String modifier  = null;//修改人
	private String modifyDate  = null;//修改时间
	private String rowid = null;
	private String cycliKey = null;//周期键
	private String cycliValue = null;//周期名字
	private String schetype = null;
	private String addr = null;
	private String ispublic=null;//0 不公开，1公开
	private String deleted=null;//是否被删除
	private String optype=null;//0 不公开，1公开
	private String subtaskid = null;
	
	
	public String getDeleted() {
		return deleted;
	}
	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
	public String getSubtaskid() {
		return subtaskid;
	}
	public void setSubtaskid(String subtaskid) {
		this.subtaskid = subtaskid;
	}
	public String getIspublic() {
		return ispublic;
	}
	public void setIspublic(String ispublic) {
		this.ispublic = ispublic;
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
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getDriority() {
		return driority;
	}
	public void setDriority(String driority) {
		this.driority = driority;
	}
	public String getAssignerId() {
		return assignerId;
	}
	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
	}
	public String getAssignerName() {
		return assignerName;
	}
	public void setAssignerName(String assignerName) {
		this.assignerName = assignerName;
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
	public String getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
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
	public String getCycliKey() {
		return cycliKey;
	}
	public void setCycliKey(String cycliKey) {
		this.cycliKey = cycliKey;
	}
	public String getCycliValue() {
		return cycliValue;
	}
	public void setCycliValue(String cycliValue) {
		this.cycliValue = cycliValue;
	}
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public List<TaskParent> getParent() {
		return parent;
	}
	public void setParent(List<TaskParent> parent) {
		this.parent = parent;
	}
	
}
