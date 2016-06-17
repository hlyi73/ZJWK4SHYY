package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm的参数
 * @author dengbo
 *
 */
public class RepeatNameReq extends BaseCrm{
	
	String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
}
