package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Contract;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveAdd;
import com.takshine.wxcrm.message.sugar.ContractAdd;
import com.takshine.wxcrm.message.sugar.ContractReq;
import com.takshine.wxcrm.message.sugar.ContractResp;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.PaymentMethod;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.CacheContractService;
import com.takshine.wxcrm.service.Contract2CrmService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;

/**
 * 合同 相关业务接口实现
 * @author dengbo
 *
 */
@Service("contract2CrmService")
public class Contract2CrmServiceImpl extends BaseServiceImpl implements Contract2CrmService{

	private static Logger log = Logger.getLogger(Contract2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询合同数据列表
	 */
	@SuppressWarnings("unchecked")
	public ContractResp getContractList(Contract obj, String source) throws Exception{
		//合同响应
		ContractResp resp = new ContractResp();
		resp.setCrmaccount(obj.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_CONTRACT);//合同
		resp.setViewtype(obj.getViewtype());//视图类型
		//合同请求
		ContractReq req = new ContractReq();
		req.setCrmaccount(obj.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		req.setViewtype(obj.getViewtype());
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(obj.getPagecount());
		req.setCurrpage(obj.getCurrpage());
		req.setContractstatus(obj.getContractstatus());
		req.setViewtypesel(obj.getViewtypesel());
		req.setStartdate(obj.getStartdate());
		req.setEnddate(obj.getEnddate());
		req.setAssignId(obj.getAssignId());
		req.setFirstchar(obj.getFirstchar());
		req.setTitle(obj.getTitle());
		req.setOrderString(obj.getOrderString());
		
		//视图类型
		String viewtype = req.getViewtype();
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			
			//List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			
			List<String> rstuid = new ArrayList<String>();
			List<CacheContract> cachelist = new ArrayList<CacheContract>();
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i);
//				log.info("crmid = >" + crmid);
//				//查询接口 获取人的数据列表
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOpenId(openId);
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
			
			//查询接口 获取人的数据列表
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(req.getCrmaccount());
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			uReq.setFlag("");
			uReq.setOpenId(obj.getOpenId());
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
				CacheContract csear = new CacheContract();
				csear.setCrm_id_in(rstuid);
				csear.setStatus(req.getContractstatus());
				csear.setName(req.getTitle());
				csear.setOrderByString(req.getOrderString());
				csear.setCurrpage(( new Integer(obj.getCurrpage()) - 1 ) * new Integer(obj.getPagecount()) );
				csear.setPagecount(new Integer(obj.getPagecount()));
				cachelist = (List<CacheContract>)cRMService.getDbService().getCacheContractService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			List<ContractAdd> rstlist = new ArrayList<ContractAdd>();
			for (CacheContract cacheContract : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContractService().invstransf(cacheContract));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContracts(rstlist);
			return resp;
		}else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				//查询列表
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("Contract");
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
			team.setOpenId(obj.getOpenId());
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheContract> cachelist = new ArrayList<CacheContract>();
			if(rstuid.size() > 0){
				CacheContract csear = new CacheContract();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(new Integer(0));
				csear.setPagecount(new Integer(999));
				csear.setStatus(req.getContractstatus());
				csear.setName(req.getTitle());
				csear.setOrderByString(req.getOrderString());
				csear.setCurrpage(( new Integer(obj.getCurrpage()) - 1 ) * new Integer(obj.getPagecount()) );
				csear.setPagecount(new Integer(obj.getPagecount()));
				cachelist = (List<CacheContract>)cRMService.getDbService().getCacheContractService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			List<ContractAdd> rstlist = new ArrayList<ContractAdd>();
			for (CacheContract cacheContract : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContractService().invstransf(cacheContract));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContracts(rstlist);
			return resp;
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype)){//我的所有的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<String> jsonStrArray = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				req.setCrmaccount(crmid);
				req.setCurrpage("1");
				req.setPagecount("99999");
				req.setOrgUrl(crmIds.get(i).getCrmurl());
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getContractList jsonStr => jsonStr is : " + jsonStr);
				jsonStrArray.add(jsonStr);
			}

