package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.SignModel;

/**
 * 考勤签到
 * 
 *
 */
public class Sign extends SignModel {

	private String signTime = null;
	private String signType = null;
	private String signAddr = null;
	private String signLongitude = null;
	private String signLatitude = null;
	private String remark = null;
	private String viewtype = null;//
	private int currpages = 0;
	private int pagecounts = 10;
	private String name = null;
	private String startdate = null;
	private String enddate = null;
	private List<String> crm_id_in = null;
	private String wximgids;//微信上传图片
	
	public String getSignTime() {
		return signTime;
	}
	public void setSignTime(String signTime) {
		this.signTime = signTime;
	}
	public String getSignType() {
		return signType;
	}
	public void setSignType(String signType) {
		this.signType = signType;
	}
	public String getSignAddr() {
		return signAddr;
	}
	public void setSignAddr(String signAddr) {
		this.signAddr = signAddr;
	}
	public String getSignLongitude() {
		return signLongitude;
	}
	public void setSignLongitude(String signLongitude) {
		this.signLongitude = signLongitude;
	}
	public String getSignLatitude() {
		return signLatitude;
	}
	public void setSignLatitude(String signLatitude) {
		this.signLatitude = signLatitude;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
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
	public List<String> getCrm_id_in() {
		return crm_id_in;
	}
	public void setCrm_id_in(List<String> crm_id_in) {
		this.crm_id_in = crm_id_in;
	}
	public String getWximgids() {
		return wximgids;
	}
	public void setWximgids(String wximgids) {
		this.wximgids = wximgids;
	}

}
