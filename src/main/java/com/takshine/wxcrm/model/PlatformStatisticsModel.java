package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 平台统计
 *
 */
public class PlatformStatisticsModel extends BaseModel{
	  private String party_row_id;
	  private String type;
	  private String model;
	  private String url;
	  private String rela_id;
	  private String user_name;
	  private String r_type;
	  
	public String getParty_row_id() {
		return party_row_id;
	}
	public void setParty_row_id(String party_row_id) {
		this.party_row_id = party_row_id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getRela_id() {
		return rela_id;
	}
	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getR_type() {
		return r_type;
	}
	public void setR_type(String r_type) {
		this.r_type = r_type;
	}
	 
	  
}
