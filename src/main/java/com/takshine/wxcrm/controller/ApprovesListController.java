package com.takshine.wxcrm.controller;

import java.util.List;
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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveListAdd;
import com.takshine.wxcrm.message.sugar.ApproveListResp;
import com.takshine.wxcrm.service.ApproveListService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 审批页面控制器
 * 
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/approves")
public class ApprovesListController {
	// 日志服务
	Logger logger = Logger.getLogger(ApprovesListController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	

	/**
	 * 查询审批列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ApprovesListController acclist method begin=>");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		viewtype = (null==viewtype?"approvalview":viewtype);
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String startDate = request.getParameter("startdate");
		String endDate = request.getParameter("enddate");
		String assignerid = request.getParameter("assignerid");
		logger.info("ApprovesListController list method viewtype =>" + viewtype);
		logger.info("ApprovesListController list method currpage =>" + currpage);
		logger.info("ApprovesListController list method pagecount =>" + pagecount);
		logger.info("ApprovesListController list method startDate =>" + startDate);
		logger.info("ApprovesListController list method endDate =>" + endDate);
		logger.info("ApprovesListController list method assignerid =>" + assignerid);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ApproveListAdd approve = new ApproveListAdd();
			approve.setCrmaccount(crmId);
			approve.setViewtype(viewtype);// 视图类型
			approve.setPagecount(pagecount);
			approve.setCurrpage(currpage);
			approve.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			if(null != startDate && !"".equals(startDate)){
				approve.setStartdate(startDate.replaceAll("-",""));
			}
			if(null != endDate && !"".equals(endDate)){
				approve.setEnddate(endDate.replaceAll("-",""));
			}
			approve.setAssignerid(assignerid);
			ApproveListResp aResp = cRMService.getSugarService().getApproveListService().getApproveList(approve,"WEB");
//			//获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = lovUser2SugarService.getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				request.setAttribute("assignername",currResp.getUsers().get(0).getUsername());
//			}
			String errorCode = aResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ApproveListAdd> list = aResp.getApproves();
				request.setAttribute("approveList", list);
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + aResp.getErrcode() + "，错误描述：" + aResp.getErrmsg());
				}
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("startdate", startDate);
		request.setAttribute("enddate", endDate);
		request.setAttribute("assignerid", assignerid);
		request.setAttribute("crmId", crmId);
		return "approves/list";
	}
	
	/**
	 * 异步查询审批列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asylist")
	@ResponseBody
	public String asylist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ApprovesListController acclist method begin=>");
		String str = "";
		//error 对象
		CrmError crmErr = new CrmError();
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String startDate = request.getParameter("startdate");
		String endDate = request.getParameter("enddate");
		String assignerid = request.getParameter("assignerid");
		logger.info("ApprovesListController list method viewtype =>" + viewtype);
		logger.info("ApprovesListController list method currpage =>" + currpage);
		logger.info("ApprovesListController list method pagecount =>" + pagecount);
		logger.info("ApprovesListController list method startDate =>" + startDate);
		logger.info("ApprovesListController list method endDate =>" + endDate);
		logger.info("ApprovesListController list method assignerid =>" + assignerid);
		// 绑定对象
		String crmId =UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ApproveListAdd approve = new ApproveListAdd();
			approve.setCrmaccount(crmId);
			approve.setViewtype(viewtype);// 视图类型
			approve.setPagecount(pagecount);
			approve.setCurrpage(currpage);
			if(null != startDate && !"".equals(startDate)){
				approve.setStartdate(startDate.replaceAll("-",""));
			}
			if(null != endDate && !"".equals(endDate)){
				approve.setEnddate(endDate.replaceAll("-",""));
			}
			approve.setAssignerid(assignerid);
			ApproveListResp aResp =  cRMService.getSugarService().getApproveListService().getApproveList(approve,"WEB");
			String errorCode = aResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ApproveListAdd> cList = aResp.getApproves();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
			    crmErr.setErrorCode(aResp.getErrcode());
			    crmErr.setErrorMsg(aResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 批量审批
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/batchApproval")
	public String batchApproval(ApproveListAdd add,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ApprovesListController batchApproval method crmId =>" + crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			add.setCrmaccount(crmId);
			add.setCommitid(crmId);
			CrmError crmError = cRMService.getSugarService().getApproveListService().updateApproveList(add);
			String errorcode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorcode)){
				return "redirect:/approves/list";
			}else{
				throw new Exception("操作失败!错误编码:"+crmError.getErrorCode()+"  错误描述:"+crmError.getErrorMsg());
			}
		}else{
			throw new Exception("操作失败!错误编码:"+ErrCode.ERR_CODE_1001001+"  错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
}
