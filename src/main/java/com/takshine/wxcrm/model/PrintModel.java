package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

public class PrintModel extends BaseModel{
	private String operativeid;
	private String operativetype;
	private String objectid;
	private String objecttype;
	private String ownid;
	public String getOperativeid() {
		return operativeid;
	}
	public void setOperativeid(String operativeid) {
		this.operativeid = operativeid;
	}
	public String getOperativetype() {
		return operativetype;
	}
	public void setOperativetype(String operativetype) {
		this.operativetype = operativetype;
	}
	public String getObjectid() {
		return objectid;
	}
	public void setObjectid(String objectid) {
		this.objectid = objectid;
	}
	public String getObjecttype() {
		return objecttype;
	}
	public void setObjecttype(String objecttype) {
		this.objecttype = objecttype;
	}
	public String getOwnid() {
		return ownid;
	}
	public void setOwnid(String ownid) {
		this.ownid = ownid;
	}
}
