package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询合同接口从crm响应回来的参数
 * 
 * @author dengbo
 *
 */
public class FeedsResp extends BaseCrm {
	private String count = null;// 数字
	private String msgcount = null;
	private String currpage = "1";// 当前页
	private String pagecount = "5";// 每页的条数
	private List<FeedsAdd> feedList = new ArrayList<FeedsAdd>();// 活动流
	private List<FeedsAdd> replyList = new ArrayList<FeedsAdd>();// 回复列表
	private List<OpptyAuditsAdd> auditList = new ArrayList<OpptyAuditsAdd>();//业务机会跟进历史
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
	public List<FeedsAdd> getFeedList() {
		return feedList;
	}
	public void setFeedList(List<FeedsAdd> feedList) {
		this.feedList = feedList;
	}
	public List<FeedsAdd> getReplyList() {
		return replyList;
	}
	public void setReplyList(List<FeedsAdd> replyList) {
		this.replyList = replyList;
	}
	public List<OpptyAuditsAdd> getAuditList() {
		return auditList;
	}
	public void setAuditList(List<OpptyAuditsAdd> auditList) {
		this.auditList = auditList;
	}
	public String getMsgcount() {
		return msgcount;
	}
	public void setMsgcount(String msgcount) {
		this.msgcount = msgcount;
	}
	

	
}
