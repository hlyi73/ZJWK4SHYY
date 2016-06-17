package com.takshine.wxcrm.message.sugar;

/**
 * 查询服务请求报表接口 从crm响应回来的参数
 * @author dengbo
 *
 */
public class AnalyticsComplaintResp extends BaseCrm{
	
	private String month;//月份
	private String num;//服务请求个数
	private String subtype;//类型
	private String depart;//部门
	
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getSubtype() {
		return subtype;
	}
	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	
}
