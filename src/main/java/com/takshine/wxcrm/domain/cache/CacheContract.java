package com.takshine.wxcrm.domain.cache;

/**
 * 联系人
 * @author Administrator
 *
 */
public class CacheContract extends CacheBase {
	
	private String start_date = null;
	private String end_date = null;
	private String cost = null;
	private String recived_amount = null;
	private String status = null;
	private String assigner_id = null;
	private String assigner_name = null;
	
	public CacheContract transf(){
		CacheContract c = new CacheContract();
		return c;
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

	public String getCost() {
		return cost;
	}

	public void setCost(String cost) {
		this.cost = cost;
	}

	public String getRecived_amount() {
		return recived_amount;
	}

	public void setRecived_amount(String recived_amount) {
		this.recived_amount = recived_amount;
	}

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
}
