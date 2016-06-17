package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.ResourceRela;

/**
 * 资料
 * @author zhihe
 *
 */
public interface ResourceService extends EntityService
{
	//获取资料列表
	public List<Resource> findResourceListByFilter(Resource res);
	//获取资料关系列表
	public List<ResourceRela> findResourceRelaListByFilter(ResourceRela rela);
	//更新资料
	public void updateResourceById(Resource res);
	//更新关系
	public void updateResourceRelaById(ResourceRela rela);
	//新增资料
	public int addResource(Resource res) throws Exception;
	//获取资料关联的图片消息
	public List<MessagesExt> getAllMessagesExtByRelaId(MessagesExt mext);
	//获取系统推荐文章
	public List<Resource> findResourceBySys(Resource res);
}
