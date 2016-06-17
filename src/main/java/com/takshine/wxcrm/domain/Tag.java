package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.TagModel;

/**
 * 销售方法论
 * @author 刘淋
 *
 */
public class Tag extends TagModel{
	
	private String modelType;
	private String modelId;
	private String tagName;
	private int total;


	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public String getModelType() {
		return modelType;
	}

	public void setModelType(String modelType) {
		this.modelType = modelType;
	}

	public String getModelId() {
		return modelId;
	}

	public void setModelId(String modelId) {
		this.modelId = modelId;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

}
