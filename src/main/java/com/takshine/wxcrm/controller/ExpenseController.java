package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Expense;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.message.sugar.ExpenseResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 生意 -> 费用报销 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/expense")
public class ExpenseController {
	// 日志
	protected static Logger logger = Logger.getLogger(ExpenseController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询 用户和手机关联关系 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("CustomerController acclist method begin=>");
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		String openId = wxuser.getOpenId();
		//验证用户是否有权限访问
		List<Organization> orgList = cRMService.getDbService().getWorkPlanService().getCrmIdAndOrgIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), Constants.DEFAULT_ORGANIZATION);
		//如果没有绑定企业，则返回错误
		if(null == orgList || orgList.size() == 0){
			throw new Exception(ErrCode.ERR_CODE_AUTH_INVALID);
		}
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String expensedate = request.getParameter("expensedate");
		String approval = request.getParameter("approval");
		String depart = request.getParameter("depart");
		String viewtypesel = request.getParameter("viewtypesel");
		String subtype = request.getParameter("subtype");
		String type = request.getParameter("type");
		String startDate =  request.getParameter("startDate");
		String endDate =  request.getParameter("endDate");
		String orderString = request.getParameter("orderString");
		
		//查询的参数
		String exAssigner = request.getParameter("exAssigner");//责任人ID,以","号分隔
		String approval1 = request.getParameter("approval1");
		String viewtype1 = request.getParameter("viewtype1");
		String viewtypesel1 = request.getParameter("viewtypesel1");
		String orgId = request.getParameter("orgId");
		
		if(StringUtils.isNotNullOrEmptyStr(approval1)){
			approval = approval1;
		}
		if(StringUtils.isNotNullOrEmptyStr(viewtypesel1)){
			viewtypesel = viewtypesel1;
		}
		if(StringUtils.isNotNullOrEmptyStr(viewtype1)){
			viewtype = viewtype1;
		}
		
		//从市场活动进来
	    String parentId = request.getParameter("parentId");
	    String parentType = request.getParameter("parentType");
	    String parentName = request.getParameter("parentName");
	    if(StringUtils.isNotNullOrEmptyStr(parentName)&&!StringUtils.regZh(parentName)){
	    	parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
	    }
	    request.setAttribute("parentId", parentId);
	    request.setAttribute("parentType", parentType);
	    request.setAttribute("parentName", parentName);
		
		//处理月份
		String str = DateTime.currentDate(DateTime.DateFormat4);
		String[] strs = str.split("-");
		if(StringUtils.isNotNullOrEmptyStr(expensedate)){
			if("current".equals(expensedate)){
				expensedate = strs[0]+strs[1];		
			}else if("before".equals(expensedate)){
				int currentMonth = Integer.parseInt(strs[1]);
				if(currentMonth==1){
					expensedate = Integer.parseInt(strs[0])-1+"12";
				}else{
					expensedate = strs[0]+"0"+(currentMonth-1)+"";	
				}
			}
		}
		
		if(null != depart){
			depart = new String(depart.getBytes("ISO-8859-1"),"UTF-8");
		}
		String subtypename = request.getParameter("subtypename");
		if(null != subtypename){
			subtypename = new String(subtypename.getBytes("ISO-8859-1"),"UTF-8");
		}
	    viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		logger.info("ExpenseController list method openId =>" + openId);
		logger.info("ExpenseController list method viewtype =>" + viewtype);
		logger.info("ExpenseController list method currpage =>" + currpage);
		logger.info("ExpenseController list method pagecount =>" + pagecount);
		logger.info("ExpenseController list method expensedate =>" + expensedate);
		logger.info("ExpenseController list method depart =>" + depart);
		logger.info("ExpenseController list method approval =>" + approval);
		logger.info("ExpenseController list method subtype =>" + subtype);
		logger.info("ExpenseController list method type =>" + type);
		
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String crmId = wxuser.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Expense exp = new Expense();
			exp.setCrmId(crmId);
			exp.setViewtype(viewtype);//视图类型
			exp.setPagecount(pagecount);
			exp.setCurrpage(currpage);
			exp.setExpensedate(expensedate);
			exp.setDepart(depart);
			exp.setApproval(approval);
			exp.setExpensesubtype(subtype);
			exp.setAssignid(exAssigner);
			exp.setExpensetype(type);
			exp.setExpensesubtypename(subtypename);
			exp.setParentid(parentId);
			exp.setParenttype(parentType);
			exp.setOpenId(openId);
			exp.setOrderByString(orderString);
			exp.setOrgId(orgId);
			if(null != startDate && !"".equals(startDate)){
				exp.setStartDate(startDate.replaceAll("-", ""));
			}
			if(null != endDate && !"".equals(endDate)){
				exp.setEndDate(endDate.replaceAll("-", ""));
			}
			
			ExpenseResp sResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(exp,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("expenseList", sResp.getExpenses());
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		//用户对象
		UserReq uReq = new UserReq();
		uReq.setCrmaccount(crmId);
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setFlag(Constants.SEARCH_USER_LIST);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		request.setAttribute("usersList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
		
		//requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("viewtype", viewtype);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("expensedate", expensedate);
		request.setAttribute("depart", depart);
		request.setAttribute("approval", approval);
		request.setAttribute("viewtypesel", viewtypesel);
		request.setAttribute("subtype", subtype);
		request.setAttribute("exAssigner", exAssigner);
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("orderString", orderString);
		request.setAttribute("orgId", orgId);
		
		//search 初始化里面的值
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(wxuser.getCrmId());
		UserReq userReq  = new UserReq();
		userReq.setCrmaccount(crmId);
		userReq.setCurrpage(null);
		userReq.setPagecount(null);
		UsersResp userResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(userReq);
		List<UserAdd> ulist = userResp.getUsers();
		request.setAttribute("expenseSubTypeList", mp.get("expense_sub_type_list"));//费用子类
		request.setAttribute("userList", ulist);
		
		return "shenyi/expense/list";
	}
	
	/**
	 * 加载市场活动下的成本数量
	 * @return
	 */
	@RequestMapping("/alist")
	@ResponseBody
	public String alist( HttpServletRequest request,HttpServletResponse response) throws Exception{
		logger.info("ScheduleController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentid = request.getParameter("parentId");
		String parenttype = request.getParameter("parentType");
		String viewtype=request.getParameter("viewtype");
		String crmId = cRMService.getSugarService().getExpense2CrmService().getCrmId(openId, publicId);
		logger.info("ScheduleController alist method crmId =>" + crmId);
		logger.info("ScheduleController alist method parentid =>" + parentid);
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			Expense expense = new Expense();
			expense.setCrmId(crmId);
			expense.setParentid(parentid);
			expense.setParenttype(parenttype);
			expense.setViewtype(viewtype);
			ExpenseResp quoteResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(expense, "WX");
			List<ExpenseAdd> list = quoteResp.getExpenses();
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
	
	@RequestMapping("/expenselist")
	@ResponseBody
	public String expenselist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("CustomerController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String viewtype = request.getParameter("viewtype");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String expensedate = request.getParameter("expensedate");
		String depart = request.getParameter("depart");
		String approval = request.getParameter("approval");
		String subtype = request.getParameter("type");
		String orderString = request.getParameter("orderString");
		
		//查询的参数
		String exAssigner = request.getParameter("exAssigner");//责任人ID,以","号分隔
		
		//处理月份
		String string = DateTime.currentDate(DateTime.DateFormat4);
		String[] strs = string.split("-");
		if(StringUtils.isNotNullOrEmptyStr(expensedate)){
			if("current".equals(expensedate)){
				expensedate = strs[0]+strs[1];		
			}else if("before".equals(expensedate)){
				int currentMonth = Integer.parseInt(strs[1]);
				if(currentMonth==1){
					expensedate = Integer.parseInt(strs[0])-1+"12";
				}
			}
		}
		
		String subtypename = request.getParameter("subtypename");
		if(null != subtypename){
			subtypename = new String(subtypename.getBytes("ISO-8859-1"),"UTF-8");
		}
		
		if(null != depart){
			depart = new String(depart.getBytes("ISO-8859-1"),"UTF-8");
		}
	           viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		logger.info("ExpenseController list method openId =>" + openId);
		logger.info("ExpenseController list method publicId =>" + publicId);
		logger.info("ExpenseController list method viewtype =>" + viewtype);
		logger.info("ExpenseController list method currpage =>" + currpage);
		logger.info("ExpenseController list method pagecount =>" + pagecount);
		logger.info("ExpenseController list method expensedate =>" + expensedate);
		logger.info("ExpenseController list method depart =>" + depart);
		logger.info("ExpenseController list method approval =>" + approval);
		logger.info("ExpenseController list method subtype =>" + subtype);
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		//绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Expense exp = new Expense();
			exp.setCrmId(crmId);
			exp.setViewtype(viewtype);//视图类型
			exp.setPagecount(pagecount);
			exp.setCurrpage(currpage);
			exp.setExpensedate(expensedate);
			exp.setDepart(depart);
			exp.setApproval(approval);
			exp.setExpensesubtype(subtype);
			exp.setAssignid(exAssigner);
			exp.setOrderByString(orderString);
			//查询报销列表
			ExpenseResp sResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(exp,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ExpenseAdd> list = sResp.getExpenses();
				str = JSONArray.fromObject(list).toString();
				logger.info("str:-> is =" + str);
				return str;
			}else{
			    crmErr.setErrorCode(sResp.getErrcode());
			    crmErr.setErrorMsg(sResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return str = JSONObject.fromObject(crmErr).toString();
	}

	/**
     * 日程创建
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/get")
    public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
		//openId appId
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		//从市场活动进来
	    String parentId = request.getParameter("parentId");
	    String parentType = request.getParameter("parentType");
	    String parentName = request.getParameter("parentName");
	    String orgId = request.getParameter("orgId");
	    if(StringUtils.isNotNullOrEmptyStr(parentName)&&!StringUtils.regZh(parentName)){
	    	parentName = new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
	    }
	    request.setAttribute("parentId", parentId);
	    request.setAttribute("parentType", parentType);
	    request.setAttribute("parentName", parentName);
        
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(wxuser.getCrmId());
		request.setAttribute("expenseSubTypeList",mp.get("expense_sub_type_list"));// 子类别
		request.setAttribute("expenseSubTypeWXList",mp.get("expense_sub_type_wx_list"));// 子类别
		request.setAttribute("expenseTypeList", mp.get("expense_type_list"));// 大类
		request.setAttribute("expenseStatusList", mp.get("expense_status_list"));// 状态
		request.setAttribute("expenseDepartList", mp.get("expense_depart_list"));// 部门
		// crmId
		request.setAttribute("crmId", wxuser.getCrmId());
		// 获取用户头像数据
		request.setAttribute("headimgurl", wxuser.getHeadimgurl());
		// 获取下拉列表信息和 责任人的用户列表信息
		Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(wxuser.getCrmId());
		request.setAttribute("statusDom", mpSta.get("status_dom"));
		request.setAttribute("priorityDom", mpSta.get("priority_dom"));
		request.setAttribute("periodList", mp.get("task_period_list"));
		// 审批用户对象
		UserReq uReq = new UserReq();
		uReq.setCrmaccount(wxuser.getCrmId());
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																// 我团队的用户
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setFlag(Constants.SEARCH_USER_LIST);
		uReq.setOrgId(orgId);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		request.setAttribute("userList",uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());

		request.setAttribute("assigner", wxuser.getName());

		// 客户 和 业务机会 列表
		// 查询客户信息
//		Customer sc = new Customer();
//		sc.setCrmId(wxuser.getCrmId());
//		sc.setViewtype("myallview");
//		sc.setCurrpage("1");
//		sc.setPagecount("1000");
//		sc.setOpenId(wxuser.getOpenId());
//		sc.setOrgId(orgId);
//		CustomerResp cResp = customer2SugarService.getCustomerList(sc, "WEB");
//		List<CustomerAdd> cList = cResp.getCustomers();
//		request.setAttribute("cList", cList);
//		// 查询业务机会信息
//		Opportunity opp = new Opportunity();
//		opp.setCrmId(wxuser.getCrmId());
//		opp.setViewtype("myallview");
//		opp.setCurrpage("1");
//		opp.setPagecount("1000");
//		opp.setOrgId(orgId);
//		opp.setOpenId(wxuser.getOpenId());
//		OpptyResp oppResp = oppty2SugarService.getOpportunityList(opp, "WEB");
//		List<OpptyAdd> oppList = oppResp.getOpptys();
//		request.setAttribute("oppList", oppList);
		request.setAttribute("orgId", orgId);
		return "shenyi/expense/add";
	}
	
	/**
	 * 已核销的报销原始记录详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/original")
	public String original(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ExpenseController original method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String flag = request.getParameter("original");
		logger.info("ExpenseController original method rowId =>" + rowId);
		logger.info("ExpenseController original method openId =>" + openId);
		logger.info("ExpenseController original method publicId =>" + publicId);
		logger.info("ExpenseController original method flag =>" + flag);
		//绑定对象
		String crmId = cRMService.getSugarService().getExpense2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Expense expense = new Expense();
			expense.setCrmId(crmId);
			expense.setRowId(rowId);
			expense.setOriginal(flag);
			ExpenseResp expResp = cRMService.getSugarService().getExpense2CrmService().getOriginalExpense(expense);
			String errorCode = expResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ExpenseAdd> list = expResp.getExpenses();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("expenseName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + expResp.getErrcode() + "，错误描述：" + expResp.getErrmsg());
			}
			//财务核销 权限控制
			request.setAttribute("EXPENSE_DETAIL_VERIFI", 
					cRMService.getSugarService().getExpense2CrmService().checkFunc(crmId, "WXCRM_MEMU_EXPENSE_DETAIL_VERIFI"));

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
		return "shenyi/expense/original";
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
		logger.info("ExpenseController detail method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String orgId = request.getParameter("orgId");//  rowId
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		logger.info("ExpenseController detail method rowId =>" + rowId);
		//绑定对象
		String crmId = getNewCrmId(request);
		//获取绑定的账户 在sugar系统的id
		Expense exp = new Expense();
		exp.setRowId(rowId);
		exp.setOrgId(orgId);
		exp.setCrmId(crmId);
		ExpenseResp expResp = cRMService.getSugarService().getExpense2CrmService().getExpenseSingle(exp, crmId);
		String errorCode = expResp.getErrcode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			List<ExpenseAdd> list = expResp.getExpenses();
			//放到页面上
			if(null != list && list.size() > 0){
				request.setAttribute("expenseName", list.get(0).getName());
				//审批历史
				request.setAttribute("approList", list.get(0).getApproves());
				ExpenseAdd expenseAdd = list.get(0);
				if("Activity".equals(expenseAdd.getParenttype())){
					CampaignsResp sResp = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaignsSingle(expenseAdd.getParentid(),crmId);
					List<CampaignsAdd> camlist = sResp.getCams();
					// 放到页面上
					if (null != camlist && camlist.size() > 0) {
						expenseAdd.setParentname(camlist.get(0).getName());
					}
				}
				request.setAttribute("sd", expenseAdd);
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + expResp.getErrcode() + "，错误描述：" + expResp.getErrmsg());
		}
		//获取当前操作用户
		request.setAttribute("assigner", wxuser.getName());
		
		//用户对象
		UserReq uReq = new UserReq();
		uReq.setCrmaccount(crmId);
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setFlag(Constants.SEARCH_USER_LIST);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
		
		//获取LOV下拉列表信息
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("expenseSubTypeList", mp.get("expense_sub_type_list"));//子类别
		request.setAttribute("expenseTypeList", mp.get("expense_type_list"));//子类别
		request.setAttribute("parentDeaprtList", mp.get("parent_depart_list"));//一级部门
		request.setAttribute("departList", mp.get("expense_depart_list"));//二级部门
		
		//财务核销 权限控制
		request.setAttribute("EXPENSE_DETAIL_VERIFI", 
				cRMService.getSugarService().getExpense2CrmService().checkFunc(crmId, "WXCRM_MEMU_EXPENSE_DETAIL_VERIFI"));
		
		//requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("orgId", orgId);
		//分享控制按钮
		request.setAttribute("shareBtnContol", request.getParameter("shareBtnContol"));
		
		return "shenyi/expense/detail";
	}

	/**
	 * 新增 用户和手机关联关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(Expense obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ExpenseController save method id =>" + obj.getId());

		// request info
		request.setAttribute("command", obj);
		
		/*String approvaemail = obj.getApprovaemail();//审批人邮箱
		String approvalname = obj.getApprovalname();//审批人名字*/
		String approvalstatus=obj.getApprovalstatus();//审批状态
		
		//toOthers 审批时候提交给其他人审批 需要添加一条新的数据记录
		String toOthers = request.getParameter("toOthers");
		if(null != toOthers && !"".equals(toOthers) && "yes".equals(toOthers)){
			obj.setType(Constants.ACTION_CHANGEAPPROVAL);
			obj.setRowId("");//清空rowId 创建新的几率
		}
		
		String crmId = getNewCrmId(request);
		obj.setCrmId(crmId);
		//rowId
		CrmError crmErr = cRMService.getSugarService().getExpense2CrmService().addExpense(obj);
		String rowId = crmErr.getRowId();
		if(null != rowId && !"".equals(rowId)){
			request.setAttribute("rowId", rowId);
			request.setAttribute("success", "ok");
			//发消微信息提醒
			if("approving".equals(approvalstatus)||"approved".equals(approvalstatus)){//给审批人推送消息
				//推送审批消息  Commitid 审批人ID
				cRMService.getWxService().getWxRespMsgService().respExpCustMsg(obj.getApprovalid(), rowId, "approving",obj.getOrgId());
			}
			if("reject".equals(approvalstatus)){//报销被驳回  给费用对象发送消息
				//推送审批消息 Assignid 费用对象ID
				cRMService.getWxService().getWxRespMsgService().respExpCustMsg(obj.getAssignid(), rowId, "reject",obj.getOrgId());
			}
		}else{
			request.setAttribute("rowId", "");
			request.setAttribute("success", "fail");
		}
		
		//取消动作
		if(!"cancel".equals(obj.getType())){
			
			String commitid = obj.getCommitid();//审批人ID
			if(null != commitid && !"".equals(commitid)){
				//commitid不为空 则指定了审批人 
				return "redirect:/expense/list?viewtype=approvalview&viewtypesel=approvalview&approval=&rowId="+ rowId;
			}else{
				//commitid为空  则表示为 “保存动作”
				return "redirect:/expense/detail?rowId="+ rowId +"&orgId="+ obj.getOrgId();
			}
			
		}else{
			
			return "redirect:/expense/list";
		}
	}
	
	/**
	 * 批量新增 用户和手机关联关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/batchSave", method = RequestMethod.POST)
	public String batchSave(Expense obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ExpenseController save method id =>" + obj.getId());
		String retRowId = "";
		String fstRowId = "";
		// request info
		request.setAttribute("command", obj);
		String crmId = getNewCrmId(request);
		String expTypes = obj.getExpensetype();
		String subTypes = obj.getExpensesubtype();
		String amts = obj.getExpenseamount();
        //String approvaemail = obj.getApprovaemail();//审批人邮箱
		String approvalname = obj.getApprovalname();//审批人名字
		String [] expTypesArr = expTypes.split(",");
		String [] subTypeArr = subTypes.split(",");
		String [] amtsArr = amts.split(",");
		for (int i = 0; i < subTypeArr.length; i++) {
			String ty = expTypesArr[i];
			String subT = subTypeArr[i];
			String amt = amtsArr[i];
			Expense s = new Expense();
			BeanUtils.copyProperties(s, obj);
			s.setExpensetype(ty);
			s.setExpensesubtype(subT);
			s.setExpenseamount(amt);
			s.setCrmId(crmId);
			//rowId
			CrmError crmErr = cRMService.getSugarService().getExpense2CrmService().addExpense(s);
			String r = crmErr.getRowId();
			if(StringUtils.isNotNullOrEmptyStr(r)){
				if(i == 0 ){
					fstRowId = r;
				} 
				retRowId += r + ",";
			}
		}
		String success = "";
		if(null != retRowId && !"".equals(retRowId)){
			request.setAttribute("rowId", retRowId);
			request.setAttribute("success", "batchSucc");
			success = "batchSucc";
			if(StringUtils.isNotNullOrEmptyStr(approvalname)){
                /*SenderInfor senderInfor = new SenderInfor();
				String content = Constants.MAILAPPROVAL.replace("@@assigner@@", approvalname).replaceAll("@@count@@", amtsArr.length+"").replaceAll("@@count@@","1").replaceAll("@@content@@", "详情请登陆微信CRM或内部CRM系统！");
				senderInfor.setContent(content);
				senderInfor.setSubject("审批通知");
				senderInfor.setToEmails(approvaemail);
				senderInfor.setSignature(Constants.SIGNATURE);
				MailUtils.sendEmail(senderInfor);*/
				//推送审批消息
				cRMService.getWxService().getWxRespMsgService().respExpCustMsg(obj.getApprovalid(), fstRowId,"approving",obj.getOrgId());
			}
		}else{
			request.setAttribute("rowId", "");
			request.setAttribute("success", "batchFail");
			success = "batchFail";
		}
		//fstRowId
		request.setAttribute("fstRowId", fstRowId);
		//requestinfo
		if("Campaigns".equals(obj.getParenttype())){
			return "redirect:/campaigns/detail?rowId="+obj.getParentid();
		}else if("Activity".equals(obj.getParenttype())){
			return "redirect:/zjactivity/detail?rowId="+obj.getParentid();
		}
		//return "shenyi/expense/msg";
		return "redirect:/expense/msg?fstRowId="+fstRowId+"&success="+success+"&orgId="+obj.getOrgId();
	}
	
	@RequestMapping(value = "/msg", method = RequestMethod.GET)
	public String batchSave(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String fstRowId = request.getParameter("fstRowId");
		String success = request.getParameter("success");
		String orgId = request.getParameter("orgId");
		
		request.setAttribute("success", success);
		request.setAttribute("fstRowId", fstRowId);
		request.setAttribute("orgId", orgId);
		
		return "shenyi/expense/msg";
	}
	
	/**
	 * 批量提交审批
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/batchApproval", method = RequestMethod.POST)
	public String batchApproval(Expense obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ExpenseController save method id =>" + obj.getId());

		// request info
		request.setAttribute("command", obj);
		//rowId
		CrmError crmErr =  cRMService.getSugarService().getExpense2CrmService().batchApproval(obj);
		String errorCode = crmErr.getErrorCode();
        /*String approvaemail = obj.getApprovaemail();//审批人邮箱
		String approvalname = obj.getApprovalname();//审批人名字
		String record=obj.getRecordid();
		String status = obj.getApprovalstatus();
		String assignerId = obj.getAssignid();
		String count="";
		if(StringUtils.isNotNullOrEmptyStr(record)&&record.contains(",")){
			if(record.contains("undefined")){
				record = record.replaceAll("undefined,", "");
			}
			count = record.split(",").length+"";
		}*/
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			request.setAttribute("success", "batchApproSucc");
          /*if("approved".equals(status)&&StringUtils.isNotNullOrEmptyStr(approvalname)){
				SenderInfor senderInfor = new SenderInfor();
				senderInfor.setSubject("审批通知");
				senderInfor.setToEmails(approvaemail);
				String str = Constants.MAILAPPROVAL.replace("@@assigner@@", approvalname).replaceAll("@@count@@",count).replaceAll("@@count@@","1").replaceAll("@@content@@", "详情请登陆微信CRM或内部CRM系统！");
				senderInfor.setContent(str);
				senderInfor.setSignature(Constants.SIGNATURE);
				MailUtils.sendEmail(senderInfor);
			}else if("reject".equals(status)){
				if(StringUtils.isNotNullOrEmptyStr(assignerId)){
					if(assignerId.contains("undefined")){
						assignerId = assignerId.replaceAll("undefined,", "");
					}
					String[] strs=null;
					String email = "";
					String name = "";
					Set<String> set = new HashSet<String>();
					Map<String, Object> map = new HashMap<String, Object>();
					if(assignerId.contains(",")){
						strs= assignerId.split(",");
					}
					int i=1;
					for(String str : strs){
						set.add(str);
						map.put(str,i++);
					}
					for(String str : set){
						SenderInfor senderInfor = new SenderInfor();
						UserReq uReq = new UserReq();
						uReq.setCrmaccount(str);
						uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
						uReq.setCurrpage("1");
						uReq.setPagecount("1000");
						uReq.setFlag(Constants.SEARCH_USER_INFO);
						UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
						List<UserAdd> list = uResp.getUsers();
						if(list!=null&&list.size()>0){
							email = list.get(0).getEmail();
							name = list.get(0).getUsername();
						}
						if(!"".equals(email)){
							senderInfor.setSubject("驳回通知");
							senderInfor.setToEmails(email);
							String content = Constants.MAILREJECT.replace("@@assigner@@", name).replaceAll("@@count@@",map.get(str)+"").replaceAll("@@count@@","1").replaceAll("@@content@@", "详情请登陆微信CRM或内部CRM系统！");
							senderInfor.setSignature(Constants.SIGNATURE);
							senderInfor.setContent(content);
							MailUtils.sendEmail(senderInfor);
						}
					}
				}
			}*/
		}else{
			request.setAttribute("success", "batchApproFail");
			request.setAttribute("errorCode", crmErr.getErrorCode());
			request.setAttribute("errorMsg", crmErr.getErrorMsg());
		}
		//requestinfo
		request.setAttribute("openId", obj.getOpenId());
		request.setAttribute("publicId", obj.getPublicId());
		
		return "shenyi/expense/msg";
	}

	/**
	 * 获取记录的CRMID
	 * @param request
	 * @return
	 * @throws Exception
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
				String newCrmId = cRMService.getSugarService().getExpense2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
					return newCrmId;
				}
			}
		} catch (Exception e) {
			logger.info("error mesg = >" + e.getMessage());
		}
		return crmId;
	}
}
