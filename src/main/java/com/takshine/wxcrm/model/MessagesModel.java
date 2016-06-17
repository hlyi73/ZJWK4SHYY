package com.takshine.wxcrm.model;

import java.util.Date;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;

/**
 * 消息
 * @author liulin
 *
 */
public class MessagesModel extends BaseModel{
	
	private String crmId = null;
	private String msgType = null;
	private Date lastTime = null;
	
	//通用的信息功能
	private String ownerCrmId = null;//拥有人的crmId
	private String ownerOpenId = null;//拥有人的openId
	private String userId = null;//发送人ID
	private String targetUId = null;//目标人ID
	private String username = null;//发送人姓名	
	private String targetUName = null;//目标人姓名	
	private String content =null;//消息内容
	private String relaModule=null;//关联模块	
	private String relaId=null;//关联ID
	private String relaName=null;//关联名称
	private String subRelaId=null;//子级关联ID
	private String readFlag=null;//读取标志(Y:已读,N:未读)
	private String assignerid;//责任人ID
	private String isatten = null; //是否是外部用户
	private String msgtime = null; //首页消息用
	private String shorttime = null; //首页消息用
	private int totalcount = 0;
	private String headimgurl;
	private String cardname; //名片中的名字
	private String cardimg; //名片中的头像
	
	
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
	public String getHeadimgurl() {
//		if (StringUtils.isNotNullOrEmptyStr(headimgurl))
//		{
//			if (headimgurl.lastIndexOf("/") != -1)
//			{
//				headimgurl = headimgurl.substring(0,headimgurl.lastIndexOf("/") + 1) + Constants.OTHER_IMG_SIZE_96;
//			}
//		}
		if (StringUtils.isNotNullOrEmptyStr(getCardimg())){
			headimgurl = "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + getCardimg();
		}
		return headimgurl;
	}
	public void setHeadimgurl(String headimgurl) {
		this.headimgurl = headimgurl;
	}
	public int getTotalcount() {
		return totalcount;
	}
	public void setTotalcount(int totalcount) {
		this.totalcount = totalcount;
	}
	public String getMsgtime() {
		return msgtime;
	}
	public void setMsgtime(String msgtime) {
		this.msgtime = msgtime;
	}
	public String getShorttime() {
		return shorttime;
	}
	public void setShorttime(String shorttime) {
		this.shorttime = shorttime;
	}
	
	public String getIsatten() {
		return isatten;
	}
	public void setIsatten(String isatten) {
		this.isatten = isatten;
	}
	public String getOwnerCrmId() {
		return ownerCrmId;
	}
	public void setOwnerCrmId(String ownerCrmId) {
		this.ownerCrmId = ownerCrmId;
	}
	public String getOwnerOpenId() {
		return ownerOpenId;
	}
	public void setOwnerOpenId(String ownerOpenId) {
		this.ownerOpenId = ownerOpenId;
	}
	public String getCrmId() {
		return crmId;
	}
	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}
	public String getMsgType() {
		return msgType;
	}
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}
	public Date getLastTime() {
		return lastTime;
	}
	public void setLastTime(Date lastTime) {
		this.lastTime = lastTime;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUsername() {
		if(StringUtils.isNotNullOrEmptyStr(getCardname())){
			username = getCardname();
		}
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getRelaModule() {
		return relaModule;
	}
	public void setRelaModule(String relaModule) {
		this.relaModule = relaModule;
	}
	public String getRelaId() {
		return relaId;
	}
	public void setRelaId(String relaId) {
		this.relaId = relaId;
	}
	public String getReadFlag() {
		return readFlag;
	}
	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	public String getTargetUId() {
		return targetUId;
	}
	public void setTargetUId(String targetUId) {
		this.targetUId = targetUId;
	}
	public String getTargetUName() {
		return targetUName;
	}
	public void setTargetUName(String targetUName) {
		this.targetUName = targetUName;
	}
	public String getSubRelaId() {
		return subRelaId;
	}
	public void setSubRelaId(String subRelaId) {
		this.subRelaId = subRelaId;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getRelaName() {
		return relaName;
	}
	public void setRelaName(String relaName) {
		this.relaName = relaName;
	}
	
}
