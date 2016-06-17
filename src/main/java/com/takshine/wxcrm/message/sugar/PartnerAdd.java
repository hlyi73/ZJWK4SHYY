package com.takshine.wxcrm.message.sugar;

/**
 * 合作伙伴
 * @author dengbo
 *
 */
public class PartnerAdd extends BaseCrm{
	
	private String rowid;//记录ID
	private String customername;//合作伙伴名称
	private String phoneoffice;//电话号码
	private String customerid;//客户ID
	private String desc;//描述
	private String opptyid;//业务机会ID
	
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
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
}
