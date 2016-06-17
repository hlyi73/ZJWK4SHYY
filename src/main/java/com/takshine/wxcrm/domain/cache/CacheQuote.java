package com.takshine.wxcrm.domain.cache;

/**
 * 报价
 * 
 * @author Administrator
 *
 */
public class CacheQuote extends CacheBase {
	private String status = null;
	private String assigner_id = null;
	private String assigner_name = null;
	private String quotedate = null;
	private String amount = null;
	
	private String start_date = null;
	private String end_date = null;
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getAssigner_id() {
		return assigner_id;
	}
	public void setAssigner_id(String assigner_id) {
		this.assigner_id = assigner_id;
	}
	public String getAssigner_name() {
		return assigner_name;
	}
	public void setAssigner_name(String assigner_name) {
		this.assigner_name = assigner_name;
	}
	public String getQuotedate() {
		return quotedate;
	}
	public void setQuotedate(String quotedate) {
		this.quotedate = quotedate;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
}
