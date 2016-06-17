package com.takshine.wxcrm.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.message.tplmsg.ValColor;
import com.takshine.wxcrm.service.TemplateMsgService;

/**
 * 模板消息  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/tplmsg")
public class TemplateMsgController {
	    // 日志
		protected static Logger logger = Logger.getLogger(TemplateMsgController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 *  发送 消息
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/send")
		@ResponseBody
		public String send(Messages msg, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			//发送参数
	        String openId = "on478t5q-IsPn-KcWs5G7FEGqi2Q";//  on478tyhwR3fkCAOQpd6lT0rUjxc
	        String topcolor = "#00DB00";
	        String url = "http://www.takshine.com";
	        //日程任务
	        Map<String, ValColor> map = new HashMap<String, ValColor>();
	        map.put("first", new ValColor("您好，请留意日历事件：","#4A4AFF"));//标题值
	        map.put("schedule", new ValColor("准备每月的总结","#4A4AFF"));//事件值
	        map.put("time", new ValColor("每月30日","#FF0000"));//时间值
	        map.put("remark", new ValColor("明天8:00将再次提醒。","#4A4AFF"));//备注值
	        //发送消息
	        JSONObject rst = cRMService.getDbService().getTemplateMsgService().sendScheduleMsg(openId, topcolor, url, map);
	        logger.info(rst.getString("errcode"));
	        
	        //审批结果
	        map.clear();
	        map.put("first", new ValColor("彭总，您好：","#4A4AFF"));//标题值
	        map.put("keyword1", new ValColor("『银电网络智能监控系统』项目差旅费报销，金额为￥215元整。","#4A4AFF"));//审批事项
	        map.put("keyword2", new ValColor("通过","#FF0000"));//审批结果
	        map.put("remark", new ValColor("2014/8/25 10:12:22","#4A4AFF"));//备注值
	        //发送消息
	        rst = cRMService.getDbService().getTemplateMsgService().sendApproveMsg(openId, topcolor, url, map);
	        logger.info(rst.getString("errcode"));
	        
	        //待办工作任务
	        map.clear();
	        map.put("first", new ValColor("你好，你还有3项待办工作。","#4A4AFF"));//标题值
	        map.put("work", new ValColor("客户生日关怀、客户保险到期等3项工作","#4A4AFF"));//待办工作
	        map.put("remark", new ValColor("请按时完成待办工作。","#4A4AFF"));//备注值
	        //发送消息
	        rst = cRMService.getDbService().getTemplateMsgService().sendToDoWorkMsg(openId, topcolor, url, map);
	        logger.info(rst.getString("errcode"));
	        
			return "success";
		}
}
