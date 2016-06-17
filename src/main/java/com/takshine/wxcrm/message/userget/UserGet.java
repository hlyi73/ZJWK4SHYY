package com.takshine.wxcrm.message.userget;

import java.util.List;

import com.takshine.wxcrm.message.userinfo.UserInfo;

public class UserGet {
	
	private String total ;
	private String count ;
	private String next_openid ;
	private List<String> openidlist ;
	private List<UserInfo> uinfolist ;
	
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public String getNext_openid() {
		return next_openid;
	}
	public void setNext_openid(String next_openid) {
		this.next_openid = next_openid;
	}
	public List<String> getOpenidlist() {
		return openidlist;
	}
	public void setOpenidlist(List<String> openidlist) {
		this.openidlist = openidlist;
	}
	public List<UserInfo> getUinfolist() {
		return uinfolist;
	}
	public void setUinfolist(List<UserInfo> uinfolist) {
		this.uinfolist = uinfolist;
	}
}
