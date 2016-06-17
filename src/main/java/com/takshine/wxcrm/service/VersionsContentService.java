package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.VersionsContent;

/**
 * 版本内容管理接口
 * @author liulin
 *
 */
public interface VersionsContentService extends EntityService{
	
	/**
	 * 查询版本内容 
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<VersionsContent> findVersionsContentList(VersionsContent vc);
	
	
}
