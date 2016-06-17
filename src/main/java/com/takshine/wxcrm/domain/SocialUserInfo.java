
package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.SocialUserInfoModel;


/**
 * 微信用户基本信息表  DTO对象
 * @author liulin
 *
 */
public class SocialUserInfo extends SocialUserInfoModel {
	private List<SocialMessages> msgList;
	private List<SocialTags> tagList;

	public List<SocialTags> getTagList() {
		return tagList;
	}

	public void setTagList(List<SocialTags> tagList) {
		this.tagList = tagList;
	}

	public List<SocialMessages> getMsgList() {
		return msgList;
	}

	public void setMsgList(List<SocialMessages> msgList) {
		this.msgList = msgList;
	}
	
	
}
