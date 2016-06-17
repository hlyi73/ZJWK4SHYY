package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.Message;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.service.MessagesService;

/**
 * 消息  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/msg")
public class MessageController {
	    // 日志
		protected static Logger logger = Logger.getLogger(MessageController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 * 异步获取 消息数据 列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/asynclist")
		@ResponseBody
		public String asynclist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("MessageController asynclist method begin=>");
			String relaModule = request.getParameter("relaModule");
			String relaId = request.getParameter("relaId");
			String subRelaId = request.getParameter("subRelaId");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			       currpage = (null == currpage ? "1" : currpage);
			       pagecount = (null == pagecount ? "10" : pagecount);
			       
			logger.info("relaModule := >" + relaModule);
			logger.info("relaId := >" + relaId);
			logger.info("subRelaId := >" + subRelaId);
			//组装查询参数
			Messages obj = new Messages();
			obj.setRelaModule(relaModule);
			obj.setRelaId(relaId);
			obj.setSubRelaId(subRelaId);
			obj.setCurrpage(currpage);
			obj.setPagecount(pagecount);
			//调用后台查询数据库
			List<Messages> mlist = (List<Messages>)cRMService.getDbService().getMessageService().findObjListByFilter(obj);
			String rst = "[]";
			// 放到页面上
			if (null != mlist && mlist.size() > 0) {
				rst = JSONArray.fromObject(mlist).toString();
			}
			return rst;
		}
		
		/**
		 *  新增 消息
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save")
		@ResponseBody
		public String save(Message msg, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("MessageController save method id =>" + msg.getId());
			
			msg.setId(Get32Primarykey.getRandom32BeginTimePK());
			msg.setCrmId("5da1ce9f-74b5-d233-c286-51c64d153d5a");
			msg.setMsgType("01");
			msg.setLastTime(DateTime.currentDate());
			//save
			cRMService.getDbService().getMessageService().addObj(msg);
			
			return "success";
		}
}
