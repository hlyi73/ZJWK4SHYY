package com.takshine.core.service.business.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.ActivityService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.Activity_Rela;
import com.takshine.wxcrm.base.common.ErrCode;

/**
 * 客户服务
 * @author dengbo
 *
 */
@Service("coreBusinessActivityService")
public class ActivityServiceImpl implements ActivityService {
	protected static Logger logger = Logger.getLogger(ActivityServiceImpl.class.getName());
	protected static final String NoticeActivityType = "NoticeActivityType";
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	public void noticeActivity(String openid, String activityid) throws CRMException {
		try {
			Activity_Rela ar = new Activity_Rela();
			ar.setRela_id(openid);
			ar.setRela_name("关注");
			ar.setRela_type(NoticeActivityType);
			ar.setActivity_id(activityid);
			cRMService.getDbService().getActivity_RelaService().deleteActivityRelaByActivityId(ar);
			cRMService.getDbService().getActivity_RelaService().addObj(ar);
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public int countNoticeActivities(String activityid) throws CRMException{
		try {
			List<Activity_Rela> list = getNoticeActivities(activityid);
			if (list == null) return 0;
			return list.size();
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	
	
	private void checkActivity(String activityid) throws Exception{
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(activityid);
		
		Date date = sdf.parse(act.getStart_date());
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(date);
		Calendar cal2 = Calendar.getInstance();
		if (cal1.after(cal2) == false) throw new RuntimeException("");
	}
	
	
	public List<Activity_Rela> getNoticeActivities(String activityid)
			throws CRMException {
		try {
			checkActivity(activityid);
			Activity_Rela ar = new Activity_Rela();
			ar.setRela_name("关注");
			ar.setRela_type(NoticeActivityType);
			ar.setActivity_id(activityid);
			List<Activity_Rela> retlist = cRMService.getDbService().getActivity_RelaService().findActivity_RelaListByFilter(ar);
			
			
			return retlist;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public List<String> getNoticeOpenIds(String activityid)throws CRMException
	{
		List<String> retlist = new ArrayList<String>();
		try {
			
			List<Activity_Rela> list = getNoticeActivities(activityid);
			if (list != null){
				for(Activity_Rela ar : list){
					retlist.add(ar.getRela_id());
				}
			}
			return retlist;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public List<Activity> geActivities() throws CRMException {
		try {
			return cRMService.getDbService().getActivityService().getActivityList(new Activity());
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public List<Activity_Rela> getNoticeActivitiesByOpenId(String openid)
			throws CRMException {
		try {
			Activity_Rela ar = new Activity_Rela();
			ar.setRela_name("关注");
			ar.setRela_type(NoticeActivityType);
			ar.setOpenId(openid);
			List<Activity_Rela> list =  cRMService.getDbService().getActivity_RelaService().findActivity_RelaListByFilter(ar);
			List<Activity_Rela> retlist =  new ArrayList<Activity_Rela>();
			for(Activity_Rela a : list){
				try{
					checkActivity(a.getActivity_id());
					retlist.add(a);
				}catch(Exception ec){
					
				}
			}
			return retlist;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public int countNoticeActivitiesByOpenId(String openid) throws CRMException {
		try {
			List<Activity_Rela> list = getNoticeActivitiesByOpenId(openid);
			if (list == null) return 0;
			return list.size();
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}
	public Activity geActivityById(String id) throws CRMException {
		try {
			return cRMService.getDbService().getActivityService().getActivitySingle(id);
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,e.getMessage()));
		}
	}

}
