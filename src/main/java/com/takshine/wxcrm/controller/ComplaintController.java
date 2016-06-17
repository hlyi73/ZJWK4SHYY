package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
import com.takshine.wxcrm.domain.Complaint;
import com.takshine.wxcrm.domain.ServeExecute;
import com.takshine.wxcrm.domain.ServeVisit;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 客户投诉 与服务请求页面控制类
 * @author liulin
 *
 */
@Controller
@RequestMapping("/complaint")
public class ComplaintController {
	
	//日志服务
	Logger logger = Logger.getLogger(ComplaintController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	
	/**
	 * 获取客户投诉列表
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(Complaint comp, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("complaintController list =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(comp.getOpenid(), comp.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {
			
			comp.setCrmid(crmid);
			comp.setType(Constants.ACTION_SEARCH);
			comp = cRMService.getSugarService().getComplaintService().getComplaintList(comp);
			
			List<Complaint> list = comp.getComps();
			// 放到页面上
			request.setAttribute("compslist", list);
			// requestinfo
			request.setAttribute("crmid", crmid);
			request.setAttribute("servertype", comp.getServertype());
			request.setAttribute("status", comp.getStatus());
			request.setAttribute("openid", comp.getOpenid());
			request.setAttribute("openId", comp.getOpenid());
			request.setAttribute("publicid", comp.getPublicid());
			request.setAttribute("publicId", comp.getPublicid());
			request.setAttribute("sd", comp);
			request.setAttribute("viewtype", comp.getViewtype());
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//根据类型进行跳转
		String type = comp.getServertype();
		if(null != type && type.equals("complaint")){
			return "complaint/list";//投诉
		}else{
			return "servreq/list";//服务请求
		}
	}
	
	/**
	 * 异步加载 列表
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asycn_list")
	@ResponseBody
	public String asycn_list(Complaint comp, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("complaintController asycn_list =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(comp.getOpenid(), comp.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {
			comp.setCrmid(crmid);
			comp.setType(Constants.ACTION_SEARCH);
			comp = cRMService.getSugarService().getComplaintService().getComplaintList(comp);
			List<Complaint> list = comp.getComps();
			String str  = JSONArray.fromObject(list).toString();
			logger.info("str:-> is =" + str);
			return str;
		}else{
			return "[]";
		}
	}
	
	/**
	 * 服务执行 列表
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/serexeclist")
	public String serexeclist(ServeExecute exec, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("complaintController list =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(exec.getOpenid(), exec.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {
			
			exec.setCrmid(crmid);
			exec.setType(Constants.ACTION_SEARCH);
			exec = cRMService.getSugarService().getComplaintService().getServeExecuteList(exec);
			
			List<ServeExecute> list = exec.getExecs();
			// 放到页面上
			request.setAttribute("execlist", list);
			// requestinfo
			request.setAttribute("crmid", crmid);
			request.setAttribute("openid", exec.getOpenid());
			request.setAttribute("publicid", exec.getPublicid());
			request.setAttribute("parentid", exec.getParentid());
			request.setAttribute("parenttype", exec.getParenttype());
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		return "servreq/execlist";//服务执行列表
	}
	
	/**
	 * 服务回访 列表
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/servisitlist")
	public String servisitlist(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("complaintController list =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {
			
			visit.setCrmid(crmid);
			visit.setType(Constants.ACTION_SEARCH);
			visit = cRMService.getSugarService().getComplaintService().getServeVisitList(visit);
			
			List<ServeVisit> list = visit.getVisits();
			// 放到页面上
			request.setAttribute("visitlist", list);
			// requestinfo
			request.setAttribute("crmid", crmid);
			request.setAttribute("openid", visit.getOpenid());
			request.setAttribute("publicid", visit.getPublicid());
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		return "servreq/visitlist";//服务回访列表
	}
	
	/**
	 * 异步调用 服务执行 列表
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asycn_serexeclist")
	@ResponseBody
	public String asycn_serexeclist(ServeExecute exec, HttpServletRequest request, HttpServletResponse response) throws Exception{
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(exec.getOpenid(), exec.getPublicid());
		logger.info("crmId:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		exec.setCrmid(crmid);
		exec.setType(Constants.ACTION_SEARCH);
		exec = cRMService.getSugarService().getComplaintService().getServeExecuteList(exec);

		String str  = JSONArray.fromObject(exec.getExecs()).toString();
		logger.info("str:-> is =" + str);
		return str;
	}
	
	/**
	 * 异步调用 服务回访 列表 
	 * @param comp
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asycn_servisitlist")
	@ResponseBody
	public String servisitount(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("asycn_servisitlist  =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
			
		visit.setCrmid(crmid);
		visit.setType(Constants.ACTION_SEARCH);
		visit = cRMService.getSugarService().getComplaintService().getServeVisitList(visit);
		
		String str  = JSONArray.fromObject(visit.getVisits()).toString();
		logger.info("str:-> is =" + str);
		return str;
	}
	
	/**
	 * 服务请求和投诉 详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(Complaint comp, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//日志输出
		logger.info("ComplaintController detail openid =>" + comp.getOpenid());
		logger.info("ComplaintController detail publicid =>" + comp.getPublicid());
		logger.info("ComplaintController detail rowid =>" + comp.getRowid());
		//查询单个日程
		comp.setType(Constants.ACTION_SEARCHID);
		comp = cRMService.getSugarService().getComplaintService().getComplaintList(comp);
        //对返回的错误代码进行判断
		if(ErrCode.ERR_CODE_0.equals(comp.getErrcode())){
			List<Complaint> list = comp.getComps();
			if(list.size() > 0){
				//lov data
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(comp.getCrmid());
				request.setAttribute("case_status_dom", mp.get("case_status_dom"));
				//单个详情数据
				request.setAttribute("sd", list.get(0));
				//requestinfo
				request.setAttribute("crmid", comp.getCrmid());
				request.setAttribute("rowid", comp.getRowid());
				request.setAttribute("openid", comp.getOpenid());
				request.setAttribute("openId", comp.getOpenid());
				request.setAttribute("publicid", comp.getPublicid());
				request.setAttribute("publicId", comp.getPublicid());
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + comp.getErrcode() + "，错误描述：" + comp.getErrmsg());
		}
		
		//根据类型进行跳转
		String type = comp.getServertype();
		if(null != type && type.equals("complaint")){
			return "complaint/detail";//投诉
		}else{
			return "servreq/detail";//服务请求
		}
	}
	
	/**
	 * 服务执行 详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/serexecdetail")
	public String serexecdetail(ServeExecute exec, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//日志输出
		logger.info("ComplaintController serexecdetail openid =>" + exec.getOpenid());
		logger.info("ComplaintController serexecdetail publicid =>" + exec.getPublicid());
		logger.info("ComplaintController serexecdetail rowid =>" + exec.getRowid());
		//查询单个日程
		exec.setType(Constants.ACTION_SEARCHID);
		exec = cRMService.getSugarService().getComplaintService().getServeExecuteList(exec);
        //对返回的错误代码进行判断
		if(ErrCode.ERR_CODE_0.equals(exec.getErrcode())){
			List<ServeExecute> list = exec.getExecs();
			if(list.size() > 0){
				//lov data
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(exec.getCrmid());
				request.setAttribute("statusDom", mp.get("status_dom"));
				//单个详情数据
				request.setAttribute("sd", list.get(0));
				//requestinfo
				request.setAttribute("crmid", exec.getCrmid());
				request.setAttribute("rowid", exec.getRowid());
				request.setAttribute("openid", exec.getOpenid());
				request.setAttribute("publicid", exec.getPublicid());
				
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + exec.getErrcode() + "，错误描述：" + exec.getErrmsg());
		}
		return "servreq/execdetail";
	}
	
	/**
	 * 服务请求和投诉 详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/servisitdetail")
	public String servisitdetail(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//日志输出
		logger.info("ComplaintController servisitdetail openid =>" + visit.getOpenid());
		logger.info("ComplaintController servisitdetail publicid =>" + visit.getPublicid());
		logger.info("ComplaintController servisitdetail rowid =>" + visit.getRowid());
		//查询单个日程
		visit.setType(Constants.ACTION_SEARCHID);
		visit = cRMService.getSugarService().getComplaintService().getServeVisitList(visit);
        //对返回的错误代码进行判断
		if(ErrCode.ERR_CODE_0.equals(visit.getErrcode())){
			List<ServeVisit> list = visit.getVisits();
			if(list.size() > 0){
				//lov data
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(visit.getCrmid());
				request.setAttribute("statusDom", mp.get("status_dom"));
				
				request.setAttribute("case_handle_list", mp.get("case_handle_list"));//处理情况
				request.setAttribute("case_question_list", mp.get("case_question_list"));//遗留问题
				request.setAttribute("case_service_attitude_list", mp.get("case_service_attitude_list"));//服务态度
				request.setAttribute("case_timely_list", mp.get("case_timely_list"));//及时性
				request.setAttribute("case_work_effect_list", mp.get("case_work_effect_list"));//工作效率
				request.setAttribute("yesorno_list", mp.get("yesorno_list"));//yes or no
				request.setAttribute("case_finish_list", mp.get("case_finish_list"));//完成情况
				request.setAttribute("case_visit_status_list", mp.get("case_visit_status_list"));//服务状态
				
				
				//单个详情数据
				request.setAttribute("sd", list.get(0));
				//requestinfo
				request.setAttribute("crmid", visit.getCrmid());
				request.setAttribute("rowid", visit.getRowid());
				request.setAttribute("openid", visit.getOpenid());
				request.setAttribute("publicid", visit.getPublicid());
				
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + visit.getErrcode() + "，错误描述：" + visit.getErrmsg());
		}
		return "servreq/visitdetail";//服务请求
	}

	/**
	 * 增加服务请求
	 */
	@RequestMapping("/get")
	public String add(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String publicId = request.getParameter("publicid");
		String servertype = request.getParameter("servertype");
		String openId = request.getParameter("openid");
		String crmId = cRMService.getSugarService().getComplaintService().getCrmId(openId, publicId);
		logger.info("ComplaintController add method openId =>" + openId);
		logger.info("ComplaintController add method publicId =>" + publicId);
		logger.info("ComplaintController add method crmId =>" + crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			//currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//查询所有的用户列表
			currReq.setFlag("all");
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			request.setAttribute("userList", currResp.getUsers() == null ? new ArrayList<UserAdd>() : currResp.getUsers());
			currReq.setFlag("single");
			currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUserid()){
				request.setAttribute("assignerid", currResp.getUsers().get(0).getUserid());
			}
			String date = DateTime.currentDate(DateTime.DateFormat1);
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("statusDom", mp.get("case_status_dom"));
			request.setAttribute("substypes_servq", mp.get("case_subtype_list"));//服务类型
			request.setAttribute("substypes_compt", mp.get("complaint_subtype_list_2"));//投诉类型
			request.setAttribute("sources", mp.get("case_complaint_source_list"));//投诉来源
			//获取用户头像数据
			Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			if(null != obj1){
				WxuserInfo wxuinfo = (WxuserInfo)obj1;
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
			request.setAttribute("date", date);
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("servertype", servertype);
		//根据类型进行跳转
		if(null != servertype && servertype.equals("complaint")){
			return "complaint/addForm";//投诉
		}else{
			return "servreq/addForm";
		}
	}
	
	/**
	 * 保存服务请求
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String save(Complaint complaint,HttpServletRequest request,HttpServletResponse response) throws Exception{
		String openId = complaint.getOpenid();
		String publicId = complaint.getPublicid();
		String flag = request.getParameter("flag");//是否继续添加
		String crmId = cRMService.getSugarService().getComplaintService().getCrmId(openId, publicId);
		String servertype = complaint.getServertype();
		logger.info("ComplaintController add method openId =>" + openId);
		logger.info("ComplaintController add method publicId =>" + publicId);
		logger.info("ComplaintController add method crmId =>" + crmId);
		logger.info("ComplaintController add method flag =>" + flag);
		logger.info("ComplaintController add method servertype =>" + servertype);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			complaint.setCrmid(crmId);
			CrmError crmError = cRMService.getSugarService().getComplaintService().addComplaint(complaint);
			String rowId = crmError.getRowId();
			//获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			String assignername ="";
			if(currResp!=null&&currResp.getUsers()!=null&&currResp.getUsers().size()>0){
				assignername = currResp.getUsers().get(0).getUsername();
			}
			if(StringUtils.isNotNullOrEmptyStr(rowId)){
			
				if("continue".equals(flag)){
					return "redirect:/complaint/add?servertype="+servertype+"&openid="+openId+"&publicid="+publicId;
				}else{
					if("complaint".equals(servertype)){
						//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
						if(null != complaint.getComplaint_target() && !crmId.equals(complaint.getComplaint_target())){
							cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(complaint.getComplaint_target(),assignername+" 分配了一个投诉【"+complaint.getCase_number()+"】给您", "complaint/detail?rowid="+rowId+"&servertype="+servertype);
						}
					}else{
						//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
						if(null != complaint.getHandle() && !crmId.equals(complaint.getHandle())){
							cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(complaint.getHandle(),assignername+" 分配了一个服务请求【"+complaint.getCase_number()+"】给您", "complaint/detail?rowid="+rowId+"&servertype="+servertype);
						}
					}
					return "redirect:/complaint/list?openid="+openId+"&publicid="+publicId+"&servertype="+servertype;
				}
			}else{
				throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 修改 服务请求
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(Complaint comp, HttpServletRequest request,HttpServletResponse response) throws Exception{
		//查询单个日程
		comp.setType(Constants.ACTION_SEARCHID);
		comp = cRMService.getSugarService().getComplaintService().getComplaintList(comp);
		//对返回的错误代码进行判断
		if(ErrCode.ERR_CODE_0.equals(comp.getErrcode())){
			List<Complaint> list = comp.getComps();
			if(list.size() > 0){
				//lov data
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(comp.getCrmid());
				request.setAttribute("statusDom", mp.get("status_dom"));
				//单个详情数据
				request.setAttribute("sd", list.get(0));
				//requestinfo
				request.setAttribute("crmid", comp.getCrmid());
				request.setAttribute("rowid", comp.getRowid());
				request.setAttribute("openid", comp.getOpenid());
				request.setAttribute("publicid", comp.getPublicid());
				
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + comp.getErrcode() + "，错误描述：" + comp.getErrmsg());
		}
		
		//根据类型进行跳转
		String type = comp.getServertype();
		if(null != type && type.equals("complaint")){
			return "complaint/modify";//投诉
		}else{
			return "servreq/modify";//服务请求
		}
	}
	
	/**
	 * 增加服务执行
	 */
	@RequestMapping("/getexec")
	public String addexec(ServeExecute exec, HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("complaintController addexec =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(exec.getOpenid(), exec.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {

			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmid);
			request.setAttribute("case_handle_list", mp.get("case_handle_list"));//处理情况
			request.setAttribute("case_question_list", mp.get("case_question_list"));//遗留问题
			request.setAttribute("case_service_attitude_list", mp.get("case_service_attitude_list"));//服务态度
			request.setAttribute("case_timely_list", mp.get("case_timely_list"));//及时性
			request.setAttribute("case_work_effect_list", mp.get("case_work_effect_list"));//工作效率
			request.setAttribute("yesorno_list", mp.get("yesorno_list"));//服务执行
			
			request.setAttribute("openid", exec.getOpenid());
			request.setAttribute("publicid", exec.getPublicid());
			request.setAttribute("crmid", crmid);
			request.setAttribute("parentid", exec.getParentid());
			request.setAttribute("parenttype", exec.getParenttype());
			
			return "servreq/addexec";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存服务执行
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveexec")
	public String saveexec(ServeExecute exec, HttpServletRequest request, HttpServletResponse response) throws Exception{
		CrmError crmError = cRMService.getSugarService().getComplaintService().addExec(exec);
		if(crmError.getErrorCode().equals(ErrCode.ERR_CODE_0)){
			String continue_add = exec.getContinue_add();
			if(null != continue_add && !"".equals(continue_add)){
				return "redirect:/complaint/getexec?openid="+exec.getOpenid() + "&publicid="+ exec.getPublicid();
			}
			return "redirect:/complaint/detail?openid="+exec.getOpenid() + "&publicid="+ exec.getPublicid() + "&crmid=" + exec.getCrmid() + "&rowid=" + exec.getParentid();
		}else{
			throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
		}
	}
	
	/**
	 * 选择 非自接合同 和 自接合同
	 */
	@RequestMapping("/visit_choose")
	public String visit_choose(ServeVisit visit, HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("complaintController visit_choose =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {
			request.setAttribute("openid", visit.getOpenid());
			request.setAttribute("publicid", visit.getPublicid());
			request.setAttribute("crmid", crmid);
			request.setAttribute("parentid", visit.getParentid());
			request.setAttribute("parenttype", visit.getParenttype());
			
			return "servreq/visitchoose";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 增加 非自接合同 的服务回访
	 */
	@RequestMapping("/getvisit")
	public String addvisit(ServeVisit visit, HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("complaintController addvisit =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {

			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmid);
			request.setAttribute("case_handle_list", mp.get("case_handle_list"));//处理情况
			request.setAttribute("case_question_list", mp.get("case_question_list"));//遗留问题
			request.setAttribute("case_service_attitude_list", mp.get("case_service_attitude_list"));//服务态度
			request.setAttribute("case_timely_list", mp.get("case_timely_list"));//及时性
			request.setAttribute("case_work_effect_list", mp.get("case_work_effect_list"));//工作效率
			request.setAttribute("yesorno_list", mp.get("yesorno_list"));//yes or no
			request.setAttribute("case_finish_list", mp.get("case_finish_list")); //完成情况
			
			request.setAttribute("openid", visit.getOpenid());
			request.setAttribute("publicid", visit.getPublicid());
			request.setAttribute("crmid", crmid);
			request.setAttribute("parentid", visit.getParentid());
			request.setAttribute("parenttype", visit.getParenttype());
			
			return "servreq/addvisit";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存服务回访
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savevisit")
	public String savevisit(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception{
		CrmError crmError = cRMService.getSugarService().getComplaintService().addVisit(visit);
		if(crmError.getErrorCode().equals(ErrCode.ERR_CODE_0)){
			String continue_add = visit.getContinue_add();
			if(null != continue_add && !"".equals(continue_add)){
				return "redirect:/complaint/getvisit?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid();
			}
			return "redirect:/complaint/detail?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid() + "&crmid=" + visit.getCrmid() + "&rowid=" + visit.getParentid();
		}else{
			throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
		}
	}
	
	/**
	 * 增加 自接合同 的服务回访
	 */
	@RequestMapping("/getvisit_zijie")
	public String addvisit_zijie(ServeVisit visit, HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("complaintController addvisit =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {

			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmid);
			request.setAttribute("case_handle_list", mp.get("case_handle_list"));//处理情况
			
			request.setAttribute("openid", visit.getOpenid());
			request.setAttribute("publicid", visit.getPublicid());
			request.setAttribute("crmid", crmid);
			request.setAttribute("parentid", visit.getParentid());
			request.setAttribute("parenttype", visit.getParenttype());
			
			return "servreq/addvisit_zijie";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存自己合同的 服务回访
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savevisit_zijie")
	public String savevisit_zijie(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception{
		CrmError crmError = cRMService.getSugarService().getComplaintService().addVisit(visit);
		if(crmError.getErrorCode().equals(ErrCode.ERR_CODE_0)){
			String continue_add = visit.getContinue_add();
			if(null != continue_add && !"".equals(continue_add)){
				return "redirect:/complaint/getvisit?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid();
			}
			return "redirect:/complaint/detail?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid() + "&crmid=" + visit.getCrmid() + "&rowid=" + visit.getParentid();
		}else{
			throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
		}
	}
	
	/**
	 * 增加 投诉 回访
	 */
	@RequestMapping("/getvisit_tousu")
	public String getvisit_tousu(ServeVisit visit, HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("complaintController getvisit_tousu =>");
		// 绑定对象
		String crmid = cRMService.getSugarService().getComplaintService().getCrmId(visit.getOpenid(), visit.getPublicid());
		logger.info("crmid:-> is =" + crmid);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmid)) {

			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmid);
			request.setAttribute("case_visit_status_list", mp.get("case_visit_status_list"));//回访状态
			
			request.setAttribute("openid", visit.getOpenid());
			request.setAttribute("publicid", visit.getPublicid());
			request.setAttribute("crmid", crmid);
			request.setAttribute("parentid", visit.getParentid());
			request.setAttribute("parenttype", visit.getParenttype());
			
			return "servreq/addvisit_tousu";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存投诉回访
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savevisit_tousu")
	public String savevisit_tousu(ServeVisit visit, HttpServletRequest request, HttpServletResponse response) throws Exception{
		CrmError crmError = cRMService.getSugarService().getComplaintService().addVisit(visit);
		if(crmError.getErrorCode().equals(ErrCode.ERR_CODE_0)){
			String continue_add = visit.getContinue_add();
			if(null != continue_add && !"".equals(continue_add)){
				return "redirect:/complaint/getvisit_tousu?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid()+"&servertype=complaint";
			}
			return "redirect:/complaint/detail?openid="+visit.getOpenid() + "&publicid="+ visit.getPublicid() + "&crmid=" + visit.getCrmid() + "&rowid=" + visit.getParentid()+"&servertype=complaint";
		}else{
			throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
		}
	}
	
	/**
	 * 修改服务请求状态
	 * @param complaint
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/complaint_status_upd")
	@ResponseBody
	public String complaint_status_upd(Complaint complaint,HttpServletRequest request,HttpServletResponse response)throws Exception{
		CrmError crmErr = new CrmError();
		crmErr = cRMService.getSugarService().getComplaintService().complaintStatusUpd(complaint);
		return JSONObject.fromObject(crmErr).toString();
	} 
}
