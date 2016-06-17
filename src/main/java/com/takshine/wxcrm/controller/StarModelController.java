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
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Star;
import com.takshine.wxcrm.service.StarModelService;

/**
 * 模块与星标关联
 * 
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/starModel")
public class StarModelController {
	// 日志
		protected static Logger log = Logger.getLogger(ModelTagController.class
				.getName());

		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 * 查询 模块里的星标记录
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/isStar")
		@ResponseBody
		public String isStar(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			log.info("starSingel start = > ");
			String parentType = request.getParameter("parentType");
			
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			String rst = "";
			if(null == crmId || "".equals(crmId)){
				rst = "-1";
			}else{
				Star st = new Star();
				st.setCrmId(crmId);
				st.setParentType(parentType);
				List<Star> starlist = cRMService.getDbService().getStarModelService().findStarModelById(st);
				if(null != starlist && starlist.size() > 0){
					rst =  JSONArray.fromObject(starlist).toString();
				}
			}
			log.info("StarMondelController ----- isStar => " +rst);
			return rst;
		}
		
		
		/**
		 * 保存标签
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/save")
		@ResponseBody
		public String save(HttpServletRequest request, HttpServletResponse response) throws Exception{
			log.info("starModelController save  =>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String crmId =UserUtil.getCurrUser(request).getCrmId();

			if(null == crmId || "".equals(crmId)){
				return "fail";
			}
			
			String parentId = request.getParameter("parentId"); parentId = (parentId == null) ? "" : parentId;
			String parentType = request.getParameter("parentType");parentType = (parentType == null) ? "":parentType;
			log.info("parentId = >" + parentId);
			log.info("parentType  = >" + parentType);
			
			Star st = new Star();
			st.setParentId(parentId);
			st.setParentType(parentType);
			st.setOpenId(openId);
			st.setCrmId(crmId);
			st.setId(Get32Primarykey.getRandom32PK());

			cRMService.getDbService().getStarModelService().saveStar(st);
			
			return "success";
		}
		
		/**
		 * 删除星标
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/delStar")
		@ResponseBody
		public String delStar(HttpServletRequest request, HttpServletResponse response) throws Exception{
			log.info("starModelController delete  =>");
			
			String crmId = UserUtil.getCurrUser(request).getCrmId();

			if(null == crmId || "".equals(crmId)){
				return "fail";
			}
			
			String parentId = request.getParameter("parentId"); parentId = (parentId == null) ? "" : parentId;
			String parentType = request.getParameter("parentType");parentType = (parentType == null) ? "":parentType;
			log.info("parentId = >" + parentId);
			log.info("parentType  = >" + parentType);
			
			Star st = new Star();
			st.setParentId(parentId);
			st.setParentType(parentType);
			st.setCrmId(crmId);
			cRMService.getDbService().getStarModelService().delStar(st);
			return "success";
		}
}
