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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.OpptyReq;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ScheSingleReq;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Oppty2SugarService;

/**
 * 业务机会   相关业务接口实现
 *
 * @author liulin
 */
@Service("oppty2SugarService")
public class Oppty2SugarServiceImpl extends BaseServiceImpl implements Oppty2SugarService {
	
	private static Logger log = Logger.getLogger(Oppty2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询 业务机会数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public OpptyResp getOpportunityList(Opportunity oppty,String source)throws Exception{
		//业务机会响应
		OpptyResp resp = new OpptyResp();
		resp.setCrmaccount(oppty.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_OPPTY);
		resp.setViewtype(oppty.getViewtype());
		resp.setCurrpage(oppty.getCurrpage());
		resp.setPagecount(oppty.getPagecount());
		//业务机会请求
		OpptyReq sreq = new OpptyReq();
		sreq.setCrmaccount(oppty.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_OPPTY);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setViewtype(oppty.getViewtype());
		sreq.setCurrpage(oppty.getCurrpage());
		sreq.setCampaigns(oppty.getCampaigns());
		//查询条件
		sreq.setFirstchar(oppty.getFirstchar());//首字母
		sreq.setOpptyname(oppty.getOpptyname());//业务机会名称
		sreq.setSalesStage(oppty.getSalesstage());//业务机会阶段
		sreq.setStartDate(oppty.getStartDate());//关闭的开始时间
		sreq.setEndDate(oppty.getEndDate());//关闭的结束时间
		sreq.setAssignId(oppty.getAssignId());//责任人
		sreq.setCstartdate(oppty.getCstartdate());//创建的开始时间
		sreq.setCenddate(oppty.getCenddate());//创建的结束时间
		sreq.setClosedate(oppty.getDateclosed());
		sreq.setFailreason(oppty.getFailreason());
		sreq.setParentId(oppty.getParentId());
		sreq.setOrderString(oppty.getOrderByString());
		sreq.setTagName(oppty.getTagName());
		sreq.setStarflag(oppty.getStarflag());
		sreq.setOrgId(oppty.getOrgId());
		//如果是WEB上显示
		if("WEB".equals(source)){
			sreq.setPagecount(oppty.getPagecount());
		}else{
			sreq.setPagecount(oppty.getPagecount());
		}
		
		//view type
		String viewtype = sreq.getViewtype();
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			//List<Organization> crmIds = getCrmIdAndOrgIdArr(oppty.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			
			List<String> rstuid = new ArrayList<String>();
			List<CacheOppty> cachelist = new ArrayList<CacheOppty>();
			
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i).getCrmId();
//				log.info("crmid = >" + crmid);
//				
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOrgUrl(crmIds.get(i).getCrmurl());
//				uReq.setOpenId(oppty.getOpenId());
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
			
			//在lovuser service中，已经根据id进行循环，此外不需要再循环了
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(sreq.getCrmaccount());
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			uReq.setFlag("");
			uReq.setOpenId(oppty.getOpenId());
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
				CacheOppty csear = new CacheOppty();
				csear.setCrm_id_in(rstuid);
				csear.setName(sreq.getOpptyname());
				csear.setStage(sreq.getSalesStage());
				csear.setStart_date(sreq.getStartDate());
				csear.setEnd_date(sreq.getEndDate());
				csear.setOrderByStringSec(sreq.getOrderString());
				csear.setStarflag(sreq.getStarflag());
				csear.setTagName(sreq.getTagName());
				csear.setCurrpage(( new Integer(oppty.getCurrpage()) - 1 ) * new Integer(oppty.getPagecount()) );
				csear.setPagecount(new Integer(oppty.getPagecount()));
				cachelist = (List<CacheOppty>)cRMService.getDbService().getCacheOpptyService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<OpptyAdd> rstlist = new ArrayList<OpptyAdd>();
			for (CacheOppty cacheOppty : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheOpptyService().invstransf(cacheOppty));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setOpptys(rstlist);
			return resp;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(oppty.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				//查询列表
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setOrgUrl(crmIds.get(i).getCrmurl());
				sc.setParenttype("Opportunities");
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
			team.setOpenId(oppty.getOpenId());
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheOppty> cachelist = new ArrayList<CacheOppty>();
			if(rstuid.size() > 0){
				CacheOppty csear = new CacheOppty();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(oppty.getCurrpage()) - 1 ) * new Integer(oppty.getPagecount()) );
				csear.setPagecount(new Integer(oppty.getPagecount()));
				csear.setName(sreq.getOpptyname());
				csear.setStage(sreq.getSalesStage());
				csear.setStart_date(sreq.getStartDate());
				csear.setEnd_date(sreq.getEndDate());
				csear.setOrderByStringSec(sreq.getOrderString());
				csear.setStarflag(sreq.getStarflag());
				csear.setTagName(sreq.getTagName());
				cachelist = (List<CacheOppty>)cRMService.getDbService().getCacheOpptyService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			//结果集合
			List<OpptyAdd> rstlist = new ArrayList<OpptyAdd>();
			for (CacheOppty cacheOppty : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheOpptyService().invstransf(cacheOppty));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setOpptys(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype) //myallview 我的所有的 
					|| Constants.SEARCH_VIEW_TYPE_NOTICEVIEW.equals(viewtype)){  //noteice view 循环查询后台 查询所有的数据 到前台
			List<Organization> crmIds = getCrmIdAndOrgIdArr(oppty.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				if(StringUtils.isNotNullOrEmptyStr(oppty.getOrgId())&&!crmid.equals(sreq.getCrmaccount())){
					continue;
				}
				log.info("crmid = >" + crmid);
				sreq.setCrmaccount(crmid);
				sreq.setOrgUrl(crmIds.get(i).getCrmurl());
				if(!StringUtils.isNotNullOrEmptyStr(oppty.getOrgId())){
					sreq.setCurrpage("1");
					sreq.setPagecount("99999");
				}
				String jsonStr = JSONObject.fromObject(sreq).toString();
				log.info("getOpptyList jsonStr => jsonStr is : " + jsonStr);
				// 单次调用sugar接口
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
				log.info("getOpptyList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<OpptyAdd> list = (List<OpptyAdd>) JSONArray.toCollection(jsonObject.getJSONArray("opptys"), OpptyAdd.class);
						//如果orgId不为空，则默认查询一个org数据，所以直接返回
						if(StringUtils.isNotNullOrEmptyStr(oppty.getOrgId())){
							resp.setOpptys(list);
							return resp;
						}
						for(OpptyAdd opptyAdd : list){
							rstuid.add(opptyAdd.getRowid());
						}
					}
				}
			}
			
