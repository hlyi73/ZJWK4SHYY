package com.takshine.wxcrm.message.sugar;

/**
 * 周报
 * @author dengbo
 *
 */
public class WeekReportReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , allview
	private String currpage ;//当前页
	private String pagecount;//每页的条数
	private String rowid;
	private String assignerid;//责任人ID
	private String countweek;//周次
	
	private String name;
	private String reporttype;
	private String worktype;//类型(重点工作)
	private String typename;//类型名称
	private String questtype;
	private String questtypename;//类型(问题/建议)
	private String content;//具体工作内容
	private String startdate;//开始日期
	private String enddate;//结束日期
	private String summarize;//总结
	private String product;//未交付产品
	private String ordinal;//序号
	private String industry;//所处行业
	private String industryname;//行业名称
	private String goal;//主要目标
	private String projectdynamic;//项目动态
	private String qutorsugg;//问题与建议
	private String parenttype;
	private String parentname;
	private String parentid;
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
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getCountweek() {
		return countweek;
	}
	public void setCountweek(String countweek) {
		this.countweek = countweek;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getReporttype() {
		return reporttype;
	}
	public void setReporttype(String reporttype) {
		this.reporttype = reporttype;
	}
	public String getWorktype() {
		return worktype;
	}
	public void setWorktype(String worktype) {
		this.worktype = worktype;
	}
	public String getTypename() {
		return typename;
	}
	public void setTypename(String typename) {
		this.typename = typename;
	}
	public String getQuesttype() {
		return questtype;
	}
	public void setQuesttype(String questtype) {
		this.questtype = questtype;
	}
	public String getQuesttypename() {
		return questtypename;
	}
	public void setQuesttypename(String questtypename) {
		this.questtypename = questtypename;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	public String getSummarize() {
		return summarize;
	}
	public void setSummarize(String summarize) {
		this.summarize = summarize;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getOrdinal() {
		return ordinal;
	}
	public void setOrdinal(String ordinal) {
		this.ordinal = ordinal;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getIndustryname() {
		return industryname;
	}
	public void setIndustryname(String industryname) {
		this.industryname = industryname;
	}
	public String getGoal() {
		return goal;
	}
	public void setGoal(String goal) {
		this.goal = goal;
	}
	public String getProjectdynamic() {
		return projectdynamic;
	}
	public void setProjectdynamic(String projectdynamic) {
		this.projectdynamic = projectdynamic;
	}
	public String getQutorsugg() {
		return qutorsugg;
	}
	public void setQutorsugg(String qutorsugg) {
		this.qutorsugg = qutorsugg;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
	public String getParentname() {
		return parentname;
	}
	public void setParentname(String parentname) {
		this.parentname = parentname;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	
	
}
