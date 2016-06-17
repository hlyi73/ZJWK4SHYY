package com.takshine.core.service;

import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.service.ScheduledScansService;
import com.takshine.wxcrm.service.WxAddressInfoService;
import com.takshine.wxcrm.service.WxCoreService;
import com.takshine.wxcrm.service.WxPushMsgService;
import com.takshine.wxcrm.service.WxReplyService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxSubscribeHisService;
import com.takshine.wxcrm.service.WxTodayInHistoryService;
import com.takshine.wxcrm.service.WxUserLocationService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.wxcrm.service.ZJWKSystemTaskService;

/**
 * 系统中微信通用接口
 * @author dengbo
 *
 */
public interface WxService{
	public WxAddressInfoService getWxAddressInfoService();

	public WxCoreService getWxCoreService();

	public WxReplyService getWxReplyService();

	public WxRespMsgService getWxRespMsgService();

	public WxSubscribeHisService getWxSubscribeHisService();

	public WxTodayInHistoryService getWxTodayInHistoryService();

	public WxUserinfoService getWxUserinfoService();

	public WxUserLocationService getWxUserLocationService();
	
	public ZJWKSystemTaskService getZjwkSystemTaskService();
	
	public WxHttpConUtil getWxHttpConUtil();
	
	public WxPushMsgService getWxPushMsgService();

	public ScheduledScansService getScheduledScansService();
}
