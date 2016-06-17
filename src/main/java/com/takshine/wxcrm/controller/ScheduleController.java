package com.takshine.wxcrm.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.SortUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxMsgUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserFocus;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 日程  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/schedule")
public class ScheduleController {
	    // 日志
		protected static Logger logger = Logger.getLogger(ScheduleController.class.getName());
		

		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
	     * 日程创建
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/get")
	    public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
			//openId publicId
			ZJWKUtil.getRequestURL(request);
			String orgId = request.getParameter("orgId");
/*			String openId = UserUtil.getCurrUser(request).getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");*/
			String scheType = request.getParameter("schetype");
			scheType = (null == scheType ? "task" : scheType);
		    String clickDate =request.getParameter("clickDate");
            String crmId = getNewCrmId(request);
       		//判断是否已经绑定 crm 账户
			if(!StringUtils.isNotNullOrEmptyStr(crmId)){
				return "schedule/msg";
				
			}else{
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("statusDom", mp.get("status_dom"));
				request.setAttribute("priorityDom", mp.get("priority_dom"));
				request.setAttribute("periodList", mp.get("task_period_list"));
				request.setAttribute("meeting_status_dom", mp.get("meeting_status_dom"));
				request.setAttribute("reminder_time_options", mp.get("reminder_time_options"));
				
				//用户对象
//				UserReq uReq = new UserReq();
//				uReq.setCurrpage("1");
//				uReq.setPagecount("1000");
//				uReq.setCrmaccount(crmId);
//				uReq.setOpenId(UserUtil.getCurrUser(request).getOpenId());
//				uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
//				request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
				
				//查询客户信息
//				Customer sc = new Customer();
//				sc.setCrmId(crmId);
//				sc.setCurrpage("1");
//				sc.setPagecount("1000");
//				sc.setViewtype("myallview");
//				sc.setOpenId(UserUtil.getCurrUser(request).getOpenId());
//				CustomerResp cResp = customer2SugarService.getCustomerList(sc,"WEB");
//				List<CustomerAdd> cList = cResp.getCustomers();
//				request.setAttribute("cList", cList);
				
				//查询业务机会信息
//				Opportunity opp = new Opportunity();
//				opp.setCrmId(crmId);
//				opp.setCurrpage("1");
//				opp.setPagecount("1000");
//				opp.setViewtype("myallview");
//				opp.setOpenId(UserUtil.getCurrUser(request).getOpenId());
//				OpptyResp oppResp = oppty2SugarService.getOpportunityList(opp,"WEB");
//				List<OpptyAdd> oppList = oppResp.getOpptys();
//				request.setAttribute("oppList", oppList);
			
				//设置 openId publicId crmId
				request.setAttribute("crmId", crmId);
				request.setAttribute("orgId", orgId);
				
				//如果从客户或业务机会明细下创建任务时，会带过来parentId和parentName;
				String parentId = request.getParameter("parentId");
				String parentName = request.getParameter("parentName");
				if(null != parentName && !"".equals(parentName)){
					parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
				}
				String parentType = request.getParameter("parentType");
				String parentTypeName = request.getParameter("parentTypeName");
				if(null != parentTypeName && !"".equals(parentTypeName)){
					parentTypeName = new String(parentTypeName.getBytes("ISO-8859-1"),"UTF-8");
				}
				String assignerId = request.getParameter("assignerId");
				String assignerName = request.getParameter("assignerName");
				if(null != assignerName && !"".equals(assignerName)){
					assignerName = new String(assignerName.getBytes("ISO-8859-1"),"UTF-8");
				}
				
//				//获取用户头像数据
//				if(StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUser(request).getHeadimgurl())){
//					request.setAttribute("headimgurl", UserUtil.getCurrUser(request).getHeadimgurl());
//				}else{
//					Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
//					if(null != obj1){
//						WxuserInfo wxuinfo = (WxuserInfo)obj1;
//						request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
//						UserUtil.getCurrUser(request).setHeadimgurl(wxuinfo.getHeadimgurl());
//					}else{
//						request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
//					}
//				}
				//request.setAttribute("headimgurl", UserUtil.getCurrUser(request).getHeadimgurl());
				
				request.setAttribute("parentId", parentId);
				request.setAttribute("parentType", parentType);
				request.setAttribute("flag", request.getParameter("flag"));
				request.setAttribute("parentName", parentName);
				request.setAttribute("parentTypeName", parentTypeName);
				request.setAttribute("assignerId", assignerId);
				request.setAttribute("assignerName", assignerName);
				request.setAttribute("clickDate", clickDate);
				//redirectUrl 重定向url
				if("report".equals(scheType)){
					return "schedule/addreport";
				}else{
					return "schedule/addForm";
				}
			}
		}
		/**
	     * 日程创建
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/add")
	    public String add(HttpServletRequest request, HttpServletResponse response) throws Exception{
			//openId publicId
			String orgId = request.getParameter("orgId");
			String scheType = request.getParameter("schetype");
			scheType = (null == scheType ? "task" : scheType);

            String crmId = getNewCrmId(request);
       		//判断是否已经绑定 crm 账户
			if(!StringUtils.isNotNullOrEmptyStr(crmId)){
				return "schedule/msg";
			}else{

				//获取下拉列表信息和 责任人的用户列表信息 
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("statusDom", mp.get("status_dom"));
				request.setAttribute("priorityDom", mp.get("priority_dom"));
				request.setAttribute("periodList", mp.get("task_period_list"));
				request.setAttribute("meeting_status_dom", mp.get("meeting_status_dom"));
				request.setAttribute("reminder_time_options", mp.get("reminder_time_options"));
				
				//用户对象
				UserReq uReq = new UserReq();
				uReq.setCurrpage("1");
				uReq.setPagecount("1000");
				uReq.setCrmaccount(crmId);
				uReq.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
				
				//查询客户信息
				Customer sc = new Customer();
				sc.setCrmId(crmId);
				sc.setCurrpage("1");
				sc.setPagecount("1000");
				sc.setViewtype("myallview");
				sc.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sc,"WEB");
				List<CustomerAdd> cList = cResp.getCustomers();
				request.setAttribute("cList", cList);
				
				//查询业务机会信息
				Opportunity opp = new Opportunity();
				opp.setCrmId(crmId);
				opp.setCurrpage("1");
				opp.setPagecount("1000");
				opp.setViewtype("myallview");
				opp.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				OpptyResp oppResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(opp,"WEB");
				List<OpptyAdd> oppList = oppResp.getOpptys();
				request.setAttribute("oppList", oppList);
			
				//设置 openId publicId crmId
				request.setAttribute("crmId", crmId);
				request.setAttribute("orgId", orgId);
				
				//如果从客户或业务机会明细下创建任务时，会带过来parentId和parentName;
				String parentId = request.getParameter("parentId");
				String parentName = request.getParameter("parentName");
				if(null != parentName && !"".equals(parentName)){
					parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
				}
				String parentType = request.getParameter("parentType");
				String parentTypeName = request.getParameter("parentTypeName");
				if(null != parentTypeName && !"".equals(parentTypeName)){
					parentTypeName = new String(parentTypeName.getBytes("ISO-8859-1"),"UTF-8");
				}
				String assignerId = request.getParameter("assignerId");
				String assignerName = request.getParameter("assignerName");
				if(null != assignerName && !"".equals(assignerName)){
					assignerName = new String(assignerName.getBytes("ISO-8859-1"),"UTF-8");
				}
				//获取用户头像数据
				request.setAttribute("headimgurl", UserUtil.getCurrUser(request).getHeadimgurl());
				
				request.setAttribute("parentId", parentId);
				request.setAttribute("parentType", parentType);
				request.setAttribute("flag", request.getParameter("flag"));
				request.setAttribute("parentName", parentName);
				request.setAttribute("parentTypeName", parentTypeName);
				request.setAttribute("assignerId", assignerId);
				request.setAttribute("assignerName", assignerName);
				
				if("task".equals(scheType)){
					return "schedule/addForm";
				}else if("meeting".equals(scheType)){
					return "schedule/addmeet";
				}else if("phone".equals(scheType)){
					return "schedule/addphone";
				}else if("report".equals(scheType)){
					return "schedule/addreport";
				}else if("plan".equals(scheType)){
					return "schedule/addplan";
				}
				return "schedule/addForm";
			}
		}
		
		
		
		
		/**
		 *  新增 任务
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save", method = RequestMethod.POST)
		public String save(Schedule obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController save method id =>" + obj.getId());
			String flag = request.getParameter("flag");
			// request info
			request.setAttribute("command", obj);
			obj.setCrmId(getNewCrmId(request));
			//rowId
			CrmError crmErr = cRMService.getSugarService().getSchedule2SugarService().addSchedule(obj);
			String rowId = crmErr.getRowId();
			if(null != rowId && !"".equals(rowId)){
				request.setAttribute("rowId", rowId);
				request.setAttribute("success", "ok");
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignerId() && !obj.getCrmId().equals(obj.getAssignerId())){
					
					//modify by Kater Yi 2015/3/3 增加消息内容
					StringBuffer sendContent = new StringBuffer();
					sendContent.append(UserUtil.getCurrUser(request).getName()+" 分配了一个任务【"+obj.getTitle()+"】给您");
					String template = PropertiesUtil.getMsgContext("message.replymessage");
					template = template.replace("$$messageid",WxMsgUtil.getMessageShortId(rowId, "schedule"));
					sendContent.append(template);
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerId(),sendContent.toString(), "schedule/detail?rowId="+obj.getRowid()+"&schetype="+obj.getSchetype()+"&orgId="+obj.getOrgId());
				}
				
				if(StringUtils.isNotNullOrEmptyStr(flag)){
					String module = "";
					if("Accounts".equals(obj.getParentType())){
						module="customer";
					}else if("Opportunities".equals(obj.getParentType())){
						module="oppty";
					}else if("Project".equals(obj.getParentType())){
						module = "project";
					}else if("Cases".equals(obj.getParentType()) || "complaint".equals(obj.getParentType())){
						module = "complaint";
						return "redirect:/"+module+"/detail?rowid="+obj.getParentId()+"&crmid="+ obj.getCrmId() + "&modeltype=case&servertype="+ obj.getParentType();
					}else if("Campaigns".equals(obj.getParentType())){
						module="campaigns";
					}else if("Activity".equals(obj.getParentType())){
						module="zjactivity";
					}else if("Contract".equals(obj.getParentType())){
						module="contract";
					}else if("Quote".equals(obj.getParentType())){
						module="quote";
					}else if("Contacts".equals(obj.getParentType())){
						module="contact";
					}
					return "redirect:/"+module+"/detail?rowId="+obj.getParentId()+"&orgId="+obj.getOrgId();
				}
			}else{
				request.setAttribute("rowId", "");
				request.setAttribute("success", "fail");
				request.setAttribute("errorCode", crmErr.getErrorCode());
				request.setAttribute("errorMsg", crmErr.getErrorMsg());
			}
	
			//requestinfo
			request.setAttribute("orgId", obj.getOrgId());
			request.setAttribute("schetype", obj.getSchetype());
	
			return "redirect:/schedule/detail?rowId="+rowId+"&orgId="+obj.getOrgId();
			
		}
		
		/**
		 * 异步的方式   新增 任务
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/asynsave", method = RequestMethod.POST)
		@ResponseBody
		public String asynsave(Schedule obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController asynsave method id =>" + obj.getId());
			if(null == obj.getSchetype() || "".equals(obj.getSchetype())){
				obj.setSchetype("task");
			}
			obj.setCrmId(getNewCrmId(request));
			if(!StringUtils.isNotNullOrEmptyStr(obj.getAssignerId())){
				obj.setAssignerId(obj.getCrmId());
			}
			//rowId
			CrmError crmErr = cRMService.getSugarService().getSchedule2SugarService().addSchedule(obj);
			//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
			if(null != obj.getAssignerId() && !obj.getCrmId().equals(obj.getAssignerId())){
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerId(),request.getSession().getAttribute("assigner")+" 分配了一个任务【"+obj.getTitle()+"】给您", "schedule/detail?rowId="+obj.getRowid()+"&schetype="+obj.getSchetype());
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 查询新的crmid
		 * @param request
		 * @return
		 */
		private String getNewCrmId(HttpServletRequest request){
			String crmId = request.getParameter("crmId");// crmIdID
			String orgId = request.getParameter("orgId");
			try {
				if(StringUtils.isNotNullOrEmptyStr(orgId)){
					String openId = UserUtil.getCurrUser(request).getOpenId();
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
		
		/**
		 * 工作日程 详情信息
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/detail")
		public String detail(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			ZJWKUtil.getRequestURL(request);//获取请求的url
			logger.info("ScheduleController detail method begin=>");
			String rowId = request.getParameter("rowId");//  rowId
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");
			String orgId = request.getParameter("orgId");
			String schetype = request.getParameter("schetype");
			//父任务状态标识  sign:ytj 为父任务已提交状态
			String sign = request.getParameter("sign");
			request.setAttribute("sign", sign);
			schetype = (null == schetype ? "task" : schetype);
			request.setAttribute("return_id", request.getParameter("return_id"));
			request.setAttribute("return_type", request.getParameter("return_type"));
			String workId = request.getParameter("workId");
			String workIndex = request.getParameter("workIndex");
			String workFlag = request.getParameter("workFlag");
			String workViewtype = request.getParameter("workViewtype");
			logger.info("ScheduleController detail method rowId =>" + rowId);
			logger.info("ScheduleController detail method openId =>" + openId);
			logger.info("ScheduleController detail method publicId =>" + publicId);
			String crmId = "";
			if(null!=orgId&&!"".equals(orgId)){
				crmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(openId, publicId, orgId);
			}
			if(null==crmId||"".equals(crmId)){
				Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId); 
				if(obj!=null && !"".equals(obj.toString())){
					crmId=(String)obj;
				}else{
					crmId = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(rowId).getCrm_id();
					if(!StringUtils.isNotNullOrEmptyStr(orgId)){
						orgId = cRMService.getDbService().getCacheScheduleService().getOrgId(openId, publicId, crmId);
					}
				}
			}
			if(!StringUtils.isNotNullOrEmptyStr(crmId)){
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				//判断当前用户是否在团队中
				boolean isTeamFlag = false;
				//查询当前关联的共享用户
				Share share = new Share();
				share.setParentid(rowId);
				share.setParenttype("Tasks");
				share.setCrmId(crmId);
				ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
				List<ShareAdd> shareAdds = sresp.getShares();
				ShareAdd sa = null;
				for(int i=0;i<shareAdds.size();i++){
					sa = shareAdds.get(i);
					if(crmId.equals(sa.getShareuserid())){
						isTeamFlag = true;
						break;
					}
				}
				
				//CRM团队成员
				if(!isTeamFlag){
					TeamPeason search = new TeamPeason();
					search.setRelaId(rowId);
					search.setCurrpages(Constants.ZERO);
					search.setPagecounts(Constants.ALL_PAGECOUNT);
					//查询团队列表-好友列表
					List<TeamPeason> fteamlist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
					for(int i=0;i<fteamlist.size();i++){
						search = fteamlist.get(i);
						if(openId.equals(search.getOpenId())){
							isTeamFlag = true;
							break;
						}
					}
				}
				
				
				//查询单个日程
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleSingle(rowId, crmId,schetype);
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<ScheduleAdd> list = sResp.getTasks();
					//放到页面上
					if(null != list && list.size() > 0){
						ScheduleAdd scheduleAdd = list.get(0);
						
						//判断是否是下属
						if(!isTeamFlag){
							UserReq uReq = new UserReq();
							uReq.setCurrpage("1");
							uReq.setPagecount("1000");
							uReq.setCrmaccount(crmId);
							uReq.setOpenId(openId);
							uReq.setOrgId(orgId);
							uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
							UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
							if(null != uResp && null != uResp.getUsers() && uResp.getUsers().size() >0){
								List<UserAdd> userList = uResp.getUsers();
								UserAdd ua = null;
								for(int i=0;i<userList.size();i++){
									ua = userList.get(i);
									if(scheduleAdd.getAssignerid().equals(ua.getUserid())){
										isTeamFlag = true;
										break;
									}
								}
							}
						}
						//非团队成员
						if(!isTeamFlag){
							if(StringUtils.isNotNullOrEmptyStr(workId)){
								throw new Exception("错误编码：000000000，错误描述：您没有权限查看！");
							}else{
								throw new Exception("错误编码：" + ErrCode.ERR_CODE_1 + "，错误描述：" + ErrCode.ERR_MSG_1);
							}
						}
						if("Activity".equals(scheduleAdd.getRelamodule())){
							CampaignsResp cResp = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsSingle(scheduleAdd.getRelarowid(),crmId);
							List<CampaignsAdd> camlist = cResp.getCams();
							// 放到页面上
							if (null != camlist && camlist.size() > 0) {
								scheduleAdd.setRelaname(camlist.get(0).getName());
							}
						}
						request.setAttribute("sd", scheduleAdd);
					}else{
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
					}
				}else{
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
				
				//lov
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("statusDom", mp.get("status_dom"));
				request.setAttribute("priorityDom", mp.get("priority_dom"));
				request.setAttribute("periodList", mp.get("task_period_list"));
				//request.setAttribute("meeting_status_dom", mp.get("meeting_status_dom"));
				//request.setAttribute("reminder_time_options", mp.get("reminder_time_options"));							

				request.setAttribute("shareusers", shareAdds);
				
				//查询子任务
				Schedule sche = new Schedule();
				sche.setSubtaskid(rowId);
				sche.setViewtype("allview");
				sche.setCurrpage("1");
				sche.setPagecount("999");
				sche.setOpenId(openId);
				ScheduleResp subResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche, "WEB");
				if(null != subResp && null != subResp.getTasks() && subResp.getTasks().size() >0){
					request.setAttribute("subTaskList", subResp.getTasks());
				}else{
					request.setAttribute("subTaskList", new ArrayList<ScheduleAdd>());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("rowId", rowId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("schetype", schetype);
			// 分享控制按钮
			request.setAttribute("shareBtnContol",request.getParameter("shareBtnContol"));
			
			//透传从工作计划过来的记录id
			if (StringUtils.isNotNullOrEmptyStr(workId))
			{
				request.setAttribute("workId", workId);
				request.setAttribute("workIndex", workIndex);
				request.setAttribute("workFlag", workFlag);
				request.setAttribute("workViewtype", workViewtype);
				request.setAttribute("orgId", orgId);
			}
			//拿所有图片
			MessagesExt mext = new MessagesExt();
			mext.setRelaid(rowId);
			mext.setPagecounts(new Integer(999));
			mext.setCurrpages(new Integer(0));
			List<MessagesExt>imgList = cRMService.getDbService().getResourceService().getAllMessagesExtByRelaId(mext);
			if (null != imgList && !imgList.isEmpty()){
				request.setAttribute("imgList", imgList);
			}else{
				request.setAttribute("imgList", new ArrayList<MessagesExt>());
			}
			if("task".equals(schetype)){
				return "schedule/detail";
			}else if("meeting".equals(schetype)){
				return "schedule/mdetail";
			}else if("phone".equals(schetype)){
				return "schedule/pdetail";
			}
			return "schedule/detail";
		}
		
		/**
		 * 工作日程 完成操作
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/scheduleComplete")
		public String scheduleComplete(Schedule obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("scheduleComplete method begin=>");
			String rowId = request.getParameter("rowId");//  rowId
			String return_id =request.getParameter("return_id");
			String return_type =request.getParameter("return_type");
			logger.info("ScheduleController detail method rowId =>" + rowId);
			//查询crmId是否存在
			String crmId = request.getParameter("crmId");
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(crmId != null && !"".equals(crmId)){
				obj.setCrmId(crmId);
				obj.setRowid(rowId);
				CrmError crmErr = cRMService.getSugarService().getSchedule2SugarService().updateScheduleComplete(obj, crmId);
				String errorCode = crmErr.getErrorCode();
				if(!ErrCode.ERR_CODE_0.equals(errorCode)){
				    throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			
			//request info
			request.setAttribute("command", obj);
			
			//commitid为空  则表示为 “保存动作”
			
			//优先判断是否是从工作计划过来的子任务
			String workId = request.getParameter("workId");
			String workFlag = request.getParameter("workFlag");
			String workViewtype = request.getParameter("workViewtype");
			String workIndex = request.getParameter("workIndex");
			String orgId = request.getParameter("orgId");
			if (StringUtils.isNotNullOrEmptyStr(workId))
			{
				return "redirect:/workplan/detail?rowId="+ workId +"&flag="+workFlag+"&orgId="+orgId+"&viewtype="+workViewtype+"&index="+workIndex;
			}else if(StringUtils.isNotNullOrEmptyStr(return_id) && StringUtils.isNotNullOrEmptyStr(return_type)){
				if("custsubtask".equals(return_type)){
					return "redirect:/customer/detail?rowId="+ return_id +"&orgId="+orgId;
				}else if("opptysubtask".equals(return_type)){
					return "redirect:/oppty/detail?rowId="+ return_id +"&orgId="+orgId;
				}
			}
			//判断是否从商机进来的
			String action = request.getParameter("action");
			if ("calendar".equals(action)){
				return "calendar/calendar";
			}

			return "redirect:/schedule/detail?rowId="+ rowId +"&schetype="+obj.getSchetype()+"&orgId="+obj.getOrgId();
		}

		
		
		/**
		 * 查询所有的任务列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/list")
		public String scheduleList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController list method begin=>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String parentType = request.getParameter("parentType");
			String viewtype = request.getParameter("viewtype");
			String assignId = request.getParameter("assignId");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "25" : pagecount);
			       viewtype = (viewtype == null ) ? "myview" : viewtype ;
			       
			logger.info("ScheduleController list method openId =>" + openId);
			logger.info("ScheduleController list method viewtype =>" + viewtype);
			//查询crmId是否存在
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Schedule sche = new Schedule();
				sche.setCrmId(crmId);
				if(!"subview".equals(viewtype) && !"focusview".equals(viewtype)){
					sche.setAssignerId(crmId);
				}else{
					sche.setAssignerId(assignId);
				}
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setViewtype(viewtype);//视图类型
				sche.setOpenId(openId);
				//查询日程列表
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<ScheduleAdd> list = sResp.getTasks();
					request.setAttribute("taskList", list);
				}else{
				    throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			
			//用户对象
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			//关注用户列表
			request.setAttribute("focusUserList", cRMService.getDbService().getUserFocusService().getUserFocusListByPara(crmId));
			//requestinfo
			request.setAttribute("crmId", crmId);
			request.setAttribute("openId", openId);
			request.setAttribute("viewtype", viewtype);
			request.setAttribute("assignerId", assignId);
			request.setAttribute("parentType", parentType);
			
			return "schedule/list";
		}
		
		/**
		 * 查询所有业务机会关联下的任务列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/opptylist")
		public String scheduleOpptyList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController scheduleOpptyList method begin=>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String viewtype = request.getParameter("viewtype");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String parentId = request.getParameter("parentId");
			String parentName = request.getParameter("parentName");
			String schetype = request.getParameter("schetype");
			if(null != parentName && !"".equals(parentName)){
				parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
			}
			String parentType =request.getParameter("parentType");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "25" : pagecount);
			viewtype = (viewtype == null ) ? "allview" : viewtype ; 
			logger.info("ScheduleController scheduleOpptyList method openId =>" + openId);
			logger.info("ScheduleController scheduleOpptyList method viewtype =>" + viewtype);
			logger.info("ScheduleController scheduleOpptyList method parentId =>" + parentId);
			//查询crmId是否存在
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Schedule sche = new Schedule();
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setViewtype(viewtype);//视图类型
				sche.setParentId(parentId);
				sche.setCrmId(crmId);
				sche.setSchetype(schetype);
				sche.setOpenId(openId);
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				List<ScheduleAdd> list = sResp.getTasks();
				request.setAttribute("taskList", list);
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("openId", openId);
			request.setAttribute("viewtype", viewtype);
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentName", parentName);
			request.setAttribute("parentType", parentType);
			request.setAttribute("schetype", schetype);
			if("plan".equals(schetype)){
				return "schedule/planlist";
			}
			return "schedule/opptylist";
		}
		
		/**
		 * 工作日程 用户关注
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/userFocus")
		@SuppressWarnings("unchecked")
		public String userFocus(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String assIdsNames = request.getParameter("assIdsNames");
			assIdsNames = (assIdsNames == null ) ? "" : URLDecoder.decode(assIdsNames, "UTF-8");
			
			logger.info("ScheduleController userFocus method assIdsNames =>" + assIdsNames);
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			if(!"".equals(crmId)){
				String arr [] = assIdsNames.split(",");
				for (int i = 0; i < arr.length; i++) {
					//数组
					String [] subArr = arr[i].split("\\|");
					
					UserFocus sc = new UserFocus();
					sc.setCrmId(crmId);
					sc.setFocusCrmId(subArr[0]);
					
					List<UserFocus> ulist = (List<UserFocus>)cRMService.getDbService().getUserFocusService().findObjListByFilter(sc);
					if(ulist.size() == 0){
						UserFocus uf = new UserFocus();
						uf.setId(Get32Primarykey.getRandom32BeginTimePK());
						uf.setCrmId(crmId);
						
						uf.setFocusCrmId(subArr[0]);
						uf.setFocusCrmName(subArr[1]);
						uf.setType("schedule");//日程类型
						// creator and date
						uf.setCreateBy("admin");// 创建人ID
						uf.setCreateTime(DateTime.currentDate());// 创建时间
						cRMService.getDbService().getUserFocusService().addObj(uf);
					}
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			return "redirect:/schedule/list?viewtype=focusview&approval=new";
		}
		
		/**
		 * 查询所有的任务列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/tasklist")
		@ResponseBody
		public String list(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController list method begin=>");
			
			String crmId = request.getParameter("crmId");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);
			String viewtype = request.getParameter("viewtype");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String status = request.getParameter("status");
			String assignerid = request.getParameter("assignerid");
			String schetype=request.getParameter("schetype");
			       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
			logger.info("ScheduleController list method crmId =>" + crmId);
			logger.info("ScheduleController list method viewtype =>" + viewtype);
			logger.info("crmId:-> is =" + crmId);
			//错误对象
			CrmError crmErr = new CrmError();
			//获取绑定的账户 在sugar系统的id
				Schedule sche = new Schedule();
				//组装查询条件
				sche.setViewtype(viewtype);//视图类型
				sche.setCrmId(crmId);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setStartdate(startDate);
				sche.setEnddate(endDate);
				sche.setStatus(status);
				sche.setSchetype(schetype);
				sche.setOpenId(openId);
				if(null == assignerid || "".equals(assignerid)){
					sche.setAssignerId(crmId);
				}else{
					sche.setAssignerId(assignerid);
				}
				//查询日程列表
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<ScheduleAdd> list = sResp.getTasks();
					//Modify by Kater Yi 2015/3/3
					list = (List<ScheduleAdd>) SortUtil.sortByDesc(list);
					/////////////////////////////
					return JSONArray.fromObject(list).toString();
				}else{
				    crmErr.setErrorCode(sResp.getErrcode());
				    crmErr.setErrorMsg(sResp.getErrmsg());
				}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		
		/**
		 * 异步查询所有的任务列表（日程表）
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/synctasklist")
		@ResponseBody
		public String synctasklist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			
			logger.info("ScheduleController list method begin=>");
			
			String crmId = request.getParameter("crmId");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);
			String viewtype = request.getParameter("viewtype");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String status = request.getParameter("status");
			String assignerid = request.getParameter("assignerid");
			String schetype=request.getParameter("schetype");
			       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
			logger.info("ScheduleController list method crmId =>" + crmId);
			logger.info("ScheduleController list method viewtype =>" + viewtype);
			logger.info("crmId:-> is =" + crmId);
			//错误对象
			// 获取绑定的账户 在sugar系统的id
			Schedule sche = new Schedule();
			// 组装查询条件 //查询时间范围内的数据
			sche.setViewtype(viewtype);// 视图类型
			sche.setCrmId(crmId);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setStartdate(startDate);
			sche.setEnddate(endDate);
			sche.setStatus(status);
			sche.setSchetype(schetype);
			sche.setOpenId(openId);
			if (null == assignerid || "".equals(assignerid)) {
				sche.setAssignerId(crmId);
			} else {
				sche.setAssignerId(assignerid);
			}
			// 查询日程列表
			List<ScheduleAdd> taskList = cRMService.getBusinessService().getCalendarService().getScheduleList(sche);
	
			// 获取未完成的任务
			sche.setStatus("In Progress,Not Started");
			if(StringUtils.isNotNullOrEmptyStr(sche.getStartdate())){
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				try {
					long dif = df.parse(sche.getStartdate()).getTime()-86400*1000;//减一天
					Date date=new Date(); 
					date.setTime(dif);
					sche.setStartdate(df.format(date));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				sche.setEnddate(sche.getStartdate());
			}
			sche.setStartdate(null);
			// 查询日程列表
			List<ScheduleAdd> list = cRMService.getBusinessService().getCalendarService().getScheduleList(sche);
			taskList.addAll(list);
			
			
			// Modify by Kater Yi 2015/3/3
			taskList = (List<ScheduleAdd>) SortUtil.sortByDesc(taskList);
			// ///////////////////////////
			return JSONArray.fromObject(taskList).toString();
		}
		
		
		@RequestMapping("/tlist")
		@ResponseBody
		public String tlist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("ScheduleController list method begin=>");
			
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String assignId = request.getParameter("assignerIds");
			String parentId = request.getParameter("parentId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String status = request.getParameter("status");
			String title = request.getParameter("title");
			String orgId = request.getParameter("orgId");
			String assignerName =request.getParameter("assignerName");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);
			String viewtype = request.getParameter("viewtype");
			       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
			logger.info("ScheduleController list method viewtype =>" + viewtype);
			
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			if (StringUtils.isNotNullOrEmptyStr(orgId))
			{
				crmId = cRMService.getSugarService().getSchedule2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
			}

			logger.info("ScheduleController list method crmId =>" + crmId);
			//错误对象
			CrmError crmErr = new CrmError();
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Schedule sche = new Schedule();
				sche.setViewtype(viewtype);//视图类型
				sche.setCrmId(crmId);
				sche.setAssignerId(assignId);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setParentId(parentId);
				sche.setStartdate(startDate);
				sche.setEnddate(endDate);
				sche.setOpenId(openId);
				sche.setStatus(status);
				sche.setTitle(title);
				sche.setAssignerName(assignerName);
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				List<ScheduleAdd> list = new LinkedList<ScheduleAdd>();
				List<ScheduleAdd> listtemp = sResp.getTasks();
				if (assignId !=null && "".equals(assignId) == false){
					for(ScheduleAdd data : listtemp){
						if (assignId.indexOf(data.getAssignerid())>=0){
							list.add(data);
						}
					}
				}else{
					list.addAll(listtemp);
				}
				
				if(list!=null&&list.size()>0){
					return JSONArray.fromObject(list).toString();
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001004);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 异步查询所有的任务个数
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/alist")
		@ResponseBody
		public String alist(HttpServletRequest request,HttpServletResponse response) throws Exception{
			logger.info("ScheduleController list method begin=>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String viewtype = request.getParameter("viewtype");
			String schetype=request.getParameter("schetype");
			viewtype = (viewtype == null ) ? "allview" : viewtype ; 
			String parentId = request.getParameter("parentId");
			String currpage = request.getParameter("currpage");
			       currpage = (currpage == null ) ? "1" : currpage ; 
			String pagecount = request.getParameter("pagecount");
			       pagecount = (pagecount == null ) ? "25" : pagecount ; 
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("ScheduleController alist method crmId =>" + crmId);
			logger.info("ScheduleController alist method viewtype =>" + viewtype);
			logger.info("ScheduleController alist method parentId =>" + parentId);
			logger.info("ScheduleController alist method pagecount =>" + pagecount);
			logger.info("crmId:-> is =" + crmId);
			//error 对象
			CrmError crmErr = new CrmError();
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Schedule sche = new Schedule();
				sche.setViewtype(viewtype);//视图类型
				sche.setCrmId(crmId);
				sche.setParentId(parentId);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setSchetype(schetype);
				sche.setOpenId(openId);
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				List<ScheduleAdd> list = sResp.getTasks();
				if(list!=null&&list.size()>0){
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
					crmErr.setRowCount(list.size() + "");
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
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
			request.setAttribute("orgId", request.getParameter("orgId"));
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
			String openId = UserUtil.getCurrUser(request).getOpenId();
			
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			if(!"".equals(crmId)){
				//用户对象
				UserReq uReq = new UserReq();
				uReq.setCurrpage("1");
				uReq.setPagecount("1000");
				uReq.setCrmaccount(crmId);
				uReq.setOpenId(openId);
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			}
			request.setAttribute("openId", openId);
			request.setAttribute("crmId", crmId);
			return "schedule/calendar";
		}
		
		/**
		 * 初始化 报表生成页面 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/genReport")
		public String genReport(HttpServletRequest request,HttpServletResponse response) throws Exception{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String crmId = request.getParameter("crmId");
			String startdate = request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			
			//用户对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(crmId);
			uReq.setFlag("all");
			uReq.setOpenId(openId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			//request info 
			request.setAttribute("openId", openId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("startdate", startdate);
			request.setAttribute("enddate", enddate);
			
			return "schedule/genReport";
		}
		
		/**
		 * 生成工作报告
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/sendWorkReport")
		@ResponseBody
		public String sendWorkReport(HttpServletRequest request,HttpServletResponse response) throws Exception{
            logger.info("ScheduleController genWorkReport method begin=>");
			
			String crmId = request.getParameter("crmId");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
				   currpage = (null == currpage ? "1" : currpage);
				   pagecount = (null == pagecount ? "25" : pagecount);
				   
			String viewtype = request.getParameter("viewtype");
			       viewtype = (viewtype == null ) ? "myview" : viewtype ;
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String status = request.getParameter("status");
			String assignerid = request.getParameter("assignerid");
			String approvename = request.getParameter("approvename");
			String email = request.getParameter("email");
			String assigner = request.getParameter("assigner");
			       
			logger.info("ScheduleController genWorkReport method crmId =>" + crmId);
			logger.info("ScheduleController genWorkReport method viewtype =>" + viewtype);
			logger.info("ScheduleController genWorkReport method crmId:-> is =" + crmId);
			
			//错误对象
			CrmError crmErr = new CrmError();
			//获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Schedule sche = new Schedule();
				//组装查询条件
				sche.setViewtype(viewtype);//视图类型
				sche.setCrmId(crmId);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setStartdate(startDate);
				sche.setEnddate(endDate);
				sche.setStatus(status);
				sche.setOpenId(openId);
				if(null == assignerid || "".equals(assignerid)){
					sche.setAssignerId(crmId);
				}else{
					sche.setAssignerId(assignerid);
				}
				//查询日程列表
				ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					//查询日程任务列表
					List<ScheduleAdd> list = sResp.getTasks();
					//创建日程任务的 excel 报告
					Object [] rst = createScheWorkReportExl(list, assigner,approvename,email, startDate, endDate);
					//发送工作报告邮件
					sendWorkReportEmail(startDate, email, assigner, approvename, (String)rst[0], (File)rst[1]);
					
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
				}else{
				    crmErr.setErrorCode(sResp.getErrcode());
				    crmErr.setErrorMsg(sResp.getErrmsg());
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 创建日程任务的 excel 报告
		 * @param list
		 * @param assigner
		 * @param approvename
		 * @param email
		 * @param startDate
		 * @param endDate
		 * @return
		 */
		private Object[] createScheWorkReportExl(List<ScheduleAdd> list, String assigner,String approvename, String email,
				                               String startDate, String endDate){
			try {
				File f = new File("test.xls");
				if(!f.exists()){
					f.createNewFile();
				}
				FileOutputStream os = new FileOutputStream(f);
				 //创建工作薄
				WritableWorkbook workbook = Workbook.createWorkbook(os);
				//创建新的一页
				WritableSheet sheet = workbook.createSheet("First Sheet",0);
				sheet.setColumnView(0, 20);
				sheet.setColumnView(1, 20);
				sheet.setColumnView(2, 20);
				sheet.setColumnView(3, 20);
				
				//合并单元格
				sheet.mergeCells(0, 0, 3, 0);
				sheet.setRowView(0, 750);
				//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
				Label rtile = new Label(0, 0, "工作报告");
				rtile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,15));
				sheet.addCell(rtile);
				
				//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
				Label name = new Label(0, 1, "人员姓名");
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(name);
				Label nametxt = new Label(1, 1, assigner);
				nametxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(nametxt);
				sheet.setRowView(1, 500);
				
				Label date = new Label(0,2,"日期");
				date.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(date);
				Label content = new Label(1,2,"工作内容");
				content.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(content);
				Label fee = new Label(2,2,"收费(单位:小时)");
				fee.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(fee);
				sheet.setRowView(2, 500);
				
				int count = 3;//从第三行开始
				int wdays = 0;
				int dbc = 0;
				//遍历日期
                for (long i = DateTime.dateTimeParse(startDate, "yyyy-MM-dd"); 
                		i <= DateTime.dateTimeParse(endDate, "yyyy-MM-dd"); i += 86400000) {
                	SimpleDateFormat sdf = new SimpleDateFormat("dd");
                	String d1 = sdf.format(i);
                	//显示数据
            		Label tmpc = new Label(0, count, d1 + "日");
            		sheet.setRowView(count, 500);
            		tmpc.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
    				sheet.addCell(tmpc);
    				//遍历数据集合
    				int nc = 0;
            		for (int j = 0; j < list.size(); j++) {
            			ScheduleAdd sa = list.get(j);
            			String sd = sa.getStartdate();
            			String ed = sa.getEnddate();
            			String d2 = sd.split(" ")[0].split("-")[2];
            			String title = sa.getTitle();
            			if(d1.equals(d2)){
            				Long db = DateTime.daysBetween(ed, sd, false, 3600000l);
            				
            				Label tmpc2 = new Label(1, count, title);
            				tmpc2.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
            				sheet.addCell(tmpc2);
            				Label tmpc3 = new Label(2, count, db.toString());
            				tmpc3.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
            				sheet.addCell(tmpc3);
            				
            				count ++;
            				wdays ++;//工作日计数
            				dbc += db;//工时
            			}else{
            				nc ++;
            			}
					}
            		if(nc == list.size()){
            			Label tmpc1 = new Label(1, count, "无");
            			tmpc1.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
        				sheet.addCell(tmpc1);
        				Label tmpc2 = new Label(2, count, "无");
        				tmpc2.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
        				sheet.addCell(tmpc2);
        				
            			count ++;
            		}
				}
                
                //合计
                Label hj = new Label(0, count, "合计(工时)");
                hj.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(hj);
				Label hjc = new Label(2, count, String.valueOf(dbc));
				hjc.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(hjc);
				sheet.setRowView(count, 500);
				count++;
				//合计人天
				Label hjrt = new Label(0, count, "合计(人/天)");
				hjrt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(hjrt);
				Label hjrtc = new Label(2, count, String.valueOf(wdays));
				hjrtc.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(hjrtc);
				sheet.setRowView(count, 500);
				count++;
				//项目人员
				Label pp = new Label(0, count, "项目人员");
				pp.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(pp);
				Label ppv = new Label(1, count, assigner);
				ppv.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(ppv);
				sheet.setRowView(count, 500);
				count++;
				//项目人员日期
				Label ppd = new Label(0, count, "日期");
				ppd.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(ppd);
				Label ppdv = new Label(1, count, DateTime.currentDate("yyyy-MM-dd"));
				ppdv.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(ppdv);
				sheet.setRowView(count, 500);
				count++;
				
				//把创建的内容写入到输出流中，并关闭输出流
				workbook.write();
				workbook.close();
				os.close();
				
				//返回数据
		        return new Object[]{String.valueOf(wdays), f};
		        
			} catch (Exception e) {
				return new String[]{};
			}
		}
		
		/**
		 * 发送工作报告邮件
		 * @param startDate
		 * @param email
		 * @param assigner
		 * @param approvename
		 * @param wdays
		 * @param filePath
		 */
		private void sendWorkReportEmail(String startDate, String email, String assigner,String approvename, String wdays, File f){
			SenderInfor senderInfor = new SenderInfor();
	    	String t = startDate.split("-")[0] + "年" + startDate.split("-")[1] + "月";
	    	 
	        String subject = "请您确认"+ assigner + " " +t +"工作报告, 共" + wdays +"天, 谢谢!";  
	        StringBuilder builder = new StringBuilder();  
	        builder.append("<div>"+ approvename +", 您好!</br></br>请您确认"+ assigner + " " + t +"工作报告, 共" + wdays +"天, 具体信息请阅附件的工作报告, 谢谢!</div>");  
	        String c = builder.toString();  
	        senderInfor.setToEmails(email);  
	        senderInfor.setSubject(subject);  
	        senderInfor.setContent(c);
	        Map<String, String> m = new HashMap<String, String>();
	        m.put(assigner + " " + t +"工作报告" + ".xls", f.getAbsolutePath());
	        senderInfor.setAttachments(m);
	        MailUtils.sendEmail(senderInfor);
	        
	        f.delete();
		}
		
		/**
		 * 设置格式
		 * @return
		 */
		private WritableCellFormat getCellFormat(Colour color, Alignment posi ,Integer size){
			try {
				//设置字体;  
				WritableFont font1 = new WritableFont(WritableFont.createFont("微软雅黑"), size, WritableFont.NO_BOLD);
				//WritableFont font1 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.RED);  
  
				WritableCellFormat cellFormat1 = new WritableCellFormat(font1);  
				//设置背景颜色;  
				//cellFormat1.setBackground(color); 
				//设置自动换行;  
				cellFormat1.setWrap(true);  
				//设置文字居中对齐方式;  
				cellFormat1.setAlignment(posi);  
				//设置垂直居中;  
				cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);
				
				return cellFormat1;
			} catch (WriteException e) {
				logger.info(e.getMessage());
				return null;
			} 
		}
		
		/**
		 * 删除实体对象
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/delSchedule")
		@ResponseBody
		public String delSchedule(Schedule obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String rowId = request.getParameter("rowid");
			String tasksource =  request.getParameter("tasksource");
			if("workplan".equals(tasksource)){
				if(StringUtils.isNotNullOrEmptyStr(rowId)&&rowId.contains(",")){
					for(String rowid : rowId.split(",")){
						cRMService.getBusinessService().getCalendarService().deleteSchedule(rowid);
					}
				}				
			}else{
				cRMService.getBusinessService().getCalendarService().deleteSchedule(rowId);
			}
			return "success";
		}
		
		/**
		 * 工作计划中异步更新任务状态
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/asyUpdTask")
		@ResponseBody
		public String asyUpdTask(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String rowId = request.getParameter("rowId");
			String status = request.getParameter("status");
			String schetype = request.getParameter("schetype");
			String orgId = request.getParameter("orgId");
			String crmId = "";
			if(null!=orgId&&!"".equals(orgId)){
				crmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
			}
			String str ="";
			ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleSingle(rowId, crmId,schetype);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ScheduleAdd> list = sResp.getTasks();
				if(null != list && list.size() > 0){
					ScheduleAdd scheduleAdd = list.get(0);
					scheduleAdd.setStatus(status);
					scheduleAdd.setRowid(rowId);
					Schedule schedule = new Schedule();
					try {
						BeanUtils.copyProperties(schedule, scheduleAdd);
					} catch (Exception e) {
						e.printStackTrace();
					} 
					schedule.setOrgId(orgId);
					schedule.setCycliKey(scheduleAdd.getCyclikey());
					schedule.setCycliValue(scheduleAdd.getCyclivalue());
					schedule.setSchetype(schetype);
					schedule.setParentId(scheduleAdd.getRelarowid());
					schedule.setParentType(scheduleAdd.getRelamodule());
					CrmError crmErr = cRMService.getSugarService().getSchedule2SugarService().updateScheduleComplete(schedule, crmId);
					errorCode = crmErr.getErrorCode();
					if(!ErrCode.ERR_CODE_0.equals(errorCode)){
						str = "9999";
					}else{
						str="success";
					}
				}
			}
			return str;
		}
}
