package com.takshine.wxcrm.message.sugar;

/**
 * 合同下关联的付款方式
 * 
 * @author dengbo
 *
 */
public class PaymentMethod extends BaseCrm{
	
	private String rowid;// 付款方式id
	private String name;// 付款方式摘要
	private String amount;// 付款金额
	private String paymentDesc;// 付款描述
	private String assignerid_pays;//责任人Id
	private String contractid;//合同Id

	public String getContractid() {
		return contractid;
	}

	public void setContractid(String contractid) {
		this.contractid = contractid;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getPaymentDesc() {
		return paymentDesc;
	}

	public void setPaymentDesc(String paymentDesc) {
		this.paymentDesc = paymentDesc;
	}

	public String getAssignerid_pays() {
		return assignerid_pays;
	}

	public void setAssignerid_pays(String assignerid_pays) {
		this.assignerid_pays = assignerid_pays;
	}
}
