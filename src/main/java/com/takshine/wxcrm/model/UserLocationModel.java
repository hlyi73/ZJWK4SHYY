package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 用户位置表 Model
 * 
 * @author liulin
 */
public class UserLocationModel extends BaseModel {
	
	private String openId = null;//用户的OPEN_ID
	private String lat = null;//用户发送的经度
	private String lng = null;//用户发生的纬度
	private String bd09Lng = null;//经过百度坐标转换后的经度
	private String bd09Lat = null;//经过百度坐标转换后的纬度
	
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLng() {
		return lng;
	}
	public void setLng(String lng) {
		this.lng = lng;
	}
	public String getBd09Lng() {
		return bd09Lng;
	}
	public void setBd09Lng(String bd09Lng) {
		this.bd09Lng = bd09Lng;
	}
	public String getBd09Lat() {
		return bd09Lat;
	}
	public void setBd09Lat(String bd09Lat) {
		this.bd09Lat = bd09Lat;
	}

}
