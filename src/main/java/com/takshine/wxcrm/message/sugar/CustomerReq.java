package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询客户的参数
 * 
 * @author liulin
 *
 */
public class CustomerReq extends BaseCrm {

	private String viewtype;// 视图类型 myview , teamview, focusview, allview
	private String firstchar;
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private String name;// 名称
	private String assignerid;// 责任人Id
	private String accnttype;// 客户类型
	private String industry;// 行业
	private String publicId; //公共Id
	private String openId;
	private String startDate;//开始时间
	private String endDate;//结束时间
	private String opptyid;
	private String campaigns;
	private String parentid;
	private String parenttype;
	private String province;//省
	private String tagName; 
	private String starflag;
	
	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
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

	public String getCampaigns() {
		return campaigns;
	}

	public void setCampaigns(String campaigns) {
		this.campaigns = campaigns;
	}

	public String getViewtype() {
		return viewtype;
	}

	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}

	public String getFirstchar() {
		return firstchar;
	}

	public void setFirstchar(String firstchar) {
		this.firstchar = firstchar;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAssignerid() {
		return assignerid;
	}

	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}

	public String getAccnttype() {
		return accnttype;
	}

	public void setAccnttype(String accnttype) {
		this.accnttype = accnttype;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getPublicId() {
		return publicId;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public String getOpenId() {
		return openId;
	}

	public void setOpenId(String openId) {
		this.openId = openId;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getOpptyid() {
		return opptyid;
	}

	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getStarflag() {
		return starflag;
	}

	public void setStarflag(String starflag) {
		this.starflag = starflag;
	}
	
}
