package com.takshine.marketing.domain;

import com.takshine.marketing.model.LovModel;
/**
 * 
 * 下拉列表
 */
public class Lov extends LovModel {
	private String name;
	private String id;//主键
	private String key;//主题
	private String value;//内容
	private String parentid;//父ID
	private String lov_order;//序号
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getLov_order() {
		return lov_order;
	}
	public void setLov_order(String lov_order) {
		this.lov_order = lov_order;
	}
	
	
}
