package com.takshine.wxcrm.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.CacheOpptyService;
import com.takshine.wxcrm.service.Campaigns2ZJMKTService;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.wxcrm.service.impl.Contact2SugarServiceImpl;

/**
 * 业务机会  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/oppty")
public class OpptyController {
	    // 日志
		protected static Logger logger = Logger.getLogger(OpptyController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		
		/**
		 * 添加业务机会
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/get")
		public String get(HttpServletRequest request,HttpServletRequest response) throws Exception  {
			//openId appId
			String orgId = request.getParameter("orgId");
			WxuserInfo wxuser = UserUtil.getCurrUser(request);
			String openId = wxuser.getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");
			//选择客户时，会带过来parentId和parentName;
			String parentId = request.getParameter("parentId");
			String parentName = request.getParameter("parentName");
			//增加业务机会(增加客户)
			String customerid = request.getParameter("customerid");
			String customername = request.getParameter("customername");
			String parentType = request.getParameter("parentType"); 
			if(StringUtils.isNotNullOrEmptyStr(customername)){
				customername = URLDecoder.decode(customername,"UTF-8");
				customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
			}
			String campaigns = request.getParameter("campaigns"); 
			request.setAttribute("orgId", orgId);
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentName", parentName);
			request.setAttribute("parentType", parentType);
			request.setAttribute("customername", customername);
			//检测绑定
            String crmId = getNewCrmId(request);
       		if(StringUtils.isNotNullOrEmptyStr(crmId)){
				//crmId
				request.setAttribute("crmId", crmId);
				request.setAttribute("assignerid", crmId);
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("campaigns", campaigns);
				//获取下拉列表信息和 责任人的用户列表信息 
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("lead_source", mp.get("lead_source_dom"));
				request.setAttribute("sales_stage", mp.get("sales_stage_dom"));
				request.setAttribute("industrydom", mp.get("industry_dom"));
				request.setAttribute("accnttypedom", mp.get("account_type_dom"));
		    	request.setAttribute("customerid", customerid);
		    	request.setAttribute("customername", customername);
		    	//获取用户头像数据
				request.setAttribute("headimgurl",wxuser.getHeadimgurl());
				request.setAttribute("viewtype", Constants.SEARCH_VIEW_TYPE_ALLVIEW);
				return "oppty/newadd";
			}
       		return "oppty/msg";
		}
		
		/**
		 * 添加业务机会信息
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/saveOppty", method = RequestMethod.POST)
		public String save(Opportunity obj ,HttpServletRequest request,HttpServletResponse response) throws Exception{
			
			logger.info("opptyController save method id =>" + obj.getId());
			// request info
			request.setAttribute("command", obj);
			//rowId
			String parentType = request.getParameter("parentType");
			obj.setCrmId(getNewCrmId(request));
			CrmError crmErr = cRMService.getSugarService().getOppty2SugarService().addOppty(obj);
			String rowId = crmErr.getRowId();
			String success = "fail";
			//判断rowId是否为空
			if(null != rowId && !"".equals(rowId)){
				request.setAttribute("rowId", rowId);
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignId() && !obj.getCrmId().equals(obj.getAssignId())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignId(),UserUtil.getCurrUser(request).getName()+" 分配了一个业务机会【"+obj.getOpptyname()+"】给您", "oppty/detail?rowId="+rowId+"&orgId="+obj.getOrgId());
				}
				//
				
				success = "ok";
				//如果有联系人，则保存业务机会与联系人的关系
				String contactid = obj.getContactid();
				if(null != contactid && !"".equals(obj.getContactid())){
					String[] conids = contactid.split(",");
					Contact con = null;
					for(int i = 0 ; i < conids.length ; i++ ){
						if(null != conids[i] && !"".equals(conids[i])){
							con = new Contact();
							con.setCrmId(obj.getCrmId());
							con.setParentId(rowId);
							con.setParentType("Opportunities");
							con.setRowid(conids[i]);
							crmErr = cRMService.getSugarService().getContact2SugarService().saveContact(con);
							logger.info("opptyController save method 添加联系人结果->" + crmErr.getErrorCode() + crmErr.getErrorMsg());
						}
					}
				}
			}else{
				request.setAttribute("rowId", "");
				request.setAttribute("errorCode", crmErr.getErrorCode());
				request.setAttribute("errorMsg", crmErr.getErrorMsg());
				throw new CRMException(crmErr.getErrorCode(), crmErr.getErrorMsg());
			}
			if("Customer".equals(parentType)){
				return "redirect:/customer/detail?rowId="+obj.getCustomerid()+"&orgId="+obj.getOrgId();
			}
			if("Activity".equals(parentType) && !"".equals(obj.getCampaigns())){
				return "redirect:/zjactivity/detail?rowId="+obj.getCampaigns()+"&orgId="+obj.getOrgId();
			}
			if(!"".equals(obj.getCampaigns())){
				return "redirect:/campaigns/detail?rowId="+obj.getCampaigns()+"&orgId="+obj.getOrgId();
			}
			return "redirect:/oppty/detail?rowId=" + rowId+"&orgId="+obj.getOrgId();
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
			request.setAttribute("orgId", request.getParameter("orgId"));
			return "oppty/msg";
		}
		
		/**
		 * 查询 业务机会  信息列表
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/list")
		@ResponseBody
		public String list(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			String str = "";
			// search param
			String crmId = request.getParameter("crmId");// crmIdID
			String viewtype = request.getParameter("viewtype");// viewtype
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String firstchar = request.getParameter("firstchar");
			String orderString = request.getParameter("orderString");
			String orgId = request.getParameter("orgId");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "25" : pagecount);
			firstchar = (firstchar == null ) ? "" : firstchar ;
			//error 对象
			CrmError crmErr = new CrmError();
			if(null != crmId && !"".equals(crmId)){
				Opportunity oppty = new Opportunity();
				oppty.setCrmId(getNewCrmId(request));
				oppty.setViewtype(viewtype);
				oppty.setCurrpage(currpage);
				oppty.setPagecount(pagecount);
				oppty.setFirstchar(firstchar);
				oppty.setOrderByString(orderString);
				oppty.setOrgId(orgId);
				oppty.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				//查询返回结果
				OpptyResp oppResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(oppty,"WX");
				String errorCode = oppResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<OpptyAdd> cList = oppResp.getOpptys();
					logger.info("cList is ->" + cList.size());
					str = JSONArray.fromObject(cList).toString();
				}else{
					crmErr.setErrorCode(oppResp.getErrcode());
					crmErr.setErrorMsg(oppResp.getErrmsg());
					str = JSONObject.fromObject(crmErr).toString();
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
				str = JSONObject.fromObject(crmErr).toString();
			}
			logger.info("str is ->" + str);
			return str;
		}
		
		/**
		 * 异步查询业务机会列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/opplist")
		@ResponseBody
		public String opplist(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			String str = "";
			// search param
			String viewtype = request.getParameter("viewtype");// viewtype
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String startDate = request.getParameter("startDate");//关闭的开始时间
			String endDate = request.getParameter("endDate");//关闭的结束时间
			String assignId = request.getParameter("assignId");
			String opptyname = request.getParameter("opptyname");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "25" : pagecount);
			String cstartdate = request.getParameter("cstartDate");//创建的开始时间
			String cenddate = request.getParameter("cendDate");//创建的结束时间
			String dateclosed = request.getParameter("dateclosed");
			String salesStage = request.getParameter("salesstage");
			String orderString = request.getParameter("orderString");
			String failure = request.getParameter("failure");//失败原因
			String rate = request.getParameter("rate"); //成单
			//错误对象
			CrmError crmErr = new CrmError();
			
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			//判断crmId是否为空
			if(null != crmId && !"".equals(crmId)){
				Opportunity oppty = new Opportunity();
				oppty.setCrmId(getNewCrmId(request));
				oppty.setViewtype(viewtype);
				oppty.setCurrpage(currpage);
				oppty.setPagecount(pagecount);
				oppty.setOpptyname(opptyname);//业务机会名称
				oppty.setStartDate(startDate);//关闭的开始时间
				oppty.setEndDate(endDate);//关闭的结束时间
				oppty.setOrderByString(orderString);//
				if (null != cstartdate && !"".equals(cstartdate)) {
					oppty.setCstartdate(cstartdate.replaceAll("-", ""));//创建的开始时间
				}
				if (null != cenddate && !"".equals(cenddate)) {
					oppty.setCenddate(cenddate.replaceAll("-", ""));//创建的结束时间
				}
				if (null != dateclosed && !"".equals(dateclosed)) {
					oppty.setDateclosed(dateclosed.replaceAll("-", ""));
				}
				oppty.setAssignId(assignId);
				oppty.setFailreason(failure);
				oppty.setSalesstage(salesStage);//业务机会阶段
				oppty.setRate(rate);  //成单
				oppty.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				oppty.setOrgId(request.getParameter("orgId"));
				//查询返回结果
				OpptyResp oppResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(oppty,"WEB");
				List<OpptyAdd> cList = oppResp.getOpptys();
				logger.info("cList is ->" + cList.size());
				if(cList!=null&&cList.size()>0){
					str = JSONArray.fromObject(cList).toString();
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001004);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
					str = JSONObject.fromObject(crmErr).toString();
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
				str = JSONObject.fromObject(crmErr).toString();
			}
			logger.info("str is ->" + str);
			return str;
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
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			String viewtype = request.getParameter("viewtype");
			viewtype = (viewtype == null ) ? "myallview" : viewtype ; 
			String parentId = request.getParameter("parentId");
			String campaigns = request.getParameter("campaigns");
			String crmId =UserUtil.getCurrUser(request).getCrmId();
			logger.info("ScheduleController alist method crmId =>" + crmId);
			logger.info("ScheduleController alist method viewtype =>" + viewtype);
			logger.info("ScheduleController alist method parentId =>" + parentId);
			logger.info("crmId:-> is =" + crmId);
			//error 对象
			CrmError crmErr = new CrmError();
			// 获取绑定的账户 在sugar系统的id
			if(null != crmId && !"".equals(crmId)){
				Opportunity sche = new Opportunity();
				sche.setViewtype(viewtype);//视图类型
				sche.setCrmId(crmId);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setParentId(parentId);
				sche.setCampaigns(campaigns);
				sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(sche,"WEB");
				List<OpptyAdd> list = sResp.getOpptys();
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
		 * 查询新的crmid
		 * @param request
		 * @return
		 */
		private String getNewCrmId(HttpServletRequest request) throws Exception{
			String crmId = request.getParameter("crmId");// crmIdID
			String orgId = request.getParameter("orgId");
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				return UserUtil.getCurrUser(request).getCrmId();
			}
			try {
				if(StringUtils.isNotNullOrEmptyStr(orgId)){
					String openId = UserUtil.getCurrUser(request).getOpenId();
					logger.info("openId = >" + openId);
					String newCrmId = cRMService.getSugarService().getOppty2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
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
			logger.info("CustomerController detail method begin=>");
			String rowId = request.getParameter("rowId");//  rowId
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String orgId = request.getParameter("orgId");
			//视图类型 
			String viewtype = request.getParameter("viewtype");
			
			logger.info("CustomerController detail method rowId =>" + rowId);
			logger.info("CustomerController detail method openId =>" + openId);
			logger.info("CustomerController detail method orgId =>" + orgId);
			
			// 绑定对象
			String crmId = "";
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				crmId = cRMService.getSugarService().getOppty2SugarService().getCrmIdByOrgId(openId,PropertiesUtil.getAppContext("app.publicId"), orgId);
			}else{
				crmId = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(rowId).getCrm_id();
				orgId = cRMService.getDbService().getCacheOpptyService().getOrgId(openId,PropertiesUtil.getAppContext("app.publicId"), crmId);
			}
			
			if (!StringUtils.isNotNullOrEmptyStr(crmId)) {
				crmId = UserUtil.getCurrUser(request).getCrmId();
			}
			RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT + openId + "_" + orgId, crmId);
			String opptycode = Get32Primarykey.get8RandomValiteCode(8);
			logger.info("crmId:-> is =" + crmId);
			// 获取绑定的账户 在sugar系统的id
			if (!"".equals(crmId)) {
				//判断当前用户是否在团队中
				boolean isTeamFlag = false;
				//查询当前关联的共享用户
				Share share = new Share();
				share.setParentid(rowId);
				share.setParenttype("Opportunities");
				share.setCrmId(crmId);
				ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
				List<ShareAdd> shareAdds = sresp.getShares();
				
				if(!(null!=viewtype && "teamview".equals(viewtype)))
				{
					//非下属的商机才做以下的校验
					ShareAdd sa = null;
					for(int i=0;i<shareAdds.size();i++){
						sa = shareAdds.get(i);
						if(crmId.equals(sa.getShareuserid())){
							isTeamFlag = true;
							break;
						}
					}
					List<TeamPeason> fteamlist = null;
					//CRM团队成员
					if(!isTeamFlag){
						TeamPeason search = new TeamPeason();
						search.setRelaId(rowId);
						//查询团队列表-好友列表
						fteamlist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
						for(int i=0;i<fteamlist.size();i++){
							search = fteamlist.get(i);
							if(openId.equals(search.getOpenId())){
								isTeamFlag = true;
								break;
							}
						}
					}
					//非团队成员
					if(!isTeamFlag){
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1 + "，错误描述：" + ErrCode.ERR_MSG_1);
					}
					
				}
				
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunitySingle(rowId,crmId);
				String errorCode = sResp.getErrcode();
				if (ErrCode.ERR_CODE_0.equals(errorCode)) {
					List<OpptyAdd> list = sResp.getOpptys();
					// 放到页面上
					if (null != list && list.size() > 0) {
						request.setAttribute("sd", list.get(0));
						request.setAttribute("oppName", list.get(0).getName());
						request.setAttribute("opptycode", opptycode);
						
						//跟进历史
						List<OpptyAuditsAdd> auditList = list.get(0).getAudits();
						//查询前台共享历史
//						if(null == fteamlist){
//							TeamPeason t = new TeamPeason();
//							t.setRelaId(rowId);
//							//查询团队列表-好友列表
//							fteamlist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(t);
//						}
//						TeamPeason t = null;
						OpptyAuditsAdd audit = null;
//						for (int i = 0; i < fteamlist.size(); i++) {
//							t = fteamlist.get(i);
//							if(!StringUtils.isNotNullOrEmptyStr(t.getCreateName())){
//								continue;
//							}
//							audit = new OpptyAuditsAdd();
//							audit.setOptype("sharefriends");
//							audit.setAftervalue(t.getNickName());
//							audit.setOpdate(DateTime.date2Str(t.getCreateTime(),
//									DateTime.DateFormat1));
//							audit.setOpid(t.getParty_row_id());
//							audit.setOpname(t.getCreateName());
//							auditList.add(audit);
//						}
						request.setAttribute("auditList",auditList);// 业务机会跟进数据
						request.setAttribute("conList", list.get(0).getCons());// 业务机会合同数据
						request.setAttribute("shareusers", shareAdds);
						
						//计算相关数据数量
						int conCount = 0;//联系人
						int productCount = 0;//产品
						int priceCount = 0;//报价
						int taskCount = 0;//任务
						int resCount = 0;//资料
						if (!list.get(0).getAudits().isEmpty())
						{
							for (int i=0;i<auditList.size();i++)
							{
								audit = auditList.get(i);
								if ("tasks".equals(audit.getOptype()))
								{
									taskCount++;
								}
								else if ("product".equals(audit.getOptype()))
								{
									productCount++;
								}
								else if ("contact".equals(audit.getOptype()))
								{
									conCount++;
								}
								else if ("price".equals(audit.getOptype()))
								{
									priceCount++;
								}
								else if ("resource".equals(audit.getOptype()))
								{
									resCount++;
								}
							}
						}
						
						//缓存到界面
						request.setAttribute("conCount", conCount);
						request.setAttribute("productCount", productCount);
						request.setAttribute("taskCount", taskCount);
						request.setAttribute("priceCount", priceCount);
						request.setAttribute("resCount", resCount);
						//end by hezhi
						
						//查询相关任务
						Schedule sche = new Schedule();
						sche.setParentId(rowId);
						sche.setParentType("Opportunities");
						sche.setCrmId(crmId);
						sche.setViewtype(Constants.SEARCH_VIEW_TYPE_MYALLVIEW);
						sche.setOpenId(openId);
						
						ScheduleResp taskResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche, "WX");
						request.setAttribute("taskList", taskResp.getTasks());
	
						// 业务机会阶段
						Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
						request.setAttribute("salesStageList",mp.get("sales_stage_dom"));// 业务机会阶段
						request.setAttribute("failReasonList",mp.get("fail_reason_list"));// 业务机会失败原因列表
						request.setAttribute("statusDom", mp.get("status_dom"));
						request.setAttribute("periodList", mp.get("task_period_list"));
						
					} else {
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003
								+ "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
					}
	
				} else {
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述："
							+ sResp.getErrmsg());
				}
			} else {
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
						+ ErrCode.ERR_MSG_UNBIND);
			}
	
			//消息处理
			Messages msg = new Messages();
			msg.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			msg.setRelaId(rowId);
			cRMService.getDbService().getMessagesService().updateMessagesFlag(msg);
			
			request.setAttribute("rowId", rowId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("openId", openId);
//			RedisCacheUtil.set("WK_Opportunities_" + openId + "_" + rowId,DateTime.currentDateTime(DateTime.DateTimeFormat2)); // 缓存最后访问时间
			return "oppty/newdetail";
		}
		
		
		/**
		 * 查询业务机会列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/opptylist")
		public String opptyList(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("OpptyController list method begin=>");
			String viewtype = request.getParameter("viewtype");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String campaigns =  request.getParameter("campaigns");
			String orderString =  request.getParameter("orderString");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
		    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
			logger.info("OpptyController list method viewtype =>" + viewtype);
			//查询条件
			String startDate = request.getParameter("startDate");//关闭的开始时间
			String endDate = request.getParameter("endDate");//关闭的结束时间
			String assignId = request.getParameter("assignerId");
			String opptyname = request.getParameter("opptyname");
			String cstartdate = request.getParameter("cstartDate");//创建的开始时间
			String cenddate = request.getParameter("cendDate");//创建的结束时间
			String salesStage = request.getParameter("salesstage");
			String dateclosed = request.getParameter("dateclosed");
			String failure = request.getParameter("failure");//失败原因
			String parentType=request.getParameter("parentType");//相关类型
			String parentId=request.getParameter("parentId");
			String tagName = request.getParameter("tagName");
			String starflag = request.getParameter("starflag");
			String orgId = request.getParameter("orgId");

			//绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				Opportunity opp = new Opportunity();
				opp.setCrmId(crmId);
				opp.setViewtype(viewtype);//视图类型
				currpage = Integer.parseInt(currpage)+"";
				opp.setCurrpage(currpage);
				opp.setPagecount(pagecount);
				opp.setOpptyname(opptyname);//业务机会名称
				opp.setStartDate(startDate);//关闭的开始时间
				opp.setEndDate(endDate);//关闭的结束时间
				opp.setCampaigns(campaigns);
				opp.setParentId(parentId);
				opp.setParentType(parentType);
				if (null != cstartdate && !"".equals(cstartdate)) {
					opp.setCstartdate(cstartdate.replaceAll("-", ""));//创建的开始时间
				}
				if (null != cenddate && !"".equals(cenddate)) {
					opp.setCenddate(cenddate.replaceAll("-", ""));//创建的结束时间
				}
				if (null != dateclosed && !"".equals(dateclosed)) {
					opp.setDateclosed(dateclosed.replaceAll("-", ""));
				}
				opp.setFailreason(failure);
				opp.setSalesstage(salesStage);//业务机会阶段
				opp.setAssignId(assignId);
				opp.setOrderByString(orderString);
				opp.setTagName(tagName);
				opp.setStarflag(starflag);
				opp.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				opp.setOrgId(orgId);
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(opp,"WEB");
				List<OpptyAdd> list = sResp.getOpptys();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("oppList", list);
				}else{
					request.setAttribute("oppList", new ArrayList<OpptyAdd>());
				}
				
				//用户对象
				UserReq uReq = new UserReq();
				uReq.setCrmaccount(crmId);
				uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
				uReq.setCurrpage("1");
				uReq.setPagecount("1000");
				uReq.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
				
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("salesStageList", mp.get("sales_stage_dom"));//业务机会阶段
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("viewtype", viewtype);
			request.setAttribute("pagecount", pagecount);
			request.setAttribute("currpage", currpage);
			request.setAttribute("cstartdate", cstartdate);
			request.setAttribute("cenddate", cenddate);
			request.setAttribute("dateclosed", dateclosed);
			request.setAttribute("startDate", startDate);
			request.setAttribute("endDate", endDate);
			request.setAttribute("opptyname", opptyname);
			request.setAttribute("assignId", assignId);
			request.setAttribute("failure", failure);
			request.setAttribute("salesstage", salesStage);
			request.setAttribute("campaigns", campaigns);
			request.setAttribute("parentType", parentType);
			request.setAttribute("orderString", orderString);

			//从客户协同进入
			if (StringUtils.isNotNullOrEmptyStr(request.getParameter("source")))
			{
				request.setAttribute("source", request.getParameter("source"));
				return "oppty/outlist";
			}
			return "oppty/list";
		}
		
		
		/**
		 * 关系评估
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/rela")
		public String relation(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("OpptyController list method begin=>");
			String crmId = request.getParameter("crmId");
			String rowId = request.getParameter("rowId");

			logger.info("OpptyController list method crmId =>" + crmId);
			logger.info("OpptyController list method rowId =>" + rowId);
			//绑定对象
			logger.info("crmId:-> is =" + crmId);
			if(null != crmId && !"".equals(crmId)){
				//获取LOV下拉列表信息
				Map<String, Map<String, String>> lovList = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("adapting_change_list", lovList.get("adapting_change_list"));//适应能力
				request.setAttribute("plight_list", lovList.get("plight_list"));//你的处境
				request.setAttribute("contact_role_list", lovList.get("contact_role_list"));//用户角色
				
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunitySingle(rowId, crmId);
				List<OpptyAdd> list = sResp.getOpptys();
				
				if(null != list && list.size() > 0 && null != list.get(0).getGxml()){
					request.setAttribute("sd", list.get(0));
					request.setAttribute("gxml", list.get(0).getGxml().replaceAll("'", "\""));
				}else{
					request.setAttribute("sd", new OpptyAdd());
					request.setAttribute("gxml", "");
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("crmId", crmId);
			request.setAttribute("rowId", rowId);
			return "oppty/rela";
		}
		
		/**
		 * 关系评估
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/effect")
		public String effect(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("OpptyController list method begin=>");
			String crmId = request.getParameter("crmId");
			String rowId = request.getParameter("rowId");

			logger.info("OpptyController list method crmId =>" + crmId);
			logger.info("OpptyController list method rowId =>" + rowId);
			//绑定对象
			logger.info("crmId:-> is =" + crmId);
			if(null != crmId && !"".equals(crmId)){
				
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunitySingle(rowId, crmId);
				List<OpptyAdd> list = sResp.getOpptys();
				
				if(null != list && list.size() > 0 && null != list.get(0).getEffectxml()){
					request.setAttribute("sd", list.get(0));
					request.setAttribute("effectgxml", list.get(0).getEffectxml().replaceAll("'", "\""));
				}else{
					request.setAttribute("sd", new OpptyAdd());
					request.setAttribute("effectgxml", "");
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("crmId", crmId);
			request.setAttribute("rowId", rowId);
			return "oppty/effect";
		}
		
		/**
		 * 业务机会跟进过程中的 修改业务机会接口
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/update")
		@ResponseBody
		public String update(Opportunity obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			//调用后台接口修改业务机会跟进的过程
			if(null != obj.getOptype() && "allot".equals(obj.getOptype()) && null != obj.getRowId()){
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignId() && !obj.getCrmId().equals(obj.getAssignId())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignId(),UserUtil.getCurrUser(request).getName()+" 分配了一个业务机会【"+obj.getOpptyname()+"】给您", "oppty/detail?rowId="+obj.getRowId()+"&orgId="+obj.getOrgId());
				}
			}
			CrmError crmErr = cRMService.getSugarService().getOppty2SugarService().updateOppty(obj);
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 修改关系图
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/updategxml")
		@ResponseBody
		public String updateGxml(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String crmId = request.getParameter("crmId");
			String rowId = request.getParameter("rowId");
			String gxml = request.getParameter("gxml");
			String effectxml = request.getParameter("effectxml");
			//调用后台接口修改业务机会
			CrmError crmErr = new CrmError();
			if(null != crmId && !"".equals(crmId)){
				Opportunity obj = new Opportunity();
				obj.setCrmId(crmId);
				obj.setRowId(rowId);
				obj.setGxml(gxml);
				obj.setEffectxml(effectxml);
				crmErr = cRMService.getSugarService().getOppty2SugarService().updateOppty(obj);
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 业务机会修改并保存
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/save")
		public String saveOppty(Opportunity obj, HttpServletRequest request,
				HttpServletResponse response)throws Exception{
			
			String competitive = obj.getCompetitive();
			if(null==competitive || "".equals(competitive.trim()))
			{
				//检验前台传过来的“竞争策略”，如果未传，默认值为  1:正面
				obj.setCompetitive("1");
			}
			//调用后台接口修改业务机会跟进的过程
			CrmError crmErr = cRMService.getSugarService().getOppty2SugarService().updateOppty(obj);
			if(ErrCode.ERR_CODE_0.equals(crmErr.getErrorCode())){
				request.setAttribute("rowId", obj.getRowId());
				request.setAttribute("crmId", obj.getCrmId());
				request.setAttribute("orgId", obj.getOrgId());
			}
			return "redirect:/oppty/modify?openId="+obj.getOpenId()+"&publicId="+obj.getPublicId()+"&rowId="+obj.getRowId()+"&orgId="+obj.getOrgId();
		}
		
		/**
		 * 修改业务机会
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/modify")
		public String modify(HttpServletRequest request,HttpServletResponse response) throws Exception{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String rowId = request.getParameter("rowId");
			String orgId = request.getParameter("orgId");
			logger.info("OpptyController modify method openId =>"+openId);
			logger.info("OpptyController modify method rowId =>"+rowId);
			//绑定对象
			String crmId = "";
			Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
			if(null==obj){
				crmId = cRMService.getSugarService().getOppty2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
			}else{
				crmId = (String)obj;
			}
			if(!StringUtils.isNotNullOrEmptyStr(crmId)){
				crmId = UserUtil.getCurrUser(request).getCrmId();
			}
			RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
			//绑定对象
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				OpptyResp sResp = cRMService.getSugarService().getOppty2SugarService().getOpportunitySingle(rowId, crmId);
				List<OpptyAdd> list = sResp.getOpptys();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("sd", list.get(0));
					request.setAttribute("oppName", list.get(0).getName());
					//业务机会阶段
					Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
					request.setAttribute("salesStageList", mp.get("sales_stage_dom"));//业务机会阶段
					request.setAttribute("leadSource", mp.get("lead_source_dom"));//潜在客户来源
					request.setAttribute("opportunityType", mp.get("opportunity_type_dom"));//业务机会类型
					
					//市场活动
					Campaigns camp = new Campaigns();
					camp.setCurrpage("0");
					camp.setPagecount("1000");
					camp.setOpenId(UserUtil.getCurrUser(request).getParty_row_id()); //传partyId
					camp.setType("owner");
//				    CampaignsResp cResp = campaigns2ZJmktService.getCampaignsList(camp, "WEB"); 
//					request.setAttribute("campaignsList", cResp.getCams());
					
					request.setAttribute("failReasonList", mp.get("fail_reason_list"));//业务机会失败原因列表
					request.setAttribute("competitive", mp.get("competitive_list"));//竞争策略列表
				}else{
					request.setAttribute("sd", new OpptyAdd());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("rowId", rowId);
			request.setAttribute("crmId", crmId);
			//add by zhihe
			request.setAttribute("source", request.getParameter("source"));
			
			return "oppty/modify";
		}
		
		/**
		 * 保存查询条件
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/savesearch")
		@ResponseBody
		public String savesearch(HttpServletRequest request,
				HttpServletResponse response) throws Exception{
			String assignerid=request.getParameter("assignerid");
			String salesstage=request.getParameter("salesstage");
			String opptyname = request.getParameter("opptyname");
			String startdate =request.getParameter("startdate");
			String enddate =request.getParameter("enddate");
			String searchname =request.getParameter("searchname");
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			String searchcon=searchname+"|"+"opptyname:"+opptyname+"|"+"salesstage:"+salesstage+"|"+"startdate:"+startdate+"|"+"enddate"+enddate+"|"+"assignerid"+assignerid;
			logger.info("OpptyController  savesearch method crmId =>" + crmId);
			logger.info("OpptyController  savesearch method searchcon =>" + searchcon);
			CrmError crmErr = new CrmError();
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				//cache
				List<String> searchList = new ArrayList<String>();
				searchList.add(searchcon);
				try{
					for (int i = 0; i < searchList.size(); i++) {
						RedisCacheUtil.addToSortedSet("oppty_search"+crmId, searchList.get(i), i);
					}
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
				}catch(Exception e){
					e.printStackTrace();
					crmErr.setErrorCode(ErrCode.ERR_CODE_1);
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		
		/**
		 * 保存最后一次查询条件
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/savelastsearch")
		@ResponseBody
		public String savelastsearch(HttpServletRequest request,
				HttpServletResponse response) throws Exception{
			String assignerid=request.getParameter("assignerid");
			String salesstage=request.getParameter("salesstage");
			String opptyname = request.getParameter("opptyname");
			String startdate =request.getParameter("startdate");
			String enddate =request.getParameter("enddate");
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			String searchcon=opptyname+"|"+salesstage+"|"+startdate+"|"+enddate+"|"+assignerid;
			logger.info("OpptyController  savesearch method crmId =>" + crmId);
			logger.info("OpptyController  savesearch method searchcon =>" + searchcon);
			CrmError crmErr = new CrmError();
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
			   //删除之前缓存
				RedisCacheUtil.delete("oppty_search_last"+crmId);
				//cache
				List<String> searchList = new ArrayList<String>();
				searchList.add(searchcon);
				try{
					for (int i = 0; i < searchList.size(); i++) {
						RedisCacheUtil.addToSortedSet("oppty_search_last"+crmId, searchList.get(i), i);
					}
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
				}catch(Exception e){
					e.printStackTrace();
					crmErr.setErrorCode(ErrCode.ERR_CODE_1);
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 加载缓存的查询条件
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/searchcache")
		@SuppressWarnings("rawtypes")
		@ResponseBody
		public String searchcache(HttpServletRequest request,
				HttpServletResponse response) throws Exception{
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("OpptyController searchcache method crmId =>" + crmId);
			
			//cache
			List<String> sealist = new ArrayList<String>();
			//获取缓存的查询条件
			Set<String> rs = RedisCacheUtil.getSortedSetRange("oppty_search"+crmId, 0, 0);
			for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
				String searchcon = (String) iterator.next();
				sealist.add(searchcon);
				logger.info("OpptyController searchcache method searchcon=>" + searchcon);
			}
			return JSONArray.fromObject(sealist).toString();
		}
		
		
		/**
		 * 加载最后一次的查询条件
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/searchlastcache")
		@SuppressWarnings("rawtypes")
		@ResponseBody
		public String searchlastcache(HttpServletRequest request,
				HttpServletResponse response) throws Exception{
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("OpptyController searchlastcache method crmId =>" + crmId);
			
			//cache
			List<String> sealist = new ArrayList<String>();
			//获取缓存的查询条件
			Set<String> rs = RedisCacheUtil.getSortedSetRange("oppty_search_last"+crmId, 0, 0);
			for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
				String searchcon = (String) iterator.next();
				sealist.add(searchcon);
				logger.info("OpptyController searchlastcache method searchcon=>" + searchcon);
			}
			return JSONArray.fromObject(sealist).toString();
		}
		
		/**
		 * 加载最后一次的查询条件
		 * 
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/dellastcache")
		@ResponseBody
		public String dellastcache(HttpServletRequest request,
				HttpServletResponse response) throws Exception{
			String crmId =UserUtil.getCurrUser(request).getCrmId();
			logger.info("OpptyController dellastcache method crmId =>" + crmId);
			//获取缓存的查询条件
			if(null != crmId && !"".equals(crmId)){
				RedisCacheUtil.delete("oppty_search_last"+crmId);
				return "success";
			}
			return "fail";
		}
		
		
		/**
		 * 删除查询条件
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/delcache")
		@ResponseBody
		public String delcache(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String name = request.getParameter("name");
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
				name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
			}
			CrmError crmErr = new CrmError();
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				Set<String> rs = RedisCacheUtil.getSortedSetRange("oppty_search"+ crmId, 0, 0);
				List<String> searchList = new ArrayList<String>();
				if(rs!=null){
					RedisCacheUtil.delete("oppty_search" + crmId);
				}
				try{
					for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
						String searchcon = (String) iterator.next();
						logger.info("OpptyController searchcache method searchcon=>"+ searchcon);
						if(!searchcon.contains(name)){
							searchList.add(searchcon);
						}
					}
					for (int i = 0; i < searchList.size(); i++) {
						RedisCacheUtil.addToSortedSet("oppty_search"+crmId, searchList.get(i), i);
					}
					crmErr.setErrorCode("0");
				}catch(Exception e){
					e.printStackTrace();
					crmErr.setErrorCode("9");
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		
		/**
		 * 删除实体对象
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/delOppty")
		@ResponseBody
		public String delOppty(Opportunity obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
		    String optype = request.getParameter("optype");
			String rowId = request.getParameter("rowid");
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			obj.setCrmId(crmId);
			obj.setRowId(rowId);
			obj.setOptype(optype);
			CrmError crmError = cRMService.getSugarService().getOppty2SugarService().deleteOpportunity(obj);
			return JSONObject.fromObject(crmError).toString();
		}
		
		
		/**
		 * 威客系统对外提供的接口 新增 联系人
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/wk_oppty_save")
		public String wk_oppty_save(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String sourceid = request.getParameter("sourceid");
			String customername = request.getParameter("customername");
			customername = (null == customername ? "" : customername);
			logger.info("sourceid = >" + sourceid);
			if (StringUtils.isNotNullOrEmptyStr(customername) && !StringUtils.regZh(customername)) {
				customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
			}
			String u = "/oppty/get?customername=" + customername;
			String redirectUrl = URLEncoder.encode(u, "UTF-8");
			logger.info("redirectUrl = >" + redirectUrl);
			return "redirect:/operorg/list?source=aync&redirectUrl=" + redirectUrl;
		}
}
