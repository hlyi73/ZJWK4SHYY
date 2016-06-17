package com.takshine.wxcrm.service;

import java.util.Map;

import net.sf.json.JSONObject;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.message.tplmsg.ValColor;

/**
 * 模板消息服务
 * @author liulin
 *
 */
public interface TemplateMsgService extends EntityService{
	
	/**
	 * 发送日程模板消息
	 */
	public JSONObject sendScheduleMsg(String openId, String topcolor, String url, Map<String, ValColor> map);
	
	/**
	 * 审批 模板消息 
	 */
	public JSONObject sendApproveMsg(String openId, String topcolor, String url, Map<String, ValColor> map);
	
	/**
	 * 待办任务 模板消息 
	 */
	public JSONObject sendToDoWorkMsg(String openId, String topcolor, String url, Map<String, ValColor> map);
	
}
