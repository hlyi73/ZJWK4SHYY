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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BugResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ProjectAdd;
import com.takshine.wxcrm.message.sugar.ProjectResp;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Bug2SugarService;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.Project2CrmService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.UserFocusService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * bug 控制器
 * @author lilei
 *
 */
@Controller
@RequestMapping("/bug")
public class BugController {
	protected static Logger logger = Logger.getLogger(BugController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 查询所有的任务列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("BugController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
			   currpage = (null == currpage ? "1" : currpage);
			   pagecount = (null == pagecount ? "8" : pagecount);
		String viewtype = request.getParameter("viewtype");
		String status = request.getParameter("status");
		String assignerid = request.getParameter("assignerid");
		       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		String parentid=request.getParameter("parentid");
		String parenttype=request.getParameter("parenttype");
		logger.info("BugController list method viewtype =>" + viewtype);
		String crmId = cRMService.getSugarService().getBug2SugarService().getCrmId(openId, publicId);
		//获取绑定的账户 在sugar系统的id
		logger.info("crmId:-> is =" + crmId);
		//错误对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			Bug sche = new Bug();
			//组装查询条件
			sche.setViewtype(viewtype);//视图类型
			sche.setCrmId(crmId);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setParentid(parentid);
			sche.setParenttype(parenttype);;
			sche.setStatus(status);
			if(null == assignerid || "".equals(assignerid)){
				sche.setAssigner(crmId);
			}else{
				sche.setAssigner(assignerid);
			}
			//查询日程列表
			BugResp sResp = cRMService.getSugarService().getBug2SugarService().getBugList(sche);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<Bug> list = sResp.getBugs();
				request.setAttribute("bugList", list);
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}
			request.setAttribute("crmId", crmId);
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("parentid", parentid);
		request.setAttribute("parenttype", parenttype);
		return "bug/list";
	}
	/**
	 * 查询所有的任务列表
	 * @param request
	 * @param response
	 * @return josnStr
	 * @throws Exception
	 */
	@RequestMapping("/jsonlist")
	@ResponseBody
	public String listJson(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("BugController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
			   currpage = (null == currpage ? "1" : currpage);
			   pagecount = (null == pagecount ? "8" : pagecount);
		String viewtype = request.getParameter("viewtype");
		String status = request.getParameter("status");
		String assignerid = request.getParameter("assignerid");
		       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		String parentid=request.getParameter("parentid");
		String parenttype=request.getParameter("parenttype");
		logger.info("BugController list method viewtype =>" + viewtype);
		String crmId = cRMService.getSugarService().getBug2SugarService().getCrmId(openId, publicId);
		//获取绑定的账户 在sugar系统的id
		logger.info("crmId:-> is =" + crmId);
		//错误对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			Bug sche = new Bug();
			//组装查询条件
			sche.setViewtype(viewtype);//视图类型
			sche.setCrmId(crmId);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setParentid(parentid);
			sche.setParenttype(parenttype);;
			sche.setStatus(status);
			if(null == assignerid || "".equals(assignerid)){
				sche.setAssigner(crmId);
			}else{
				sche.setAssigner(assignerid);
			}
			//查询日程列表
			BugResp sResp = cRMService.getSugarService().getBug2SugarService().getBugList(sche);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<Bug> list = sResp.getBugs();
				return JSONArray.fromObject(list).toString();
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
	 * Bug详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("BugController detail method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("BugController detail method rowId =>" + rowId);
		logger.info("BugController detail method openId =>" + openId);
		logger.info("BugController detail method publicId =>" + publicId);
		//查询crmId是否存在
		String crmId = cRMService.getSugarService().getBug2SugarService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			//查询单个
			Bug sche = new Bug();
			//组装查询条件
			sche.setCrmId(crmId);
			sche.setRowid(rowId);
			BugResp sResp = cRMService.getSugarService().getBug2SugarService().getBug(rowId, crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<Bug> list = sResp.getBugs();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("sd", list.get(0));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
			}
			
			//lov
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("statusDom", mp.get("bug_status_dom"));
			request.setAttribute("priorityDom", mp.get("priority_dom"));
			request.setAttribute("resolutionDom", mp.get("bug_resolution_dom"));
			
			//用户对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			
			//客户 列表
			Customer sc = new Customer();
			sc.setCrmId(crmId);
			sc.setCurrpage("1");
			sc.setPagecount("10");
			sc.setViewtype("myallview");
			sc.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sc,"WEB");
			List<CustomerAdd> cList = cResp.getCustomers();
			request.setAttribute("cList", cList);
			
			//查询业务机会信息
			Opportunity opp = new Opportunity();
			opp.setCrmId(crmId);
			opp.setCurrpage("1");
			opp.setPagecount("10");
			opp.setViewtype("myallview");
			opp.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			OpptyResp oppResp = cRMService.getSugarService().getOppty2SugarService().getOpportunityList(opp,"WEB");
			List<OpptyAdd> oppList = oppResp.getOpptys();
			request.setAttribute("oppList", oppList);
			
			//查询项目信息
			Project pro = new Project();
			pro.setCrmId(crmId);
			pro.setCurrpage("1");
			pro.setPagecount("10");
			pro.setViewtype("myallview");
			ProjectResp gResp = cRMService.getSugarService().getProject2CrmService().getProjectList(pro,"WEB");
			List<ProjectAdd> proList = gResp.getProjects();
			request.setAttribute("proList", proList);
			
			//获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			currResp.getUsers();
			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
				request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
			}
			
			//查询当前任务下关联的共享用户
			Share share = new Share();
			share.setParentid(rowId);
			share.setParenttype("Bug");
			share.setCrmId(crmId);
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			request.setAttribute("shareusers", shareAdds);
			
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		//分享控制按钮
		request.setAttribute("shareBtnContol", request.getParameter("shareBtnContol"));
		return "bug/detail";
	}
	
