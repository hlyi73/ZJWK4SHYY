package com.takshine.wxcrm.message.sugar;


/**
 * 传递给crm 附件 请求 参数
 * @author dengbo
 *
 */
public class AttachmentReq extends BaseCrm{
	
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
