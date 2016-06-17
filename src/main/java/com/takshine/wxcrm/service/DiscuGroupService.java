package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;

/**
 * 讨论组  处理接口
 *
 * @author liulin
 */
public interface DiscuGroupService extends EntityService {
	
	/**
	 * 查询讨论组用户列表
	 * @return
	 */
	public List<DiscuGroupUser> findDiscuGroupUserList(DiscuGroupUser dg);
	
	public CrmError addDiscuGroupTopic(DiscuGroupTopic dgt);
	
	public CrmError updateDiscuGroupTopic(DiscuGroupTopic dgt);
	
	public void updateDiscuGroupStatus(DiscuGroup dgt);
	
	public CrmError deleteDiscuGroupTopic(DiscuGroupTopic dgt);
	
	/**
	 * 根据话题ID 删除讨论组话题
	 */
	public void delDiscuGroupTopicByTopicId(String topicid);
	
	public List<DiscuGroupTopic> findDiscuGroupTopicList(DiscuGroupTopic dgt);
	
	public List<DiscuGroupTopic> findDiscuGroupTopicByParam(DiscuGroupTopic dgt);
	
	public List<DiscuGroup> findJoinDiscuGroupList(DiscuGroup dg);
	
	public List<DiscuGroup> findWeightDiscuGroupList(DiscuGroup dg);
	
	public List<DiscuGroup> findConditionGroupListByFilter(DiscuGroup dg);
	
	public Activity findActivityById(String id);
	
	/**
	 * 根据类型查询活动列表 owner join
	 */
	public List<CampaignsAdd> findActivityListByType(String userid, String type);
	
	/**
	 * 根据文章id查询文章
	 */
	public Resource findArticleById(String id);
}