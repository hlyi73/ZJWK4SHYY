package com.takshine.wxcrm.message.sugar;

/**
 * 查询销售目标报表接口 从crm响应回来的参数
 * @author dengbo
 *
 */
public class AnalyticsQuotaResp extends BaseCrm{
	
	private String quarter;//季度,Q1(第一季度)/Q2(第二季度)/Q3(第三季度)/Q4(第四季度)
	private String month;//月份
	private String quotaamt;//目标金额
	private String recamt;//实际金额
	private String growthrate;//达成率
	private String startdate;//季度开始时间
	private String enddate;//季度结束时间
	
	public String getQuarter() {
		return quarter;
	}
	public void setQuarter(String quarter) {
		this.quarter = quarter;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getQuotaamt() {
		return quotaamt;
	}
	public void setQuotaamt(String quotaamt) {
		this.quotaamt = quotaamt;
	}
	public String getRecamt() {
		return recamt;
	}
	public void setRecamt(String recamt) {
		this.recamt = recamt;
	}
	public String getGrowthrate() {
		return growthrate;
	}
	public void setGrowthrate(String growthrate) {
		this.growthrate = growthrate;
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
	
}
