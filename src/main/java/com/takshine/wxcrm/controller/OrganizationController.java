package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.service.OrganizationService;

/**
 * 组织 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/org")
public class OrganizationController {
	    // 日志
		protected static Logger logger = Logger.getLogger(OrganizationController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 * 获取 组织数据 列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/list")
		public String list(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("OrganizationController list method begin=>");
			String name = request.getParameter("name");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
	        currpage = (null == currpage ? "0" : currpage);
	        pagecount = (null == pagecount ? "10" : pagecount);
			logger.info("name := >" + name);
			//组装查询参数
			Organization obj = new Organization();
			obj.setName(name);
			obj.setCurrpages(Integer.parseInt(currpage));
			obj.setPagecounts(Integer.parseInt(pagecount));
			//调用后台查询数据库
			List<Organization> orgList = (List<Organization>)cRMService.getDbService().getOrganizationService().findObjListByFilter(obj);
			request.setAttribute("orgList", orgList);
			return "org/list";
		}
		
		/**
		 * 组织 详情
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/detail")
		public String detail(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String name = request.getParameter("name");
			Organization org = new Organization();
			org.setName(name);
			Organization rst = (Organization)cRMService.getDbService().getOrganizationService().findObj(org);
			request.setAttribute("org", rst);
			return "org/detail";
		}
		
		/**
		 *  新增 组织
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/get")
		public String get(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			
			return "org/add";
		}
		
		/**
		 *  保存 组织
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save")
		public String save(Organization org, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			//save
			String id = cRMService.getDbService().getOrganizationService().addObj(org);
			logger.info("OrganizationController save method id =>" + id);
			return id;
		}
		
		/**
		 *  保存 组织
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/del")
		@ResponseBody
		public String del(Organization org, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String id = request.getParameter("id");
			//删除
			cRMService.getDbService().getOrganizationService().deleteObjById(id);
			logger.info("OrganizationController del success =>");
			return "success";
		}
		
}
