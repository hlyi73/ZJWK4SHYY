package com.takshine.wxcrm.message.sugar;

/**
 * 产品价格表
 * 
 * @author 黄鹏
 *
 */
public class ProductCostAdd {

	private String startdate; // 开始时间
	private String enddate; // 结束时间
	private String unit;// 单位
	private String accounting;// 核算方法
	private String standardprice; // 标准成本
	private String averageprice;// 平均成本
	private String desc; // 说明

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

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getAccounting() {
		return accounting;
	}

	public void setAccounting(String accounting) {
		this.accounting = accounting;
	}

	public String getStandardprice() {
		return standardprice;
	}

	public void setStandardprice(String standardprice) {
		this.standardprice = standardprice;
	}

	public String getAverageprice() {
		return averageprice;
	}

	public void setAverageprice(String averageprice) {
		this.averageprice = averageprice;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

}
