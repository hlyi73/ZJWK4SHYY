package com.takshine.wxcrm.message.sugar;

import java.util.List;


/**
 * 传递给crm tas销售方法论的 参数
 * @author 刘淋
 *
 */
public class TasReq extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String rowid;//业务机会id
	private String tastype;//tas销售方法论 类别
	private List<TasAdd> tasList;
	private String content;//暂时用来做部门增加的key/value，中间以，号分隔；外层用；号分隔
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getTastype() {
		return tastype;
	}
	public void setTastype(String tastype) {
		this.tastype = tastype;
	}
	public List<TasAdd> getTasList() {
		return tasList;
	}
	public void setTasList(List<TasAdd> tasList) {
		this.tasList = tasList;
	}
	
}
