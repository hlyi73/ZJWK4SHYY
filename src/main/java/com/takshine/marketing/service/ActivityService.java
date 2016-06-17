package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityItem;
import com.takshine.marketing.domain.ActivityParticipant;

/**
 * 活动处理接口
 * @author dengbo
 *
 */
public interface ActivityService extends EntityService{
	
	/**
	 * 查询 活动数据列表
	 * @return
	 */
	public List<Activity> getActivityList(Activity act)throws Exception;
	
	/**
	 * 查询 参与活动数据列表
	 * @return
	 */
	public List<Activity> getJoinActivityList(ActivityParticipant act)throws Exception;
	
	
	/**
	 * 查询单个活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public Activity getActivitySingle(String rowid)throws Exception;
	/**
	 * 新建活动
	 * @param pro
	 * @return
	 * @throws Exception
	 */
	public String addActivity(Activity act)throws Exception;
	/**
	 * 更新活动
	 * @return
	 * @throws Exception
	 */
	public boolean updateActivity(Activity act)throws Exception;
	
	/**
	 * 根据参数 修改活动
	 */
	public void updateActivityByParams(Activity act) throws Exception ;
	
	/**
	 * 修改活动
	 */
	public boolean updateActivityCrmIdAndOrgId(Activity act) throws Exception ;
	
	/**
	 * 更新活动标志
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public Activity updActFlag(String id)throws Exception;
	
	/**
	 * 查询 活动项列表
	 * @return
	 */
	public List<ActivityItem> getActivityItemList(ActivityItem item)throws Exception;
	
	

	/**
	 * 查询 活动首字母
	 * @return
	 */
	public List<String> getFirstList(Activity act)throws Exception;
	
	/**
	 * 新建活动项
	 * @param pro
	 * @return
	 * @throws Exception
	 */
	public boolean addActivityItem(ActivityItem item)throws Exception;
	
	/**
	 * 删除活动
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public String delActivity(String id)throws Exception;
	
	/**
	 * 判断是否是团队成员
	 * @param id
	 * @param sourceid
	 * @param createBy
	 * @return
	 * @throws Exception
	 */
	public String isTeamMembers(String id,String sourceid,String createBy)throws Exception;
	
	/**
	 * 查询推荐的活动
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchGroomActivity(Activity act)throws Exception;
	
	/**
	 * 查询我下属的活动
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchBranchActivity(Activity act)throws Exception;
	
	/**
	 * 查询所有的活动（需要报名且是第二天发生的）
	 * @param act
	 * @return
	 * @throws Exception
	 */
	public List<Activity> searchAllActivity(Activity act)throws Exception;
	
	/**
	 * 查询关注的活动
	 * @param openId
	 * @return
	 * @throws Exception
	 */
	public List<Activity> findAttenAct(Activity act)throws Exception;
	
}
