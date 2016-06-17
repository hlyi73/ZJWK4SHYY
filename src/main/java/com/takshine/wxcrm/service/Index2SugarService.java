package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.domain.IndexKPI;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BugResp;
/**
 * 首页 相关业务接口实现
 * @author lilei
 *
 */
public interface Index2SugarService extends EntityService {
	/**
	 * 查询首页数据
	 * @return
	 */
	public IndexKPI getIndexKPI(String crmId,String startDate,String endDate)throws Exception ;
	
}
