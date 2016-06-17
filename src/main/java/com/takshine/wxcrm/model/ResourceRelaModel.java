package com.takshine.wxcrm.model;

import java.util.Date;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 资料关联模型
 * @author zhihe
 *
 */
public class ResourceRelaModel extends BaseModel{
	
	private String relaId = null;//关联记录id
	private String relaResourceId = null; //关联资料id
	private String relaUserId = null;//关联用户id
	private String relaExploreNum = null;//浏览次数
	private Date relaCreateDate = null;//创建时间
	private Date relaModifyDate = null;//修改时间
	private String relaInfo1 = null;//预留字段1
	private String relaInfo2 = null;//预留字段2
	private String relaInfo3 = null;//预留字段3
	
	public String getRelaId() {
		return relaId;
	}
	public void setRelaId(String relaId) {
		this.relaId = relaId;
	}
	public String getRelaResourceId() {
		return relaResourceId;
	}
	public void setRelaResourceId(String relaResourceId) {
		this.relaResourceId = relaResourceId;
	}
	public String getRelaUserId() {
		return relaUserId;
	}
	public void setRelaUserId(String relaUserId) {
		this.relaUserId = relaUserId;
	}
	public String getRelaExploreNum() {
		return relaExploreNum;
	}
	public void setRelaExploreNum(String relaExploreNum) {
		this.relaExploreNum = relaExploreNum;
	}
	public Date getRelaCreateDate() {
		return relaCreateDate;
	}
	public void setRelaCreateDate(Date relaCreateDate) {
		this.relaCreateDate = relaCreateDate;
	}
	public Date getRelaModifyDate() {
		return relaModifyDate;
	}
	public void setRelaModifyDate(Date relaModifyDate) {
		this.relaModifyDate = relaModifyDate;
	}
	public String getRelaInfo1() {
		return relaInfo1;
	}
	public void setRelaInfo1(String relaInfo1) {
		this.relaInfo1 = relaInfo1;
	}
	public String getRelaInfo2() {
		return relaInfo2;
	}
	public void setRelaInfo2(String relaInfo2) {
		this.relaInfo2 = relaInfo2;
	}
	public String getRelaInfo3() {
		return relaInfo3;
	}
	public void setRelaInfo3(String relaInfo3) {
		this.relaInfo3 = relaInfo3;
	}
}
