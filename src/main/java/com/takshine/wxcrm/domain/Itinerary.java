package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.ItineraryModel;

public class Itinerary extends ItineraryModel {
   private String id;
   private String city;
   private String itinerarydate;
   private String name;
   private String company;
   private String headimgurl;
public String getHeadimgurl() {
	return headimgurl;
}
public void setHeadimgurl(String headimgurl) {
	this.headimgurl = headimgurl;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getCompany() {
	return company;
}
public void setCompany(String company) {
	this.company = company;
}
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getCity() {
	return city;
}
public void setCity(String city) {
	this.city = city;
}
public String getItinerarydate() {
	return itinerarydate;
}
public void setItinerarydate(String itinerarydate) {
	this.itinerarydate = itinerarydate;
}
public String getRemark() {
	return remark;
}
public void setRemark(String remark) {
	this.remark = remark;
}
private String remark;

}
