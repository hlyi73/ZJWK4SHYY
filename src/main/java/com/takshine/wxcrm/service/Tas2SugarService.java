package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.message.sugar.TasResp;

/**
 * TAS销售方法论  业务处理接口
 *
 * @author liulin
 */
public interface Tas2SugarService extends EntityService {
	
	/**
	 * 查询  价值主张
	 * @param obj
	 * @return
	 */
	public TasResp searchVal(String crmId, String rowId);
	
	/**
	 * 修改价值主张
	 */
	public String updateVal(String crmId, String rowId, String dataColl);
	
	/**
	 * 查询强制性事件
	 * @param obj
	 * @return
	 */
	public TasResp searchEvt(String crmId, String rowId);
	
	/**
	 * 修改强制性事件
	 */
	public String updateEvt(String crmId, String rowId, String dataColl);
	
	/**
	 * 修改竞争策略
	 * @param obj
	 * @return
	 */
	public String updateSgy(Opportunity oppty);
	
}
