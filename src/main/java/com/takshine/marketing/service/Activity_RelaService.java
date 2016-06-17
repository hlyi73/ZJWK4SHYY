package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityItem;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Activity_Rela;

/**
 * 活动关联接口
 * @author dengbo
 *
 */
public interface Activity_RelaService extends EntityService{

	/**
	 * 批量增加
	 * @return
	 */
	public int batchAddActivityRela(List<Activity_Rela> list);
	
	
	public int deleteActivityRelaByActivityId(Activity_Rela ar);


	public int deleteActivity_RelaByActivityIdAndRelaId(Activity_Rela ar);
	public List<Activity_Rela> findActivity_RelaListByFilter(Activity_Rela ar);
}
