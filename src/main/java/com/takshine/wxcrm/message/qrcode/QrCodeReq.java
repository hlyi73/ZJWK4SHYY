package com.takshine.wxcrm.message.qrcode;

public class QrCodeReq {
	private String action_name;//二维码类型，QR_SCENE为临时,QR_LIMIT_SCENE为永久
	//private Integer expireSeconds;//该二维码有效时间，以秒为单位。 最大不超过1800。
	private QrCodeAction action_info;//二维码详细信息
	

	public String getAction_name() {
		return action_name;
	}
	public void setAction_name(String action_name) {
		this.action_name = action_name;
	}
	/*public Integer getExpireSeconds() {
		return expireSeconds;
	}
	public void setExpireSeconds(Integer expireSeconds) {
		this.expireSeconds = expireSeconds;
	}*/
	public QrCodeAction getAction_info() {
		return action_info;
	}
	public void setAction_info(QrCodeAction action_info) {
		this.action_info = action_info;
	}
	
}
