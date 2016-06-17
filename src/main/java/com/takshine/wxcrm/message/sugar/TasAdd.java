package com.takshine.wxcrm.message.sugar;

import java.util.List;


/**
 * 传递给crm tas销售方法论的 参数
 * @author 刘淋
 *
 */
public class TasAdd extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String key;//问题
	private String name;//问题名字
	private List<TasValueAdd> values;//答案s
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<TasValueAdd> getValues() {
		return values;
	}
	public void setValues(List<TasValueAdd> values) {
		this.values = values;
	}
}
