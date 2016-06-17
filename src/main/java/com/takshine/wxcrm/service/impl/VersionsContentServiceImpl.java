package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Versions;
import com.takshine.wxcrm.domain.VersionsContent;
import com.takshine.wxcrm.service.VersionsContentService;

/**
 * 版本内容管理
 * @author
 *
 */
@Service("versionsContentService")
public class VersionsContentServiceImpl extends BaseServiceImpl implements VersionsContentService{

	private static Logger log = Logger.getLogger(VersionsContentServiceImpl.class.getName());


	@Override
	protected String getDomainName() {
		return "VersionsContent";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "versionsContentSql.";
	}
	
	public BaseModel initObj() {
		return new Versions();
	}
	
	/**
	 * 查询版本内容
	 * @param entId
	 * @return
	 */
	public List<VersionsContent> findVersionsContentList(VersionsContent vc){
		

		List<VersionsContent> vcList = getSqlSession().selectList("versionsContentSql.findVersionsContentListByFilter", vc);
		
		return vcList;
	}
}
