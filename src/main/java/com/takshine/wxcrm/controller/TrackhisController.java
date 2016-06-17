package com.takshine.wxcrm.controller;

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
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.service.TrackhisService;

/**
 * 用户和手机关联关系 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/trackhis")
public class TrackhisController {
	// 日志
	protected static Logger log = Logger.getLogger(TrackhisController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 跟进历史 列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asycnlist")
	@ResponseBody
	public String list(Trackhis his, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("TrackhisController asycnlist");
		Trackhis rst = cRMService.getSugarService().getTrackhisService().getTrackhisList(his);
		return JSONArray.fromObject(rst.getHis()).toString(); 
	}
}