			List<CacheOppty> cachelist = new ArrayList<CacheOppty>();
			if(rstuid.size() > 0){
				CacheOppty csear = new CacheOppty();
				csear.setRowid_in(rstuid);
				csear.setName(sreq.getOpptyname());
				csear.setStage(sreq.getSalesStage());
				csear.setStart_date(sreq.getStartDate());
				csear.setEnd_date(sreq.getEndDate());
				csear.setOrderByStringSec(sreq.getOrderString());
				csear.setStarflag(sreq.getStarflag());
				csear.setTagName(sreq.getTagName());
				csear.setCurrpage(( new Integer(oppty.getCurrpage()) - 1 ) * new Integer(oppty.getPagecount()) );
				csear.setPagecount(new Integer(oppty.getPagecount()));
				cachelist = (List<CacheOppty>)cRMService.getDbService().getCacheOpptyService().findObjListByFilter(csear);
			}
			
			List<OpptyAdd> rstlist = new ArrayList<OpptyAdd>();
			for (CacheOppty cacheOppty : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheOpptyService().invstransf(cacheOppty));
			}
			
			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setOpptys(rstlist);
			return resp;
		
		}else{
			//查询缓存表
			CacheOppty csear = new CacheOppty();
			csear.setCrm_id(sreq.getCrmaccount());
			csear.setName(sreq.getOpptyname());
			csear.setStage(sreq.getSalesStage());
			csear.setStart_date(sreq.getStartDate());
			csear.setEnd_date(sreq.getEndDate());
			csear.setOrderByStringSec(sreq.getOrderString());
			csear.setCurrpage(( new Integer(oppty.getCurrpage()) - 1 ) * new Integer(oppty.getPagecount()) );
			csear.setPagecount(new Integer(oppty.getPagecount()));
			String orderByString = "";
			csear.setStarflag(sreq.getStarflag());
			csear.setTagName(sreq.getTagName());
			if(Constants.SEARCH_VIEW_TYPE_MYWONVIEW.equals(viewtype)){
				orderByString = " and stage = 'Closed Won'";
			}else if(Constants.SEARCH_VIEW_TYPE_MYCLOSEDVIEW.equals(viewtype)){
				orderByString = " and (stage = 'Closed Lost' or stage = 'Abandon')";
			}else if(Constants.SEARCH_VIEW_TYPE_MYFOLLOWINGVIEW.equals(viewtype)){
				orderByString = " and stage <> 'Closed Lost' and stage <> 'Abandon' and stage <> 'Closed Won' ";
			}
			csear.setOrderByString(orderByString);
			csear.setOrg_id(sreq.getOrgId());
			List<CacheOppty> cachelist = (List<CacheOppty>)cRMService.getDbService().getCacheOpptyService().findCacheOpptyListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<OpptyAdd> rstlist = new ArrayList<OpptyAdd>();
			for (CacheOppty cacheOppty : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheOpptyService().invstransf(cacheOppty));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setOpptys(rstlist);
			return resp;
		}
		
		/*//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getOpportunityList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getOpportunityList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<OpptyAdd> olist = (List<OpptyAdd>)JSONArray.toCollection(jsonObject.getJSONArray("opptys"), OpptyAdd.class);
				resp.setOpptys(olist);//业务机会列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
			log.info("getOpportunityList errcode => errcode is : " + errcode);
			log.info("getOpportunityList errmsg => errmsg is : " + errmsg);
		}
		return resp;*/
	}
	
	/**
	 * 查询单个业务机会数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public OpptyResp getOpportunitySingle(String rowId, String crmId){
		CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cacheOppty.getCrm_id());
		
		//业务机会响应
		OpptyResp resp = new OpptyResp();
		resp.setCrmaccount(crmId);//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_OPPTY);
		//业务机会请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(crmId);//sugar id
		single.setOrgId(cacheOppty.getOrg_id());
		single.setModeltype(Constants.MODEL_TYPE_OPPTY);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowId);
		
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getOpportunitySingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getOpportunitySingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			List<OpptyAdd> olist = new ArrayList<OpptyAdd>();
			JSONArray jarr = jsonObject.getJSONArray("opptys");
			OpptyAdd opp = null;
			for(int i = 0; i < jarr.size() ;i++){
				opp = new OpptyAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				opp.setAmount(jobj.getString("amount"));
				opp.setAssigner(jobj.getString("assigner"));
				opp.setCampaigns(jobj.getString("campaigns"));
				opp.setCreatedate(jobj.getString("createdate"));
				opp.setCreater(jobj.getString("creater"));
				opp.setCurrency(jobj.getString("currency"));
				opp.setCustomerid(jobj.getString("customerid"));
				opp.setCustomername(jobj.getString("customername"));
				opp.setDateclosed(jobj.getString("dateclosed"));
				opp.setDesc(jobj.getString("description"));
				opp.setLeadsource(jobj.getString("leadsource"));
				opp.setModifier(jobj.getString("modifier"));
				opp.setModifyDate(jobj.getString("modifydate"));
				opp.setName(jobj.getString("name"));
				opp.setNextstep(jobj.getString("nextstep"));
				opp.setOpptytype(jobj.getString("opptytype"));
				opp.setProbability(jobj.getString("probability"));
				opp.setRowid(jobj.getString("rowid"));
				opp.setSalesstage(jobj.getString("salesstage"));
				opp.setSalesstagename(jobj.getString("salesstagename"));
				opp.setFeedid(jobj.getString("feedid"));
				opp.setCompetitive(jobj.getString("competitive"));
				opp.setCompetitiveName(jobj.getString("competitivename"));
				opp.setAssignerid(jobj.getString("assignerid"));
				opp.setLeadsourcename(jobj.getString("leadsourcename"));
				opp.setOpptytypename(jobj.getString("opptytypename"));
				opp.setCampaignsname(jobj.getString("campaignsname"));
				opp.setGxml(jobj.getString("gxml"));
				opp.setEffectxml(jobj.getString("effectxml"));
				opp.setFailreason(jobj.getString("failreason"));
				opp.setAuthority(jobj.getString("authority"));
				opp.setOrgId(cacheOppty.getOrg_id());
				//opp.setCompetitive(jobj.getString("competitive"));
				//opp.setCompetitive(jobj.getString("competitiveName"));
				//opp.setFactdateclosed(jobj.getString("factdateclosed"));
				//业务机会跟进
				if(null != jobj.getString("audits") && !"".equals(jobj.getString("audits"))){
					List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), OpptyAuditsAdd.class);
					opp.setAudits(auditsList);
				}
				//放入业务机会列表集合
				olist.add(opp);
			}
			resp.setOpptys(olist);//任务列表
			
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getOpportunitySingle errcode => errcode is : " + errcode);
			log.info("getOpportunitySingle errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 更新单个业务机会数据
	 * @param oppty
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public CrmError updateOppty(Opportunity oppty)throws Exception{
		CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(oppty.getRowId());
		log.info("newCrmId = >" + oppty.getCrmId());
		
		CrmError crmErr = new CrmError();
		log.info("updateOppty start => obj is : " + oppty);
		OpptyAdd sa = new OpptyAdd();
		sa.setCrmaccount(oppty.getCrmId());//crmId
		sa.setOrgId(cacheOppty.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_OPPTY);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(oppty.getRowId());//rowId
		sa.setDateclosed(oppty.getDateclosed());//关闭日期
		sa.setSalesstage(oppty.getSalesstage());//销售阶段
		sa.setAmount(oppty.getAmount());//金额
		sa.setLoseDesc(oppty.getLoseDesc());//丢单描述
		sa.setCustomername(oppty.getCustomername());//客户名称
		sa.setCustomerid(oppty.getCustomerid());//客户ID
		sa.setProbability(oppty.getProbability());//成交概率
		sa.setOpptytype(oppty.getOpptytype());//业务机会类型
		sa.setLeadsource(oppty.getLeadsource());//潜在客户
		sa.setNextstep(oppty.getNextstep());//下一步骤
		sa.setCampaigns(oppty.getCampaigns());//市场活动
		sa.setCampaignsname(oppty.getCampaignsname());//市场活动名称
		sa.setDesc(oppty.getDesc());//描述
		sa.setModifyDate(oppty.getModifydate());//修改日期
		sa.setGxml(oppty.getGxml());
		sa.setEffectxml(oppty.getEffectxml());
		sa.setFailreason(oppty.getFailreason());//失败原因
		sa.setAssignerid(oppty.getAssignId());//责任人
		sa.setOptype(oppty.getOptype());//操作类型
		sa.setFactdateclosed(oppty.getFactdateclosed());//实际关闭日期
		sa.setCompetitive(oppty.getCompetitive()); //竞争策略
		sa.setName(oppty.getName());//生意名称
		String opptyAmount = oppty.getAmount();
		if(StringUtils.isNotNullOrEmptyStr(opptyAmount)){
			CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(oppty.getCustomerid());
			String oppty_amount = cacheCustomer.getOppty_amount();
			String amount = cacheCustomer.getAmount();
			if(!StringUtils.isNotNullOrEmptyStr(oppty_amount)){
				oppty_amount = "0";
			}
			if(!StringUtils.isNotNullOrEmptyStr(amount)){
				amount = "0";
			}
			if("Closed Won".equals(oppty.getSalesstage())){
				cacheCustomer.setAmount(StringUtils.addAmount(amount,opptyAmount));
				cacheCustomer.setOppty_amount(StringUtils.getMargin(oppty_amount,opptyAmount));
			}else if(!"Closed Won".equals(oppty.getSalesstage())&&!"Closed Lost".equals(oppty.getSalesstage())&&!"Abandon".equals(oppty.getSalesstage())){
				cacheCustomer.setOppty_amount(opptyAmount);
			}
			cRMService.getDbService().getCacheCustomerService().updateObj(cacheCustomer);
			
		}
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"currency",
				"creater","createdate","tasks","audits","cons","errcode","errmsg"});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("updateOppty jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateOppty rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addSchedule errcode => errcode is : " + errcode);
			log.info("addSchedule errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		
		try {
			//同步到缓存
			CacheOppty cache = cRMService.getDbService().getCacheOpptyService().transf(null, sa);
			cRMService.getDbService().getCacheOpptyService().updateObj(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}
    
	//保存业务机会信息
	public CrmError addOppty(Opportunity obj) {
		CrmError crmErr = new CrmError();
		// TODO Auto-generated method stub
		log.info("addOppty start => obj is : " + obj);
		OpptyAdd op = new OpptyAdd();
		op.setCrmaccount(obj.getCrmId());
		op.setModeltype(Constants.MODEL_TYPE_OPPTY);
		op.setType(Constants.ACTION_ADD);
		op.setName(obj.getOpptyname());//业务机会名称
		op.setCustomerid(obj.getCustomerid());
		op.setAmount(obj.getAmount());//业务机会金额
		op.setDateclosed(obj.getDateclosed());
		op.setProbability(obj.getProbability());
		op.setOpptytype(obj.getOpptytype());
		op.setLeadsource(obj.getLeadsource());
		op.setSalesstage(obj.getSalesstage());
		op.setAssigner(obj.getAssignId());
		op.setDesc(obj.getDesc());
		op.setCampaigns(obj.getCampaigns());
		op.setParentid(obj.getParentId());
		op.setParenttype(obj.getParentType());
		op.setOrgId(obj.getOrgId());
		op.setCompetitive(obj.getCompetitive());
		op.setNextstep(obj.getNextstep());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(op, jsonConfig).toString();
		log.info("addOppty jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addOppty rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addOppty errcode => errcode is : " + errcode);
			log.info("addOppty errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addOppty rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
				
				try {
					//同步到缓存
					CacheOppty cache = cRMService.getDbService().getCacheOpptyService().transf(obj.getOrgId(), op);
					cache.setRowid(rowId);
					cRMService.getDbService().getCacheOpptyService().addObj(cache);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}
			
		}
		return crmErr;
	}
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteOpportunity(Opportunity obj){
		CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(obj.getRowId());
		log.info("newCrmId = >" + cacheOppty.getCrm_id());
		CrmError crmErr = new CrmError();
		log.info("delContact start => obj is : " + obj);
		CustomerAdd sa = new CustomerAdd();
		sa.setCrmaccount(cacheOppty.getCrm_id());
		sa.setOrgId(cacheOppty.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_OPPTY);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(obj.getRowId());
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
			CacheOppty cache = new CacheOppty();
			cache.setRowid(obj.getRowId());
			cache.setEnabled_flag("disabled");
			cRMService.getDbService().getCacheOpptyService().updateEnabledFlag(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}

}
