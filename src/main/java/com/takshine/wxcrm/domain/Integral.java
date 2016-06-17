package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.IntegralModel;

/**
 * 积分实体类
 * @author dengbo
 *
 */
public class Integral extends IntegralModel{
	
	private String startDate = null;
	private String endDate = null;
	private Integer currpages = 1;
	private Integer pagecounts = 10;
	
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public Integer getCurrpages() {
		return currpages;
	}
	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}
	public Integer getPagecounts() {
		return pagecounts;
	}
	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	
}
