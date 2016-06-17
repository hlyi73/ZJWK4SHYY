package com.takshine.wxcrm.message.sugar;


/**
 * 传递给sugar查询
 * @author dengbo
 *
 */
public class CampaignsReq extends BaseCrm{
	
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String assignerid;// 责任人Id
	private String publicId; //公共Id
	private String openId;
	private String rowid;
	private String firstchar;
	private String viewtype;//branch:下属;share:参与;owner:自己负责的
	
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
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
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getPublicId() {
		return publicId;
	}
	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getFirstchar() {
		return firstchar;
	}
	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

}
