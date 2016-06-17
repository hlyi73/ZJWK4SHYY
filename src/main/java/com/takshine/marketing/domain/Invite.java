package com.takshine.marketing.domain;

import com.takshine.marketing.model.InviteModel;

/**
 * 邀请表(实体类)
 * @author dengbo
 *
 */
public class Invite extends InviteModel {
	
	private String id;//主键
	private String batch_number;//批次号
	private String rela_id;//关联ID
	private String rela_type;//关联类型
	private String rela_name;//关联名称
	private String send_type;//发送类型--sms,email,wx
	private String send_status;//发送状态 -- sms_send_ok,sms_send_fail,wx_send_ok,email_send_ok,emai_send_fail,email_open,email_refuse...
	private String received_userid;//接收人ID
	private String received_openid;//接收人OPEN ID
	private String received_phone;//接收人电话
	private String received_email;//接收人邮箱
	private String received_username;//接收人称
	private String create_by;//发起人
	private String create_time;//发起时间
	private String org_id;//组织
	private String crm_id;//后台Sugar Id
	private String received_parentid;//接受者的父Id
	private String received_parentname;//接受者的父名称
	private String num_msg;
	private String friend;
	
	public String getFriend() {
		return friend;
	}
	public void setFriend(String friend) {
		this.friend = friend;
	}
	public String getNum_msg() {
		return num_msg;
	}
	public void setNum_msg(String num_msg) {
		this.num_msg = num_msg;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBatch_number() {
		return batch_number;
	}
	public void setBatch_number(String batch_number) {
		this.batch_number = batch_number;
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
	public String getRela_name() {
		return rela_name;
	}
	public void setRela_name(String rela_name) {
		this.rela_name = rela_name;
	}
	public String getSend_type() {
		return send_type;
	}
	public void setSend_type(String send_type) {
		this.send_type = send_type;
	}
	public String getSend_status() {
		return send_status;
	}
	public void setSend_status(String send_status) {
		this.send_status = send_status;
	}
	public String getReceived_userid() {
		return received_userid;
	}
	public void setReceived_userid(String received_userid) {
		this.received_userid = received_userid;
	}
	public String getReceived_openid() {
		return received_openid;
	}
	public void setReceived_openid(String received_openid) {
		this.received_openid = received_openid;
	}
	public String getReceived_phone() {
		return received_phone;
	}
	public void setReceived_phone(String received_phone) {
		this.received_phone = received_phone;
	}
	public String getReceived_email() {
		return received_email;
	}
	public void setReceived_email(String received_email) {
		this.received_email = received_email;
	}
	public String getReceived_username() {
		return received_username;
	}
	public void setReceived_username(String received_username) {
		this.received_username = received_username;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getOrg_id() {
		return org_id;
	}
	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}
	public String getCrm_id() {
		return crm_id;
	}
	public void setCrm_id(String crm_id) {
		this.crm_id = crm_id;
	}
	public String getReceived_parentid() {
		return received_parentid;
	}
	public void setReceived_parentid(String received_parentid) {
		this.received_parentid = received_parentid;
	}
	public String getReceived_parentname() {
		return received_parentname;
	}
	public void setReceived_parentname(String received_parentname) {
		this.received_parentname = received_parentname;
	}
}
