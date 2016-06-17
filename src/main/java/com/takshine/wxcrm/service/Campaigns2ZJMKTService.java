package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.message.sugar.CampaignsResp;

/**
 * 市场活动接口
 * @author dengbo
 *
 */
public interface Campaigns2ZJMKTService extends EntityService{
	
	/**
	 * 查询 市场活动数据列表
	 * @return
	 */
	public List<Activity> getCampaignsList(Campaigns camp, String source)throws Exception;
	
	
	/**
	 * 查询我报名的活动列表
	 * @return
	 */
	public List<Activity> getJoinCampaignsList(Campaigns camp, String source)throws Exception;
	
	/**
	 * 查询单个市场活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public CampaignsResp getCampaignsSingle(String rowid,String crmid)throws Exception;
	
	/**
	 * 通过不同的viewtype查询活动列表的ID
	 * @param camp
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getCampaigns(Campaigns camp)throws Exception;
	
	/**
	 * 得到推荐的活动
	 * @return
	 * @throws Exception
	 */
	public List<Activity> getRecommendCampaignsList()throws Exception;

}
