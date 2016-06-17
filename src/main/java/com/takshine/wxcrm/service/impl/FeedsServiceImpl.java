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
import com.takshine.wxcrm.domain.Feeds;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.sugar.FeedsAdd;
import com.takshine.wxcrm.message.sugar.FeedsReq;
import com.takshine.wxcrm.message.sugar.FeedsResp;
import com.takshine.wxcrm.service.FeedsService;

/**
 * 报表 相关业务接口实现
 *
 */
@Service("feedsService")
public class FeedsServiceImpl extends BaseServiceImpl implements FeedsService {

	private static Logger log = Logger.getLogger(FeedsServiceImpl.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public BaseModel initObj() {
		return null;
	}
	@SuppressWarnings("unchecked")
	public FeedsResp getFeedList(Feeds feed) {
		// 活动流
		FeedsResp resp = new FeedsResp();
		resp.setCrmaccount(feed.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_FEED);
		// 活动流请求
		FeedsReq sreq = new FeedsReq();
		sreq.setCrmaccount(feed.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_FEED);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setPagecount(feed.getPagecount());
		sreq.setCurrpage(feed.getCurrpage());
		sreq.setLasttime(feed.getLasttime());
		sreq.setParam1(feed.getParam1());
		sreq.setParam2(feed.getParam2());
		sreq.setParam3(feed.getParam3());
		sreq.setParam4(feed.getParam4());
		sreq.setParam5(feed.getParam5());

		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getFeedList jsonStr => jsonStr is : " + jsonStr);
		// 多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_FEED, jsonStr, Constants.INVOKE_MULITY);
		log.info("getFeedList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			//String msgcount = jsonObject.getString("msgcount");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
				resp.setFeedList(slist);// 活动流列表
			}
			resp.setCount(count);// 数字
			//resp.setMsgcount(msgcount);
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getFeedList errcode => errcode is : " + errcode);
			log.info("getFeedList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	@SuppressWarnings("unchecked")
	public FeedsResp getFeedById(Feeds feed) {
		// 活动流
		FeedsResp resp = new FeedsResp();
		resp.setCrmaccount(feed.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_FEED);
		// 活动流请求
		FeedsReq sreq = new FeedsReq();
		sreq.setCrmaccount(feed.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_FEED);
		sreq.setType(Constants.ACTION_SEARCHID);
		sreq.setRowid(feed.getRowid());
		sreq.setModule(feed.getModule());

		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getFeedList jsonStr => jsonStr is : " + jsonStr);
		// 多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_FEED, jsonStr, Constants.INVOKE_MULITY);
		log.info("getFeedList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
				resp.setFeedList(slist);// 活动流列表
			}
			resp.setCount(count);// 数字
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getFeedList errcode => errcode is : " + errcode);
			log.info("getFeedList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	@SuppressWarnings("unchecked")
	public FeedsResp replyFeed(Feeds feed) {
		// 活动流
		FeedsResp resp = new FeedsResp();
		resp.setCrmaccount(feed.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_FEED);
		// 活动流请求
		FeedsReq sreq = new FeedsReq();
		sreq.setCrmaccount(feed.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_FEED);
		sreq.setType(Constants.ACTION_ADD);
		sreq.setRowid(feed.getRowid());
		sreq.setModule(feed.getModule());
		sreq.setReply(feed.getReply());
		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getFeedList jsonStr => jsonStr is : " + jsonStr);
		// 多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_FEED, jsonStr, Constants.INVOKE_MULITY);
		log.info("getFeedList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
				resp.setFeedList(slist);// 活动流列表
			}
			resp.setCount(count);// 数字
			return resp;
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getFeedList errcode => errcode is : " + errcode);
			log.info("getFeedList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
			return resp;
		}

	}

	/**
	 * 获取新消息列表
	 */
	@SuppressWarnings("unchecked")
	public FeedsResp getNewFeedList(Feeds feed) {
		// 活动流
		FeedsResp resp = new FeedsResp();
		resp.setCrmaccount(feed.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_FEED);
		// 活动流请求
		FeedsReq sreq = new FeedsReq();
		sreq.setCrmaccount(feed.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_FEED);
		sreq.setType(Constants.ACTION_SEARCH_MESSAGE);
		sreq.setLasttime(feed.getLasttime());
		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getFeedList jsonStr => jsonStr is : " + jsonStr);
		// 多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_FEED, jsonStr, Constants.INVOKE_MULITY);
		log.info("getFeedList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
				resp.setFeedList(slist);// 活动流列表
			}
			resp.setCount(count);// 数字
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getFeedList errcode => errcode is : " + errcode);
			log.info("getFeedList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	public FeedsResp getAllFeedList(Feeds feed) throws Exception {
		// 活动流
		FeedsResp resp = new FeedsResp();
		resp.setCrmaccount(feed.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_FEED);
		// 活动流请求
		FeedsReq sreq = new FeedsReq();
		sreq.setCrmaccount(feed.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_FEED);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setViewtype(feed.getViewtype());

		
		
		//分系统查询
		List<Organization> crmIds = getCrmIdAndOrgIdArr(feed.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<FeedsAdd> rstList = new ArrayList<FeedsAdd>();
		List<String> jsonStrArray = new ArrayList<String>();
		Map<String,String> mapOrgid = new HashMap<String,String>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			//获取ORGID
//			OperatorMobile operatorMobile = new OperatorMobile();
//			operatorMobile.setCrmId(crmid);
//			OperatorMobile operatorMobile2 = checkBinding(operatorMobile);
//			String orgId = operatorMobile2.getOrgId();
			String orgId = crmIds.get(i).getOrgId();
			
			sreq.setCrmaccount(crmid);
			sreq.setOrgUrl(crmIds.get(i).getCrmurl());
			
			// 转换为json
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getFeedList jsonStr => jsonStr is : " + jsonStr);
			jsonStrArray.add(jsonStr);
			mapOrgid.put(jsonStr, orgId);
		}

		// 多次调用sugar接口
		Map<String,String> rstMap = cRMService.getWxService().getWxHttpConUtil().postJsonDataRetMapBodyKey(Constants.MODEL_URL_FEED, jsonStrArray, Constants.INVOKE_MULITY);
		for(String jsonStr : rstMap.keySet()){
			try{
				String rst = rstMap.get(jsonStr);
				log.info("getFeedList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
						//resp.setFeedList(slist);// 活动流列表
						
						if(null != slist && slist.size()>0){
							FeedsAdd fa = null;
							for(int j=0;j<slist.size();j++){
								fa = slist.get(j);
								fa.setOrgId(mapOrgid.get(jsonStr));
								rstList.add(fa);
							}
						}
					}
					//resp.setCount(count);// 数字
				} 
			}catch(Exception ec){
				
			}
		}
		
		if(rstList.size() > 0){
			// 字符串排序
		    Collections.sort(rstList, new Comparator() {
		      public int compare(Object o1, Object o2) {
		    	  return ((FeedsAdd)o2).getCreatedate().compareTo(((FeedsAdd)o1).getCreatedate());
		      }
		    });
			resp.setFeedList(rstList);
		}		
		
//		// 多次调用sugar接口
//		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_FEED, jsonStr, Constants.INVOKE_MULITY);
//		log.info("getFeedList rst => rst is : " + rst);
//		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
//		if (!jsonObject.containsKey("errcode")) {
//			// 错误代码和消息
//			String count = jsonObject.getString("count");
//			// String msgcount = jsonObject.getString("msgcount");
//			if (!"".equals(count) && Integer.parseInt(count) > 0) {
//				List<FeedsAdd> slist = (List<FeedsAdd>) JSONArray.toCollection(jsonObject.getJSONArray("feeds"), FeedsAdd.class);
//				resp.setFeedList(slist);// 活动流列表
//			}
//			resp.setCount(count);// 数字
//			// resp.setMsgcount(msgcount);
//		} else {
//			String errcode = jsonObject.getString("errcode");
//			String errmsg = jsonObject.getString("errmsg");
//			log.info("getFeedList errcode => errcode is : " + errcode);
//			log.info("getFeedList errmsg => errmsg is : " + errmsg);
//			resp.setErrcode(errcode);
//			resp.setErrmsg(errmsg);
//		}
		return resp;
	}

}
