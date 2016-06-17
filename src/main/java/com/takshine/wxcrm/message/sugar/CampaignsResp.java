package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询从市场活动接口传递回来的参数
 * @author dengbo
 *
 */
public class CampaignsResp extends BaseCrm{
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();//市场活动列表
	public String getCount() {
		return count;
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
	public List<CampaignsAdd> getCams() {
		return cams;
	}
	public void setCams(List<CampaignsAdd> cams) {
		this.cams = cams;
	}
	
	
}
