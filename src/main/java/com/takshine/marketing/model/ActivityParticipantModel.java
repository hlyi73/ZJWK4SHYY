package com.takshine.marketing.model;

import com.takshine.wxcrm.base.model.BaseModel;

public class ActivityParticipantModel extends BaseModel {
     private String activityid;
     private String participantid;
     private String sourceid;
     private String source;
     private String startdate;
     private String enddate;
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
	public String getParticipantid() {
		return participantid;
	}
	public void setParticipantid(String participantid) {
		this.participantid = participantid;
	}
}
