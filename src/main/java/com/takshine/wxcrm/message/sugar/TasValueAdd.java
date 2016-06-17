package com.takshine.wxcrm.message.sugar;



/**
 * 传递给crm tas销售方法论的 参数
 * @author 刘淋
 *
 */
public class TasValueAdd extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String id;//主键
	private String flag;//标志
	private String value;//值
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
}
