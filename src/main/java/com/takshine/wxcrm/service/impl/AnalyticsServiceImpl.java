package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Analytics;
import com.takshine.wxcrm.domain.IndexKPI;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.sugar.AnalyticsComplaintResp;
import com.takshine.wxcrm.message.sugar.AnalyticsContactResp;
import com.takshine.wxcrm.message.sugar.AnalyticsCustomeryResp;
import com.takshine.wxcrm.message.sugar.AnalyticsExpenseResp;
import com.takshine.wxcrm.message.sugar.AnalyticsOpptyResp;
import com.takshine.wxcrm.message.sugar.AnalyticsQuotaResp;
import com.takshine.wxcrm.message.sugar.AnalyticsReceivableResp;
import com.takshine.wxcrm.message.sugar.AnalyticsReq;
import com.takshine.wxcrm.message.sugar.AnalyticsResp;
import com.takshine.wxcrm.service.AnalyticsService;
import com.takshine.wxcrm.service.LovUser2SugarService;

/**
 * 报表   相关业务接口实现
 *
 */
@Service("analyticsService")
public class AnalyticsServiceImpl extends BaseServiceImpl implements AnalyticsService {
	
	private static Logger log = Logger.getLogger(AnalyticsServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	

	/**
	 * 业务机会-业务机会阶段统计分析表
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsOppty4Stage(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsOpptyResp> rstList = new ArrayList<AnalyticsOpptyResp>();
		Map<String, AnalyticsOpptyResp> map = new HashMap<String, AnalyticsOpptyResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			//转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsOppty4Stage jsonStr => jsonStr is : " + jsonStr);
			//单次调用sugar接口 
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			//做空判断
			if(null == rst || "".equals(rst)){
				continue;
			}
			//解析JSON数据
			log.info("getAnalyticsOppty4Stage for stage List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
					if (null != opptyList && opptyList.size() > 0) {
						for (int j = 0; j < opptyList.size(); j++) {
							AnalyticsOpptyResp analyticsOpptyResp = opptyList.get(j);
							String opptyStage = analyticsOpptyResp.getOpptyStage();
							String opptyAmount = analyticsOpptyResp.getOpptyAmount();
							String opptyDate = analyticsOpptyResp.getOpptyDate();
							String key = opptyStage+opptyDate;
							if(map.keySet()!=null && map.keySet().contains(key)){
								analyticsOpptyResp = map.get(key);
								opptyAmount = StringUtils.addAmount(analyticsOpptyResp.getOpptyAmount(),opptyAmount);
								analyticsOpptyResp.setOpptyAmount(opptyAmount);
							}
							map.put(key, analyticsOpptyResp);
						}
					}
				}
			}
		}
		if(map!=null&&map.size()>0){
			for(String key:map.keySet()){
				AnalyticsOpptyResp analyticsOpptyResp = map.get(key);
				rstList.add(analyticsOpptyResp);
			}
		}
		resp.setOpptyList(rstList);
		return resp;
	}

	
	/**
	 * 销售管道分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsOppty4SPipeline(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsOpptyResp> rstList = new ArrayList<AnalyticsOpptyResp>();
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(analytics.getCrmId());
		Map<String, String> sales_dom=mp.get("sales_stage_dom");
		Map<String, AnalyticsOpptyResp> map = new HashMap<String, AnalyticsOpptyResp>();
		
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsOppty4SPipeline jsonStr => jsonStr is : " + jsonStr);

			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);

			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}

			// 解析JSON数据
			log.info("getAnalyticsOppty4SPipeline for pipeline List rst => rst is : " + rst);

			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));

			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
					if (null != opptyList && opptyList.size() > 0) {
						for (int j = 0; j < opptyList.size(); j++) {
							AnalyticsOpptyResp analyticsOpptyResp = opptyList.get(j);
							String opptyStage = analyticsOpptyResp.getOpptyStage();
							String opptyAmount = analyticsOpptyResp.getOpptyAmount();
							if(map.keySet()!=null && map.keySet().contains(opptyStage)){
								analyticsOpptyResp = map.get(opptyStage);
								opptyAmount = StringUtils.addAmount(analyticsOpptyResp.getOpptyAmount(),opptyAmount);
								analyticsOpptyResp.setOpptyAmount(opptyAmount);
							}
							map.put(opptyStage, analyticsOpptyResp);
						}
					}
				}
			}
		}
		
		if(map!=null&&map.size()>0){
			for(String key:sales_dom.keySet()){
				AnalyticsOpptyResp analyticsOpptyResp = map.get(key);
				if(analyticsOpptyResp!=null){
				rstList.add(analyticsOpptyResp);
				}
			}
		}
		
		resp.setOpptyList(rstList);
		return resp;
	}

		
	/**
	 * 业务机会失败原因分析
	 */
	public AnalyticsResp getAnalyticsOppty4Failure(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsOpptyResp> rstList = new ArrayList<AnalyticsOpptyResp>();
		Map<String, AnalyticsOpptyResp> map = new HashMap<String, AnalyticsOpptyResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsOppty4Failure jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticsOppty4Failure for Failure List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
					if (null != opptyList && opptyList.size() > 0) {
						for (int j = 0; j < opptyList.size(); j++) {
							AnalyticsOpptyResp analyticsOpptyResp = opptyList.get(j);
							String opptyFailure = analyticsOpptyResp.getOpptyFailure();
							String opptyFailureName = analyticsOpptyResp.getOpptyFailurename();
							String opptyAmount = analyticsOpptyResp.getOpptyAmount();
							String key = opptyFailure+opptyFailureName;
							if(map.keySet()!=null && map.keySet().contains(key)){
								analyticsOpptyResp = map.get(key);
								opptyAmount = StringUtils.addAmount(analyticsOpptyResp.getOpptyAmount(),opptyAmount);
								analyticsOpptyResp.setOpptyAmount(opptyAmount);
							}
							map.put(key, analyticsOpptyResp);
						}
					}
				}
			}
		}
		if(map!=null&&map.size()>0){
			for(String key:map.keySet()){
				AnalyticsOpptyResp analyticsOpptyResp = map.get(key);
				rstList.add(analyticsOpptyResp);
			}
		}
		resp.setOpptyList(rstList);
		return resp;
	}
	
	
	/**
	 * 业务机会停留分析
	 */
	public AnalyticsResp opptyAnalyticsOppty4Salestage(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsOpptyResp> rstList = new ArrayList<AnalyticsOpptyResp>();

		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("opptyAnalyticsOppty4Salestage jsonStr => jsonStr is : " + jsonStr);

			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);

			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}

			// 解析JSON数据
			log.info("opptyAnalyticsOppty4Salestage for stageList rst => rst is : " + rst);

			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));

			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
					if (null != opptyList && opptyList.size() > 0) {
						for (int j = 0; j < opptyList.size(); j++) {
							rstList.add(opptyList.get(j));
						}
					}
				}
			}
		}
		resp.setOpptyList(rstList);
		return resp;
	}
    
	
	
	/**
	 * 客户行业分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Industry(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		
		//请求后台参数
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsCustomeryResp> rstList = new ArrayList<AnalyticsCustomeryResp>();
		Map<String, AnalyticsCustomeryResp> map = new HashMap<String, AnalyticsCustomeryResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsReceivable4Industry jsonStr => jsonStr is : " + jsonStr);

			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);

			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}

			// 解析JSON数据
			log.info("getAnalyticsReceivable4Industry for Industry List rst => rst is : " + rst);

			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));

			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsCustomeryResp> clist = (List<AnalyticsCustomeryResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsCustomeryResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							AnalyticsCustomeryResp analyticsCustomeryResp = clist.get(j);
							String industry = analyticsCustomeryResp.getIndustry();
							String customerNumber = analyticsCustomeryResp.getCustomerNumber();
							String industryname = analyticsCustomeryResp.getIndustryname();
							String key = industry+industryname;
							if(map.keySet()!=null && map.keySet().contains(key)){
								analyticsCustomeryResp = map.get(key);
								customerNumber = StringUtils.addAmount(analyticsCustomeryResp.getCustomerNumber(),customerNumber);
								analyticsCustomeryResp.setCustomerNumber(customerNumber);
							}
							map.put(key, analyticsCustomeryResp);
						}
					}
				}
			}
		}
		if(map!=null&&map.size()>0){
			for(String key:map.keySet()){
				AnalyticsCustomeryResp analyticsCustomeryResp = map.get(key);
				rstList.add(analyticsCustomeryResp);
			}
		}
		resp.setCustomerList(rstList);
		return resp;
	}

	
	/**
	 * 客户地理分布分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsCustomer4Distribute(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		//请求后台参数
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsCustomeryResp> rstList = new ArrayList<AnalyticsCustomeryResp>();
		Map<String, AnalyticsCustomeryResp> map = new HashMap<String, AnalyticsCustomeryResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsCustomer4Distribute jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticsCustomer4Distribute for Distribute List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsCustomeryResp> clist = (List<AnalyticsCustomeryResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsCustomeryResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							AnalyticsCustomeryResp analyticsCustomeryResp = clist.get(j);
							String province = analyticsCustomeryResp.getProvince();
							String customerNumber = analyticsCustomeryResp.getCustomerNumber();
							String key = "";
							if(StringUtils.isNotNullOrEmptyStr(province)){
								key ="未知";
							}else{
								key = province;
							}
							if(map.keySet()!=null && map.keySet().contains(key)){
								analyticsCustomeryResp = map.get(key);
								customerNumber = StringUtils.addAmount(analyticsCustomeryResp.getCustomerNumber(),customerNumber);
								analyticsCustomeryResp.setCustomerNumber(customerNumber);
							}
							map.put(key, analyticsCustomeryResp);
						}
					}
				}
			}
		}
		if(map!=null&&map.size()>0){
			for(String key:map.keySet()){
				AnalyticsCustomeryResp analyticsCustomeryResp = map.get(key);
				rstList.add(analyticsCustomeryResp);
			}
		}
		resp.setCustomerList(rstList);
		return resp;
	}
	
	
	/**
	 * 客户贡献分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticCustomer4Contribution(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam8(analytics.getParam8());
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsCustomeryResp> rstList = new ArrayList<AnalyticsCustomeryResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticCustomer4Contribution jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticCustomer4Contribution for Contribution List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsCustomeryResp> clist = (List<AnalyticsCustomeryResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsCustomeryResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							rstList.add(clist.get(j));
						}
					}
				}
			}
		}
		if(rstList.size() > 0){
			// 字符串排序
		    Collections.sort(rstList, new Comparator() {
		      public int compare(Object o1, Object o2) {
		    	  return ((AnalyticsCustomeryResp)o2).getValue().compareTo(((AnalyticsCustomeryResp)o1).getValue());
		      }
		    });
		    if(rstList.size()>10){
		    	rstList = rstList.subList(0,10);
		    }
		}
		resp.setCustomerList(rstList);
		return resp;
	}
	
	/**
	 * 客户未来业务机会分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsCustomer4Futureoppty(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam7(analytics.getParam7());
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsCustomeryResp> rstList = new ArrayList<AnalyticsCustomeryResp>();

		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsCustomer4Futureoppty jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticsCustomer4Futureoppty for Futureoppty List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsCustomeryResp> clist = (List<AnalyticsCustomeryResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsCustomeryResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							rstList.add(clist.get(j));
						}
					}
				}
			}
		}
		if(rstList.size() > 0){
			// 字符串排序
		    Collections.sort(rstList, new Comparator() {
		      public int compare(Object o1, Object o2) {
		    	  return ((AnalyticsCustomeryResp)o2).getValue().compareTo(((AnalyticsCustomeryResp)o1).getValue());
		      }
		    });
		    if(rstList.size()>10){
		    	rstList = rstList.subList(0,10);
		    }
		}
		resp.setCustomerList(rstList);
		return resp;
	}
	

	/**
	 * 回款分析-by月份
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Month(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam7(analytics.getParam7());
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsReceivableResp> rstList = new ArrayList<AnalyticsReceivableResp>();
		Map<String, AnalyticsReceivableResp> map = new HashMap<String, AnalyticsReceivableResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsReceivable4Month jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticsReceivable4Month for Month List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsReceivableResp> clist = (List<AnalyticsReceivableResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsReceivableResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							AnalyticsReceivableResp analyticsReceivableResp = clist.get(j);
							String month = analyticsReceivableResp.getMonth();
							String planAmount = analyticsReceivableResp.getPlanAmount();
							String actAmount = analyticsReceivableResp.getActAmount();
							String margin = analyticsReceivableResp.getMargin();
							if(map.keySet()!=null && map.keySet().contains(month)){
								analyticsReceivableResp = map.get(month);
								planAmount = StringUtils.addAmount(analyticsReceivableResp.getPlanAmount(),planAmount);
								actAmount = StringUtils.addAmount(analyticsReceivableResp.getActAmount(),actAmount);
								margin = StringUtils.addAmount(analyticsReceivableResp.getMargin(),margin);
								analyticsReceivableResp.setPlanAmount(planAmount);
								analyticsReceivableResp.setActAmount(actAmount);
								analyticsReceivableResp.setMargin(margin);
							}
							map.put(month, analyticsReceivableResp);
						}
					}
				}
			}
		}
		if(map!=null&&map.size()>0){
			for(String key:map.keySet()){
				AnalyticsReceivableResp analyticsReceivableResp = map.get(key);
				rstList.add(analyticsReceivableResp);
			}
		}
		resp.setReceList(rstList);
		return resp;
	}
	
	
	/**
	 * 回款分析-by客户
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Customer(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		
		// 分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(analytics.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsReceivableResp> rstList = new ArrayList<AnalyticsReceivableResp>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getAnalyticsReceivable4Customer jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getAnalyticsReceivable4Customer for Customer List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsReceivableResp> clist = (List<AnalyticsReceivableResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsReceivableResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							rstList.add(clist.get(j));
						}
					}
				}
			}
		}
		resp.setReceList(rstList);
		return resp;
	}
	
	/**
	 * 首页kpi
	 */
	public IndexKPI getIndexKPI(String crmId, String startDate, String endDate) throws Exception {
		// 转换为json
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(crmId);// crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 服务请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(crmId);// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic("kpi");
		sreq.setParam1(startDate);
		sreq.setParam2(endDate);
		sreq.setReport("kpi");

		// 分系统查询
		String openId = getOpenIdByCrmId(sreq.getCrmaccount());
		log.info("openId = >" + openId);
		List<Organization> crmIds = getCrmIdAndOrgIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		IndexKPI index = new IndexKPI();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getIndexKPI jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}
			// 解析JSON数据
			log.info("getIndexKPI List rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					JSONArray jsonArray = jsonObject.getJSONArray("analytics");
					JSONObject jsonObject1 = jsonArray.getJSONObject(0);
					if(StringUtils.isNotNullOrEmptyStr(index.getCollectionCompleted())){
						index.setCollectionCompleted(Float.parseFloat(index.getCollectionCompleted()) + Float.parseFloat(jsonObject1.getString("collectionCompleted"))+"");
					}else{
						index.setCollectionCompleted(jsonObject1.getString("collectionCompleted"));
					}
					
					if(StringUtils.isNotNullOrEmptyStr(index.getCollectionTargets())){
						index.setCollectionTargets(Float.parseFloat(index.getCollectionTargets()) + Float.parseFloat(jsonObject1.getString("collectionTargets"))+"");
					}else{
						index.setCollectionTargets(jsonObject1.getString("collectionTargets"));
					}
					
					if(StringUtils.isNotNullOrEmptyStr(index.getSalesCompleted())){
						index.setSalesCompleted(Float.parseFloat(index.getSalesCompleted()) + Float.parseFloat(jsonObject1.getString("salesCompleted"))+"");
					}else{
						index.setSalesCompleted(jsonObject1.getString("salesCompleted"));
					}
					
					if(StringUtils.isNotNullOrEmptyStr(index.getUnfinishedTask())){
						index.setUnfinishedTask(Integer.parseInt(index.getUnfinishedTask()) + Integer.parseInt(jsonObject1.getString("unfinishedTask"))+"");
					}else{
						index.setUnfinishedTask(jsonObject1.getString("unfinishedTask"));
					}
					
					if(StringUtils.isNotNullOrEmptyStr(index.getSalesTargets())){
						index.setSalesTargets(Float.parseFloat(index.getSalesTargets()) + Float.parseFloat(jsonObject1.getString("salesTargets"))+"");
					}else{
						index.setSalesTargets(jsonObject1.getString("salesTargets"));
					}
					
				}
			}
		}

		return index;
	}
	
	
	
	
	
	
	//--------------------------------------------------------------------------------
	
	/**
	 * 回款分析-by部门
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Depart(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam7(analytics.getParam7());
		sreq.setParam8(analytics.getParam8());
		
		// 分系统查询
		String openId = getOpenIdByCrmId(sreq.getCrmaccount());
		log.info("openId = >" + openId);
		List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<AnalyticsReceivableResp> rstList = new ArrayList<AnalyticsReceivableResp>();

		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i);
			sreq.setCrmaccount(crmid);

			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getExpenseAnalytics jsonStr => jsonStr is : " + jsonStr);

			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);

			// 做空判断
			if (null == rst || "".equals(rst)) {
				continue;
			}

			// 解析JSON数据
			log.info("getExpenseAnalytics for Department List rst => rst is : " + rst);

			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));

			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<AnalyticsReceivableResp> clist = (List<AnalyticsReceivableResp>) JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsReceivableResp.class);
					if (null != clist && clist.size() > 0) {
						for (int j = 0; j < clist.size(); j++) {
							rstList.add(clist.get(j));
						}
					}
				}
			}
		}
		resp.setReceList(rstList);
		return resp;
	}
	
	/**
	 * 联系人贡献分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsContact4Contribution(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//联系人请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam8(analytics.getParam8());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticContact4Contribution  jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticContact4Contribution   List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsContactResp> clist = (List<AnalyticsContactResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsContactResp.class);
				resp.setContactList(clist);
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 联系人未来业务机会分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsContact4Futureoppty(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		sreq.setParam7(analytics.getParam7());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsContact4Futureoppty   jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsContact4Futureoppty   rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsContactResp> clist = (List<AnalyticsContactResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsContactResp.class);
				resp.setContactList(clist);
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsContact4Futureoppty errcode => errcode is : " + errcode);
			log.info("getAnalyticsContact4Futureoppty errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	
	/**
	 * 销售目标分析(季度)
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsQuota4Quarter(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsQuota4Quarter jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsQuota4Quarter for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsQuotaResp> clist = (List<AnalyticsQuotaResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsQuotaResp.class);
				resp.setQuotas(clist);//目标列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsQuota4Quarter errcode => errcode is : " + errcode);
			log.info("getAnalyticsQuota4Quarter errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 销售目标分析(月份)
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsQuota4Month(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsQuota4Month jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsQuota4Month for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsQuotaResp> clist = (List<AnalyticsQuotaResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsQuotaResp.class);
				resp.setQuotas(clist);//目标列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsQuota4Month errcode => errcode is : " + errcode);
			log.info("getAnalyticsQuota4Month errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 服务请求分析(按月份)
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsComplaint4Month(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//服务请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsComplaint4Month jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsComplaint4Month for Month List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsComplaintResp> clist = (List<AnalyticsComplaintResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsComplaintResp.class);
				resp.setComplaints(clist);//服务请求列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsComplaint4Month errcode => errcode is : " + errcode);
			log.info("getAnalyticsComplaint4Month errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 服务请求分析(按类型)
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsComplaint4Subtype(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//服务请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsComplaint4Subtype jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsComplaint4Subtype for Subtype List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsComplaintResp> clist = (List<AnalyticsComplaintResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsComplaintResp.class);
				resp.setComplaints(clist);//服务请求列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsComplaint4Subtype errcode => errcode is : " + errcode);
			log.info("getAnalyticsComplaint4Subtype errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 服务请求分析(按部门)
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsComplaint4Depart(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//服务请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsComplaint4Depart jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsComplaint4Depart for Subtype List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsComplaintResp> clist = (List<AnalyticsComplaintResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsComplaintResp.class);
				resp.setComplaints(clist);//服务请求列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsComplaint4Depart errcode => errcode is : " + errcode);
			log.info("getAnalyticsComplaint4Depart errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	
	/**
	 * 费用-按部门统计费用
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsExpense4Depart(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getExpenseAnalytics jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getExpenseAnalytics for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsExpenseResp> clist = (List<AnalyticsExpenseResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsExpenseResp.class);
				resp.setExpense(clist);//客户列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 费用 -按类型统计
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsExpense4Type(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getExpenseAnalytics jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getExpenseAnalytics for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsExpenseResp> clist = (List<AnalyticsExpenseResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsExpenseResp.class);
				resp.setExpense(clist);//客户列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 产品报价分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsQuote4Product(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsQuote4Product jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)){
			 return resp;
		}
		//解析JSON数据
		log.info("getAnalyticsQuote4Product for Month List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsReceivableResp> receList = (List<AnalyticsReceivableResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsReceivableResp.class);
				resp.setReceList(receList);
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsQuote4Product errcode => errcode is : " + errcode);
			log.info("getAnalyticsQuote4Product errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 异常回款分析
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Unusual(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsReceivable4Unusual jsonStr => jsonStr is : "+ jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)){
			return resp;
		} 
		//解析JSON数据
		log.info("getAnalyticsReceivable4Unusual for Unusual List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsReceivableResp> receList = (List<AnalyticsReceivableResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsReceivableResp.class);
				resp.setReceList(receList);
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 费用类型报表-按费用子类统计
	 */
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsExpense4SubType(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getExpenseAnalytics jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)){
			return resp;
		}
		//解析JSON数据
		log.info("getExpenseAnalytics for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsExpenseResp> clist = (List<AnalyticsExpenseResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsExpenseResp.class);
				resp.setExpense(clist);//客户列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 业务机会排名分析
	 */
	public AnalyticsResp getAnalyticsOppty4Rank(Analytics analytics){
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsOppty4Rank jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst.trim())) return resp;
		//解析JSON数据
		log.info("getAnalyticsOppty4Rank for  List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
				resp.setOpptyList(opptyList);//
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsOppty4Rank errcode => errcode is : " + errcode);
			log.info("getAnalyticsOppty4Rank errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 潜在客户时间分析
	 */
	
	@SuppressWarnings("unchecked")
	public AnalyticsResp getAnalyticsReceivable4Latent(Analytics analytics) {
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		
		//客户请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getExpenseAnalytics jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getExpenseAnalytics for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsCustomeryResp> clist = (List<AnalyticsCustomeryResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsCustomeryResp.class);
				resp.setCustomerList(clist);//行业列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	

	/**
	 * 业务机会成单率分析
	 */
	public AnalyticsResp getAnalyticsOppty4Rate(Analytics analytics){
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsOppty4Rate jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsOppty4Rate for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
				resp.setOpptyList(opptyList);//
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseAnalytics errcode => errcode is : " + errcode);
			log.info("getExpenseAnalytics errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	

	
	/**
	 * 业务机会成单数量分析
	 */
	public AnalyticsResp getAnalyticsOppty4Count(Analytics analytics){
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsOppty4Count jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsOppty4Count for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
				resp.setOpptyList(opptyList);//
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsOppty4Count errcode => errcode is : " + errcode);
			log.info("getAnalyticsOppty4Count errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 业务机会同比分析
	 */
	public AnalyticsResp getAnalyticsOppty4Yearcompare(Analytics analytics){
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsOppty4Yearcompare jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsOppty4Yearcompare for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
				resp.setOpptyList(opptyList);//
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsOppty4Yearcompare errcode => errcode is : " + errcode);
			log.info("getAnalyticsOppty4Yearcompare errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 业务机会成单环比分析
	 */
	public AnalyticsResp getAnalyticsOppty4Monthcompare(Analytics analytics){
		AnalyticsResp resp = new AnalyticsResp();
		resp.setCrmaccount(analytics.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		// 业务机会请求
		AnalyticsReq sreq = new AnalyticsReq();
		sreq.setCrmaccount(analytics.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ANALYTICS);
		sreq.setTopic(analytics.getTopic());
		sreq.setReport(analytics.getReport());
		sreq.setParam1(analytics.getParam1());
		sreq.setParam2(analytics.getParam2());
		sreq.setParam3(analytics.getParam3());
		sreq.setParam4(analytics.getParam4());
		sreq.setParam5(analytics.getParam5());
		sreq.setParam6(analytics.getParam6());
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAnalyticsOppty4Monthcompare jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ANALYTICS, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("getAnalyticsOppty4Monthcompare for Department List rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				List<AnalyticsOpptyResp> opptyList = (List<AnalyticsOpptyResp>)JSONArray.toCollection(jsonObject.getJSONArray("analytics"), AnalyticsOpptyResp.class);
				resp.setOpptyList(opptyList);//
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAnalyticsOppty4Monthcompare errcode => errcode is : " + errcode);
			log.info("getAnalyticsOppty4Monthcompare errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	

}
