package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.OrganizationModel;

/**
 * 组织 实体类
 * @author dengbo
 *
 */
public class Organization extends OrganizationModel{
	
	private Integer currpages = 0;
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
