package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.BugModel;
/**
 * bug
 * @author lilei
 *
 */
public class Bug extends BugModel {
	/**
	 * 缺陷
	 */
	private String viewtype = null;//视图类型 myview , teamview, focusview, allview
	private String rowid;//数据在crm系统的主键
	private String serialnumber=null;//编号
	private String title = null;//标题
	private String status = null ;//状态
	private String statusname=null;
	private String desc  = null;//说明
	private String driority  = null;//优先级
	private String driorityname=null;
	private String source=null;//来源
	private String sourcename=null;//
	private String type=null;//类型
	private String typeName=null;
	private String log=null;//日志
	private String category=null;//类别
	private String categoryname=null;
	private String analyze=null;//分析
	private String analyzename=null;
	private String parentid=null ;//相关ID
	private String parentname=null;
	private String parenttype=null ;//相关类型
	private String assignerid = null ;//责任人Id
	private String assigner = null ;//责任人名字
	private String createrid=null;
	private String creater  = null;//创建人
	private String createdate = null ;//创建时间
	private String modifierid=null;
	private String modifier  = null;//修改人
	private String modifydate  = null;//修改时间
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getSerialnumber() {
		return serialnumber;
	}
	public void setSerialnumber(String serialnumber) {
		this.serialnumber = serialnumber;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatusname() {
		return statusname;
	}
	public void setStatusname(String statusname) {
		this.statusname = statusname;
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
	public String getDriorityname() {
		return driorityname;
	}
	public void setDriorityname(String driorityname) {
		this.driorityname = driorityname;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getSourcename() {
		return sourcename;
	}
	public void setSourcename(String sourcename) {
		this.sourcename = sourcename;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getLog() {
		return log;
	}
	public void setLog(String log) {
		this.log = log;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getCategoryname() {
		return categoryname;
	}
	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}
	public String getAnalyze() {
		return analyze;
	}
	public void setAnalyze(String analyze) {
		this.analyze = analyze;
	}
	public String getAnalyzename() {
		return analyzename;
	}
	public void setAnalyzename(String analyzename) {
		this.analyzename = analyzename;
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
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parentntype) {
		this.parenttype = parentntype;
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
	public String getCreaterid() {
		return createrid;
	}
	public void setCreaterid(String createrid) {
		this.createrid = createrid;
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
	public String getModifierid() {
		return modifierid;
	}
	public void setModifierid(String modifierid) {
		this.modifierid = modifierid;
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
