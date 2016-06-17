package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Activity;
import com.takshine.wxcrm.domain.CalendarInfo;
import com.takshine.wxcrm.domain.CalendarRss;
import com.takshine.wxcrm.domain.Group;
import com.takshine.wxcrm.domain.InnerUser;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;

/**
 * 日历  页面控制器
 * 
 * @author lilei
 * 
 */
@Controller
@RequestMapping("/calendar")
public class CalendarController {
	    // 日志
		protected static Logger logger = Logger.getLogger(CalendarController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		@RequestMapping(value = "/getRssCalendar")
		@ResponseBody
	   public String getRssCalendar(HttpServletRequest request,
				HttpServletResponse response)throws Exception{
			logger.info("CalendarController list method begin=>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String endDate=request.getParameter("endDate");
			String startDate=request.getParameter("startDate");
			String randomString=request.getParameter("randomString");
			String cacheKey="Calendar_RssList_"+openId+"_"+randomString+"_"+startDate;	
			List<Subscribe> list = new ArrayList<Subscribe>();
			Subscribe s= new Subscribe();
			s.setOpenId(openId);
			s.setCurrpages(0);
			s.setPagecounts(1000);
			if(RedisCacheUtil.checkKeyExisted(cacheKey)){
				list=(ArrayList<Subscribe>) RedisCacheUtil.get(cacheKey);
				if(list.size()<1){
					RedisCacheUtil.delete(cacheKey);
					return"0";
				}
			}else{
				list=cRMService.getDbService().getSubscribeService().getSubscribeList(s);
			}
			if(list==null||list.size()<1){return "0";}
			List<Subscribe> cachelist=new ArrayList<Subscribe>();
			cachelist.addAll(list);
		    for(Subscribe obj:list){
		    	if("group".equals(obj.getType())){//群活动
		    		Group group=cRMService.getDbService().getGroup2ZjrmService().getGroupDetail(obj.getFeedid());
		    		if(group!=null){
			    		List<Activity> activitylist= group.getList();		   
			    		if(activitylist!=null&&activitylist.size()>0){
			    			ArrayList<Activity> activitylist2=new ArrayList<Activity>();
			    			for(Activity act:activitylist){
			    				if(DateTime.isBetweenTwoTime(act.getStartdate(), act.getDeadline(), startDate, DateTime.DateFormat1)){
			    					activitylist2.add(act);
			    				}
			    			}
			    			if(activitylist2.size()>0){
			    				group.setList(activitylist2);
			    				cachelist.remove(obj);
								RedisCacheUtil.set(cacheKey, cachelist,60);
								group.setCurrDate(startDate);
								return JSONObject.fromObject(group).toString();
			    			}
			    		}
		    		}
		    		
		    	}else if("user".equals(obj.getType())||"friend".equals(obj.getType())){
					List<CalendarInfo> calendarlList=new ArrayList<CalendarInfo>();
					CalendarRss rss= new CalendarRss();
					rss.setOpenid(openId);
					rss.setRssObjectId(obj.getFeedid());
					rss.setRssObjectName(obj.getName());
					rss.setType(obj.getType());
					rss.setCurrDate(startDate);
					List<ScheduleAdd> sclist = new ArrayList<ScheduleAdd>();
		    		Schedule sche = new Schedule();
					//组装查询条件
					sche.setViewtype("openview");//视图类型
					sche.setOpenId(obj.getFeedid());
					sche.setStartdate(startDate);
					sche.setEnddate(endDate);	
					sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
					//查询日程列表
						try{
//							ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
							sclist = cRMService.getBusinessService().getCalendarService().getScheduleList(sche);
						}catch(Exception e){
							logger.info("getRssCalendar:-> e =" + e.getMessage());
						}
		    		
		    		if(sclist!=null&&sclist.size()>0){
						for(ScheduleAdd sch:sclist){
							CalendarInfo ci= new CalendarInfo();
							ci.setTitle(sch.getTitle());
							ci.setEndTime(sch.getEnddate());
							ci.setStartTime(sch.getStartdate());
							ci.setDesc(sch.getDesc());
							ci.setId(sch.getRowid());
							ci.setOrgId(sch.getOrgId());
							calendarlList.add(ci);
						}	
						rss.setList(calendarlList);
						cachelist.remove(obj);
						RedisCacheUtil.set(cacheKey, cachelist, 60);
						return JSONObject.fromObject(rss).toString();	
		    		}		    				   
		    	}  
		    }
	    	RedisCacheUtil.delete(cacheKey);
			return"0";
	   }
		
		/**
		 * 查询所有的任务列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/list")
		public String getList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController list method begin=>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			return "calendar/list";
		}
		
		/**
		 * 查询所有的订阅列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/subscribeList")
		@ResponseBody
		public String subscribeList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController list method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);
			logger.info("CalendarController list method openId =>" + openId);
			//错误对象
			//CrmError crmErr = new CrmError();
			Subscribe subscribe = new Subscribe();
			subscribe.setOpenId(openId);
			subscribe.setCurrpages(Integer.parseInt(currpage));
			subscribe.setPagecounts(Integer.parseInt(pagecount));
			List<Subscribe>  list=cRMService.getDbService().getSubscribeService().getSubscribeList(subscribe);
			return JSONArray.fromObject(list).toString();
		}
		/**
		 * 查询内部用户列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/innerUserList")
		@ResponseBody
		public String innerUserList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController innerUserList method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String firstChar=request.getParameter("firstChar");
		/*	String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);*/
			logger.info("CalendarController innerUserList method openId =>" + openId);
			//错误对象
			List<InnerUser>  list=cRMService.getDbService().getInnerUserService().getInnerUserByOpenId(openId,firstChar);
			return JSONArray.fromObject(list).toString();
		}	
		
		/**
		 * 查询好友用户列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/friendList")
		@ResponseBody
		public String friendList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController friendList method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String firstChar=request.getParameter("firstChar");
		/*	String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);*/
			logger.info("CalendarController friendList method openId =>" + openId);
			//错误对象
			WxuserInfo wx= new WxuserInfo();
			wx.setOpenId(openId);
			if(firstChar!=null&&!"".equals(firstChar.trim())){
				wx.setFirstChar(firstChar);
				}
			List<WxuserInfo>  list=cRMService.getDbService().getUserRelaService().getFriendList(wx);
			return JSONArray.fromObject(list).toString();
		}
		
