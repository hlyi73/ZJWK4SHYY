package com.takshine.wxcrm.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 客户 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/customer")
public class CustomerController {
	// 日志
	protected static Logger logger = Logger.getLogger(CustomerController.class
			.getName());
	

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询 客户 信息列表
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
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String firstchar = request.getParameter("firstchar");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		viewtype = (viewtype == null) ? "myview" : viewtype;
		firstchar = (firstchar == null) ? "" : firstchar;
		//error 对象
		CrmError crmErr = new CrmError();
		//判断crmId是否为空
		if (null != crmId && !"".equals(crmId)) {
			Customer sche = new Customer();
			sche.setCrmId(getNewCrmId(request));
			sche.setViewtype(viewtype);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setFirstchar(firstchar);
			sche.setOrgId(orgId);
			sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,
					"WX");
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CustomerAdd> cList = cResp.getCustomers();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
				crmErr.setErrorCode(cResp.getErrcode());
				crmErr.setErrorMsg(cResp.getErrmsg());
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
				String newCrmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
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
		String industry=request.getParameter("industry");
		String name = request.getParameter("name");
		String accttype =request.getParameter("accttype");
		String searchname =request.getParameter("searchname");
		//新增客户状态
		String state =request.getParameter("state");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String searchcon=searchname+"|"+"name:"+name+"|"+"accttype:"+accttype+"|"+"industry:"+industry+"|"+"assignerid:"+assignerid+"|"+"state:"+state;
		logger.info("CustomerController  savesearch method crmId =>" + crmId);
		logger.info("CustomerController  savesearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("customer_search_"+crmId, searchList.get(i), i);
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
		String industry=request.getParameter("industry");
		String name = request.getParameter("name");
		String accttype =request.getParameter("accttype");
		String state =request.getParameter("state");
		String viewtype = request.getParameter("viewtype");
		String crmId =UserUtil.getCurrUser(request).getCrmId();
		String searchcon=name+"|"+accttype+"|"+industry+"|"+assignerid+"|"+state+"|"+viewtype;
		logger.info("CustomerController  savesearch method crmId =>" + crmId);
		logger.info("CustomerController  savesearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//删除之前的缓存记录
			RedisCacheUtil.delete("customer_search_last"+crmId);
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("customer_search_last"+crmId, searchList.get(i), i);
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
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("CustomerController searchcache method crmId =>" + crmId);
		
		//cache
		List<String> sealist = new ArrayList<String>();
		//获取缓存的查询条件
		Set<String> rs = RedisCacheUtil.getSortedSetRange("customer_search_"+crmId, 0, 0);
		for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
			String searchcon = (String) iterator.next();
			sealist.add(searchcon);
			logger.info("CustomerController searchcache method searchcon=>" + searchcon);
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
		String crmId =UserUtil.getCurrUser(request).getCrmId();
		logger.info("CustomerController searchcache method crmId =>" + crmId);
		//cache
		List<String> sealist = new ArrayList<String>();
		//获取缓存的查询条件
		Set<String> rs = RedisCacheUtil.getSortedSetRange("customer_search_last"+crmId, 0, 0);
		for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
			String searchcon = (String) iterator.next();
			sealist.add(searchcon);
			logger.info("CustomerController searchcache method searchcon=>" + searchcon);
		}
		return JSONArray.fromObject(sealist).toString();
	}
	

	
	/**
	 * 查询 客户 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/clist")
	@ResponseBody
	public String clist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// search param
		String viewtype = request.getParameter("viewtype");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		viewtype = (viewtype == null) ? "myallview" : viewtype;
		String campaigns = request.getParameter("campaigns");
		//error 对象
		CrmError crmErr = new CrmError();
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		//判断crmId是否为空
		if (null != crmId && !"".equals(crmId)) {
			Customer sche = new Customer();
			sche.setCrmId(getNewCrmId(request));
			sche.setViewtype(viewtype);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setCampaigns(campaigns);
			sche.setOpenId(openId);
			// 查询返回结果
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,
					"WX");
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CustomerAdd> cList = cResp.getCustomers();
				crmErr.setRowCount(cList.size() + "");
			}else{
				crmErr.setErrorCode(cResp.getErrcode());
				crmErr.setErrorMsg(cResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}

	@RequestMapping("/alist")
	@ResponseBody
	public String alist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String str = "";
		// search param
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String name = request.getParameter("name");
		String accnttype = request.getParameter("accnttype");
		String industry = request.getParameter("industry");
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String assignerid = request.getParameter("assignerid");
		String orderString = request.getParameter("orderString");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		viewtype = (viewtype == null) ? "myview" : viewtype;
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//判断crmId是否为空
		if (null != crmId && !"".equals(crmId)) {
			Customer sche = new Customer();
			sche.setCrmId(crmId);
			sche.setViewtype(viewtype);
			sche.setCurrpage(currpage);
			sche.setPagecount(pagecount);
			sche.setName(name);
			sche.setIndustry(industry);
			sche.setAccnttype(accnttype);
			sche.setStartdate(startdate);
			sche.setEnddate(enddate);
			sche.setAssignerid(assignerid);
			sche.setOrderByString(orderString);
			sche.setOrgId(orgId);
			sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			sche.setOrgId(orgId);
			// 查询返回结果
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,
					"WEB");
			String errorCode = cResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CustomerAdd> cList = cResp.getCustomers();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
			    crmErr.setErrorCode(cResp.getErrcode());
			    crmErr.setErrorMsg(cResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 清空最后一次的查询条件
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
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("CustomerController dellastcache method crmId =>" + crmId);
		//获取缓存的查询条件
		if(null != crmId && !"".equals(crmId)){
			RedisCacheUtil.delete("customer_search_last"+crmId);
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
	public String delcache(HttpServletRequest request,HttpServletResponse response)throws Exception
	{
		String name = request.getParameter("name");
		return cRMService.getBusinessService().getAccountService().delSearchCondition(request, Constants.SEARCH_REDIS_KEY_PREFIX_CUSTOMER, name);
	}

	/**
	 * 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		logger.info("CustomerController detail method begin=>");
		ZJWKUtil.getRequestURL(request);//获取请求的url
		String rowId = request.getParameter("rowId");// rowId
		String flag = request.getParameter("flag");// 标志,用来区分合作伙伴还是竞争对手
		String assId = request.getParameter("assId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String orgId = request.getParameter("orgId");
		logger.info("CustomerController detail method rowId =>" + rowId);
		logger.info("CustomerController detail method orgId =>" + orgId);
		
		// 判断是否绑定对象
		List<String> result =  cRMService.getBusinessService().getAccountService().checkBind(request, orgId, rowId);
		String crmId = result.get(0);
		orgId = result.get(1);
		
		//如果crmId不为空，则调用后台判断是否拥有查看详情权限，即是否在团队中
		List<ShareAdd> shareAdds = cRMService.getBusinessService().getAccountService().getShareUsers(request, rowId, crmId, Constants.PARENT_TYPE_CUSTOMER);
		request.setAttribute("shareusers", shareAdds);

		//校验通过后，调用后台获取客户数据
		Customer cust = new Customer();
		cust.setRowId(rowId);
		cust.setCrmId(crmId);
		cust.setOrgId(orgId);
		CustomerAdd customer = cRMService.getBusinessService().getAccountService().getCustomerSingle(cust, flag);
		if(null != customer)
		{
			request.setAttribute("accName", customer.getName());
			request.setAttribute("sd", customer);
			request.setAttribute("oppList", customer.getOppties());
			request.setAttribute("taskList", customer.getTasks());
			request.setAttribute("conList", customer.getCons());
			request.setAttribute("auditList", customer.getAudits());//客户跟进数据
				
			int conCount = 0;
			int opptyCount = 0;
			int taskCount = 0;
			//增加计算数量add by hezhi
			if (!customer.getAudits().isEmpty())
			{
				List<OpptyAuditsAdd> auditList = customer.getAudits();

				for (int i=0;i<auditList.size();i++)
				{
					OpptyAuditsAdd audit = auditList.get(i);
					if (Constants.AUDIT_OP_TYPE_TASK.equals(audit.getOptype()))
					{
						taskCount++;
					}
					else if (Constants.AUDIT_OP_TYPE_CONTACT.equals(audit.getOptype()))
					{
						conCount++;
					}
				}
			}
			
			//同步查询客户关联的商机，不走跟进历史判断
			if (null != customer.getOppties())
			{
				opptyCount = customer.getOppties().size();
				request.setAttribute("opptyCount", opptyCount);
			}
			
			//同步查询客户关联任务，不走跟进历史
			if (null != customer.getTasks() && customer.getTasks().size()>0)
			{
				taskCount = customer.getTasks().size();
			}
			request.setAttribute("taskCount", taskCount);
			//缓存到界面
			request.setAttribute("conCount", conCount);

			//end by hezhi
			// 获取下拉列表信息和 责任人的用户列表信息
			Map<String, Map<String, String>> mp = cRMService.getBusinessService().getLOVService().getLovValues(request);
			request.setAttribute("accnttypedom", mp.get("account_type_dom"));
			request.setAttribute("industrydom", mp.get("industry_dom"));
			request.setAttribute("statusDom", mp.get("status_dom"));
			request.setAttribute("periodList", mp.get("task_period_list"));
			request.setAttribute("parentType", Constants.PARENT_TYPE_CUSTOMER);
		} 
		
		//消息处理
		Messages msg = new Messages();
		msg.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
		msg.setRelaId(rowId);
		cRMService.getDbService().getMessagesService().updateMessagesFlag(msg);
		
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("assId", assId);
		request.setAttribute("userName", UserUtil.getCurrUser(request).getNickname());
		return "customer/newdetail";
	}

	/**
	 * 查询客户列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/acclist")
	public String accntList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("CustomerController acclist method begin=>");
		//前台list页面查询条件
		String name = request.getParameter("name");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
				name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String accnttype = request.getParameter("accnttype");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String industry = request.getParameter("industry");
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String assignerid = request.getParameter("assignerid");
		String contribution = request.getParameter("contribution");
		String campaigns = request.getParameter("campaigns");
		String province = request.getParameter("province");
		String parentType=request.getParameter("parentType");
		String parentId=request.getParameter("parentId");
		String orderString=request.getParameter("orderString");
		String tagName = request.getParameter("tagName");
		String starflag = request.getParameter("starflag");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		viewtype = (viewtype == null) ? "myview" : viewtype;
		logger.info("ScheduleController list method viewtype =>" + viewtype);
		Map<String, Map<String, String>> mp = cRMService.getBusinessService().getLOVService().getLovValues(request);

		request.setAttribute("industrydom", mp.get(cRMService.getBusinessService().getLOVService().KEY_INDUSTRY));//获取行业下拉框的值
		request.setAttribute("accnttypedom", mp.get(cRMService.getBusinessService().getLOVService().KEY_ACCOUNT_TYPE));//获取客户类型下拉框的值
		
		Customer cust = new Customer();
		currpage = Integer.parseInt(currpage) + "";
		cust.setCurrpage(currpage);
		cust.setPagecount(pagecount);
		cust.setViewtype(viewtype);// 视图类型
		cust.setAssignerid(assignerid);//责任人ID
		cust.setIndustry(industry);//客户行业
		cust.setName(name);//客户名字
		cust.setAccnttype(accnttype);//客户类型
		cust.setCampaigns(campaigns);
		cust.setOrderByString(orderString);

		cust.setProvince(province);

		cust.setParentid(parentId);
		cust.setParenttype(parentType);
        cust.setTagName(tagName);
        cust.setStarflag(starflag);
		cust.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		cust.setOrgId(orgId);
		if (StringUtils.isNotNullOrEmptyStr(startdate)) {
			cust.setStartdate(startdate.replace("-", ""));
		} else if (StringUtils.isNotNullOrEmptyStr(enddate)) {
			cust.setEnddate(enddate.replace("-", ""));
		}
		
		//用户对象
		List<CustomerAdd> list = cRMService.getBusinessService().getAccountService().getCustomerListByCurrentUser(request, cust);
		request.setAttribute("accList", list);
		request.setAttribute("acctListSize", list.size());
		
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("industry", industry);
		request.setAttribute("startDate", startdate);
		request.setAttribute("endDate", enddate);
		request.setAttribute("assignerId", assignerid);
		request.setAttribute("name", name);
		request.setAttribute("accnttype", accnttype);
		request.setAttribute("campaigns", campaigns);
		request.setAttribute("contribution", contribution);
		request.setAttribute("parentId", parentId);
		request.setAttribute("parentType", parentType);
		request.setAttribute("orderString", orderString);
		request.setAttribute("orgId", orgId);
		request.setAttribute("zjdata_url", PropertiesUtil.getAppContext("zjdata.url"));

		return "customer/list";
	}
	
	/**
	 * 新增客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String get(CustomerAdd obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 如果从客户或业务机会明细下创建任务时，会带过来parentId和parentName;
		String orgId = request.getParameter("orgId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String module = request.getParameter("module");// 标志位,为了跳转到相关页面
		String opptyid = request.getParameter("opptyid");
		// 如果从客户或业务机会明细下创建任务时，会带过来parentId和parentName;
		String parentId = request.getParameter("parentId");
		String parentName = request.getParameter("parentName");
		String parentType = request.getParameter("parentType");
		String campaigns = request.getParameter("campaigns"); 
		request.setAttribute("parentId", parentId);
		request.setAttribute("parentName", parentName);
		request.setAttribute("parentType", parentType);
		request.setAttribute("campaigns", campaigns);
		request.setAttribute("module", module);
		request.setAttribute("opptyid", opptyid);
		request.setAttribute("orgId", orgId);
		request.setAttribute("parentId", parentId);
		request.setAttribute("parentName", parentName);
		request.setAttribute("parentType", parentType);
		request.setAttribute("campaigns", campaigns);
		// 检测绑定
		String crmId = getNewCrmId(request);
		logger.info("ContactController get method openId =>" + openId);
		logger.info("ContactController get method parentId =>" + parentId);
		logger.info("ContactController get method parentType =>" + parentType);
		// 判断是否已经绑定 crm 账户
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(crmId);
			uReq.setOpenId(openId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList",uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			
			//获取用户头像数据
			Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			if(null != obj1){
				WxuserInfo wxuinfo = (WxuserInfo)obj1;
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
			// crmId
			request.setAttribute("crmId", crmId);
			// 获取下拉列表信息和 责任人的用户列表信息
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
					.getLovList(crmId);
			request.setAttribute("industrydom", mp.get("industry_dom"));
			Map<String, String> map = new HashMap<String, String>();
			if("partner".equals(module)){
				Map<String, String> accMap = mp.get("account_type_dom");
				for(String key : accMap.keySet()){
					if("合作者".equals(accMap.get(key))){
						map.put(key,accMap.get(key));
					}
				}
				request.setAttribute("accnttypedom", map);
			}else if("rival".equals(module)){
				Map<String, String> accMap = mp.get("account_type_dom");
				for(String key : accMap.keySet()){
					if("竞争者".equals(accMap.get(key))){
						map.put(key,accMap.get(key));
					}
				}
				request.setAttribute("accnttypedom", map);
			}else{
				request.setAttribute("accnttypedom", mp.get("account_type_dom"));
			}
		}
		logger.info("CustomerController save method id =>" + obj.getRowid());
		//信恒资产项目临时处理 --- added by pengmd 20150505
		if(StringUtils.isNotNullOrEmptyStr(orgId) && "20150324_XINHENG".equals(orgId)){
			return "customer/newadd_xhzc";
		}
		// -- added end
		return "customer/newadd";
	}

	/**
	 * 增加客户
	 * 
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("CustomerController save method id =>" + obj.getId());
		String module = request.getParameter("module");
		String opptyid = request.getParameter("opptyid");
		request.setAttribute("command", obj);
		obj.setCrmId(getNewCrmId(request));
		if(StringUtils.isNotNullOrEmptyStr(obj.getCity())){
			obj.setStreet(obj.getCity() + (null == obj.getStreet() ? "" : obj.getStreet()) );
		}
		if(StringUtils.isNotNullOrEmptyStr(obj.getProvince())){
			obj.setStreet(obj.getProvince() + (null == obj.getStreet() ? "" : obj.getStreet()) );
		}
		CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().addCustomer(obj);
		String rowId = crmErr.getRowId();
		if (null != rowId && !"".equals(rowId)) {
			request.setAttribute("rowId", rowId);
			request.setAttribute("orgId", obj.getOrgId());
			request.setAttribute("success", "ok");
			request.setAttribute("customerid", rowId);
			request.setAttribute("customername", obj.getName());
			//request.setAttribute("openId", obj.getOpenId());
			//request.setAttribute("publicId", obj.getPublicId());
			//得到当前用户
			/*String crmId = UserUtil.getCurrUser(request).getCrmId();
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			currReq.setOpenId(obj.getOpenId());
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			String assignername = "";
			if (null != currResp.getUsers()
					&& null != currResp.getUsers().get(0).getUsername()) {
				assignername= currResp.getUsers().get(0).getUsername();
			}
			//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
			if(null != obj.getAssignerid() && !obj.getCrmId().equals(obj.getAssignerid())){
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(),assignername+" 分配了一个客户【"+obj.getName()+"】给您", "customer/detail?rowId="+rowId+"&orgId="+obj.getOrgId());
			}
			//
*/			
			if (StringUtils.isNotNullOrEmptyStr(module)) {
				return "redirect:/" + module + "/get?opptyid="
						+ opptyid + "&customerid=" + rowId + "&customername="
						+ URLEncoder.encode(obj.getName(),"UTF-8");
			}else{
				return "redirect:/customer/detail?rowId="+rowId+"&orgId="+obj.getOrgId();
			}
		} else {
			request.setAttribute("rowId", "");
			request.setAttribute("success", "fail");
			throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
		}
	}
	
	
	/**
	 * 异步保存客户
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/asynsave", method = RequestMethod.POST)
	@ResponseBody
	public String syncSave(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String crmId = getNewCrmId(request);
		
		obj.setCrmId(crmId);
		obj.setAssignerid(crmId);
		CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().addCustomer(obj);
		return JSONObject.fromObject(crmErr).toString();
	}

	/**
	 * 修改
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String rowId = request.getParameter("rowId");
		String flag = request.getParameter("flag");// 标志,用来区分合作伙伴还是竞争对手
		logger.info("CustomerController modify method openId =>" + openId);
		logger.info("CustomerController modify method rowId =>" + rowId);
		String orgId = request.getParameter("orgId");
		// 绑定对象
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
			RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		}else{
			crmId = (String)obj;
		}
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Customer cust = new Customer();
			cust.setRowId(rowId);
			cust.setCrmId(crmId);
			cust.setOrgId(orgId);
			CustomerResp sResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerSingle(cust, flag);
			List<CustomerAdd> list = sResp.getCustomers();
			// 放到页面上
			if (null != list && list.size() > 0) {
				request.setAttribute("sd", list.get(0));
				request.setAttribute("oppName", list.get(0).getName());

			} else {
				request.setAttribute("sd", new CustomerAdd());
			}
			// 获取下拉列表信息和 责任人的用户列表信息
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
					.getLovList(crmId);
			request.setAttribute("industrydom", mp.get("industry_dom"));
			request.setAttribute("accnttypedom", mp.get("account_type_dom"));
			//市场活动
			Campaigns camp = new Campaigns();
			camp.setCurrpage("0");
			camp.setPagecount("1000");
			camp.setOpenId(openId);
			camp.setType("owner");
//		    CampaignsResp cResp = campaigns2ZJmktService.getCampaignsList(camp, "WEB"); 
//			request.setAttribute("campaignsList", cResp.getCams());
			
			request.setAttribute("sourcedom", mp.get("account_source_list"));
			request.setAttribute("naturedom", mp.get("nature_list"));
			
			
			//获取已有标签信息
			Tag tag = new Tag();
			tag.setModelId(rowId);
			tag.setModelType("product_tag");//主营产品
			List<Tag> productList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
			request.setAttribute("productList", productList);
			tag.setModelType("customer_tag");//客户群体
			List<Tag> customerList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
			request.setAttribute("customerList", customerList);
			tag.setModelType("salesregions_tag");//销售区域
			List<Tag> salesregionsList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
			request.setAttribute("salesregionsList", salesregionsList);
			tag.setModelType("industry_tag");//行业
			List<Tag> industryList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
			request.setAttribute("industryList", industryList);
			tag.setModelType("brand_tag");//主营品牌
			List<Tag> brandList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
			request.setAttribute("brandList", brandList);
		}
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("crmId", crmId);
		//add by zhihe
		request.setAttribute("source", request.getParameter("source"));

		//信恒资产项目临时处理 --- added by pengmd 20150505
		if(StringUtils.isNotNullOrEmptyStr(orgId) && "20150324_XINHENG".equals(orgId)){
			return "customer/modify_xhzc";
		}
		// -- added end
		return "customer/modify";
	}

	
	/**
	 * 修改客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update")
	public String update(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String crmId = request.getParameter("crmId");
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
			obj.setCrmId(crmId);
			obj.setOptype("upd");
			CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().updateCustomer(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/customer/modify?rowId=" + rowId+"&orgId="+obj.getOrgId();
	}
	
	/**
	 * 删除客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delCustomer")
	@ResponseBody
	public String delete(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
	    String optype = request.getParameter("optype");
		String rowId = request.getParameter("rowid");
		obj.setOpenId(openId);
		obj.setPublicId(publicId);
		obj.setRowId(rowId);
		obj.setOptype(optype);
		CrmError crmError = cRMService.getSugarService().getCustomer2SugarService().deleteCustomer(obj);
		return JSONObject.fromObject(crmError).toString();
	}


	/**
	 * 分配客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/allocation")
	public String allocation(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
			obj.setCrmId(crmId);
			obj.setOptype("allot");
			CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().updateCustomer(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignerid() && !obj.getCrmId().equals(obj.getAssignerid())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(),UserUtil.getCurrUser(request).getName()+" 分配了一个客户【"+obj.getName()+"】给您", "customer/detail?rowId="+rowId+"&orgId="+obj.getOrgId());
				}
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/customer/detail?rowId=" + rowId;
	}

	/**
	 * 导出客户列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/export")
	@ResponseBody
	public String exportCustomerList(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(partyId))
		{
			//查找用户是否有验证的邮箱
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(partyId);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(null == obj || !StringUtils.isNotNullOrEmptyStr(((BusinessCard)obj).getEmail()))
			{
				//维护名片
				return "noemail";
			}
			
			if(!"1".equals(((BusinessCard)obj).getIsEmailValidation()))
			{
				//邮箱没有验证通过
				return "invalidemail";
			}
			
			String email = ((BusinessCard)obj).getEmail();
			
			//获取筛选的条件，如果有则设置成查询条件
			String viewtype = request.getParameter("viewtype");
			String name = request.getParameter("name");
			String accnttype = request.getParameter("accnttype");
			String state = request.getParameter("state");
			String assignerid = request.getParameter("assignerid");
			
			//获取我的客户
			Customer sche = new Customer();
			sche.setCrmId(crmId);
			if (StringUtils.isNotNullOrEmptyStr(viewtype))
			{
				sche.setViewtype(viewtype);
			}
			else
			{
				sche.setViewtype(Constants.SEARCH_VIEW_TYPE_MYVIEW);
			}
			if (StringUtils.isNotNullOrEmptyStr(name))
			{
				sche.setName(name);
			}
			if (StringUtils.isNotNullOrEmptyStr(accnttype))
			{
				sche.setAccnttype(accnttype);
			}
			if (StringUtils.isNotNullOrEmptyStr(state))
			{
				sche.setState(state);
			}
			if (StringUtils.isNotNullOrEmptyStr(assignerid))
			{
				sche.setAssignerid(assignerid);
			}
			sche.setCurrpage("1");
			sche.setPagecount("999");
			sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,"WX");
			List<CustomerAdd> custList = new ArrayList<CustomerAdd>();
			if (null != cResp && ErrCode.ERR_CODE_0.equals(cResp.getErrcode()))
			{
				custList = cResp.getCustomers();
			}
			
			//生成CSV文件
			File f = reportConlistToCSV(custList);
			//发送邮件
			sendEmail(email, f,UserUtil.getCurrUser(request).getNickname(),custList.size());
			
			return "success";
		}
		else
		{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
		
		/**
		 * 创建批量导出客户的 excel 报告
		 * @param list
		 * @param assigner
		 * @param approvename
		 * @param email
		 * @param startDate
		 * @param endDate
		 * @return
		 */
		private File reportConlistToCSV(List<CustomerAdd> list)
		{
			try 
			{
				File f = new File("test.xls");
				if(!f.exists())
				{
					f.createNewFile();
				}
				FileOutputStream os = new FileOutputStream(f);
				 //创建工作薄
				WritableWorkbook workbook = Workbook.createWorkbook(os);
				//创建新的一页
				WritableSheet sheet = workbook.createSheet("客户",0);
				sheet.setColumnView(0, 20);
				sheet.setColumnView(1, 20);
				sheet.setColumnView(2, 20);
				sheet.setColumnView(3, 20);
				
				//合并单元格
				sheet.mergeCells(0, 0, 5, 0);
				sheet.setRowView(0, 750);
				//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
				Label rtile = new Label(0, 0, "我的指尖微客客户");
				rtile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,12));
				sheet.addCell(rtile);
				
				Label exportdatetxt = new Label(0, 1, "导出时间：");
				exportdatetxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(exportdatetxt);
				
				Label exportdate = new Label(1, 1, DateTime.currentDate(DateTime.DateFormat1));
				exportdate.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(exportdate);
				
				Label contactnumtxt = new Label(3, 1, "总数：");
				contactnumtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(contactnumtxt);
				
				Label contactnum = new Label(4, 1, list.size()+"");
				contactnum.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(contactnum);
				
				//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
				Label nametxt = new Label(0, 2, "客户名称");
				nametxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(nametxt);
				
				Label mobiletxt = new Label(1, 2, "电话");
				mobiletxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(mobiletxt);
				
				Label addrtxt = new Label(2,2,"地址");
				addrtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(addrtxt);
				
				Label industytxt = new Label(3,2,"行业");
				industytxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(industytxt);
				
				Label remarktxt = new Label(4,2,"备注");
				remarktxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(remarktxt);
				sheet.setRowView(1, 500);
				
				CustomerAdd ca = null;
				for(int i=0;i<list.size();i++)
				{
					ca = list.get(i);
					
					Label name = new Label(0, i+3,ca.getName());
					name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
					sheet.addCell(name);
					
					Label mobile = new Label(1, i+3,ca.getPhoneoffice());
					mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
					sheet.addCell(mobile);
					
					Label addr = new Label(2,i+3,ca.getStreet() );
					addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
					sheet.addCell(addr);
					
					Label industy = new Label(3,i+3,ca.getIndustry());
					industy.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
					sheet.addCell(industy);
					
					Label remark = new Label(4,i+3,ca.getDesc());
					remark.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
					sheet.addCell(remark);

					sheet.setRowView(1, 500);
				}
				
				//把创建的内容写入到输出流中，并关闭输出流
				workbook.write();
				workbook.close();
				os.close();
				
				//返回数据
		        return f;
		        
			} catch (Exception e) 
			{
				return null;
			}
		}
		
		/**
		 * 发送邮件
		 * @param startDate
		 * @param email
		 * @param assigner
		 * @param approvename
		 * @param wdays
		 * @param filePath
		 */
		private void sendEmail(String email,File f,String username,int conSize)
		{
			SenderInfor senderInfor = new SenderInfor();
	        StringBuffer content = new StringBuffer();  
	        content.append("亲爱的").append(username).append("，您好！").append("<br/>").append("您本次共导出").append(conSize).append("个客户，感谢您的使用！");
	        senderInfor.setToEmails(email);  
	        senderInfor.setSubject("我的指尖微客客户");  
	        senderInfor.setContent(content.toString());
	        Map<String, String> m = new HashMap<String, String>();
	        m.put("客户_("+ DateTime.currentDateTime(DateTime.DateFormat1) + ").xls", f.getAbsolutePath());
	        senderInfor.setAttachments(m);
	        MailUtils.sendEmail(senderInfor);
	        
	        f.delete();
		}
		
		/**
		 * 设置格式
		 * @return
		 */
		private WritableCellFormat getCellFormat(Colour color, Alignment posi ,Integer size)
		{
			try 
			{
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
			}
			catch (WriteException e) 
			{
				logger.info(e.getMessage());
				return null;
			} 
		}
	/**
	 * 推荐客户
	 * 
	 * @param request
	 * @param response
	 * @return
	 *//*
	@RequestMapping("/recommend")
	public String recommend(Customer obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if (null != crmId && !"".equals(crmId)) {
			obj.setCrmId(crmId);
			obj.setOptype("allot");
			CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().updateCustomer(obj);
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
				if(null != obj.getAssignerid() && !obj.getCrmId().equals(obj.getAssignerid())){
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(),UserUtil.getCurrUser(request).getName()+" 分配了一个客户【"+obj.getName()+"】给您", "customer/detail?rowId="+rowId+"&orgId="+obj.getOrgId());
				}
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/customer/detail?rowId=" + rowId;
	}*/
}
