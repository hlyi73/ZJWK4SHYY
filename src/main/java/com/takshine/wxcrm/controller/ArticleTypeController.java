/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.domain.ArticleType;
import com.takshine.wxcrm.service.ArticleTypeService;

/**
 * 文章类别   页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/articleType")
public class ArticleTypeController {
	// 日志
	protected static Logger logger = Logger.getLogger(ArticleTypeController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		List<ArticleType> artTypeList = cRMService.getDbService().getArticleTypeService().findArticleTypeByFilter(null);
		for (int i = 0; i < artTypeList.size(); i++) {
			System.out.println(artTypeList.get(i).getName());
		}
		return null;
	}
	
	@RequestMapping("/asynlist")
	@ResponseBody
	public String asynlist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		List<ArticleType> artTypeList = cRMService.getDbService().getArticleTypeService().findArticleTypeByFilter(null);
		return JSONArray.fromObject(artTypeList).toString();
	}

	
}
