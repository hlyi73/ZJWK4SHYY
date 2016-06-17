package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 审批列表实体类
 * @author dengbo
 *
 */
public class ApproveListResp extends BaseCrm{
	
	private String viewtype;
	private String count = null;
	private String currpage = "1";
	private String pagecount = "10";
	private List<ApproveListAdd> approves = new ArrayList<ApproveListAdd>();
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
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
	public List<ApproveListAdd> getApproves() {
		return approves;
	}
	public void setApproves(List<ApproveListAdd> approves) {
		this.approves = approves;
	}
	
	
}
