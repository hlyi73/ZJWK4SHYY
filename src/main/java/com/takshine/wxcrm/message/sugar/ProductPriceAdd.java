package com.takshine.wxcrm.message.sugar;

/**
 * 产品价格表
 * 
 * @author 黄鹏
 *
 */
public class ProductPriceAdd {
	private String coin; // 货币

	private String priceType; // 价格类型
	private String startdate; // 开始时间
	private String enddate; // 结束时间
	private String payTerm; // 付款条件
	private String desc; // 说明
	private String listprice; // 列表价格
	private String promotionprice; // 促销价格
	private String maxprice; // 最高价格
	private String minprice; // 最低价格

	public String getCoin() {
		return coin;
	}

	public void setCoin(String coin) {
		this.coin = coin;
	}

	public String getPriceType() {
		return priceType;
	}

	public void setPriceType(String priceType) {
		this.priceType = priceType;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getPayTerm() {
		return payTerm;
	}

	public void setPayTerm(String payTerm) {
		this.payTerm = payTerm;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getListprice() {
		return listprice;
	}

	public void setListprice(String listprice) {
		this.listprice = listprice;
	}

	public String getPromotionprice() {
		return promotionprice;
	}

	public void setPromotionprice(String promotionprice) {
		this.promotionprice = promotionprice;
	}

	public String getMaxprice() {
		return maxprice;
	}

	public void setMaxprice(String maxprice) {
		this.maxprice = maxprice;
	}

	public String getMinprice() {
		return minprice;
	}

	public void setMinprice(String minprice) {
		this.minprice = minprice;
	}

}
