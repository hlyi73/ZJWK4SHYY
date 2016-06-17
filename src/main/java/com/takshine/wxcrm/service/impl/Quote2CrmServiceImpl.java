package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveAdd;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ProductQuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Quote2CrmService;

/**
 * 报价相关业务接口实现
 *
 * @author dengbo
 */
@Service("quote2CrmService")
public class Quote2CrmServiceImpl extends BaseServiceImpl implements Quote2CrmService{
	
	private static Logger log = Logger.getLogger(Quote2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询 报价数据列表
	 * @return
	 */
	public QuoteResp getQuoteList(QuoteAdd sche, String source)throws Exception{
		//日程响应
		QuoteResp resp = new QuoteResp();
		sche.setModeltype(Constants.MODEL_TYPE_QUOTE);
		sche.setType(Constants.ACTION_SEARCH);
		//viewtype视图
		String viewtype = sche.getViewtype();
		log.info("viewtype = >" + viewtype);
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			//List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<CacheQuote> cachelist = new ArrayList<CacheQuote>();
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i);
//				log.info("crmid = >" + crmid);
//				//查询接口 获取人的数据列表
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOpenId(sche.getOpenId());
//				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
//					List<UserAdd> ulist = uResp.getUsers();
//					if(null != ulist && ulist.size()>0){
//						for (int j = 0; j < ulist.size(); j++) {
//							UserAdd ua = ulist.get(j);
//							String uid = ua.getUserid();
//							log.info("uid = >" + uid);
//							rstuid.add(uid);
//						}
//					}
//			}
			
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(sche.getCrmaccount());
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			uReq.setFlag("");
			uReq.setOpenId(sche.getOpenId());
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			List<UserAdd> ulist = uResp.getUsers();
			if(null != ulist && ulist.size()>0){
				for (int j = 0; j < ulist.size(); j++) {
					UserAdd ua = ulist.get(j);
					String uid = ua.getUserid();
					log.info("uid = >" + uid);
					rstuid.add(uid);
				}
			}
				
			if(rstuid.size() > 0){
				CacheQuote csear = new CacheQuote();
				csear.setCrm_id_in(rstuid);
				csear.setName(sche.getName());
				csear.setStatus(sche.getStatus());
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setOrderByString(sche.getOrderString());
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				cachelist = (List<CacheQuote>)cRMService.getDbService().getCacheQuoteService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			List<QuoteAdd> rstlist = new ArrayList<QuoteAdd>();
			for (CacheQuote cacheQuote : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheQuoteService().invstransf(cacheQuote));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setQuotes(rstlist);
			return resp;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				//查询列表
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("Accounts");
				sc.setOrgUrl(crmIds.get(i).getCrmurl());
				ShareResp scResp = cRMService.getSugarService().getShare2SugarService().getShareRecordList(sc);
				List<ShareAdd> respList = scResp.getShares();
				for (int j = 0; j < respList.size(); j++) {
					ShareAdd sa = respList.get(j);
					String rowid = sa.getParentid();
					log.info("rowid = >" + rowid);
					rstuid.add(rowid);
				}
			}
			
			TeamPeason team = new TeamPeason();
			team.setOpenId(sche.getOpenId());
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheQuote> cachelist = new ArrayList<CacheQuote>();
			if(rstuid.size() > 0){
				CacheQuote csear = new CacheQuote();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sche.getName());
				csear.setStatus(sche.getStatus());
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setOrderByString(sche.getOrderString());
				cachelist = (List<CacheQuote>)cRMService.getDbService().getCacheQuoteService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			List<QuoteAdd> rstlist = new ArrayList<QuoteAdd>();
			for (CacheQuote cacheQuote : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheQuoteService().invstransf(cacheQuote));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setQuotes(rstlist);
			return resp;
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype)){//我的所有的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				sche.setCrmaccount(crmid);
				sche.setCurrpage("1");
				sche.setPagecount("99999");
				sche.setOrgUrl(crmIds.get(i).getCrmurl());
				String jsonStr = JSONObject.fromObject(sche).toString();
				log.info("getQuoteList jsonStr => jsonStr is : " + jsonStr);
				// 单次调用sugar接口
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
				log.info("getQuoteList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<QuoteAdd> list = (List<QuoteAdd>) JSONArray.toCollection(jsonObject.getJSONArray("quotes"),QuoteAdd.class);
						for(QuoteAdd quoteAdd : list){
							rstuid.add(quoteAdd.getRowid());
						}
					}
				}
			}
			List<CacheQuote> cachelist = new ArrayList<CacheQuote>();
			if(rstuid.size() > 0){
				CacheQuote csear = new CacheQuote();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sche.getName());
				csear.setStatus(sche.getStatus());
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setOrderByString(sche.getOrderString());
				cachelist = (List<CacheQuote>)cRMService.getDbService().getCacheQuoteService().findObjListByFilter(csear);
			}
			List<QuoteAdd> rstlist = new ArrayList<QuoteAdd>();
			for (CacheQuote cacheQuote : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheQuoteService().invstransf(cacheQuote));
			}
			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setQuotes(rstlist);
			return resp;
		}else{
			//查询缓存表
			CacheQuote csear = new CacheQuote();
			csear.setCrm_id(sche.getCrmaccount());
			csear.setName(sche.getName());
			csear.setStatus(sche.getStatus());
			csear.setStart_date(sche.getStartdate());
			csear.setEnd_date(sche.getEnddate());
			csear.setOrderByString(sche.getOrderString());
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			List<CacheQuote> cachelist = (List<CacheQuote>)cRMService.getDbService().getCacheQuoteService().findCacheQuoteListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<QuoteAdd> rstlist = new ArrayList<QuoteAdd>();
			for (CacheQuote cacheQuote : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheQuoteService().invstransf(cacheQuote));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setQuotes(rstlist);
			return resp;
		}
	}
	
	/**
	 * 查询单个报价数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public QuoteResp getQuoteSingle(String rowId, String crmId){
		CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cacheQuote.getCrm_id());
		
		//日程响应
		QuoteResp resp = new QuoteResp();
		resp.setCrmaccount(crmId);//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_QUOTE);
		//日程请求
		QuoteAdd single = new QuoteAdd();
		single.setCrmaccount(crmId);//sugar id
		single.setOrgId(cacheQuote.getOrg_id());
		single.setModeltype(Constants.MODEL_TYPE_QUOTE);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowId);
		
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getQuoteSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getQuoteSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			List<QuoteAdd> slist = new ArrayList<QuoteAdd>();
			JSONArray jarr = jsonObject.getJSONArray("quotes");
			for(int i = 0; i < jarr.size() ;i++){
				QuoteAdd cr = new QuoteAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				cr.setRowid(jobj.getString("rowid"));
				cr.setName(jobj.getString("name"));
				cr.setQuotedate(jobj.getString("quotedate"));
				cr.setAssigner(jobj.getString("assigner"));
				cr.setAssignerid(jobj.getString("assignerid"));
				cr.setCreater(jobj.getString("creater"));
				cr.setCreatedate(jobj.getString("createdate"));
				cr.setModifier(jobj.getString("modifier"));
				cr.setModifydate(jobj.getString("modifydate"));
				cr.setValid(jobj.getString("valid"));
				cr.setStatus(jobj.getString("status"));
				cr.setStatusname(jobj.getString("statusname"));
				cr.setAmount(jobj.getString("amount"));
				cr.setAuditor(jobj.getString("auditor"));
				cr.setParentid(jobj.getString("parentid"));
				cr.setParentname(jobj.getString("parentname"));
				cr.setQuotecode(jobj.getString("quotecode"));
				cr.setDecount(jobj.getString("decount"));
				cr.setQuotestatus(jobj.getString("quotestatus"));
				cr.setQuotestatusname(jobj.getString("quotestatusname"));
				cr.setCountmonut(jobj.getString("countmount"));
				cr.setOrgId(cacheQuote.getOrg_id());
				if(null != jobj.get("approves") && !"".equals(jobj.get("approves"))){
					List<ApproveAdd> approlist = (List<ApproveAdd>)JSONArray.toCollection(jobj.getJSONArray("approves"), ApproveAdd.class);
					cr.setApproves(approlist);
				}
				if(null != jobj.get("audits") && !"".equals(jobj.get("audits"))){
					List<OpptyAuditsAdd> approlist = (List<OpptyAuditsAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), OpptyAuditsAdd.class);
					cr.setAudits(approlist);
				}
				slist.add(cr);
				resp.setQuotes(slist);
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getQuoteSingle errcode => errcode is : " + errcode);
			log.info("getQuoteSingle errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 修改报价信息
	 * @param obj
	 * @return
	 */
	public CrmError updateQuote(QuoteAdd obj){
		CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(obj.getRowid());
		log.info("newCrmId = >" + cacheQuote.getCrm_id());
		obj.setCrmaccount(obj.getCrmaccount());
		obj.setOrgId(cacheQuote.getOrg_id());
		
		CrmError crmErr = new CrmError();
		log.info("updateQuote start => obj is : " + obj);
		obj.setModeltype(Constants.MODEL_TYPE_QUOTE);
		obj.setType(obj.getType());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(obj, jsonConfig).toString();
		log.info("updateQuote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateQuote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateQuote errcode => errcode is : " + errcode);
			log.info("updateQuote errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		
		try {
			//同步到缓存
			CacheQuote cache = cRMService.getDbService().getCacheQuoteService().transf(null, obj);
			cRMService.getDbService().getCacheQuoteService().updateObj(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}
	
	/**
	 * 保存报价信息
	 * @param obj
	 * @return
	 */
	public CrmError saveQuote(QuoteAdd obj){
		CrmError crmErr = new CrmError();
		log.info("addQuote start => obj is : " + obj);
		obj.setModeltype(Constants.MODEL_TYPE_QUOTE);
		obj.setType(Constants.ACTION_ADD);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(obj, jsonConfig).toString();
		log.info("addQuote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addQuote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			if("0".equals(errcode)){
				String rowId = jsonObject.getString("rowid");
				crmErr.setRowId(rowId);
				try {
					//同步到缓存
					CacheQuote cache = cRMService.getDbService().getCacheQuoteService().transf(obj.getOrgId(), obj);
					cache.setRowid(rowId);
					cRMService.getDbService().getCacheQuoteService().addObj(cache);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
				
			}
			log.info("addQuote errcode => errcode is : " + errcode);
			log.info("addQuote errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 保存报价明细
	 * @param productQuoteAdd
	 * @return
	 */
	public CrmError saveMxquote(ProductQuoteAdd productQuoteAdd){
		CrmError crmErr = new CrmError();
		productQuoteAdd.setModeltype(Constants.MODEL_TYPE_QUOTE);
		productQuoteAdd.setType(Constants.ACTION_ADDITEM);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(productQuoteAdd, jsonConfig).toString();
		log.info("saveMxquote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("saveMxquote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("saveMxquote errcode => errcode is : " + errcode);
			log.info("saveMxquote errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * copy报价单
	 * @param rowId
	 * @return
	 */
	public CrmError copyQuote(String rowId,String crmId,String type){
		CrmError crmErr = new CrmError();
		QuoteAdd single = new QuoteAdd();
		single.setCrmaccount(crmId);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_QUOTE);
		single.setOptype(type);
		single.setType(Constants.MODEL_TYPE_REQUOTE);
		single.setRowid(rowId);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(single, jsonConfig).toString();
		log.info("copyQuote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("copyQuote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode =  jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			if("0".equals(errcode)){
				String rowid = jsonObject.getString("rowid");
				crmErr.setRowId(rowid);
			}
			log.info("copyQuote errcode => errcode is : " + errcode);
			log.info("copyQuote errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 查找单个报价明细
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ProductQuoteAdd getMxQuote(String rowId,String crmId){
		ProductQuoteAdd productQuoteAdd = new ProductQuoteAdd();
		QuoteAdd single = new QuoteAdd();
		single.setCrmaccount(crmId);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_QUOTE);
		single.setType(Constants.ACTION_SEARCHITEM);
		single.setRowid(rowId);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(single, jsonConfig).toString();
		log.info("getMxQuote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("getMxQuote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (!jsonObject.containsKey("errcode")) {
			List<ProductQuoteAdd> slist = (List<ProductQuoteAdd>)JSONArray.toCollection(jsonObject.getJSONArray("quotes"), ProductQuoteAdd.class);
			if(slist!=null&&slist.size()>0){
				productQuoteAdd = slist.get(0);
			}
		}else{
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("getMxQuote errcode => errcode is : " + errcode);
			log.info("getMxQuote errmsg => errmsg is : " + errmsg);
			productQuoteAdd.setErrcode(errcode);
			productQuoteAdd.setErrmsg(errmsg);
		}
		return productQuoteAdd;
	}
	
	/**
	 * 修改报价明细
	 * @param productQuoteAdd
	 * @return
	 */
	public CrmError updateMxQuote(ProductQuoteAdd productQuoteAdd){
		CrmError crmErr = new CrmError();
		productQuoteAdd.setModeltype(Constants.MODEL_TYPE_QUOTE);
		productQuoteAdd.setType(Constants.ACTION_UPDATEITEM);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(productQuoteAdd, jsonConfig).toString();
		log.info("updateMxQuote jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateMxQuote rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateMxQuote errcode => errcode is : " + errcode);
			log.info("updateMxQuote errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteQuote(QuoteAdd obj){
		CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(obj.getRowid());
		log.info("newCrmId = >" + cacheQuote.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("delContact start => obj is : " + obj);
		obj.setCrmaccount(cacheQuote.getCrm_id());
		obj.setOrgId(cacheQuote.getOrg_id());
		obj.setModeltype(Constants.MODEL_TYPE_OPPTY);
		obj.setType(Constants.ACTION_UPDATE);
		obj.setRowid(obj.getRowid());
		obj.setOptype(obj.getOptype());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(obj, jsonConfig).toString();
		log.info("delCustomer jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("delCustomer rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("delContact errcode => errcode is : " + errcode);
			log.info("delContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		
		try {
			//同步到缓存
			CacheOppty cache = new CacheOppty();
			cache.setRowid(obj.getRowid());
			cache.setEnabled_flag("disabled");
			cRMService.getDbService().getCacheQuoteService().updateEnabledFlag(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}
	
}
