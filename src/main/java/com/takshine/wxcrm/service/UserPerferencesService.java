package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.UserPerferences;

/**
 * 个性化设置
 * @author liulin
 *
 */
public interface UserPerferencesService extends EntityService{
	
	public void deleteUserPerferencesByParam(UserPerferences u);
	public void updateAutoWeekWorkRerportByParam();
	public void updateAutoDayWorkRerportByParam();
	
}
