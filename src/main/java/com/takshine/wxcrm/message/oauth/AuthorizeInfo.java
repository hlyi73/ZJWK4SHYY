package com.takshine.wxcrm.message.oauth;

/**
 * 权限信息
 * @author liulin
 *
 */
public class AuthorizeInfo {
	
	private String accessToken; //网页授权接口调用凭证,注意：此access_token与基础支持的access_token不同
	private int expiresIn;//access_token接口调用凭证超时时间，单位（秒）
	private String refreshToken; //用户刷新access_token
	private String openId ;//用户唯一标识
	private String scope ;//用户授权的作用域，使用逗号（,）分隔
	
	public String getAccessToken() {
		return accessToken;
	}
	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}
	public int getExpiresIn() {
		return expiresIn;
	}
	public void setExpiresIn(int expiresIn) {
		this.expiresIn = expiresIn;
	}
	public String getRefreshToken() {
		return refreshToken;
	}
	public void setRefreshToken(String refreshToken) {
		this.refreshToken = refreshToken;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getScope() {
		return scope;
	}
	public void setScope(String scope) {
		this.scope = scope;
	}
	
	
}
