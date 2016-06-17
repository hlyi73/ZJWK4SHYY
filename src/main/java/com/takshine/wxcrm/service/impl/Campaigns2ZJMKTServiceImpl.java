package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.service.ActivityParticipantService;
import com.takshine.marketing.service.ActivityService;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsReq;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Campaigns2ZJMKTService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;

/**
 * 市场活动  相关业务接口实现
 * @author dengbo
 *
 */
@Service("campaigns2ZJmktService")
public class Campaigns2ZJMKTServiceImpl extends BaseServiceImpl implements Campaigns2ZJMKTService{

	private static Logger log = Logger.getLogger(Campaigns2ZJMKTServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询市场活动数据列表
	 * @throws Exception 
	 */
	public List<Activity> getCampaignsList(Campaigns camp, String source) throws Exception {
		String currpage =camp.getCurrpage();
		String pagecount =camp.getPagecount();
		String startdate = camp.getStartdate();
		String enddate = camp.getEnddate();
		String orgId = camp.getOrgId();
		List<Activity> list = new ArrayList<Activity>();
		if(currpage==null||"".equals(currpage.trim())){
			currpage="0";
		}
		if(pagecount==null||"".equals(pagecount.trim())){
			pagecount="99999";
		}
		Activity act = new Activity();
		act.setOrgId(orgId);
		if("join".equals(camp.getType())){
			ActivityParticipant ap = new ActivityParticipant();
			ap.setSource(source);
			ap.setSourceid(camp.getOpenId());
			ap.setPagecounts(Integer.parseInt(pagecount));
			ap.setCurrpages(Integer.parseInt(currpage));
			if(StringUtils.isNotNullOrEmptyStr(startdate)){
				ap.setStartdate(startdate);
			}
			if(StringUtils.isNotNullOrEmptyStr(enddate)){
			ap.setEnddate(enddate);
			}
			list = cRMService.getDbService().getActivityService().getJoinActivityList(ap);
		}else if("owner".equals(camp.getType())){
			act.setCreateBy(camp.getOpenId());
			act.setSource(source);
			act.setPagecounts(Integer.parseInt(pagecount));
			act.setCurrpages(Integer.parseInt(currpage));
			if(StringUtils.isNotNullOrEmptyStr(startdate)){
				act.setStart_date(startdate);
			}
			if(StringUtils.isNotNullOrEmptyStr(enddate)){
				act.setEnd_date(enddate);
			}
			list = cRMService.getDbService().getActivityService().getActivityList(act);
		}else{
			if(StringUtils.isNotNullOrEmptyStr(startdate)){
				act.setStart_date(startdate);
			}
			if(StringUtils.isNotNullOrEmptyStr(enddate)){
				act.setEnd_date(enddate);
			}
			act.setPagecounts(Integer.parseInt(pagecount));
			act.setCurrpages(Integer.parseInt(currpage));
			list = cRMService.getDbService().getActivityService().getActivityList(act);
		}
		return list;
 	}

	/**
	 * 通过不同的viewtype查询活动列表的ID
	 * @param camp
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getCampaigns(Campaigns camp)throws Exception{
		List<Activity> activities = new ArrayList<Activity>();
		//请求
		CampaignsReq req = new CampaignsReq();
		req.setModeltype(Constants.MODEL_TYPE_CAMP);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(camp.getPagecount());
		req.setCurrpage(camp.getCurrpage());
		req.setViewtype(camp.getViewtype());
		req.setCrmaccount(camp.getCrmId());
		String viewtype = camp.getViewtype();
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			//open ID
			String openId = getOpenIdByCrmId(camp.getCrmId());
			log.info("openId = >" + openId);
			List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i);
				log.info("crmid = >" + crmid);
				//查询接口 获取人的数据列表
				UserReq uReq  = new UserReq();
				uReq.setCrmaccount(crmid);
				uReq.setCurrpage("1");
				uReq.setPagecount("9999");
				uReq.setFlag("");
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				String errorCode = uResp.getErrcode();
				if(ErrCode.ERR_CODE_0.equals(errorCode)){
					String count = uResp.getCount();
					List<UserAdd> ulist = uResp.getUsers();
					if(Integer.parseInt(count) > 0){
						for (int j = 0; j < ulist.size(); j++) {
							UserAdd ua = ulist.get(j);
							String uid = ua.getUserid();
							log.info("uid = >" + uid);
							rstuid.add(uid);
						}
					}
				}
			}
			List<CampaignsAdd> list = new ArrayList<CampaignsAdd>();
			List<String> jsonStrArray = new ArrayList<String>();
			for(int j=0;j<rstuid.size();j++){
				req.setCrmaccount(rstuid.get(j));
				//转换为json
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getCampaigns jsonStr => is : "+jsonStr);
				jsonStrArray.add(jsonStr);
			}
			//多次调用sugar接口
			List<String> rstArray = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArray, Constants.INVOKE_MULITY);
			for(String rst : rstArray){
				try{
					log.info("getCampaigns rst => is : "+rst);
					//做空判断
					if(null == rst || "".equals(rst)) return null;
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();
					if(!jsonObject.containsKey("errcode")){
						String count = jsonObject.getString("count");
						if(!"".equals(count)&&Integer.parseInt(count)>0){
							JSONArray jsonArray = jsonObject.getJSONArray("campaigns");
							for(int i=0;i<jsonArray.size();i++){
								JSONObject jsonObject1 = jsonArray.getJSONObject(i);
								String rowid = jsonObject1.getString("rowid");
								Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(rowid);
								if(null!=activity){
									activities.add(activity);
								}
							}
						}
					}
				}catch(Exception ec){
					
				}
			}
			return activities;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			//open ID
			String openId = getOpenIdByCrmId(req.getCrmaccount());
			log.info("openId = >" + openId);
			List<String> crmIds = getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i);
				log.info("crmid = >" + crmid);
				//查询列表
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("Activity");
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
			team.setOpenId(openId);
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();
			for(String id : rstuid){
				Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(id);
				if(null!=activity){
					activities.add(activity);
				}
			}
			return activities;
		}
		return new ArrayList<Activity>();
	}
	
	/**
	 * 查询单个市场活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public CampaignsResp getCampaignsSingle(String rowid, String crmid)
			throws Exception {
		CampaignsResp resp = new CampaignsResp();
		String url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/syncdetail?id="+rowid;
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		log.info("getCampaignsSingle rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();
			CampaignsAdd campaignsAdd = new CampaignsAdd();
			campaignsAdd.setRowid(jsonObject.getString("id"));
			campaignsAdd.setName(jsonObject.getString("title"));
			campaignsAdd.setStartdate(jsonObject.getString("start_date"));
			campaignsAdd.setEnddate(jsonObject.getString("end_date"));
			cams.add(campaignsAdd);
			resp.setCams(cams);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCampaignsSingle errcode => errcode is : " + errcode);
			log.info("getCampaignsSingle errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}

	/**
	 * 查询我报名的活动
	 * @throws Exception 
	 */
	public List<Activity> getJoinCampaignsList(Campaigns camp, String source) throws Exception{
		List<Activity> actList=new ArrayList<Activity>();
		ActivityParticipant participant = new ActivityParticipant();
		participant.setSourceid(camp.getOpenId());
		participant.setPagecounts(99999);
		participant.setCurrpages(Integer.parseInt(camp.getCurrpage()));
		actList = cRMService.getDbService().getActivityParticipantService().getActivityListById(participant);
		return actList;
	}

	/**
	 * 得到推荐的活动
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getRecommendCampaignsList()throws Exception{
		CampaignsResp resp = new CampaignsResp();
		List<Activity> actList=new ArrayList<Activity>();
		actList = cRMService.getDbService().getActivityService().searchGroomActivity(new Activity());
		return actList;
	}
	
}
