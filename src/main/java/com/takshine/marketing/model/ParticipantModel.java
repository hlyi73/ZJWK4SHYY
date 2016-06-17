package com.takshine.marketing.model;

import java.util.List;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.DateTime;

/**
 * 活动用户表
 * 
 *
 */
public class ParticipantModel extends BaseModel {

	private String id;
	private String opName;
	private String opDuty;
	private String opDepart;
	private String opCompany;
	private String opMobile;
	private String opPhone;
	private String opEmail;
	private String opFax;
	private String opCountry;
	private String opProvince;
	private String opCity;
	private String opAddress;
	private String opStatus;
	private String opSignature;
	private String opGender;
	private String opImage ;
	private String syncStatus;
	private String currentDateDistance;//时间间隔字符串
	private String sourceid;
	private String source;
	
	private List<String> id_in;
	
	private String flag;//是否是好友关系
	
	
	public List<String> getId_in() {
		return id_in;
	}
	public void setId_in(List<String> id_in) {
		this.id_in = id_in;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
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
	public String getCurrentDateDistance() {
		return currentDateDistance;
	}
	private String status;//报名状态 通过：1；不通过：0
	public void setCurrentDateDistance(String currentDateDistance) {
		this.currentDateDistance = DateTime.currentDateDistance(currentDateDistance);
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSyncStatus() {
		return syncStatus;
	}
	public void setSyncStatus(String syncStatus) {
		this.syncStatus = syncStatus;
	}
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getOpName() {
		return opName;
	}

	public void setOpName(String opName) {
		this.opName = opName;
	}

	public String getOpDuty() {
		return opDuty;
	}

	public void setOpDuty(String opDuty) {
		this.opDuty = opDuty;
	}

	public String getOpDepart() {
		return opDepart;
	}
	
	public String getOpCompany() {
		return opCompany;
	}

	public void setOpCompany(String opCompany) {
		this.opCompany = opCompany;
	}

	public void setOpDepart(String opDepart) {
		this.opDepart = opDepart;
	}

	public String getOpMobile() {
		return opMobile;
	}

	public void setOpMobile(String opMobile) {
		this.opMobile = opMobile;
	}

	public String getOpPhone() {
		return opPhone;
	}

	public void setOpPhone(String opPhone) {
		this.opPhone = opPhone;
	}

	public String getOpEmail() {
		return opEmail;
	}

	public void setOpEmail(String opEmail) {
		this.opEmail = opEmail;
	}

	public String getOpFax() {
		return opFax;
	}

	public void setOpFax(String opFax) {
		this.opFax = opFax;
	}

	public String getOpCountry() {
		return opCountry;
	}

	public void setOpCountry(String opCountry) {
		this.opCountry = opCountry;
	}

	public String getOpProvince() {
		return opProvince;
	}

	public void setOpProvince(String opProvince) {
		this.opProvince = opProvince;
	}

	public String getOpCity() {
		return opCity;
	}

	public void setOpCity(String opCity) {
		this.opCity = opCity;
	}

	public String getOpAddress() {
		return opAddress;
	}

	public void setOpAddress(String opAddress) {
		this.opAddress = opAddress;
	}

	public String getOpStatus() {
		return opStatus;
	}

	public void setOpStatus(String opStatus) {
		this.opStatus = opStatus;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOpSignature() {
		return opSignature;
	}

	public void setOpSignature(String opSignature) {
		this.opSignature = opSignature;
	}

	public String getOpGender() {
		return opGender;
	}

	public void setOpGender(String opGender) {
		this.opGender = opGender;
	}

	public String getOpImage() {
		return opImage;
	}

	public void setOpImage(String opImage) {
		this.opImage = opImage;
	}
	

}
