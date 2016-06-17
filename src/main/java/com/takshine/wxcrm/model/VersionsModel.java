package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 版本管理
 * @author 
 *
 */
public class VersionsModel extends BaseModel{
	
	private String ver_number = null ;
	private String ver_name = null ;
	private String desc = null ;
	public String getVer_number() {
		return ver_number;
	}
	public void setVer_number(String ver_number) {
		this.ver_number = ver_number;
	}
	public String getVer_name() {
		return ver_name;
	}
	public void setVer_name(String ver_name) {
		this.ver_name = ver_name;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	
	
}
