package com.takshine.wxcrm.service;

import javax.servlet.http.HttpServletRequest;

public interface WxCoreService {
	
	/**
	 * 处理微信发来的请求
	 * 
	 * @param request
	 * @return
	 */
	public String processRequest(HttpServletRequest request);
}
