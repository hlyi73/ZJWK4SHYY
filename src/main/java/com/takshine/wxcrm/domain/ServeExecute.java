package com.takshine.wxcrm.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * 服务执行
 * @author liulin
 *
 */
public class ServeExecute extends BaseDtm{
	//part01
	private String start_date;//服务开始时间
	private String end_date;//服务结束时间
	private String assigned_user_id;//服务人员
	private String assigned_user_name;//服务人员
	private String certificate_no;//上岗证号
	private String fault_desc;//故障描述
	private String process_desc;//处置说明
	private String is_callback;//回执单是否收回
	private String service_num;//产业单位服务编号
	private String parentid;//服务请求
	private String parentname;//服务请求
	private String parenttype;//服务请求
	
	private ServeVisit visit = null; //服务回访

	//part02
	private List<ServeExecute> execs = new ArrayList<ServeExecute>();//查询时候返回的集合列表

	
	public ServeVisit getVisit() {
		return visit;
	}

	public void setVisit(ServeVisit visit) {
		this.visit = visit;
	}

	public String getAssigned_user_name() {
		return assigned_user_name;
	}

	public void setAssigned_user_name(String assigned_user_name) {
		this.assigned_user_name = assigned_user_name;
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

	public String getAssigned_user_id() {
		return assigned_user_id;
	}

	public void setAssigned_user_id(String assigned_user_id) {
		this.assigned_user_id = assigned_user_id;
	}

	public String getCertificate_no() {
		return certificate_no;
	}

	public void setCertificate_no(String certificate_no) {
		this.certificate_no = certificate_no;
	}

	public String getFault_desc() {
		return fault_desc;
	}

	public void setFault_desc(String fault_desc) {
		this.fault_desc = fault_desc;
	}

	public String getProcess_desc() {
		return process_desc;
	}

	public void setProcess_desc(String process_desc) {
		this.process_desc = process_desc;
	}

	public String getIs_callback() {
		return is_callback;
	}

	public void setIs_callback(String is_callback) {
		this.is_callback = is_callback;
	}

	public String getService_num() {
		return service_num;
	}

	public void setService_num(String service_num) {
		this.service_num = service_num;
	}

	public String getParentid() {
		return parentid;
	}

	public void setParentid(String parentid) {
		this.parentid = parentid;
	}

	public String getParentname() {
		return parentname;
	}

	public void setParentname(String parentname) {
		this.parentname = parentname;
	}

	public List<ServeExecute> getExecs() {
		return execs;
	}

	public void setExecs(List<ServeExecute> execs) {
		this.execs = execs;
	}

	public String getParenttype() {
		return parenttype;
	}

	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
}