		/**
		 * 查询好友用户列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/groupList")
		@ResponseBody
		public String groupList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController groupList method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
		/*	String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);*/
			logger.info("CalendarController groupList method openId =>" + openId);
			//错误对象
			
			List<Group>  list=cRMService.getDbService().getGroup2ZjrmService().getPublicGroupList(openId);
			if(list==null||list.size()<1){
				return "";
			}
			return JSONArray.fromObject(list).toString();
		}
		/**
		 * 查询已订阅用户列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/rssUserList")
		@ResponseBody
		public String rssUserList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController list method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String type=request.getParameter("type");
		/*	String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);*/
			logger.info("CalendarController list method openId =>" + openId);
			//错误对象
			Subscribe subscribe= new Subscribe();
			subscribe.setType(type);
			subscribe.setOpenId(openId);
			List<InnerUser>  list=cRMService.getDbService().getInnerUserService().getRssUserByOpenId(subscribe);
			return JSONArray.fromObject(list).toString();
		}
		
		/**
		 * 查询已订阅好友列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/rssFriendList")
		@ResponseBody
		public String rssFriendList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController list method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String type=request.getParameter("type");
		/*	String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);*/
			logger.info("CalendarController list method openId =>" + openId);
			//错误对象
			Subscribe subscribe= new Subscribe();
			subscribe.setType(type);
			subscribe.setOpenId(openId);
			List<WxuserInfo>  list=cRMService.getDbService().getUserRelaService().getRssFriendList(subscribe);
			return JSONArray.fromObject(list).toString();
		}
		/**
		 * 查询所有的订阅列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/rssGroupList")
		@ResponseBody
		public String rssGroupList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("CalendarController list method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String type = request.getParameter("type");
			logger.info("CalendarController list method openId =>" + openId);
			//错误对象
			//CrmError crmErr = new CrmError();
			Subscribe subscribe = new Subscribe();
			subscribe.setOpenId(openId);
			subscribe.setType(type);
			subscribe.setCurrpages(0);
			subscribe.setPagecounts(1000);
			List<Subscribe>  list=cRMService.getDbService().getSubscribeService().getSubscribeList(subscribe);
			return JSONArray.fromObject(list).toString();
		}
		@RequestMapping("/firstCharlist")
		@ResponseBody
		public String firstCharlist(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			//error 对象
			CrmError crmErr = new CrmError();
			// search param
			String openId = UserUtil.getCurrUser(request).getOpenId();// crmId 5da1ce9f-74b5-d233-c286-51c64d153d5a
			logger.info("FristChartsController method list");
			logger.info("FristChartsController method openId  is =>" + openId);
			//获取用户的权限资源数据
			List<String> clist = cRMService.getDbService().getInnerUserService().getFirstList(openId);
				if(null != clist && clist.size() > 0){
					String rstStr = "[";
					for (int i = 0; i < clist.size(); i++) {
						String c = clist.get(i);
						rstStr += "\"" + c + "\"";
						if(i != clist.size() -1){
							rstStr += ",";
						}
					}
					rstStr += "]";
					logger.info("FristChartsController method clist size is =>" + clist.size());
					logger.info("FristChartsController method rstStr is =>" + rstStr);
					return rstStr;
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
				}
			return JSONObject.fromObject(crmErr).toString();
		}	
		
		@RequestMapping("/friendFirstCharlist")
		@ResponseBody
		public String friendFirstCharlist(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			//error 对象
			CrmError crmErr = new CrmError();
			// search param
			String openId = UserUtil.getCurrUser(request).getOpenId();// crmId 5da1ce9f-74b5-d233-c286-51c64d153d5a
			logger.info("FristChartsController method list");
			logger.info("FristChartsController method openId  is =>" + openId);
			//获取用户的权限资源数据
			List<String> clist = cRMService.getDbService().getUserRelaService().getFriendFristCharList(openId);
				if(null != clist && clist.size() > 0){
					String rstStr = "[";
					for (int i = 0; i < clist.size(); i++) {
						String c = clist.get(i);
						rstStr += "\"" + c + "\"";
						if(i != clist.size() -1){
							rstStr += ",";
						}
					}
					rstStr += "]";
					logger.info("FristChartsController method clist size is =>" + clist.size());
					logger.info("FristChartsController method rstStr is =>" + rstStr);
					return rstStr;
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
				}
			return JSONObject.fromObject(crmErr).toString();
		}	
		
		/**
		 * msg 详情页面
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/msg")
		public String msg(HttpServletRequest request,HttpServletResponse response) throws Exception{
			request.setAttribute("success", request.getParameter("success"));
			request.setAttribute("rowId", request.getParameter("rowId"));
			request.setAttribute("schetype", request.getParameter("schetype"));
			return "schedule/msg";
		}
		
		/**
		 * 日程表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/calendar")
		public String calendar(HttpServletRequest request,HttpServletResponse response) throws Exception{
			//活动用partyId
			String partyId = UserUtil.getCurrUser(request).getParty_row_id();
			String orgId = request.getParameter("orgId");
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				orgId = "Default Organization";
			}
			String crmId = getNewCrmId(UserUtil.getCurrUser(request).getOpenId(), orgId, UserUtil.getCurrUser(request).getCrmId());
			logger.info("crmId = >" + crmId);
			
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("statusDom", mp.get("status_dom"));
			
			request.setAttribute("partyId", partyId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("assignerid", crmId);
			request.setAttribute("orgId", orgId);
			request.setAttribute("openId", UserUtil.getCurrUser(request).getOpenId());
			return "calendar/calendar";
		}
		
		/**
		 * 日程表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/activity")
		public String activity(HttpServletRequest request,HttpServletResponse response) throws Exception{
			String orgId = request.getParameter("orgId");
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				orgId = "Default Organization";
			}
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
			request.setAttribute("crmId", crmId);
			request.setAttribute("assignerid", crmId);
			request.setAttribute("orgId", orgId);
			return "calendar/calendar_activity";
		}
			
			/**
		 * 取消订阅
		 * @return
		 */
		@RequestMapping("/cancelRss")
		@ResponseBody
		public String cancelRss(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String id =request.getParameter("id");
			CrmError crmError = new CrmError();		
			if(StringUtils.isNotNullOrEmptyStr(id)){
				cRMService.getDbService().getSubscribeService().deleteObjById(id);
				crmError.setErrorCode("0");
			}else{
				crmError.setErrorCode(ErrCode.ERR_CODE_1001004);
				crmError.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
			}
			return JSONObject.fromObject(crmError).toString();
		}
		/**
		 * 用户订阅
		 * @return
		 */
		@RequestMapping("/saveRss")
		@ResponseBody
		public String saveRss(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String rssId = request.getParameter("rssId");
			String type=request.getParameter("type");
			String name=request.getParameter("name");
			CrmError crmError = new CrmError();
			
			Subscribe subscribe  = new Subscribe();
			
			if(StringUtils.isNotNullOrEmptyStr(openId)&&StringUtils.isNotNullOrEmptyStr(rssId)){
				subscribe.setOpenId(openId);
				subscribe.setFeedid(rssId);
				subscribe.setType(type);
				List<Subscribe> list = cRMService.getDbService().getSubscribeService().getSubscribeList(subscribe);
				if(list!=null&&list.size()>0){
					crmError.setErrorCode("0");
					crmError.setRowId(list.get(0).getId());
					
				}else{
					subscribe.setName(name);
					String id = cRMService.getDbService().getSubscribeService().addObj(subscribe);
					if(StringUtils.isNotNullOrEmptyStr(id)){
						crmError.setErrorCode("0");
						crmError.setRowId(id);
					}else{
						crmError.setErrorCode("1000000");
						crmError.setErrorMsg("操作失败");
					}
				}
			}else{
				crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmError).toString();
		}
		
		/**
		 * 查询新的crmid
		 * @param request
		 * @return
		 */
		private String getNewCrmId(String openId, String orgId, String crmId){
			try {
				if(StringUtils.isNotNullOrEmptyStr(orgId)){
					String newCrmId = cRMService.getSugarService().getSchedule2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
					if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
						return newCrmId;
					}
				}
			} catch (Exception e) {
				logger.info("error mesg = >" + e.getMessage());
			}
			return crmId;
		}

}
