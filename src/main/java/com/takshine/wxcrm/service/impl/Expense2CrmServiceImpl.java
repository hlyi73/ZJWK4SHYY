package com.takshine.wxcrm.service.impl;

import java.lang.reflect.InvocationTargetException;
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
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Expense;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheExpense;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveAdd;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.message.sugar.ExpenseReq;
import com.takshine.wxcrm.message.sugar.ExpenseResp;
import com.takshine.wxcrm.message.sugar.ScheSingleReq;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Expense2CrmService;
import com.takshine.wxcrm.service.Schedule2SugarService;

/**
 * 日程任务   相关业务接口实现
 *
 * @author liulin
 */
@Service("expense2CrmService")
public class Expense2CrmServiceImpl extends BaseServiceImpl implements Expense2CrmService{
	
	private static Logger log = Logger.getLogger(Expense2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	public BaseModel initObj() {
		return null;
	}
	
	
/*	public static final String cachegroup = Expense2CrmServiceImpl.class.getName();
	
	public final ExpenseAdd getDataFromCache(String rowid) throws IllegalAccessException, InvocationTargetException, CRMException{
		
		ExpenseAdd data = (ExpenseAdd) this.cRMService.getBusinessService().getCacheService().get(cachegroup,rowid);
		if (data == null){
			//data = this.getExpenseSingle(sche, crmId)(rowid);
			this.cRMService.getBusinessService().getCacheService().set(cachegroup,rowid, data);
		}
		return data;
	}
	public final void putDataFromCache(String rowid,ExpenseAdd data){
		this.cRMService.getBusinessService().getCacheService().set(cachegroup,rowid, data);
	}
	public final void removeDataFromCache(String rowid){
		this.cRMService.getBusinessService().getCacheService().remove(cachegroup,rowid);
	}
	public final void clearDataFromCache(){
		this.cRMService.getBusinessService().getCacheService().clear(cachegroup);
	}
*/
	
	
	/**
	 * 查询 日程数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public ExpenseResp getExpenseList(Expense sche,String source) throws Exception{
		//日程响应
		ExpenseResp resp = new ExpenseResp();
		resp.setCrmaccount(sche.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		resp.setViewtype(sche.getViewtype());
		//日程请求
		ExpenseReq sreq = new ExpenseReq();
		sreq.setCrmaccount(sche.getCrmId());//crm id
		sreq.setLicinfostr(sche.getLicinfostr());//licenses info
		sreq.setLicinfosign(sche.getLicinfosign());//licenses sign
		sreq.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		sreq.setViewtype(sche.getViewtype());//视图类型
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setExpensedate(sche.getExpensedate());
		sreq.setDepart(sche.getDepart());
		sreq.setApproval(sche.getApproval());
		sreq.setExpensesubtype(sche.getExpensesubtype());
		sreq.setAssignerId(sche.getAssignid());
		sreq.setExpensesubtypename(sche.getExpensesubtypename());
		sreq.setStartDate(sche.getStartDate());
		sreq.setEndDate(sche.getEndDate());
		sreq.setExpensetype(sche.getExpensetype());
		sreq.setParentid(sche.getParentid());
		sreq.setParenttype(sche.getParenttype());
		sreq.setOrderString(sche.getOrderByString());
		sreq.setPagecount(sche.getPagecount());
		sreq.setCurrpage(sche.getCurrpage());
		sreq.setOrgId(sche.getOrgId());
		
		//所有的
		if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(sche.getViewtype())){
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<String> jsonStrArry = new LinkedList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				sreq.setCrmaccount(crmid);
				sreq.setCurrpage("1");
				sreq.setPagecount("99999");
				sreq.setOrgUrl(crmIds.get(i).getCrmurl());
				String jsonStr = JSONObject.fromObject(sreq).toString();
				log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
				jsonStrArry.add(jsonStr);
			}

			
			List<String> rstArry = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArry, Constants.INVOKE_MULITY);
			for(String rst : rstArry){
				try{
					log.info("getCustomerList rst => rst is : " + rst);
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					if (!jsonObject.containsKey("errcode")) {
						// 错误代码和消息
						String count = jsonObject.getString("count");
						if (!"".equals(count) && Integer.parseInt(count) > 0) {
							List<ExpenseAdd> list = (List<ExpenseAdd>) JSONArray.toCollection(jsonObject.getJSONArray("expenses"),ExpenseAdd.class);
							for(ExpenseAdd expenseAdd : list){
								rstuid.add(expenseAdd.getRowid());
							}
						}
					}
				}catch(Exception ec){
					
				}
			}
			
			
			
			List<CacheExpense> cachelist = new ArrayList<CacheExpense>();
			if(rstuid.size() > 0){
				CacheExpense csear = new CacheExpense();
				csear.setRowid_in(rstuid);
				csear.setExpense_status(sche.getApproval());
				csear.setExpense_subtype(sche.getExpensesubtype());
				csear.setExpense_type(sche.getExpensetype());
				csear.setCurrpage(( new Integer(sreq.getCurrpage()) - 1 ) * new Integer(sreq.getPagecount()) );
				csear.setPagecount(new Integer(sreq.getPagecount()));
				cachelist = (List<CacheExpense>)cRMService.getDbService().getCacheExpenseService().findObjListByFilter(csear);
			}
			
			List<ExpenseAdd> rstlist = new ArrayList<ExpenseAdd>();
			for (CacheExpense cacheExpense : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheExpenseService().invstransf(cacheExpense));
			}
			
			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setExpenses(rstlist);
			return resp;
		}
		//下属的
		else if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(sche.getViewtype())){
			List<String> rstuid = new ArrayList<String>();
			List<CacheExpense> cachelist = new ArrayList<CacheExpense>();
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(sreq.getCrmaccount());
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			uReq.setFlag("");
			uReq.setOpenId(sreq.getOpenId());
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
				CacheExpense csear = new CacheExpense();
				csear.setCrm_id_in(rstuid);
				csear.setExpense_status(sche.getApproval());
				csear.setExpense_subtype(sche.getExpensesubtype());
				csear.setExpense_type(sche.getExpensetype());
				cachelist = (List<CacheExpense>)cRMService.getDbService().getCacheExpenseService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ExpenseAdd> rstlist = new ArrayList<ExpenseAdd>();
			for (CacheExpense cacheExpense : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheExpenseService().invstransf(cacheExpense));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setExpenses(rstlist);
			return resp;
		}
		//分享的
		else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(sche.getViewtype())){
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sreq.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("Expense");
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
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheExpense> cachelist = new ArrayList<CacheExpense>();
			if(rstuid.size() > 0){
				CacheExpense csear = new CacheExpense();
				csear.setRowid_in(rstuid);
				csear.setExpense_status(sche.getApproval());
				csear.setExpense_subtype(sche.getExpensesubtype());
				csear.setExpense_type(sche.getExpensetype());
				csear.setCurrpage(new Integer(0));
				csear.setPagecount(new Integer(999));
				cachelist = (List<CacheExpense>)cRMService.getDbService().getCacheExpenseService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ExpenseAdd> rstlist = new ArrayList<ExpenseAdd>();
			for (CacheExpense cacheExpense : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheExpenseService().invstransf(cacheExpense));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setExpenses(rstlist);
			return resp;
		}
		//我的
		else{
			//查询缓存表
			CacheExpense csear = new CacheExpense();
			csear.setCrm_id(sche.getCrmId());
			csear.setExpense_status(sche.getApproval());
			csear.setExpense_subtype(sche.getExpensesubtype());
			csear.setExpense_type(sche.getExpensetype());
			csear.setOrderByString(sche.getOrderByString());
			csear.setOrg_id(sche.getOrgId());
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			List<CacheExpense> cachelist = (List<CacheExpense>)cRMService.getDbService().getCacheExpenseService().findCacheExpenseListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<ExpenseAdd> rstlist = new ArrayList<ExpenseAdd>();
			for (CacheExpense cacheExpense : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheExpenseService().invstransf(cacheExpense));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setExpenses(rstlist);
			return resp;
		}
		
	}
	
	/**
	 * 查询单个日程数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public ExpenseResp getExpenseSingle(Expense sche, String crmId){
		//日程响应
		ExpenseResp resp = new ExpenseResp();
		resp.setCrmaccount(crmId);//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		//日程请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(crmId);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(sche.getRowId());
		single.setOrgId(sche.getOrgId());
		
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getExpenseSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getExpenseSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			List<ExpenseAdd> slist = new ArrayList<ExpenseAdd>();
			JSONArray jarr = jsonObject.getJSONArray("expense");
			for(int i = 0; i < jarr.size() ;i++){
				ExpenseAdd cr = new ExpenseAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				cr.setRowid(jobj.getString("rowid"));
				cr.setName(jobj.getString("name"));
				cr.setExpensestatus(jobj.getString("expensestatus"));
				cr.setExpensestatusname(jobj.getString("expensestatusname"));
				cr.setExpensedate(jobj.getString("expensedate"));
				cr.setExpenseamount(jobj.getString("expenseamount"));
				cr.setAssigner(jobj.getString("assigner"));
				cr.setAssignid(jobj.getString("assignid"));
				cr.setDesc(jobj.getString("desc"));
				cr.setExpensetype(jobj.getString("expensetype"));
				cr.setExpensetypename(jobj.getString("expensetypename"));
				cr.setExpensesubtype(jobj.getString("expensesubtype"));
				cr.setExpensesubtypename(jobj.getString("expensesubtypename"));
				cr.setParenttype(jobj.getString("parenttype"));
				cr.setParentid(jobj.getString("parentid"));
				cr.setCreater(jobj.getString("creater"));
				cr.setCreatedate(jobj.getString("createdate"));
				cr.setModifier(jobj.getString("modifier"));
				cr.setModifydate(jobj.getString("modifydate"));
				cr.setParentname(jobj.getString("parentname"));
				cr.setAuditor(jobj.getString("auditor"));
				cr.setDesc(jobj.getString("desc"));
				cr.setDepartment(jobj.getString("department"));//费用部门
				cr.setDepartmentname(jobj.getString("departmentname"));//费用部门
				cr.setExpUserName(jobj.getString("expUserName")); //费用对象
				cr.setParentdepart(jobj.getString("parentdepart")); //
				cr.setParentdepartname(jobj.getString("parentdepartname")); //
				if(null != jobj.get("audits") && !"".equals(jobj.get("audits"))){
					List<ApproveAdd> approlist = (List<ApproveAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), ApproveAdd.class);
					cr.setApproves(approlist);
				}
				slist.add(cr);
				resp.setExpenses(slist);
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getExpenseSingle errcode => errcode is : " + errcode);
			log.info("getExpenseSingle errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}
	
	/**
	 * 查询已核销报销的原始信息
	 * @return
	 */
	public ExpenseResp getOriginalExpense(Expense expense){
		//日程响应
		ExpenseResp resp = new ExpenseResp();
		resp.setCrmaccount(expense.getCrmId());//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		//日程请求
		ExpenseReq single = new ExpenseReq();
		single.setCrmaccount(expense.getCrmId());//sugar id
		single.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(expense.getRowId());
		single.setOriginal(expense.getOriginal());
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getOriginalExpense jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getOriginalExpense rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			List<ExpenseAdd> slist = new ArrayList<ExpenseAdd>();
			JSONArray jarr = jsonObject.getJSONArray("expense");
			for(int i = 0; i < jarr.size() ;i++){
				ExpenseAdd cr = new ExpenseAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				cr.setRowid(jobj.getString("rowid"));
				cr.setName(jobj.getString("name"));
				cr.setExpensestatus(jobj.getString("expensestatus"));
				cr.setExpensestatusname(jobj.getString("expensestatusname"));
				cr.setExpensedate(jobj.getString("expensedate"));
				cr.setExpenseamount(jobj.getString("expenseamount"));
				cr.setAssigner(jobj.getString("assigner"));
				cr.setAssignid(jobj.getString("assignid"));
				cr.setDesc(jobj.getString("desc"));
				cr.setExpensetype(jobj.getString("expensetype"));
				cr.setExpensetypename(jobj.getString("expensetypename"));
				cr.setExpensesubtype(jobj.getString("expensesubtype"));
				cr.setExpensesubtypename(jobj.getString("expensesubtypename"));
				cr.setParenttype(jobj.getString("parenttype"));
				cr.setParentid(jobj.getString("parentid"));
				cr.setCreater(jobj.getString("creater"));
				cr.setCreatedate(jobj.getString("createdate"));
				cr.setModifier(jobj.getString("modifier"));
				cr.setModifydate(jobj.getString("modifydate"));
				cr.setParentname(jobj.getString("parentname"));
				cr.setAuditor(jobj.getString("auditor"));
				cr.setDesc(jobj.getString("desc"));
				cr.setDepartment(jobj.getString("department"));//费用部门
				cr.setDepartmentname(jobj.getString("departmentname"));//费用部门
				cr.setExpUserName(jobj.getString("expUserName")); //费用对象
				cr.setParentdepart(jobj.getString("parentdepart")); //
				cr.setParentdepartname(jobj.getString("parentdepartname")); //
				slist.add(cr);
				resp.setExpenses(slist);
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getOriginalExpense errcode => errcode is : " + errcode);
			log.info("getOriginalExpense errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}
	
	
	/**
	 * 保存费用信息
	 * @param obj
	 * @return
	 */
	public CrmError addExpense(Expense obj){
		CrmError crmErr = new CrmError();
		log.info("addExpense start => obj is : " + obj);
		ExpenseAdd sa = new ExpenseAdd();
		sa.setName(obj.getName());
		sa.setCrmaccount(obj.getCrmId());
		sa.setRowid(obj.getRowId());
		sa.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		sa.setType(obj.getType());
		sa.setExpensedate(obj.getExpensedate());//日期
		sa.setExpenseamount(obj.getExpenseamount());//金额
		sa.setModifydate(obj.getModifydate());//修改时间
		sa.setAssigner(obj.getCrmId());
		sa.setDesc(obj.getDesc());//描述
		sa.setExpensetype(obj.getExpensetype());//1为销售
		sa.setExpensesubtype(obj.getExpensesubtype());//类型
		sa.setParenttype(obj.getParenttype());//关联的类型
		sa.setParentid(obj.getParentid());//关联的ID
		sa.setDepartment(obj.getDepart());//费用部门
		sa.setExpUserName(obj.getExpUserName()); //费用对象
		//审批相关信息
		sa.setCommitid(obj.getCommitid());
		sa.setCommitname(obj.getCommitname());
		sa.setApprovalid(obj.getApprovalid());
		sa.setApprovalname(obj.getApprovalname());
		sa.setApprovalstatus(obj.getApprovalstatus());
		sa.setApprovaldesc(obj.getApprovaldesc());
		sa.setRecordid(obj.getRecordid());
		sa.setParentdepart(obj.getParentdepart());
		sa.setExpUserName(obj.getExpUserName());
		sa.setOrgId(obj.getOrgId());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addExpense jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addExpense rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addExpense errcode => errcode is : " + errcode);
			log.info("addExpense errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addExpense rowid => rowid is : " + rowId);
				crmErr.setRowId(rowId);
				
				try {
					//同步到缓存
					CacheExpense cache = cRMService.getDbService().getCacheExpenseService().transf(obj.getOrgId(), sa);
					cache.setRowid(rowId);
					if(StringUtils.isNotNullOrEmptyStr(obj.getApprovalstatus())){
						cache.setExpense_status(obj.getApprovalstatus());
					}else{
						cache.setExpense_status("new");
					}
					
					if ("add".equals(obj.getType()))
					{
						cRMService.getDbService().getCacheExpenseService().addObj(cache);
					}
					else
					{
						if ("cancel".equals(obj.getType()))
						{
							//如果是作废，则设置记录状态为cancel和disabled
							cache.setRowid(obj.getRowId());
							cache.setEnabled_flag("disabled");
							cache.setExpense_status("cancel");
						}
						else if ("update".equals(obj.getType()))
						{
							//如果还有下一级审批，则设置状态仍为审批中
							if(StringUtils.isNotNullOrEmptyStr(obj.getApprovalid()) && !"reject".equals(obj.getApprovalstatus()))
							{
								cache.setExpense_status("approving");
							}
						}
						
						cRMService.getDbService().getCacheExpenseService().updateObj(cache);
					}
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}
		}
		return crmErr;
	}
	
	/**
	 * 批量提交 费用信息
	 * @param obj
	 * @return
	 */
	public CrmError batchApproval(Expense obj){
		CrmError crmErr = new CrmError();
		log.info("addExpense start => obj is : " + obj);
		ExpenseAdd sa = new ExpenseAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setRowid(obj.getRowId());
		sa.setModeltype(Constants.MODEL_TYPE_EXPENSE);
		sa.setType(obj.getType());
		sa.setExpensedate(obj.getExpensedate());//日期
		sa.setExpenseamount(obj.getExpenseamount());//金额
		sa.setAssigner(obj.getCrmId());
		sa.setDesc("批量报销费用");//描述
		sa.setDesc(obj.getDesc());//描述
		sa.setExpensetype(obj.getExpensetype());//1为销售
		sa.setExpensesubtype(obj.getExpensesubtype());//类型
		sa.setParenttype(obj.getParenttype());//关联的类型
		sa.setParentid(obj.getParentid());//关联的ID
		//审批相关信息
		sa.setCommitid(obj.getCommitid());
		sa.setCommitname(obj.getCommitname());
		sa.setApprovalid(obj.getApprovalid());
		sa.setApprovalname(obj.getApprovalname());
		sa.setApprovalstatus(obj.getApprovalstatus());
		sa.setApprovaldesc(obj.getApprovaldesc());
		sa.setRecordid(obj.getRecordid());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addExpense jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addExpense rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addExpense errcode => errcode is : " + errcode);
			log.info("addExpense errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
}
