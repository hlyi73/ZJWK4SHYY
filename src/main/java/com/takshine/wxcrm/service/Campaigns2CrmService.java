package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsResp;

/**
 * 市场活动接口
 * @author dengbo
 *
 */
public interface Campaigns2CrmService extends EntityService{
	
	/**
	 * 查询 市场活动数据列表
	 * @return
	 */
	public CampaignsResp getCampaignsList(Campaigns sche, String source)throws Exception;
	
	/**
	 * 查询单个市场活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public CampaignsResp getCampaignsSingle(String rowid,String crmid)throws Exception;
	
	/**
	 * 增加市场活动
	 * @param campaignsAdd
	 * @return
	 * @throws Exception
	 */
	public CrmError saveCampaigns(CampaignsAdd campaignsAdd) throws Exception;
	
	/**
	 * 修改市场活动
	 * @param campaignsAdd
	 * @return
	 * @throws Exception
	 */
	public CrmError updateCampaigns(CampaignsAdd campaignsAdd)throws Exception;
}
