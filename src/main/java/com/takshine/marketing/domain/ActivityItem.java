package com.takshine.marketing.domain;

import com.takshine.marketing.model.ActivityItemModel;
/**
 * 
 * @author lilei
 * 活动基本信息
 */
public class ActivityItem extends ActivityItemModel {
	private String id;//主键
	private String content;//内容
	private String start_date;//开始时间
	private String end_date;//结束时间
	private String experts; //专家或嘉宾
	private String activity_id;//
	
	
	public String getActivity_id() {
		return activity_id;
	}
	public void setActivity_id(String activity_id) {
		this.activity_id = activity_id;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getExperts() {
		return experts;
	}
	public void setExperts(String experts) {
		this.experts = experts;
	}
	
	
	
}
