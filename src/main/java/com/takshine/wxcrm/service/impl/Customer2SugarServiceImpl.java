package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.LinkedList;
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
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerReq;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ScheSingleReq;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Customer2SugarService;

/**
 * 客户任务 相关业务接口实现
 *
 * @author liulin
 */
@Service("customer2SugarService")
public class Customer2SugarServiceImpl extends BaseServiceImpl implements
		Customer2SugarService {

	private static Logger log = Logger.getLogger(Customer2SugarServiceImpl.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询 客户数据列表
	 * 
	 * @param source
	 *            是用于微信平台上，还是在WEB上显示
	 * @return
	 */
	public CustomerResp getCustomerList(Customer sche, String source) throws Exception{
		// 客户响应
		CustomerResp resp = new CustomerResp();
		resp.setCrmaccount(sche.getCrmId());// crm id
		resp.setModeltype(Constants.MODEL_TYPE_ACCNT);
		resp.setViewtype(sche.getViewtype());
		resp.setCurrpage(sche.getCurrpage());
		resp.setPagecount(sche.getPagecount());
		// 客户请求
		CustomerReq sreq = new CustomerReq();
		sreq.setCrmaccount(sche.getCrmId());// crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ACCNT);
		sreq.setViewtype(sche.getViewtype());// 试图类型
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setCurrpage(sche.getCurrpage());
		sreq.setFirstchar(sche.getFirstchar());// 首字母
		sreq.setAccnttype(sche.getAccnttype());//客户类型
		sreq.setIndustry(sche.getIndustry());//行业
		sreq.setAssignerid(sche.getAssignerid());//责任人Id
		sreq.setName(sche.getName());//客户名称
		sreq.setOpenId(sche.getOpenId());
		sreq.setPublicId(sche.getPublicId());
		sreq.setStartDate(sche.getStartdate());//开始时间
		sreq.setEndDate(sche.getEnddate());//结束时间
		sreq.setOpptyid(sche.getOpptyid());
		sreq.setCampaigns(sche.getCampaigns());
		sreq.setParentid(sche.getParentid());
		sreq.setParenttype(sche.getParenttype());
		sreq.setProvince(sche.getProvince());
		sreq.setOrderString(sche.getOrderByString());
		sreq.setTagName(sche.getTagName());   //标签名字
		sreq.setStarflag(sche.getStarflag());  //星标标识
		sreq.setOrgId(sche.getOrgId());//组织
		// 如果是WEB上显示
		if ("WEB".equals(source)) {
			sreq.setPagecount(sche.getPagecount());
		} else {
			sreq.setPagecount(sche.getPagecount());
		}
		
		// 转换为json
		//String jsonStr = JSONObject.fromObject(sreq).toString();
		//log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		//String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
		//		Constants.INVOKE_MULITY);
		String viewtype = sreq.getViewtype();
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			//List<Organization> crmIds = getCrmIdAndOrgIdArr(sreq.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			
			List<String> rstuid = new ArrayList<String>();
			List<CacheCustomer> cachelist = new ArrayList<CacheCustomer>();
			
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i).getCrmId();
//				log.info("crmid = >" + crmid);
//				//查询接口 获取人的数据列表
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOpenId(sche.getOpenId());
//				uReq.setOrgUrl(crmIds.get(i).getCrmurl());
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
				CacheCustomer csear = new CacheCustomer();
				csear.setCrm_id_in(rstuid);
				csear.setName(sreq.getName());
				csear.setAccnttype(sreq.getAccnttype());
				csear.setIndusty(sreq.getIndustry());
				csear.setOrderByString(sreq.getOrderString());
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setTagName(sreq.getTagName());
				csear.setStarflag(sreq.getStarflag());
				cachelist = (List<CacheCustomer>)cRMService.getDbService().getCacheCustomerService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<CustomerAdd> rstlist = new ArrayList<CustomerAdd>();
			for (CacheCustomer cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheCustomerService().invstransf(cacheCustomer));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setCustomers(rstlist);
			return resp;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sreq.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
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
			team.setOpenId(sreq.getOpenId());
			team.setCurrpages(Constants.ZERO);
			team.setPagecounts(Constants.ALL_PAGECOUNT);
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheCustomer> cachelist = new ArrayList<CacheCustomer>();
			if(rstuid.size() > 0){
				CacheCustomer csear = new CacheCustomer();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sreq.getName());
				csear.setAccnttype(sreq.getAccnttype());
				csear.setIndusty(sreq.getIndustry());
				csear.setOrderByString(sreq.getOrderString());
				csear.setTagName(sreq.getTagName());
				csear.setStarflag(sreq.getStarflag());
				cachelist = (List<CacheCustomer>)cRMService.getDbService().getCacheCustomerService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<CustomerAdd> rstlist = new ArrayList<CustomerAdd>();
			for (CacheCustomer cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheCustomerService().invstransf(cacheCustomer));
			}
			
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setCustomers(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype)){//我的所有的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sreq.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<String> jsonStrArray = new LinkedList<String>();
			for (Organization org: crmIds) {
				String crmid = org.getCrmId();
				if(StringUtils.isNotNullOrEmptyStr(sche.getOrgId()) && !org.getOrgId().equals(sche.getOrgId())){
					continue;
				}
				log.info("crmid = >" + crmid);
				sreq.setCrmaccount(crmid);
				if(!StringUtils.isNotNullOrEmptyStr(sche.getOrgId())){
					sreq.setCurrpage("1");
					sreq.setPagecount("99999");
				}
				sreq.setOrgUrl(org.getCrmurl());
				String jsonStr = JSONObject.fromObject(sreq).toString();
				log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
				jsonStrArray.add(jsonStr);
			}

			// 单次调用sugar接口
			List<String> rstArray = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArray, Constants.INVOKE_MULITY);
			
			for(String rst : rstArray){
				try{
					log.info("getCustomerList rst => rst is : " + rst);
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					if (!jsonObject.containsKey("errcode")) {
						// 错误代码和消息
						String count = jsonObject.getString("count");
						if (!"".equals(count) && Integer.parseInt(count) > 0) {
							List<CustomerAdd> list = (List<CustomerAdd>) JSONArray.toCollection(jsonObject.getJSONArray("accnts"),CustomerAdd.class);
							//如果orgId不为空，则默认查询一个org数据，所以直接返回
							if(StringUtils.isNotNullOrEmptyStr(sche.getOrgId())){
								resp.setCustomers(list);
								return resp;
							}
							for(CustomerAdd customerAdd : list){
								rstuid.add(customerAdd.getRowid());
							}
						}
					}
				}catch(Exception ec){
					
				}
			}

			List<CacheCustomer> cachelist = new ArrayList<CacheCustomer>();
			if(rstuid.size() > 0){
				CacheCustomer csear = new CacheCustomer();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sreq.getName());
				csear.setAccnttype(sreq.getAccnttype());
				csear.setIndusty(sreq.getIndustry());
				csear.setOrderByString(sreq.getOrderString());
				csear.setTagName(sreq.getTagName());
				csear.setStarflag(sreq.getStarflag());
				csear.setTagName(sreq.getTagName());
				csear.setStarflag(sreq.getStarflag());
				cachelist = (List<CacheCustomer>)cRMService.getDbService().getCacheCustomerService().findObjListByFilter(csear);
			}
			
			List<CustomerAdd> rstlist = new ArrayList<CustomerAdd>();
			for (CacheCustomer cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheCustomerService().invstransf(cacheCustomer));
			}
			
			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setCustomers(rstlist);
			return resp;
			
		}else{
			//查询缓存表
			CacheCustomer csear = new CacheCustomer();
			csear.setCrm_id(sreq.getCrmaccount());
			csear.setName(sreq.getName());
			csear.setAccnttype(sreq.getAccnttype());
			csear.setIndusty(sreq.getIndustry());
			csear.setOrderByString(sreq.getOrderString());
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			csear.setTagName(sreq.getTagName());
			csear.setStarflag(sreq.getStarflag());
			csear.setOrg_id(sreq.getOrgId());
			List<CacheCustomer> cachelist = (List<CacheCustomer>)cRMService.getDbService().getCacheCustomerService().findCacheCustomerListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<CustomerAdd> rstlist = new ArrayList<CustomerAdd>();
			for (CacheCustomer cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheCustomerService().invstransf(cacheCustomer));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setCustomers(rstlist);
			return resp;
		}
		
		/*// 做空判断
		if (null == rst || "".equals(rst))
			return resp;
		// 解析JSON数据
		log.info("getCustomerList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				List<CustomerAdd> list = (List<CustomerAdd>) JSONArray.toCollection(jsonObject.getJSONArray("accnts"),CustomerAdd.class);
				List<CustomerAdd> clist = new ArrayList<CustomerAdd>();
				for(CustomerAdd customerAdd : list){
					CustomerAdd cadd = new CustomerAdd();
					try {
						BeanUtils.copyProperties(cadd, customerAdd);
					} catch (Exception e) {
						e.printStackTrace();
					} 
					if(!StringUtils.isNotNullOrEmptyStr(customerAdd.getAccnttype())){
						cadd.setAccnttype("未分类");
					}
					clist.add(cadd);
				}
				resp.setCustomers(clist);// 客户列表
			}
			resp.setCount(count);// 数字
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCustomerList errcode => errcode is : " + errcode);
			log.info("getCustomerList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;*/
	}

	/**
	 * 查询单个客户数据
	 * 
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public CustomerResp getCustomerSingle(Customer cust,String flag) {
		//CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cust.getCrmId());
		// 客户响应
		CustomerResp resp = new CustomerResp();
		//resp.setCrmaccount(crmId);// sugar id
		resp.setCrmaccount(cust.getCrmId());// sugar id
		resp.setModeltype(Constants.MODEL_TYPE_ACCNT);
		// 客户请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(cust.getCrmId());// sugar id
//		single.setCrmaccount(cacheCustomer.getCrm_id());// sugar id
		single.setOrgId(cust.getOrgId());//orgid
		single.setModeltype(Constants.MODEL_TYPE_ACCNT);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(cust.getRowId());
		single.setFlag(flag);
		// 转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getCustomerSingle jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
				Constants.INVOKE_MULITY);
		log.info("getCustomerSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			List<CustomerAdd> clist = new ArrayList<CustomerAdd>();
			JSONArray jarr = jsonObject.getJSONArray("accnts");
			for (int i = 0; i < jarr.size(); i++) {
				CustomerAdd cr = new CustomerAdd();
				JSONObject jobj = (JSONObject) jarr.get(i);
				cr.setRowid(jobj.getString("rowid"));
				cr.setName(jobj.getString("name"));
				cr.setPhoneoffice(jobj.getString("phoneoffice"));
				cr.setWebsite(jobj.getString("website"));
				cr.setPhonefax(jobj.getString("phonefax"));
				cr.setAddresstype(jobj.getString("addresstype"));
				cr.setStreet(jobj.getString("street"));
				cr.setCity(jobj.getString("city"));
				cr.setProvince(jobj.getString("province"));
				cr.setPostalcode(jobj.getString("postalcode"));
				cr.setCountry(jobj.getString("country"));
				cr.setDesc(jobj.getString("desc"));
				cr.setAccnttype(jobj.getString("accnttype"));
				cr.setAssignerid(jobj.getString("assignerid"));
				cr.setIndustry(jobj.getString("industry"));
				cr.setAnnualrevenue(jobj.getString("annualrevenue"));
				cr.setEmployees(jobj.getString("employees"));
				cr.setSiccode(jobj.getString("siccode"));
				cr.setTickersymbol(jobj.getString("tickersymbol"));
				cr.setCampaigns(jobj.getString("campaigns"));
				cr.setAssigner(jobj.getString("assigner"));
				cr.setCreater(jobj.getString("creater"));
				cr.setCreatedate(jobj.getString("createdate"));
				cr.setModifier(jobj.getString("modifier"));
				cr.setModifyDate(jobj.getString("modifydate"));
				cr.setIndustryname(jobj.getString("industryname"));
				cr.setAccnttypename(jobj.getString("accnttypename"));
				cr.setCampaignsname(jobj.getString("campaignsname"));
				cr.setAuthority(jobj.getString("authority"));
		
		        cr.setLegal(jobj.getString("legal"));
				cr.setRegistered(jobj.getString("registered"));
				cr.setNature(jobj.getString("nature"));
				cr.setNaturename(jobj.getString("naturename"));
				cr.setProduct(jobj.getString("product"));
				cr.setCustomer(jobj.getString("customer"));
				cr.setBrand(jobj.getString("brand"));
				cr.setSource(jobj.getString("source"));
				cr.setSourcename(jobj.getString("sourcename"));
				cr.setBuilddate(jobj.getString("builddate"));
				cr.setRegistmark(jobj.getString("registmark"));
				cr.setRegistadress(jobj.getString("registadress"));
			//	cr.setParentcompany(jobj.getString("parentcompany"));
			//	cr.setChildcompany(jobj.getString("childcompany"));
			//	cr.setFirms(jobj.getString("firms"));
				cr.setSalesregions(jobj.getString("salesregions"));
				cr.setBuilddate(jobj.getString("builddate"));
				cr.setAbbreviation(jobj.getString("abbreviation"));
			//	cr.setExistvolume(jobj.getString("existvolume"));
			//	cr.setPlanvolume(jobj.getString("planvolume"));
			//	cr.setExistpayment(jobj.getString("existpayment"));
			//	cr.setMustpayment(jobj.getString("mustpayment"));
			//	cr.setPayablepayment(jobj.getString("payablepayment"));
				cr.setOrgId(cust.getOrgId());
			
			
				
				//客户跟进
				if(null != jobj.getString("audits") && !"".equals(jobj.getString("audits"))){
					List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), OpptyAuditsAdd.class);
					cr.setAudits(auditsList);
				}
				
				if (null != jobj.getString("oppties")
						&& !"".equals(jobj.getString("oppties"))) {
					List<OpptyAdd> opptyList = (List<OpptyAdd>) JSONArray
							.toCollection(jobj.getJSONArray("oppties"),
									OpptyAdd.class);
					cr.setOppties(opptyList);
				}
				if (null != jobj.getString("tasks")
						&& !"".equals(jobj.getString("tasks"))) {
					List<ScheduleAdd> taskList = (List<ScheduleAdd>) JSONArray
							.toCollection(jobj.getJSONArray("tasks"),
									ScheduleAdd.class);
					cr.setTasks(taskList);
				}
				clist.add(cr);
			}
			resp.setCustomers(clist);// 客户列表

		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCustomerSingle errcode => errcode is : " + errcode);
			log.info("getCustomerSingle errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 增加客户
	 */
	public CrmError addCustomer(Customer obj) {
		CrmError crmErr = new CrmError();
		log.info("addContract start => obj is : " + obj);
		CustomerAdd cust = new CustomerAdd();
		cust.setCrmaccount(obj.getCrmId());
		cust.setModeltype(Constants.MODEL_TYPE_ACCNT);
		cust.setType(Constants.ACTION_ADD);
		cust.setName(obj.getName());
		cust.setPhoneoffice(obj.getPhoneoffice());
		cust.setAccnttype(obj.getAccnttype());
		cust.setIndustry(obj.getIndustry());
		cust.setAssigner(obj.getAssigner());
		cust.setStreet(obj.getStreet());
		cust.setAnnualrevenue(obj.getAnnualrevenue());
		cust.setDesc(obj.getDesc());
		cust.setWebsite(obj.getWebsite());
		cust.setPhonefax(obj.getPhonefax());
		cust.setPostalcode(obj.getPostalcode());
		cust.setTickersymbol(obj.getTickersymbol());
		cust.setEmployees(obj.getEmployees());
		cust.setSiccode(obj.getSiccode());
		cust.setCampaigns(obj.getCampaigns());
		cust.setAssignerid(obj.getAssignerid());
		cust.setParentid(obj.getParentid());
		cust.setParenttype(obj.getParenttype());
		cust.setOrgId(obj.getOrgId());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[] { "", "" });

		String jsonStr = JSONObject.fromObject(cust, jsonConfig).toString();
		log.info("CustomerAdd jsonStr => jsonStr is : " + jsonStr);

		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
				Constants.ACTION_ADD);
		log.info("CustomerAdd rst => rst is : " + rst);

		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		// 如果请求成功
		if (jsonObject != null) {
			String errcode = jsonObject.getString("errcode");// 错误编码
			String errmsg = jsonObject.getString("errmsg");// 错误消息
			log.info("addContract errcode => errcode is : " + errcode);
			log.info("addContract errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			// 错误编码
			if (ErrCode.ERR_CODE_0.equals(errcode)) {
				String rowId = jsonObject.getString("rowid");// 记录ID
				log.info("addContract rowid => rowid is : " + rowId);
				crmErr.setRowId(rowId);
				
				try {
					//同步到缓存
					CacheCustomer cache = cRMService.getDbService().getCacheCustomerService().transf(obj.getOrgId(), cust);
					cache.setRowid(rowId);
					cRMService.getDbService().getCacheCustomerService().addObj(cache);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}else if("100008".equals(errcode)){
				String rowId = jsonObject.getString("rowid");// 记录ID
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

	/**
	 * 修改客户
	 */
	public CrmError updateCustomer(Customer obj) {
		CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(obj.getRowId());
		log.info("newCrmId = >" + cacheCustomer.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("addContract start => obj is : " + obj);
		CustomerAdd cust = new CustomerAdd();
		//cust.setCrmaccount(obj.getCrmId());
		cust.setCrmaccount(obj.getCrmId());
		cust.setOrgId(cacheCustomer.getOrg_id());
		cust.setModeltype(Constants.MODEL_TYPE_ACCNT);
		cust.setType(Constants.ACTION_UPDATE);
		cust.setName(obj.getName());
		cust.setPhoneoffice(obj.getPhoneoffice());
		cust.setAccnttype(obj.getAccnttype());
		cust.setIndustry(obj.getIndustry());
		cust.setAssigner(obj.getAssigner());
		cust.setStreet(obj.getStreet());
		cust.setAnnualrevenue(obj.getAnnualrevenue());
		cust.setDesc(obj.getDesc());
		cust.setWebsite(obj.getWebsite());
		cust.setPhonefax(obj.getPhonefax());
		cust.setPostalcode(obj.getPostalcode());
		cust.setTickersymbol(obj.getTickersymbol());
		cust.setEmployees(obj.getEmployees());
		cust.setSiccode(obj.getSiccode());
		cust.setCampaigns(obj.getCampaigns());
		cust.setRowid(obj.getRowId());
		cust.setAssignerid(obj.getAssignerid());
		cust.setOptype(obj.getOptype());
		cust.setStar(obj.getStar());  //星标
		
		//新加字段
		cust.setLegal(obj.getLegal());
		cust.setRegistered(obj.getRegistered());
		cust.setNature(obj.getNature());
		cust.setNaturename(obj.getNaturename());
		cust.setProduct(obj.getProduct());
		cust.setCustomer(obj.getCustomer());
		cust.setBrand(obj.getBrand());
		cust.setSource(obj.getSource());
		cust.setSourcename(obj.getSourcename());
		cust.setBuilddate(obj.getBuilddate());
		cust.setRegistmark(obj.getRegistmark());
		cust.setRegistadress(obj.getRegistadress());
		cust.setParentcompany(obj.getParentcompany());
		cust.setChildcompany(obj.getChildcompany());
		cust.setFirms(obj.getFirms());
		cust.setSalesregions(obj.getSalesregions());
		cust.setAbbreviation(obj.getAbbreviation());
		cust.setExistvolume(obj.getExistvolume());
		cust.setPlanvolume(obj.getPlanvolume());
		cust.setMustpayment(obj.getMustpayment());
		cust.setExistpayment(obj.getExistpayment());
		cust.setPayablepayment(obj.getPayablepayment());
		
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[] {  "currency", "creater","createdate", "tasks", "audits", "cons", "errcode", "errmsg" });

		String jsonStr = JSONObject.fromObject(cust, jsonConfig).toString();
		log.info("updateOppty jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
				Constants.INVOKE_SINGLE);
		log.info("updateOppty rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");// 错误编码
			String errmsg = jsonObject.getString("errmsg");// 错误消息
			log.info("addSchedule errcode => errcode is : " + errcode);
			log.info("addSchedule errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		
		try {
			//同步到缓存
			CacheCustomer cache = cRMService.getDbService().getCacheCustomerService().transf(null, cust);
			cRMService.getDbService().getCacheCustomerService().updateObj(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}

	/**
	 * 删除客户
	 */
	public CrmError deleteCustomer(Customer obj) {
		CacheCustomer cacheCustomer = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(obj.getRowId());
		log.info("newCrmId = >" + cacheCustomer.getCrm_id());
		CrmError crmErr = new CrmError();
		log.info("deleteCustomer start => obj is : " + obj);
		CustomerAdd sa = new CustomerAdd();
		sa.setCrmaccount(cacheCustomer.getCrm_id());
		sa.setOrgId(cacheCustomer.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_ACCNT);
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
			cRMService.getDbService().getCacheCustomerService().updCacheCustomerByRowid(obj.getRowId());
		} catch (Exception e) {
			log.info("deleteCustomer updCacheCustomerByRowid error = >" + e.getMessage());
		}
		return crmErr;
	}
}
