package com.takshine.wxcrm.domain;

import org.apache.commons.lang.StringUtils;

import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.model.DiscuGroupUserModel;

/**
 * 讨论组 用户
 * @author Administrator
 *
 */

public class DiscuGroupUser extends DiscuGroupUserModel{
	
	private String user_company = null;
	private String user_position = null;
	private String user_phone = null;
	private String user_rela_id = null;
	private String curr_user_id = null;
	private String party_row_id = null;
	private String head_img_url = null;
	
	public String getHead_img_url() {
		if(StringUtils.isNotBlank(head_img_url) && head_img_url.indexOf("http://") == -1){
			return "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/"+head_img_url;
		}
		return head_img_url;
	}
	public void setHead_img_url(String head_img_url) {
		this.head_img_url = head_img_url;
	}
	public String getUser_company() {
		return user_company;
	}
	public void setUser_company(String user_company) {
		this.user_company = user_company;
	}
	public String getUser_position() {
		return user_position;
	}
	public void setUser_position(String user_position) {
		this.user_position = user_position;
	}
	public String getUser_phone() {
		return user_phone;
	}
	public void setUser_phone(String user_phone) {
		this.user_phone = user_phone;
	}
	public String getUser_rela_id() {
		return user_rela_id;
	}
	public void setUser_rela_id(String user_rela_id) {
		this.user_rela_id = user_rela_id;
	}
	public String getCurr_user_id() {
		return curr_user_id;
	}
	public void setCurr_user_id(String curr_user_id) {
		this.curr_user_id = curr_user_id;
	}
	public String getParty_row_id() {
		return party_row_id;
	}
	public void setParty_row_id(String party_row_id) {
		this.party_row_id = party_row_id;
	}
	
}
