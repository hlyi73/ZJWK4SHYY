package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.SocialContactModel;

/**
 * 微博联系人实体类
 * @author dengbo
 *
 */
public class SocialContact extends SocialContactModel{
	
	private String uid;//微博用户ID
	private String contactid;//联系人ID
	private String access_token;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getContactid() {
		return contactid;
	}
	public void setContactid(String contactid) {
		this.contactid = contactid;
	}
	public String getAccess_token() {
		return access_token;
	}
	public void setAccess_token(String access_token) {
		this.access_token = access_token;
	}
	
}
