package com.takshine.wxcrm.message.sugar;

/**
 * 查询产品报价报表接口 从crm响应回来的参数
 * @author dengbo
 *
 */
public class AnalyticsQuoteResp extends BaseCrm{
	
	private String amount;//报价金额
	private String month;//月份
	private String productname;//产品名称
	private String productid;//产品ID
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public String getProductid() {
		return productid;
	}
	public void setProductid(String productid) {
		this.productid = productid;
	}
}
