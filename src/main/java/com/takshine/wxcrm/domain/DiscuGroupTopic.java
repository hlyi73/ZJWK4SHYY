package com.takshine.wxcrm.domain;

import org.apache.commons.lang3.StringUtils;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组 话题
 * @author zhihe
 *
 */

public class DiscuGroupTopic extends BaseModel{
	
	private static final long serialVersionUID = 1L;
	private String dis_id = null;
	private String topic_id = null;
	private String topic_name = null;
	private String topic_type = null;//文章 article   活动 activity  调查 survey 互助 help  文本 text
	private String ess_flag = null;
	private String create_time = null;
	private String creator = null;
	private String creator_name = null;
	private String topic_status = null;
	private String topic_imgurl = null;
	private String topic_addr = null;
	private String topic_startdate = null; //活动开始时间
	private String topic_sendname = null;  //名片中的名字
	private String topic_creatortitle = null; //群发者职位
	private String topic_orgname = null; //组织名称
	private String cardimg = null; //名片中的头像
	private String headimgurl = null; //微信头像
	private String content = null; //文本 text 对应的内容
	private String subcontent = null; //文本 text 对应的内容
	private String order_create_time = null;//排序用字段
	
	public String getOrder_create_time() {
		return order_create_time;
	}
	public void setOrder_create_time(String order_create_time) {
		this.order_create_time = order_create_time;
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
	public String getTopic_orgname() {
		return topic_orgname;
	}
	public void setTopic_orgname(String topic_orgname) {
		this.topic_orgname = topic_orgname;
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
	public String getTopic_startdate() {
		return topic_startdate;
	}
	public void setTopic_startdate(String topic_startdate) {
		this.topic_startdate = topic_startdate;
	}
	public String getTopic_addr() {
		return topic_addr;
	}
	public void setTopic_addr(String topic_addr) {
		this.topic_addr = topic_addr;
	}
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
	public String getTopic_type() {
		return topic_type;
	}
	public void setTopic_type(String topic_type) {
		this.topic_type = topic_type;
	}
	public String getEss_flag() {
		return ess_flag;
	}
	public void setEss_flag(String ess_flag) {
		this.ess_flag = ess_flag;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getTopic_name() {
		return topic_name;
	}
	public void setTopic_name(String topic_name) {
		this.topic_name = topic_name;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreator_name() {
		if(StringUtils.isNotBlank(this.topic_sendname)){
			return this.topic_sendname;
		}
		return creator_name;
	}
	public void setCreator_name(String creator_name) {
		this.creator_name = creator_name;
	}
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
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
		if(StringUtils.isNotBlank(content) && content.length() > 30){
			this.subcontent = content.substring(0, 30);
		}else{
			this.subcontent = "";
		}
	}
	public String getSubcontent() {
		return subcontent;
	}
	public void setSubcontent(String subcontent) {
		this.subcontent = subcontent;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
