package com.takshine.wxcrm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 日程  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/baidu")
public class BaiduRouteController {
	    // 日志
		protected static Logger logger = Logger.getLogger(BaiduRouteController.class.getName());
		

		/**
	     * 路径
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/route")
	    public String route(HttpServletRequest request, HttpServletResponse response) throws Exception{
	    	return "baidu/route";
	    	//获取请求参数
		}
		
		/**
	     * 路径
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/place")
	    public String place(HttpServletRequest request, HttpServletResponse response) throws Exception{
	    	return "baidu/place";
	    	//获取请求参数
		}
}
