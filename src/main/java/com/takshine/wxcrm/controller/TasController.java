package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Tas;
import com.takshine.wxcrm.message.sugar.TasAdd;
import com.takshine.wxcrm.message.sugar.TasResp;
import com.takshine.wxcrm.message.sugar.TasValueAdd;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.Tas2SugarService;


/**
 * tas销售方法论  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/tas")
public class TasController {
	// 日志
	protected static Logger logger = Logger.getLogger(TasController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
     * 获取价值主张
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/getval")
    public String getval(HttpServletRequest request, HttpServletResponse response) throws Exception{
		//openId appId
		String pagename = request.getParameter("pagename");
		if(StringUtils.isNotNullOrEmptyStr(pagename)&&!StringUtils.regZh(pagename)){
			pagename = new String(pagename.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = request.getParameter("crmId");
		String rowId = request.getParameter("rowId");//业务机会ID
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("TasController getevt method pagename =>" + pagename);
		logger.info("TasController getevt method crmId =>" + crmId);
		logger.info("TasController getevt method rowId =>" + rowId);
		logger.info("TasController getevt method openId =>" + openId);
		logger.info("TasController getevt method publicId =>" + publicId);
		
		//查询 强制性事件
		TasResp r = cRMService.getSugarService().getTas2SugarService().searchVal(crmId, rowId);
		List<TasValueAdd> tasValueList = (List<TasValueAdd>)r.getTasValueList();
		if(null == tasValueList) tasValueList = new ArrayList<TasValueAdd>();
		
		//request info 
		request.setAttribute("tasValueList", tasValueList);
		request.setAttribute("pagename", pagename);
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("orgId", request.getParameter("orgId"));
		return "oppty/tas/addval";
	}
	
	/**
	 * 保存价值主张
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveval")
	public String saveval(Tas s, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String dataColl = request.getParameter("dataColl");
		String rowId = request.getParameter("rowId");//业务机会ID
		String crmId = request.getParameter("crmId");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("TasController saveval method dataColl =>" + dataColl);
		logger.info("TasController saveval method rowId =>" + rowId);
		logger.info("TasController saveval method crmId =>" + crmId);
		logger.info("TasController saveval method openId =>" + openId);
		logger.info("TasController saveval method publicId =>" + publicId);
		
		if(null != dataColl && !"".equals(dataColl)){
			cRMService.getSugarService().getTas2SugarService().updateVal(crmId, rowId, dataColl);
		}
		//跳转到业务机会详情
		return "redirect:/oppty/detail?openId="+ openId + "&publicId="+ publicId + "&rowId=" + rowId+"&orgId="+request.getParameter("orgId");
	}
	
	/**
	 * 获取强制性事件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getevt")
	public String getevt(Tas obj, HttpServletRequest request, HttpServletResponse response) throws Exception{
		//openId appId
		String pagename = request.getParameter("pagename");
		if(StringUtils.isNotNullOrEmptyStr(pagename)&&!StringUtils.regZh(pagename)){
			pagename = new String(pagename.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = request.getParameter("crmId");
		String rowId = request.getParameter("rowId");//业务机会ID
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("TasController getevt method pagename =>" + pagename);
		logger.info("TasController getevt method crmId =>" + crmId);
		logger.info("TasController getevt method rowId =>" + rowId);
		logger.info("TasController getevt method openId =>" + openId);
		logger.info("TasController getevt method publicId =>" + publicId);
		
		//查询 强制性事件
		TasResp r = cRMService.getSugarService().getTas2SugarService().searchEvt(crmId, rowId);
		List<TasAdd> tasList = (List<TasAdd>)r.getTasList();
		if(null == tasList) tasList = new ArrayList<TasAdd>();
		
		//request info 
		request.setAttribute("tasList", tasList);
		request.setAttribute("pagename", pagename);
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("orgId", request.getParameter("orgId"));
		return "oppty/tas/addevt";
	}
	
	/**
	 * 保存强制性事件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveevt")
	public String saveevt(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String dataColl = request.getParameter("dataColl");
		String rowId = request.getParameter("rowId");//业务机会ID
		String crmId = request.getParameter("crmId");
		logger.info("TasController getevt method openId =>" + openId);
		logger.info("TasController getevt method publicId =>" + publicId);
		logger.info("TasController getevt method dataColl =>" + dataColl);
		logger.info("TasController getevt method rowId =>" + rowId);
		logger.info("TasController getevt method crmId =>" + crmId);
		
		if(null != dataColl && !"".equals(dataColl)){
			cRMService.getSugarService().getTas2SugarService().updateEvt(crmId, rowId, dataColl);
		}
		//跳转到业务机会详情
		return "redirect:/oppty/detail?openId="+ openId + "&publicId="+ publicId + "&rowId=" + rowId+"&orgId="+request.getParameter("orgId");
	}
	
	/**
	 * 获取竞争策略
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getsgy")
	public String getsgy(HttpServletRequest request, HttpServletResponse response) throws Exception{
		//openId appId
		String pagename = request.getParameter("pagename");
		if(StringUtils.isNotNullOrEmptyStr(pagename)&&!StringUtils.regZh(pagename)){
			pagename = new String(pagename.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = request.getParameter("crmId");
		String rowId = request.getParameter("rowId");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String competitive = request.getParameter("competitive");
		logger.info("TasController getsgy method pagename =>" + pagename);
		logger.info("TasController getsgy method crmId =>" + crmId);
		logger.info("TasController getsgy method rowId =>" + rowId);
		
		//获取竞争策略
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("strategyList", mp.get("competitive_list"));//竞争策略列表
		
		request.setAttribute("pagename", pagename);
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("competitive", competitive);
		request.setAttribute("orgId", request.getParameter("orgId"));
		return "oppty/tas/addsgy";
	}
	
	
	/**
	 * 保存竞争策略
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savesgy")
	public String savesgy(Opportunity obj, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = obj.getOpenId();
		String publicId = obj.getPublicId();
		String rowId = obj.getRowId();
		logger.info("TasController savesgy method openId =>" + openId);
		logger.info("TasController savesgy method publicId =>" + publicId);
		logger.info("TasController savesgy method rowId =>" + rowId);
		//调用后台接口修改业务机会跟进的过程
		this.cRMService.getSugarService().getTas2SugarService().updateSgy(obj);
		//跳转到业务机会详情
		return "redirect:/oppty/detail?openId="+ openId + "&publicId="+ publicId + "&rowId=" + rowId+"&orgId="+obj.getOrgId();
	}

}
