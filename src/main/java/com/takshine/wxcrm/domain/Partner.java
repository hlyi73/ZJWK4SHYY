
package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.PartnerModel;

/**
 * 合作伙伴的domain
 * @author dengbo
 *
 */
public class Partner extends PartnerModel {
	
	private String viewtype;
	private String customername;//合作伙伴名称
	private String phoneoffice;//电话号码
	private String customerid;//客户ID
	private String desc;//描述
	private String opptyid;//业务机会ID
	private String rowid;
	
	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

	public String getPhoneoffice() {
		return phoneoffice;
	}

	public void setPhoneoffice(String phoneoffice) {
		this.phoneoffice = phoneoffice;
	}

	public String getCustomerid() {
		return customerid;
	}

	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}

	public String getOpptyid() {
		return opptyid;
	}

	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	
}