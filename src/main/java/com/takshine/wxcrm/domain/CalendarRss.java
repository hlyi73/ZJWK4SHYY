package com.takshine.wxcrm.domain;

import java.util.List;

public class CalendarRss {
  private String openid;
  private String rssObjectId;
  private String rssObjectName;
  private String type;
  private String rssObjectHeadImage;
  private String currDate;
  public String getCurrDate() {
	return currDate;
}
public void setCurrDate(String currDate) {
	this.currDate = currDate;
}
private List<CalendarInfo> list;
public String getOpenid() {
	return openid;
}
public void setOpenid(String openid) {
	this.openid = openid;
}
public String getRssObjectId() {
	return rssObjectId;
}
public void setRssObjectId(String rssObjectId) {
	this.rssObjectId = rssObjectId;
}
public String getRssObjectName() {
	return rssObjectName;
}
public void setRssObjectName(String rssObjectName) {
	this.rssObjectName = rssObjectName;
}
public String getType() {
	return type;
}
public void setType(String type) {
	this.type = type;
}
public String getRssObjectHeadImage() {
	return rssObjectHeadImage;
}
public void setRssObjectHeadImage(String rssObjectHeadImage) {
	this.rssObjectHeadImage = rssObjectHeadImage;
}
public List<CalendarInfo> getList() {
	return list;
}
public void setList(List<CalendarInfo> list) {
	this.list = list;
}
  
}
