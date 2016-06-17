package com.takshine.wxcrm.message.sugar;

/**
 * 联系人报表接口 从crm响应回来的参数
 * 
 * @author huangpeng
 *
 */
public class AnalyticsContactResp extends BaseCrm{
   private String contactname ;  //联系人名称
   private String value;         //价值
public String getContactname() {
	return contactname;
}
public void setContactname(String contactname) {
	this.contactname = contactname;
}
public String getValue() {
	return value;
}
public void setValue(String value) {
	this.value = value;
}
   
   
   
}
