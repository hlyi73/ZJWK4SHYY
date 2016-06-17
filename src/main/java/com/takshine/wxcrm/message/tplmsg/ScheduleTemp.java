package com.takshine.wxcrm.message.tplmsg;

public class ScheduleTemp extends BaseTemp {
	
	private ValColor first = new ValColor();
	private ValColor schedule = new ValColor();
	private ValColor time = new ValColor();
	private ValColor remark = new ValColor();
	
	public ValColor getFirst() {
		return first;
	}
	public void setFirst(ValColor first) {
		this.first = first;
	}
	public ValColor getSchedule() {
		return schedule;
	}
	public void setSchedule(ValColor schedule) {
		this.schedule = schedule;
	}
	public ValColor getTime() {
		return time;
	}
	public void setTime(ValColor time) {
		this.time = time;
	}
	public ValColor getRemark() {
		return remark;
	}
	public void setRemark(ValColor remark) {
		this.remark = remark;
	}
	
}
