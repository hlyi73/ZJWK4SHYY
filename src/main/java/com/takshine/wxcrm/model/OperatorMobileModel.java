/*
 * UserinfoModel.java 
 * Copyright(c) 2007 BroadText Inc.
 * ALL Rights Reserved.
 */
package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 用户手机绑定关系表 Model
 * 
 * @author liulin
 */
public class OperatorMobileModel extends BaseModel {
	
	private String opId = null;//德成用户表ID
	private String enabled_flag;//标志位
	
	public String getEnabled_flag() {
		return enabled_flag;
	}

	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}

	public String getOpId() {
		return opId;
	}

	public void setOpId(String opId) {
		this.opId = opId;
	}
}
