package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询项目接口从crm响应回来的参数
 * 
 * @author dengbo
 *
 */
public class ProjectResp extends BaseCrm {
	private String viewtype;// 视图类型 myview , teamview, focusview, allview
	private String count = null;// 数字
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String authority;
	public String getAuthority() {
		return authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	private List<ProjectAdd> projects = new ArrayList<ProjectAdd>();// 项目列表

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getCurrpage() {
		return currpage;
	}

	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}

	public String getPagecount() {
		return pagecount;
	}

	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}

	public List<ProjectAdd> getProjects() {
		return projects;
	}

	public void setProjects(List<ProjectAdd> projects) {
		this.projects = projects;
	}

}
