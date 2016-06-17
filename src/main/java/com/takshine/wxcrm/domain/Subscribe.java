package com.takshine.wxcrm.domain;

import java.io.Serializable;

import com.takshine.wxcrm.model.SubscribeModel;

/**
 * 用户内部订阅实体类
 * @author dengbo
 *
 */
public class Subscribe extends SubscribeModel implements Serializable {
	private String crmId;
	public String getCrmId() {
		return crmId;
	}
	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}
	private String feedid;//活动流记录ID
	private String type;//订阅类型：record,user,activity,group
	private String name;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
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
	public String getFeedid() {
		return feedid;
	}
	public void setFeedid(String feedid) {
		this.feedid = feedid;
	}
}
