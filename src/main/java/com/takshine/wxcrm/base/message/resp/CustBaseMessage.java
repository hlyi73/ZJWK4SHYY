package com.takshine.wxcrm.base.message.resp;

/**
 * 自定义消息接口类
 * @author liulin
 *
 */
public class CustBaseMessage {
	private String touser;// 普通用户openid
	private String msgtype;// 消息类型，text

	public String getTouser() {
		return touser;
	}

	public void setTouser(String touser) {
		this.touser = touser;
	}

	public String getMsgtype() {
		return msgtype;
	}

	public void setMsgtype(String msgtype) {
		this.msgtype = msgtype;
	}

}
