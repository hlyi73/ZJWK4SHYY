package com.takshine.core.service.exception;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.takshine.wxcrm.base.util.DateTime;


/**
 * 异常
 */
public class CRMException extends Exception {
	private static Log log = LogFactory.getLog("crmexception");
	
	private static final long serialVersionUID = 1L;
	private String errcode;
	private String mymessage;
	
	public CRMException(String errcode,String mymessage){
		this.setErrcode(errcode);
		this.setMymessage(mymessage);
		log.error("=======crmexception=【"+ DateTime.currentDateTime() +"】=============================> ");
		log.error("ClassName => " + getStackTrace()[0].getClassName());
		log.error("MethodName => " + getStackTrace()[0].getMethodName());
		log.error("LineNumber => " + getStackTrace()[0].getLineNumber());
		log.error("FileName => " + getStackTrace()[0].getFileName());
		log.error("===============================================> ");
	}
	
	public String getErrcode() {
		return errcode;
	}
	
	public void setErrcode(String errcode) {
		this.errcode = errcode;
	}
	
	public String getMymessage() {
		return mymessage;
	}
	
	public void setMymessage(String mymessage) {
		this.mymessage = mymessage;
	}
	
	@Override
	public String getMessage(){
		return "错误编码：" + this.getErrcode() + "，错误描述：" + this.getMymessage();
	}
	
}
