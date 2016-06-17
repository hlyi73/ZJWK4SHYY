package com.takshine.wxcrm.domain.cache;

/**
 * 联系人前端缓存
 * 
 * @author Administrator
 *
 */
public class CacheExpense extends CacheBase{
	
	private String expense_type;
	private String expense_type_name;
	private String expense_subtype;
	private String expense_subtype_name;
	private String parent_id;
	private String parent_type;
	private String parent_name;
	private String expense_status;
	private String expense_status_name;
	private String expense_date;
	private float expense_amount;
	public String getExpense_type() {
		return expense_type;
	}
	public void setExpense_type(String expense_type) {
		this.expense_type = expense_type;
	}
	public String getExpense_subtype() {
		return expense_subtype;
	}
	public void setExpense_subtype(String expense_subtype) {
		this.expense_subtype = expense_subtype;
	}
	public String getParent_id() {
		return parent_id;
	}
	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}
	public String getParent_type() {
		return parent_type;
	}
	public void setParent_type(String parent_type) {
		this.parent_type = parent_type;
	}
	public String getExpense_status() {
		return expense_status;
	}
	public void setExpense_status(String expense_status) {
		this.expense_status = expense_status;
	}
	public String getExpense_date() {
		return expense_date;
	}
	public void setExpense_date(String expense_date) {
		this.expense_date = expense_date;
	}
	public String getExpense_type_name() {
		return expense_type_name;
	}
	public void setExpense_type_name(String expense_type_name) {
		this.expense_type_name = expense_type_name;
	}
	public String getExpense_subtype_name() {
		return expense_subtype_name;
	}
	public void setExpense_subtype_name(String expense_subtype_name) {
		this.expense_subtype_name = expense_subtype_name;
	}
	public String getExpense_status_name() {
		return expense_status_name;
	}
	public void setExpense_status_name(String expense_status_name) {
		this.expense_status_name = expense_status_name;
	}
	public float getExpense_amount() {
		return expense_amount;
	}
	public void setExpense_amount(float expense_amount) {
		this.expense_amount = expense_amount;
	}
	public String getParent_name() {
		return parent_name;
	}
	public void setParent_name(String parent_name) {
		this.parent_name = parent_name;
	}
	
	
}
