/*
 * UserinfoModel.java 
 * Copyright(c) 2007 BroadText Inc.
 * ALL Rights Reserved.
 */
package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 用户表Model
 * 
 * @author pengmd
 */
public class UserinfoModel extends BaseModel {
	private String userName = null;
	private String trueName = null;
	private String passWord = null;
	private String remark = null;
	private String reserve1 = null;
	private String reserve2 = null;
	private String reserve3 = null;
	private String reserve4 = null;
	private String reserve5 = null;
	private String reserve6 = null;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getTrueName() {
		return trueName;
	}

	public void setTrueName(String trueName) {
		this.trueName = trueName;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getReserve1() {
		return reserve1;
	}

	public void setReserve1(String reserve1) {
		this.reserve1 = reserve1;
	}

	public String getReserve2() {
		return reserve2;
	}

	public void setReserve2(String reserve2) {
		this.reserve2 = reserve2;
	}

	public String getReserve3() {
		return reserve3;
	}

	public void setReserve3(String reserve3) {
		this.reserve3 = reserve3;
	}

	public String getReserve4() {
		return reserve4;
	}

	public void setReserve4(String reserve4) {
		this.reserve4 = reserve4;
	}

	public String getReserve5() {
		return reserve5;
	}

	public void setReserve5(String reserve5) {
		this.reserve5 = reserve5;
	}

	public String getReserve6() {
		return reserve6;
	}

	public void setReserve6(String reserve6) {
		this.reserve6 = reserve6;
	}

}