package com.takshine.wxcrm.base.error;

/**
 * 错误消息
 * @author liulin
 *
 */
public class BaseError {
	
	private String errorCode = null;//错误编码
	private String errorMsg = null;//错误消息
	
	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getErrorMsg() {
		return errorMsg;
	}
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
	
}
