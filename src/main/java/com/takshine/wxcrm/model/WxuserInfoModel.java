/*
 * UserinfoModel.java 
 * Copyright(c) 2007 BroadText Inc.
 * ALL Rights Reserved.
 */
package com.takshine.wxcrm.model;

import java.util.Date;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;

/**
 * 微信用户基本信息表 Model
 * 
 * @author liulin
 */
public class WxuserInfoModel extends BaseModel {
	
    private String subscribe = null;        
    private String nickname = null;         
    private String sex = null;             
    private String city = null;  
    private String country = null;    
    private String province = null;
    private String language = null;
    private String headimgurl = null;
    private Date subscribeTime = null;
    private Date loginTime=null;//最后一次登录时间
    private String name = null;
    private String headimgstr = null; //base64
    
    
    private String unionid = null;//唯一ID
    private String party_row_id = null;//s-party 主键ID
	private String contactConfig="friend";//联系方式配置
	private String msmConfig="friend";//私信配置
	private String messageConfig="all";//留言配置
	private String validationConfig="my";//好友验证 my：需要我验证/question：问题验证/all：不需要验证
	
	private String cardname; //名片中的姓名
	private String cardimg; //名片中的图像
	private String mobile; //
	private String email;
	
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getCardname() {
		return cardname;
	}
	public void setCardname(String cardname) {
		this.cardname = cardname;
	}
	public String getCardimg() {
		return cardimg;
	}
	public void setCardimg(String cardimg) {
		this.cardimg = cardimg;
	}
	public String getContactConfig() {
		return contactConfig;
	}
	public void setContactConfig(String contactConfig) {
		this.contactConfig = contactConfig;
	}
	public String getMsmConfig() {
		return msmConfig;
	}
	public void setMsmConfig(String msmConfig) {
		this.msmConfig = msmConfig;
	}
	public String getMessageConfig() {
		return messageConfig;
	}
	public void setMessageConfig(String messageConfig) {
		this.messageConfig = messageConfig;
	}
	public String getValidationConfig() {
		return validationConfig;
	}
	public void setValidationConfig(String validationConfig) {
		this.validationConfig = validationConfig;
	}
	public String getHeadimgstr() {
		return headimgstr;
	}
	public void setHeadimgstr(String headimgstr) {
		this.headimgstr = headimgstr;
	}
	public String getName() {
		if(StringUtils.isNotNullOrEmptyStr(cardname)){
			return cardname;
		}
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubscribe() {
		return subscribe;
	}
	public void setSubscribe(String subscribe) {
		this.subscribe = subscribe;
	}
	public String getNickname() {
		if(StringUtils.isNotNullOrEmptyStr(cardname)){
			return cardname;
		}
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getHeadimgurl() 
	{
		
//		if (StringUtils.isNotNullOrEmptyStr(headimgurl))
//		{
//			if (headimgurl.lastIndexOf("/") != -1)
//			{
//				headimgurl = headimgurl.substring(0,headimgurl.lastIndexOf("/") + 1) + Constants.OTHER_IMG_SIZE_96;
//			}
//		}
		//
		if (StringUtils.isNotNullOrEmptyStr(getCardimg())){
			headimgurl = "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + getCardimg();
		}
			
		
		return headimgurl;
	}
	
	/**
	 * 重载getHeadimgurl方法
	 * @param flag 可选0,46,96,132
	 * @return
	 */
	public String getHeadimgurl(String flag)
	{
		if (StringUtils.isNotNullOrEmptyStr(headimgurl))
		{
			if (headimgurl.lastIndexOf("/") != -1)
			{
				headimgurl = headimgurl.substring(0,headimgurl.lastIndexOf("/") + 1) + flag;
			}
		}
		
		return headimgurl;
	}
	
	public void setHeadimgurl(String headimgurl) {
		this.headimgurl = headimgurl;
	}
	public Date getSubscribeTime() {
		return subscribeTime;
	}
	public void setSubscribeTime(Date subscribeTime) {
		this.subscribeTime = subscribeTime;
	}
	public Date getLoginTime() {
		return loginTime;
	}
	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}
	public String getUnionid() {
		return unionid;
	}
	public void setUnionid(String unionid) {
		this.unionid = unionid;
	}
	public String getParty_row_id() {
		return party_row_id;
	}
	public void setParty_row_id(String party_row_id) {
		this.party_row_id = party_row_id;
	}
	private String rssId;//订阅Id
	private String firstChar;//首字母
	
	public String getFirstChar() {
		return firstChar;
	}
	public void setFirstChar(String firstChar) {
		this.firstChar = firstChar;
	}
	public String getRssId() {
		return rssId;
	}
	public void setRssId(String rssId) {
		this.rssId = rssId;
	}
}
