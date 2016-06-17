package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 标签  用户添加的标签
 * @author liulin
 *
 */
public class ModelTag extends BaseModel{
	
	private String tag_id = null; 
	private String tag_point = null; 
	private String model_id  = null;
	
	public String getTag_id() {
		return tag_id;
	}
	public void setTag_id(String tag_id) {
		this.tag_id = tag_id;
	}
	public String getTag_point() {
		return tag_point;
	}
	public void setTag_point(String tag_point) {
		this.tag_point = tag_point;
	}
	public String getModel_id() {
		return model_id;
	}
	public void setModel_id(String model_id) {
		this.model_id = model_id;
	} 
}
