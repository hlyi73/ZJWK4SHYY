package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.BusinessCardModel;

public class BusinessCard extends BusinessCardModel {
	private String partyId;
	private String openId;
	private String name;
	private String phone;
	private String extPhone;
	private String company;
	private String shortcompany;
	private String position;
	private String headImageUrl;
	private String email;
	private String city;
	private String province;
	private String address;
	private String sex = "0";
	private String status = "0";
	private String isValidation = "0";
	private String isEmailValidation = "0";

	public String getIsEmailValidation() {
		return isEmailValidation;
	}

	public void setIsEmailValidation(String isEmailValidation) {
		this.isEmailValidation = isEmailValidation;
	}

	private List<String> party_rowid_in;

	public List<String> getParty_rowid_in() {
		return party_rowid_in;
	}

	public void setParty_rowid_in(List<String> party_rowid_in) {
		this.party_rowid_in = party_rowid_in;
	}

	public String getIsValidation() {
		return isValidation;
	}

	public void setIsValidation(String isValidation) {
		this.isValidation = isValidation;
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

	public String getExtPhone() {
		return extPhone;
	}

	public void setExtPhone(String extPhone) {
		this.extPhone = extPhone;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getHeadImageUrl() {
		return headImageUrl;
	}

	public void setHeadImageUrl(String headImageUrl) {
		this.headImageUrl = headImageUrl;
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

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getShortcompany() {
		return shortcompany;
	}

	public void setShortcompany(String shortcompany) {
		this.shortcompany = shortcompany;
	}
	public String toVCARDString(){
		StringBuffer sb = new StringBuffer();
		sb.append("BEGIN:VCARD\n");
		sb.append("VERSION:3.0\n");
		sb.append("N:"+this.getName()+"\n");
    	sb.append("EMAIL:"+this.getEmail()+"\n");
		sb.append("TEL;WORK,CELL:"+this.getPhone()+"\n");
		sb.append("ADR;TYPE=WORK:"+this.getAddress()+"\n");
		sb.append("TITLE:"+this.getPosition()+"\n");
		sb.append("ORG:"+this.getCompany()+"\n");
		sb.append("END:VCARD");
		return sb.toString();

	}

}
