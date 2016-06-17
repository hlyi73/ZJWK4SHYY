package com.takshine.wxcrm.message.sugar;

/**
 * 传递给crm 查询联系人
 * @author liulin 
 *
 */
public class ContactReq extends BaseCrm{
	
	private String viewtype;//视图类型 myview , teamview, focusview, allview
	private String firstchar; 
	private String currpage ;//当前页
	private String pagecount;//每页的条数
	private String parentId;//关联Id
	private String parentType;//关联类型
	private String rowid;
	private String flag;//标记
	private String connname;  //名字
	private String phonemobile; //电话
	private String tagName;
	private String starflag;
	private String contype;
	private String contype_val;
	
	public String getTagtype() {
		return tagtype;
	}
	public void setTagtype(String tagtype) {
		this.tagtype = tagtype;
	}
	private String tagtype;
	
	
	public String getContype() {
		return contype;
	}
	public void setContype(String contype) {
		this.contype = contype;
	}
	public String getContype_val() {
		return contype_val;
	}
	public void setContype_val(String contype_val) {
		this.contype_val = contype_val;
	}
	public String getConnname() {
		return connname;
	}
	public void setConnname(String connname) {
		this.connname = connname;
	}
	public String getPhonemobile() {
		return phonemobile;
	}
	public void setPhonemobile(String phonemobile) {
		this.phonemobile = phonemobile;
	}
	//查詢字段
	private String datetime;
	private String timefre;//時間頻率
	private String assignerId = null;//责任人ID
	
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public String getTimefre() {
		return timefre;
	}
	public void setTimefre(String timefre) {
		this.timefre = timefre;
	}
	public String getAssignerId() {
		return assignerId;
	}
	public void setAssignerId(String assignerId) {
		this.assignerId = assignerId;
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
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getParentType() {
		return parentType;
	}
	public void setParentType(String parentType) {
		this.parentType = parentType;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
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
