package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.model.UserExperience;
import com.takshine.wxcrm.service.UserExperienceService;

/**
 * 用户履历
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/userExperience")
public class UserExperienceController{
	// 日志
	protected static Logger log = Logger.getLogger(UserExperienceController.class.getName());
			
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询用户履历
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String userId = "";//获取userId >>> FuncManage.getUserId(request);
		log.info("userId =>" + userId);
		String type = request.getParameter("type");
		log.info("type =>" + type);
		
		UserExperience userExperi = new UserExperience();
		userExperi.setUser_id(userId);
		userExperi.setType(type);
		userExperi.setCurrpage("0");
		userExperi.setPagecount("999");
		request.setAttribute("type", type);
		request.setAttribute("exprilist", cRMService.getDbService().getUserExperienceService().findObjListByFilter(userExperi));
		return "experi/list";
	}
	
	/**
	 * 异步查询用户履历
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asycnlist")
	@ResponseBody
	public String asycnlist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String userId = request.getParameter("userId");
		log.info("userId =>" + userId);
		String type = request.getParameter("type");
		log.info("type =>" + type);
		
		UserExperience userExperi = new UserExperience();
		userExperi.setUser_id(userId);
		userExperi.setType(type);
		
		//调用后台查询数据库
		@SuppressWarnings("unchecked")
		List<UserExperience> experilist = (List<UserExperience>)cRMService.getDbService().getUserExperienceService().findObjListByFilter(userExperi);
		String rst = "[]";
		// 放到页面上
		if (null != experilist && experilist.size() > 0) {
			rst = JSONArray.fromObject(experilist).toString();
		}
		log.info("rst = >" + rst);
		return rst;
	}
	
	/**
	 * 添加履历
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/add")
	public String add(UserExperience experi, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String userId = "";//获取userId >>> FuncManage.getUserId(request);
		log.info("userId =>" + userId);
		//类别
		String type = request.getParameter("type");
		String id = request.getParameter("id");
		if(StringUtils.isNotBlank(id)){
			UserExperience userExperi = new UserExperience();
			userExperi.setUser_id(userId);
			userExperi.setType(type);
			userExperi.setId(id);
			@SuppressWarnings("unchecked")
			List<UserExperience> list = (List<UserExperience>)cRMService.getDbService().getUserExperienceService().findObjListByFilter(userExperi);
			if(list!=null&&list.size()>0){
				request.setAttribute("userExperi", list.get(0));
			}
			log.info("id =>"+id);
		}
		request.setAttribute("id", id);
		log.info("type =>" + type);
		if("work".equals(type)){
			return "experi/addwork";
		}else{
			return "experi/addedu";
		}
	}
	
	/**
	 * 查询用户履历
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	public String save(UserExperience experi, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String start_date = experi.getStart_date();
		String end_date = experi.getEnd_date();
		if("".equals(start_date)) experi.setStart_date(null);
		if("".equals(end_date)) experi.setEnd_date(null);
		
		String userId = "";//获取userId >>> FuncManage.getUserId(request);
		String id = request.getParameter("rowid");
		log.info("userId =>" + userId);
		experi.setUser_id(userId);
		if(StringUtils.isNotBlank(id)){
			experi.setId(id);
			cRMService.getDbService().getUserExperienceService().updateObj(experi);
		}else{
			cRMService.getDbService().getUserExperienceService().addObj(experi);
		}
		return "redirect:/userExperience/list?type=" + experi.getType();
	}
	
	/**
	 * 删除用户履历
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/del")
	@ResponseBody
	public String del(UserExperience experi, HttpServletRequest request, HttpServletResponse response) throws Exception{
		log.info("del = >");
		String id = request.getParameter("id");
		       id = (id == null) ? "-1": id;
		log.info("id = >" + id);
		cRMService.getDbService().getUserExperienceService().deleteObjById(id);
		return "success";
	}
}
