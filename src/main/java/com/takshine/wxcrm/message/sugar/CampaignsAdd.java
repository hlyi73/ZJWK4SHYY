package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 传递给sugar查询市场活动
 * @author dengbo
 *
 */
public class CampaignsAdd extends BaseCrm{
	private String rowid;
	private String name;//名称
	private String status;//状态
	private String statuskey;//状态key
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String type;//类型
	private String typekey;//类型key
	private String budget;//预算
	private String budgetcost;//预算成本
	private String expectcost;//预期收入
	private String factcost;//实际成本
	private String impressions;//印象数
	private String goal;//目的
	private String desc;//说明
	private String assigner ;//责任人
	private String assignerid;//责任人ID
	private String creater ;//创建人
	private String createdate ;//创建时间
	private String modifier ;//修改人
	private String modifydate ;//修改时间
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	private String logo;
	private String place;
	private String value;
	private String remark;
	private String headImageUrl;

	private String readnum;
	private String praisenum;
	private String forwardnum;
	private String joinnum;
	
	private List<OpptyAdd> oppties = new ArrayList<OpptyAdd>();//业务机会列表
	private List<ScheduleAdd> tasks = new ArrayList<ScheduleAdd>();//任务列表
	private List<CustomerAdd> custs = new ArrayList<CustomerAdd>();//客户列表
	private List<OpptyAuditsAdd> audits = new ArrayList<OpptyAuditsAdd>();// 任务列表
	
	
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getHeadImageUrl() {
		return headImageUrl;
	}
	public void setHeadImageUrl(String headImageUrl) {
		this.headImageUrl = headImageUrl;
	}
	public String getReadnum() {
		return readnum;
	}
	public void setReadnum(String readnum) {
		this.readnum = readnum;
	}
	public String getPraisenum() {
		return praisenum;
	}
	public void setPraisenum(String praisenum) {
		this.praisenum = praisenum;
	}
	public String getForwardnum() {
		return forwardnum;
	}
	public void setForwardnum(String forwardnum) {
		this.forwardnum = forwardnum;
	}
	public String getJoinnum() {
		return joinnum;
	}
	public void setJoinnum(String joinnum) {
		this.joinnum = joinnum;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
	public String getLogo() {
		return logo;
	}
	public void setLogo(String logo) {
		this.logo = logo;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getBudget() {
		return budget;
	}
	public void setBudget(String budget) {
		this.budget = budget;
	}
	public String getBudgetcost() {
		return budgetcost;
	}
	public void setBudgetcost(String budgetcost) {
		this.budgetcost = budgetcost;
	}
	public String getExpectcost() {
		return expectcost;
	}
	public void setExpectcost(String expectcost) {
		this.expectcost = expectcost;
	}
	public String getFactcost() {
		return factcost;
	}
	public void setFactcost(String factcost) {
		this.factcost = factcost;
	}
	public String getImpressions() {
		return impressions;
	}
	public void setImpressions(String impressions) {
		this.impressions = impressions;
	}
	public String getGoal() {
		return goal;
	}
	public void setGoal(String goal) {
		this.goal = goal;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}
	public List<OpptyAdd> getOppties() {
		return oppties;
	}
	public void setOppties(List<OpptyAdd> oppties) {
		this.oppties = oppties;
	}
	public List<ScheduleAdd> getTasks() {
		return tasks;
	}
	public void setTasks(List<ScheduleAdd> tasks) {
		this.tasks = tasks;
	}
	public List<CustomerAdd> getCusts() {
		return custs;
	}
	public void setCusts(List<CustomerAdd> custs) {
		this.custs = custs;
	}
	public List<OpptyAuditsAdd> getAudits() {
		return audits;
	}
	public void setAudits(List<OpptyAuditsAdd> audits) {
		this.audits = audits;
	}
	public String getStatuskey() {
		return statuskey;
	}
	public void setStatuskey(String statuskey) {
		this.statuskey = statuskey;
	}
	public String getTypekey() {
		return typekey;
	}
	public void setTypekey(String typekey) {
		this.typekey = typekey;
	}
	
}
