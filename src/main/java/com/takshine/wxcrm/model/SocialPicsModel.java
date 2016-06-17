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
public class SocialPicsModel extends BaseModel {
	private String pic_urls;

	public String getPic_urls() {
		return pic_urls;
	}

	public void setPic_urls(String pic_urls) {
		this.pic_urls = pic_urls;
	}
}
