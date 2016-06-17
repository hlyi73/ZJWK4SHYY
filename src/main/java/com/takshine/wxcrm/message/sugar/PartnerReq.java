package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询合作伙伴
 * @author dengbo
 *
 */
public class PartnerReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private String rowid;
	private String customerId;//客户ID
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
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getOpptyid() {
		return opptyid;
	}
	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}
	
}
