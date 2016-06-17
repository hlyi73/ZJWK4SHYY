package com.takshine.wxcrm.domain.cache;

/**
 * 联系人前端缓存
 * 
 * @author Administrator
 *
 */
public class CacheContact extends CacheBase{
	
	private String sex = null;
	private String position = null;
	private String mobile = null;
	private String type = null;
	private String source = null;
	private String address = null;
	private String requency = null;
	private String salutation = null;//称谓
	private String filename = null;//称谓
	private String firstname = null;//首字母
	private String email = null;//首字母
	private String isFriends = null;//是否是好友
	private String tagtype = null;
	
	public String getTagtype() {
		return tagtype;
	}

	public void setTagtype(String tagtype) {
		this.tagtype = tagtype;
	}
	
	public CacheContact transf(){
		CacheContact c = new CacheContact();
		return c;
	}
	
	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRequency() {
		return requency;
	}

	public void setRequency(String requency) {
		this.requency = requency;
	}

	public String getSalutation() {
		return salutation;
	}

	public void setSalutation(String salutation) {
		this.salutation = salutation;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getIsFriends() {
		return isFriends;
	}

	public void setIsFriends(String isFriends) {
		this.isFriends = isFriends;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
}
