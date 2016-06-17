package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.ActivityPrint;

public interface ActivityParticipantService extends EntityService {
	
	/**
	 * 根据参与人Id得到所有的参与活动
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getActivityListById(ActivityParticipant activityParticipant)throws Exception;
}
