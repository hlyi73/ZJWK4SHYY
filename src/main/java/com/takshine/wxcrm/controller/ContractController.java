package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Contract;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContractAdd;
import com.takshine.wxcrm.message.sugar.ContractResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 合同页面控制器
 * 
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/contract")
public class ContractController {
	// 日志服务
	Logger logger = Logger.getLogger(ContractController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 查询合同列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ContractController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		viewtype = (viewtype == null) ? "myview" : viewtype;
		String status = request.getParameter("status");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		//预期销售目标报表查询条件
		String startDate = request.getParameter("startdate");//季度的开始时间
		String endDate = request.getParameter("enddate");//季度的结束时间
		String assignId = request.getParameter("assignerId");
		String quarter = request.getParameter("quarter");
		if(StringUtils.isNotNullOrEmptyStr(quarter)){
			startDate = DateTime.qua2date(quarter).split(",")[0];
			endDate = DateTime.qua2date(quarter).split(",")[1];
		}
		//前台list页面查询条件
		String name = request.getParameter("name");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String orderString = request.getParameter("orderString");
		logger.info("ContractController acclist method openId =>" + openId);
		logger.info("ContractController acclist method publicId =>" + publicId);
		logger.info("ContractController list method viewtype =>" + viewtype);
		logger.info("ContractController list method currpage =>" + currpage);
		logger.info("ContractController list method pagecount =>" + pagecount);
		logger.info("ContractController list method pagecount =>" + name);
		logger.info("ContractController list method pagecount =>" + status);
		logger.info("ContractController list method pagecount =>" + assignId);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contract contract = new Contract();
			contract.setCrmId(crmId);
			contract.setViewtype(viewtype);// 视图类型
			contract.setPagecount(pagecount);
			contract.setCurrpage(currpage);
			contract.setContractstatus(status);
			if(null != startDate && !"".equals(startDate)){
				contract.setStartdate(startDate.replaceAll("-",""));
			}
			if(null != endDate && !"".equals(endDate)){
				contract.setEnddate(endDate.replaceAll("-",""));
			}
			contract.setAssignId(assignId);
			contract.setTitle(name);
			contract.setOrderString(orderString);
			contract.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContractResp gResp = cRMService.getSugarService().getContract2CrmService().getContractList(contract,"WEB");
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContractAdd> list = gResp.getContracts();
				request.setAttribute("contractList", list);
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
				}
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
				.getLovList(crmId);
		request.setAttribute("statusdom", mp.get("contacts_status_list"));// 获取行业下拉框的值
		// requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("status", status);
		request.setAttribute("name", name);
		request.setAttribute("startdate", startDate);
		request.setAttribute("enddate", endDate);
		request.setAttribute("assignerId", assignId);
		request.setAttribute("quarter", quarter);
		request.setAttribute("orderString", orderString);
		return "shenyi/contract/list";
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
			List<String> searchList = new ArrayList<String>();
			Set<String> rs = RedisCacheUtil.getSortedSetRange("contract_search_"+ crmId, 0, 0);
			RedisCacheUtil.delete("contract_search_" + crmId);
			if(rs!=null&&rs.size()==1){
				rs =new HashSet<String>();
			}
			try{
				for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
					String searchcon = (String) iterator.next();
					logger.info("ContractController searchcache method searchcon=>"+ searchcon);
					if(!searchcon.contains(name)){
						searchList.add(searchcon);
					}
				}
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("contract_search_"+crmId, searchList.get(i), i);
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
			HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String assignerid=request.getParameter("assignerid");
		String name = request.getParameter("name");
		String status =request.getParameter("status");
		String searchname =request.getParameter("searchname");
		if(StringUtils.isNotNullOrEmptyStr(searchname)&&!StringUtils.regZh(searchname)){
			searchname = new String(searchname.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String searchcon=searchname+"|"+"name:"+name+"|"+"status:"+status+"|"+"assignerid:"+assignerid;
		logger.info("ContractController  savesearch method crmId =>" + crmId);
		logger.info("ContractController  savesearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("contract_search_"+crmId, searchList.get(i), i);
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
		String openId = request.getParameter("openId");// crmIdID
		String publicId = request.getParameter("publicId");// crmIdID
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ContractController searchcache method crmId =>" + crmId);
		// cache
		List<String> sealist = new ArrayList<String>();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			// 获取缓存的查询条件
			Set<String> rs = RedisCacheUtil.getSortedSetRange("contract_search_"+ crmId, 0, 0);
			for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
				String searchcon = (String) iterator.next();
				sealist.add(searchcon);
				logger.info("ContractController searchcache method searchcon=>"+ searchcon);
			}
		}else{
			throw new Exception("操作失败,错误编码:"+ErrCode.ERR_CODE_1001001+"操作描述:"+ErrCode.ERR_MSG_UNBIND);
		}
		return JSONArray.fromObject(sealist).toString();
	}
	
