package com.takshine.wxcrm.model;

import org.apache.commons.lang3.StringUtils;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组话题消息
 * @author Administrator
 *
 */
public class DiscuGroupTopicMsgModel extends BaseModel {
	
	private String dis_id = null;
	private String topic_id = null;
	private String send_user_id = null;
	private String send_user_name = null;
	private String target_user_id = null;
	private String target_user_name = null;
	private String target_user_cardname = null;
	private String msg_type = null;
	private String content = null;
	private String create_time = null;
	private String send_u_img_url = null;
	private String target_u_img_url = null;
	
	public String getDis_id() {
		return dis_id;
	}
	public void setDis_id(String dis_id) {
		this.dis_id = dis_id;
	}
	public String getTopic_id() {
		return topic_id;
	}
	public void setTopic_id(String topic_id) {
		this.topic_id = topic_id;
	}
	public String getSend_user_id() {
		return send_user_id;
	}
	public void setSend_user_id(String send_user_id) {
		this.send_user_id = send_user_id;
	}
	public String getTarget_user_id() {
		return target_user_id;
	}
	public void setTarget_user_id(String target_user_id) {
		this.target_user_id = target_user_id;
	}
	public String getMsg_type() {
		return msg_type;
	}
	public void setMsg_type(String msg_type) {
		this.msg_type = msg_type;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getSend_u_img_url() {
		return send_u_img_url;
	}
	public void setSend_u_img_url(String send_u_img_url) {
		this.send_u_img_url = send_u_img_url;
	}
	public String getTarget_u_img_url() {
		return target_u_img_url;
	}
	public void setTarget_u_img_url(String target_u_img_url) {
		this.target_u_img_url = target_u_img_url;
	}
	public String getSend_user_name() {
		return send_user_name;
	}
	public void setSend_user_name(String send_user_name) {
		this.send_user_name = send_user_name;
	}
	public String getTarget_user_name() {
		if(StringUtils.isNotBlank(this.target_user_cardname)){
			return this.target_user_cardname;
		}
		return target_user_name;
	}
	public void setTarget_user_name(String target_user_name) {
		this.target_user_name = target_user_name;
	}
	public String getTarget_user_cardname() {
		return target_user_cardname;
	}
	public void setTarget_user_cardname(String target_user_cardname) {
		this.target_user_cardname = target_user_cardname;
	}
}
