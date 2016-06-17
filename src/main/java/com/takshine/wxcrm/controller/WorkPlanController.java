package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Comments;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.WorkReport;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 工作计划
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/workplan")
public class WorkPlanController {
	
	protected static Logger logger = Logger.getLogger(WorkPlanController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 工作计划列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//验证用户是否有权限访问
		List<Organization> orgList = cRMService.getDbService().getWorkPlanService().getCrmIdAndOrgIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		//如果没有绑定企业，则返回错误
		if(null == orgList || orgList.size() == 0){
			throw new Exception(ErrCode.ERR_CODE_AUTH_INVALID);
		}
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		//前台页面传过来的查询条件
		String viewtype = request.getParameter("viewtype");
		String status = request.getParameter("status");
		String type = request.getParameter("type");
		String orderByString = request.getParameter("orderString");
		orderByString = (null == orderByString ? "dcdate" : orderByString);
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");
		String assignerId = request.getParameter("assignerId");
		assignerId = StringUtils.isNotNullOrEmptyStr(assignerId)?assignerId:"";
		String addAssigner = request.getParameter("addAssigner");
		String orgId = request.getParameter("orgId");
		String flag = request.getParameter("flag");
		logger.info("WorkPlanController list partyId ===>"+partyId);
		logger.info("WorkPlanController list openId ===>"+openId);
		logger.info("WorkPlanController list viewtype ===>"+viewtype);
		logger.info("WorkPlanController list status ===>"+status);
		logger.info("WorkPlanController list type ===>"+type);
		logger.info("WorkPlanController list orderByString ===>"+orderByString);
		logger.info("WorkPlanController list start_date ===>"+start_date);
		logger.info("WorkPlanController list end_date ===>"+end_date);
		logger.info("WorkPlanController list orgId ===>"+orgId);
		WorkReport workReport = new WorkReport();
		//通用的查询参数
		workReport.setStatus(status);
		workReport.setType(type);
		if(StringUtils.isNotNullOrEmptyStr(start_date)){
			workReport.setStart_date(start_date);
		}
		if(StringUtils.isNotNullOrEmptyStr(end_date)){
			workReport.setEnd_date(end_date);
		}
		workReport.setViewtype(viewtype);
		workReport.setOpenId(openId);
		workReport.setCurrpages(0);
		workReport.setPagecounts(999999);
		workReport.setOrgId(orgId);
		if("acdate".equals(orderByString)){
			workReport.setOrderByString(" create_time asc ");
		}else if("aname".equals(orderByString)){
			workReport.setOrderByString(" assigner_id asc ");
		}else{
			workReport.setOrderByString(" create_time desc ");
		}
		workReport.setPagecounts(Constants.ALL_PAGECOUNT);
		String rowids = "";
		//页面查询
		if(StringUtils.isNotNullOrEmptyStr(flag)){
			//我的工作计划
			if(Constants.SEARCH_VIEW_TYPE_MYVIEW.equals(viewtype)){
				workReport.setAssigner_id(partyId);
				List<WorkReport> wReportList =  cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
				request.setAttribute("myWorkPlanList", wReportList);
				for(WorkReport wReport:wReportList){
					String id = wReport.getId();
					rowids += id + ",";
				}
				RedisCacheUtil.setString("ZJWK_WORKPLAN_SEARCH_RECORDLIST_OWNER_"+partyId, rowids);
			}else if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//我下属的
				List<WorkReport> wReportList = new ArrayList<WorkReport>();
				if(StringUtils.isNotNullOrEmptyStr(assignerId)){
					String[] assids = assignerId.split(",");
					List<String> assList = new ArrayList<String>();
					for(int i=0;i<assids.length;i++){
						assList.add(assids[i]);
					}
					workReport.setAssignid_in(assList);
					workReport.setAssigner_id("");
					wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
					request.setAttribute("myBranchWorkPlanList", wReportList);
				}else{
					//默认查询我下属的工作计划
					UserReq uReq = new UserReq();
					uReq.setCurrpage("1");
					uReq.setPagecount("1000");
					uReq.setOpenId(openId);
					uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
					UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
					if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
						for(UserAdd userAdd:uResp.getUsers()){
							String userid = userAdd.getUserid();
							assignerId += userid+",";
						}
					}
					if(StringUtils.isNotNullOrEmptyStr(assignerId)){
						String[] assids = assignerId.split(",");
						List<String> assList = new ArrayList<String>();
						for(int i=0;i<assids.length;i++){
							assList.add(assids[i]);
						}
						workReport.setAssignid_in(assList);
						workReport.setAssigner_id("");
						wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
						request.setAttribute("myBranchWorkPlanList", wReportList);
						assignerId="";
					}
				}
				for(WorkReport wReport:wReportList){
					String id = wReport.getId();
					rowids += id + ",";
				}
				RedisCacheUtil.setString("ZJWK_WORKPLAN_SEARCH_RECORDLIST_MYBRANCH_"+partyId, rowids);
			}else{
				//查询我的工作计划
				workReport.setAssigner_id(partyId);
				List<WorkReport> wReportList = new ArrayList<WorkReport>();
				wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
				request.setAttribute("myWorkPlanList", wReportList);
				for(WorkReport wReport:wReportList){
					String id = wReport.getId();
					rowids += id + ",";
				}
				RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_OWNER_"+partyId, rowids);
				//查询我下属的工作计划
				UserReq uReq = new UserReq();
				uReq.setCurrpage("1");
				uReq.setPagecount("1000");
				uReq.setOpenId(openId);
				uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
					for(UserAdd userAdd:uResp.getUsers()){
						String userid = userAdd.getUserid();
						assignerId += userid+",";
					}
				}
				rowids="";
				if(StringUtils.isNotNullOrEmptyStr(assignerId)){
					String[] assids = assignerId.split(",");
					List<String> assList = new ArrayList<String>();
					for(int i=0;i<assids.length;i++){
						assList.add(assids[i]);
					}
					workReport.setAssignid_in(assList);
					workReport.setAssigner_id("");
					wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
					request.setAttribute("myBranchWorkPlanList", wReportList);
					for(WorkReport wReport:wReportList){
						String id = wReport.getId();
						rowids += id + ",";
					}
					RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_MYBRANCH_"+partyId, rowids);
				}
				//查询分享给我的工作计划
				List<String> rowid_in = new ArrayList<String>();
				TeamPeason team = new TeamPeason();
				team.setOpenId(openId);
				List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
				for(TeamPeason teampeoson : list){
					String rowid = teampeoson.getRelaId();
					rowid_in.add(rowid);	
				}
				//查询后台团队
				List<String> crmIds = cRMService.getDbService().getWorkPlanService().getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
				for (int i = 0; i < crmIds.size(); i++) {
					String crmid = crmIds.get(i);
					//查询列表
					Share sc = new Share();
					sc.setCrmId(crmid);
					sc.setParenttype("WorkReport");
					ShareResp scResp = cRMService.getSugarService().getShare2SugarService().getShareRecordList(sc);
					List<ShareAdd> respList = scResp.getShares();
					for (int j = 0; j < respList.size(); j++) {
						ShareAdd sa = respList.get(j);
						String rowid = sa.getParentid();
						rowid_in.add(rowid);
					}
				}
				rowids="";
				if(rowid_in.size()>0){
					workReport.setRowid_in(rowid_in);
					workReport.setAssigner_id("");
					workReport.setAssignid_in(null);
					List<WorkReport> list1 = new ArrayList<WorkReport>();
					for(WorkReport w : wReportList){
						String assigner = w.getAssigner_id();
						if(!partyId.equals(assigner)){
							list1.add(w);
							rowids += w.getId() + ",";
						}
					}	
					RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_SHARE_"+partyId, rowids);
					request.setAttribute("shareWorkPlanList", list1);
				}
			}
		}else{//默认进来的
			//查询我的工作计划
			workReport.setAssigner_id(partyId);
			List<WorkReport> wReportList = new ArrayList<WorkReport>();
			wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
			request.setAttribute("myWorkPlanList", wReportList);
			for(WorkReport wReport:wReportList){
				String id = wReport.getId();
				rowids += id + ",";
			}
			RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_OWNER_"+partyId, rowids);
			//查询我直接下属的工作计划
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setOpenId(openId);
			uReq.setFlag("direct_subordinates");
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
				for(UserAdd userAdd:uResp.getUsers()){
					String userid = userAdd.getUserid();
					assignerId += userid+",";
				}
			}
			rowids="";
			if(StringUtils.isNotNullOrEmptyStr(assignerId)){
				String[] assids = assignerId.split(",");
				List<String> assList = new ArrayList<String>();
				for(int i=0;i<assids.length;i++){
					assList.add(assids[i]);
				}
				workReport.setAssignid_in(assList);
				workReport.setAssigner_id("");
				long l = System.currentTimeMillis();
				wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
				long e  = System.currentTimeMillis();
				logger.info("workplan seacr time =======>>>>>"+(e-l));
				request.setAttribute("myBranchWorkPlanList", wReportList);
				for(WorkReport wReport:wReportList){
					String id = wReport.getId();
					rowids += id + ",";
				}
				RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_MYBRANCH_"+partyId, rowids);
				assignerId = "";
			}
			//查询分享给我的工作计划
			List<String> rowid_in = new ArrayList<String>();
			//查询teampeoson表
			TeamPeason team = new TeamPeason();
			team.setOpenId(openId);
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				rowid_in.add(rowid);	
			}
			//查询后台团队
			List<String> crmIds = cRMService.getDbService().getWorkPlanService().getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i);
				//查询列表
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("WorkReport");
				ShareResp scResp = cRMService.getSugarService().getShare2SugarService().getShareRecordList(sc);
				List<ShareAdd> respList = scResp.getShares();
				for (int j = 0; j < respList.size(); j++) {
					ShareAdd sa = respList.get(j);
					String rowid = sa.getParentid();
					rowid_in.add(rowid);
				}
			}
			rowids="";
			if(rowid_in.size()>0){
				workReport.setRowid_in(rowid_in);
				workReport.setAssigner_id("");
				workReport.setAssignid_in(null);
				wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
				List<WorkReport> list1 = new ArrayList<WorkReport>();
				for(WorkReport w : wReportList){
					String assigner = w.getAssigner_id();
					if(!partyId.equals(assigner)){
						list1.add(w);
						String id = w.getId();
						rowids += id + ",";
					}
				}	
				RedisCacheUtil.setString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_SHARE_"+partyId, rowids);
				request.setAttribute("shareWorkPlanList", list1);
			}
		}
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("type", type);
		request.setAttribute("showflag", flag);
		request.setAttribute("status", status);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("start_date", start_date);
		request.setAttribute("end_date", end_date);
		request.setAttribute("orderByString", orderByString);
		request.setAttribute("orgId", orgId);
		return "workplan/list";
	}
	
	/**
	 * 工作计划列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/searchWorkPlan")
	public String searchWorkPlan(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//验证用户是否有权限访问
		List<Organization> orgList = cRMService.getDbService().getWorkPlanService().getCrmIdAndOrgIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		//如果没有绑定企业，则返回错误
		if(null == orgList || orgList.size() == 0){
			throw new Exception(ErrCode.ERR_CODE_AUTH_INVALID);
		}
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		//前台页面传过来的查询条件
		String viewtype = request.getParameter("viewtype");
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = Constants.SEARCH_VIEW_TYPE_MYVIEW;
		}
		String status = request.getParameter("status");
		String type = request.getParameter("type");
		String orderByString = request.getParameter("orderString");
		orderByString = (null == orderByString ? "dcdate" : orderByString);
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		logger.info("WorkPlanController list partyId ===>"+partyId);
		logger.info("WorkPlanController list openId ===>"+openId);
		logger.info("WorkPlanController list viewtype ===>"+viewtype);
		logger.info("WorkPlanController list status ===>"+status);
		logger.info("WorkPlanController list type ===>"+type);
		logger.info("WorkPlanController list orderByString ===>"+orderByString);
		logger.info("WorkPlanController list start_date ===>"+start_date);
		logger.info("WorkPlanController list end_date ===>"+end_date);
		//查询我的工作计划
		WorkReport workReport = new WorkReport();
		if(Constants.SEARCH_VIEW_TYPE_MYVIEW.equals(viewtype)){
			workReport.setAssigner_id(partyId);
		}else{
			if(StringUtils.isNotNullOrEmptyStr(assignerId)){
				String[] assids = assignerId.split(",");
				List<String> assList = new ArrayList<String>();
				for(int i=0;i<assids.length;i++){
					assList.add(assids[i]);
				}
				workReport.setAssignid_in(assList);
			}
		}
		workReport.setStatus(status);
		workReport.setType(type);
		if(StringUtils.isNotNullOrEmptyStr(start_date)){
			workReport.setStart_date(start_date);
		}
		if(StringUtils.isNotNullOrEmptyStr(end_date)){
			workReport.setEnd_date(end_date);
		}
		workReport.setViewtype(viewtype);
		workReport.setOpenId(openId);
		if("acdate".equals(orderByString)){
			workReport.setOrderByString(" create_time asc ");
		}else if("aname".equals(orderByString)){
			workReport.setOrderByString(" assigner_id asc ");
		}else{
			workReport.setOrderByString(" create_time desc ");
		}
		workReport.setPagecounts(Constants.ALL_PAGECOUNT);
		List<WorkReport> wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
		if(null == wReportList || wReportList.size() == 0){
			wReportList = new ArrayList<WorkReport>();
		}
		request.setAttribute("list", wReportList);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("type", type);
		request.setAttribute("status", status);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("start_date", start_date);
		request.setAttribute("end_date", end_date);
		request.setAttribute("orderByString", orderByString);
		return "workplan/list";
	}
	
	@RequestMapping("/listbak")
	public String listbak(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//前台页面传过来的查询条件
		String viewtype = request.getParameter("viewtype");
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = Constants.SEARCH_VIEW_TYPE_MYVIEW;
		}
		String status = request.getParameter("status");
		String type = request.getParameter("type");
		String orderByString = request.getParameter("orderString");
		logger.info("WorkPlanController list partyId ===>"+partyId);
		logger.info("WorkPlanController list openId ===>"+openId);
		logger.info("WorkPlanController list viewtype ===>"+viewtype);
		logger.info("WorkPlanController list status ===>"+status);
		logger.info("WorkPlanController list type ===>"+type);
		logger.info("WorkPlanController list orderByString ===>"+orderByString);
		List<WorkReport> wList = new ArrayList<WorkReport>(); 
		List<WorkReport> tList = new ArrayList<WorkReport>(); 
		List<WorkReport> wReportList = new ArrayList<WorkReport>();
		//查询我的工作计划
		WorkReport workReport = new WorkReport();
		workReport.setAssigner_id(partyId);
		workReport.setStatus(status);
		workReport.setType(type);
		if(StringUtils.isNotNullOrEmptyStr(orderByString)){
			String day = DateTime.getWeekDay(orderByString, DateTime.DateFormat1);
			String start_date = day.split(";")[0];
			String end_date = day.split(";")[1];
			workReport.setStart_date(start_date);
			workReport.setEnd_date(end_date);
		}
		
		if("myview".equals(viewtype)){
			wList = (List<WorkReport>)cRMService.getDbService().getWorkPlanService().findObjListByFilter(workReport);
			wReportList.addAll(wList);
		}else if("shareview".equals(viewtype)){
			//查询分享给我的工作计划
			TeamPeason team = new TeamPeason();
			team.setOpenId(openId);
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				logger.info("WorkPlanController list rowid ===>" + rowid);
				WorkReport wReport = (WorkReport)cRMService.getDbService().getWorkPlanService().findObjById(rowid);
				if(null!=wReport){
					tList.add(wReport);
				}
			}
			wReportList.addAll(tList);
		}else{
			wList = (List<WorkReport>)cRMService.getDbService().getWorkPlanService().findObjListByFilter(workReport);
			wReportList.addAll(wList);
			
			//查询分享给我的工作计划
			TeamPeason team = new TeamPeason();
			team.setOpenId(openId);
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				logger.info("WorkPlanController list rowid ===>" + rowid);
				WorkReport wReport = (WorkReport)cRMService.getDbService().getWorkPlanService().findObjById(rowid);
				if(null!=wReport){
					tList.add(wReport);
				}
			}
			wReportList.addAll(tList);
		}
		
		request.setAttribute("list", wReportList);
		return "workplan/list";
	}
	
	/**
	 * 增加工作计划
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String get(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String orgId = request.getParameter("orgId");
		request.setAttribute("orgId", orgId);
//		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
//		request.setAttribute("assignername", wxuserInfo.getName());
		String crmId = cRMService.getDbService().getWorkPlanService().getCrmIdByOrgId(UserUtil.getCurrOpenId(request), PropertiesUtil.getAppContext("app.publicId"), orgId);
		// 用户对象
		UserReq uReq = new UserReq();
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setCrmaccount(crmId);
		uReq.setFlag("single");
		uReq.setOpenId(UserUtil.getCurrOpenId(request));
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		UserAdd userAdd = new UserAdd();
		if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
			userAdd = uResp.getUsers().get(0);
		}
		request.setAttribute("assignername", userAdd.getUsername());
		return "workplan/add";
	}
	
	/**
	 * 保存工作计划
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(WorkReport workReport,HttpServletRequest request,HttpServletResponse response)throws Exception{
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String orgId = request.getParameter("orgId");
		String partyId = wxuserInfo.getParty_row_id();
		String openId = wxuserInfo.getOpenId();
		String name = workReport.getCreator();
		logger.info("WorkPlanController save partyId ===>"+partyId);
		logger.info("WorkPlanController save nickname ===>"+wxuserInfo.getNickname());
		logger.info("WorkPlanController save orgId ===>"+orgId);
		String remark = workReport.getRemark();
		if(StringUtils.isNotNullOrEmptyStr(remark)&&!StringUtils.regZh(remark)){
			remark = new String(remark.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = "";
		if(StringUtils.isNotNullOrEmptyStr(orgId)){
			crmId = cRMService.getDbService().getWorkPlanService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		workReport.setOrgId(orgId);
		workReport.setCrmId(crmId);
		//先验证是否是同一天创建的工作计划(创建时间、类型、开始日期、组织)
		String currDate = DateTime.currentDate(DateTime.DateFormat1);
		workReport.setCreate_time(currDate);
		workReport.setAssigner_id(partyId);
		String flag =  cRMService.getDbService().getWorkPlanService().checkWorkPlan(workReport);
		if("true".equals(flag)){
			return "99999";
		}
		workReport.setAssigner_id(partyId);
		workReport.setCreator(name);	
		String id = cRMService.getDbService().getWorkPlanService().addObj(workReport);
		logger.info("WorkPlanController save crmId ===>"+crmId);
		//添加团队成员
		Share share = new Share();
		share.setShareuserid(crmId);
		share.setShareusername(name);
		share.setParentid(id);
		share.setParenttype("WorkReport");
		share.setType("share");
		share.setCrmId(crmId);
		cRMService.getSugarService().getShare2SugarService().updShareUser(share);
		//缓存rowId和orgId的关系
		RedisCacheUtil.setString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+id,orgId);
		return id;
	}
	
	/**
	 * 工作日报修改
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modify")
	@ResponseBody
	public String modify(WorkReport workReport,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String title = workReport.getTitle();
		String remark = workReport.getRemark();
		if(!StringUtils.regZh(title)){
			title = new String(title.getBytes("ISO-8859-1"),"UTF-8");
			workReport.setTitle(title);
		}
		if(!StringUtils.regZh(remark)){
			remark = new String(remark.getBytes("ISO-8859-1"),"UTF-8");
			workReport.setRemark(remark);
		}
		int flag = cRMService.getDbService().getWorkPlanService().updateWorkPlanById(workReport);
		if(flag>0){
			return "success";
		}else{
			return "error";
		}
	}
	
	/**
	 * 工作日报详情
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String orgId = request.getParameter("orgId");
		String eval_type = "";
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		//为了区分上一页和下一页
		String flag = request.getParameter("flag");
		//为了区分页面左上角是否需要有左右跳转的箭头，如果工作计划只有一条记录，就隐藏左右跳转箭头
		String planLength = request.getParameter("planLength");
		request.setAttribute("planLength", planLength);
		String viewtype = request.getParameter("viewtype");
		String operate = request.getParameter("operate");
		String index = request.getParameter("index");
		if(StringUtils.isNotNullOrEmptyStr(operate)){
			String rowids = "";
			if("myview".equals(viewtype)){
				if("search".equals(flag)){
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_SEARCH_RECORDLIST_OWNER_"+partyId);
				}else{
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_OWNER_"+partyId);
				}
			}else if("myBranch".equals(viewtype)){
				if("search".equals(flag)){
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_SEARCH_RECORDLIST_MYBRANCH_"+partyId);
				}else{
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_MYBRANCH_"+partyId);
				}
			}else if("share".equals(viewtype)){
				if("search".equals(flag)){
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_SEARCH_RECORDLIST_SHARE_"+partyId);
				}else{
					rowids = RedisCacheUtil.getString("ZJWK_WORKPLAN_DEFAULT_RECORDLIST_SHARE_"+partyId);
				}
			}
			if(StringUtils.isNotNullOrEmptyStr(rowids)&&rowids.contains(",")){
				String[] str = rowids.split(",");
				if(str.length==1){
					request.setAttribute("shownext", "none");
				}
				else{
					if("next".equals(operate)){
						if((Integer.parseInt(index)+1)==(str.length)){
							rowId = str[0];
							index = 0+"";
						}else{
							rowId = str[Integer.parseInt(index)+1];
							index = Integer.parseInt(index)+1+"";
						}
					}else if("pre".equals(operate)){
						if("0".equals(index)){
							rowId = str[str.length-1];
							index = (str.length-1)+"";
						}else{
							rowId = str[Integer.parseInt(index)-1];
							index = Integer.parseInt(index)-1+"";
						}
					}
				}
			}
		}
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+rowId);
		}
		if(!StringUtils.isNotNullOrEmptyStr(index)){
			request.setAttribute("shownext", "none");
		}
		logger.info("WorkPlanController detail rowId ===>"+rowId);
		logger.info("WorkPlanController detail orgId ===>"+orgId);
		WorkReport workReport = new WorkReport();
		Object obj = cRMService.getDbService().getWorkPlanService().findObjById(rowId);
		if(null!=obj){
			workReport = (WorkReport)obj; 
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				orgId = workReport.getOrgId();
			}
		}
		String crmId = cRMService.getDbService().getWorkPlanService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		if(partyId.equals(workReport.getAssigner_id())){
			request.setAttribute("authority", "Y");
			eval_type = "owner";
		}else{
			request.setAttribute("authority", "N");
		}
		//查询当前工作计划下的任务列表
		Schedule schedule = new Schedule();
		schedule.setOrgId(orgId);
		schedule.setParentId(rowId);
		schedule.setOpenId(openId);
		schedule.setCrmId(crmId);
		schedule.setParentType("WorkReport");
		schedule.setViewtype("workplanviewtype");
		ScheduleResp resp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(schedule, "");
		List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>(); 
		List<ScheduleAdd> tasklist = new ArrayList<ScheduleAdd>(); 
		Map<String, String> map = new TreeMap<String, String>();
		if(null!=resp&&null!=resp.getTasks()){
			slist = resp.getTasks();
			for(ScheduleAdd scheduleAdd : slist){
				String start_date = scheduleAdd.getStartdate();
				String week = DateTime.getWeekOfDate(start_date);
				scheduleAdd.setWeek(week);
				if(start_date.length()>=10){
					start_date = start_date.substring(0,10);
				}
				scheduleAdd.setStartdate(start_date);
				map.put(start_date,start_date.substring(5,10)+"&nbsp;&nbsp;"+week);
				tasklist.add(scheduleAdd);
			}
		}
		request.setAttribute("slist", tasklist);
		request.setAttribute("map", map);
		//查询当前关联的共享用户
		Share share = new Share();
		share.setParentid(rowId);
		share.setParenttype("WorkReport");
		share.setCrmId(crmId);
		ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
		List<ShareAdd> shareAdds = sresp.getShares();
		List<ShareAdd> teamList = new ArrayList<ShareAdd>();
		for (int i = 0; i < shareAdds.size(); i++) {
			ShareAdd sa = shareAdds.get(i);
			if (crmId.equals(sa.getShareuserid())) {
				sa.setFlag("N");
			}
			teamList.add(sa);
		}
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("statusDom", mp.get("status_dom"));
		request.setAttribute("periodList", mp.get("task_period_list"));
		//CRM团队成员
//		if(!isTeamFlag){
//			TeamPeason search = new TeamPeason();
//			search.setRelaId(rowId);
//			//查询团队列表-好友列表
//			List<TeamPeason> fteamlist = (List<TeamPeason>)teamPeasonService.findObjListByFilter(search);
//			for(int i=0;i<fteamlist.size();i++){
//				search = fteamlist.get(i);
//				if(openId.equals(search.getOpenId())){
//					isTeamFlag = true;
//					request.setAttribute("eval_type", "friend");
//					break;
//				}
//			}
//		}
		//判断当前用户是否为好友
		TeamPeason search = new TeamPeason();
		search.setRelaId(rowId);
		List<TeamPeason> fteamlist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
		for(int i=0;i<fteamlist.size();i++){
			search = fteamlist.get(i);
			if(openId.equals(search.getOpenId())){
				eval_type = "friend";
				break;
			}
		}
		//当前用户是否为该工作计划的上级
		UserReq uReq  = new UserReq();
		uReq.setCrmaccount(crmId);
		uReq.setCurrpage("1");
		uReq.setPagecount("9999");
		uReq.setFlag("");
		uReq.setOpenId(openId);
		uReq.setOrgId(orgId);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		if(null == uResp || null == uResp.getUsers() || uResp.getUsers().size() == 0){
			if(!StringUtils.isNotNullOrEmptyStr(eval_type)){
				eval_type = "";
			}
		}else{
			List<UserAdd> userList = uResp.getUsers();
			boolean isLead = false;
			for(int i=0;i<userList.size();i++){
				if(userList.get(i).getUserid().equals(workReport.getCrmId())){
					isLead = true;
					break;
				}
			}
			if(isLead){//领导
				eval_type = "lead";
				request.setAttribute("authority", "Y");
			}
		}
		//同事
		if(!StringUtils.isNotNullOrEmptyStr(eval_type)){
			eval_type = "partner";
		}
		//非团队成员
//		if(!isTeamFlag){
//			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1 + "，错误描述：" + ErrCode.ERR_MSG_1);
//		}
		request.setAttribute("eval_type", eval_type);
		request.setAttribute("shareusers", teamList);
		request.setAttribute("workReport", workReport);
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("index", index);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("flag", flag);
		return "workplan/detail";
	}
	
	
	/**
	 * 保存评价内容
	 * @param comments
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveComments")
	@ResponseBody
	public String saveComments(Comments comments,HttpServletRequest request,HttpServletResponse response)throws Exception{
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String name = wxuserInfo.getName();
		String content = comments.getComments();
		if(StringUtils.isNotNullOrEmptyStr(content)&&!StringUtils.regZh(content)){
			content = new String(content.getBytes("ISO-8859-1"),"UTF-8");
		}
		comments.setAssignerid(wxuserInfo.getParty_row_id());
		comments.setCreator(name);
		String id = cRMService.getDbService().getCommentsService().addObj(comments);
		
		//更新工作计划状态
		if("WorkReport".equals(comments.getRela_type())){
			//查找原来的记录
			WorkReport workReport = new WorkReport();
			Object obj = cRMService.getDbService().getWorkPlanService().findObjById(comments.getRela_id());
			if(null!=obj){
				workReport = (WorkReport)obj; 
			}
			//if(!"audit".equals(workReport.getStatus()) && !workReport.getAssigner_id().equals(wxuserInfo.getParty_row_id())){
			//评论人不是本人的时候，统一都修改评价状态为已评价    hexin修改于2015-05-18
			if(!"audit".equals(workReport.getStatus()) && !"owner".equals(comments.getEval_type())){
				workReport.setId(comments.getRela_id());
				workReport.setStatus("audit"); //已评价
				cRMService.getDbService().getWorkPlanService().updateWorkPlanStatusById(workReport);
			}
		}
		return id;
	}
	
	/**
	 * 异步获取评论内容
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asynclist")
	@ResponseBody
	public String asynclist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rela_type = request.getParameter("rela_type");
		String rela_id = request.getParameter("rela_id");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String flag = request.getParameter("flag");
		logger.info("WorkPlanController save rela_type ===>"+rela_type);
		logger.info("WorkPlanController save rela_id ===>"+rela_id);
		logger.info("WorkPlanController save currpage ===>"+currpage);
		logger.info("WorkPlanController save pagecount ===>"+pagecount);
		Comments comments = new Comments();
		comments.setRela_id(rela_id);
		comments.setRela_type(rela_type);
		comments.setCurrpages(Integer.parseInt(currpage));
		comments.setPagecounts(Integer.parseInt(pagecount));
		comments.setFlag(flag);
		List<Comments> list = (List<Comments>)cRMService.getDbService().getCommentsService().findObjListByFilter(comments);
		return JSONArray.fromObject(list).toString();
	}
	
	
	/**
	 * 修改工作计划状态
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updstatus")
	@ResponseBody
	public String updstatus(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String status = request.getParameter("status");
		WorkReport wr = new WorkReport();
		wr.setId(rowId);
		wr.setStatus(status);
		boolean flag = cRMService.getDbService().getWorkPlanService().updateWorkPlanStatusById(wr);
		if(flag){
			return "success";
		}
		return "fail";
	}
	
	
	/**
	 * 更新工作计划
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updworkplan")
	@ResponseBody
	public String updworkplan(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String orgId = request.getParameter("orgId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		
		CrmError crmErr = new CrmError();
		
		//查找原来的记录
		WorkReport workReport = new WorkReport();
		Object obj = cRMService.getDbService().getWorkPlanService().findObjById(rowId);
		if(null!=obj){
			workReport = (WorkReport)obj; 
		}
		
		//保存新的记录
		workReport.setId(null);
		workReport.setStatus("draft");
		String id = cRMService.getDbService().getWorkPlanService().addObj(workReport);
		
		if(StringUtils.isNotNullOrEmptyStr(id)){
			crmErr.setRowId(id);
			
			String crmId = "";
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				crmId = cRMService.getDbService().getWorkPlanService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
			}else{
				crmId = UserUtil.getCurrUser(request).getCrmId();
			}

			//添加团队成员
			Share share = new Share();
			share.setShareuserid(crmId);
			share.setShareusername(UserUtil.getCurrUser(request).getName());
			share.setParentid(id);
			share.setParenttype("WorkReport");
			share.setType("share");
			share.setCrmId(crmId);
			cRMService.getSugarService().getShare2SugarService().updShareUser(share);
			//缓存rowId和orgId的关系
			RedisCacheUtil.setString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+id,orgId);
			
			//更新任务了工作计划的关系
			Schedule sche = new Schedule();
			sche.setRowid(rowId);
			sche.setParentId(id);
			sche.setParentType("WorkReport");
			sche.setOrgId(orgId);
			sche.setCrmId(crmId);
			cRMService.getSugarService().getSchedule2SugarService().updateScheduleParent(sche);
			
			//更新原来的记录状态为已更新
			workReport.setId(rowId);
			workReport.setStatus("refresh");
			workReport.setRela_workid(id);
			cRMService.getDbService().getWorkPlanService().updateObj(workReport);
			crmErr.setErrorCode(ErrCode.ERR_CODE_0);
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE__1);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}		
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 工作计划分析
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/analytics")
	public String analytics(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//前台页面传过来的查询条件
		String viewtype = request.getParameter("viewtype");
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = Constants.SEARCH_VIEW_TYPE_MYVIEW;
		}
		String period_type = request.getParameter("period_type");//日期区间
		if(!StringUtils.isNotNullOrEmptyStr(period_type)){
			period_type = "premonth";
		}
		String analytics_type = request.getParameter("analytics_type");//报表展示
		if(!StringUtils.isNotNullOrEmptyStr(analytics_type)){
			analytics_type = "day";
		}
		String eval_type = request.getParameter("eval_type");
		if(!StringUtils.isNotNullOrEmptyStr(eval_type)){
			eval_type = "all";
		}
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		if(StringUtils.isNotNullOrEmptyStr(addAssigner)&&!StringUtils.regZh(addAssigner)){
			addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(!"free".equals(period_type)){
			Map<String, String> map = DateTime.getStartDateAndEndDate(period_type);
			start_date = map.get("start_date");
			end_date = map.get("end_date");
		}else if("free".equals(period_type)){
			end_date = start_date;
		}
		logger.info("WorkPlanController analytics partyId ===>"+partyId);
		logger.info("WorkPlanController analytics openId ===>"+openId);
		logger.info("WorkPlanController analytics viewtype ===>"+viewtype);
		logger.info("WorkPlanController analytics period_type ===>"+period_type);
		logger.info("WorkPlanController analytics analytics_type ===>"+analytics_type);
		logger.info("WorkPlanController analytics start_date ===>"+start_date);
		logger.info("WorkPlanController analytics end_date ===>"+end_date);
		logger.info("WorkPlanController analytics assignerId ===>"+assignerId);
		logger.info("WorkPlanController analytics addAssigner ===>"+addAssigner);
		//查询我的工作计划
		WorkReport workReport = new WorkReport();
		if(Constants.SEARCH_VIEW_TYPE_MYVIEW.equals(viewtype)){
			workReport.setAssigner_id(partyId);
			addAssigner="";
			assignerId="";
		}else{
			if(StringUtils.isNotNullOrEmptyStr(assignerId)){
				String[] assids = assignerId.split(",");
				List<String> assList = new ArrayList<String>();
				for(int i=0;i<assids.length;i++){
					assList.add(assids[i]);
				}
				workReport.setAssignid_in(assList);
			}
			
		}
		workReport.setType(analytics_type);
		if(StringUtils.isNotNullOrEmptyStr(start_date)){
			workReport.setStart_date(start_date);
		}
		if(StringUtils.isNotNullOrEmptyStr(end_date)){
			workReport.setEnd_date(end_date);
		}
		workReport.setViewtype(viewtype);
		workReport.setOpenId(openId);
		if(!"all".equals(eval_type)){
			workReport.setEval_type(eval_type);
		}
		workReport.setPagecounts(Constants.ALL_PAGECOUNT);
		List<WorkReport> wReportList = cRMService.getDbService().getWorkPlanService().searchAnalyticsList(workReport);
		
		StringBuffer xdata = new StringBuffer();
		StringBuffer ydata = new StringBuffer();
		StringBuffer legend = new StringBuffer();
		
		List<String> xList = new ArrayList<String>();
		List<String> legendList = new ArrayList<String>();
		Map<String,String> tmpMap = new HashMap<String,String>();
		if (null == wReportList || wReportList.size() == 0) {
			request.setAttribute("dataFlg", "no");
		} else {
			request.setAttribute("dataFlg", "yes");
			
			for(int i=0;i<wReportList.size();i++){
				workReport = wReportList.get(i);
				tmpMap.put(workReport.getCreator() + workReport.getCreate_time(), StringUtils.repStr(workReport.getComments_grade()));
				if(!xList.contains(workReport.getCreate_time())){
					if(xList.size() > 0){
						xdata.append(",");
					}
					xdata.append("'").append(workReport.getCreate_time()).append("'");
					xList.add(workReport.getCreate_time());
				}
				if(!legendList.contains(workReport.getCreator())){
					if(legendList.size() > 0){
						legend.append(",");
					}
					legend.append("'").append(workReport.getCreator()).append("'");
					legendList.add(workReport.getCreator());
				}
			}
			
			for(int i=0;i<legendList.size();i++){
				if(StringUtils.isNotNullOrEmptyStr(ydata.toString())){
					ydata.append(",");
				}
				ydata.append("{").append("name:'").append(legendList.get(i)).append("',type:'line',data:[");
				for(int j=0;j<xList.size();j++){
					if(j > 0){
						ydata.append(",");
					}
					if(null != tmpMap.get(legendList.get(i)+xList.get(j))){
						ydata.append(tmpMap.get(legendList.get(i)+xList.get(j)));
					}else{
						ydata.append("0");
					}
				}
				ydata.append("]");
				ydata.append("}");
			}
		}
		
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("period_type", period_type);
		request.setAttribute("type", analytics_type);
		request.setAttribute("assignerid", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("eval_type", eval_type);
		request.setAttribute("start_date", start_date);
		request.setAttribute("end_date", end_date);
		
		request.setAttribute("xdata", xdata.toString());
		request.setAttribute("ydata", ydata.toString());
		request.setAttribute("legend",legend.toString());
		return "workplan/analytics";
	}
	
	/**
	 * 删除工作计划
	 * @return
	 */
	@RequestMapping("/deleteWorkPlan")
	@ResponseBody
	public String delete(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String flag = "";
		try{
			cRMService.getDbService().getWorkPlanService().deleteObjById(rowId);
			flag = "0";
		}catch(Exception e){
			e.printStackTrace();
			flag = "9999999";
		}
		return flag;
	}

	/**
	 * 保存平均分到redies
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveCalcAvg")
	@ResponseBody
	public String saveCalcAvg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String avg = request.getParameter("total");
		RedisCacheUtil.setString("ZJWK_WORKPLAN_SINGLE_AVG_"+rowId, avg);
		return "";
	}
	
	@RequestMapping("/getCalcAvg")
	@ResponseBody
	public String getCalcAvg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String rowId = request.getParameter("rowId");
		String avg = RedisCacheUtil.getString("ZJWK_WORKPLAN_SINGLE_AVG_"+rowId);
		if(!StringUtils.isNotNullOrEmptyStr(avg)){
			avg = "";
		}
		return avg;
	}
	
	@RequestMapping("/workPlansForAutoEmail")
	@ResponseBody
	public String workPlansForAutoEmail(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openid = request.getParameter("openid");
		Date start = null,end = null;
		this.cRMService.getBusinessService().getWorkPlanService().getMyWorkReports(openid, start, end);
		
		return "workplan/workplansforautoemail";
	}
}
