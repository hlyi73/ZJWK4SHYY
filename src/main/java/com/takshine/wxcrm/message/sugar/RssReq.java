package com.takshine.wxcrm.message.sugar;

public class RssReq extends BaseCrm {
  private String crmid;
  private String startDate;
  private String endDate;
  private String parameter1;//记录类型Id串
  private String parameter2;//user类型Id串
  private String parameter3;
  private String parameter4;
  private String parameter5;
  public String getCrmid() {
	return crmid;
}
public void setCrmid(String crmid) {
	this.crmid = crmid;
}
public String getStartDate() {
	return startDate;
}
public void setStartDate(String startDate) {
	this.startDate = startDate;
}
public String getEndDate() {
	return endDate;
}
public void setEndDate(String endDate) {
	this.endDate = endDate;
}
public String getParameter1() {
	return parameter1;
}
public void setParameter1(String parameter1) {
	this.parameter1 = parameter1;
}
public String getParameter2() {
	return parameter2;
}
public void setParameter2(String parameter2) {
	this.parameter2 = parameter2;
}
public String getParameter3() {
	return parameter3;
}
public void setParameter3(String parameter3) {
	this.parameter3 = parameter3;
}
public String getParameter4() {
	return parameter4;
}
public void setParameter4(String parameter4) {
	this.parameter4 = parameter4;
}
public String getParameter5() {
	return parameter5;
}
public void setParameter5(String parameter5) {
	this.parameter5 = parameter5;
}
}