	/**
	 * 异步查询合同列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asylist")
	@ResponseBody
	public String asylist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("ContractController acclist method begin=>");
		String str = "";
		//error 对象
		CrmError crmErr = new CrmError();
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String firstchar = request.getParameter("firstchar");
		firstchar = (firstchar == null ) ? "" : firstchar ;
		viewtype = (viewtype == null) ? "myview" : viewtype;
		String status = request.getParameter("status");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		//预期销售目标报表查询条件
		String startDate = request.getParameter("startdate");//季度的开始时间
		String endDate = request.getParameter("enddate");//季度的结束时间
		String assignId = request.getParameter("assignerId");
		String quarter = request.getParameter("quarter");
		if(StringUtils.isNotNullOrEmptyStr(quarter)){
			startDate = DateTime.qua2date(quarter).split(",")[0];
			endDate = DateTime.qua2date(quarter).split(",")[1];
		}
		//前台list页面查询条件
		String name = request.getParameter("name");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String orderString = request.getParameter("orderString");
		logger.info("ContractController acclist method openId =>" + openId);
		logger.info("ContractController acclist method publicId =>" + publicId);
		logger.info("ContractController list method viewtype =>" + viewtype);
		logger.info("ContractController list method currpage =>" + currpage);
		logger.info("ContractController list method pagecount =>" + pagecount);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Contract contract = new Contract();
			contract.setCrmId(crmId);
			contract.setViewtype(viewtype);// 视图类型
			contract.setPagecount(pagecount);
			contract.setCurrpage(currpage);
			contract.setContractstatus(status);
			contract.setFirstchar(firstchar);
			if(null != startDate && !"".equals(startDate)){
				contract.setStartdate(startDate.replaceAll("-",""));
			}
			if(null != endDate && !"".equals(endDate)){
				contract.setEnddate(endDate.replaceAll("-",""));
			}
			contract.setAssignId(assignId);
			contract.setTitle(name);
			contract.setOrderString(orderString);
			contract.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContractResp gResp = cRMService.getSugarService().getContract2CrmService().getContractList(contract,"WEB");
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContractAdd> cList = gResp.getContracts();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
			    crmErr.setErrorCode(gResp.getErrcode());
			    crmErr.setErrorMsg(gResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		return JSONObject.fromObject(crmErr).toString();
	}


	/**
	 * 查询合同详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ContractController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("ContractController detail method rowId =>" + rowId);
		logger.info("ContractController detail method openId =>" + openId);
		logger.info("ContractController detail method publicId =>" + publicId);
		String orgId = request.getParameter("orgId");
		// 绑定对象
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getContract2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = (String)obj;
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ContractResp gResp = cRMService.getSugarService().getContract2CrmService().getContractSingle(rowId,
					crmId);
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContractAdd> list = gResp.getContracts();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("contractName", list.get(0).getTitle());
					request.setAttribute("con", list.get(0));
//					if(list.get(0).getGathering()!=null&&list.get(0).getGathering().size()>0){
//						List<GatheringAdd> listGathering = list.get(0).getGathering();
//						request.setAttribute("gatherings", listGathering);
//					}
					if(list.get(0).getApproves()!=null&&list.get(0).getApproves().size()>0){
						request.setAttribute("approves", list.get(0).getApproves());
					}
					if(list.get(0).getAudits()!=null&&list.get(0).getAudits().size()>0){
						request.setAttribute("auditList", list.get(0).getAudits());
					}
					//查询当前业务机会下关联的共享用户
					Share share = new Share();
					share.setParentid(rowId);
					share.setParenttype("Contract");
					share.setCrmId(crmId);
					ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
					List<ShareAdd> shareAdds = sresp.getShares();
					request.setAttribute("shareusers", shareAdds);
					
					// 查询联系人列表
//					Contact contact = new Contact();
//					contact.setCrmId(crmId);
//					contact.setPagecount("10");
//					contact.setCurrpage("1");
//					contact.setViewtype("myallview");
//					ContactResp cResp = contact2SugarService.getContactClist(
//							contact, "WEB");
//					List<ContactAdd> clist = cResp.getContacts();
//					if (null != list && list.size() > 0) {
//						request.setAttribute("contactList", clist);
//					} else {
//						request.setAttribute("contactList",new ArrayList<ContactAdd>());
//					}
					
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
			    throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
			}
			
			//用户名
//			String username="";
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				username = currResp.getUsers().get(0).getUsername();
//			}
//			request.setAttribute("username", username);
//			request.setAttribute("assigner", username);
		}else{
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

		RedisCacheUtil.set("WK_Contract_"+openId+"_"+rowId,DateTime.currentDateTime(DateTime.DateTimeFormat2));	//缓存最后访问时间	
		return "shenyi/contract/detail";
	}
	
	/**
	 * 合同详情页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request, HttpServletResponse response)throws Exception{
		logger.info("ContractController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("ContractController modify method rowId =>" + rowId);
		logger.info("ContractController modify method openId =>" + openId);
		logger.info("ContractController detmodifyail method publicId =>" + publicId);
		String orgId = request.getParameter("orgId");
		// 绑定对象
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getContract2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = (String)obj;
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ContractResp gResp = cRMService.getSugarService().getContract2CrmService().getContractSingle(rowId, crmId);
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ContractAdd> list = gResp.getContracts();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("contractName", list.get(0).getTitle());
					request.setAttribute("con", list.get(0));
					if(list.get(0).getApproves()!=null&&list.get(0).getApproves().size()>0){
						request.setAttribute("approves", list.get(0).getApproves());
					}
				} else {
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("crmId", crmId);
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		// 分享控制按钮
		request.setAttribute("shareBtnContol",
				request.getParameter("shareBtnContol"));
		return "shenyi/contract/modify";
	}
	
	/**
     * 合同创建
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/get")
    public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
		//openId appId
		String orgId = request.getParameter("orgId");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
        //检测绑定
//		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String crmId = getNewCrmId(request);
   		logger.info("ContractController get method openId =>" + openId);
   		logger.info("ContractController get method publicId =>" + publicId);
   		logger.info("ContractController get method crmId =>" + crmId);
   		//判断是否已经绑定 crm 账户
   		if(StringUtils.isNotNullOrEmptyStr(crmId)){
   			request.setAttribute("openId", openId);
   			request.setAttribute("publicId", publicId);
   			request.setAttribute("orgId", orgId);
   		//获取用户头像数据
			Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			if(null != obj1){
				WxuserInfo wxuinfo = (WxuserInfo)obj1;
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
			//获取下拉列表信息和 责任人的用户列表信息 
			Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("statusDom", mpSta.get("status_dom"));
			request.setAttribute("priorityDom", mpSta.get("priority_dom"));
			request.setAttribute("crmId", crmId);
//			//获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers()){
//				if(null != currResp.getUsers().get(0).getUsername()){
//					request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
//				}
//				request.setAttribute("assignerid", currResp.getUsers().get(0).getUserid());
//			}
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setFlag(Constants.SEARCH_USER_LIST);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
   			return "shenyi/contract/add";
   		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存合同
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String save(Contract obj,HttpServletRequest request, HttpServletResponse response)throws Exception{
		String openId = obj.getOpenId();
		String publicId = obj.getPublicId();
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setContractstatus("draft");
			obj.setCrmId(getNewCrmId(request));
			obj.setAssignerid(getNewCrmId(request));
			CrmError crmErr = cRMService.getSugarService().getContract2CrmService().addContract(obj);
			String rowId = crmErr.getRowId();
			if (null != rowId && !"".equals(rowId)) {
				request.setAttribute("rowId", rowId);
				request.setAttribute("success", "ok");
				request.setAttribute("openId", obj.getOpenId());
				request.setAttribute("publicId", obj.getPublicId());
				return "redirect:/contract/list?viewtype=myview&openId="+obj.getOpenId()+"&publicId="+obj.getPublicId();
			} else {
				request.setAttribute("rowId", "");
				request.setAttribute("success", "fail");
				throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
	}
	
	/**
	 * 异步保存合同
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asysave")
	@ResponseBody
	public String asysave(Contract obj,HttpServletRequest request, HttpServletResponse response)throws Exception{
		String crmId = obj.getCrmId();
		String str = "";
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setContractstatus("draft");
			obj.setStartdate(DateTime.currentDate(DateTime.DateFormat1));
			crmErr= cRMService.getSugarService().getContract2CrmService().addContract(obj);
			str = JSONObject.fromObject(crmErr).toString();
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return str;
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
				String newCrmId = cRMService.getSugarService().getContract2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
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
	 * 修改合同
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update")
	public String update(Contract obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String rowId = request.getParameter("rowId");
		String crmId = obj.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
//			//获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				obj.setModifier(currResp.getUsers().get(0).getUsername());
//				obj.setModifydate(DateTime.currentDateTime(DateTime.DateTimeFormat1));
//			}
			obj.setRecordid(rowId);
			obj.setCrmId(crmId);
			String approvalstatus=obj.getApprovalstatus();//审批状态
			String str="";
			String url="/contract/detail?rowId="+rowId+"&orgId="+obj.getOrgId();
			CrmError crmErr = cRMService.getSugarService().getContract2CrmService().updateContract(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
				//发消微信息提醒
				if("approving".equals(approvalstatus)||("approved".equals(approvalstatus)&&StringUtils.isNotNullOrEmptyStr(obj.getApprovalid()))){//给审批人推送消息
					str="您有一个合同提交给您审批,";
					//推送审批消息  Commitid 审批人ID
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getApprovalid(),str,url);
				}
				if("reject".equals(approvalstatus)){//报销被驳回  给费用对象发送消息
					str="您有一个合同被驳回,";
					//推送审批消息 Assignid 费用对象ID
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(), str,url);
				}
			}else{
				throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//取消动作
		if(!"cancel".equals(obj.getType())){
			String commitid = obj.getCommitid();//审批人ID
			if(null != commitid && !"".equals(commitid)){
				//commitid不为空 则指定了审批人 
				return "redirect:/contract/list?viewtype=myview&openId="+ obj.getOpenId()+ "&publicId="+ obj.getPublicId();
			}else{
				//commitid为空  则表示为 “保存动作”
				return "redirect:/contract/modify?openId=" + openId + "&publicId="
				+ publicId + "&rowId=" + rowId+"&orgId="+obj.getOrgId();
			}
		}else{
			return "redirect:/contract/list?viewtype=myview&openId="+ obj.getOpenId()+ "&publicId="+ obj.getPublicId();
		}
	}
	
	/**
	 * 删除实体对象
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delContract")
	@ResponseBody
	public String delContract(Contract obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId=request.getParameter("openId");
		String publicId = request.getParameter("publicId");
	    String optype = request.getParameter("optype");
		String rowId = request.getParameter("rowid");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
	
		obj.setOpenId(openId);
		obj.setPublicId(publicId);
		obj.setCrmId(crmId);
		obj.setRecordid(rowId);
		obj.setOptype(optype);
		cRMService.getSugarService().getContract2CrmService().deleteContract(obj);
	
		return "success";
	}
	
}
