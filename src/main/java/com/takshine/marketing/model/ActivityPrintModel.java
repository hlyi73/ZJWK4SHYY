package com.takshine.marketing.model;

import com.takshine.wxcrm.base.model.BaseModel;

public class ActivityPrintModel extends BaseModel {
     private String activityid;
     private String openid;
	 private String type;// visit :访问；praise：点赞
	 private String sourceid;//第三方 用户Id
	 private String source;//来源   ＷＫ：微客；ＲＭ：人脉
	 private String forwardid;
	 private String sourcename;
	 public String getSourcename() {
		return sourcename;
	}
	public void setSourcename(String sourcename) {
		this.sourcename = sourcename;
	}
	private int forwardcount;
	 
	 
	public int getForwardcount() {
		return forwardcount;
	}
	public void setForwardcount(int forwardcount) {
		this.forwardcount = forwardcount;
	}
	public String getForwardid() {
		return forwardid;
	}
	public void setForwardid(String forwardid) {
		this.forwardid = forwardid;
	}
	public String getSourceid() {
		return sourceid;
	}
	public void setSourceid(String sourceid) {
		this.sourceid = sourceid;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getActivityid() {
		return activityid;
	}
	public void setActivityid(String activityid) {
		this.activityid = activityid;
	}
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
