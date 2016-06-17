package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询产品的参数
 * 
 * @author huangpeng
 *
 */
public class ProductReq extends BaseCrm{
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String name;// 名称
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String openId;
	private String publicId; //公共Id
	private String type; //产品类型
	private String rowid; //产品ID
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getPublicId() {
		return publicId;
	}
	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	
}
