package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询业务机会的参数 
 * @author liulin 
 *
 */
public class OpptyReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String firstchar; 
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	
	//查询条件
	private String salesStage = null;//销售阶段
	private String startDate = null;//关闭的开始日期
	private String endDate = null;//关闭的结束日期
	private String assignId = null;//责任人
	private String opptyname = null;//业务机会名称
	private String cstartdate;//创建的开始时间
	private String cenddate;//创建的结束时间
	private String closedate;
	private String failreason;//业务机会失败原因
	private String parentId;
	private String campaigns;
	private String tagName; //标签名字
	private String starflag; //星标
	
	public String getCampaigns() {
		return campaigns;
	}
	public void setCampaigns(String campaigns) {
		this.campaigns = campaigns;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
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
	public String getSalesStage() {
		return salesStage;
	}
	public void setSalesStage(String salesStage) {
		this.salesStage = salesStage;
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
	public String getAssignId() {
		return assignId;
	}
	public void setAssignId(String assignId) {
		this.assignId = assignId;
	}
	public String getOpptyname() {
		return opptyname;
	}
	public void setOpptyname(String opptyname) {
		this.opptyname = opptyname;
	}
	public String getCstartdate() {
		return cstartdate;
	}
	public void setCstartdate(String cstartdate) {
		this.cstartdate = cstartdate;
	}
	public String getCenddate() {
		return cenddate;
	}
	public void setCenddate(String cenddate) {
		this.cenddate = cenddate;
	}
	public String getClosedate() {
		return closedate;
	}
	public void setClosedate(String closedate) {
		this.closedate = closedate;
	}
	public String getFailreason() {
		return failreason;
	}
	public void setFailreason(String failreason) {
		this.failreason = failreason;
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
