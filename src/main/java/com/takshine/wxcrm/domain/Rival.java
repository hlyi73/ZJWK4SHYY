
package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.RivalModel;

/**
 * 竞争对手的domain
 * @author dengbo
 *
 */
public class Rival extends RivalModel {
	
	private String viewtype;
	private String customername;//竞争对手名称
	private String customerid;//客户ID
	private String opptyid;//业务机会ID	
	private String threat;//威胁
	private String desc;
	private String rowid;
		
	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
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

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}

	public String getCustomerid() {
		return customerid;
	}

	public void setCustomerid(String customerid) {
		this.customerid = customerid;
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