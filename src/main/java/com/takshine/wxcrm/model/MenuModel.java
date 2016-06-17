package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 菜单
 * @author liulin
 *
 */
public class MenuModel extends BaseModel{
	
	private String menu_id = null;
	private String menu_name = null;
	private String menu_image = null;
	private String menu_link = null;
	private String menu_type = null;
	private String menu_level = null;
	private String menu_sort = null;
	private String menu_parentid = null;
	private String enabled_flag = null;
	
	public String getMenu_id() {
		return menu_id;
	}
	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public String getMenu_image() {
		return menu_image;
	}
	public void setMenu_image(String menu_image) {
		this.menu_image = menu_image;
	}
	public String getMenu_link() {
		return menu_link;
	}
	public void setMenu_link(String menu_link) {
		this.menu_link = menu_link;
	}
	public String getMenu_type() {
		return menu_type;
	}
	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}
	public String getMenu_sort() {
		return menu_sort;
	}
	public void setMenu_sort(String menu_sort) {
		this.menu_sort = menu_sort;
	}
	public String getMenu_level() {
		return menu_level;
	}
	public void setMenu_level(String menu_level) {
		this.menu_level = menu_level;
	}
	public String getEnabled_flag() {
		return enabled_flag;
	}
	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}
	public String getMenu_parentid() {
		return menu_parentid;
	}
	public void setMenu_parentid(String menu_parentid) {
		this.menu_parentid = menu_parentid;
	}
}
