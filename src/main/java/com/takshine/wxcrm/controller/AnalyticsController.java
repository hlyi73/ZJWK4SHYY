package com.takshine.wxcrm.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Analytics;
import com.takshine.wxcrm.message.sugar.AnalyticsComplaintResp;
import com.takshine.wxcrm.message.sugar.AnalyticsContactResp;
import com.takshine.wxcrm.message.sugar.AnalyticsCustomeryResp;
import com.takshine.wxcrm.message.sugar.AnalyticsExpenseResp;
import com.takshine.wxcrm.message.sugar.AnalyticsOpptyResp;
import com.takshine.wxcrm.message.sugar.AnalyticsQuotaResp;
import com.takshine.wxcrm.message.sugar.AnalyticsReceivableResp;
import com.takshine.wxcrm.message.sugar.AnalyticsResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.AnalyticsService;
import com.takshine.wxcrm.service.LovUser2SugarService;

/**
 * 报表 页面控制器
 * 
 * @author [ Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/analytics")
public class AnalyticsController {
	
	protected static Logger logger = Logger.getLogger(AnalyticsController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 费用统计分析-by部门
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	@RequestMapping("/expense/depart")
	public String expenseAnalytics4Dept(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		// String crmId = request.getParameter("crmId");// crmIdID

		String subtype = request.getParameter("subtype");
		String type = request.getParameter("type");
		String typename = request.getParameter("typename");
		String subtypename = request.getParameter("subtypename");

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String source = request.getParameter("source");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}

		if (null != source && !"".equals(source) && null != subtypename
				&& !"".equals(subtypename)) {
			subtypename = new String(subtypename.getBytes("ISO-8859-1"),
					"UTF-8");
		}

		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);
		logger.info("expenseAnalytics4type params subtype  is ->" + subtype);
		logger.info("expenseAnalytics4type params subtypename  is ->"
				+ subtypename);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			// 获取LOV下拉列表信息
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
					.getLovList(crmId);
			request.setAttribute("expenseSubTypeList",
					mp.get("expense_sub_type_list"));// 子类别

			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_EXPENSE);
			analytics.setReport(Constants.ANALYTICS_REPORT_EXPENSE_DEPART);
			// 参数
			analytics.setParam1(subtype);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam2(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam3(endDate.replaceAll("-", ""));
			}
			analytics.setParam4(assignerId);
			analytics.setParam5(depart);
			analytics.setParam6(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsExpense4Depart(analytics);
			List<AnalyticsExpenseResp> cList = cResp.getExpense();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}

			StringBuffer dimession = new StringBuffer();
			StringBuffer fact = new StringBuffer();
			dimession.append("[");
			fact.append("[");

			List<String> dateList = new ArrayList<String>();
			List<String> departList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			Map valueMap = new HashMap();
			AnalyticsExpenseResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				if (!dateList.contains(resp.getExpenseDate())) {
					dateList.add(resp.getExpenseDate());
				}
				if (!departList.contains(resp.getDepartment())) {
					departList.add(resp.getDepartment());
				}
				valueMap.put(resp.getExpenseDate() + resp.getDepartment(),
						resp.getExpenseAmount());
			}

			// 维度
			for (int i = 0; i < dateList.size(); i++) {
				dimession.append("'").append(dateList.get(i)).append("'");
				if (i != dateList.size() - 1) {
					dimession.append(",");
				}
			}

			// 指标
			for (int i = 0; i < departList.size(); i++) {
				fact.append("{");
				fact.append("name:'").append(departList.get(i)).append("',");
				fact.append("data:[");
				for (int j = 0; j < dateList.size(); j++) {
					if (valueMap.containsKey(dateList.get(j)
							+ departList.get(i))) {
						fact.append("{y:")
								.append(Double.parseDouble(valueMap.get(
										dateList.get(j) + departList.get(i))
										.toString())).append(",");
						fact.append("url:'")
								.append("../../expense/list?viewtype=analyticsview&approval=approved&type=")
								.append(subtype)
								.append("&depart=")
								.append(URLEncoder.encode(departList.get(i),
										"utf-8")).append("&expensedate=")
								.append(dateList.get(j)).append("'}");
					} else {
						fact.append("{y:0}");
					}
					if (j != dateList.size() - 1) {
						fact.append(",");
					}
				}
				fact.append("]");
				fact.append("}");
				if (i != departList.size() - 1) {
					fact.append(",");
				}
			}

			dimession.append("]");
			fact.append("]");

			logger.info("dimession is ->" + dimession);
			logger.info("fact is ->" + fact);
			request.setAttribute("dimession", dimession);
			request.setAttribute("fact", fact);

			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																	// 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("expenseList", cList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("subtype", subtype);
		request.setAttribute("type", type);
		request.setAttribute("typename", typename);
		request.setAttribute("subtypename", subtypename);
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("depart", depart);

		return "analytics/topic/expense/expense_department";
	}

	/**
	 * 查询 客户 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/expense/type")
	public String expenseAnalytics4type(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		// String crmId = request.getParameter("crmId");// crmIdID
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String subtype = request.getParameter("subtype");
		String type = request.getParameter("type");
		String source = request.getParameter("source");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}

		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_EXPENSE);
			analytics.setReport(Constants.ANALYTICS_REPORT_EXPENSE_TYPE);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(depart);
			analytics.setParam5(subtype);
			analytics.setParam6(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsExpense4Type(analytics);
			List<AnalyticsExpenseResp> cList = cResp.getExpense();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			AnalyticsExpenseResp resp = null;
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getExpenseType() + "',"
						+ resp.getExpenseAmount() + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}
			logger.info("expenseAnalytics4type params startDate  is ->"
					+ startDate);
			logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
			logger.info("expenseAnalytics4type params assignerId  is ->"
					+ assignerId);
			logger.info("expenseAnalytics4type params addAssigner  is ->"
					+ addAssigner);
			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);

			request.setAttribute("expenseList", cList);
			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("depart", depart);
		request.setAttribute("subtype", subtype);
		request.setAttribute("type", type);

		return "analytics/topic/expense/expense_type";
	}

	/**
	 * 查询 客户 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/expense/subtype")
	public String expenseAnalytics4Subtype(HttpServletRequest request,

	HttpServletResponse response) throws Exception {
		// search param
		// String crmId = request.getParameter("crmId");// crmIdID
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String subtype = request.getParameter("subtype");
		String type = request.getParameter("type");
		String source = request.getParameter("source");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}

		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_EXPENSE);
			analytics.setReport(Constants.ANALYTICS_REPORT_EXPENSE_SUB_TYPE);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(depart);
			analytics.setParam5(subtype);
			analytics.setParam6(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsExpense4SubType(analytics);
			List<AnalyticsExpenseResp> cList = cResp.getExpense();
			logger.info("cList is ->" + cList.size());

			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}

			AnalyticsExpenseResp resp = null;
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getExpenseSubType() + "',"
						+ resp.getExpenseAmount() + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}

			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);

			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																	// 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("expenseList", cList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("depart", depart);
		request.setAttribute("subtype", subtype);
		request.setAttribute("type", type);

		return "analytics/topic/expense/expense_sub_type";
	}

	/**
	 * 客户地理分布分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/distribute")
	public String customerAnalytics4Distribute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String viewtype = request.getParameter("analyticsview");
		String customername = request.getParameter("name");
		String accnttype = request.getParameter("accnttype");
		String industry = request.getParameter("industry");
		String province = request.getParameter("province");
		String city =  request.getParameter("city");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}

		logger.info("customerAnalytics4Distribute params assignerId  is ->"
				+ assignerId);
		logger.info("customerAnalytics4Distribute params addAssigner  is ->"
				+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_DISTRIBUTE);
			analytics.setParam6(customername);
			analytics.setParam5(accnttype);
			analytics.setParam4(industry);
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsCustomer4Distribute(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			logger.info("cList is ->" + cList.size());

			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				request.setAttribute("clist", JSONArray.fromObject(cList));
			}
			AnalyticsCustomeryResp resp = null;
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				String pro = resp.getProvince();
				if (pro.equals("")||pro==null) {
					pro = "未知";
				}
				// 数据组装
				dataStr += "['" + pro + "',"
						+ resp.getCustomerNumber() + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}
			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);
			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("expenseList", cList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("analyticsview", viewtype);
		request.setAttribute("name", customername);
		request.setAttribute("accnttype", accnttype);
		request.setAttribute("industry", industry);
		request.setAttribute("province", province);
		request.setAttribute("city", city);

		return "analytics/topic/customer/customer_distribute";
	}
	
	/**
	 * 异步客户地理分布分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/ajaxdistribute")
	@ResponseBody
	public String ajaxcustomerAnalytics4Distribute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String viewtype = request.getParameter("viewtype");
		String customername = request.getParameter("customername");
		String accnttype = request.getParameter("accnttype");
		String industry = request.getParameter("industry");
		String assignerId = request.getParameter("assignerId");
	
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_DISTRIBUTE);
			
			analytics.setParam7(viewtype);
			analytics.setParam6(customername);
			analytics.setParam5(accnttype);
			analytics.setParam4(industry);
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsCustomer4Distribute(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	

	/**
	 * 客户贡献分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/contribution")
	public String customerAnalytics4Contribution(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String contribution = request.getParameter("contribution");
		String num = request.getParameter("num");
		
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} 

		logger.info("customerAnalytics4Contribution params assignerId  is ->"+ assignerId);
		logger.info("customerAnalytics4Contribution params addAssigner  is ->"+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_CONTRIBUTION);
			
			analytics.setParam5(assignerId);
			analytics.setParam6(contribution);
			analytics.setParam8(num);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticCustomer4Contribution(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}

			List<String> cutomerList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			AnalyticsCustomeryResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				cutomerList.add(resp.getCustomername());
				valueList.add(Double.parseDouble(resp.getValue()));
			}
		
			request.setAttribute("dimession", JSONArray.fromObject(cutomerList).toString());
			request.setAttribute("fact", JSONArray.fromObject(valueList).toString());
			request.setAttribute("clist", JSONArray.fromObject(cList).toString());
			logger.info("dimession is ->" + JSONArray.fromObject(cutomerList));
			logger.info("fact is ->" + JSONArray.fromObject(valueList));
			logger.info("clist is ->" + JSONArray.fromObject(cList).toString());
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("num",num);
		request.setAttribute("contributione",contribution);
	

		return "analytics/topic/customer/customer_contribution";
	}
	
	/**
	 * 异步客户贡献分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/ajaxcontribution")
	@ResponseBody
	public String ajaxcustomerAnalytics4Contribution(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String viewtype = request.getParameter("viewtype");
		String customername = request.getParameter("customername");
		String accnttype = request.getParameter("accnttype");
		String industry = request.getParameter("industry");
		String assignerId = request.getParameter("assignerId");
		String contribution = request.getParameter("contribution");
	
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_CONTRIBUTION);
			
			analytics.setParam1(viewtype);
			analytics.setParam2(customername);
			analytics.setParam3(accnttype);
			analytics.setParam4(industry);
			analytics.setParam5(assignerId);
			analytics.setParam6(contribution);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticCustomer4Contribution(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}


	/**
	 * 联系人贡献分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/contact/contribution")
	public String contactAnalytics4Contribution(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String contribution = request.getParameter("contribution");
		String num = request.getParameter("num");
		
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} 

		logger.info("contactAnalytics4Contribution params assignerId  is ->"+ assignerId);
		logger.info("contactAnalytics4Contribution params addAssigner  is ->"+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CONTACT);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CONTACT_CONTRIBUTION);
			
			analytics.setParam5(assignerId);
			analytics.setParam6(contribution);
			analytics.setParam8(num);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsContact4Contribution(analytics);
			List<AnalyticsContactResp> cList = cResp.getContactList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}

			List<String> contactList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			AnalyticsContactResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				contactList.add(resp.getContactname());
				valueList.add(Double.parseDouble(resp.getValue()));
			}
		
			request.setAttribute("dimession", JSONArray.fromObject(contactList).toString());
			request.setAttribute("fact", JSONArray.fromObject(valueList).toString());
			request.setAttribute("clist", JSONArray.fromObject(cList).toString());
			logger.info("dimession is ->" + JSONArray.fromObject(contactList));
			logger.info("fact is ->" + JSONArray.fromObject(valueList));
			logger.info("clist is ->" + JSONArray.fromObject(cList).toString());
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("num",num);
		request.setAttribute("contribution",contribution);

		return "analytics/topic/contact/contact_contribution";
	}
	
	/**
	 * 异步联系人贡献分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/contact/ajaxcontribution")
	@ResponseBody
	public String ajaxcontactAnalytics4Contribution(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String viewtype = request.getParameter("viewtype");
		String conname = request.getParameter("conname");
		String phonemobile = request.getParameter("phonemobile");
		String assignerId = request.getParameter("assignerId");
	
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CONTACT);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CONTACT_CONTRIBUTION);
			
			analytics.setParam1(viewtype);
			analytics.setParam2(conname);
			analytics.setParam3(phonemobile);
			analytics.setParam4(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsContact4Contribution(analytics);
			List<AnalyticsContactResp> cList = cResp.getContactList();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	
	/**
	 * 客户未来业务机会分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/futureoppty")
	public String customerAnalytics4Futureoppty(HttpServletRequest request,

			HttpServletResponse response) throws Exception {
		// search param
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String futureoppty = request.getParameter("futureoppty");
		String num = request.getParameter("num");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}

		logger.info("customerAnalytics4Contribution params assignerId  is ->"
				+ assignerId);
		logger.info("customerAnalytics4Contribution params addAssigner  is ->"
				+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_FUTUREOPPTY);
		
			analytics.setParam5(assignerId);
			analytics.setParam6(futureoppty);
			analytics.setParam7(num);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsCustomer4Futureoppty(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<String> customerList = new ArrayList<String>();
			List<Double> amountList = new ArrayList<Double>();
			AnalyticsCustomeryResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				customerList.add(resp.getCustomername());
				amountList.add(Double.parseDouble(resp.getValue()));
			}
			logger.info("dimession is ->" + JSONArray.fromObject(customerList));
			logger.info("fact is ->" + JSONArray.fromObject(amountList));
			request.setAttribute("dimession", JSONArray.fromObject(customerList).toString());
			request.setAttribute("fact", JSONArray.fromObject(amountList).toString());
			request.setAttribute("clist", JSONArray.fromObject(cList).toString());

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/customer/customer_futureoppty";
	}
	
	/**
	 * 异步客户未来业务机会分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/ajaxfutureoppty")
	@ResponseBody
	public String ajaxcustomerAnalytics4Futureoppty(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String customername = request.getParameter("customername");
		String accnttype = request.getParameter("accnttype");
		String industry = request.getParameter("industry");
		String assignerId = request.getParameter("assignerId");
		String futureoppty = request.getParameter("futureoppty");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		
		 
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CUSTOMER_FUTUREOPPTY);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			analytics.setParam2(customername);
			analytics.setParam3(accnttype);
			analytics.setParam4(industry);
			analytics.setParam5(assignerId);
			analytics.setParam6(futureoppty);
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsCustomer4Futureoppty(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			if (null == cList || cList.size() == 0) {
				str = "";
				request.setAttribute("clist", cList);
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	
	
	/**
	 * 联系人未来业务机会分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/contact/futureoppty")
	public String contactAnalytics4Futureoppty(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}

		logger.info("contactAnalytics4Futureoppty params assignerId  is ->"
				+ assignerId);
		logger.info("contactAnalytics4Futureoppty params addAssigner  is ->"
				+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CONTACT);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CONTACT_FUTUREOPPTY);
			analytics.setParam5(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsContact4Futureoppty(analytics);
			List<AnalyticsContactResp> cList = cResp.getContactList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<String> customerList = new ArrayList<String>();
			List<Double> amountList = new ArrayList<Double>();
			AnalyticsContactResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				customerList.add(resp.getContactname());
				amountList.add(Double.parseDouble(resp.getValue()));
			}
			logger.info("dimession is ->" + JSONArray.fromObject(customerList));
			logger.info("fact is ->" + JSONArray.fromObject(amountList));
			request.setAttribute("dimession", JSONArray.fromObject(customerList).toString());
			request.setAttribute("fact", JSONArray.fromObject(amountList).toString());
			request.setAttribute("clist", JSONArray.fromObject(cList).toString());

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/contact/contact_futurevalue";
	}
	
	/**
	 * 异步客户未来业务机会分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/contact/ajaxfutureoppty")
	@ResponseBody
	public String ajaxcontactAnalytics4Futureoppty(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String viewtype = request.getParameter("viewtype");
		String conname = request.getParameter("conname");
		String phonemobile = request.getParameter("phonemobile");
		String assignerId = request.getParameter("assignerId");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		
		 
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CONTACT);
			analytics.setReport(Constants.ANALYTICS_TOPIC_CONTACT_FUTUREOPPTY);
			
			analytics.setParam1(viewtype);
			analytics.setParam2(conname);
			analytics.setParam3(phonemobile);
			analytics.setParam4(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsContact4Futureoppty(analytics);
			List<AnalyticsContactResp> cList = cResp.getContactList();
			if (null == cList || cList.size() == 0) {
				str = "";
				request.setAttribute("clist", cList);
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	
	
	/**
	 * 业务机会阶段分析表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/oppty/stage")
	public String opptyAnalytics4Stage(HttpServletRequest request,

			HttpServletResponse response) throws Exception {
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_STAGE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsOppty4Stage(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<String> dateList = new ArrayList<String>();
			List<String> stageList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			Map valueMap = new HashMap();
			AnalyticsOpptyResp resp = null;
			List<AnalyticsOpptyResp> rlist = new ArrayList<AnalyticsOpptyResp>();
			for (int i = 0; i < cList.size(); i++) {
				AnalyticsOpptyResp aresp = new AnalyticsOpptyResp();
				resp = cList.get(i);
				if (!dateList.contains(resp.getOpptyDate())) {
					dateList.add(resp.getOpptyDate());
				}
				if (!stageList.contains(resp.getOpptyStagename())) {
					stageList.add(resp.getOpptyStagename());
					aresp.setOpptyStage(resp.getOpptyStage());
					aresp.setOpptyStagename(resp.getOpptyStagename());
					rlist.add(aresp);
				}
				valueMap.put(resp.getOpptyDate() + resp.getOpptyStagename(),
						resp.getOpptyAmount());
			}

			JSONArray jarr = new JSONArray();
			JSONObject jobj = new JSONObject();
			for (int i = 0; i < stageList.size(); i++) {
				valueList = new ArrayList<Double>();
				jobj = new JSONObject();
				for (int j = 0; j < dateList.size(); j++) {
					if (valueMap
							.containsKey(dateList.get(j) + stageList.get(i))) {
						valueList
								.add(Double.parseDouble(valueMap.get(
										dateList.get(j) + stageList.get(i))
										.toString()));
					} else {
						valueList.add(new Double(0));
					}
				}
				jobj.accumulate("name", stageList.get(i));
				jobj.accumulate("data", valueList);
				jarr.add(jobj);
			}
			logger.info("dimession is ->" + JSONArray.fromObject(dateList));
			logger.info("fact is ->" + jarr.toString());
			request.setAttribute("dimession", JSONArray.fromObject(dateList)
					.toString());
			request.setAttribute("rlist", JSONArray.fromObject(rlist));
			request.setAttribute("fact", jarr.toString());
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/oppty/oppty_stage";
	}
	
	
	/**
	 * 异步业务机会阶段分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/ajaxstage")
	@ResponseBody
	public String ajaxopptyAnalytics4Stage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String opptyname = request.getParameter("opptyname");
		String salestage = request.getParameter("salestage");
		String viewtype = request.getParameter("viewtype");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_STAGE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(opptyname);
			analytics.setParam5(salestage);
			analytics.setParam6(viewtype);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Stage(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			
			
			List<String> dateList = new ArrayList<String>();
			List<String> stageList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			List<String> strList = new ArrayList<String>();
			Map valueMap = new HashMap();
			AnalyticsOpptyResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				AnalyticsOpptyResp aresp = new AnalyticsOpptyResp();
				resp = cList.get(i);
				if (!dateList.contains(resp.getOpptyDate())) {
					dateList.add(resp.getOpptyDate());
				}
				if (!stageList.contains(resp.getOpptyStagename())) {
					stageList.add(resp.getOpptyStagename());
					aresp.setOpptyStage(resp.getOpptyStage());
					aresp.setOpptyStagename(resp.getOpptyStagename());
				}
				valueMap.put(resp.getOpptyDate() + resp.getOpptyStagename(),resp.getOpptyAmount());
			}

			JSONArray jarr = new JSONArray();
			JSONObject jobj = new JSONObject();
			for (int i = 0; i < stageList.size(); i++) {
				valueList = new ArrayList<Double>();
				jobj = new JSONObject();
				for (int j = 0; j < dateList.size(); j++) {
					if (valueMap.containsKey(dateList.get(j) + stageList.get(i))) {
						valueList.add(Double.parseDouble(valueMap.get(dateList.get(j) + stageList.get(i)).toString()));
					} else {
						valueList.add(new Double(0));
					}
				}
				jobj.accumulate("name", stageList.get(i));
				jobj.accumulate("data", valueList);
				jarr.add(jobj);
			}
			String dimession = JSONArray.fromObject(dateList).toString();
			String fact = jarr.toString();
			strList.add(0, fact);
			strList.add(1,dimession);
			str = JSONArray.fromObject(strList).toString();
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	
	

	/**
	 * 销售管道分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/pipeline")
	public String opptyAnalytics4Pipeline(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");


		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_PIPELINE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsOppty4SPipeline(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<String> stageList = new ArrayList<String>();
			List<Double> valueList = new ArrayList<Double>();
			AnalyticsOpptyResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				stageList.add(resp.getOpptyStagename());
				valueList.add(Double.parseDouble(resp.getOpptyAmount()));
			}
			logger.info("dimession is ->" + JSONArray.fromObject(stageList));
			logger.info("fact is ->" + JSONArray.fromObject(valueList));
			request.setAttribute("dimession", JSONArray.fromObject(stageList)
					.toString());
			request.setAttribute("fact", JSONArray.fromObject(valueList)
					.toString());
			request.setAttribute("clist", JSONArray.fromObject(cList)
					.toString());
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/oppty/oppty_pipeline";
	}
	
	/**
	 * 异步销售管道分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/ajaxpipeline")
	@ResponseBody
	public String ajaxopptyAnalytics4Pipeline(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String opptyname = request.getParameter("opptyname");
		String salestage = request.getParameter("salestage");
		String viewtype = request.getParameter("viewtype");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_PIPELINE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(opptyname);
			analytics.setParam5(salestage);
			analytics.setParam6(viewtype);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsOppty4SPipeline(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	

	/**
	 * 销售漏斗分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/funnel")
	public String opptyAnalytics4Funnel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		if (null == assignerId || "".equals(assignerId.trim())) {
			addAssigner = "我自己";
			//assignerId=crmId;
		}
		/*if ("all".equals(assignerId.trim())) {
			addAssigner = "所有人";
		}*/
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_PIPELINE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsOppty4SPipeline(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			String dataStr = "";
			AnalyticsOpptyResp resp = null;
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getOpptyStagename() + "',"
						+ Double.parseDouble(resp.getOpptyAmount()) + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}
			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);
			request.setAttribute("clist", JSONArray.fromObject(cList));
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/oppty/oppty_funnel";
	}

	/**
	 * 业务机会失败原因分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/failure")
	public String opptyAnalytics4Failure(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");// 关闭的开始时间
		String endDate = request.getParameter("endDate");// 关闭的结束时间
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String dateclosed = request.getParameter("dateclosed");
		String salestage = request.getParameter("salestage");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != dateclosed && !"".equals(dateclosed)
				&& dateclosed.length() >= 7) {
			dateclosed = dateclosed.substring(0, 7);
		}
		logger.info("opptyAnalytics4Failure params startDate  is ->"
				+ startDate);
		logger.info("opptyAnalytics4Failure params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Failure params assignerId  is ->"
				+ assignerId);
		logger.info("opptyAnalytics4Failure params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_REASON);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (null != dateclosed && !"".equals(dateclosed)) {
				analytics.setParam4(dateclosed.replaceAll("-", ""));
			}
			analytics.setParam5(salestage);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsOppty4Failure(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			AnalyticsOpptyResp resp = null;
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getOpptyFailurename() + "',"
						+ Double.parseDouble(resp.getOpptyAmount()) + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}
			logger.info("opptyAnalytics4Failure params startDate  is ->"
					+ startDate);
			logger.info("opptyAnalytics4Failure params endDate  is ->"
					+ endDate);
			logger.info("opptyAnalytics4Failure params assignerId  is ->"
					+ assignerId);
			logger.info("opptyAnalytics4Failure params addAssigner  is ->"
					+ addAssigner);
			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);
			request.setAttribute("clist", JSONArray.fromObject(cList));
			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/oppty/oppty_failure";
	}

	
	/**
	 * 异步业务机会失败原因分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/ajaxfailure")
	@ResponseBody
	public String ajaxopptyAnalytics4Failure(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param

		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String opptyname = request.getParameter("opptyname");
		String salestage = request.getParameter("salestage");
		String viewtype = request.getParameter("viewtype");
		
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		
		logger.info("opptyAnalytics4Failure params startDate  is ->"+ startDate);
		logger.info("opptyAnalytics4Failure params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Failure params assignerId  is ->"+ assignerId);
		logger.info("opptyAnalytics4Failure params addAssigner  is ->"+ addAssigner);

		String crmId =UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_REASON);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(opptyname);
			analytics.setParam5(salestage);
			analytics.setParam6(viewtype);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Failure(analytics);
			List<AnalyticsOpptyResp> cList = cResp.getOpptyList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 商机成单率分布分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/rate")
	public String opptyAnalytics4Rate(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");// 关闭的开始时间
		String endDate = request.getParameter("endDate");// 关闭的结束时间
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String dateclosed = request.getParameter("dateclosed");
		String salestage = request.getParameter("salestage");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != dateclosed && !"".equals(dateclosed)
				&& dateclosed.length() >= 7) {
			dateclosed = dateclosed.substring(0, 7);
		}
		logger.info("opptyAnalytics4Rate params startDate  is ->"
				+ startDate);
		logger.info("opptyAnalytics4Rate params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Rate params assignerId  is ->"
				+ assignerId);
		logger.info("opptyAnalytics4Rate params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_RATE);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (null != dateclosed && !"".equals(dateclosed)) {
				analytics.setParam4(dateclosed.replaceAll("-", ""));
			}
			analytics.setParam5(salestage);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp oppResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Rate(analytics);
			List<AnalyticsOpptyResp> oppList = oppResp.getOpptyList();
			logger.info("cList is ->" + oppList.size());

			if (null == oppList || oppList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				request.setAttribute("clist", JSONArray.fromObject(oppList));
			}
			AnalyticsOpptyResp resp = null;
			String dataStr = "";
			for (int i = 0; i < oppList.size(); i++) {
				resp = oppList.get(i);
				String pro = resp.getRate();
				if (pro.equals("")||pro==null) {
					pro = "未知";
				}
				// 数据组装
				dataStr += "['" + pro + "',"
						+ resp.getCount() + "]";
				if (i != oppList.size() - 1) {
					dataStr += ",";
				}
			}
			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);
			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("expenseList", oppList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);


		return "analytics/topic/oppty/oppty_rate";
	}
	

	/**
	 * 商机排名分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/rank")
	public String opptyAnalytics4Rank(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");// 关闭的开始时间
		String endDate = request.getParameter("endDate");// 关闭的结束时间
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String dateclosed = request.getParameter("dateclosed");
		String salestage = request.getParameter("salestage");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != dateclosed && !"".equals(dateclosed)
				&& dateclosed.length() >= 7) {
			dateclosed = dateclosed.substring(0, 7);
		}
		logger.info("opptyAnalytics4Rate params startDate  is ->"
				+ startDate);
		logger.info("opptyAnalytics4Rate params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Rate params assignerId  is ->"
				+ assignerId);
		logger.info("opptyAnalytics4Rate params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_RANK);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (null != dateclosed && !"".equals(dateclosed)) {
				analytics.setParam4(dateclosed.replaceAll("-", ""));
			}
			analytics.setParam5(salestage);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp oppResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Rank(analytics);
			List<AnalyticsOpptyResp> oppList = oppResp.getOpptyList();
			logger.info("cList is ->" + oppList.size());

			if (null == oppList || oppList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				request.setAttribute("clist", oppList);
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		
		
		return "analytics/topic/oppty/oppty_rank";
	}
	

	/**
	 * 商机成单同比分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/yearcompare")
	public String opptyAnalytics4Yearcompare(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");// 关闭的开始时间
		String endDate = request.getParameter("endDate");// 关闭的结束时间
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String dateclosed = request.getParameter("dateclosed");
		String salestage = request.getParameter("salestage");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != dateclosed && !"".equals(dateclosed)
				&& dateclosed.length() >= 7) {
			dateclosed = dateclosed.substring(0, 7);
		}
		logger.info("opptyAnalytics4Yearcompare params startDate  is ->"
				+ startDate);
		logger.info("opptyAnalytics4Yearcompare params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Yearcompare params assignerId  is ->"
				+ assignerId);
		logger.info("opptyAnalytics4Yearcompare params addAssigner  is ->"
				+ addAssigner);

		String crmId =UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_YEARCOMPARE);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (null != dateclosed && !"".equals(dateclosed)) {
				analytics.setParam4(dateclosed.replaceAll("-", ""));
			}
			analytics.setParam5(salestage);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp oppResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Rank(analytics);
			List<AnalyticsOpptyResp> oppList = oppResp.getOpptyList();
			logger.info("cList is ->" + oppList.size());

			if (null == oppList || oppList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				//报表参数
				List<String> timeList = new ArrayList<String>();
				List<String> countList = new ArrayList<String>();
				List<String> lineList = new ArrayList<String>();
				AnalyticsOpptyResp resp = null;
				for (int i = 0; i < oppList.size(); i++) {
					resp = oppList.get(i);
					timeList.add(resp.getOpptyDate());
					countList.add(resp.getCount());
					lineList.add(resp.getYearcompare());
				}
				logger.info("dimession is ->" + JSONArray.fromObject(timeList));
				logger.info("fact is ->" + JSONArray.fromObject(countList));
				logger.info("line is ->" + JSONArray.fromObject(lineList));
				request.setAttribute("dimession", JSONArray.fromObject(timeList)
						.toString());
				request.setAttribute("fact", JSONArray.fromObject(countList)
						.toString());
				request.setAttribute("line", JSONArray.fromObject(lineList)
						.toString());
				request.setAttribute("clist", JSONArray.fromObject(oppList));
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/oppty/oppty_yearcompare";
	}
	
	

	/**
	 * 商机成单环比分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/monthcompare")
	public String opptyAnalytics4Monthcompare(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");// 关闭的开始时间
		String endDate = request.getParameter("endDate");// 关闭的结束时间
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String dateclosed = request.getParameter("dateclosed");
		String salestage = request.getParameter("salestage");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		if (null != dateclosed && !"".equals(dateclosed)
				&& dateclosed.length() >= 7) {
			dateclosed = dateclosed.substring(0, 7);
		}
		logger.info("opptyAnalytics4Rate params startDate  is ->"
				+ startDate);
		logger.info("opptyAnalytics4Rate params endDate  is ->" + endDate);
		logger.info("opptyAnalytics4Rate params assignerId  is ->"
				+ assignerId);
		logger.info("opptyAnalytics4Rate params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_MONTHCOMPARE);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (null != dateclosed && !"".equals(dateclosed)) {
				analytics.setParam4(dateclosed.replaceAll("-", ""));
			}
			analytics.setParam5(salestage);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp oppResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsOppty4Rank(analytics);
			List<AnalyticsOpptyResp> oppList = oppResp.getOpptyList();
			logger.info("cList is ->" + oppList.size());

			if (null == oppList || oppList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				//报表参数
				List<String> timeList = new ArrayList<String>();
				List<String> oldcountList = new ArrayList<String>();
				List<String> countList = new ArrayList<String>();
				List<String> lineList = new ArrayList<String>();
				AnalyticsOpptyResp resp = null;
				for (int i = 0; i < oppList.size(); i++) {
					resp = oppList.get(i);
					timeList.add(resp.getOpptyDate());
					oldcountList.add(resp.getOldcount());
					countList.add(resp.getCount());
					lineList.add(resp.getYearcompare());
				}
				logger.info("dimession is ->" + JSONArray.fromObject(timeList));
				logger.info("fact1 is ->" + JSONArray.fromObject(oldcountList));
				logger.info("fact2 is ->" + JSONArray.fromObject(countList));
				logger.info("line is ->" + JSONArray.fromObject(lineList));
				request.setAttribute("dimession", JSONArray.fromObject(timeList)
						.toString());
				request.setAttribute("fact1", JSONArray.fromObject(oldcountList)
						.toString());
				request.setAttribute("fact2", JSONArray.fromObject(countList)
						.toString());
				request.setAttribute("line", JSONArray.fromObject(lineList)
						.toString());
				
				
				request.setAttribute("clist", JSONArray.fromObject(oppList));
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/oppty/oppty_monthcompare";
	}
	
	/**
	 * 回款分析(月份)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/month")
	public String receivableAnalytics4Month(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String source = request.getParameter("source");
		String month = request.getParameter("month");
		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		String viewtype = request.getParameter("viewtype");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_MONTH);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (depart != null && !"".equals(depart)) {
				analytics.setParam4(depart);
			}
			if(StringUtils.isNotNullOrEmptyStr(name)){
				analytics.setParam5(name);
			}
			if(StringUtils.isNotNullOrEmptyStr(status)){
				analytics.setParam6(status);
			}
			if(StringUtils.isNotNullOrEmptyStr(viewtype)){
				analytics.setParam7(viewtype);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Month(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			// 维度
			StringBuffer dimession = new StringBuffer();
			StringBuffer fact = new StringBuffer();
			dimession.append("[");
			fact.append("[");
			List<String> planList = new ArrayList<String>();
			List<String> receList = new ArrayList<String>();
			List<String> dateList = new ArrayList<String>();
			List<String> marList = new ArrayList<String>();
			List<AnalyticsReceivableResp> gaList = new ArrayList<AnalyticsReceivableResp>();
			for (AnalyticsReceivableResp resp : cList) {
				AnalyticsReceivableResp aresp = new AnalyticsReceivableResp();
				if (StringUtils.isNotNullOrEmptyStr(resp.getMonth())) {
					dateList.add(resp.getMonth());
				}
				if (StringUtils.isNotNullOrEmptyStr(StringUtils.replaceStr(resp
						.getPlanAmount()))) {
					String planAmount = StringUtils.repAmount(resp
							.getPlanAmount());
					planList.add(planAmount);
					aresp.setPlanAmount(planAmount);
				}
				if (StringUtils.isNotNullOrEmptyStr(StringUtils.replaceStr(resp
						.getActAmount()))) {
					String actAmount = StringUtils.repAmount(resp
							.getActAmount());
					receList.add(actAmount);
					aresp.setActAmount(actAmount);
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getMargin())) {
					String margin = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getMargin()));
					marList.add(margin);
					aresp.setMargin(margin);
				}
				aresp.setMonth(resp.getMonth());
				gaList.add(aresp);
			}
			// 维度
			for (int i = 0; i < dateList.size(); i++) {
				dimession.append("'").append(dateList.get(i)).append("'");
				if (i != dateList.size() - 1) {
					dimession.append(",");
				}
			}
			String[] legend = new String[] { "应收", "实收" };
			Map<String, List<String>> map = new HashMap<String, List<String>>();
			map.put(legend[0], planList);
			map.put(legend[1], receList);
			// 指标
			for (int i = 0; i < legend.length; i++) {
				fact.append("{");
				fact.append("name:'").append(legend[i]).append("',");
				fact.append("data:[");
				List<String> valuelist = map.get(legend[i]);
				for (int j = 0; j < valuelist.size(); j++) {
					if (StringUtils.isNotNullOrEmptyStr(valuelist.get(j))) {
						// fact.append("{y:").append(valuelist.get(j)).append("}");
						fact.append("{y:").append(valuelist.get(j)).append(",");
						fact.append("url:'")
								.append("../../gathering/list?viewtype=analyticsview")
								.append("&month=")
								.append(URLEncoder.encode(dateList.get(j),
										"utf-8")).append("'}");
					} else {
						fact.append("{y:0}");
					}
					if (j != valuelist.size() - 1) {
						fact.append(",");
					}
				}
				fact.append("]");
				fact.append("}");
				if (i != legend.length - 1) {
					fact.append(",");
				}
			}
			dimession.append("]");
			fact.append("]");

			logger.info("dimession is ->" + dimession);
			logger.info("fact is ->" + fact);
			request.setAttribute("dimession", dimession);
			request.setAttribute("fact", fact);

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("gatheringList", gaList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("month", month);
		request.setAttribute("depart", depart);
		request.setAttribute("name", name);
		request.setAttribute("status", status);
		return "analytics/topic/gathering/gathering_month";
	}
	
	/**
	 * 异步回款月份
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/ajaxmonth")
	@ResponseBody
	public String ajaxgatheringAnalytics4Month(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String assignerId = request.getParameter("assignerId");
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		String viewtype = request.getParameter("viewtype");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_MONTH);
			analytics.setParam3(assignerId);
			if(StringUtils.isNotNullOrEmptyStr(name)){
				analytics.setParam5(name);
			}
			if(StringUtils.isNotNullOrEmptyStr(status)){
				analytics.setParam6(status);
			}
			if(StringUtils.isNotNullOrEmptyStr(viewtype)){
				analytics.setParam7(viewtype);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Month(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 回款分析(部门)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/depart")
	public String receivableAnalytics4Depart(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String month = request.getParameter("month");
		String source = request.getParameter("source");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String viewtype = request.getParameter("viewtype");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_DEPART);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (depart != null && !"".equals(depart)) {
				analytics.setParam4(depart);
			}
			if (month != null && !"".equals(month)) {
				analytics.setParam5(month);
			}
			if(StringUtils.isNotNullOrEmptyStr(name)){
				analytics.setParam6(name);
			}
			if(StringUtils.isNotNullOrEmptyStr(status)){
				analytics.setParam7(status);
			}
			if(StringUtils.isNotNullOrEmptyStr(viewtype)){
				analytics.setParam8(viewtype);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Depart(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			// 维度
			StringBuffer dimession = new StringBuffer();
			StringBuffer fact = new StringBuffer();
			dimession.append("[");
			fact.append("[");
			List<String> planList = new ArrayList<String>();
			List<String> receList = new ArrayList<String>();
			List<String> depList = new ArrayList<String>();
			List<String> marList = new ArrayList<String>();
			List<AnalyticsReceivableResp> gaList = new ArrayList<AnalyticsReceivableResp>();
			for (AnalyticsReceivableResp resp : cList) {
				AnalyticsReceivableResp aresp = new AnalyticsReceivableResp();
				if (StringUtils.isNotNullOrEmptyStr(resp.getDepart())) {
					depList.add(resp.getDepart());
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getPlanAmount())) {
					String planAmount = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getPlanAmount()));
					planList.add(planAmount);
					aresp.setPlanAmount(planAmount);
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getActAmount())) {
					String actAmount = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getActAmount()));
					receList.add(actAmount);
					aresp.setActAmount(actAmount);
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getMargin())) {
					String margin = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getMargin()));
					marList.add(margin);
					aresp.setMargin(margin);
				}
				aresp.setDepart(resp.getDepart());
				gaList.add(aresp);
			}

			// 维度
			for (int i = 0; i < depList.size(); i++) {
				dimession.append("'").append(depList.get(i)).append("'");
				if (i != depList.size() - 1) {
					dimession.append(",");
				}
			}
			String[] legend = new String[] { "应收", "实收" };
			Map<String, List<String>> map = new HashMap<String, List<String>>();
			map.put(legend[0], planList);
			map.put(legend[1], receList);
			// 指标
			for (int i = 0; i < legend.length; i++) {
				fact.append("{");
				fact.append("name:'").append(legend[i]).append("',");
				fact.append("data:[");
				List<String> valuelist = map.get(legend[i]);
				for (int j = 0; j < valuelist.size(); j++) {
					if (StringUtils.isNotNullOrEmptyStr(valuelist.get(j))) {
						fact.append("{y:").append(valuelist.get(j)).append(",");
						fact.append("url:'")
								.append("../../gathering/list?viewtype=analyticsview")
								.append("&depart=")
								.append(URLEncoder.encode(depList.get(j),
										"utf-8")).append("'}");
					} else {
						fact.append("{y:0}");
					}
					if (j != valuelist.size() - 1) {
						fact.append(",");
					}
				}
				fact.append("]");
				fact.append("}");
				if (i != legend.length - 1) {
					fact.append(",");
				}
			}
			dimession.append("]");
			fact.append("]");

			logger.info("dimession is ->" + dimession);
			logger.info("fact is ->" + fact);
			request.setAttribute("dimession", dimession);
			request.setAttribute("fact", fact);

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																	// 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("gatheringList", gaList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("month", month);
		request.setAttribute("depart", depart);
		request.setAttribute("name", name);
		request.setAttribute("status", status);
		return "analytics/topic/gathering/gathering_department";
	}

	
	/**
	 * 异步回款部门分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/ajaxdepartment")
	@ResponseBody
	public String ajaxgatheringAnalytics4Depart(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String assignerId = request.getParameter("assignerId");
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		String viewtype = request.getParameter("viewtype");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_DEPART);
			analytics.setParam3(assignerId);
			if(StringUtils.isNotNullOrEmptyStr(name)){
				analytics.setParam6(name);
			}
			if(StringUtils.isNotNullOrEmptyStr(status)){
				analytics.setParam7(status);
			}
			if(StringUtils.isNotNullOrEmptyStr(viewtype)){
				analytics.setParam8(viewtype);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Depart(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}
	
	/**
	 * 回款分析(客户)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/customer")
	public String receivableAnalytics4Customer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String month = request.getParameter("month");
		String source = request.getParameter("source");
		String customer = request.getParameter("customer");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null != customer && !"".equals(customer)) {
			customer = new String(customer.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_CUSTOMER);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (depart != null && !"".equals(depart)) {
				analytics.setParam4(depart);
			}
			if (month != null && !"".equals(month)) {
				analytics.setParam5(month);
			}
			if (customer != null && !"".equals(customer)) {
				analytics.setParam6(customer);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Customer(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<AnalyticsReceivableResp> gaList = new ArrayList<AnalyticsReceivableResp>();
			String totalPlanAmount = "";
			String totalActAmount = "";
			String totalMargin = "";
			for (AnalyticsReceivableResp resp : cList) {
				AnalyticsReceivableResp gaResp = new AnalyticsReceivableResp();
				if (StringUtils.isNotNullOrEmptyStr(resp.getPlanAmount())) {
					String planAmount = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getPlanAmount()));
					gaResp.setPlanAmount(planAmount);
					if ("".equals(totalPlanAmount)) {
						totalPlanAmount = planAmount;
					} else {
						totalPlanAmount = StringUtils.addAmount(
								totalPlanAmount, planAmount);
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getActAmount())) {
					String actAmount = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getActAmount()));
					gaResp.setActAmount(actAmount);
					if ("".equals(totalActAmount)) {
						totalActAmount = actAmount;
					} else {
						totalActAmount = StringUtils.addAmount(totalActAmount,
								actAmount);
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getMargin())) {
					String margin = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getMargin()));
					gaResp.setMargin(margin);
					if ("".equals(totalMargin)) {
						totalMargin = margin;
					} else {
						totalMargin = StringUtils
								.addAmount(totalMargin, margin);
					}
				}
				gaResp.setCustomer(resp.getCustomer());
				gaResp.setAssigner(resp.getAssigner());
				gaResp.setCustomerId(resp.getCustomerId());
				gaList.add(gaResp);
			}

			AnalyticsReceivableResp aresp = new AnalyticsReceivableResp();
			aresp.setCustomer("合计");
			aresp.setPlanAmount(totalPlanAmount);
			aresp.setActAmount(totalActAmount);
			aresp.setMargin(totalMargin);
			gaList.add(aresp);

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
			request.setAttribute("gatheringList", gaList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("month", month);
		request.setAttribute("depart", depart);
		request.setAttribute("customer", customer);

		return "analytics/topic/gathering/gathering_customer";
	}

	/**
	 * 异常回款分析(已核销但是钱未全部到账)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gathering/unusual")
	public String receivableAnalytics4Unusual(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String month = request.getParameter("month");
		String source = request.getParameter("source");

		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("UTF-8"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("UTF-8"), "UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_RECEIVABLE);
			analytics.setReport(Constants.ANALYTICS_REPORT_RECEIVABLE_UNUSUAL);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			if (depart != null && !"".equals(depart)) {
				analytics.setParam4(depart);
			}
			if (month != null && !"".equals(month)) {
				analytics.setParam5(month);
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Unusual(analytics);
			List<AnalyticsReceivableResp> cList = cResp.getReceList();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			List<AnalyticsReceivableResp> gaList = new ArrayList<AnalyticsReceivableResp>();
			for (AnalyticsReceivableResp resp : cList) {
				AnalyticsReceivableResp gaResp = new AnalyticsReceivableResp();
				if (StringUtils.isNotNullOrEmptyStr(resp.getPlanAmount())) {
					gaResp.setPlanAmount(StringUtils.repAmount(resp
							.getPlanAmount()));
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getActAmount())) {
					gaResp.setActAmount(StringUtils.repAmount(resp
							.getActAmount()));
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getMargin())) {
					gaResp.setMargin(StringUtils.repAmount(resp.getMargin()));
				}
				gaResp.setCustomer(resp.getCustomer());
				gaResp.setAssigner(resp.getAssigner());
				gaList.add(gaResp);
			}
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
			request.setAttribute("gatheringList", gaList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/gathering/gathering_unusual";
	}

	/**
	 * 测试drilldown
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/test/drilldown")
	public String testDrilldown(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_PIPELINE);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}


		return "analytics/topic/test/test_drilldown";
	}

	/**
	 * 业务机会分析(销售阶段)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/oppty/salestage")
	public String opptyAnalyticsOppty4Salestage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// param
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		// 检测绑定
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_OPPTY);
			analytics.setReport(Constants.ANALYTICS_REPORT_OPPTY_RESIDENCE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询业务机会列表
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.opptyAnalyticsOppty4Salestage(analytics);
			List<AnalyticsOpptyResp> oList = cResp.getOpptyList();
			logger.info("oList is ->" + oList.size());
			if (null == oList || oList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");

				request.setAttribute("opptyList", oList);
			}
			logger.info("opptyAnalyticsOppty4Salestage params startDate  is ->"
					+ startDate);
			logger.info("opptyAnalyticsOppty4Salestage params endDate  is ->"
					+ endDate);
			logger.info("opptyAnalyticsOppty4Salestage params assignerId  is ->"
					+ assignerId);
			logger.info("opptyAnalyticsOppty4Salestage params addAssigner  is ->"
					+ addAssigner);
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("assignerId", assignerId);
		return "analytics/topic/oppty/oppty_salestage";
	}

	/**
	 * 客户行业分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/industry")
	public String expenseAnalytics2Industry(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String depart = request.getParameter("depart");
		String subtype = request.getParameter("subtype");
		String type = request.getParameter("type");
		String source = request.getParameter("source");
		String viewtype = request.getParameter("analyticsview");
		String industry = request.getParameter("industry");
		if (null != depart && !"".equals(depart)) {
			depart = new String(depart.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (null != source && !"".equals(source)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_REPORT_CUSTOMER_INDUSTRY);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(depart);
			analytics.setParam5(subtype);
			analytics.setParam6(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Industry(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			logger.info("cList is ->" + cList.size());

			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
				request.setAttribute("clist", JSONArray.fromObject(cList));
			}

			AnalyticsCustomeryResp resp = null;
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getIndustryname() + "',"
						+ resp.getCustomerNumber() + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
			}

			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);

			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																	// 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());

			request.setAttribute("expenseList", cList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("depart", depart);
		request.setAttribute("subtype", subtype);
		request.setAttribute("type", type);
		request.setAttribute("analyticsview", viewtype);
		request.setAttribute("industry", industry);

		return "analytics/topic/customer/customer_industry";
	}
	
	
	/**
	 * 异步客户行业分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/ajaxindustry")
	@ResponseBody
	public String ajaxcustomerAnalytics4Industry(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String str="";
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String viewtype = request.getParameter("viewtype");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_REPORT_CUSTOMER_INDUSTRY);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setParam4(viewtype);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsReceivable4Industry(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 潜在客户时间分析
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/customer/latent")
	public String expenseAnalytics1Subtype(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");

		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		}

		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}

		logger.info("expenseAnalytics4type params startDate  is ->" + startDate);
		logger.info("expenseAnalytics4type params endDate  is ->" + endDate);
		logger.info("expenseAnalytics4type params assignerId  is ->"
				+ assignerId);
		logger.info("expenseAnalytics4type params addAssigner  is ->"
				+ addAssigner);

		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CUSTOMER);
			analytics.setReport(Constants.ANALYTICS_REPORT_CUSTOMER_LEADS);
			if (null != startDate && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (null != endDate && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsReceivable4Latent(analytics);
			List<AnalyticsCustomeryResp> cList = cResp.getCustomerList();
			logger.info("cList is ->" + cList.size());

			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}

			AnalyticsCustomeryResp resp = null;
			List<String> dateList = new ArrayList<String>();
			String dataStr = "";
			for (int i = 0; i < cList.size(); i++) {
				resp = cList.get(i);
				dataStr += "['" + resp.getDuration() + "',"
						+ resp.getCustomerNumber() + "]";
				if (i != cList.size() - 1) {
					dataStr += ",";
				}
				dateList.add(resp.getDuration());
			}

			StringBuffer dimession = new StringBuffer();
			// 维度
			for (int i = 0; i < dateList.size(); i++) {
				dimession.append("'").append(dateList.get(i)).append("'");
				if (i != dateList.size() - 1) {
					dimession.append(",");
				}
			}

			logger.info("fact is ->" + dataStr);
			request.setAttribute("fact", dataStr);
			request.setAttribute("dimession", dimession);

			// 用户对象
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候 查询
																	// 我团队的用户
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
			request.setAttribute("expenseList", cList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);

		return "analytics/topic/customer/customer_latent";
	}

	/**
	 * 销售目标分析(季度)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/quota/quarter")
	public String quotaAnalytics4Quarter(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		String source = request.getParameter("source");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (StringUtils.isNotNullOrEmptyStr(addAssigner)
					&& !StringUtils.regZh(addAssigner)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_QUOTA);
			analytics.setReport(Constants.ANALYTICS_REPORT_QUOTA_QUARTER);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsQuota4Quarter(analytics);
			List<AnalyticsQuotaResp> cList = cResp.getQuotas();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			// 维度
			StringBuffer dimession = new StringBuffer();
			StringBuffer fact = new StringBuffer();
			dimession.append("[");
			fact.append("[");
			List<String> quatList = new ArrayList<String>();
			List<String> receList = new ArrayList<String>();
			List<String> dateList = new ArrayList<String>();
			Map<String, List<AnalyticsQuotaResp>> map = new HashMap<String, List<AnalyticsQuotaResp>>();
			String quarter = "";
			List<AnalyticsQuotaResp> aqlist = new ArrayList<AnalyticsQuotaResp>();
			for (int i = 0; i < cList.size(); i++) {
				AnalyticsQuotaResp resp = cList.get(i);
				boolean flag = true;
				AnalyticsQuotaResp aqresp = new AnalyticsQuotaResp();
				if (StringUtils.isNotNullOrEmptyStr(resp.getEnddate())) {
					quarter = DateTime.date2qua(resp.getEnddate());
				}
				if (map.keySet() != null && map.keySet().size() > 0
						&& !map.keySet().contains(quarter)) {
					aqlist = new ArrayList<AnalyticsQuotaResp>();
					flag = false;
				}
				aqresp.setEnddate(resp.getEnddate());
				aqresp.setStartdate(resp.getStartdate());
				aqresp.setQuotaamt(resp.getQuotaamt());
				aqresp.setRecamt(resp.getRecamt());
				if (StringUtils.isNotNullOrEmptyStr(quarter)) {
					if (i == 0 || !flag) {
						aqlist.add(aqresp);
						map.put(quarter, aqlist);
					} else {
						List<AnalyticsQuotaResp> lists = map.get(quarter);
						lists.add(aqresp);
						map.put(quarter, lists);
					}
				}
			}
			String totalPlanAmount = "";
			String totalActAmount = "";
			List<AnalyticsQuotaResp> quList = new ArrayList<AnalyticsQuotaResp>();
			List<String> strList = new ArrayList<String>();
			for (String key : map.keySet()) {
				strList.add(key);
			}
			for (int i = strList.size() - 1; i >= 0; i--) {
				String key = strList.get(i);
				AnalyticsQuotaResp aresp = new AnalyticsQuotaResp();
				String growthrate = "";
				String toquotaamt = "";
				String toactamount = "";
				dateList.add(key);
				aresp.setQuarter(key);
				for (AnalyticsQuotaResp resp : map.get(key)) {
					if (StringUtils.isNotNullOrEmptyStr(resp.getQuotaamt())) {
						String quotaamt = StringUtils.repAmount(StringUtils
								.replaceStr(resp.getQuotaamt()));
						if ("".equals(toquotaamt)) {
							toquotaamt = quotaamt;
						} else {
							toquotaamt = StringUtils.addAmount(toquotaamt,
									quotaamt);
						}
					}
					if (StringUtils.isNotNullOrEmptyStr(resp.getRecamt())) {
						String actAmount = StringUtils.repAmount(StringUtils
								.replaceStr(resp.getRecamt()));
						if ("".equals(toactamount)) {
							toactamount = actAmount;
						} else {
							toactamount = StringUtils.addAmount(toactamount,
									actAmount);
						}
					}
				}
				quatList.add(toquotaamt);
				aresp.setQuotaamt(toquotaamt);
				receList.add(toactamount);
				aresp.setRecamt(toactamount);
				if ("".equals(totalPlanAmount)) {
					totalPlanAmount = toquotaamt;
				} else {
					totalPlanAmount = StringUtils.addAmount(totalPlanAmount,
							toquotaamt);
				}
				if ("".equals(totalActAmount)) {
					totalActAmount = toactamount;
				} else {
					totalActAmount = StringUtils.addAmount(totalActAmount,
							toactamount);
				}
				if (StringUtils.isNotNullOrEmptyStr(toquotaamt)
						&& StringUtils.isNotNullOrEmptyStr(toactamount)) {
					growthrate = StringUtils.divAmount(toactamount, toquotaamt,
							4);
					aresp.setGrowthrate(growthrate);
				}
				quList.add(aresp);
			}
			// 维度
			for (int i = 0; i < dateList.size(); i++) {
				dimession.append("'").append(dateList.get(i)).append("'");
				if (i != dateList.size() - 1) {
					dimession.append(",");
				}
			}
			String[] legend = new String[] { "预期", "实际" };
			Map<String, List<String>> map1 = new HashMap<String, List<String>>();
			map1.put(legend[0], quatList);
			map1.put(legend[1], receList);
			// 指标
			for (int i = 0; i < legend.length; i++) {
				fact.append("{");
				fact.append("name:'").append(legend[i]).append("',");
				fact.append("data:[");
				List<String> valuelist = map1.get(legend[i]);
				for (int j = 0; j < valuelist.size(); j++) {
					if (StringUtils.isNotNullOrEmptyStr(valuelist.get(j))) {
						fact.append("{y:").append(valuelist.get(j)).append("}");
					} else {
						fact.append("{y:0}");
					}
					if (j != valuelist.size() - 1) {
						fact.append(",");
					}
				}
				fact.append("]");
				fact.append("}");
				if (i != legend.length - 1) {
					fact.append(",");
				}
			}
			dimession.append("]");
			fact.append("]");

			logger.info("dimession is ->" + dimession);
			logger.info("fact is ->" + fact);
			request.setAttribute("dimession", dimession);
			request.setAttribute("fact", fact);

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
			AnalyticsQuotaResp aresp = new AnalyticsQuotaResp();
			aresp.setQuarter("合计");
			aresp.setQuotaamt(totalPlanAmount);
			aresp.setRecamt(totalActAmount);
			String gstr = "";
			if (StringUtils.isNotNullOrEmptyStr(totalActAmount)
					&& StringUtils.isNotNullOrEmptyStr(totalPlanAmount)) {
				gstr = StringUtils.divAmount(
						StringUtils.replaceStr(totalActAmount),
						StringUtils.replaceStr(totalPlanAmount), 4);
			}
			aresp.setGrowthrate(gstr);
			quList.add(aresp);
			request.setAttribute("quotaList", quList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/quota/quota_quarter";
	}

	/**
	 * 销售目标分析(月份)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/quota/month")
	public String quotaAnalytics4Month(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// search param
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerId = request.getParameter("assignerId");
		String addAssigner = request.getParameter("addAssigner");
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (StringUtils.isNotNullOrEmptyStr(addAssigner)
					&& !StringUtils.regZh(addAssigner)) {
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),
						"UTF-8");
			}
		}
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_QUOTA);
			analytics.setReport(Constants.ANALYTICS_REPORT_QUOTA_MONTH);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerId);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			// 查询返回结果
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService()
					.getAnalyticsQuota4Month(analytics);
			List<AnalyticsQuotaResp> cList = cResp.getQuotas();
			logger.info("cList is ->" + cList.size());
			if (null == cList || cList.size() == 0) {
				request.setAttribute("dataFlg", "no");
			} else {
				request.setAttribute("dataFlg", "yes");
			}
			// 维度
			StringBuffer dimession = new StringBuffer();
			StringBuffer fact = new StringBuffer();
			dimession.append("[");
			fact.append("[");
			List<String> quatList = new ArrayList<String>();
			List<String> receList = new ArrayList<String>();
			List<String> dateList = new ArrayList<String>();
			String totalPlanAmount = "";
			String totalActAmount = "";
			List<AnalyticsQuotaResp> quList = new ArrayList<AnalyticsQuotaResp>();
			for (AnalyticsQuotaResp resp : cList) {
				AnalyticsQuotaResp aresp = new AnalyticsQuotaResp();
				String growthrate = "";
				if (StringUtils.isNotNullOrEmptyStr(resp.getMonth())) {
					dateList.add(resp.getMonth());
					aresp.setMonth(resp.getMonth());
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getQuotaamt())) {
					String quotaamt = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getQuotaamt()));
					quatList.add(quotaamt);
					aresp.setQuotaamt(quotaamt);
					if ("".equals(totalPlanAmount)) {
						totalPlanAmount = quotaamt;
					} else {
						totalPlanAmount = StringUtils.addAmount(
								totalPlanAmount, quotaamt);
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getRecamt())) {
					String actAmount = StringUtils.repAmount(StringUtils
							.replaceStr(resp.getRecamt()));
					receList.add(actAmount);
					aresp.setRecamt(actAmount);
					if ("".equals(totalActAmount)) {
						totalActAmount = actAmount;
					} else {
						totalActAmount = StringUtils.addAmount(totalActAmount,
								actAmount);
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(resp.getQuotaamt())
						&& StringUtils.isNotNullOrEmptyStr(resp.getQuotaamt())) {
					growthrate = StringUtils.divAmount(
							StringUtils.replaceStr(resp.getRecamt()),
							StringUtils.replaceStr(resp.getQuotaamt()), 4);
					aresp.setGrowthrate(growthrate);
				}
				quList.add(aresp);
			}
			// 维度
			for (int i = 0; i < dateList.size(); i++) {
				dimession.append("'").append(dateList.get(i)).append("'");
				if (i != dateList.size() - 1) {
					dimession.append(",");
				}
			}
			String[] legend = new String[] { "预期", "实际" };
			Map<String, List<String>> map = new HashMap<String, List<String>>();
			map.put(legend[0], quatList);
			map.put(legend[1], receList);
			// 指标
			for (int i = 0; i < legend.length; i++) {
				fact.append("{");
				fact.append("name:'").append(legend[i]).append("',");
				fact.append("data:[");
				List<String> valuelist = map.get(legend[i]);
				for (int j = 0; j < valuelist.size(); j++) {
					if (StringUtils.isNotNullOrEmptyStr(valuelist.get(j))) {
						// fact.append("{y:").append(valuelist.get(j)).append("}");
						fact.append("{y:").append(valuelist.get(j)).append("}");
					} else {
						fact.append("{y:0}");
					}
					if (j != valuelist.size() - 1) {
						fact.append(",");
					}
				}
				fact.append("]");
				fact.append("}");
				if (i != legend.length - 1) {
					fact.append(",");
				}
			}
			dimession.append("]");
			fact.append("]");

			logger.info("dimession is ->" + dimession);
			logger.info("fact is ->" + fact);
			request.setAttribute("dimession", dimession);
			request.setAttribute("fact", fact);

			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute(
					"userList",
					uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp
							.getUsers());
			AnalyticsQuotaResp aresp = new AnalyticsQuotaResp();
			aresp.setMonth("合计");
			aresp.setQuotaamt(totalPlanAmount);
			aresp.setRecamt(totalActAmount);
			String gstr = "";
			if (StringUtils.isNotNullOrEmptyStr(totalActAmount)
					&& StringUtils.isNotNullOrEmptyStr(totalPlanAmount)) {
				gstr = StringUtils.divAmount(
						StringUtils.replaceStr(totalActAmount),
						StringUtils.replaceStr(totalPlanAmount), 4);
			}
			aresp.setGrowthrate(gstr);
			quList.add(aresp);
			request.setAttribute("quotaList", quList);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignerId", assignerId);
		request.setAttribute("addAssigner", addAssigner);
		return "analytics/topic/quota/quota_month";
	}
	
	/**
	 * 服务请求按照月份统计(异步加载数据)
	 * @return
	 */
	@RequestMapping("/complaint/asymonth")
	@ResponseBody
	public String complaint4AsyMonth(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String str="";
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerid = request.getParameter("assignerId");
		String type=request.getParameter("servertype");
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("AnalyticsController complaint4AsyMonth startDate ==>"+startDate);
		logger.info("AnalyticsController complaint4AsyMonth endDate ==>"+endDate);
		logger.info("AnalyticsController complaint4AsyMonth assignerid ==>"+assignerid);
		logger.info("AnalyticsController complaint4AsyMonth type ==>"+type);
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CASE);
			analytics.setReport(Constants.ANALYTICS_REPORT_SR_MONTH);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			analytics.setParam3(assignerid);
			analytics.setParam4(type);
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsComplaint4Month(analytics);
			List<AnalyticsComplaintResp> cList = cResp.getComplaints();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 服务请求按照月份统计
	 * @return
	 */
	@RequestMapping("/complaint/month")
	public String complaint4Month(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String servertype=request.getParameter("servertype");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String addAssigner = request.getParameter("addAssigner");
		logger.info("AnalyticsController complaint4Month servertype ==>"+servertype);
		if (null != crmId && !"".equals(crmId)) {
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList",uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_MSG_UNBIND);
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (StringUtils.isNotNullOrEmptyStr(addAssigner)&& !StringUtils.regZh(addAssigner)) {
					addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		int year = Calendar.getInstance().get(Calendar.YEAR);
		String startDate = year + "-01";
		String endDate = year + "-12";
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("type", servertype);
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		return "analytics/topic/complaint/complaint_month";
	}
	
	 /** 
	  * 服务请求按照类型统计(异步加载数据)
	  * @return
	  */
	@RequestMapping("/complaint/asytype")
	@ResponseBody
	public String complaint4AsyType(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String str="";
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerid = request.getParameter("assignerId");
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String type=request.getParameter("servertype");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("AnalyticsController complaint4AsyType startDate ==>"+startDate);
		logger.info("AnalyticsController complaint4AsyType endDate ==>"+endDate);
		logger.info("AnalyticsController complaint4AsyType assignerid ==>"+assignerid);
		logger.info("AnalyticsController complaint4AsyType type ==>"+type);
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CASE);
			analytics.setReport(Constants.ANALYTICS_REPORT_SR_TYPE);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerid);
			analytics.setParam4(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsComplaint4Subtype(analytics);
			List<AnalyticsComplaintResp> cList = cResp.getComplaints();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 服务请求按照类型统计
	 * @return
	 */
	@RequestMapping("/complaint/subtype")
	public String complaint4Subtype(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String addAssigner = request.getParameter("addAssigner");
		String servertype=request.getParameter("servertype");
		logger.info("AnalyticsController complaint4Subtype servertype ==>"+servertype);
		if (null != crmId && !"".equals(crmId)) {
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList",uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_MSG_UNBIND);
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (StringUtils.isNotNullOrEmptyStr(addAssigner)&& !StringUtils.regZh(addAssigner)) {
					addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		int year = Calendar.getInstance().get(Calendar.YEAR);
		String startDate = year + "-01";
		String endDate = year + "-12";
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("type", servertype);
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		return "analytics/topic/complaint/complaint_subtype";
	}
	
	/** 
	  * 服务请求按照类型统计(异步加载数据)
	  * @return
	  */
	@RequestMapping("/complaint/asydepart")
	@ResponseBody
	public String complaint4AsyDepart(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String str="";
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignerid = request.getParameter("assignerid");
		if (null == startDate && null == endDate) {
			int year = Calendar.getInstance().get(Calendar.YEAR);
			startDate = year + "-01";
			endDate = year + "-12";
		}
		if (null != startDate && !"".equals(startDate)
				&& startDate.length() >= 7) {
			startDate = startDate.substring(0, 7);
		}
		if (null != endDate && !"".equals(endDate) && endDate.length() >= 7) {
			endDate = endDate.substring(0, 7);
		}
		String type=request.getParameter("servertype");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("AnalyticsController complaint4AsyDepart startDate ==>"+startDate);
		logger.info("AnalyticsController complaint4AsyDepart endDate ==>"+endDate);
		logger.info("AnalyticsController complaint4AsyDepart assignerid ==>"+assignerid);
		logger.info("AnalyticsController complaint4AsyDepart type ==>"+type);
		if (null != crmId && !"".equals(crmId)) {
			Analytics analytics = new Analytics();
			analytics.setCrmId(crmId);
			analytics.setTopic(Constants.ANALYTICS_TOPIC_CASE);
			analytics.setReport(Constants.ANALYTICS_REPORT_SR_DEPART);
			if (startDate != null && !"".equals(startDate)) {
				analytics.setParam1(startDate.replaceAll("-", ""));
			}
			if (endDate != null && !"".equals(endDate)) {
				analytics.setParam2(endDate.replaceAll("-", ""));
			}
			analytics.setParam3(assignerid);
			analytics.setParam4(type);
			analytics.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			AnalyticsResp cResp = cRMService.getSugarService().getAnalyticsService().getAnalyticsComplaint4Depart(analytics);
			List<AnalyticsComplaintResp> cList = cResp.getComplaints();
			if (null == cList || cList.size() == 0) {
				str = "";
			} else {
				str = JSONArray.fromObject(cList).toString();
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return str;
	}

	/**
	 * 服务请求按照部门统计
	 * @return
	 */
	@RequestMapping("/complaint/depart")
	public String complaint4Depart(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String addAssigner = request.getParameter("addAssigner");
		String servertype=request.getParameter("servertype");
		logger.info("AnalyticsController complaint4Depart servertype ==>"+servertype);
		if (null != crmId && !"".equals(crmId)) {
			UserReq uReq = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList",uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_MSG_UNBIND);
		}
		if (null == addAssigner || "".equals(addAssigner)) {
			addAssigner = "所有人";
		} else {
			if (StringUtils.isNotNullOrEmptyStr(addAssigner)&& !StringUtils.regZh(addAssigner)) {
					addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		int year = Calendar.getInstance().get(Calendar.YEAR);
		String startDate = year + "-01";
		String endDate = year + "-12";
		request.setAttribute("addAssigner", addAssigner);
		request.setAttribute("type", servertype);
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		return "analytics/topic/complaint/complaint_depart";
	}
	
	/**
	 * 公共页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String common(HttpServletRequest request,HttpServletResponse response)throws Exception{
		return "analytics/common/common";
	}
}
