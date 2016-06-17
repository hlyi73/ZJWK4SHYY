package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.common.LovVal;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.model.ModelTag;
import com.takshine.wxcrm.service.ModelTagService;
import com.takshine.wxcrm.service.TagService;

/**
 * 标签与实体关联实现类
 *
 */
@Service("modelTagService")
public class ModelTagServiceImpl extends BaseServiceImpl implements
		ModelTagService {

	@Override
	protected String getDomainName() {
		return "ModelTag";
	}

	@Autowired
	@Qualifier("tagService")
	private TagService tagService;

	/**
	 * 获取sql配置文件命名空间
	 * 
	 * @return
	 */
	@Override
	protected String getNamespace() {
		return "tagModelSql.";
	}

	public BaseModel initObj() {
		return new ModelTag();
	}

	public List<Tag> findTagListByModelId(ModelTag mg) {
		return getSqlSession().selectList(
				getNamespace() + "findTagListByModelId", mg);
	}

	public int deleteModelTagByModelId(String modelId) {
		return getSqlSession().delete(
				getNamespace() + "deleteModelTagByModelId", modelId);
	}

	
	/**
	 * 根据实体ID获得标签表中标签内容集合，以逗号隔开的JSON返回
	 * @return
	 */
	public String getTaglist(String modelid){
		
		ModelTag mt = new ModelTag();
		mt.setModel_id(modelid);
		List<Tag> taglist = findTagListByModelId(mt);
		//返回
		String rst = "[]";
		// 放到页面上
		if (null != taglist && taglist.size() > 0) {
			rst = JSONArray.fromObject(taglist).toString();
		}
		
		return rst;
	}
	
	
	/**
	 * 保存标签信息，完成标签表、实体与标签表关联表同步保存
	 * @param mg 标签内容信息  modelId:实体id, tagnames:以逗号隔开多标签内容, relamodel:模式，重建实体与标签关联表的方式
	 * @throws Exception
	 */
	public void setModelTagByMode(Map<String, String> mg) throws Exception {

		if (mg == null)
			throw new Exception("没有标签数据，不能保存！！");

		HashMap<String, String> mode = (HashMap<String, String>) mg;

		// 群标签信息
		String modelId = mode.get("modelId");
		String tagnames = mode.get("tagnames");
		String relamodel = mode.get("relamodel");

		if (!StringUtils.isNotBlank(tagnames)
				|| !StringUtils.isNotBlank(relamodel)
				|| !StringUtils.isNotBlank(modelId)) {
			throw new Exception("没有标签数据,不能保存！！");
		}
		
		// 标签表 遍历 保存
		String[] tagArrs = tagnames.split(",");
		List<String> tagids = new ArrayList<String>();
		for (int i = 0; i < tagArrs.length; i++) {
			String tagname = tagArrs[i];
			// tag实体
			Tag tag = new Tag();
			tag.setTagName(tagname);
			Object rsttag = tagService.findObj(tag);
			if (rsttag == null) {
				tag.setId(Get32Primarykey.getRandom32PK());
				tag.setModelType(LovVal.MODEL_TAG_TYPE_COMMON);
				tagService.addObj(tag);
			} else {
				tag = (Tag) rsttag;
			}
			// 保存到集合
			tagids.add(tag.getId());
		}
		// 根据前台传递的模式参数进行处理，现在都是recreate，重建实体与标签关联表
		if ("recreate".equals(relamodel)) {
			// 删除所有的关联重新插入
			deleteModelTagByModelId(modelId);
			// 遍历追加
			for (int a = 0; a < tagids.size(); a++) {
				ModelTag modelTag = new ModelTag();
				modelTag.setModel_id(modelId);
				modelTag.setTag_id(tagids.get(a));
				modelTag.setTag_point("0");
				addObj(modelTag);
			}
		}
	}

	public List<Tag> getTagListByMy(Tag tag) {
		return getSqlSession().selectList(
				getNamespace() + "findTagListAndCountByMy", tag);
	}

	public List<Tag> getTagListByOther(Tag tag) {
		return getSqlSession().selectList(
				getNamespace() + "findTagListAndCountByOther", tag);
	}

	public int batchAddObj(List<Tag> tagList) {
		return getSqlSession().insert(getNamespace() + "batchInsertTags", tagList);
	}

}
