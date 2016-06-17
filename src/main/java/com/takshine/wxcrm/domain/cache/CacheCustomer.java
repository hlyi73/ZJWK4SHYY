package com.takshine.wxcrm.domain.cache;

/**
 * 客户
 * @author Administrator
 *
 */

public class CacheCustomer extends CacheBase {
	
	private String accnttype = null;
	private String telephone = null;
	private String soure = null;
	private String industy = null;
	private String address = null;
	private String contact_id = null;
	private String amount = null;
	private String oppty_amount = null;
	//责任人
	private String assigner = null;
	private String tagName = null ; 
	private String starflag = null ; 
	
	public CacheCustomer transf(){
		CacheCustomer c = new CacheCustomer();
		return c;
	}

	public String getAccnttype() {
		return accnttype;
	}

	public void setAccnttype(String accnttype) {
		this.accnttype = accnttype;
	}
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getSoure() {
		return soure;
	}

	public void setSoure(String soure) {
		this.soure = soure;
	}

	public String getIndusty() {
		return industy;
	}

	public void setIndusty(String industy) {
		this.industy = industy;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getContact_id() {
		return contact_id;
	}

	public void setContact_id(String contact_id) {
		this.contact_id = contact_id;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getOppty_amount() {
		return oppty_amount;
	}

	public void setOppty_amount(String oppty_amount) {
		this.oppty_amount = oppty_amount;
	}

	public String getAssigner() {
		return assigner;
	}

	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getStarflag() {
		return starflag;
	}

	public void setStarflag(String starflag) {
		this.starflag = starflag;
	}
	
}
