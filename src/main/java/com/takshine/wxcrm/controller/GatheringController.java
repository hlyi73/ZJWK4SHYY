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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Gathering;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.GatheringResp;

/**
 * 收款页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/gathering")
public class GatheringController {
	//日志服务
	Logger logger = Logger.getLogger(GatheringController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询收款列表

	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,HttpServletResponse response) throws Exception {
		logger.info("GatheringController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtypesel = request.getParameter("viewtypesel");
		String verifityStatus = request.getParameter("verifityStatus");
		String depart = request.getParameter("depart");
		String month=request.getParameter("month");
		String assignerId = request.getParameter("assignerId");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		if(null != depart){
			depart = new String(depart.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(month)){
			month = month.replaceAll("-", "");
		}
		if(null != startDate && !"".equals(startDate) && startDate.length() >=7){
			startDate = startDate.substring(0,7);
			startDate=startDate.replaceAll("-", "");
		}
		if(null != endDate && !"".equals(endDate) && endDate.length() >=7){
			endDate = endDate.substring(0,7);
			endDate=endDate.replaceAll("-", "");
		}
		String planDate = request.getParameter("planDate");
		String status = request.getParameter("status");
	    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("GatheringController acclist method openId =>" + openId);
		logger.info("GatheringController acclist method publicId =>" + publicId);
		logger.info("GatheringController list method viewtype =>" + viewtype);
		logger.info("GatheringController list method currpage =>" + currpage);
		logger.info("GatheringController list method pagecount =>" + pagecount);
		logger.info("GatheringController list method viewtypesel =>" + viewtypesel);
		logger.info("GatheringController list method status =>" + status);
		logger.info("GatheringController list method depart =>" + depart);
		//绑定对象
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Gathering gathering = new Gathering();
			gathering.setCrmId(crmId);
			gathering.setViewtype(viewtype);//视图类型
			gathering.setPagecount(pagecount);
			gathering.setCurrpage(currpage);
			gathering.setStatus(status);
			gathering.setDepart(depart);
			gathering.setPlanDate(planDate);
			gathering.setMonth(month);
			gathering.setVerifityStatus(verifityStatus);
			gathering.setStartDate(startDate);
			gathering.setEndDate(endDate);
			gathering.setAssignerId(assignerId);
			GatheringResp gResp = cRMService.getSugarService().getGathering2CrmService().getGatheringList(gathering,"WEB");
			List<GatheringAdd> list = gResp.getGatherings();
			//放到页面上
			if(null != list && list.size() > 0){
				request.setAttribute("gatheringList", list);
			}else{
				request.setAttribute("gatheringList", new ArrayList<GatheringAdd>());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtypesel", viewtypesel);
		request.setAttribute("status", status);
		return "shenyi/gathering/list";
	}
	
	/**
	 * 分页查询
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gatheringlist")
	@ResponseBody
	public String gatheringlist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("GatheringController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String planDate = request.getParameter("planDate");
		String status = request.getParameter("status");
		String verifityStatus = request.getParameter("verifityStatus");
	    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		//绑定对象
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Gathering gathering = new Gathering();
			gathering.setCrmId(crmId);
			gathering.setViewtype(viewtype);//视图类型
			gathering.setPagecount(pagecount);
			gathering.setCurrpage(currpage);
			gathering.setStatus(status);
			gathering.setPlanDate(planDate);
			gathering.setVerifityStatus(verifityStatus);
			//查询应收款 回款 列表集合
			GatheringResp gResp = cRMService.getSugarService().getGathering2CrmService().getGatheringList(gathering,"WEB");
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<GatheringAdd> list = gResp.getGatherings();
				return JSONArray.fromObject(list).toString();
			}else{
			    crmErr.setErrorCode(gResp.getErrcode());
			    crmErr.setErrorMsg(gResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 查询已核销或未核销的收款列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/verlist")
	public String verList(HttpServletRequest request,HttpServletResponse response) throws Exception {
		logger.info("GatheringController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtypesel = request.getParameter("viewtypesel");
		String status = request.getParameter("status");
		String verifityStatus = request.getParameter("VerifityStatus");
	    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("GatheringController acclist method openId =>" + openId);
		logger.info("GatheringController acclist method publicId =>" + publicId);
		logger.info("GatheringController list method viewtype =>" + viewtype);
		logger.info("GatheringController list method currpage =>" + currpage);
		logger.info("GatheringController list method pagecount =>" + pagecount);
		logger.info("GatheringController list method viewtypesel =>" + viewtypesel);
		logger.info("GatheringController list method status =>" + status);
		//绑定对象
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Gathering gathering = new Gathering();
			gathering.setCrmId(crmId);
			gathering.setViewtype(viewtype);//视图类型
			gathering.setPagecount(pagecount);
			gathering.setCurrpage(currpage);
			gathering.setStatus(status);
			gathering.setVerifityStatus(verifityStatus);
			GatheringResp gResp = cRMService.getSugarService().getGathering2CrmService().getGatheringList(gathering,"WEB");
			List<GatheringAdd> list = gResp.getGatherings();
			//放到页面上
			if(null != list && list.size() > 0){
				request.setAttribute("gatheringList", list);
			}else{
				request.setAttribute("gatheringList", new ArrayList<GatheringAdd>());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtypesel", viewtypesel);
		request.setAttribute("status", status);
		//未审核标志:财务核销使用
//		request.setAttribute("verifityFlag", "verifity");
		return "shenyi/gathering/verlist";
	}
	
	/**
	 * 查询收款详情
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,HttpServletResponse response) throws Exception{
		logger.info("GatheringController detail method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String gatheringtype = request.getParameter("gatheringtype");
		logger.info("GatheringController detail method rowId =>" + rowId);
		logger.info("GatheringController detail method openId =>" + openId);
		logger.info("GatheringController detail method publicId =>" + publicId);
		logger.info("GatheringController detail method gatheringtype =>" + gatheringtype);
		//绑定对象
		String crmId = request.getParameter("crmId");
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			GatheringResp gResp = cRMService.getSugarService().getGathering2CrmService().getGatheringSingle(rowId, crmId,gatheringtype);
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<GatheringAdd> list = gResp.getGatherings();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("gatheringName", list.get(0).getTitle());
					request.setAttribute("msg",Float.parseFloat(list.get(0).getMargin())<0.00 ? true:false);
					request.setAttribute("ga", list.get(0));
					request.setAttribute("auditList", list.get(0).getAudits());
					//获取下拉列表信息和 责任人的用户列表信息 
					Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
					request.setAttribute("status", mpSta.get("ticket_status_list"));
					request.setAttribute("types", mpSta.get("receiv_type_list"));
					request.setAttribute("paymentlist", mpSta.get("payment_type_list"));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
			    throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
			}
			
//			String username="";
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				username = currResp.getUsers().get(0).getUsername();
//			}
//			request.setAttribute("username", username);
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("gatheringtype", gatheringtype);
		//分享控制按钮
		request.setAttribute("shareBtnContol", request.getParameter("shareBtnContol"));
		if("plan".equals(gatheringtype)){
			return "shenyi/gathering/pdetail";
		}else{
			return "shenyi/gathering/detail";
		}
	}
	
	/**
	 * 跟进回款
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/followup")
	public String followup(Gathering obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//openId appId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String rowId = request.getParameter("rowId");
		String verifityFlag = request.getParameter("verifityFlag");//审核标志
		String invoicedId = request.getParameter("invoicedId");//某条回款历史记录的ID
		logger.info("GatheringController followup method openId =>" + openId);
		logger.info("GatheringController followup method publicId =>" + publicId);
		logger.info("GatheringController followup method rowId =>" + rowId);
		//获取用户头像数据
		Object u = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
		if(null != u){
			WxuserInfo wxuinfo = (WxuserInfo)u;
			request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
		}else{
			request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("rowId", rowId);
		request.setAttribute("obj", obj);
		request.setAttribute("verifityFlag", verifityFlag);
		request.setAttribute("invoicedId", invoicedId);
		return "shenyi/gathering/followup";
	}
	
	/**
	 * 保存回款跟进信息
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveFollowup")
	public String saveFollowup(Gathering obj, HttpServletRequest request,HttpServletResponse response) throws Exception {
		//openId appId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String rowId = request.getParameter("rowId");
		logger.info("GatheringController saveFollowup method openId =>" + openId);
		logger.info("GatheringController saveFollowup method publicId =>" + publicId);
		logger.info("GatheringController saveFollowup method rowId =>" + rowId);
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			obj.setCrmId(crmId);
			String rst = cRMService.getSugarService().getGathering2CrmService().saveFollowup(obj, rowId);
			if(null != rst && !"".equals(rst)){
				request.setAttribute("flowupSuc", "ok");
			}else{
				request.setAttribute("flowupSuc", "fail");
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//return "shenyi/gathering/msg";
		return "redirect:/gathering/detail?rowId="+ rowId +"&openId="+ obj.getOpenId()+ "&publicId="+ obj.getPublicId();
	}
	
	/**
	 * 财务审核信息
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/finaVer")
	public String finaceVerifity(Gathering obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//openId appId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String invoicedId = request.getParameter("invoicedId");
		String rowId = request.getParameter("rowId");
		logger.info("GatheringController saveFollowup method openId =>" + openId);
		logger.info("GatheringController saveFollowup method publicId =>" + publicId);
		logger.info("GatheringController saveFollowup method invoicedId =>" + invoicedId);
		logger.info("GatheringController saveFollowup method rowId =>" + rowId);
		
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			obj.setCrmId(crmId);
			String rst = cRMService.getSugarService().getGathering2CrmService().finaceVerifity(obj, invoicedId);
			if(null != rst && !"".equals(rst)){
				request.setAttribute("checkSuc", "ok");
			}else{
				request.setAttribute("checkSuc", "fail");
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//return "shenyi/gathering/msg";
		return "redirect:/gathering/detail?rowId="+ rowId +"&openId="+ obj.getOpenId()+ "&publicId="+ obj.getPublicId();
	}
	
	
	/**
	 * 查询回款开票List
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/ilist")
	public String ilist(HttpServletRequest request,HttpServletResponse response) throws Exception {
		logger.info("GatheringController alist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String contractId = request.getParameter("contractId");//合同ID
		String rowid = request.getParameter("rowId");//回款计划ID
		logger.info("GatheringController alist method openId =>" + openId);
		logger.info("GatheringController alist method publicId =>" + publicId);
		logger.info("GatheringController alist method contractId =>" + contractId);
		logger.info("GatheringController alist method rowid =>" + rowid);
		//绑定对象
		String crmId = request.getParameter("crmId");
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Gathering gathering = new Gathering();
			gathering.setCrmId(crmId);
			gathering.setContractId(contractId);
			gathering.setRowid(rowid);
			GatheringResp gResp = cRMService.getSugarService().getGathering2CrmService().getGatheringListForInv(gathering,"WEB");
			List<GatheringAdd> list = gResp.getGatherings();
			//放到页面上
			if(null != list && list.size() > 0){
				request.setAttribute("gatheringList", list);
			}else{
				request.setAttribute("gatheringList", new ArrayList<GatheringAdd>());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		return "shenyi/gathering/invlist";
	}
	
	/**
	 * 增加回款
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String add(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		logger.info("GatheringController add openId ==="+openId);
		logger.info("GatheringController add publicId ==="+publicId);
		logger.info("GatheringController add crmId ==="+crmId);
		String gatheringtype = request.getParameter("gatheringtype");
		String contractName = request.getParameter("contractName");
		if(StringUtils.isNotNullOrEmptyStr(contractName)&&!StringUtils.regZh(contractName)){
			contractName = new String(contractName.getBytes("ISO-8859-1"),"UTF-8");
		}
		String contractId = request.getParameter("contractId");
		logger.info("GatheringController add contractName ==="+contractName);
		logger.info("GatheringController add contractId ==="+contractId);
		logger.info("GatheringController add contractId ==="+contractId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			request.setAttribute("contractName", contractName);
			request.setAttribute("contractId", contractId);
			request.setAttribute("gatheringtype", gatheringtype);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("orgId", orgId);
			//获取下拉列表信息和 责任人的用户列表信息 
			Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("status", mpSta.get("ticket_status_list"));
			request.setAttribute("types", mpSta.get("receiv_type_list"));
			request.setAttribute("paymentlist", mpSta.get("payment_type_list"));
			return "shenyi/gathering/add";
		}else{
			throw new Exception("操作失败!错误编码:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存回款
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String save(GatheringAdd gatheringAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String flag = request.getParameter("flag");
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		logger.info("GatheringController save openId ==="+openId);
		logger.info("GatheringController save publicId ==="+publicId);
		logger.info("GatheringController save crmId ==="+crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			if("plan".equals(flag)){
				gatheringAdd.setGatheringtype("detail");
				gatheringAdd.setReceivedAmount(gatheringAdd.getPlanAmount());
				gatheringAdd.setReceivedDate(gatheringAdd.getPlanDate());
			}
			gatheringAdd.setCrmaccount(crmId);
			CrmError crmError = cRMService.getSugarService().getGathering2CrmService().addGathering(gatheringAdd);
			String errcode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				if("plan".equals(flag)){
					return "redirect:/gathering/detail?gatheringtype=plan&rowId="+gatheringAdd.getRowid()+"&openId="+openId+"&publicId="+publicId+"&crmId="+crmId;
				}else{
					String contractId = gatheringAdd.getContractId();
					return "redirect:/contract/detail?rowId="+contractId+"&openId="+openId+"&publicId="+publicId+"&orgId="+orgId;
				}
			}else{
				throw new Exception("操作失败!错误编码:"+errcode+"错误描述:"+crmError.getErrorMsg());
			}
		}else{
			throw new Exception("操作失败!错误编码:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 回款计划生成回款明细
	 * @param gatheringAdd
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asysave")
	@ResponseBody
	public String asysave(GatheringAdd gatheringAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String flag = request.getParameter("flag");
		String crmId = cRMService.getSugarService().getGathering2CrmService().getCrmId(openId, publicId);
		CrmError crmError =  new CrmError();
		logger.info("GatheringController asysave openId ==="+openId);
		logger.info("GatheringController asysave publicId ==="+publicId);
		logger.info("GatheringController asysave crmId ==="+crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			if("plan".equals(flag)){
				gatheringAdd.setGatheringtype("detail");
				String planAmount = gatheringAdd.getPlanAmount();
				if(StringUtils.isNotNullOrEmptyStr(planAmount)&&planAmount.contains(",")){
					planAmount = planAmount.replaceFirst(",", "");
				}
				gatheringAdd.setReceivedAmount(planAmount);
				gatheringAdd.setReceivedDate(gatheringAdd.getPlanDate());
			}
			gatheringAdd.setCrmaccount(crmId);
			crmError = cRMService.getSugarService().getGathering2CrmService().addGathering(gatheringAdd);
		}else{
			crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 修改回款
	 * @param gatheringAdd
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update")
	public String update(GatheringAdd gatheringAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = request.getParameter("crmId");
		logger.info("GatheringController update openId ==="+openId);
		logger.info("GatheringController update publicId ==="+publicId);
		logger.info("GatheringController update crmId ==="+crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			gatheringAdd.setCrmaccount(crmId);
			CrmError crmError = cRMService.getSugarService().getGathering2CrmService().updateGathering(gatheringAdd);
			String errcode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return "redirect:/gathering/detail?rowId="+gatheringAdd.getRowid()+"&openId="+openId+"&publicId="+publicId+"&gatheringtype="+gatheringAdd.getGatheringtype()+"&crmId="+crmId;
			}else{
				throw new Exception("操作失败!错误编码:"+errcode+"错误描述:"+crmError.getErrorMsg());
			}
		}else{
			throw new Exception("操作失败!错误编码:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
}
