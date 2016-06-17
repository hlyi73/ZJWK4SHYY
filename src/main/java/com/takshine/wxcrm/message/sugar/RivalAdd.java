package com.takshine.wxcrm.message.sugar;

/**
 * 竞争对手
 * @author dengbo
 *
 */
public class RivalAdd extends BaseCrm{
	
	private String rowid = null;//记录ID
	private String customername;//竞争对手名称
	private String desc;
	private String threat;
	private String customerid;//客户ID
	private String opptyid;//业务机会ID
	
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getThreat() {
		return threat;
	}

	public void setThreat(String threat) {
		this.threat = threat;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
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
