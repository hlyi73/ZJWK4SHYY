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
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProjectAdd;
import com.takshine.wxcrm.message.sugar.ProjectResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Project2CrmService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 项目 页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/project")
public class ProjectController {
	
	//日志服务
	Logger logger = Logger.getLogger(ProjectController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	/**
	 * 异步 查询项目列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asyList")
	@ResponseBody
	public String asyList(HttpServletRequest request,HttpServletResponse response)throws Exception{
		logger.info("ProjectController acclist method begin=>");
		String crmId = request.getParameter("crmId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
	    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
	    String firstchar = request.getParameter("firstchar");
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ProjectController list method viewtype =>" + viewtype);
		logger.info("ProjectController list method currpage =>" + currpage);
		logger.info("ProjectController list method pagecount =>" + pagecount);
		//绑定对象
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Project project = new Project();
			project.setCrmId(crmId);
			project.setViewtype(viewtype);//视图类型
			project.setPagecount(pagecount);
			project.setCurrpage(currpage);
			project.setFirstchar(firstchar);
			ProjectResp gResp = cRMService.getSugarService().getProject2CrmService().getProjectList(project,"WEB");
			List<ProjectAdd> list = gResp.getProjects();
			//JSON字符串输出
			str = JSONArray.fromObject(list).toString();
		}
		logger.info("ProjectController asyList str is ->" + str);
		return str;
	}
	
	/**
	 * 查询项目列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,HttpServletResponse response)throws Exception{
		logger.info("ProjectController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		viewtype = (viewtype == null ) ? "myallview" : viewtype ;
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ProjectController list method currpage =>" + currpage);
		logger.info("ProjectController list method pagecount =>" + pagecount);
		logger.info("ProjectController list method openId =>" + openId);
		logger.info("ProjectController list method publicId =>" + publicId);
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(openId, publicId);
		//绑定对象
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Project project = new Project();
			project.setCrmId(crmId);
			project.setPagecount(pagecount);
			project.setCurrpage(currpage);
			project.setViewtype(viewtype);
			ProjectResp gResp = cRMService.getSugarService().getProject2CrmService().getProjectList(project,"WEB");
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ProjectAdd> list = gResp.getProjects();
				request.setAttribute("proList", list);
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
				}
			}
			request.setAttribute("crmId", crmId);
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("viewtype", viewtype);
		return "project/list";
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
		logger.info("ProjectController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ProjectController detail method rowId =>" + rowId);
		logger.info("ProjectController detail method openId =>" + openId);
		logger.info("ProjectController detail method publicId =>" + publicId);
		logger.info("ProjectController detail method currpage =>" + currpage);
		logger.info("ProjectController detail method pagecount =>" + pagecount);
		// 绑定对象
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ProjectResp sResp = cRMService.getSugarService().getProject2CrmService().getProjectSingle(rowId,crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ProjectAdd> list = sResp.getProjects();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("proName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
					request.setAttribute("auditList", list.get(0).getAudits());//跟进数据
					
					// 用户对象
					UserReq uReq = new UserReq();
					uReq.setCurrpage("1");
					uReq.setPagecount("1000");
					uReq.setCrmaccount(crmId);
					uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
					UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
					request.setAttribute("userList",
							uResp.getUsers() == null ? new ArrayList<UserAdd>()
									: uResp.getUsers());

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
					//查询当前任务下关联的共享用户
					Share share = new Share();
					share.setParentid(rowId);
					share.setParenttype("Project");
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
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		// 分享控制按钮
		request.setAttribute("shareBtnContol",
				request.getParameter("shareBtnContol"));

		RedisCacheUtil.set("WK_Project_"+openId+"_"+rowId,DateTime.currentDateTime(DateTime.DateTimeFormat2));	//缓存最后访问时间
		return "project/detail";
	}
	
	/**
	 * 工作日程 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ProjectController modify method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ProjectController modify method rowId =>" + rowId);
		logger.info("ProjectController modify method openId =>" + openId);
		logger.info("ProjectController modify method publicId =>" + publicId);
		logger.info("ProjectController modify method currpage =>" + currpage);
		logger.info("ProjectController modify method pagecount =>" + pagecount);
		// 绑定对象
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ProjectResp sResp = cRMService.getSugarService().getProject2CrmService().getProjectSingle(rowId,crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ProjectAdd> list = sResp.getProjects();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("proName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
					Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
					request.setAttribute("project_status_dom", mp.get("project_status_dom"));
					request.setAttribute("projects_priority_options", mp.get("projects_priority_options"));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		// 分享控制按钮
		request.setAttribute("shareBtnContol",
				request.getParameter("shareBtnContol"));
		return "project/modify";
	}
	/**
	 * 新增 项目
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	public String save(Project obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(obj.getOpenId(), obj.getPublicId());
		//判断crmId 是否为空
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setCrmId(crmId);
			CrmError crmErr = cRMService.getSugarService().getProject2CrmService().addProject(obj);
			String rowId = crmErr.getRowId();
			if (null != rowId && !"".equals(rowId)) {
				request.setAttribute("rowId", rowId);
				request.setAttribute("success", "ok");
				//如果责任人不是本人，就发送消息
				if(null != obj.getAssignerid() && !obj.getCrmId().equals(obj.getAssignerid())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(),request.getSession().getAttribute("assigner")+" 分配了一个项目【"+obj.getName()+"】给您", "project/detail?rowId="+rowId);
				}
				
			}else{
				request.setAttribute("rowId", "");
				request.setAttribute("success", "fail");
				request.setAttribute("errorCode", crmErr.getErrorCode());
				request.setAttribute("errorMsg", crmErr.getErrorMsg());
			}
			request.setAttribute("openId", obj.getOpenId());
			request.setAttribute("publicId", obj.getPublicId());
			return "redirect:/project/detail?rowId=" + rowId
					+ "&openId=" + obj.getOpenId() + "&publicId="
					+ obj.getPublicId();
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
	}
	
	/**
	 * 更新项目
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update")
	public String update(Project obj,HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(obj.getOpenId(), obj.getPublicId());
		//判断crmId 是否为空
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setCrmId(crmId);
			obj.setOptype("upd");
			CrmError crmErr =cRMService.getSugarService().getProject2CrmService().updateProject(obj);
			if(!ErrCode.ERR_CODE_0.equals(crmErr.getErrorCode())){
			    throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}else{
				request.setAttribute("rowId", "");
				request.setAttribute("success", "fail");
				request.setAttribute("errorCode", crmErr.getErrorCode());
				request.setAttribute("errorMsg", crmErr.getErrorMsg());
			}
			request.setAttribute("openId", obj.getOpenId());
			request.setAttribute("publicId", obj.getPublicId());
			return "redirect:/project/detail?rowId=" + obj.getRowid()
					+ "&openId=" + obj.getOpenId() + "&publicId="
					+ obj.getPublicId();
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
	}
	
	/**
	 * 更新项目
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/allocation")
	@ResponseBody
	public String allocation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId=request.getParameter("openId");
		String publicId=request.getParameter("publicId");
		String rowId=request.getParameter("rowId");
		String assignId=request.getParameter("assignId");
		String crmId = cRMService.getSugarService().getProject2CrmService().getCrmId(openId, publicId);
		//判断crmId 是否为空
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
		    Project obj=new Project();
		    obj.setCrmId(crmId);
			obj.setAssignerid(assignId);
			obj.setRowid(rowId);
			obj.setOptype("allot");
			try{
			crmErr =cRMService.getSugarService().getProject2CrmService().updateProject(obj);
			}catch(Exception e){
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001006);
				crmErr.setErrorMsg(ErrCode.ERR_CODE_1001006_MSG);
			}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 *添加项目
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	public String get(HttpServletRequest request,HttpServletRequest response) throws Exception  {
		//openId appId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentId = request.getParameter("parentId");
		String parentName = request.getParameter("parentName");
		String parentType = request.getParameter("parentType"); 
		request.setAttribute("parentId", parentId);
		request.setAttribute("parentName", parentName);
		request.setAttribute("parentType", parentType);
		openId = (openId == null) ? "" : openId ;
        publicId = (publicId == null) ? "" : publicId ;
		//检测绑定
		OperatorMobile opMobile = cRMService.getSugarService().getProject2CrmService().checkBinding(openId, publicId);
   		logger.info("ProjectController get method openId =>" + openId);
   		logger.info("ProjectController get method publicId =>" + publicId);
   		logger.info("ProjectController get method crmId =>" + opMobile.getCrmId());
   		if((opMobile == null) 
				|| (null == opMobile.getCrmId()) 
				|| "".equals(opMobile.getCrmId()) ){
			request.setAttribute("bindSucc", "fail");
			return "project/msg";
		}else {
			//crmId
			request.setAttribute("crmId", opMobile.getCrmId());
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);				
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(opMobile.getCrmId());
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			if (null != currResp.getUsers()
					&& null != currResp.getUsers().get(0).getUsername()) {
				
				request.setAttribute("assigner", currResp.getUsers().get(0)
						.getUsername());
				request.setAttribute("assignerId", currResp.getUsers().get(0)
						.getUserid());
			}
			//获取下拉列表信息和 责任人的用户列表信息 
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(opMobile.getCrmId());
			request.setAttribute("project_status_dom", mp.get("project_status_dom"));
			request.setAttribute("projects_priority_options", mp.get("projects_priority_options"));
			//责任人对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(opMobile.getCrmId());
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
	    	//获取用户头像数据
			Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			if(null != obj1){
				WxuserInfo wxuinfo = (WxuserInfo)obj1;
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
			request.setAttribute("viewtype", Constants.SEARCH_VIEW_TYPE_ALLVIEW);
			return "project/add";
		}
	}
}
