package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;



/**
 * 查询产品接口 从crm响应回来的参数
 * @author huangpeng 
 *
 */
public class ProductResp extends BaseCrm{
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	
	private List<ProductAdd> porducts = new ArrayList<ProductAdd>();//产品列表

	public String getCount() {
		return count;
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

	public List<ProductAdd> getPorducts() {
		return porducts;
	}

	public void setPorducts(List<ProductAdd> porducts) {
		this.porducts = porducts;
	}
}
