package com.takshine.wxcrm.domain.cache;

import java.util.List;

/**
 * 联系人前端缓存
 * 
 * @author Administrator
 *
 */
public class CacheBase {
	//part01
	private String name = null;
	private String crm_id = null;
	private String open_id = null;
	private String rowid = null;
	private String org_id = null;
	private String create_date = null;
	private String create_by = null;
	private String modify_date = null;
	private String modify_by = null;
	private String enabled_flag = null;
	//part02
	private Integer currpage = 0;
	private Integer pagecount = 10;
	//part03
	private List<String> crm_id_in = null;
	private List<String> rowid_in = null;
	private String crm_id_notin = null;
	//part04
	private String viewtype;//查询的类型
	private String orderByString;//查询条件
	private String orderByStringSec;//排序条件
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCrm_id() {
		return crm_id;
	}

	public void setCrm_id(String crm_id) {
		this.crm_id = crm_id;
	}

	public String getOpen_id() {
		return open_id;
	}

	public void setOpen_id(String open_id) {
		this.open_id = open_id;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getOrg_id() {
		return org_id;
	}

	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public String getModify_date() {
		return modify_date;
	}

	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}

	public String getModify_by() {
		return modify_by;
	}

	public void setModify_by(String modify_by) {
		this.modify_by = modify_by;
	}
	
	public String getEnabled_flag() {
		if(null == enabled_flag || "".equals(enabled_flag)){
			return "enabled";
		}
		return enabled_flag;
	}

	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}

	public Integer getCurrpage() {
		return currpage;
	}

	public void setCurrpage(Integer currpage) {
		this.currpage = currpage;
	}

	public Integer getPagecount() {
		return pagecount;
	}

	public void setPagecount(Integer pagecount) {
		this.pagecount = pagecount;
	}

	public List<String> getCrm_id_in() {
		return crm_id_in;
	}

	public void setCrm_id_in(List<String> crm_id_in) {
		this.crm_id_in = crm_id_in;
	}

	public String getCrm_id_notin() {
		return crm_id_notin;
	}

	public void setCrm_id_notin(String crm_id_notin) {
		this.crm_id_notin = crm_id_notin;
	}

	public List<String> getRowid_in() {
		return rowid_in;
	}

	public void setRowid_in(List<String> rowid_in) {
		this.rowid_in = rowid_in;
	}

	public String getOrderByString() {
		return orderByString;
	}

	public void setOrderByString(String orderByString) {
		this.orderByString = orderByString;
	}

	public String getOrderByStringSec() {
		return orderByStringSec;
	}

	public void setOrderByStringSec(String orderByStringSec) {
		this.orderByStringSec = orderByStringSec;
	}

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
}
