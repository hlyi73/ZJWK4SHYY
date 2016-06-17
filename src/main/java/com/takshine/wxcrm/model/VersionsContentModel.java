package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 版本内容管理
 * @author 
 *
 */
public class VersionsContentModel extends BaseModel{
	
	private String ver_id = null;
	private String serial_number = null ;
	private String content = null ;
	private String imgurl = null ;
	public String getVer_id() {
		return ver_id;
	}
	public void setVer_id(String ver_id) {
		this.ver_id = ver_id;
	}
	public String getSerial_number() {
		return serial_number;
	}
	public void setSerial_number(String serial_number) {
		this.serial_number = serial_number;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getImgurl() {
		return imgurl;
	}
	public void setImgurl(String imgurl) {
		this.imgurl = imgurl;
	}
	
}
