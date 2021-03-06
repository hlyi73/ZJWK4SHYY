package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm查询分享
 * @author dengbo
 *
 */
public class ShareReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String currpage ;//当前页
	private String pagecount;//每页的条数
	private String parentid;//共享的记录ID
	private String parenttype;//共享的记录类型,Accounts:企业；Opportunities:业务机会; Contacts:联系人；Tasks:任务；Contract：合同
	private String shareuserid;//共享给某用户的用户ID
	private String shareusername;//共享某用户的用户名
	
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
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getShareuserid() {
		return shareuserid;
	}
	public void setShareuserid(String shareuserid) {
		this.shareuserid = shareuserid;
	}
	public String getShareusername() {
		return shareusername;
	}
	public void setShareusername(String shareusername) {
		this.shareusername = shareusername;
	}
	
}
