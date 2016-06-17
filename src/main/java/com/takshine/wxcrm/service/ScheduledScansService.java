package com.takshine.wxcrm.service;


/**
 * 定时扫描
 * @author dengbo
 *
 */
public interface ScheduledScansService{

	/**
	 * 定时扫描通知信息
	 */
	public void noticeWork();
	
	/**
	 * 每天早报
	 * @param openId
	 */
	public void processMessagesByWxMenuKey(String openId);
	
}
