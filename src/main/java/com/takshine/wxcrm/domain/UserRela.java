package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 用户关联
 * @author Administrator
 *
 */
public class UserRela extends BaseModel{
	
	private String id = null;
	private String user_id = null;
	private String user_name = null;
	private String rela_user_id = null;
	private String rela_user_name = null;
	private String type = null;
	private String create_date = null;
	
	private Integer currpages = new Integer(0);
	private Integer pagecounts = new Integer(10);
	
	//扩展
	private String headimgurl = null;
	private String city = null;
	private String company = null;
	private String county = null;
	private String depart = null;
	private String email_1 = null;
	private String mobile_no_1 = null;
	private String position = null;
	private String province = null;
	private String first_char = null;
	
	public String getFirst_char() {
		return first_char;
	}
	public void setFirst_char(String first_char) {
		this.first_char = first_char;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getRela_user_id() {
		return rela_user_id;
	}
	public void setRela_user_id(String rela_user_id) {
		this.rela_user_id = rela_user_id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public Integer getCurrpages() {
		return currpages;
	}
	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}
	public Integer getPagecounts() {
		return pagecounts;
	}
	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getRela_user_name() {
		return rela_user_name;
	}
	public void setRela_user_name(String rela_user_name) {
		this.rela_user_name = rela_user_name;
	}
	public String getHeadimgurl() {
		return headimgurl;
	}
	public void setHeadimgurl(String headimgurl) {
		this.headimgurl = headimgurl;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getCounty() {
		return county;
	}
	public void setCounty(String county) {
		this.county = county;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getEmail_1() {
		return email_1;
	}
	public void setEmail_1(String email_1) {
		this.email_1 = email_1;
	}
	public String getMobile_no_1() {
		return mobile_no_1;
	}
	public void setMobile_no_1(String mobile_no_1) {
		this.mobile_no_1 = mobile_no_1;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
}
