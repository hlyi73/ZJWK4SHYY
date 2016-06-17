package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.AttachmentModel;

/**
 * 附件
 * @author liulin
 *
 */
public class Attachment extends AttachmentModel{
	
	private String parentid;//相关ID
	private String parenttype;//相关类别
	
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	
}
