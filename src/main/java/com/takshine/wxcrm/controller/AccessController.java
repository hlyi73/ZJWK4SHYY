/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.AccesslogAdd;
import com.takshine.wxcrm.message.sugar.AccesslogResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.AccessLogsService;

/**
 * 文章信息 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/access")
public class AccessController {
	// 日志
	protected static Logger logger = Logger
			.getLogger(AccessController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/total")
	public String accessCount(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String weekly = request.getParameter("weekly");
		weekly = (null == weekly ? "curr":weekly);
		String type = request.getParameter("type");
		type = (null == type ? "day" : type);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		StringBuffer dim = new StringBuffer();
		StringBuffer fact = new StringBuffer();
		
		String startDate = null,endDate = null;
		Calendar calendar=Calendar.getInstance(Locale.CHINA);
		if(null == weekly || "curr".equals(weekly)){
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			startDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
			calendar.add(Calendar.WEEK_OF_YEAR, 1);
			endDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
		}else{
			calendar.add(Calendar.DATE, -1 * 7);
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			startDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
			calendar.add(Calendar.WEEK_OF_YEAR, 1);
			endDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
		}
		
		List<AccessLogs> accessList = null;
		if(null != type && ("day".equals(type) || "module".equals(type))){
			accessList = cRMService.getDbService().getAccessLogsService().countAccessLogs(openId,startDate, endDate, type);
			if(null != accessList && accessList.size() >0){
				//日访问
				if(null != type && "day".equals(type)){
					AccessLogs log = null;
					for(int i=0;i<accessList.size();i++){
						log = accessList.get(i);
						dim.append("'"+log.getStartDate()+"'");
						fact.append(log.getAccessCount());
						if(i<accessList.size() - 1){
							dim.append(",");
							fact.append(",");
						}
					}
				}
				//模块访问
				else if(null != type && "module".equals(type)){
					List<String> dateList = new ArrayList<String>();
					List<String> moduleList = new ArrayList<String>();
					Map<String,Integer> map = new HashMap<String, Integer>();
					AccessLogs log = null;
					//获取日期及模块
					for(int i=0;i<accessList.size();i++){
						log = accessList.get(i);
						if(!dateList.contains(log.getStartDate())){
							dateList.add(log.getStartDate());
							if("".equals(dim.toString())){
								dim.append("'"+log.getStartDate()+"'");
							}else{
								dim.append(",'").append(log.getStartDate()+"'");
							}
						}
						if(!moduleList.contains(log.getAccessModule())){
							moduleList.add(log.getAccessModule());
						}
						map.put(log.getStartDate()+"_"+log.getAccessModule(), Integer.valueOf(log.getAccessCount()));
					}
					
					//拼装数据
					for(int i=0;i<moduleList.size();i++){
						if("".equals(fact.toString())){
							fact.append("{name:'").append(moduleList.get(i)).append("',");
						}else{
							fact.append(",").append("{name:'").append(moduleList.get(i)).append("',");
						}
						fact.append("data:[");
						for(int j=0;j<dateList.size();j++){
							if(j != 0){
								fact.append(",");
							}
							if(map.containsKey(dateList.get(j) +"_"+moduleList.get(i))){
								fact.append(map.get(dateList.get(j) +"_"+moduleList.get(i)));
							}else{
								fact.append("0");
							}
						}
						fact.append("]}");
					}
				}
				request.setAttribute("dim", dim.toString());
				request.setAttribute("fact", fact.toString());
			}else{
				request.setAttribute("flag", "nodata");
			}
		}
			//用户访问
			else if(null != type && "user".equals(type)){
				List<AccessLogs> logs = new ArrayList<AccessLogs>();
				accessList = cRMService.getDbService().getAccessLogsService().countAccessLogs(openId,startDate, endDate, "top5");
				logs.addAll(accessList);
				request.setAttribute("logs", JSONArray.fromObject(logs));
			}
		request.setAttribute("type", type);
		request.setAttribute("weekly", weekly);
		return "access/access";
	}

	
	
	/**
	 * 查询 用户行为 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addlist")
	@ResponseBody
	public String addlist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String str = "";
		//查询参数
		String weekly = request.getParameter("weekly");
		weekly = (null == weekly ? "curr":weekly);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		//error 对象
		CrmError crmErr = new CrmError();
		//判断crmId是否为空
		if(null != crmId && !"".equals(crmId)){
			String startDate = null,endDate = null;
			Calendar calendar=Calendar.getInstance(Locale.CHINA);
			if(null == weekly || "curr".equals(weekly)){
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
				startDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
				calendar.add(Calendar.WEEK_OF_YEAR, 1);
				endDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
			}else{
				calendar.add(Calendar.DATE, -1 * 7);
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
				startDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
				calendar.add(Calendar.WEEK_OF_YEAR, 1);
				endDate = DateTime.date2Str(calendar.getTime(),"yyyy-MM-dd");
			}
			
			AccessLogs sche = new AccessLogs();
			sche.setCrmId(crmId);
			sche.setStartDate(startDate);
			sche.setEndDate(endDate);
			// 查询返回结果
			AccesslogResp cResp = cRMService.getDbService().getAccessLogsService().addcountAccessLogs(sche,"WX");
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<AccesslogAdd> cList = cResp.getAccesslog();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
				crmErr.setErrorCode(cResp.getErrcode());
				crmErr.setErrorMsg(cResp.getErrmsg());
			}
		}else {
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
}