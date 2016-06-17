package com.takshine.wxcrm.message.sugar;

/**
 * 帐号绑定请求信息
 * @author liulin
 * 
 */
public class AuthResp extends BaseCrm {
	private String crmid;// 帐号ID (令牌)
	private String opname;
	private String opduty;
	private String opmobile;
	private String opemail;
	private String opdepart;
	private String opaddress;

	public String getCrmid() {
		return crmid;
	}

	public void setCrmid(String crmid) {
		this.crmid = crmid;
	}

	public String getOpname() {
		return opname;
	}

	public void setOpname(String opname) {
		this.opname = opname;
	}

	public String getOpduty() {
		return opduty;
	}

	public void setOpduty(String opduty) {
		this.opduty = opduty;
	}

	public String getOpmobile() {
		return opmobile;
	}

	public void setOpmobile(String opmobile) {
		this.opmobile = opmobile;
	}

	public String getOpemail() {
		return opemail;
	}

	public void setOpemail(String opemail) {
		this.opemail = opemail;
	}

	public String getOpaddress() {
		return opaddress;
	}

	public void setOpaddress(String opaddress) {
		this.opaddress = opaddress;
	}

	public String getOpdepart() {
		return opdepart;
	}

	public void setOpdepart(String opdepart) {
		this.opdepart = opdepart;
	}
	
}
