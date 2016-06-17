package com.takshine.wxcrm.service.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.beanutils.BeanUtils;
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
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TaskParent;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserFocus;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheSingleReq;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleComplete;
import com.takshine.wxcrm.message.sugar.ScheduleReq;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Schedule2SugarService;

/**
 * 日程任务   相关业务接口实现
 *
 * @author liulin
 */
@Service("schedule2SugarService")
public class Schedule2SugarServiceImpl extends BaseServiceImpl implements Schedule2SugarService{
	public static final String cachegroup = Schedule2SugarService.class.getName();
	
	public final ScheduleAdd getScheduleFromCache(String rowid) throws IllegalAccessException, InvocationTargetException, CRMException{
		
		ScheduleAdd data = (ScheduleAdd) this.cRMService.getBusinessService().getCacheService().get(cachegroup,rowid);
		if (data == null){
			data = getScheduleFromRemote(rowid);
			this.cRMService.getBusinessService().getCacheService().set(cachegroup,rowid, data);
		}
		return data;
	}
	public final void putScheduleFromCache(String rowid,ScheduleAdd data){
		this.cRMService.getBusinessService().getCacheService().set(cachegroup,rowid, data);
	}
	public final void removeScheduleFromCache(String rowid){
		this.cRMService.getBusinessService().getCacheService().remove(cachegroup,rowid);
	}
	public final void clearScheduleFromCache(){
		this.cRMService.getBusinessService().getCacheService().clear(cachegroup);
	}
	
