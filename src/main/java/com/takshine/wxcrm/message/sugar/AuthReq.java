package com.takshine.wxcrm.message.sugar;

/**
 * 帐号绑定请求信息
 * @author liulin
 * 
 */
public class AuthReq extends BaseCrm {
	private String crmpwd;// 密码
	private String source;//
	private String username; //
	private String initorgid;//初始化组织ID

	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCrmpwd() {
		return crmpwd;
	}

	public void setCrmpwd(String crmpwd) {
		this.crmpwd = crmpwd;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getInitorgid() {
		return initorgid;
	}

	public void setInitorgid(String initorgid) {
		this.initorgid = initorgid;
	}

}
