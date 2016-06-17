package com.takshine.wxcrm.controller;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.WeekReport;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.sugar.WeekReportAdd;
import com.takshine.wxcrm.message.sugar.WeekReportResp;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 周报页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/weekreport")
public class WeekReportController {
	    // 日志
		protected static Logger logger = Logger.getLogger(WeekReportController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		
		/**
		 * 添加周报选择周报类型(重点工作/重大市场项目/问题与建议)
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/get")
		public String get(HttpServletRequest request,HttpServletRequest response) throws Exception  {
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
       		logger.info("WeekReportController get method openId =>" + openId);
       		logger.info("WeekReportController get method publicId =>" + publicId);
       		logger.info("WeekReportController get method crmId =>" + crmId);
       		if(StringUtils.isNotNullOrEmptyStr(crmId)){
       			request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("types", mp.get("report_type_list"));//类型
				return "week/get";
			}else {
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
		}
		
		/**
		 * 增加周报
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/add")
		public String add(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String reporttype = request.getParameter("reporttype");//周报类型
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("WeekReportController add method reporttype =>" + reporttype);
			logger.info("WeekReportController add method openId =>" + openId);
			logger.info("WeekReportController add method publicId =>" + publicId);
			logger.info("WeekReportController add method crmId =>" + crmId);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				//获取当前操作用户
				UserReq currReq = new UserReq();
				currReq.setCrmaccount(crmId);
				currReq.setFlag("single");
				currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//查询所有的用户列表
				currReq.setCurrpage("1");
				currReq.setPagecount("1000");
				UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
				currResp.getUsers();
				if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUserid()){
					request.setAttribute("assignerid", currResp.getUsers().get(0).getUserid());
				}
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("worktypes", mp.get("report_subtype_list_1"));//类型
				request.setAttribute("questtypes", mp.get("report_subtype_list_2"));//类型
				//获取用户头像数据
				Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
				if(null != obj1){
					WxuserInfo wxuinfo = (WxuserInfo)obj1;
					request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
				}else{
					request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("reporttype", reporttype);
			request.setAttribute("crmId", crmId);
			if("1".equals(reporttype)){
				return "week/addWork";
			}else if("2".equals(reporttype)){
				return "week/addProject";
			}else if("3".equals(reporttype)){
				return "week/addQuest";
			}
			return "week/addWork";
		}
		
		/**
		 * 保存周报
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/save")
		public String save(WeekReport obj ,HttpServletRequest request,HttpServletResponse response) throws Exception{
			String openId = obj.getOpenId();
			String publicId = obj.getPublicId();
			String flag = request.getParameter("flag");//是否继续添加
			String reporttype = obj.getReporttype();
			Calendar a=Calendar.getInstance();
			int week = a.get(Calendar.WEEK_OF_YEAR);
			int year = a.get(Calendar.YEAR);
			obj.setCountweek(year+""+week);
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("WeekReportController add method openId =>" + openId);
			logger.info("WeekReportController add method reporttype =>" + reporttype);
			logger.info("WeekReportController add method publicId =>" + publicId);
			logger.info("WeekReportController add method crmId =>" + crmId);
			logger.info("WeekReportController add method flag =>" + flag);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				obj.setCrmId(crmId);
				CrmError crmError = cRMService.getSugarService().getWeekReport2SugarService().addWeekReport(obj);
				String rowId = crmError.getRowId();
				if(StringUtils.isNotNullOrEmptyStr(rowId)){
					if("continue".equals(flag)){
						return "redirect:/weekreport/add?reporttype="+reporttype+"&openId="+openId+"&publicId="+publicId;
					}else{
						return "redirect:/weekreport/list?viewtype=myview&openId="+openId+"&publicId="+publicId;
					}
				}else{
					throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
		}
		
		
		/**
		 * 异步查询周报列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/asylist")
		@ResponseBody
		public String asylist(HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			String str = "";
			CrmError crmErr = new CrmError();
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String assignerid= request.getParameter("assignerid");
			String viewtype = request.getParameter("viewtype");
			String countweek = request.getParameter("countweek");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			logger.info("WeekReportController list method openId =>" + openId);
			logger.info("WeekReportController list method publicId =>" + publicId);
			logger.info("WeekReportController list method currpage =>" + currpage);
			logger.info("WeekReportController list method pagecount =>" + pagecount);
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("WeekReportController list crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				WeekReport week = new WeekReport();
				week.setCrmId(crmId);
				week.setCurrpage(currpage);
				week.setPagecount(pagecount);
				if("myview".equals(viewtype)){
					week.setAssignerid(crmId);
				}else{
					week.setAssignerid(assignerid);
				}
				week.setCountweek(countweek);
				WeekReportResp wResp = cRMService.getSugarService().getWeekReport2SugarService().getWeekReportList(week,"WEB");
				List<WeekReportAdd> cList = wResp.getReports();
				Map<String, List<WeekReportAdd>> maps = new HashMap<String, List<WeekReportAdd>>();
				List<WeekReportAdd> list = new ArrayList<WeekReportAdd>();
				for(int i=0;i<cList.size();i++){
					WeekReportAdd wAdd = cList.get(i);
					String cweek=  wAdd.getCountweek();
					if(!StringUtils.isNotNullOrEmptyStr(cweek)){
						continue;
					}
					if(maps.keySet()==null||!maps.keySet().contains(cweek)){
						list = new ArrayList<WeekReportAdd>();
						list.add(wAdd);
						maps.put(cweek, list);
					}else{
						list = maps.get(cweek);
						list.add(wAdd);
						maps.put(cweek, list);
					}
				}
				logger.info("maps is ->" + maps.size());
				if(maps!=null&&maps.size()>0){
					str = JSONArray.fromObject(maps).toString();
				}else{
					crmErr.setErrorCode(wResp.getErrcode());
					crmErr.setErrorMsg(wResp.getErrmsg());
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
		 * 周报详情信息
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/detail")
		public String detail(HttpServletRequest request,HttpServletResponse response) throws Exception {
			logger.info("CustomerController detail method begin=>");
			String rowId = request.getParameter("rowId");//  rowId
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			logger.info("CustomerController detail method rowId =>" + rowId);
			logger.info("CustomerController detail method openId =>" + openId);
			logger.info("CustomerController detail method publicId =>" + publicId);
			//绑定对象
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				WeekReportResp sResp = cRMService.getSugarService().getWeekReport2SugarService().getWeekReportSingle(rowId, crmId);
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<WeekReportAdd> list = sResp.getReports();
					//放到页面上
					if(null != list && list.size() > 0){
						request.setAttribute("sd", list.get(0));
						String countweek = list.get(0).getCountweek();
						String name = list.get(0).getReporttypename()+"("+countweek.substring(0,4)+"年第"+countweek.substring(4)+"周)";
						request.setAttribute("weekName", name);
						// 获取当前操作用户
						UserReq currReq = new UserReq();
						currReq.setCrmaccount(crmId);
						currReq.setFlag("single");
						currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
						currReq.setCurrpage("1");
						currReq.setPagecount("1000");
						UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
						currResp.getUsers();
						if (null != currResp.getUsers()&& null != currResp.getUsers().get(0).getUsername()) {
							request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
						}
						//查询当前业务机会下关联的共享用户
						Share share = new Share();
						share.setParentid(rowId);
						share.setParenttype("WeekReport");
						share.setCrmId(crmId);
						ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
						List<ShareAdd> shareAdds = sresp.getShares();
						request.setAttribute("shareusers", shareAdds);
					}else{
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
					}
				}else{
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			request.setAttribute("rowId", rowId);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("crmId", crmId);
			return "week/detail";
		}
		
		/**
		 * 查询周报列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/list")
		public String list(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String assignerid= request.getParameter("assignerid");
			String countweek = request.getParameter("countweek");
			String viewtypesel = request.getParameter("viewtypesel");
			String viewtype = request.getParameter("viewtype");
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			logger.info("WeekReportController list method openId =>" + openId);
			logger.info("WeekReportController list method publicId =>" + publicId);
			logger.info("WeekReportController list method currpage =>" + currpage);
			logger.info("WeekReportController list method pagecount =>" + pagecount);
			logger.info("WeekReportController list method assignerid =>" + assignerid);
			logger.info("WeekReportController list method countweek =>" + countweek);
			logger.info("WeekReportController list method viewtype =>" + viewtype);
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("WeekReportController list crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				//获取当年所有周
				initCurrYearWeeks(request);
				
				WeekReport week = new WeekReport();
				week.setCrmId(crmId);
				week.setCurrpage(currpage);
				week.setPagecount(pagecount);
				if("myview".equals(viewtype)&&!StringUtils.isNotNullOrEmptyStr(assignerid)){
					week.setAssignerid(crmId);
				}else{
					week.setAssignerid(assignerid);
				}
				week.setCountweek(countweek);
				WeekReportResp wResp = cRMService.getSugarService().getWeekReport2SugarService().getWeekReportList(week,"WEB");
				String errorCode = wResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<WeekReportAdd> weekReportAdds = wResp.getReports();
					Map<String, List<WeekReportAdd>> maps = new HashMap<String, List<WeekReportAdd>>();
					List<WeekReportAdd> list = new ArrayList<WeekReportAdd>();
					for(int i=0;i<weekReportAdds.size();i++){
						WeekReportAdd wAdd = weekReportAdds.get(i);
						String cweek=  wAdd.getCountweek();
						if(!StringUtils.isNotNullOrEmptyStr(cweek)){
							continue;
						}
						if(maps.keySet()==null||!maps.keySet().contains(cweek)){
							list = new ArrayList<WeekReportAdd>();
							list.add(wAdd);
							maps.put(cweek, list);
						}else{
							list = maps.get(cweek);
							list.add(wAdd);
							maps.put(cweek, list);
						}
					}
					request.setAttribute("maps", maps);
				}else{
					if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
						throw new Exception("错误编码：" + wResp.getErrcode() + "，错误描述：" + wResp.getErrmsg());
					}
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("pagecount", pagecount);
			request.setAttribute("currpage", currpage);
			request.setAttribute("countweek", countweek);
			request.setAttribute("assignerid",assignerid);
			request.setAttribute("viewtypesel",viewtypesel);
			request.setAttribute("viewtype",viewtype);
			return "week/list";
		}
		
		/**
		 * 周报详情页面
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/modify")
		public String modify(HttpServletRequest request,HttpServletResponse response) throws Exception{
			logger.info("CustomerController detail method begin=>");
			String rowId = request.getParameter("rowId");//  rowId
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String reporttype = request.getParameter("reporttype");
			logger.info("CustomerController detail method rowId =>" + rowId);
			logger.info("CustomerController detail method reporttype =>" + reporttype);
			logger.info("CustomerController detail method openId =>" + openId);
			logger.info("CustomerController detail method publicId =>" + publicId);
			//绑定对象
			String crmId = cRMService.getSugarService().getWeekReport2SugarService().getCrmId(openId, publicId);
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				WeekReportResp sResp = cRMService.getSugarService().getWeekReport2SugarService().getWeekReportSingle(rowId, crmId);
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<WeekReportAdd> list = sResp.getReports();
					//放到页面上
					if(null != list && list.size() > 0){
						request.setAttribute("week", list.get(0));
						request.setAttribute("details", list.get(0).getDetails());
						String countweek = list.get(0).getCountweek();
						String name = list.get(0).getReporttypename()+"("+countweek.substring(0,4)+"年第"+countweek.substring(4)+"周)";
						request.setAttribute("weekName", name);
						request.setAttribute("details", list.get(0).getDetails());
					}else{
						throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
					}
				}else{
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			request.setAttribute("rowId", rowId);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("reporttype", reporttype);
			return "week/modify";
		}
		
		/**
		 * 获取当前年份所有周
		 */
		private void initCurrYearWeeks(HttpServletRequest request) {
			List<WeekReport> weekList = new ArrayList<WeekReport>();
			SimpleDateFormat sdf = new SimpleDateFormat("MM.dd");
		    DecimalFormat df = new DecimalFormat("00");
	        Calendar calendar = Calendar.getInstance();
	        calendar.setTime(new Date());
	        int currweek = calendar.get(Calendar.WEEK_OF_YEAR);
	        int year = calendar.get(Calendar.YEAR);
	        request.setAttribute("currweek", year + "" + currweek);
	        calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
	        calendar.set(Calendar.WEEK_OF_YEAR, 1);
	        int week = 1;
	        WeekReport wr = null;
	        while (calendar.get(Calendar.YEAR) <= year) {
	            if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY) {
	            	wr = new WeekReport();
	            	wr.setCountweek(year + "" + df.format(week++));
	            	wr.setStartdate(sdf.format(calendar.getTime()));
	                calendar.add(Calendar.DATE, 6);
	                wr.setEnddate(sdf.format(calendar.getTime()));
	                weekList.add(wr);
	                if(week > currweek){
	            		break;
	            	}
	            }
	            calendar.add(Calendar.DATE, 1);
	        }
	        Collections.sort(weekList, new Comparator<WeekReport>(){ 
				public int compare(WeekReport s1,WeekReport s2){ 
	                                //降序排列 
				    return Integer.valueOf(s2.getCountweek()).compareTo(Integer.valueOf(s1.getCountweek())); 
				} 
			}); 
	        request.setAttribute("weekList", weekList);
	    }
}
