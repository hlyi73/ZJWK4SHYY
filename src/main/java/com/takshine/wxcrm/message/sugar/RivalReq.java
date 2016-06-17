package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询竞争对手
 * @author dengbo
 *
 */
public class RivalReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private String rowId;
	private String customerid;
	private String opptyid;//业务机会ID
	
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
	public String getRowId() {
		return rowId;
	}
	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}
	public String getOpptyid() {
		return opptyid;
	}
	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}
	
}
