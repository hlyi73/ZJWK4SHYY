package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.service.TagService;

/**
 * 标签实现类
 *
 */
@Service("tagService")
public class TagServiceImpl extends BaseServiceImpl implements TagService{

	@Override
	protected String getDomainName() {
		return "Tag";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "tagSql.";
	}
	
	public BaseModel initObj() {
		return new Tag();
	}

	public List<Tag> findTagListByUserId(String userId) {
		// TODO Auto-generated method stub
		return getSqlSession().selectList(getNamespace()+"findTagListByUserId", userId);
	}




}
