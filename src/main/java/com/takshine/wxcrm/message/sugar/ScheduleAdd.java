package com.takshine.wxcrm.message.sugar;


/**
 * 传递给crm 新增日程接口的 参数
 * @author 刘淋
 *
 */
public class ScheduleAdd extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String rowid;//数据在crm系统的主键
	private String title;//标题
	private String startdate=null ;//开始日期
	private String enddate=null ;//结束日期
	private String status ;//状态
	private String statusname;
	private String driorityname;
	private String desc ;//说明
	private String driority ;//优先级
	private String assigner ;//责任人
	private String parentId ;//相关ID
	private String parentType ;//相关类型
	private String creater ;//创建人
	private String createdate ;//创建时间
	private String modifier ;//修改人
	private String modifydate ;//修改时间
	private String relamodule;//相关
	private String relarowid; //相关记录ID
	private String relaname;//相关记录名称
	private String assignerid;
	private String contact  = null;//联系人
	private String contactname = null;
	private String participant = null ; //参与人
	private String participantname = null;
	private String cyclikey = null;//周期键
	private String cyclivalue = null;//周期名字
	private String schetype = null;
	private String addr = null;
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String ispublic;//是否公开 0:不公开 1：公开
	private String optype;
	private String subtaskid = null;
	private String deleted = "0";
	
	//日报增加的字段
	private String noticetype;//通知类型
	private String nums;//数量
	
	private String week;//星期
	
	public String getWeek() {
		return week;
	}
	public void setWeek(String week) {
		this.week = week;
	}
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
	public String getNoticetype() {
		return noticetype;
	}
	public void setNoticetype(String noticetype) {
		this.noticetype = noticetype;
	}
	public String getNums() {
		return nums;
	}
	public void setNums(String nums) {
		this.nums = nums;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
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
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
	public String getParticipant() {
		return participant;
	}
	public void setParticipant(String participant) {
		this.participant = participant;
	}
	private String email;//邮箱地址
	
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}
	public String getDriorityname() {
		return driorityname;
	}
	public void setDriorityname(String driorityname) {
		this.driorityname = driorityname;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
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
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
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

	public String getRelamodule() {
		return relamodule;
	}
	public void setRelamodule(String relamodule) {
		this.relamodule = relamodule;
	}
	public String getRelarowid() {
		return relarowid;
	}
	public void setRelarowid(String relarowid) {
		this.relarowid = relarowid;
	}
	public String getRelaname() {
		return relaname;
	}
	public void setRelaname(String relaname) {
		this.relaname = relaname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}
	public String getContactname() {
		return contactname;
	}
	public void setContactname(String contactname) {
		this.contactname = contactname;
	}
	public String getParticipantname() {
		return participantname;
	}
	public void setParticipantname(String participantname) {
		this.participantname = participantname;
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
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	
}