			// 单次调用sugar接口
			List<String> rstArray = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArray, Constants.INVOKE_MULITY);
			for(String rst : rstArray){
				try{
					log.info("getContractList rst => rst is : " + rst);
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					if (!jsonObject.containsKey("errcode")) {
						// 错误代码和消息
						String count = jsonObject.getString("count");
						if (!"".equals(count) && Integer.parseInt(count) > 0) {
							List<ContractAdd> list = (List<ContractAdd>) JSONArray.toCollection(jsonObject.getJSONArray("contracts"),ContractAdd.class);
							for(ContractAdd contractAdd : list){
								rstuid.add(contractAdd.getRowid());
							}
						}
					}
				}catch(Exception ec){
					
				}
			}

			
			
			List<CacheContract> cachelist = new ArrayList<CacheContract>();
			if(rstuid.size() > 0){
				CacheContract csear = new CacheContract();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(obj.getCurrpage()) - 1 ) * new Integer(obj.getPagecount()) );
				csear.setPagecount(new Integer(obj.getPagecount()));
				csear.setStatus(req.getContractstatus());
				csear.setName(req.getTitle());
				csear.setOrderByString(req.getOrderString());
				cachelist = (List<CacheContract>)cRMService.getDbService().getCacheContractService().findObjListByFilter(csear);
			}
			List<ContractAdd> rstlist = new ArrayList<ContractAdd>();
			for (CacheContract cacheContract : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContractService().invstransf(cacheContract));
			}
			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContracts(rstlist);
			return resp;
		}else{
			//查询缓存表
			CacheContract csear = new CacheContract();
			csear.setCrm_id(req.getCrmaccount());
			csear.setStatus(req.getContractstatus());
			csear.setName(req.getTitle());
			csear.setOrderByString(req.getOrderString());
			csear.setCurrpage(( new Integer(obj.getCurrpage()) - 1 ) * new Integer(obj.getPagecount()) );
			csear.setPagecount(new Integer(obj.getPagecount()));
			List<CacheContract> cachelist = (List<CacheContract>)cRMService.getDbService().getCacheContractService().findCacheContractListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<ContractAdd> rstlist = new ArrayList<ContractAdd>();
			for (CacheContract cacheContract : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContractService().invstransf(cacheContract));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContracts(rstlist);
			return resp;
		}
 	}

	/**
	 * 查询单个合同数据
	 */
	@SuppressWarnings("unchecked")
	public ContractResp getContractSingle(String rowId, String crmId) {
		CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cacheContract.getCrm_id());
		
		//合同响应
		ContractResp resp = new ContractResp();
		resp.setCrmaccount(crmId);
		resp.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		//合同请求
		ContractAdd gaAdd = new ContractAdd();
		gaAdd.setCrmaccount(crmId);
		gaAdd.setOrgId(cacheContract.getOrg_id());
		gaAdd.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		gaAdd.setType(Constants.ACTION_SEARCHID);
		gaAdd.setRowid(rowId);
		//转换为json
		String jsonStr = JSONObject.fromObject(gaAdd).toString();
		log.info("getContractSingle jsonStr =>  jsonStr is : "+jsonStr);
		//单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("getContractSingle rst => rst is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			List<ContractAdd> list = new ArrayList<ContractAdd>();
			JSONArray jsonArray = jsonObject.getJSONArray("contract");
			for(int i=0;i<jsonArray.size();i++){
				ContractAdd contractAdd = new ContractAdd();
				JSONObject jsonObject2 = (JSONObject)jsonArray.get(i);
				contractAdd.setRowid(jsonObject2.getString("rowid"));
				contractAdd.setParent_name(jsonObject2.getString("parentname"));
				contractAdd.setTitle(jsonObject2.getString("title"));
				contractAdd.setParent_id(jsonObject2.getString("parentid"));
				contractAdd.setParent_type(jsonObject2.getString("parenttype"));
				contractAdd.setStartDate(jsonObject2.getString("startDate"));
				contractAdd.setEndDate(jsonObject2.getString("endDate"));
				contractAdd.setCost(jsonObject2.getString("cost"));
				contractAdd.setDuty(jsonObject2.getString("duty"));
				contractAdd.setDesc(jsonObject2.getString("desc"));
				contractAdd.setAssigner(jsonObject2.getString("assigner"));
				contractAdd.setAssignerid(jsonObject2.getString("assignerid"));
				contractAdd.setCreater(jsonObject2.getString("creater"));
				contractAdd.setCreatedate(jsonObject2.getString("createdate"));
				contractAdd.setModifier(jsonObject2.getString("modifier"));
				contractAdd.setModifydate(jsonObject2.getString("modifydate"));
				contractAdd.setContractstatus(jsonObject2.getString("contractstatus"));
				contractAdd.setContractstatusname(jsonObject2.getString("contractstatusname"));
				contractAdd.setAuditor(jsonObject2.getString("auditor"));
				contractAdd.setInvamttotal(jsonObject2.getString("invamttotal"));
				contractAdd.setRecamttotal(jsonObject2.getString("recamttotal"));
				contractAdd.setReccount(jsonObject2.getString("reccount"));
				contractAdd.setContractCode(jsonObject2.getString("contractCode"));
				contractAdd.setAuthority(jsonObject2.getString("authority"));
				contractAdd.setOrgId(cacheContract.getOrg_id());
				if(jsonObject2.get("approves")!=null&&!"".equals(jsonObject2.get("approves"))){
					List<ApproveAdd> approves =(List<ApproveAdd>)JSONArray.toCollection(jsonObject2.getJSONArray("approves"),ApproveAdd.class);
					contractAdd.setApproves(approves);
				}
				//客户跟进
				if(null != jsonObject2.getString("audits") && !"".equals(jsonObject2.getString("audits"))){
					List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jsonObject2.getJSONArray("audits"), OpptyAuditsAdd.class);
					contractAdd.setAudits(auditsList);
				}
				list.add(contractAdd);
			}
			resp.setContracts(list);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContractSingle errcode => errcode is : "+errcode);
			log.info("getContractSingle errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 增加一个合同
	 */
	public CrmError addContract(Contract obj) {
		CrmError crmErr = new CrmError();
		log.info("addContract start => obj is : "+obj);
		ContractAdd cont = new ContractAdd();
		cont.setCrmaccount(obj.getCrmId());
		cont.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		cont.setType(Constants.ACTION_ADD);
		cont.setTitle(obj.getTitle());
		cont.setStartDate(obj.getStartDate());
		cont.setEndDate(obj.getEndDate());
		cont.setCost(obj.getCost());
		cont.setAssignerid(obj.getAssignerid());
		cont.setContractCode(obj.getContractCode());
		cont.setDesc(obj.getDesc());
		cont.setQuoterowids(obj.getMxrowids());
		cont.setContractstatus(obj.getContractstatus());
		cont.setParent_id(obj.getParent_id());
		cont.setParent_type(obj.getParent_type());
		cont.setParent_name(obj.getParent_name());
		cont.setOrgId(obj.getOrgId());
		//配置 排除某些属相不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"",""});
		String jsonStr = JSONObject.fromObject(cont,jsonConfig).toString(); 
		log.info("addContract jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContract rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContract errcode => errcode is : " + errcode);
			log.info("addContract errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowid = jsonObject.getString("rowid");//记录ID
				log.info("addContract rowid => rowid is : " + rowid);
				crmErr.setRowId(rowid);
				try {
					//同步到缓存
					CacheContract cache = cRMService.getDbService().getCacheContractService().transf(obj.getOrgId(), cont);
					cache.setRowid(rowid);
					cRMService.getDbService().getCacheContractService().addObj(cache);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}
		}
		return crmErr;
	}

	/**
	 * 修改并保存合同信息
	 */
	public CrmError updateContract(Contract obj) {
		CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(obj.getRecordid());
		log.info("newCrmId = >" + cacheContract.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("addContract start => obj is : "+obj);
		ContractAdd cont = new ContractAdd();
		cont.setCrmaccount(obj.getCrmId());
		cont.setOrgId(cacheContract.getOrg_id());
		cont.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		cont.setType(obj.getType());
		cont.setTitle(obj.getTitle());
		cont.setStartDate(obj.getStartDate());
		cont.setEndDate(obj.getEndDate());
		cont.setCost(obj.getCost());
		cont.setAssigner(obj.getCrmId());
		cont.setRecordid(obj.getRecordid());
		cont.setContractstatus(obj.getContractstatus());
		cont.setContractstatusname(obj.getContractstatusname());
		cont.setAuditor(obj.getAuditor());
		cont.setContractCode(obj.getContractCode());
		cont.setAssignerid(obj.getAssignerid());
		cont.setParent_id(obj.getParent_id());
		cont.setDesc(obj.getDesc());
		cont.setCommitid(obj.getCommitid());
		cont.setCommitname(obj.getCommitname());
		cont.setApprovalstatus(obj.getApprovalstatus());
		cont.setApprovalname(obj.getApprovalname());
		cont.setApprovalid(obj.getApprovalid());
		cont.setApprovaldesc(obj.getApprovaldesc());
		cont.setModifiid(obj.getModifiid());
		cont.setRowid(obj.getRecordid());
		//配置 排除某些属相不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"",""});
		String jsonStr = JSONObject.fromObject(cont,jsonConfig).toString(); 
		log.info("addContract jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContract rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContract errcode => errcode is : " + errcode);
			log.info("addContract errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowid = jsonObject.getString("rowid");//记录ID
				log.info("addContract rowid => rowid is : " + rowid);
				crmErr.setRowId(rowid);
			}
		}
		
		try {
			//同步到缓存
			CacheContract cache = cRMService.getDbService().getCacheContractService().transf(null, cont);
			cRMService.getDbService().getCacheContractService().updateObj(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}

	/**
	 * 异步保存合同条款信息
	 */
	public CrmError addPayments(PaymentMethod obj) {
		CrmError crmErr = new CrmError();
		log.info("addPayments start => obj is : "+obj);
		obj.setModeltype(Constants.MODEL_TYPE_CONTRACT);
		obj.setType(Constants.ACTION_ADDPAYS);
		//配置 排除某些属相不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"",""});
		String jsonStr = JSONObject.fromObject(obj,jsonConfig).toString(); 
		log.info("addPayments jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addPayments rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addPayments errcode => errcode is : " + errcode);
			log.info("addCoaddPaymentsntract errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowid = jsonObject.getString("rowid");//记录ID
				log.info("addPayments rowid => rowid is : " + rowid);
				crmErr.setRowId(rowid);
			}
		}
		return crmErr;
	}
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteContract(Contract obj){
		CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(obj.getRecordid());
		log.info("newCrmId = >" + cacheContract.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("delContact start => obj is : " + obj);
		ContractAdd sa = new ContractAdd();
		sa.setCrmaccount(cacheContract.getCrm_id());
		sa.setOrgId(cacheContract.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_OPPTY);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(obj.getRecordid());
		sa.setOptype(obj.getOptype());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
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
			CacheContract cache = new CacheContract();
			cache.setRowid(obj.getRecordid());
			cache.setEnabled_flag("disabled");
			cRMService.getDbService().getCacheContractService().updateEnabledFlag(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}

}
