package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

import com.takshine.wxcrm.domain.Sign;


/**
 * 考勤签到
 *
 */
public class SignResp extends BaseCrm{
	
	private String viewtype;
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private List<Sign> signs = new ArrayList<Sign>();//费用列表
	
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getCount() {
		return null == count ? "0" : count;
	}
	public void setCount(String count) {
		this.count = count;
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
	public List<Sign> getSigns() {
		return signs;
	}
	public void setSigns(List<Sign> signs) {
		this.signs = signs;
	}
	
}
