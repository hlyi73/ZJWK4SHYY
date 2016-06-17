package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.ProductModel;

/**
 * 产品
 * 
 * @author 黄鹏
 *
 */
public class Product extends ProductModel {
	private String rowid = null; // 记录ID
	private String name = null; // 产品名称
	private String startdate = null;// 开始时间
	private String enddate = null;// 结束时间
	private String version = null;
	private String type; // 类型
	private String paytype; // 付款类型
	private String prise; // 价格
	private String showname; // 类别名称
	private String picklist; // 销售产品类别
	private String desc; // 产品说明
	private String parenttype;// 父类别


	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPaytype() {
		return paytype;
	}

	public void setPaytype(String paytype) {
		this.paytype = paytype;
	}

	public String getPrise() {
		return prise;
	}

	public void setPrise(String prise) {
		this.prise = prise;
	}

	public String getShowname() {
		return showname;
	}

	public void setShowname(String showname) {
		this.showname = showname;
	}

	public String getPicklist() {
		return picklist;
	}

	public void setPicklist(String picklist) {
		this.picklist = picklist;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getParenttype() {
		return parenttype;
	}

	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}



}
