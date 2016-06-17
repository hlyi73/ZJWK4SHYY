package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;
import com.takshine.wxcrm.domain.Bug;

public class BugResp extends BaseCrm {
	/**
	 * sugar接口回传的参数
	 */
	private String viewtype;//视图类型 myview , teamview, focusview, allview 
	private String count = null;//数字
	private List<Bug> bugs = new ArrayList<Bug>();//Bug列表
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
	public List<Bug> getBugs() {
		return bugs;
	}
	public void setBugs(List<Bug> bugs) {
		this.bugs = bugs;
	}
}
