package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.ProductTypeModel;

/**
 * 产品
 * 
 * @author 黄鹏
 *
 */
public class ProductType extends ProductTypeModel {
	private String typeid; // 类别编码
	private String typename; // 类别名称
	private String showname; // 显示名称
	private String parenttype; // 父类别
	private String desc; // 说明

	public String getTypeid() {
		return typeid;
	}

	public void setTypeid(String typeid) {
		this.typeid = typeid;
	}

	public String getTypename() {
		return typename;
	}

	public void setTypename(String typename) {
		this.typename = typename;
	}

	public String getShowname() {
		return showname;
	}

	public void setShowname(String showname) {
		this.showname = showname;
	}

	public String getParenttype() {
		return parenttype;
	}

	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

}
