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
public class SocialTagsModel extends BaseModel {
	private String tag;

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}
	
}
