package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 工作计划与任务关联表
 * @author dengbo
 *
 */
public class WorkReportRelaTask extends BaseModel{
	
	private String rela_id;//关联ID
	private String rela_type;//任务：schedule
	private String workreport_id;//工作计划ID
	private String create_time;//创建时间
	private String creator;//创建者
	
	public String getRela_id() {
		return rela_id;
	}
	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}
	public String getRela_type() {
		return rela_type;
	}
	public void setRela_type(String rela_type) {
		this.rela_type = rela_type;
	}
	public String getWorkreport_id() {
		return workreport_id;
	}
	public void setWorkreport_id(String workreport_id) {
		this.workreport_id = workreport_id;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	
	
}
