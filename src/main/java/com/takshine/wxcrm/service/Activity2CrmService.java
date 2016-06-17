package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Activity;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProjectResp;

/**
 * 活动处理接口
 * @author lilei
 *
 */
public interface Activity2CrmService extends EntityService{
	
	/**
	 * 查询 活动数据列表
	 * @return
	 */
	public ProjectResp getActivityList(Activity sche, String source)throws Exception;
	
	/**
	 * 查询单个活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public ProjectResp getActivitySingle(String rowid,String crmid)throws Exception;
	/**
	 * 新建活动
	 * @param pro
	 * @return
	 * @throws Exception
	 */
	public CrmError addActivity(Activity pro)throws Exception;
	/**
	 * 更新活动
	 * @return
	 * @throws Exception
	 */
	public CrmError updateActivity(Activity pro)throws Exception;
}
