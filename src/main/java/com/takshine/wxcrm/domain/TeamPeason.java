package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.TeamPeasonModel;

/**
 * 团队成员
 * @author liulin
 *
 */
public class TeamPeason extends TeamPeasonModel{
	
	private String ownerOpenId;
	private String relaModel;
	private String relaName;
	private String assigner;//分享人
	private String party_row_id;
	
	public String getOwnerOpenId() {
		return ownerOpenId;
	}
	public void setOwnerOpenId(String ownerOpenId) {
		this.ownerOpenId = ownerOpenId;
	}
	public String getRelaModel() {
		return relaModel;
	}
	public void setRelaModel(String relaModel) {
		this.relaModel = relaModel;
	}
	public String getRelaName() {
		return relaName;
	}
	public void setRelaName(String relaName) {
		this.relaName = relaName;
	}
	public String getAssigner() {
		return assigner;
	}
	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}
	public String getParty_row_id() {
		return party_row_id;
	}
	public void setParty_row_id(String party_row_id) {
		this.party_row_id = party_row_id;
	}
	
	
}
