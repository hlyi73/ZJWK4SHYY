package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.ss.formula.functions.Now;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.service.ActivityService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SortUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Campaigns2ZJMKTService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.TrackhisService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 项目 页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/zjactivity")
public class ZJCampaignsController {
	
	//日志服务
	Logger logger = Logger.getLogger(ZJCampaignsController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 新增
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	public String add(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");// rowId
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String orgId = request.getParameter("orgId");
		if(null != rowId && !"".equals(rowId)){
			try{
				String crmId = "";
				//得到orgId
				if(StringUtils.isNotNullOrEmptyStr(orgId)){
					crmId = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
					RedisCacheUtil.set(Constants.ZJWK_ACTIVITY_ORGID+rowId, orgId);
				}else{
					crmId = UserUtil.getCurrUser(request).getCrmId();
				}
				String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();
//				Object obj = cRMService.getWxService().getWxUserinfoService().findObjById(openId);	
//				if(obj!=null){
//					WxuserInfo wxuserInfo = (WxuserInfo)obj;
//					partyRowId = wxuserInfo.getParty_row_id();
//				}
				RedisCacheUtil.set("WK_Activity_"+openId+"_"+rowId,DateTime.currentDateTime(DateTime.DateTimeFormat2));	//缓存最后访问时间
				//添加团队成员
				Share share = new Share();
				share.setShareuserid(crmId);
				share.setShareusername(UserUtil.getCurrUser(request).getName());
				share.setParentid(rowId);
				share.setParenttype("Activity");
				share.setType("share");
				share.setCrmId(crmId);
				cRMService.getSugarService().getShare2SugarService().updShareUser(share);
				return "redirect:/zjwkactivity/detail?id="+rowId+"&source=WK&sourceid="+partyRowId+"&crmId="+crmId+"&orgId="+orgId;
			}catch(Exception ex){
				throw new Exception("操作失败");
			}
			
		}else{
			throw new Exception("添加活动失败");
		}
	}
	
	/**
	 * 市场活动 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("CampaignsController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+rowId);
		}
		logger.info("CampaignsController detail method rowId =>" + rowId);
		// 绑定对象
		String crmId = "";
		if(StringUtils.isNotNullOrEmptyStr(orgId)){
			crmId = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			CampaignsResp sResp = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsSingle(rowId,crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CampaignsAdd> list = sResp.getCams();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("camName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
					
					//获取跟进历史
					Trackhis follow = new Trackhis();
					follow.setCrmaccount(crmId);
					follow.setParentid(list.get(0).getRowid());
					follow.setParenttype("Activity");
					List<OpptyAuditsAdd> auditList = cRMService.getSugarService().getTrackhisService().getTrackhisList2(follow);
					request.setAttribute("auditList", auditList);
					
					//责任人对象
					UserReq uReq = new UserReq();
					uReq.setCurrpage("1");
					uReq.setPagecount("1000");
					uReq.setCrmaccount(crmId);
					uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
					UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
					request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
					
					//查询当前任务下关联的共享用户
					Share share = new Share();
					share.setParentid(rowId);
					share.setParenttype("Activity");
					share.setCrmId(crmId);
					ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
					List<ShareAdd> sharelist = sresp.getShares();
					List<ShareAdd> shareAdds = new ArrayList<ShareAdd> ();
					for(ShareAdd shareObj:sharelist){
						if(crmId.equals(shareObj.getShareuserid())){
							shareObj.setFlag("N");
						}
						shareAdds.add(shareObj);
					}
					request.setAttribute("shareusers", shareAdds);
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		Object obj = cRMService.getWxService().getWxUserinfoService().findObjById(openId);	
		if(obj!=null){
			WxuserInfo wxuserInfo = (WxuserInfo)obj;
			String partyRowId = wxuserInfo.getParty_row_id();
			request.setAttribute("partyId", partyRowId);
		}
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("orgId", orgId);
		RedisCacheUtil.set("WK_Activity_"+openId+"_"+rowId,DateTime.currentDateTime(DateTime.DateTimeFormat2));	//缓存最后访问时间
		return "activity/detail";
	}
	
	/**
	 * 判断是否是活动团队成员
	 */
	@RequestMapping("/teamMembers")
	@ResponseBody
	public String  teamMembers(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String create_by = request.getParameter("create_by");
		String activityid = request.getParameter("activityid");
		String sourceid = request.getParameter("sourceid");
		WxuserInfo wxuserInfo = new WxuserInfo();
		String openId = "";
		String openId1 = "";
		wxuserInfo.setParty_row_id(create_by);
		Object obj = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuserInfo);
		if(null!=obj){
			wxuserInfo = (WxuserInfo)obj;
			openId = wxuserInfo.getOpenId();
		}
		wxuserInfo = new WxuserInfo();
		wxuserInfo.setParty_row_id(sourceid);
		obj = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuserInfo);
		if(null!=obj){
			wxuserInfo = (WxuserInfo)obj;
			openId1 = wxuserInfo.getOpenId();
		}
		String orgId = (String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+activityid);
		String crmId = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		String crmId1 = cRMService.getSugarService().getCampaigns2ZJmktService().getCrmIdByOrgId(openId1, PropertiesUtil.getAppContext("app.publicId"), orgId);
		Share share = new Share();
		share.setParentid(activityid);
		share.setParenttype("Activity");
		share.setCrmId(crmId);
		ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
		List<ShareAdd> sharelist = sresp.getShares();
		CrmError crmError = new CrmError();
		boolean flag = false;
		for(ShareAdd shareObj:sharelist){
			String userid = shareObj.getShareuserid();
			if(StringUtils.isNotNullOrEmptyStr(userid)&&userid.equals(crmId1)){
				crmError.setErrorCode("0");
				crmError.setErrorMsg("success");
				flag = true;
			}
		}
		TeamPeason teamPeason = new TeamPeason();
		teamPeason.setRelaId(activityid);
		Object obj1 = cRMService.getDbService().getTeamPeasonService().findObjListByFilter(teamPeason);
		if(null!=obj1){
			List<TeamPeason> teamList = (List<TeamPeason>)obj1;
			for(TeamPeason teamPeason2:teamList){
				String userid = teamPeason2.getOpenId();
				if(userid.equals(openId1)){
					crmError.setErrorCode("0");
					crmError.setErrorMsg("success");
					flag = true;
				}
			}
		}
		if(!flag){
			crmError.setErrorCode("999999999");
			crmError.setErrorMsg("error");
		}
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 查询列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		String startdate=request.getParameter("start_date");
		String enddate=request.getParameter("end_date");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String orgId = request.getParameter("orgId");
		String title = request.getParameter("title");
		if(StringUtils.isNotNullOrEmptyStr(title)&&!StringUtils.regZh(title)){
			title = new String(title.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(addAssigner)&&!StringUtils.regZh(addAssigner)){
			addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
		}
		if (null == currpage || "".equals(currpage)) {
			currpage = "0";
		}
		if (null == pagecount || "".equals(pagecount)) {
			pagecount = "10";
		}
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = "owner";
		}
		currpage = Integer.parseInt(currpage) * Integer.parseInt(pagecount) +"";
		String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		Campaigns camp = new Campaigns();
		camp.setCurrpage(currpage);
		camp.setPagecount(pagecount);
		camp.setOpenId(partyRowId);
		camp.setStartdate(startdate);
		camp.setEnddate(enddate);
		camp.setOrgId(orgId);
		String flag = request.getParameter("flag");
		List<Activity> activities = new ArrayList<Activity>();
		List<Activity> activityAll = new ArrayList<Activity>();
		//我发起的活动
		if("owner".equals(viewtype)){
			camp.setType(viewtype);
			activities = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsList(camp, "WEB");
			if(activities.size()>0){
				activityAll.addAll(activities);
			}
			activities = new ArrayList<Activity>();
			//我报名的
			activities = cRMService.getSugarService().getCampaigns2ZJmktService().getJoinCampaignsList(camp, "WEB");
			if(activities.size()>0){
				for(Activity activity:activities){
					String sourceid = activity.getCreateBy();
					if(!partyRowId.equals(sourceid)){
						activityAll.add(activity);
					}
				}
			}
			activities = new ArrayList<Activity>();
			//我参与的
			camp.setViewtype(Constants.SEARCH_VIEW_TYPE_SHAREVIEW);
			camp.setCrmId(crmId);
			activities = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaigns(camp);
			if(activities.size()>0){
				for(Activity activity:activities){
					String sourceid = activity.getCreateBy();
					if(!partyRowId.equals(sourceid)){
						activityAll.add(activity);
					}
				}
			}
			//我关注的
			String openId = UserUtil.getCurrUser(request).getOpenId();
			Activity act = new Activity();
			act.setOpenId(openId);
			act.setCurrpages(0);
			act.setPagecounts(999999);
			activities = cRMService.getDbService().getActivityService().findAttenAct(act);
			if(activities.size()>0){
				activityAll.addAll(activities);
			}
			//从activityAll 集合中去掉重复数据
			List<String> listTemp= new ArrayList<String>(); 
			for (Iterator iterator = activityAll.iterator(); iterator.hasNext();) {
				Activity activity = (Activity) iterator.next();
				if(listTemp.contains(activity.getId())){
					iterator.remove();  
				}else{
				  listTemp.add(activity.getId());  
				}
			}
			
		}else if("branch".equals(viewtype)){//我下属的活动
			Activity activity = new Activity();
			activity.setCurrpages(0);
			activity.setPagecounts(999999);
			activity.setOrgId(orgId);
			if("search".equals(flag)){
				activity.setStart_date(startdate);
				activity.setEnd_date(enddate);
				activity.setTitle(title);
			}
			List<Activity> list = new ArrayList<Activity>();
			if(StringUtils.isNotNullOrEmptyStr(assignerId)){
				String[] assids = assignerId.split(",");
				List<String> assList = new ArrayList<String>();
				for(int i=0;i<assids.length;i++){
					assList.add(assids[i]);
				}
				activity.setCrm_id_in(assList);
				list =  cRMService.getDbService().getActivityService().searchBranchActivity(activity);
				activityAll.addAll(list);
			}else{
				UserReq uReq = new UserReq();
				uReq.setCurrpage("1");
				uReq.setPagecount("1000");
				uReq.setOpenId(UserUtil.getCurrUser(request).getOpenId());
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
					activity.setCrm_id_in(assList);
					list = cRMService.getDbService().getActivityService().searchBranchActivity(activity);
					activityAll.addAll(list);
				}
			}
		}
		request.setAttribute("activityList", activityAll);
		//获取参与推荐活动列表
		List<Activity> list = cRMService.getSugarService().getCampaigns2ZJmktService().getRecommendCampaignsList();
		request.setAttribute("recommendList", list);
		request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("start_date", startdate);
		request.setAttribute("end_date", enddate);
		request.setAttribute("orgId", orgId);
		return "activity/list";
	}
	
	/**
	 * 推荐查询列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/recomlist")
	@ResponseBody
	public String recomlist(HttpServletRequest request, HttpServletResponse response) throws Exception {		
		//获取参与推荐活动列表
		List<Activity> list = cRMService.getSugarService().getCampaigns2ZJmktService().getRecommendCampaignsList();
		if(list.size()<=0){
			list = new ArrayList<Activity>();
		}
		return JSONArray.fromObject(list).toString();
	}
	
	/**
	 * 查询列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/synclist")
	@ResponseBody
	public String synclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		String startdate=request.getParameter("startdate");
		String enddate=request.getParameter("enddate");
		String rst = "";
		if (null == currpage || "".equals(currpage)) {
			currpage = "0";
		}
		if (null == pagecount || "".equals(pagecount)) {
			pagecount = "10";
		}
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = "owner";
		}
		currpage = Integer.parseInt(currpage) * Integer.parseInt(pagecount) +"";
		
		String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Campaigns camp = new Campaigns();
			camp.setCurrpage(currpage);
			camp.setPagecount(pagecount);
			camp.setOpenId(partyRowId);
			camp.setStartdate(startdate);
			camp.setEnddate(enddate);
			CampaignsResp sResp = null;
			//我发起的活动
			if("owner".equals(viewtype)){
				camp.setType(viewtype);
				//sResp = campaigns2ZJmktService.getCampaignsList(camp, "WEB");
			}
			//我报名的活动
			else if("join".equals(viewtype)){
				//sResp = campaigns2ZJmktService.getJoinCampaignsList(camp, "WEB");
			}else{
				camp.setViewtype(viewtype);
				camp.setCrmId(crmId);
				//sResp = campaigns2ZJmktService.getCampaigns(camp);
			}
			//Modify by Kater Yi 2015/3/3
			sResp.setCams((List<CampaignsAdd>) SortUtil.sortByDesc(sResp.getCams()));

			if(null == sResp || null == sResp.getCams() || sResp.getCams().size() == 0){
				rst = "";
			}else{
				rst = JSONArray.fromObject(sResp.getCams()).toString();
			}
			
		} else {
			rst = "";
		}
		return rst;
	}
	
	
	/**
	 * 异步查询活动列表（与我相关）
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asylist")
	@ResponseBody
	public String asylist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		if (null == currpage || "".equals(currpage)) {
			currpage = "0";
		}
		if (null == pagecount || "".equals(pagecount)) {
			pagecount = "99999";
		}
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = "owner";
		}
		String flag = request.getParameter("flag");//标识，表示是从哪里进来的
		currpage = Integer.parseInt(currpage) * Integer.parseInt(pagecount) +"";
		String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		Campaigns camp = new Campaigns();
		camp.setCurrpage(currpage);
		camp.setPagecount(pagecount);
		camp.setOpenId(partyRowId);
		List<Activity> activities = new ArrayList<Activity>();
		List<Activity> activityAll = new ArrayList<Activity>();
		camp.setType(viewtype);
		activities = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsList(camp, "WEB");
		if(activities.size()>0){
			activityAll.addAll(activities);
		}
		activities = new ArrayList<Activity>();
		//我报名的
		activities = cRMService.getSugarService().getCampaigns2ZJmktService().getJoinCampaignsList(camp, "WEB");
		if(activities.size()>0){
			for(Activity activity:activities){
				String sourceid = activity.getCreateBy();
				if(!partyRowId.equals(sourceid)){
					activityAll.add(activity);
				}
			}
		}
		activities = new ArrayList<Activity>();
		//我参与的
		camp.setViewtype(Constants.SEARCH_VIEW_TYPE_SHAREVIEW);
		camp.setCrmId(crmId);
		activities = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaigns(camp);
		if(activities.size()>0){
			for(Activity activity:activities){
				String sourceid = activity.getCreateBy();
				if(!partyRowId.equals(sourceid)){
					activityAll.add(activity);
				}
			}
		}
		//我关注的
		String openId = UserUtil.getCurrUser(request).getOpenId();
		Activity acti = new Activity();
		acti.setOpenId(openId);
		acti.setCurrpages(0);
		acti.setPagecounts(999999);
		activities = cRMService.getDbService().getActivityService().findAttenAct(acti);
		if(activities.size()>0){
			activityAll.addAll(activities);
		}
		Set<Activity> set = new HashSet<Activity>();
		List<Activity> list = new ArrayList<Activity>();
		String str = "";
		if(null!=activityAll && activityAll.size()>0){
			if("calendar".equals(flag)){
				String currdate = request.getParameter("startdate");
				long end  = DateTime.dateTimeParse(currdate, DateTime.DateFormat1);
				for(Activity act : activityAll){
					set.add(act);
				}
				for(Activity act : set){
					String startdate =act.getStart_date();
					long start  = DateTime.dateTimeParse(startdate, DateTime.DateFormat1);
					if(end==start){
						list.add(act);	
					}
				}
				str = JSONArray.fromObject(list).toString();
			}else{
				str = JSONArray.fromObject(activityAll).toString();
			}
		}
		return str;
	}
	
	/**
	 * 查询关注的活动列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/noticelist")
	public String noticelist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		if (null == currpage || "".equals(currpage)) {
			currpage = "0";
		}
		if (null == pagecount || "".equals(pagecount)) {
			pagecount = "10";
		}
		if(!StringUtils.isNotNullOrEmptyStr(viewtype)){
			viewtype = "owner";
		}
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		currpage = Integer.parseInt(currpage) * Integer.parseInt(pagecount) +"";
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		List<Activity> activities = new ArrayList<Activity>();
		//我发起的活动
		if("owner".equals(viewtype)){
			//我关注的
			String openId = UserUtil.getCurrUser(request).getOpenId();
			Activity act = new Activity();
			act.setOpenId(openId);
			act.setCurrpages(0);
			act.setPagecounts(999999);
			activities = cRMService.getDbService().getActivityService().findAttenAct(act);
		}
		if(null!=activities&&activities.size()==1){
			Activity act = activities.get(0);
			if("meet".equals(act)){
				return "redirect:/zjwkactivity/meetdetail?id="+act.getId()+"&source=wkshare&sourceid="+partyId;
			}else{
				return "redirect:/zjwkactivity/detail?id="+act.getId()+"&source=wkshare&sourceid="+partyId;
			}
		}
		request.setAttribute("activityList", activities);
		//获取参与推荐活动列表
		List<Activity> list = cRMService.getSugarService().getCampaigns2ZJmktService().getRecommendCampaignsList();
		request.setAttribute("recommendList", list);
		request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("viewtype", viewtype);
		return "activity/list";
	}
}
