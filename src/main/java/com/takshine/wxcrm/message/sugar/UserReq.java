package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询用户的参数 
 * @author liulin 
 *
 */
public class UserReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview 
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private String firstchar = "";//首字母
	private String flag;//标志位,若为direct_subordinates，则查直接下属；若为more,则查所有的用户(包括未激活的用户);若为all,则查所有的;若为single,则查询单个user;若为share,则查询共享用户列表;若为空,则查下属的
	private String parenttype;
	private String parentid;
	private String userstatus;//用户状态(启用/禁用)
	private String source;//来源
	private String crmid;//启用或禁用某人的crmid
	private String openId;
	private String optype;//del 删除
	
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getCurrpage() {
		return currpage;
	}
	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}
	public String getPagecount() {
		return pagecount;
	}
	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getFirstchar() {
		return firstchar;
	}
	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
	}
	public String getUserstatus() {
		return userstatus;
	}
	public void setUserstatus(String userstatus) {
		this.userstatus = userstatus;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getCrmid() {
		return crmid;
	}
	public void setCrmid(String crmid) {
		this.crmid = crmid;
	}
	
}
