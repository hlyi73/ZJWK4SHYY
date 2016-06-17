package com.takshine.marketing.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.service.ActivityParticipantService;
/**
 * 
 * @author dengbo
 *
 */
@Service("activityParticipantService")
public class ActivityParticipantServiceImpl extends BaseServiceImpl implements ActivityParticipantService {

	protected String getNamespace(){
		return "activityparticipantsql.";
	}
	
	public BaseModel initObj() {
		return new ActivityParticipant();
	}
	protected String getDomainName() {
		return "ActivityParticipant";
	}

	/**
	 * 根据参与人Id得到所有的参与活动
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getActivityListById(ActivityParticipant activityParticipant)throws Exception{
		List<Activity> list = new ArrayList<Activity>();
		Object object = getSqlSession().selectList("activityparticipantsql.findActivityListByParticipantId", activityParticipant);
		if(null!=object){
			list = (List<Activity>)object;
		}
		return list;
	}

}
