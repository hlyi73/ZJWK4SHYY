package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.OpptyResp;

/**
 * 业务机会任务  业务处理接口
 *
 * @author liulin
 */
public interface Oppty2SugarService extends EntityService {
	
	/**
	 * 查询 业务机会数据列表
	 * @return
	 */
	public OpptyResp getOpportunityList(Opportunity oppty,String source) throws Exception;
	
	/**
	 * 查询单个业务机会数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public OpptyResp getOpportunitySingle(String rowId, String crmId);
	
	/**
	 * 跟新单个业务机会数据
	 * @param oppty
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public CrmError updateOppty(Opportunity oppty)throws Exception;
	
	/**
	 * 保存业务机会信息
	 * @param oppty
	 * @return
	 */
	public CrmError addOppty(Opportunity oppty);
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteOpportunity(Opportunity obj);
	

}
