package com.takshine.wxcrm.message.qrcode;

public class QrCode {
	private String ticket;//获取的二维码ticket，凭借此ticket可以在有效时间内换取二维码。
	private Integer expireSeconds;//二维码的有效时间，以秒为单位。最大不超过1800。
	
	public String getTicket() {
		return ticket;
	}
	public void setTicket(String ticket) {
		this.ticket = ticket;
	}
	public Integer getExpireSeconds() {
		return expireSeconds;
	}
	public void setExpireSeconds(Integer expireSeconds) {
		this.expireSeconds = expireSeconds;
	}
	
	
}
