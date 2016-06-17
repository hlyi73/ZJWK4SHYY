package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.ArticleType;
import com.takshine.wxcrm.service.ArticleTypeService;

/**
 * 文章类别
 * @author liulin
 *
 */
@Service("articleTypeService")
public class ArticleTypeServiceImpl extends BaseServiceImpl implements ArticleTypeService{

	@Override
	protected String getDomainName() {
		return "ArticleType";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "articleTypeSql.";
	}
	
	public BaseModel initObj() {
		return new ArticleType();
	}
	
	/**
	 * 查询文章类型
	 * @param name
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ArticleType> findArticleTypeByFilter(String name){
		ArticleType search = new ArticleType();
		search.setName(name);
		List<ArticleType> artTypeList = (List<ArticleType>)findObjListByFilter(search);
		return artTypeList;
	}
	
}
