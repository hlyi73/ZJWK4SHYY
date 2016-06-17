package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询用户行为统计的参数
 * 
 * @author huangpeng
 *
 */
public class AccesslogReq extends BaseCrm {
	private String startDate;
	private String endDate;
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
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

}
