package com.takshine.marketing.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityItem;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.service.ActivityService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;

/**
 * 
 * @author dengbo
 *
 */
@Service("activityService")
public class ActivityServiceImpl extends BaseServiceImpl implements ActivityService {
	private static Logger logger = Logger.getLogger(ActivityServiceImpl.class.getName());


	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "Activity";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "activitySql.";
	}
	
	public BaseModel initObj() {
		return new Activity();
	}
	
	/**
	 * 获取活动列表
	 */
	public List<Activity> getActivityList(Activity act)
			throws Exception {
		
		List<Activity> actList = getSqlSession().selectList("activitySql.findActivityList", act);
		return actList;
	}

	/**
	 * 查询单个活动
	 */
	public Activity getActivitySingle(String id)
			throws Exception {
		Activity act = getSqlSession().selectOne("activitySql.findActivityById", id);
		return act;
	}
	
	/**
	 * 添加活动
	 */
	public String addActivity(Activity act) throws Exception {
		logger.info("ActivityServiceImpl -- addActivity --> 添加活动开始");
		String id = Get32Primarykey.getRandom32PK();
		act.setId(id);
		int result = getSqlSession().insert("activitySql.saveActivity", act);
		if(result != -1){
			return id;
		}
		Print print= new Print();
		print.setObjectid(id);
		print.setOwnid(act.getCreate_by());
		print.setOperativeid(act.getCreate_by());
		print.setObjectname(act.getTitle());
		print.setObjecttype("ACTIVITY");
		print.setOperativetype("CREATE");
		cRMService.getDbService().getPrintService().insert(print);//添加印记
		logger.info("ActivityServiceImpl -- addActivity --> 添加活动结束");
		return "";
	}
	
	/**
	 * 修改活动
	 */
	public boolean updateActivity(Activity act) throws Exception {
		// TODO Auto-generated method stubupdateActivityById
		logger.info("ActivityServiceImpl -- updateActivity --修改活动开始");
		int result =getSqlSession().update("activitySql.updateActivityById", act);
		if(result != -1){
			return true;
		}
		logger.info("ActivityServiceImpl -- updateActivity --修改活动结束");
		return false;
	}
	
	/**
	 * 根据参数 修改活动
	 */
	public void updateActivityByParams(Activity act) throws Exception {
		getSqlSession().update("activitySql.updateActivityByParams", act);
	}
	
	/**
	 * 修改活动
	 */
	public boolean updateActivityCrmIdAndOrgId(Activity act) throws Exception {
		// TODO Auto-generated method stubupdateActivityById
		logger.info("ActivityServiceImpl -- updateActivityCrmIdAndOrgId --修改活动开始");
		int result =getSqlSession().update("activitySql.updateActivityCrmIdAndOrgId", act);
		if(result != -1){
			return true;
		}
		logger.info("ActivityServiceImpl -- updateActivityCrmIdAndOrgId --修改活动结束");
		return false;
	}

	
	/**
	 * 获取活动项列表
	 */
	public List<ActivityItem> getActivityItemList(ActivityItem item) throws Exception {
		List<ActivityItem> actItemList = getSqlSession().selectList("activityItemSql.findActivityItemList", item);
		return actItemList;
	}

	/**
	 * 添加活动项
	 */
	public boolean addActivityItem(ActivityItem item) throws Exception {
		logger.info("ActivityServiceImpl -- addActivityItem --> 添加活动项开始");
		boolean flag = false;
		item.setId(Get32Primarykey.getRandom32PK());
		int result = getSqlSession().insert("activityItemSql.saveActivityItem", item);
		if(result != -1){
			flag = true;
		}
		logger.info("ActivityServiceImpl -- addActivityItem --> 添加活动项结束");
		return flag;
	}

	public List<Activity> getJoinActivityList(ActivityParticipant act)
			throws Exception {
		List<Activity> actList = getSqlSession().selectList("activitySql.findJoinActivityList", act);
		return actList;
	}

	public List<String> getFirstList(Activity act) throws Exception {
		List<String> actList = getSqlSession().selectList("activitySql.findFirstList", act);
		return actList;
	}
	
	/**
	 * 更新活动标志
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public Activity updActFlag(String id)throws Exception{
		Activity act = new Activity();
		logger.info("ActivityServiceImpl -- updActFlag --修改活动开始");
		int result =getSqlSession().update("activitySql.updateActivityFlag", id);
		if(result != -1){
			act.setEnabled_flag("disabled");
		}
		logger.info("ActivityServiceImpl -- updActFlag --修改活动结束");
		return act;
	}
	
	/**
	 * 删除活动
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public String delActivity(String id)throws Exception{
		logger.info("ActivityServiceImpl -- delActivity --删除活动开始");
		int flag = getSqlSession().delete("activitySql.deleteActivityById", id);
		if(flag>0){
			return "success";
		}else{
			return "error";
		}
	}

	
	/**
	 * 判断是否是团队成员
	 * @param id
	 * @param openId
	 * @param createBy
	 * @return
	 * @throws Exception
	 */
	public String isTeamMembers(String id,String openId,String createBy)throws Exception{
		WxuserInfo wxuserInfo = new WxuserInfo();
		String ownerOpenId = "";
		wxuserInfo.setParty_row_id(createBy);
		Object obj = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuserInfo);
		if(null!=obj){
			wxuserInfo = (WxuserInfo)obj;
			ownerOpenId = wxuserInfo.getOpenId();
		}
		String orgId = (String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+id);
		String crmId = getCrmIdByOrgId(ownerOpenId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		String crmId1 = getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		Share share = new Share();
		share.setParentid(id);
		share.setParenttype("Activity");
		share.setCrmId(crmId);
		ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
		List<ShareAdd> sharelist = sresp.getShares();
		CrmError crmError = new CrmError();
		boolean flag = false;
		for(ShareAdd shareObj:sharelist){
			String userid = shareObj.getShareuserid();
			if(StringUtils.isNotNullOrEmptyStr(userid)&&userid.equals(crmId1)){
				crmError.setErrorCode("0");
				crmError.setErrorMsg("success");
				flag = true;
			}
		}
		TeamPeason teamPeason = new TeamPeason();
		teamPeason.setRelaId(id);
		teamPeason.setCurrpages(new Integer(0));
		teamPeason.setPagecounts(new Integer(9999));
		String errorcode = "";
		Object obj1 = cRMService.getDbService().getTeamPeasonService().findObjListByFilter(teamPeason);
		if(null!=obj1){
			List<TeamPeason> teamList = (List<TeamPeason>)obj1;
			for(TeamPeason teamPeason2:teamList){
				String userid = teamPeason2.getOpenId();
				if(userid.equals(openId)){
					errorcode = "0";
					flag = true;
				}
			}
		}
		if(!flag){
			errorcode = "999999999";
		}
		return errorcode;
	}
	
	/**
	 * 查询推荐的活动
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchGroomActivity(Activity act)throws Exception{
		logger.info("ActivityServiceImpl -- searchGroomActivity --查询感兴趣的活动开始");
		List<Activity> actList = getSqlSession().selectList("activitySql.findRecommendActivityList", act);
		logger.info("ActivityServiceImpl -- searchGroomActivity --查询感兴趣的活动结束");
		return actList;
	}
	
	/**
	 * 查询我下属的活动
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchBranchActivity(Activity act)throws Exception{
		logger.info("ActivityServiceImpl -- searchBranchActivity --查询我下属的活动开始");
		List<Activity> actList = getSqlSession().selectList("activitySql.findBranchActivityList", act);
		logger.info("ActivityServiceImpl -- searchBranchActivity --查询我下属的活动结束");
		return actList;
	}
	
	/**
	 * 查询所有的活动（需要报名且是第二天发生的）
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchAllActivity(Activity act)throws Exception{
		logger.info("ActivityServiceImpl -- searchAllActivity --查询所有的活动");
		List<Activity> actList = getSqlSession().selectList("activitySql.findAllActivityList", act);
		logger.info("ActivityServiceImpl -- searchAllActivity --查询所有的活动");
		return actList;
	}
	
	/**
	 * 查询关注的活动
	 * @param openId
	 * @return
	 * @throws Exception
	 */
	public List<Activity> findAttenAct(Activity act)throws Exception{
		logger.info("ActivityServiceImpl -- findAttenAct --查询关注的活动");
		List<Activity> actList = getSqlSession().selectList("activitySql.findAllAttenActivityList", act);
		logger.info("ActivityServiceImpl -- findAttenAct --查询关注的活动");
		return actList;
	}
	
}
