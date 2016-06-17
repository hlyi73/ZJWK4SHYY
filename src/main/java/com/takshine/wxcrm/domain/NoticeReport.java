package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.base.model.BaseModel;

public class NoticeReport extends BaseModel {
	private String partyId;
	private String openId;
	private String name;
	private String phone;
	private String email;
	private String city;

	private int msgcount = 0; // 未读通知数
	private int taskcount = 0; // 任务数
	private int untaskcount = 0; // 未完成任务数
	private int evalcount = 0; // 评价数量
	private int activitycount = 0; // 关注活动数
	private int ownerNoEvalCount = 0;//未进行自我评价的工作计划
	
	
	public int getOwnerNoEvalCount() {
		return ownerNoEvalCount;
	}

	public void setOwnerNoEvalCount(int ownerNoEvalCount) {
		this.ownerNoEvalCount = ownerNoEvalCount;
	}
	public String getPartyId() {
		return partyId;
	}

	public void setPartyId(String partyId) {
		this.partyId = partyId;
	}

	public String getOpenId() {
		return openId;
	}

	public void setOpenId(String openId) {
		this.openId = openId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public int getMsgcount() {
		return msgcount;
	}

	public void setMsgcount(int msgcount) {
		this.msgcount = msgcount;
	}

	public int getTaskcount() {
		return taskcount;
	}

	public void setTaskcount(int taskcount) {
		this.taskcount = taskcount;
	}

	public int getUntaskcount() {
		return untaskcount;
	}

	public void setUntaskcount(int untaskcount) {
		this.untaskcount = untaskcount;
	}

	public int getEvalcount() {
		return evalcount;
	}

	public void setEvalcount(int evalcount) {
		this.evalcount = evalcount;
	}

	public int getActivitycount() {
		return activitycount;
	}

	public void setActivitycount(int activitycount) {
		this.activitycount = activitycount;
	}
}
