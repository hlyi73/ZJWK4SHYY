package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询tas销售方法论接口 从crm响应回来的参数
 * @author liulin 
 *
 */
public class TasResp extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String count = null;//数字
	private List<TasAdd> tasList = new ArrayList<TasAdd>();//tas销售方法论列表
	
	private List<TasValueAdd> tasValueList = new ArrayList<TasValueAdd>();//tasValue销售方法论列表
	
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public List<TasAdd> getTasList() {
		return tasList;
	}
	public void setTasList(List<TasAdd> tasList) {
		this.tasList = tasList;
	}
	public List<TasValueAdd> getTasValueList() {
		return tasValueList;
	}
	public void setTasValueList(List<TasValueAdd> tasValueList) {
		this.tasValueList = tasValueList;
	}
	
}
