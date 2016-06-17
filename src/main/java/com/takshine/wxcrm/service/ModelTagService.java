package com.takshine.wxcrm.service;

import java.util.List;
import java.util.Map;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.model.ModelTag;


/**
 * 标签与模块关联服务
 * @author Administrator
 *
 */
public interface ModelTagService extends EntityService{
	
	public List<Tag> findTagListByModelId(ModelTag mg);
	
	public int deleteModelTagByModelId(String modelId);
	
	/**
	 * 保存标签信息，完成标签表、实体与标签表关联表同步保存
	 * @param mg 标签内容信息  modelId:实体id, tagnames:以逗号隔开多标签内容, relamodel:模式，重建实体与标签关联表的方式
	 * @throws Exception
	 */
	public void setModelTagByMode(Map<String, String> mg)  throws Exception;
	
	
	/**
	 * 根据实体ID获得标签表中标签内容集合，以逗号隔开的JSON返回
	 * @return
	 */
	public String getTaglist(String modelid);
	public List<Tag> getTagListByMy(Tag tag);
	public List<Tag> getTagListByOther(Tag tag);

	public int batchAddObj(List<Tag> tagList);
}
