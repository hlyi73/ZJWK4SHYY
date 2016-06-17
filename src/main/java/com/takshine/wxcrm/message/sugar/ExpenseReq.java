package com.takshine.wxcrm.message.sugar;


/**
 * 传递给crm 费用报销 请求 参数
 * @author 刘淋
 *
 */
public class ExpenseReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private String expensedate;
	private String depart;
	private String approval;
	private String expensesubtype;
	private String assignerId;
	private String expensesubtypename;
	private String startDate;
	private String endDate;
	private String expensetype;
	private String parentid;
	private String parenttype;
	
	private String original;//查询原始报销数据
	private String rowid;
	
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getOriginal() {
		return original;
	}
	public void setOriginal(String original) {
		this.original = original;
	}
	public String getAssignerId() {
		return assignerId;
	}
	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getCurrpage() {
		return currpage;
	}
	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}
	public String getPagecount() {
		return pagecount;
	}
	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}
	public String getExpensedate() {
		return expensedate;
	}
	public void setExpensedate(String expensedate) {
		this.expensedate = expensedate;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getApproval() {
		return approval;
	}
	public void setApproval(String approval) {
		this.approval = approval;
	}
	public String getExpensesubtype() {
		return expensesubtype;
	}
	public void setExpensesubtype(String expensesubtype) {
		this.expensesubtype = expensesubtype;
	}
	public String getExpensesubtypename() {
		return expensesubtypename;
	}
	public void setExpensesubtypename(String expensesubtypename) {
		this.expensesubtypename = expensesubtypename;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getExpensetype() {
		return expensetype;
	}
	public void setExpensetype(String expensetype) {
		this.expensetype = expensetype;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	
}
