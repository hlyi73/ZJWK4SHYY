package com.takshine.wxcrm.domain;

import org.apache.commons.lang.StringUtils;

import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.model.DiscuGroupModel;

/**
 * 讨论组
 * @author Administrator
 *
 */

public class DiscuGroup extends DiscuGroupModel{
	
	private String address = null;
	private String distags = null;
	private String creator_name = null;
	private String card_name = null;
	private String dis_user_count = null;//用户数
	private String dis_topic_count = null;//话题数
	private String head_img_url = null;
	private String wx_img_url = null;
	
	
	public String getHead_img_url() {
		if(StringUtils.isNotBlank(head_img_url)){
			return "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/"+head_img_url;
		}
		return head_img_url;
	}
	public void setHead_img_url(String head_img_url) {
		this.head_img_url = head_img_url;
	}
	public String getCard_name() {
		return card_name;
	}
	public void setCard_name(String card_name) {
		this.card_name = card_name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getDistags() {
		return distags;
	}
	public void setDistags(String distags) {
		this.distags = distags;
	}
	public String getCreator_name() {
		if(StringUtils.isNotBlank(card_name)){
			return card_name;
		}
		return creator_name;
	}
	public void setCreator_name(String creator_name) {
		this.creator_name = creator_name;
	}
	public String getDis_user_count() {
		return dis_user_count;
	}
	public void setDis_user_count(String dis_user_count) {
		this.dis_user_count = dis_user_count;
	}
	public String getDis_topic_count() {
		return dis_topic_count;
	}
	public void setDis_topic_count(String dis_topic_count) {
		this.dis_topic_count = dis_topic_count;
	}
	public String getWx_img_url() {
		if(StringUtils.isNotBlank(this.head_img_url)){
			return "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/"+head_img_url;
		}
		return wx_img_url;
	}
	public void setWx_img_url(String wx_img_url) {
		this.wx_img_url = wx_img_url;
	}
	
}
