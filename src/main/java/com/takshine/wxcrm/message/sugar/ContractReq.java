package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询合同的参数
 * 
 * @author dengbo
 *
 */
public class ContractReq extends BaseCrm {
	private String viewtype;// 视图类型 myview,teamview,focusview,allview
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String contractstatus;
	private String viewtypesel;
	private String firstchar;
	private String title;//合同名称
	
	//报表分析条件
	private String startdate = null;//关闭的开始日期
	private String enddate = null;//关闭的结束日期
	private String assignId = null;//责任人	
	private String orderString;//排序条件
	
	public String getOrderString() {
		return orderString;
	}

	public void setOrderString(String orderString) {
		this.orderString = orderString;
	}

	public String getFirstchar() {
		return firstchar;
	}

	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getAssignId() {
		return assignId;
	}

	public void setAssignId(String assignId) {
		this.assignId = assignId;
	}

	public String getViewtypesel() {
		return viewtypesel;
	}

	public void setViewtypesel(String viewtypesel) {
		this.viewtypesel = viewtypesel;
	}

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
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

	public String getContractstatus() {
		return contractstatus;
	}

	public void setContractstatus(String contractstatus) {
		this.contractstatus = contractstatus;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
}
