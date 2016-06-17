package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询合同的参数
 * 
 * @author dengbo
 *
 */
public class ProjectReq extends BaseCrm {
	private String viewtype;// 视图类型 myview,teamview,focusview,allview
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String status;
	private String firstchar;
	private String rowid;
	
	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getFirstchar() {
		return firstchar;
	}

	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	
}
