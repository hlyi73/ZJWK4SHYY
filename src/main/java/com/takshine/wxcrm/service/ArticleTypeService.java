package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.ArticleType;

/**
 * 文章类别
 * @author liulin
 *
 */
public interface ArticleTypeService extends EntityService{
	
	/**
	 * 查询文章类型
	 * @param name
	 * @return
	 */
	public List<ArticleType> findArticleTypeByFilter(String name);
	
}
