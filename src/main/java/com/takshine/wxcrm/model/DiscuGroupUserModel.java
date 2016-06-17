package com.takshine.wxcrm.model;

import org.apache.commons.lang.StringUtils;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组用户
 * @author Administrator
 *
 */
public class DiscuGroupUserModel extends BaseModel {
	
	private String dis_id = null;
	private String user_id = null;
	private String user_name = null;
	private String card_name = null;
	private String user_type = null;
	private String create_time = null;
	
	public String getDis_id() {
		return dis_id;
	}
	public void setDis_id(String dis_id) {
		this.dis_id = dis_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_type() {
		return user_type;
	}
	public void setUser_type(String user_type) {
		this.user_type = user_type;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getUser_name() {
		if(StringUtils.isNotBlank(this.card_name)){
			return this.card_name;
		}
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getCard_name() {
		return card_name;
	}
	public void setCard_name(String card_name) {
		this.card_name = card_name;
	}
}