	/**
	 * bug更新状态
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/updatestatus")
	public String updateBug(Bug obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("scheduleComplete method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("BugController detail method rowId =>" + rowId);
		logger.info("BugController detail method openId =>" + openId);
		logger.info("BugController detail method publicId =>" + publicId);
		
		//查询crmId是否存在
		String crmId = cRMService.getSugarService().getBug2SugarService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		
		//获取绑定的账户 在sugar系统的id
		if(crmId != null && !"".equals(crmId)){
			obj.setCrmId(crmId);
			obj.setRowid(rowId);
			CrmError crmErr = cRMService.getSugarService().getBug2SugarService().updateBugStatus(obj, crmId);
			String errorCode = crmErr.getErrorCode();
			if(!ErrCode.ERR_CODE_0.equals(errorCode)){
			    throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//request info
		request.setAttribute("command", obj);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		
		//commitid为空  则表示为 “保存动作”
		return "redirect:/bug/detail?rowId="+ rowId +"&openId="+ openId + "&publicId="+ publicId;
	}
	
	
	/**
	 * 异步查询所有的BUG个数
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/alist")
	@ResponseBody
	public String alist(HttpServletRequest request,HttpServletResponse response) throws Exception{
		logger.info("BugController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		viewtype = (viewtype == null ) ? "allview" : viewtype ; 
		String parentId = request.getParameter("parentId");
		String currpage = request.getParameter("currpage");
		       currpage = (currpage == null ) ? "1" : currpage ; 
		String pagecount = request.getParameter("pagecount");
		       pagecount = (pagecount == null ) ? "10" : pagecount ; 
		String crmId = cRMService.getSugarService().getBug2SugarService().getCrmId(openId, publicId);
		logger.info("BugController alist method crmId =>" + crmId);
		logger.info("BugController alist method viewtype =>" + viewtype);
		logger.info("BugController alist method parentId =>" + parentId);
		logger.info("BugController alist method pagecount =>" + pagecount);
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			Bug sche = new Bug();
			sche.setViewtype(viewtype);//视图类型
			sche.setCrmId(crmId);
			sche.setParentid(parentId);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			BugResp sResp = cRMService.getSugarService().getBug2SugarService().getBugList(sche);
			List<Bug> list = sResp.getBugs();
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
}
