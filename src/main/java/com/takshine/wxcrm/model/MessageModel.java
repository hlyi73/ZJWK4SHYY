package com.takshine.wxcrm.model;

import java.util.Date;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 消息
 * @author liulin
 *
 */
public class MessageModel extends BaseModel{
	
	private String crmId = null;
	private String msgType = null;
	private Date lastTime = null;
	
	//通用的信息功能
	private String userId = null;//发送人ID
	private String targetUId = null;//目标人ID
	private String username = null;//发送人姓名	
	private String targetUName = null;//目标人姓名	
	private String content =null;//消息内容
	private String relaModule=null;//关联模块	
	private String relaId=null;//关联ID
	private String subRelaId=null;//子级关联ID
	private String readFlag=null;//读取标志(Y:已读,N:未读)
	
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
	
}
