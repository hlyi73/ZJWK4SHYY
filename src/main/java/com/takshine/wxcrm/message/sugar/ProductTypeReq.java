package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询产品的参数
 * 
 * @author huangpeng
 *
 */
public class ProductTypeReq extends BaseCrm {
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数

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
