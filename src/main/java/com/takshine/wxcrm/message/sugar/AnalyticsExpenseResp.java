package com.takshine.wxcrm.message.sugar;


/**
 * 查询费用报表接口 从crm响应回来的参数
 *
 */
public class AnalyticsExpenseResp extends BaseCrm{
	private String expenseDate;
	private String expenseAmount;
	private String department;
	private String expenseSubType;
	private String expenseType;
	
	public String getExpenseDate() {
		return expenseDate;
	}
	public void setExpenseDate(String expenseDate) {
		this.expenseDate = expenseDate;
	}
	public String getExpenseAmount() {
		return expenseAmount;
	}
	public void setExpenseAmount(String expenseAmount) {
		this.expenseAmount = expenseAmount;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getExpenseSubType() {
		return expenseSubType;
	}
	public void setExpenseSubType(String expenseSubType) {
		this.expenseSubType = expenseSubType;
	}
	public String getExpenseType() {
		return expenseType;
	}
	public void setExpenseType(String expenseType) {
		this.expenseType = expenseType;
	}
	
}
