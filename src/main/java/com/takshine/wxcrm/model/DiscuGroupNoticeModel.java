package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组公告
 * @author Administrator
 *
 */
public class DiscuGroupNoticeModel extends BaseModel {
	
	private String rela_id = null;
	private String rela_type = null;
	private String rela_name = null;
	private String content = null;
	private String type = null;
	private String create_time = null;
	private String creator = null;
	private String img_url = null;
	
	public String getRela_id() {
		return rela_id;
	}
	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}
	public String getRela_type() {
		return rela_type;
	}
	public void setRela_type(String rela_type) {
		this.rela_type = rela_type;
	}
	public String getRela_name() {
		return rela_name;
	}
	public void setRela_name(String rela_name) {
		this.rela_name = rela_name;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getImg_url() {
		return img_url;
	}
	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}
}
