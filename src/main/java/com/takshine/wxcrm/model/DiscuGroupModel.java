package com.takshine.wxcrm.model;

import org.apache.commons.lang3.StringUtils;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 讨论组
 * @author Administrator
 *
 */
public class DiscuGroupModel extends BaseModel {
	
	private String name = null;
	private String enabled_flag = null;//启用标志
	private String joinin_flag = null;//加入验证标志
	private String msg_group_flag = null;//信息群发消息标志
	private String create_time = null;//创建时间
	private String creator = null;//创建人
	private String modify_time = null;//修改时间
	private String modifier = null;//修改人
	private String img_url = null;//图片地址
	private String weight = null;//人工权重
	
	public String getName() {
		if(StringUtils.isNotBlank(this.name) && this.name.length() > 15){
			return this.name.substring(0,15) + "...";
		}
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEnabled_flag() {
		return enabled_flag;
	}
	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}
	public String getJoinin_flag() {
		return joinin_flag;
	}
	public void setJoinin_flag(String joinin_flag) {
		this.joinin_flag = joinin_flag;
	}
	public String getMsg_group_flag() {
		return msg_group_flag;
	}
	public void setMsg_group_flag(String msg_group_flag) {
		this.msg_group_flag = msg_group_flag;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getModify_time() {
		return modify_time;
	}
	public void setModify_time(String modify_time) {
		this.modify_time = modify_time;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public String getImg_url() {
		return img_url;
	}
	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
}
