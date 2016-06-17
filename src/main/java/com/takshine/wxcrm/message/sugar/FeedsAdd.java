package com.takshine.wxcrm.message.sugar;

import com.takshine.wxcrm.domain.Messages;

/**
 * 传递给crm
 * 
 * @author
 *
 */
public class FeedsAdd extends BaseCrm {

	private String optype;
	private String rowid;
	private String datatype;
	private String avalue;
	private String bvalue;
	private String userid;
	private String parentid;
	private String parentname;
	private String username;
	private String createdate;
	private String fieldname;

	// -------------------
	private String name;
	private String operid;
	private String opername;
	private String module;
	private String opertype;
	private String summary;

	private String shareusers = null;//

	private Messages msg = null;
	
	
	public Messages getMsg() {
		return msg;
	}

	public void setMsg(Messages msg) {
		this.msg = msg;
	}

	public String getShareusers() {
		return shareusers;
	}

	public void setShareusers(String shareusers) {
		this.shareusers = shareusers;
	}

	// -------------------

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getOperid() {
		return operid;
	}

	public void setOperid(String operid) {
		this.operid = operid;
	}

	public String getOpername() {
		return opername;
	}

	public void setOpername(String opername) {
		this.opername = opername;
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public String getOpertype() {
		return opertype;
	}

	public void setOpertype(String opertype) {
		this.opertype = opertype;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	private FeedsAttr attr;

	public FeedsAttr getAttr() {
		return attr;
	}

	public void setAttr(FeedsAttr attr) {
		this.attr = attr;
	}

	public String getOptype() {
		return optype;
	}

	public void setOptype(String optype) {
		this.optype = optype;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getDatatype() {
		return datatype;
	}

	public void setDatatype(String datatype) {
		this.datatype = datatype;
	}

	public String getAvalue() {
		return avalue;
	}

	public void setAvalue(String avalue) {
		this.avalue = avalue;
	}

	public String getBvalue() {
		return bvalue;
	}

	public void setBvalue(String bvalue) {
		this.bvalue = bvalue;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
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

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCreatedate() {
		return createdate;
	}

	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}

	public String getFieldname() {
		return fieldname;
	}

	public void setFieldname(String fieldname) {
		this.fieldname = fieldname;
	}
}
