package com.takshine.marketing.domain;

import java.util.ArrayList;
import java.util.List;

import com.takshine.marketing.model.Activity_RelaModel;
import com.takshine.wxcrm.model.ActivityModel;

/**
 * 活动关联
 * @author dengbo
 *
 */
public class Activity_Rela extends Activity_RelaModel {
	
	private String id;//主键
	private String rela_id;//关联ID
	private String rela_type;//关联类型
	private String rela_name;//关联名字
	private String activity_id;//活动ID
	private String create_time;//创建时间
	private String create_by;//创建者
	private String org_id;//关联实体所属ORG
	private String rela_user_phone;//关联电话号码
	
	public String getRela_user_phone() {
		return rela_user_phone;
	}
	public void setRela_user_phone(String rela_user_phone) {
		this.rela_user_phone = rela_user_phone;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getActivity_id() {
		return activity_id;
	}
	public void setActivity_id(String activity_id) {
		this.activity_id = activity_id;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getOrg_id() {
		return org_id;
	}
	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}
	
	
}
