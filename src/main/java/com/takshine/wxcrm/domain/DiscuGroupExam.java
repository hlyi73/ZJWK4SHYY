package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.DiscuGroupExamModel;

/**
 * 讨论组审批
 * @author Administrator
 *
 */
public class DiscuGroupExam extends DiscuGroupExamModel {
	//话题
	private String topic_id = null;
	private String topic_status = null;
	private String topic_imgurl = null;
	private String topic_addr = null;
	private String topic_startdate = null; //活动开始时间
	private String topic_sendname = null;  //名片中的名字
	private String topic_creatortitle = null; //群发者职位
	private String topic_orgname = null; //组织名称
	//头像
	private String cardimg = null; //名片中的头像
	private String headimgurl = null; //微信头像
	
	private String exam_user_flag = null; 
	private String exam_result_flag = null; 
	
	public String getTopic_status() {
		return topic_status;
	}
	public void setTopic_status(String topic_status) {
		this.topic_status = topic_status;
	}
	public String getTopic_imgurl() {
		return topic_imgurl;
	}
	public void setTopic_imgurl(String topic_imgurl) {
		this.topic_imgurl = topic_imgurl;
	}
	public String getTopic_addr() {
		return topic_addr;
	}
	public void setTopic_addr(String topic_addr) {
		this.topic_addr = topic_addr;
	}
	public String getTopic_startdate() {
		return topic_startdate;
	}
	public void setTopic_startdate(String topic_startdate) {
		this.topic_startdate = topic_startdate;
	}
	public String getTopic_sendname() {
		return topic_sendname;
	}
	public void setTopic_sendname(String topic_sendname) {
		this.topic_sendname = topic_sendname;
	}
	public String getTopic_creatortitle() {
		return topic_creatortitle;
	}
	public void setTopic_creatortitle(String topic_creatortitle) {
		this.topic_creatortitle = topic_creatortitle;
	}
	public String getTopic_orgname() {
		return topic_orgname;
	}
	public void setTopic_orgname(String topic_orgname) {
		this.topic_orgname = topic_orgname;
	}
	public String getCardimg() {
		return cardimg;
	}
	public void setCardimg(String cardimg) {
		this.cardimg = cardimg;
	}
	public String getHeadimgurl() {
		return headimgurl;
	}
	public void setHeadimgurl(String headimgurl) {
		this.headimgurl = headimgurl;
	}
	public String getTopic_id() {
		return topic_id;
	}
	public void setTopic_id(String topic_id) {
		this.topic_id = topic_id;
	}
	public String getExam_user_flag() {
		return exam_user_flag;
	}
	public void setExam_user_flag(String exam_user_flag) {
		this.exam_user_flag = exam_user_flag;
	}
	public String getExam_result_flag() {
		return exam_result_flag;
	}
	public void setExam_result_flag(String exam_result_flag) {
		this.exam_result_flag = exam_result_flag;
	}
}
