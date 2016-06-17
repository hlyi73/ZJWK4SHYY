package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询日程的参数 
 * @author liulin 
 *
 */
public class ScheduleReq extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String viewtype;//视图类型 myview , teamview, focusview, allview 
	private String startdate ;//状态
	private String enddate ;//说明
	private String assigner ;//优先级
	private String pagecount;
	private String status;
	private String parentId;
	private String schetype;
	private String subtaskid;
	private String name;//标题
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubtaskid() {
		return subtaskid;
	}
	public void setSubtaskid(String subtaskid) {
		this.subtaskid = subtaskid;
	}
	public String getSchetype() {
		return schetype;
	}
	public void setSchetype(String schetype) {
		this.schetype = schetype;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	private String currpage;
	
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
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getPagecount() {
		return pagecount;
	}
	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}
	public String getCurrpage() {
		return currpage;
	}
	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	
}
