package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 团队成员
 * @author liulin
 *
 */
public class TeamPeasonModel extends BaseModel{
	
	private String relaId = null;
	private String nickName = null;
	private Integer currpages = 0;
	private Integer pagecounts = 10;

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public String getRelaId() {
		return relaId;
	}

	public void setRelaId(String relaId) {
		this.relaId = relaId;
	}

	public Integer getCurrpages() {
		return currpages;
	}

	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}

	public Integer getPagecounts() {
		return pagecounts;
	}

	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	
}
