/*
 * UserinfoModel.java 
 * Copyright(c) 2007 BroadText Inc.
 * ALL Rights Reserved.
 */
package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 微信用户基本信息表 Model
 * 
 * @author liulin
 */
public class SocialMessagesModel extends BaseModel {
	private String createdate;
	private String text;
	private String source;
	private String reposts_count;
	private String comments_count;
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getReposts_count() {
		return reposts_count;
	}
	public void setReposts_count(String reposts_count) {
		this.reposts_count = reposts_count;
	}
	public String getComments_count() {
		return comments_count;
	}
	public void setComments_count(String comments_count) {
		this.comments_count = comments_count;
	}
	
	
}
