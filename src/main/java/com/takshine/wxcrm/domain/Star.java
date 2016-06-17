package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.StarModel;

/**
 * 星标
 * 
 * @author 黄鹏
 *
 */
public class Star extends StarModel {
	private String parentId;
	private String parentType;

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getParentType() {
		return parentType;
	}

	public void setParentType(String parentType) {
		this.parentType = parentType;
	}

}
