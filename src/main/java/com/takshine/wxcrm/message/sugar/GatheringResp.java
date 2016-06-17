package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询收款接口从crm响应回来的参数
 * 
 * @author dengbo
 *
 */
public class GatheringResp extends BaseCrm {
	private String viewtype;// 视图类型 myview , teamview, focusview, allview
	private String count = null;// 数字
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private List<GatheringAdd> gatherings = new ArrayList<GatheringAdd>();// 收款列表

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

	public List<GatheringAdd> getGatherings() {
		return gatherings;
	}

	public void setGatherings(List<GatheringAdd> gatherings) {
		this.gatherings = gatherings;
	}
}
