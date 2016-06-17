package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.PrintModel;

public class Print extends PrintModel {
   private String operativename;
   private String objectname;
   private String ownname;
public String getOperativename() {
	return operativename;
}
public void setOperativename(String operativename) {
	this.operativename = operativename;
}
public String getObjectname() {
	return objectname;
}
public void setObjectname(String objectname) {
	this.objectname = objectname;
}
public String getOwnname() {
	return ownname;
}
public void setOwnname(String ownname) {
	this.ownname = ownname;
}
}
