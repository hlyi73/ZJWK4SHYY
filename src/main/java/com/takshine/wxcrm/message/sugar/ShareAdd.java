package com.takshine.wxcrm.message.sugar;

/**
 * 分享
 * @author dengbo
 *
 */
public class ShareAdd extends BaseCrm{
	
	private String parentid;//共享的记录ID
	private String parenttype;//共享的记录类型,Accounts:企业；Opportunities:业务机会; Contacts:联系人；Tasks:任务；Contract：合同
	private String shareuserid;//共享给某用户的用户ID
	private String shareusername;//共享某用户的用户名
	private String flag;//标示位,Y代表可删,N代表不能删除
	
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
	public String getShareuserid() {
		return shareuserid;
	}
	public void setShareuserid(String shareuserid) {
		this.shareuserid = shareuserid;
	}
	public String getShareusername() {
		return shareusername;
	}
	public void setShareusername(String shareusername) {
		this.shareusername = shareusername;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	
}
