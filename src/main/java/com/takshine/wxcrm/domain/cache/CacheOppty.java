package com.takshine.wxcrm.domain.cache;

/**
 * 商机
 * @author Administrator
 *
 */
public class CacheOppty extends CacheBase {
	
	private String amount = null;
	private String stage = null;
	private String close_date = null;
	private String probability = null;
	private String assigner_id = null;
	private String assigner_name = null;
	private String customer_id = null;//客户ID
	private String customer_name = null;//客户名字
	private String account_id=null;
	private String start_date = null;//开始时间
	private String end_date = null;//结束时间
	private String starflag = null ; 
	private String tagName = null ; 
	
	public CacheOppty transf(){
		CacheOppty c = new CacheOppty();
		return c;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public String getClose_date() {
		return close_date;
	}

	public void setClose_date(String close_date) {
		this.close_date = close_date;
	}

	public String getProbability() {
		return probability;
	}

	public void setProbability(String probability) {
		this.probability = probability;
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

	public String getAccount_id() {
		return account_id;
	}

	public void setAccount_id(String account_id) {
		this.account_id = account_id;
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

	public String getStarflag() {
		return starflag;
	}

	public void setStarflag(String starflag) {
		this.starflag = starflag;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getCustomer_id() {
		return customer_id;
	}

	public void setCustomer_id(String customer_id) {
		this.customer_id = customer_id;
	}

	public String getCustomer_name() {
		return customer_name;
	}

	public void setCustomer_name(String customer_name) {
		this.customer_name = customer_name;
	}
	
}
