package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.ArticleInfo;
import com.takshine.wxcrm.service.ArticleInfoService;

/**
 * 文章信息
 * @author liulin
 *
 */
@Service("articleInfoService")
public class ArticleInfoServiceImpl extends BaseServiceImpl implements ArticleInfoService{

	@Override
	protected String getDomainName() {
		return "ArticleInfo";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "articleInfoSql.";
	}
	
	public BaseModel initObj() {
		return new ArticleInfo();
	}
}
