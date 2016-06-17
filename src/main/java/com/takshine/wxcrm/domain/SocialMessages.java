
package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.SocialMessagesModel;


/**
 * 微信用户基本信息表  DTO对象
 * @author liulin
 *
 */
public class SocialMessages extends SocialMessagesModel {
	List<SocialPics> picList;

	public List<SocialPics> getPicList() {
		return picList;
	}

	public void setPicList(List<SocialPics> picList) {
		this.picList = picList;
	}
	
	
}
