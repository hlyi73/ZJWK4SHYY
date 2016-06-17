package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询产品类别接口 从crm响应回来的参数
 * 
 * @author huangpeng
 *
 */
public class ProductTypeResp extends BaseCrm {
	private String count = null;// 数字
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数

	private List<ProductTypeAdd> porductTypes = new ArrayList<ProductTypeAdd>();// 产品列表

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

	public List<ProductTypeAdd> getPorductTypes() {
		return porductTypes;
	}

	public void setPorductTypes(List<ProductTypeAdd> porductTypes) {
		this.porductTypes = porductTypes;
	}

}
