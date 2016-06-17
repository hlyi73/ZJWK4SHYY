package com.takshine.wxcrm.model;

import org.apache.commons.lang3.StringUtils;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组审批
 * @author Administrator
 *
 */
public class DiscuGroupExamModel extends BaseModel {
	
	private String dis_id = null;
	private String apply_user_id = null;
	private String apply_user_name = null;
	private String apply_user_card_name = null;
	private String apply_user_company = null;
	private String apply_user_position = null;
	private String apply_user_phone = null;
	private String apply_time = null;
	private String rela_id = null;
	private String rela_name = null;
	private String rela_type = null;
	private String event_type = null;
	private String exam_user_id = null;
	private String exam_user_name = null;
	private String exam_user_card_name = null;
	private String exam_time = null;
	private String exam_result = null;
	private String exam_content = null;
	
	public String getDis_id() {
		return dis_id;
	}
	public void setDis_id(String dis_id) {
		this.dis_id = dis_id;
	}
	public String getApply_user_id() {
		return apply_user_id;
	}
	public void setApply_user_id(String apply_user_id) {
		this.apply_user_id = apply_user_id;
	}
	public String getApply_time() {
		return apply_time;
	}
	public void setApply_time(String apply_time) {
		this.apply_time = apply_time;
	}
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
	public String getEvent_type() {
		return event_type;
	}
	public void setEvent_type(String event_type) {
		this.event_type = event_type;
	}
	public String getExam_time() {
		return exam_time;
	}
	public void setExam_time(String exam_time) {
		this.exam_time = exam_time;
	}
	public String getExam_result() {
		return exam_result;
	}
	public void setExam_result(String exam_result) {
		this.exam_result = exam_result;
	}
	public String getExam_content() {
		return exam_content;
	}
	public void setExam_content(String exam_content) {
		this.exam_content = exam_content;
	}
	public String getExam_user_id() {
		return exam_user_id;
	}
	public void setExam_user_id(String exam_user_id) {
		this.exam_user_id = exam_user_id;
	}
	public String getApply_user_name() {
		return apply_user_name;
	}
	public void setApply_user_name(String apply_user_name) {
		if(StringUtils.isNotBlank(this.apply_user_card_name)){
			this.apply_user_name = this.apply_user_card_name;
		}else{
			this.apply_user_name = apply_user_name;
		}
	}
	public String getExam_user_name() {
		return exam_user_name;
	}
	public void setExam_user_name(String exam_user_name) {
		this.exam_user_name = exam_user_name;
	}
	public String getApply_user_card_name() {
		return apply_user_card_name;
	}
	public void setApply_user_card_name(String apply_user_card_name) {
		this.apply_user_card_name = apply_user_card_name;
	}
	public String getExam_user_card_name() {
		return exam_user_card_name;
	}
	public void setExam_user_card_name(String exam_user_card_name) {
		this.exam_user_card_name = exam_user_card_name;
	}
	public String getRela_name() {
		return rela_name;
	}
	public void setRela_name(String rela_name) {
		this.rela_name = rela_name;
	}
	public String getApply_user_company() {
		return apply_user_company;
	}
	public void setApply_user_company(String apply_user_company) {
		this.apply_user_company = apply_user_company;
	}
	public String getApply_user_position() {
		return apply_user_position;
	}
	public void setApply_user_position(String apply_user_position) {
		this.apply_user_position = apply_user_position;
	}
	public String getApply_user_phone() {
		return apply_user_phone;
	}
	public void setApply_user_phone(String apply_user_phone) {
		this.apply_user_phone = apply_user_phone;
	}
}
