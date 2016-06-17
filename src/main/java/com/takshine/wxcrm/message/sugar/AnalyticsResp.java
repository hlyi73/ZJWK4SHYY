package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询报表接口 从crm响应回来的参数
 *
 */
public class AnalyticsResp extends BaseCrm {
	private List<AnalyticsExpenseResp> expense = new ArrayList<AnalyticsExpenseResp>();// 费用列表
	private List<AnalyticsOpptyResp> opptyList = new ArrayList<AnalyticsOpptyResp>();// 业务机会列表
	private List<AnalyticsReceivableResp> receList = new ArrayList<AnalyticsReceivableResp>();// 回款列表
	private List<AnalyticsCustomeryResp> customerList = new ArrayList<AnalyticsCustomeryResp>();// 客户列表列表
	private List<AnalyticsContactResp> contactList = new ArrayList<AnalyticsContactResp>(); //联系人列表
	private List<AnalyticsQuotaResp> quotas = new ArrayList<AnalyticsQuotaResp>();// 目标列表
	private List<AnalyticsComplaintResp> complaints = new ArrayList<AnalyticsComplaintResp>();//服务请求列表
	private String count = null;

	public List<AnalyticsQuotaResp> getQuotas() {
		return quotas;
	}

	public void setQuotas(List<AnalyticsQuotaResp> quotas) {
		this.quotas = quotas;
	}

	public List<AnalyticsCustomeryResp> getCustomerList() {
		return customerList;
	}
	
	public List<AnalyticsContactResp> getContactList() {
		return contactList;
	}

	public void setCustomerList(List<AnalyticsCustomeryResp> customerList) {
		this.customerList = customerList;
	}
	
	public void setContactList(List<AnalyticsContactResp> contactList) {
		this.contactList = contactList;
	}

	public List<AnalyticsExpenseResp> getExpense() {
		return expense;
	}

	public void setExpense(List<AnalyticsExpenseResp> expense) {
		this.expense = expense;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public List<AnalyticsOpptyResp> getOpptyList() {
		return opptyList;
	}

	public List<AnalyticsReceivableResp> getReceList() {
		return receList;
	}

	public void setReceList(List<AnalyticsReceivableResp> receList) {
		this.receList = receList;
	}

	public void setOpptyList(List<AnalyticsOpptyResp> opptyList) {
		this.opptyList = opptyList;
	}

	public List<AnalyticsComplaintResp> getComplaints() {
		return complaints;
	}

	public void setComplaints(List<AnalyticsComplaintResp> complaints) {
		this.complaints = complaints;
	}

}
