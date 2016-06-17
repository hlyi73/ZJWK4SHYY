package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 用户关注关系表 Model
 * 
 * @author liulin
 */
public class UserFocusModel extends BaseModel {
	
	private String type = null;//关注类型
	private String crmId = null;//关注者的用户ID
	private String crmName = null;//关注者的用户名称
	private String focusCrmId = null;//被关注的用户ID
	private String focusCrmName = null;//被关注的用户名称
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCrmId() {
		return crmId;
	}
	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}
	public String getFocusCrmId() {
		return focusCrmId;
	}
	public void setFocusCrmId(String focusCrmId) {
		this.focusCrmId = focusCrmId;
	}
	public String getCrmName() {
		return crmName;
	}
	public void setCrmName(String crmName) {
		this.crmName = crmName;
	}
	public String getFocusCrmName() {
		return focusCrmName;
	}
	public void setFocusCrmName(String focusCrmName) {
		this.focusCrmName = focusCrmName;
	}
	
}
