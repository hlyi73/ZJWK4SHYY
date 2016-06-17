package com.takshine.wxcrm.message.sugar;

public class ActivityReq extends BaseCrm {
	private String viewtype;//视图类型 myview , teamview, focusview, allview 
	private String title;//主题
	private String desc;//内容
	private String startdate;//开始时间
	private String deadline;//报名截止时间
	private String estimatedcost;//预计费用
	private String partner;//合作者
	private String activitytype;//类型
	private String imagename;//图片名称
	private String place;//活动地点
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getDeadline() {
		return deadline;
	}
	public void setDeadline(String deadline) {
		this.deadline = deadline;
	}
	public String getEstimatedcost() {
		return estimatedcost;
	}
	public void setEstimatedcost(String estimatedcost) {
		this.estimatedcost = estimatedcost;
	}
	public String getPartner() {
		return partner;
	}
	public void setPartner(String partner) {
		this.partner = partner;
	}
	public String getActivitytype() {
		return activitytype;
	}
	public void setActivitytype(String activitytype) {
		this.activitytype = activitytype;
	}
	public String getImagename() {
		return imagename;
	}
	public void setImagename(String imagename) {
		this.imagename = imagename;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
	
}
