package com.takshine.wxcrm.domain.cache;

import java.util.List;

/**
 * 日程
 * @author Administrator
 *
 */
public class CacheSchedule extends CacheBase {
	
	private String assinger_id = null;
	private String assinger_name = null;
	private String start_date = null;
	private String status = null;
	private String rela_id = null;
	private String rela_name = null;
	private String rela_type = null;
	private String sche_type = null;
	private String end_date=null;
	private List<String> status_in = null;
	
	
	public List<String> getStatus_in() {
		return status_in;
	}

	public void setStatus_in(List<String> status_in) {
		this.status_in = status_in;
	}

	public String getEnd_date() {
		return end_date;
	}

	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}

	private String assigner_id = null;
	private String assigner_name = null;
	private String ispublic;
	public String getIspublic() {
		return ispublic;
	}

	public void setIspublic(String ispublic) {
		this.ispublic = ispublic;
	}

	public CacheSchedule transf(){
		CacheSchedule c = new CacheSchedule();
		return c;
	}

	public String getAssinger_id() {
		return assinger_id;
	}

	public void setAssinger_id(String assinger_id) {
		this.assinger_id = assinger_id;
	}

	public String getAssinger_name() {
		return assinger_name;
	}

	public void setAssinger_name(String assinger_name) {
		this.assinger_name = assinger_name;
	}

	public String getStart_date() {
		return start_date;
	}

	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRela_id() {
		return rela_id;
	}

	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}

	public String getRela_name() {
		return rela_name;
	}

	public void setRela_name(String rela_name) {
		this.rela_name = rela_name;
	}

	public String getRela_type() {
		return rela_type;
	}

	public void setRela_type(String rela_type) {
		this.rela_type = rela_type;
	}

	public String getSche_type() {
		return sche_type;
	}

	public void setSche_type(String sche_type) {
		this.sche_type = sche_type;
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
