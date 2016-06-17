package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BaseCrm;
import com.takshine.wxcrm.message.sugar.FrstChartsReq;
import com.takshine.wxcrm.message.sugar.FrstChartsResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.userget.UserGet;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.LovUser2SugarService;

/**
 * 从sugar系统获取 lov 和 user
 * @author liulin
 *
 */
@Service("lovUser2SugarService")
public class LovUser2SugarServiceImpl extends BaseServiceImpl implements LovUser2SugarService{
	
	// 日志
	protected static Logger log = Logger.getLogger(LovUser2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	

	public BaseModel initObj() {
		return null;
	}

	protected static final Map<String,Map<String, Map<String, String>>> lovListCacheMap = new java.util.concurrent.ConcurrentHashMap<String, Map<String,Map<String,String>>>();
	/**
	 * 查询 获取 lov 数据列表
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map<String, Map<String, String>> getLovList(String crmId){
		Map<String, Map<String, String>> v = lovListCacheMap.get(crmId);
		if (v == null){
			v= getLovListPrivate(crmId);
			lovListCacheMap.put(crmId, v);
		}
		return v;
	}
	
	/**
	 * 查询 获取 lov 数据列表
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private Map<String, Map<String, String>> getLovListPrivate(String crmId){
		//缓存键
		String cacheKey = "lovlist_" + crmId;
		//旧的crmId
		Object sObj = EhcacheUtil.get(cacheKey);//从缓存中获取菜单访问该状态
		if(sObj != null) return (Map<String, Map<String, String>>)sObj;
		//新的对象
		Map<String, Map<String, String>> lovTypeMap = new HashMap<String, Map<String, String>>();
		//lov请求
		BaseCrm req = new BaseCrm();
		req.setCrmaccount(crmId);//sugar id
		req.setType(Constants.ACTION_SEARCH);
		req.setModeltype(Constants.MODEL_TYPE_LOV);
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getLovList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
		log.info("getLovList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return lovTypeMap;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				
				JSONArray jsonArray = jsonObject.getJSONArray("lovs");
				for (int i = 0; i < jsonArray.size(); i++) {
					JSONObject jo = (JSONObject)jsonArray.get(i);
					
					//迭代遍历所有的key
					for (Iterator iterator = jo.keys(); iterator.hasNext();) {
						//lov 键值对map
						Map<String, String> lovMap = new LinkedHashMap<String, String>();
	                    //lov 类型
						String lovType = (String) iterator.next();
						JSONObject jolov = (JSONObject)jo.getJSONObject(lovType);
						for (Iterator iterator2 = jolov.keys(); iterator2
								.hasNext();) {
							String lovKey  = (String) iterator2.next();
							String lovName = (String)jolov.getString(lovKey);
							lovMap.put(lovKey, lovName);//存入对象
						}
						lovTypeMap.put(lovType, lovMap);
					}
				}
				//存放到缓存
				if(lovTypeMap.keySet().size() > 0){
					EhcacheUtil.put(cacheKey, lovTypeMap);
				}
			}
			
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getLovList errcode => errcode is : " + errcode);
			log.info("getLovList errmsg => errmsg is : " + errmsg);
		}
		return lovTypeMap;
	}
	
	/**
	 * 缓存lov数据到redis
	 * @param data
	 */
	@SuppressWarnings("rawtypes")
	public void cacheLovData(String orgId, Map<String, Map<String, String>> data){
		if(orgId == null || "".equals(orgId)){
			return;
		}
		for (String type : data.keySet()) {
			Map<String, String> mdata = data.get(type);
			String key = "WKLOV_" + orgId + "_" +type;
			log.info("lov key = >" + key);
			for (String type2 : mdata.keySet()) {
				String val2 = mdata.get(type2);
				//key val
				log.info(String.format("lov values [%s] =[%s] >",type2,val2));
			}
			RedisCacheUtil.putStringToMap(key, mdata);
		}
	}
	/**
	 * 从sugar系统中 查询 用户的数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public UsersResp getUserList(UserReq req) throws Exception{

		//重新创建对象
		UsersResp uResp = new UsersResp();
		//获得用户请求
		req.setType(Constants.ACTION_SEARCH);
		req.setModeltype(Constants.MODEL_TYPE_USER);
		String newCrmId = "";
		String orgId = "";
		if(StringUtils.isNotNullOrEmptyStr(req.getParentid())){
			String parenttype = req.getParenttype();
			if("Contract".equals(parenttype)){
				CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheContract.getCrm_id();
				orgId = cacheContract.getOrg_id();
			}else if("Opportunities".equals(parenttype)){
				CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheOppty.getCrm_id();
				orgId = cacheOppty.getOrg_id();
			}else if("Contacts".equals(parenttype)){
				CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheContact.getCrm_id();
				orgId = cacheContact.getOrg_id();
			}else if("Accounts".equals(parenttype)){
				CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheCustomer.getCrm_id();
				orgId = cacheCustomer.getOrg_id();
			}else if("Quote".equals(parenttype)){
				CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheQuote.getCrm_id();
				orgId = cacheQuote.getOrg_id();
			}else if("Tasks".equals(parenttype)){
				CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheSchedule.getCrm_id();
				orgId = cacheSchedule.getOrg_id();
			}else if("Activity".equals(parenttype)){
				orgId =(String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+req.getParentid());
				newCrmId = req.getCrmaccount();
			}else if("WorkReport".equals(parenttype)){
				orgId = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+req.getParentid());
				newCrmId = req.getCrmaccount();
			}else{
				//将来在扩展
			}
			req.setCrmaccount(newCrmId);
			req.setOrgId(orgId);
		}else if(StringUtils.isNotNullOrEmptyStr(req.getOrgId())){
			newCrmId = getCrmIdByOrgId(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), req.getOrgId());
			req.setCrmaccount(newCrmId);
		}else{
			List<Organization> crmIds = getCrmIdAndOrgIdArr(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			List<UserAdd> list = new ArrayList<UserAdd>();
			for(int i=0;i<crmIds.size();i++){
				req.setCrmaccount(crmIds.get(i).getCrmId());
				req.setOrgUrl(crmIds.get(i).getCrmurl());
				//转换为json
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getUserList jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
				log.info("getUserList rst => rst is : " + rst);
				//做空判断
				if(null == rst || "".equals(rst)) return uResp;
				//解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if(!jsonObject.containsKey("errcode")){
					String count = jsonObject.getString("count");
					if(!"".equals(count)&& Integer.parseInt(count) > 0){
						List<UserAdd> ulist = (List<UserAdd>)JSONArray.toCollection(jsonObject.getJSONArray("users"), UserAdd.class);
						list.addAll(ulist);
					}
				}
			}
			uResp.setUsers(list);//用户列表
			return uResp;
		}
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getUserList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
		log.info("getUserList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return uResp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String crmaccount = jsonObject.getString("crmaccount");
			String modeltype = jsonObject.getString("modeltype");
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<UserAdd> ulist = (List<UserAdd>)JSONArray.toCollection(jsonObject.getJSONArray("users"), UserAdd.class);
				uResp.setUsers(ulist);//用户列表
			}
			uResp.setCount(count);//数字
			uResp.setModeltype(modeltype);//类型
			uResp.setCrmaccount(crmaccount);
			//存放到缓存
//			WxCrmCacheUtil.put(cachekey, uResp);
			
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getUserList errcode => errcode is : " + errcode);
			log.info("getUserList errmsg => errmsg is : " + errmsg);
			uResp.setErrcode(errcode);
			uResp.setErrmsg(errmsg);
		}
		return uResp;
	}
	
	
	/**
	 * 从sugar系统中 查询 用户的数据列表(为了应付定时器)
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public UsersResp getUserList(UserReq req,WxHttpConUtil util) throws Exception{
		//重新创建对象
		UsersResp uResp = new UsersResp();
		//获得用户请求
		req.setType(Constants.ACTION_SEARCH);
		req.setModeltype(Constants.MODEL_TYPE_USER);
		String newCrmId = "";
		String orgId = "";
		if(StringUtils.isNotNullOrEmptyStr(req.getOrgId())){
			newCrmId = getCrmIdByOrgId(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), req.getOrgId());
			req.setCrmaccount(newCrmId);
		}else{
			List<Organization> crmIds = getCrmIdAndOrgIdArr(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			List<UserAdd> list = new ArrayList<UserAdd>();
			for(int i=0;i<crmIds.size();i++){
				req.setCrmaccount(crmIds.get(i).getCrmId());
				req.setOrgUrl(crmIds.get(i).getCrmurl());
				//转换为json
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getUserList jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = util.postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
				log.info("getUserList rst => rst is : " + rst);
				//做空判断
				if(null == rst || "".equals(rst)) return uResp;
				//解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if(!jsonObject.containsKey("errcode")){
					String count = jsonObject.getString("count");
					if(!"".equals(count)&& Integer.parseInt(count) > 0){
						List<UserAdd> ulist = (List<UserAdd>)JSONArray.toCollection(jsonObject.getJSONArray("users"), UserAdd.class);
						list.addAll(ulist);
					}
				}
			}
			uResp.setUsers(list);//用户列表
			return uResp;
		}
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getUserList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = util.postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
		log.info("getUserList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return uResp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String crmaccount = jsonObject.getString("crmaccount");
			String modeltype = jsonObject.getString("modeltype");
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<UserAdd> ulist = (List<UserAdd>)JSONArray.toCollection(jsonObject.getJSONArray("users"), UserAdd.class);
				uResp.setUsers(ulist);//用户列表
			}
			uResp.setCount(count);//数字
			uResp.setModeltype(modeltype);//类型
			uResp.setCrmaccount(crmaccount);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getUserList errcode => errcode is : " + errcode);
			log.info("getUserList errmsg => errmsg is : " + errmsg);
			uResp.setErrcode(errcode);
			uResp.setErrmsg(errmsg);
		}
		return uResp;
	}
	
	
	/**
	 * 查询活动首字母
	 * @param req
	 * @return
	 */
	public FrstChartsResp getCampaignsFirstCharList(String openId){
		FrstChartsResp chartsResp = new FrstChartsResp();
		//单次调用sugar接口 
		String url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/syncfirstbyidlist?source=WK&sourceid="+openId+"&viewtype=owner";
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return chartsResp;
		//解析JSON数据
		JSONArray jsonArray = JSONArray.fromObject(rst);
		if(null!=jsonArray&&jsonArray.size()>0){
			List<String> list = new ArrayList<String>();
			for(int i=0;i<jsonArray.size();i++){
				String str = jsonArray.get(i).toString();
				list.add(str);
			}
			chartsResp.setCommons(list);
		}
		return chartsResp;
	}
	
	/**
	 * 从后台CRM系统中 查询 首字母数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public FrstChartsResp getFirstCharList(FrstChartsReq req){
		FrstChartsResp chartsResp = new FrstChartsResp();
		//获得用户请求
		req.setModeltype(Constants.MODEL_TYPE_COMMON);
		
		String newCrmId = "";
		String orgId = "";
		if(StringUtils.isNotNullOrEmptyStr(req.getParentid())){
			String parenttype = req.getParenttype();
			if("Contract".equals(parenttype)){
				CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheContract.getCrm_id();
				orgId = cacheContract.getOrg_id();
			}else if("Opportunities".equals(parenttype)){
				CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheOppty.getCrm_id();
				orgId = cacheOppty.getOrg_id();
			}else if("Contacts".equals(parenttype)){
				CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheContact.getCrm_id();
				orgId = cacheContact.getOrg_id();
			}else if("Accounts".equals(parenttype)){
				CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheCustomer.getCrm_id();
				orgId = cacheCustomer.getOrg_id();
			}else if("Quote".equals(parenttype)){
				CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheQuote.getCrm_id();
				orgId = cacheQuote.getOrg_id();
			}else if("Tasks".equals(parenttype)){
				CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(req.getParentid());
				newCrmId = cacheSchedule.getCrm_id();
				orgId = cacheSchedule.getOrg_id();
			}else if("Activity".equals(parenttype)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+req.getParentid());
				newCrmId = req.getCrmaccount();
			}else if("WorkReport".equals(parenttype)){
				orgId =(String) RedisCacheUtil.get(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+req.getParentid());
				newCrmId = req.getCrmaccount();
			}
			req.setCrmaccount(newCrmId);
			req.setOrgId(orgId);
		}else if(StringUtils.isNotNullOrEmptyStr(req.getOrgId())){
			newCrmId = getCrmIdByOrgId(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), req.getOrgId());
			req.setCrmaccount(newCrmId);
		}else{
			List<Organization> crmIds = getCrmIdAndOrgIdArr(req.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				req.setCrmaccount(crmIds.get(i).getCrmId());
				req.setOrgUrl(crmIds.get(i).getCrmurl());
				//转换为json
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getUserList jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
				log.info("getUserList rst => rst is : " + rst);
				//做空判断
				if(null == rst || "".equals(rst)) return chartsResp;
				//解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if(!jsonObject.containsKey("errcode")){
					String count = jsonObject.getString("count");
					if(!"".equals(count)&& Integer.parseInt(count) > 0){
						List<String> ulist = (List<String>)JSONArray.toCollection(jsonObject.getJSONArray("commons"), String.class);
						list.addAll(ulist);
					}
				}
			}
			List<String> sortedList = new ArrayList<String>(new LinkedHashSet<String>(list)); 
			chartsResp.setCommons(sortedList);//用户列表
			return chartsResp;
		}
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getFirstCharList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
		log.info("getFirstCharList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return chartsResp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String crmaccount = jsonObject.getString("crmaccount");
			String modeltype = jsonObject.getString("modeltype");
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<String> commons = (List<String>)JSONArray.toCollection(jsonObject.getJSONArray("commons"), String.class);
				chartsResp.setCommons(commons);//字母列表
			}
			chartsResp.setCount(count);//数字
			chartsResp.setModeltype(modeltype);//类型
			chartsResp.setCrmaccount(crmaccount);
			
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getFirstCharList errcode => errcode is : " + errcode);
			log.info("getFirstCharList errmsg => errmsg is : " + errmsg);
			chartsResp.setErrcode(errcode);
			chartsResp.setErrmsg(errmsg);
		}
		return chartsResp;
	}
	
	/**
	 * 获取关注用户列表
	 * @return
	 */
	public UserGet getAttenUserList(String publicId, String userId, String relaId){
		UserGet ug = new UserGet();
		
		List<WxuserInfo> wxuserlist = null;
		try {
			wxuserlist = cRMService.getDbService().getUserRelaService().getUserList(userId);;
		} catch (Exception e) {
			log.info("wxuserlist exception =>" + e.getMessage());
		}
		log.info("wxuserlist =>" + wxuserlist.size());
		
		TeamPeason tsearch =  new TeamPeason();
		tsearch.setPublicId(publicId);
		tsearch.setRelaId(relaId);
		List<String> checkedList = cRMService.getDbService().getTeamPeasonService().findCheckedAtten(tsearch);
		
		//过滤
		List<UserInfo> uinfolist = new ArrayList<UserInfo>();
		List<String> newopenidList = new ArrayList<String>();
		for (int i = 0; i < wxuserlist.size(); i++) {
			WxuserInfo wx = wxuserlist.get(i);
			String openId = wx.getOpenId();
			
			if(!checkedList.contains(openId)){
				newopenidList.add(openId);
				uinfolist.add(transuinfo(wx));
			}
		}
		ug.setOpenidlist(newopenidList);
		ug.setUinfolist(uinfolist);
		
		return ug;
		
	}
	
	/**
	 * 获取用户的好友
	 * @param userId
	 * @return
	 */
	public List<UserRela> getFriendList(String userId)
	{
		//获取我的好友
		UserRela userRela = new UserRela();
		userRela.setUser_id(userId);
		userRela.setCurrpages(Constants.ZERO);
		userRela.setPagecounts(Constants.ALL_PAGECOUNT);
		List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
		
		return userRelaList;
	}
	
	/**
	 * 获取好友的首字母集合
	 * @param userId
	 * @return
	 */
	public List<String> getFriendFcharList(String userId)
	{
		List<String> retList = null;
		try
		{
			retList = cRMService.getDbService().getUserRelaService().queryFirstCharById(userId);
		}
		catch(Exception ex)
		{
			retList = new ArrayList<String>();
		}
		
		return retList;
	}
	
	private UserInfo transuinfo(WxuserInfo wu){
		UserInfo uinfo = new UserInfo();
		if(null != wu.getSubscribe()){
			uinfo.setSubscribe(Integer.parseInt(wu.getSubscribe()));
		}
		if(null != wu.getSex()){
			uinfo.setSex(Integer.parseInt(wu.getSex()));
		}
		if(null != wu.getSubscribeTime()){
			uinfo.setSubscribeTime(wu.getSubscribeTime().getTime());
		}
		
		uinfo.setOpenId(wu.getOpenId());
		uinfo.setNickname(wu.getNickname());
		uinfo.setCity(wu.getCity());
		uinfo.setCountry(wu.getCountry());
		uinfo.setProvince(wu.getProvince());
		uinfo.setLanguage(wu.getLanguage());
		uinfo.setHeadImgurl(wu.getHeadimgurl());
		
		return uinfo;
	}


	/**
	 * 修改用户状态
	 */
	public CrmError updateUser(UserReq req) {
		CrmError crmErr = new CrmError();
		req.setType(Constants.ACTION_UPDATE);
		req.setModeltype(Constants.MODEL_TYPE_USER);
		req.setSource(Constants.SYS_SOURCE);
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("updateUser jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr, Constants.INVOKE_MULITY);
		log.info("updateUser rst => rst is : " + rst);
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("updateUser errcode => errcode is : " + errcode);
			log.info("updateUser errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 保存用户
	 * @param userAdd
	 * @return
	 */
	public CrmError saveUser(UserAdd userAdd){
		CrmError crmError = new CrmError();
		return crmError;
	}


	/**
	 * 验证用户
	 */
	public boolean validateUserPassword(UserAdd ua) {
		ua.setType(Constants.ACTION_VALIDATE);
		ua.setModeltype(Constants.MODEL_TYPE_USER);
		ua.setSource(Constants.SYS_SOURCE);
		// 转换为json
		String jsonStr = JSONObject.fromObject(ua).toString();
		log.info("validateUserPassword jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr,Constants.INVOKE_SINGLE);
		log.info("validateUserPassword rst => rst is : " + rst);
		// 解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return true;
			}
		}
		return false;
	}


	/**
	 * 修改密码
	 */
	public boolean updateUserPassword(UserAdd ua) {
		ua.setType(Constants.ACTION_UPDATE_PWD);
		ua.setModeltype(Constants.MODEL_TYPE_USER);
		ua.setSource(Constants.SYS_SOURCE);
		// 转换为json
		String jsonStr = JSONObject.fromObject(ua).toString();
		log.info("updateUserPassword jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr,Constants.INVOKE_SINGLE);
		log.info("updateUserPassword rst => rst is : " + rst);
		// 解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return true;
			}
		}
		return false;
	}


	/**
	 * 修改用户信息
	 */
	public boolean updateUserInfo(UserAdd ua) {
		ua.setType(Constants.ACTION_UPDATE_BASIC);
		ua.setModeltype(Constants.MODEL_TYPE_USER);
		ua.setSource(Constants.SYS_SOURCE);
		// 转换为json
		String jsonStr = JSONObject.fromObject(ua).toString();
		log.info("updateUserPassword jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr,Constants.INVOKE_SINGLE);
		log.info("updateUserPassword rst => rst is : " + rst);
		// 解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return true;
			}
		}
		return false;
	}
	
}
