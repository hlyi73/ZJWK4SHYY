package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 周报
 * @author dengbo
 *
 */
public class WeekReportResp extends BaseCrm{
	
	private String viewtype;//视图类型 myview , allview
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "10";//每页的条数
	private List<WeekReportAdd> reports = new ArrayList<WeekReportAdd>();
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
	public List<WeekReportAdd> getReports() {
		return reports;
	}
	public void setReports(List<WeekReportAdd> reports) {
		this.reports = reports;
	}
	
}
