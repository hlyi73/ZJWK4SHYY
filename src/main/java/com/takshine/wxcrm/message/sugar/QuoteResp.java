package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询报价接口从crm响应回来的参数
 * 
 * @author dengbo
 *
 */
public class QuoteResp extends BaseCrm {
	
	private String count = null;//数字
	private String currpage = "1";//当前页
	private String pagecount = "10";//每页的条数
	private List<QuoteAdd> quotes = new ArrayList<QuoteAdd>();//报价列表
	
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
	public List<QuoteAdd> getQuotes() {
		return quotes;
	}
	public void setQuotes(List<QuoteAdd> quotes) {
		this.quotes = quotes;
	}
	
}
