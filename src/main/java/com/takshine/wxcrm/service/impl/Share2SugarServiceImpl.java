package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareReq;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.service.Share2SugarService;

/**
 * 共享 相关业务接口实现
 *
 * @author liulin
 */
@Service("share2SugarService")
public class Share2SugarServiceImpl extends BaseServiceImpl implements
		Share2SugarService {

	private static Logger log = Logger
			.getLogger(Share2SugarServiceImpl.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询共享用户数据列表
	 */
	public ShareResp getShareUserList(Share sche, String source) {
		// 响应
		ShareResp resp = new ShareResp();
		
		String newCrmId = "";
		String orgId = "";
		if(StringUtils.isNotNullOrEmptyStr(sche.getParentid())){
			String parenttype = sche.getParenttype();
			if("Contract".equals(parenttype)){
				CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheContract.getCrm_id();
				orgId = cacheContract.getOrg_id();
			}else if("Opportunities".equals(parenttype)){
				CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheOppty.getCrm_id();
				orgId = cacheOppty.getOrg_id();
			}else if("Contacts".equals(parenttype)){
				CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheContact.getCrm_id();
				orgId = cacheContact.getOrg_id();
			}else if("Accounts".equals(parenttype)){
				CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheCustomer.getCrm_id();
				orgId = cacheCustomer.getOrg_id();
			}else if("Quote".equals(parenttype)){
				CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheQuote.getCrm_id();
				orgId = cacheQuote.getOrg_id();
			}else if("Tasks".equals(parenttype)){
				CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(sche.getParentid());
				newCrmId = cacheSchedule.getCrm_id();
				orgId = cacheSchedule.getOrg_id();
			}else if("Activity".equals(parenttype)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+sche.getParentid());
				if(!StringUtils.isNotNullOrEmptyStr(orgId)){
					Object obj = cRMService.getDbService().getActivityService().findObjById(sche.getParentid());
					if(null != obj){
						orgId = ((Activity)obj).getOrgId();
					}
				}
				newCrmId = sche.getCrmId();
			}else if("WorkReport".equals(parenttype)){
				orgId = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+sche.getParentid());
				newCrmId = sche.getCrmId();
			}
		}
		if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
			resp.setCrmaccount(newCrmId);
		}else{
			resp.setCrmaccount(sche.getCrmId());// crm id
		}
		
		resp.setModeltype(Constants.MODEL_TYPE_SHARE);
		resp.setCurrpage(sche.getCurrpage());
		resp.setPagecount(sche.getPagecount());
		// 请求
		ShareReq sreq = new ShareReq();
		if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
			sreq.setCrmaccount(newCrmId);
			sreq.setOrgId(orgId);
		}else{
			sreq.setCrmaccount(sche.getCrmId());// crm id
		}
		//sreq.setCrmaccount(sche.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_SHARE);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setParentid(sche.getParentid());
		sreq.setParenttype(sche.getParenttype());
		// 如果是WEB上显示
		if ("WEB".equals(source)) {
			sreq.setPagecount(sche.getPagecount());
		} else {
			sreq.setPagecount(sche.getPagecount());
		}
		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getShareUserList jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_SHARE, jsonStr,
				Constants.INVOKE_MULITY);
		// 做空判断
		if (null == rst || "".equals(rst))
			return resp;
		// 解析JSON数据
		log.info("getShareUserList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<ShareAdd> list = (List<ShareAdd>) JSONArray.toCollection(jsonObject.getJSONArray("shares"),ShareAdd.class);
				resp.setShares(list);// 共享用户列表
			}
			resp.setCount(count);// 数字
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getShareUserList errcode => errcode is : " + errcode);
			log.info("getShareUserList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 共享记录列表
	 * @param sche
	 * @param source
	 * @return
	 */
	public ShareResp getShareRecordList(Share sche) {
		// 响应
		ShareResp resp = new ShareResp();
		resp.setCrmaccount(sche.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_SHARE);
		resp.setCurrpage(sche.getCurrpage());
		resp.setPagecount(sche.getPagecount());
		// 请求
		ShareReq sreq = new ShareReq();
		sreq.setCrmaccount(sche.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_SHARE);
		sreq.setType(Constants.ACTION_SEARCHID);
		sreq.setParentid(sche.getParentid());
		sreq.setParenttype(sche.getParenttype());
		sreq.setOrgUrl(sche.getOrgUrl());
		// 转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getShareRecordList jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_SHARE, jsonStr,
				Constants.INVOKE_MULITY);
		// 做空判断
		if (null == rst || "".equals(rst))
			return resp;
		// 解析JSON数据
		log.info("getShareRecordList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<ShareAdd> list = (List<ShareAdd>) JSONArray.toCollection(jsonObject.getJSONArray("shares"),ShareAdd.class);
				resp.setShares(list);// 共享用户列表
			}
			resp.setCount(count);// 数字
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getShareRecordList errcode => errcode is : " + errcode);
			log.info("getShareRecordList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 增加或者取消共享用户
	 */
	public CrmError updShareUser(Share obj) {
		String newCrmId = "";
		String orgId = "";
		if(StringUtils.isNotNullOrEmptyStr(obj.getParentid())){
			String parenttype = obj.getParenttype();
			if("Contract".equals(parenttype)){
				CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheContract.getCrm_id();
				orgId = cacheContract.getOrg_id();
			}else if("Opportunities".equals(parenttype)){
				CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheOppty.getCrm_id();
				orgId = cacheOppty.getOrg_id();
			}else if("Contacts".equals(parenttype)){
				CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheContact.getCrm_id();
				orgId = cacheContact.getOrg_id();
			}else if("Accounts".equals(parenttype)){
				CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheCustomer.getCrm_id();
				orgId = cacheCustomer.getOrg_id();
			}else if("Quote".equals(parenttype)){
				CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheQuote.getCrm_id();
				orgId = cacheQuote.getOrg_id();
			}else if("Tasks".equals(parenttype)){
				CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(obj.getParentid());
				newCrmId = cacheSchedule.getCrm_id();
				orgId = cacheSchedule.getOrg_id();
			}else if("Activity".equals(parenttype)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+obj.getParentid());
				newCrmId = obj.getCrmId();
			}else if("WorkReport".equals(parenttype)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+obj.getParentid());
				newCrmId = obj.getCrmId();
			}
		}
		CrmError crmErr = new CrmError();
		log.info("updShareUser start => obj is : " + obj);
		ShareAdd shareAdd = new ShareAdd();
		if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
			shareAdd.setCrmaccount(newCrmId);
			shareAdd.setOrgId(orgId);
		}else{
			shareAdd.setCrmaccount(obj.getCrmId());
		}
		shareAdd.setModeltype(Constants.MODEL_TYPE_SHARE);
		shareAdd.setType(obj.getType());
		shareAdd.setParentid(obj.getParentid());
		shareAdd.setParenttype(obj.getParenttype());
		shareAdd.setShareuserid(obj.getShareuserid());
		shareAdd.setShareusername(obj.getShareusername());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[] { "", "" });
		String jsonStr = JSONObject.fromObject(shareAdd, jsonConfig).toString();
		log.info("updShareUser jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_SHARE, jsonStr,Constants.INVOKE_MULITY);
		log.info("updShareUser rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (jsonObject != null) {
			String errcode = jsonObject.getString("errcode");// 错误编码
			String errmsg = jsonObject.getString("errmsg");// 错误消息
			log.info("updShareUser errcode => errcode is : " + errcode);
			log.info("updShareUser errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
