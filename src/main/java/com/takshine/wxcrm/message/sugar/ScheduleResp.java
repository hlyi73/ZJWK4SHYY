package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询日程接口 从crm响应回来的参数
 * @author liulin 
 *
 */
public class ScheduleResp extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String viewtype;//视图类型 myview , teamview, focusview, allview 
	private String count = null;//数字
	private List<ScheduleAdd> tasks = new ArrayList<ScheduleAdd>();//任务列表
	
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
	public List<ScheduleAdd> getTasks() {
		return tasks;
	}
	public void setTasks(List<ScheduleAdd> tasks) {
		this.tasks = tasks;
	}
	
}
