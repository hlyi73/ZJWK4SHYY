package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.RegisterModel;

/**
 * 注册 
 * @author dengbo
 *
 */
public class Register extends RegisterModel{
	
	private Integer currpages = 1;
	private Integer pagecounts = 10;
	
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
