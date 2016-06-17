package com.takshine.wxcrm.message.social;

import java.util.ArrayList;
import java.util.List;

import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.message.sugar.BaseCrm;

public class SocialUserInfoResp extends BaseCrm{
	private String currpage = null;
	private String pagecount = null;
	private String totalnum = null;
	
	private List<SocialUserInfo> slist = new ArrayList<SocialUserInfo>();
	
	
	public List<SocialUserInfo> getSlist() {
		return slist;
	}
	public void setSlist(List<SocialUserInfo> slist) {
		this.slist = slist;
	}
	public String getCurrpage() {
		return currpage;
	}
	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}
	public String getPagecount() {
		return pagecount;
	}
	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}
	public String getTotalnum() {
		return totalnum;
	}
	public void setTotalnum(String totalnum) {
		this.totalnum = totalnum;
	}
	
	
}