	public final ScheduleAdd getScheduleFromRemote(String rowid) throws CRMException, IllegalAccessException, InvocationTargetException{
		CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(rowid);
		log.info("newCrmId = >" + cacheSchedule.getCrm_id());
		
		//日程请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(cacheSchedule.getCrm_id());//sugar id
		single.setOrgId(cacheSchedule.getOrg_id());
		single.setModeltype(Constants.MODEL_TYPE_TASK);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowid);
		single.setSchetype("task");
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getScheduleSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getScheduleSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		ScheduleAdd scheduleAdd2 = null;
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			if(null != jsonObject.getString("task") && !"".equals(jsonObject.getString("task"))){
				List<ScheduleAdd> list= (List<ScheduleAdd>)JSONArray.toCollection(jsonObject.getJSONArray("task"), ScheduleAdd.class);
				if(list!=null&&list.size()>0){
					for(ScheduleAdd scheduleAdd : list){
						scheduleAdd2 = new ScheduleAdd();
						BeanUtils.copyProperties(scheduleAdd2, scheduleAdd);
						scheduleAdd2.setOrgId(cacheSchedule.getOrg_id());
					}
				}
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			throw new CRMException(errcode,errmsg);
		}
		if (scheduleAdd2 == null){
			throw new CRMException(ErrCode.ERR_CODE_1001004,ErrCode.ERR_MSG_SEARCHEMPTY);
		}
		return scheduleAdd2;
	}
	
	
	private static Logger log = Logger.getLogger(Schedule2SugarServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询 日程数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public ScheduleResp getScheduleList(Schedule sche,String source)throws Exception{
		//日程响应
		ScheduleResp resp = new ScheduleResp();
		resp.setCrmaccount(sche.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_TASK);
		resp.setViewtype(sche.getViewtype());

		//日程请求
		ScheduleReq sreq = new ScheduleReq();
		sreq.setCrmaccount(sche.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_TASK);
		sreq.setViewtype(sche.getViewtype());//试图类型
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setStartdate(sche.getStartdate());
		sreq.setEnddate(sche.getEnddate());
		sreq.setAssigner(sche.getAssignerId());
		sreq.setCurrpage(sche.getCurrpage());
		sreq.setStartdate(sche.getStartdate());
		sreq.setEnddate(sche.getEnddate());
		sreq.setStatus(sche.getStatus());
		sreq.setParentId(sche.getParentId());
		sreq.setPagecount(sche.getPagecount());
		sreq.setSchetype(sche.getSchetype());
		sreq.setSubtaskid(sche.getSubtaskid());
		sreq.setName(sche.getTitle());
		//view type
		String viewtype = sreq.getViewtype();
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			
			//List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			
			List<String> rstuid = new ArrayList<String>();
			List<CacheSchedule> cachelist = new ArrayList<CacheSchedule>();
			
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i).getCrmId();
//				log.info("crmid = >" + crmid);
//				
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOpenId(sche.getOpenId());
//				uReq.setOrgUrl(crmIds.get(i).getCrmurl());
//				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
//
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
				CacheSchedule csear = new CacheSchedule();
				csear.setCrm_id_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sche.getTitle());
				csear.setAssigner_name(sche.getAssignerName());
				ArrayList<String> status_in = new ArrayList<String>();
				if(null != status_in && status_in.size() > 0){
					status_in.add(sche.getStatus());
					csear.setStatus_in(status_in);
				}
				cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setOpenId(sche.getOpenId());
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
			team.setCurrpages(Constants.ZERO);
			team.setPagecounts(Constants.ALL_PAGECOUNT);
			//team.setRelaModel("Tasks");
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheSchedule> cachelist = new ArrayList<CacheSchedule>();
			if(rstuid.size() > 0){
				CacheSchedule csear = new CacheSchedule();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sche.getTitle());
				csear.setAssigner_name(sche.getAssignerName());
				cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype) || Constants.SEARCH_VIEW_TYPE_ALLVIEW.equals(viewtype) //myallview 我的所有的 
					|| Constants.SEARCH_VIEW_TYPE_NOTICEVIEW.equals(viewtype) || Constants.SEARCH_VIEW_TYPE_CALENDAR_VIEW.equals(viewtype)){  //noteice view 循环查询后台 查询所有的数据 到前台

			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<String> jsonlist = new ArrayList<String>();
			Map<String,String> cacheOrgid = new HashMap<String,String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				sreq.setCrmaccount(crmid);
				sreq.setAssigner(crmid);
				sreq.setCurrpage("1");
				sreq.setPagecount("99999");
				sreq.setOrgUrl(crmIds.get(i).getCrmurl());
				String jsonStr = JSONObject.fromObject(sreq).toString();
				log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
				jsonlist.add(jsonStr);
				cacheOrgid.put(jsonStr, crmIds.get(i).getOrgId());
			}
			Map<String,String> retmap = cRMService.getWxService().getWxHttpConUtil().postJsonDataRetMapBodyKey(Constants.MODEL_URL_ENTRY, jsonlist, Constants.INVOKE_MULITY);
			for(String jsonStr : retmap.keySet()){
				try{
					String rst = retmap.get(jsonStr);
					log.info("getCustomerList rst => rst is : " + rst);
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					if (!jsonObject.containsKey("errcode")) {
						// 错误代码和消息
						String count = jsonObject.getString("count");
						if (!"".equals(count) && Integer.parseInt(count) > 0) {
							List<ScheduleAdd> list = (List<ScheduleAdd>) JSONArray.toCollection(jsonObject.getJSONArray("tasks"),ScheduleAdd.class);
							for(ScheduleAdd scheduleAdd : list){
								scheduleAdd.setOrgId(cacheOrgid.get(jsonStr));
								this.putScheduleFromCache(scheduleAdd.getRowid(), scheduleAdd);
								rstuid.add(scheduleAdd.getRowid());
							}
						}
					}
				}catch(Exception ec){
					
				}
			}
			
			TeamPeason team = new TeamPeason();
			team.setOpenId(sche.getOpenId());
			team.setCurrpages(Constants.ZERO);
			team.setPagecounts(Constants.ALL_PAGECOUNT);
			if(StringUtils.isNotNullOrEmptyStr(sreq.getSubtaskid())){ 
				team.setRelaId(sreq.getSubtaskid());
			}
			if(StringUtils.isNotNullOrEmptyStr(sreq.getParentId())){
				team.setRelaId(sreq.getParentId());
			}
			//team.setRelaModel("Tasks");
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				if(!rstuid.contains(rowid)){
					rstuid.add(rowid);
				}
			}
			
			List<CacheSchedule> cachelist = new ArrayList<CacheSchedule>();
			if(rstuid.size() > 0){
				CacheSchedule csear = new CacheSchedule();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				//指尖好友分享的，需要带上条件查询
				if(StringUtils.isNotNullOrEmptyStr(sche.getStatus())){
					String[] status = sche.getStatus().split(",");
					List<String> status_in = new ArrayList<String>();
					for(int i=0;i<status.length;i++){
						status_in.add(status[i]);
					}
					csear.setStatus_in(status_in);
				}
				csear.setViewtype(sche.getViewtype());
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setName(sche.getTitle());//增加按标题搜索
				csear.setAssigner_name(sche.getAssignerName());
				cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(csear);
			}
			
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				ScheduleAdd data = this.getScheduleFromCache(cacheSchedule.getRowid());
				if (sche.getStatus()!=null && sche.getStatus().indexOf(data.getStatus())>=0){
					rstlist.add(data);
				}else if (sche.getStatus() == null){
					rstlist.add(data);
				}
			}
			

			log.info("cachelist = > " + cachelist.size());
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_OPENVIEW.equals(viewtype)){
			String openId = sche.getOpenId();
			if(!StringUtils.isNotNullOrEmptyStr(openId)){	
				openId=getOpenIdByCrmId(sreq.getCrmaccount());
			}
			log.info("openId = >" + openId);
			List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i);
				
				CacheSchedule csear = new CacheSchedule();
				csear.setCrm_id(crmid);
				csear.setIspublic("1");
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setName(sche.getTitle());
				csear.setAssigner_name(sche.getAssignerName());
				List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findObjListByFilter(csear);
				log.info("cachelist = > " + cachelist.size());
				for (CacheSchedule cacheSchedule : cachelist) {
					//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
					rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
				}
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_MYVIEW.equals(viewtype)){//我的视图
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();		
			CacheSchedule csear = new CacheSchedule();
			//List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			//log.info("crmIds size = >" + crmIds.size());
			//for (int i = 0; i < crmIds.size(); i++) {
			//	String crmid = crmIds.get(i).getCrmId();
			//	csear.setCrm_id(crmid);
			    csear.setCrm_id(sreq.getCrmaccount());
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				if(StringUtils.isNotNullOrEmptyStr(sche.getStatus())){
					String[] status = sche.getStatus().split(",");
					List<String> status_in = new ArrayList<String>();
					for(int j=0;j<status.length;j++){
						status_in.add(status[j]);
					}
					csear.setStatus_in(status_in);
				}
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setName(sche.getTitle());//增加按标题搜索
				csear.setAssigner_name(sche.getAssignerName());
				List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
				log.info("cachelist = > " + cachelist.size());
				for (CacheSchedule cacheSchedule : cachelist) {
					//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
					rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
				}
			//}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}
		//
		else if("WXMenuView".equals(viewtype)){//微信菜单
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();		
			CacheSchedule csear = new CacheSchedule();
			List<Organization> crmIds = getCrmIdAndOrgIdArr(sche.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				csear.setCrm_id(crmid);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				if(StringUtils.isNotNullOrEmptyStr(sche.getStatus())){
					String[] status = sche.getStatus().split(",");
					List<String> status_in = new ArrayList<String>();
					for(int j=0;j<status.length;j++){
						status_in.add(status[j]);
					}
					csear.setStatus_in(status_in);
				}
				csear.setStart_date(sche.getStartdate());
				csear.setEnd_date(sche.getEnddate());
				csear.setName(sche.getTitle());
				csear.setAssigner_name(sche.getAssignerName());
				List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByOpenId(csear);
				log.info("cachelist = > " + cachelist.size());
				for (CacheSchedule cacheSchedule : cachelist) {
					//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
					rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
				}
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_TODAYVIEW.equals(viewtype)//今天 查询开始时间等于今天的
				     || Constants.SEARCH_VIEW_TYPE_HISTORYVIEW.equals(viewtype)){//历史  查询开始时间小于今天的
			
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			//查询缓存表
			CacheSchedule csear = new CacheSchedule();
			csear.setCrm_id(sreq.getCrmaccount());
			csear.setViewtype(viewtype);
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			csear.setName(sche.getTitle());
			csear.setAssigner_name(sche.getAssignerName());
			List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_HOMEVIEW.equals(viewtype)){//7天 30天 7天：开始时间未来七天 并且  结束时间 小于今天并且状态不为完成 不为取消
			//查询缓存表
			CacheSchedule csear = new CacheSchedule();
			csear.setCrm_id(sreq.getCrmaccount());
			csear.setStart_date(sreq.getStartdate());
			csear.setEnd_date(sreq.getEnddate());
			csear.setStatus(sreq.getStatus());
			csear.setViewtype(viewtype);
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			csear.setName(sche.getTitle());
			csear.setAssigner_name(sche.getAssignerName());
			List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
		}else if(Constants.SEARCH_VIEW_TYPE_FOCUSVIEW.equals(viewtype)){//关注视图 查询所有的人之后 查询前台
			String openId = getOpenIdByCrmId(sreq.getCrmaccount());
			log.info("openId = >" + openId);
			List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i);
				log.info("crmid = >" + crmid);
				//focus
				UserFocus sc = new UserFocus();
				sc.setCrmId(crmid);
				List<UserFocus> ulist = (List<UserFocus>)cRMService.getDbService().getUserFocusService().findObjListByFilter(sc);
				for (int j = 0; j < ulist.size(); j++) {
					UserFocus uf = ulist.get(j);
					String focusCrmId = uf.getFocusCrmId();
					log.info(" focusCrmId = >" + focusCrmId);
					rstuid.add(focusCrmId);
				}
			}
			List<CacheSchedule> cachelist = new ArrayList<CacheSchedule>();
			if(rstuid.size() > 0){
				CacheSchedule csear = new CacheSchedule();
				csear.setCrm_id_in(rstuid);
				csear.setViewtype(viewtype);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setAssigner_name(sche.getAssignerName());
				csear.setName(sche.getTitle());
			    cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_PLANVIEW.equals(viewtype)){//计划任务 查询开始时间大于今天的任务
			//查询缓存表
			CacheSchedule csear = new CacheSchedule();
			csear.setCrm_id(sreq.getCrmaccount());
			csear.setStart_date(sreq.getStartdate());
			csear.setViewtype(viewtype);
			csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
			csear.setPagecount(new Integer(sche.getPagecount()));
			csear.setName(sche.getTitle());
			csear.setAssigner_name(sche.getAssignerName());
			List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
			for (CacheSchedule cacheSchedule : cachelist) {
				//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
				rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
		}else if(Constants.SEARCH_VIEW_TYPE_CALENDAR_VIEW.equals(viewtype)){//计划任务 查询一段时间内的任务
			//计划任务 查询一段时间内的任务
			List<ScheduleAdd> rstlist = new ArrayList<ScheduleAdd>();
				String crmid = sreq.getCrmaccount();
				//查询缓存表
				CacheSchedule csear = new CacheSchedule();
				csear.setCrm_id(crmid);
				csear.setStart_date(sreq.getStartdate());
				csear.setEnd_date(sreq.getEnddate());
				csear.setViewtype(viewtype);
				csear.setCurrpage(( new Integer(sche.getCurrpage()) - 1 ) * new Integer(sche.getPagecount()) );
				csear.setPagecount(new Integer(sche.getPagecount()));
				csear.setName(sreq.getName());
				csear.setAssigner_name(sche.getAssignerName());
				if(StringUtils.isNotNullOrEmptyStr(sche.getStatus())){
					String[] status = sche.getStatus().split(",");
					List<String> status_in = new ArrayList<String>();
					for(int j=0;j<status.length;j++){
						status_in.add(status[j]);
					}
					csear.setStatus_in(status_in);
				}
				List<CacheSchedule> cachelist = (List<CacheSchedule>)cRMService.getDbService().getCacheScheduleService().findCacheScheduleListByCrmId(csear);
				log.info("cachelist = > " + cachelist.size());
				for (CacheSchedule cacheSchedule : cachelist)
				{
					//rstlist.add(cRMService.getDbService().getCacheScheduleService().invstransf(cacheSchedule));
					rstlist.add(this.getScheduleFromCache(cacheSchedule.getRowid()));
				}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setTasks(rstlist);
			return resp;
		}else if("workplanviewtype".equals(viewtype)){//2015-03-11修改，查询工作计划下关联的任务列表
			sreq.setCrmaccount(sche.getCrmId());
			sreq.setType(Constants.ACTION_SEARCHPID);
			String jsonStr = JSONObject.fromObject(sreq).toString();
			log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
			log.info("getCustomerList rst => rst is : " + rst);
			try
			{
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<ScheduleAdd> list = (List<ScheduleAdd>) JSONArray.toCollection(jsonObject.getJSONArray("tasks"),ScheduleAdd.class);
						for(ScheduleAdd data : list){
							this.putScheduleFromCache(data.getRowid(), data);
						}
						resp.setTasks(list);
					}
				}
			}
			catch(Exception ex)
			{
				resp.setCount("0");// 数字
				resp.setTasks(new ArrayList<ScheduleAdd>());
			}
			return resp;
		}else{
			resp.setCount("0");// 数字
			resp.setTasks(new ArrayList<ScheduleAdd>());
			return resp;
		}
		
