package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Analytics;
import com.takshine.wxcrm.message.sugar.AnalyticsResp;
import com.takshine.wxcrm.message.sugar.RepeatNameReq;
import com.takshine.wxcrm.message.sugar.RepeatNameResp;

/**
 * 检查重复名称业务处理接口
 * @author dengbo
 */
public interface RepeatNameService extends EntityService {
	
	/**
	 * 检查是否有重名的情况
	 * @param req
	 * @return
	 */
	public RepeatNameResp checkName(RepeatNameReq req);
}
