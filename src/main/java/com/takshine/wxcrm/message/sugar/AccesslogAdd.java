package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 新增用户行为接口的 参数
 * 
 * @author huangpeng
 *
 */
public class AccesslogAdd extends BaseCrm{
	private String access1;
	private String access2;
	private String access3;
	private String access4;
	public String getAccess1() {
		return access1;
	}
	public void setAccess1(String access1) {
		this.access1 = access1;
	}
	public String getAccess2() {
		return access2;
	}
	public void setAccess2(String access2) {
		this.access2 = access2;
	}
	public String getAccess3() {
		return access3;
	}
	public void setAccess3(String access3) {
		this.access3 = access3;
	}
	public String getAccess4() {
		return access4;
	}
	public void setAccess4(String access4) {
		this.access4 = access4;
	}

	
}
