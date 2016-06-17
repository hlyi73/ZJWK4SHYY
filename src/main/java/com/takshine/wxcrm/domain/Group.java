package com.takshine.wxcrm.domain;

import java.io.Serializable;
import java.util.ArrayList;
public class Group implements Serializable{
    private String id;
    private String name;
    private String logo;
    private String rssId;
    private String currDate;
    public String getCurrDate() {
		return currDate;
	}
	public void setCurrDate(String currDate) {
		this.currDate = currDate;
	}
	private ArrayList<Activity> list;
	public ArrayList<Activity> getList() {
		return list;
	}
	public void setList(ArrayList<Activity> list) {
		this.list = list;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLogo() {
		return logo;
	}
	public void setLogo(String logo) {
		this.logo = logo;
	}
	public String getRssId() {
		return rssId;
	}
	public void setRssId(String rssId) {
		this.rssId = rssId;
	}
}
