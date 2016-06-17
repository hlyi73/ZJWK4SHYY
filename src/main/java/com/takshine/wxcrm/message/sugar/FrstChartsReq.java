package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询用户的参数 
 * @author liulin 
 *
 */
public class FrstChartsReq extends BaseCrm{
	
	private String parentid;
	private String parenttype;
	private String flag;//若未空,则查下属的首字母;若为all,则查所有人的首字母;若为approve,则查审批人的首字母
	private String openId;
	
	
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	
	
}
