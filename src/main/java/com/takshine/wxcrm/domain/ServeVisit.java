package com.takshine.wxcrm.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * 服务回访
 * @author liulin
 *
 */
public class ServeVisit extends BaseDtm{
	//part01
	private String parenttype;//父类型
	private String parentid;//服务请求
	private String parentname;//服务请求
	private String serve_execute_id;//服务执行
	private String serve_execute_name;//服务执行
	private String assigned_user_id;//服务人员
	private String assigned_user_name;//服务人员
	private String certificate_no;//上岗证号
	private String visit_date;//回访日期
	private String track_desc;//跟踪记录
	private String finish_desc;//回访记录
	private String created_by;//回访人
	private String visit_status;//回访状态
	private String timely;//及时性
	private String service_attitude;//服务态度
	private String work_effect;//工作效率
	private String wear_card;//佩戴胸牌
	private String leave_that;//离开告知
	private String leave_question;//遗留问题
	private String question_desc;//问题描述
	private String account_suggest;//客户建议
	private String question_handle;//问题处理
	private String finish_effect;//完成情况
	private String handle_desc;//处理情况

	//part02
	private List<ServeVisit> visits = new ArrayList<ServeVisit>();//查询时候返回的集合列表

	public String getFinish_effect() {
		return finish_effect;
	}

	public void setFinish_effect(String finish_effect) {
		this.finish_effect = finish_effect;
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

	public String getAssigned_user_name() {
		return assigned_user_name;
	}

	public void setAssigned_user_name(String assigned_user_name) {
		this.assigned_user_name = assigned_user_name;
	}

	public String getServe_execute_id() {
		return serve_execute_id;
	}

	public void setServe_execute_id(String serve_execute_id) {
		this.serve_execute_id = serve_execute_id;
	}

	public String getServe_execute_name() {
		return serve_execute_name;
	}

	public void setServe_execute_name(String serve_execute_name) {
		this.serve_execute_name = serve_execute_name;
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

	public String getVisit_date() {
		return visit_date;
	}

	public void setVisit_date(String visit_date) {
		this.visit_date = visit_date;
	}

	public String getFinish_desc() {
		return finish_desc;
	}

	public void setFinish_desc(String finish_desc) {
		this.finish_desc = finish_desc;
	}

	public String getCreated_by() {
		return created_by;
	}

	public void setCreated_by(String created_by) {
		this.created_by = created_by;
	}

	public String getTimely() {
		return timely;
	}

	public void setTimely(String timely) {
		this.timely = timely;
	}

	public String getService_attitude() {
		return service_attitude;
	}

	public void setService_attitude(String service_attitude) {
		this.service_attitude = service_attitude;
	}

	public String getWork_effect() {
		return work_effect;
	}

	public void setWork_effect(String work_effect) {
		this.work_effect = work_effect;
	}

	public String getWear_card() {
		return wear_card;
	}

	public void setWear_card(String wear_card) {
		this.wear_card = wear_card;
	}

	public String getLeave_that() {
		return leave_that;
	}

	public void setLeave_that(String leave_that) {
		this.leave_that = leave_that;
	}

	public String getLeave_question() {
		return leave_question;
	}

	public void setLeave_question(String leave_question) {
		this.leave_question = leave_question;
	}

	public String getQuestion_desc() {
		return question_desc;
	}

	public void setQuestion_desc(String question_desc) {
		this.question_desc = question_desc;
	}

	public String getAccount_suggest() {
		return account_suggest;
	}

	public void setAccount_suggest(String account_suggest) {
		this.account_suggest = account_suggest;
	}

	public String getQuestion_handle() {
		return question_handle;
	}

	public void setQuestion_handle(String question_handle) {
		this.question_handle = question_handle;
	}

	public String getHandle_desc() {
		return handle_desc;
	}

	public void setHandle_desc(String handle_desc) {
		this.handle_desc = handle_desc;
	}

	public List<ServeVisit> getVisits() {
		return visits;
	}

	public void setVisits(List<ServeVisit> visits) {
		this.visits = visits;
	}

	public String getParenttype() {
		return parenttype;
	}

	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	
	public String getTrack_desc() {
		return track_desc;
	}

	public void setTrack_desc(String track_desc) {
		this.track_desc = track_desc;
	}

	public String getVisit_status() {
		return visit_status;
	}

	public void setVisit_status(String visit_status) {
		this.visit_status = visit_status;
	}
	
	
}