/*		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getScheduleList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getScheduleList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<ScheduleAdd> slist = (List<ScheduleAdd>)JSONArray.toCollection(jsonObject.getJSONArray("tasks"), ScheduleAdd.class);
				resp.setTasks(slist);//任务列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getScheduleList errcode => errcode is : " + errcode);
			log.info("getScheduleList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;*/
	}
	
	/**
	 * 查询单个日程数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public ScheduleResp getScheduleSingle(String rowId, String crmId,String schetype)throws Exception{
		CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cacheSchedule.getCrm_id());
		
		//日程响应
		ScheduleResp resp = new ScheduleResp();
		resp.setCrmaccount(crmId);//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_TASK);
		//日程请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(crmId);//sugar id
		single.setOrgId(cacheSchedule.getOrg_id());
		single.setModeltype(Constants.MODEL_TYPE_TASK);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowId);
		single.setSchetype(schetype);
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getScheduleSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getScheduleSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			if(null != jsonObject.getString("task") && !"".equals(jsonObject.getString("task"))){
				List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>();
				List<ScheduleAdd> list= (List<ScheduleAdd>)JSONArray.toCollection(jsonObject.getJSONArray("task"), ScheduleAdd.class);
				if(list!=null&&list.size()>0){
					for(ScheduleAdd scheduleAdd : list){
						ScheduleAdd scheduleAdd2 = new ScheduleAdd();
						BeanUtils.copyProperties(scheduleAdd2, scheduleAdd);
						scheduleAdd2.setOrgId(cacheSchedule.getOrg_id());
						this.putScheduleFromCache(scheduleAdd2.getRowid(), scheduleAdd2);
						slist.add(scheduleAdd2);
					}
				}
				resp.setTasks(slist);//任务列表
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getScheduleSingle errcode => errcode is : " + errcode);
			log.info("getScheduleSingle errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	

	/**
	 * 保存日程信息
	 * @param obj
	 * @return
	 */
	public CrmError addSchedule(Schedule obj){
		CrmError crmErr = new CrmError();
		log.info("addSchedule start => obj is : " + obj);
		ScheduleAdd sa = new ScheduleAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_TASK);
		sa.setType(Constants.ACTION_ADD);
		sa.setTitle(obj.getTitle());//标题
		sa.setStartdate(obj.getStartdate());//开始日期
		sa.setEnddate(obj.getEnddate());//结束日期
		sa.setStatus(obj.getStatus());//状态
		sa.setDesc(obj.getDesc());//描述
		sa.setDriority(obj.getDriority());//优先级 
		sa.setAssigner(obj.getAssignerId());//责任人 -> 
		sa.setParentId(obj.getParentId());//关联ID
		sa.setParentType(obj.getParentType());//关联类型
		sa.setContact(obj.getContact());  //联系人
		sa.setParticipant(obj.getParticipant());//参与人
		sa.setCyclikey(obj.getCycliKey());//周期key  
		sa.setCyclivalue(obj.getCycliValue());//周期value
		sa.setSchetype(obj.getSchetype());
		sa.setAddr(obj.getAddr());
		sa.setIspublic(obj.getIspublic());
		sa.setOrgId(obj.getOrgId());
		sa.setSubtaskid(obj.getSubtaskid());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addSchedule jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addSchedule rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			try{
				ScheduleResp sResp = this.getScheduleSingle(obj.getSubtaskid(), obj.getCrmId(), "task");
				String errorCode = sResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					List<ScheduleAdd> list = sResp.getTasks();
					for(ScheduleAdd lsa : list){
						TeamPeason search = new TeamPeason();
						search.setRelaId(obj.getSubtaskid());
						//查询列表是否存在
						List<TeamPeason> tplist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
						for(TeamPeason tp : tplist){
							//插入新的数据
							try {
								tp.setId(null);
								ScheduleAdd sd=this.getScheduleFromCache(jsonObject.getString("rowid"));
								tp.setRelaId(jsonObject.getString("rowid"));
								cRMService.getDbService().getTeamPeasonService().addObj(tp);
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						break;
					}
				}
				
			}catch(Exception ec){
				
			}
			
			
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addSchedule errcode => errcode is : " + errcode);
			log.info("addSchedule errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addSchedule rowid => rowId is : " + rowId);
				crmErr.setRowId(rowId);
				try {
					//同步到缓存
					CacheSchedule cache = cRMService.getDbService().getCacheScheduleService().transf(obj.getOrgId(), sa);
					cache.setRowid(rowId);
					cRMService.getDbService().getCacheScheduleService().addObj(cache);
					this.removeScheduleFromCache(rowId);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}
		}
		return crmErr;
	}
	
	enum ScheduleChangeType{
		Status,
		TeamPersonAdd,
		TeamPersonRemove,
		AssignerChange
	}
	
	private List<ScheduleChangeType> getScheduleChangeType(ScheduleAdd sche1,ScheduleAdd sche2){
		List<ScheduleChangeType> retlist = new LinkedList<ScheduleChangeType>();
		if (sche1.getStatus()!=sche2.getStatus()){
			retlist.add(ScheduleChangeType.Status);
		}
		if (sche1.getStatus()!=sche2.getStatus()){
			
		}
		return retlist;
	}
	
	private void SendWXMessage(ScheduleAdd sche1,ScheduleAdd sche2){
		try{
			String openId = "";
			String content = "";
			String activityUrl = "";
			
			
			for(ScheduleChangeType type : getScheduleChangeType(sche1,sche2)){
				try{
					
				}catch(Exception ec){
					switch(type){
						case Status:
							break;
						case TeamPersonAdd:
							break;
						case TeamPersonRemove:
							break;
						case AssignerChange:
							break;
					}
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(openId,null,null,content,activityUrl);
				}
			}
		}catch(Exception e){
			
		}

	}
	
	private ScheduleAdd getScheduleAdd(String rowid,String crmid){
		try {
			return this.getScheduleFromCache(rowid);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 日程的完成操作
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public CrmError updateScheduleComplete(Schedule sche, String crmId){
		CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(sche.getRowid());
		log.info("newCrmId = >" + cacheSchedule.getCrm_id());
		
		ScheduleAdd data1 = getScheduleAdd(sche.getRowid(), cacheSchedule.getCrm_id());
		
		CrmError crmErr = new CrmError();
		//日程完成请求
		ScheduleComplete sComp = new ScheduleComplete();
		sComp.setCrmaccount(crmId);//sugar id
		sComp.setOrgId(cacheSchedule.getOrg_id());
		sComp.setModeltype(Constants.MODEL_TYPE_TASK);
		sComp.setType(Constants.ACTION_UPDATE);
		sComp.setRowid(sche.getRowid());//记录ID
		sComp.setStartdate(sche.getStartdate());
		sComp.setEnddate(sche.getEnddate());
		sComp.setContact(sche.getContact());
		sComp.setDesc(sche.getDesc());
		sComp.setDriority(sche.getDriority());
		
		
		sComp.setParentId(sche.getParentId());
		sComp.setParentType(sche.getParentType());
		
		if (sche.getParent()!=null){
			List<com.takshine.wxcrm.message.sugar.TaskParent> parents = new LinkedList<com.takshine.wxcrm.message.sugar.TaskParent>();
			for(TaskParent item : sche.getParent()){
				com.takshine.wxcrm.message.sugar.TaskParent p = new com.takshine.wxcrm.message.sugar.TaskParent();
				p.setParentid(item.getParentid());
				p.setParenttype(item.getParenttype());
				p.setTaskid(sche.getRowid());
				parents.add(p);
			}
			sComp.setParent(parents);
		}
		
		sComp.setStatus(sche.getStatus());
		sComp.setParticipant(sche.getParticipant());
		sComp.setCyclikey(sche.getCycliKey());
		sComp.setCyclivalue(sche.getCycliValue());
		sComp.setSchetype(sche.getSchetype());
		sComp.setAddr(sche.getAddr());
		sComp.setIspublic(sche.getIspublic());
		sComp.setDeleted(sche.getDeleted());
		//转换为json
		String jsonStr = JSONObject.fromObject(sComp).toString();
		log.info("updateScheduleComplete jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("updateScheduleComplete rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//errormsg
		String errcode = jsonObject.getString("errcode");
		String errmsg = jsonObject.getString("errmsg");
		log.info("updateScheduleComplete errcode => errcode is : " + errcode);
		log.info("updateScheduleComplete errmsg => errmsg is : " + errmsg);
		crmErr.setErrorCode(errcode);
		crmErr.setErrorMsg(errmsg);
		
		try {
			//同步到缓存
			CacheSchedule cache = cRMService.getDbService().getCacheScheduleService().transf(null, sComp);
			cRMService.getDbService().getCacheScheduleService().updateObj(cache);
			this.removeScheduleFromCache(cache.getRowid());
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		ScheduleAdd data2 = getScheduleAdd(sche.getRowid(), cacheSchedule.getCrm_id());
		
		SendWXMessage(data1,data2);
		
		return crmErr;
	}
	

	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */

	public CrmError deleteSchedule(String rowid) {
		CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(rowid);
		log.info("newCrmId = >" + cacheSchedule.getCrm_id());
		
		CrmError crmErr = new CrmError();
		try {
			ScheduleResp sResp = this.getScheduleSingle(rowid, cacheSchedule.getCrm_id(), "task");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<ScheduleAdd> list = sResp.getTasks();
				for(ScheduleAdd sa : list){
					log.info("deleteSchedule start => obj is : " + rowid);
					ScheduleComplete sComp = new ScheduleComplete();
					sComp.setCrmaccount(cacheSchedule.getCrm_id());//sugar id
					sComp.setModeltype(Constants.MODEL_TYPE_TASK);
					sComp.setType(Constants.ACTION_DELETE);
					sComp.setRowid(sa.getRowid());//记录ID
					sComp.setSchetype("task");
					//配置 排除掉某些属性不进行序列化
					JsonConfig jsonConfig = new JsonConfig();
					jsonConfig.setExcludes(new String []{"",""});
							
					String jsonStr = JSONObject.fromObject(sComp, jsonConfig).toString();
					log.info("delCustomer jsonStr => jsonStr is : " + jsonStr);
					//单次调用sugar接口
					String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
					//结果为空则提示错误信息
					if(!StringUtils.isNotNullOrEmptyStr(rst)){
						crmErr.setErrorCode(ErrCode.ERR_CODE__1);
						crmErr.setErrorMsg(ErrCode.ERR_MSG_FAIL);
						return crmErr;
					}
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
						CacheSchedule cache = new CacheSchedule();
						cache.setRowid(rowid);
						cache.setEnabled_flag("disabled");
						cRMService.getDbService().getCacheScheduleService().updateEnabledFlag(cache);
						this.removeScheduleFromCache(rowid);
					} catch (Exception e) {
						log.info("cache error = >" + e.getMessage());
					}
					break;
				}
			}else{
				crmErr.setErrorCode(sResp.getErrcode());
				crmErr.setErrorMsg(sResp.getErrmsg());
			}
			
		} catch (Exception e1) {
			throw new RuntimeException(e1.getMessage());
		}
		return crmErr;
	}
	
	/**
	 * 根据crmId 查询缓存客户列表
	 * @param crmId
	 * @return
	 */
	public List<CacheSchedule> findCacheScheduleListByCrmId(CacheSchedule cache) {
		return getSqlSession().selectList("cacheScheduleSql.findCacheScheduleListByCrmId", cache);
	}

	/**
	 * 更新任务的相关值
	 */
	public CrmError updateScheduleParent(Schedule sche) {
		CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(sche.getRowid());
		log.info("newCrmId = >" + cacheSchedule.getCrm_id());
		
		CrmError crmErr = new CrmError();
		//日程完成请求
		ScheduleComplete sComp = new ScheduleComplete();
		sComp.setCrmaccount(sche.getCrmId());//sugar id
		sComp.setOrgId(cacheSchedule.getOrg_id());
		sComp.setModeltype(Constants.MODEL_TYPE_TASK);
		sComp.setType(Constants.ACTION_UPDATE_PARENT);
		sComp.setRowid(sche.getRowid());//原相关ID（未扩展字段，用rowid字段传值）
		sComp.setParentId(sche.getParentId());
		sComp.setParentType(sche.getParentType());
		sComp.setOrgId(sche.getOrgId());
		
		//转换为json
		String jsonStr = JSONObject.fromObject(sComp).toString();
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//errormsg
		String errcode = jsonObject.getString("errcode");
		String errmsg = jsonObject.getString("errmsg");
		crmErr.setErrorCode(errcode);
		crmErr.setErrorMsg(errmsg);
		try {
			//同步到缓存
			CacheSchedule cache = new CacheSchedule();
			cache.setRela_id(sche.getParentId());
			cache.setRowid(sche.getRowid());
			cache.setRela_type(sche.getParentType());
			cRMService.getDbService().getCacheScheduleService().updateScheduleParent(cache);
			clearScheduleFromCache();
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		
		return crmErr;
	}

}
