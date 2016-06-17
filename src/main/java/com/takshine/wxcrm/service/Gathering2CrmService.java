package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Gathering;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.GatheringResp;

/**
 * 收款 业务处理接口
 * @author dengbo
 *
 */
public interface Gathering2CrmService extends EntityService{
	
	/**
	 * 查询 收款数据列表
	 * @return
	 */
	public GatheringResp getGatheringList(Gathering sche, String source);
	
	/**
	 * 查询 开票数据列表
	 * @return
	 */
	public GatheringResp getGatheringListForInv(Gathering sche, String source);
	
	/**
	 * 查询单个收款数据
	 * @param rowId
	 * @param crmId
	 * @param gatheringtype
	 * @return
	 */
	public GatheringResp getGatheringSingle(String rowId, String crmId,String gatheringtype);
	
	/**
	 * 保存 回款跟进信息
	 */
	public String saveFollowup(Gathering obj, String rowId);
	
	/**
	 * 财务审核信息
	 */
	public String finaceVerifity(Gathering obj, String rowId);
	
	/**
	 * 保存回款
	 * @return
	 */
	public CrmError addGathering(GatheringAdd gatheringAdd);
	
	/**
	 * 修改回款
	 * @return
	 */
	public CrmError updateGathering(GatheringAdd gatheringAdd);
}
