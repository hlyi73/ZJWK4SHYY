package com.takshine.wxcrm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.service.TagService;

/**
 * 标签
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/tag")
public class TagController {
	// 日志
	protected static Logger log = Logger.getLogger(TagController.class.getName());
			
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 查询标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	@ResponseBody
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("TagController list  begin=>");
		String userId = "";//FuncManage.getUserId(request);
		log.info("TagController userId =>" + userId);
		//TODO
		
		return "[]";
	}
	
	/**
	 * 新增标签
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("TagController list  begin=>");
/*		String userId = FuncManage.getUserId(request);
		log.info("TagController userId =>" + userId);
		//TODO
*/		
		return "success";
	}
}
