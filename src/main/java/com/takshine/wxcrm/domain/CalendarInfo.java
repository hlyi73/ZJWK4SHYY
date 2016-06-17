package com.takshine.wxcrm.domain;

public class CalendarInfo {
  private String startTime;
  private String endTime;
  private String title;
  private String desc;
  private String type;
  private String id;
  private String orgId;
public String getOrgId() {
	return orgId;
}
public void setOrgId(String orgId) {
	this.orgId = orgId;
}
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getType() {
	return type;
}
public void setType(String type) {
	this.type = type;
}
public String getRowId() {
	return rowId;
}
public void setRowId(String rowId) {
	this.rowId = rowId;
}
private String rowId;
public String getStartTime() {
	return startTime;
}
public void setStartTime(String startTime) {
	this.startTime = startTime;
}
public String getEndTime() {
	return endTime;
}
public void setEndTime(String endTime) {
	this.endTime = endTime;
}
public String getTitle() {
	return title;
}
public void setTitle(String title) {
	this.title = title;
}
public String getDesc() {
	return desc;
}
public void setDesc(String desc) {
	this.desc = desc;
}
}
