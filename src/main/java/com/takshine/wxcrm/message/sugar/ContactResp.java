package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询联系人
 * @author liulin 
 *
 */
public class ContactResp extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private List<ContactAdd> contacts = new ArrayList<ContactAdd>();//联系人列表
	
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
	public List<ContactAdd> getContacts() {
		return contacts;
	}
	public void setContacts(List<ContactAdd> contacts) {
		this.contacts = contacts;
	}
	
}
