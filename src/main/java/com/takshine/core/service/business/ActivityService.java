package com.takshine.core.service.business;

import java.util.List;

import com.takshine.core.service.exception.CRMException;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.Activity_Rela;


/**
 * 活动服务
 * @author dengbo
 *
 */
public interface ActivityService{
	/**
	 * 关注活动
	 * @param openid
	 * @param activityid
	 * @throws CRMException
	 */
	public void noticeActivity(String openid,String activityid) throws CRMException;
	/**
	 * 活动被关注统计数量
	 * @param activityid
	 * @return
	 * @throws CRMException
	 */
	public int countNoticeActivities(String activityid)throws CRMException;
	/**
	 * 得到活动的关注人员清点
	 * @param activityid
	 * @return
	 * @throws CRMException
	 */
	public List<String> getNoticeOpenIds(String activityid)throws CRMException;
	public List<Activity_Rela> getNoticeActivities(String activityid)throws CRMException ;
	public List<Activity_Rela> getNoticeActivitiesByOpenId(String openid)throws CRMException ;
	/**
	 * 得到OpenId对应人员关注的活动
	 * @param openid
	 * @return
	 * @throws CRMException
	 */
	public int countNoticeActivitiesByOpenId(String openid)throws CRMException ;
	/**
	 * 得到所有活动
	 * @return
	 * @throws CRMException
	 */
	public List<Activity> geActivities()throws CRMException ;
	public Activity geActivityById(String id)throws CRMException ;
	
}
