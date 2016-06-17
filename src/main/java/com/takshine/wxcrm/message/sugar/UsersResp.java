package com.takshine.wxcrm.message.sugar;

import java.util.List;

/**
 * 查询日程接口 从sugar响应回来的参数
 * @author liulin 
 *
 */
public class UsersResp extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String count ;//数字
	private List<UserAdd> users ;//任务列表
	
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public List<UserAdd> getUsers() {
		return users;
	}
	public void setUsers(List<UserAdd> users) {
		this.users = users;
	}
}
