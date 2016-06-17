package com.takshine.wxcrm.message.sugar;

/**
 * 财务核销信息
 * @author dengbo
 *
 */
public class VerifityAdd extends BaseCrm{

	//财务核销字段
	private String verifityDate ;//核销日期
	private String verifityAmount ;//核销金额
	private String verStatus;//核销状态
	private String invoicedAmount;//开票金额
	private String invociedDate;//开票日期
	private String verifityRst;//核销说明
	private String invoicedId;//针对某条回款记录的ID
	
	public String getVerifityDate() {
		return verifityDate;
	}
	public void setVerifityDate(String verifityDate) {
		this.verifityDate = verifityDate;
	}
	public String getVerifityAmount() {
		return verifityAmount;
	}
	public void setVerifityAmount(String verifityAmount) {
		this.verifityAmount = verifityAmount;
	}
	public String getVerStatus() {
		return verStatus;
	}
	public void setVerStatus(String verStatus) {
		this.verStatus = verStatus;
	}
	public String getInvoicedAmount() {
		return invoicedAmount;
	}
	public void setInvoicedAmount(String invoicedAmount) {
		this.invoicedAmount = invoicedAmount;
	}
	public String getInvociedDate() {
		return invociedDate;
	}
	public void setInvociedDate(String invociedDate) {
		this.invociedDate = invociedDate;
	}
	public String getVerifityRst() {
		return verifityRst;
	}
	public void setVerifityRst(String verifityRst) {
		this.verifityRst = verifityRst;
	}
	public String getInvoicedId() {
		return invoicedId;
	}
	public void setInvoicedId(String invoicedId) {
		this.invoicedId = invoicedId;
	}
}
