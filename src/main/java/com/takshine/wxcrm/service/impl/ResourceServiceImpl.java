package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.CatchPicture;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxMsgUtil;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.ResourceRela;
import com.takshine.wxcrm.service.PrintService;
import com.takshine.wxcrm.service.ResourceService;

/**
 * 资料服务实现类
 * @author zhihe
 *
 */
@Service("resourceService")
public class ResourceServiceImpl extends BaseServiceImpl implements ResourceService{
	private static Logger logger = Logger.getLogger(ResourceServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("printService")
	private PrintService printService;
	
	@Override
	protected String getDomainName() {
		return "Resource";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "resourceSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 根据条件查询资料列表
	 * @param res
	 * @return list
	 */
	public List<Resource> findResourceListByFilter(Resource res) 
	{
		return getSqlSession().selectList("resourceSql.findResourceListByFilter", res);
	}
	
	public List<MessagesExt> getAllMessagesExtByRelaId(MessagesExt mext)
	{
		return getSqlSession().selectList("messagesExtSql.findMessagesExtListByFilter", mext);
	}

	/**
	 * 根据条件查询资料关系
	 * @param rela
	 * @return list
	 */
	public List<ResourceRela> findResourceRelaListByFilter(ResourceRela rela) 
	{
		return null;
	}

	/**
	 * 根据id更新资料
	 * @param res
	 */
	public void updateResourceById(Resource res) 
	{
		//更新资料库，状态
		int retInt = getSqlSession().update("resourceSql.updateResourceById",res);
		//如果是更新成删除状态则完成后删除对应的关系
		if (retInt > 0 && "0".equals(res.getResourceStatus()))
		{
			ResourceRela rela = new ResourceRela();
			rela.setRelaResourceId(res.getResourceId());
			rela.setRelaUserId(res.getCreator());
			getSqlSession().delete("resourceSql.deleteResourceRelaById",rela);
		}
		//如果是更新成公开推荐，则完成后更新关系表的被推荐数+1
		else if (retInt > 0 && "public".equals(res.getResourceInfo2()))
		{
			ResourceRela rela = new ResourceRela();
			rela.setRelaResourceId(res.getResourceId());
			rela.setRelaUserId(res.getCreator());
			rela.setRelaInfo1("1");
			getSqlSession().update("resourceSql.updateResourceRelaById",rela);
		}
	}

	/**
	 * 根据id更新关系
	 * @param rela
	 */
	public void updateResourceRelaById(ResourceRela rela)
	{
		getSqlSession().update("resourceSql.updateResourceRelaById",rela);
	}

	/**
	 * 新增资料
	 */
	public int addResource(Resource res) throws Exception
	{
		try
		{
			//针对url特殊处理，去掉最后的#wechat_redirect
			if (StringUtils.isNotNullOrEmptyStr(res.getResourceUrl()))
			{
				res.setResourceUrl(res.getResourceUrl().replace("#wechat_redirect", ""));
			}
			
			//保存前校验是否已经存在于数据库中
			if(StringUtils.isNotNullOrEmptyStr(res.getResourceUrl())){
				List<Resource> retTemp = getSqlSession().selectList("resourceSql.findResourceByUrl", res);
				if (null != retTemp && !retTemp.isEmpty())
				{
					logger.info("----------ResourceServiceImpl --- addResource --- 重复资源地址 " + res.getResourceUrl());
					return 2;
				}
			}
			
			if (!StringUtils.isNotNullOrEmptyStr(res.getResourceId()))
			{
				res.setResourceId(Get32Primarykey.getRandom32PK());
			}

			if(!StringUtils.isNotNullOrEmptyStr(res.getResourceType())){
				res.setResourceType(WxMsgUtil.REQ_MESSAGE_TYPE_LINK);
			}
			logger.info("----------ResourceServiceImpl --- addResource --- insert resouce ");
			//插入新资料
			int resourceInt = getSqlSession().insert("resourceSql.insertResource", res);
			
			if(WxMsgUtil.REQ_MESSAGE_TYPE_LINK.equals(res.getResourceType()) || "timg".equals(res.getResourceType())){
				logger.info("----------ResourceServiceImpl --- addResource --- download img");
				//保存关联的图片
				try{
					String imgSrc = "";
					if(WxMsgUtil.REQ_MESSAGE_TYPE_LINK.equals(res.getResourceType())){
						imgSrc = CatchPicture.getResourceImage(res.getResourceUrl());
					}else{
						imgSrc = CatchPicture.getResourceImageByContent(res.getResourceContent());
					}
					logger.info("----------ResourceServiceImpl --- addResource --- download img src===" + imgSrc);
					if(StringUtils.isNotNullOrEmptyStr(imgSrc)){
						MessagesExt me = new MessagesExt();
						me.setId(Get32Primarykey.getRandom32PK());
						me.setFilename(imgSrc);
						me.setSource_filename(res.getResourceUrl());
						me.setRelaid(res.getResourceId());
						me.setFiletype("img");
						me.setRelatype("Resource");
						getSqlSession().insert("messagesExtSql.insertMessagesExt", me);
						logger.info("----------ResourceServiceImpl --- addResource --- add link img ");
					}
				}catch(Exception e){
					logger.info("----------ResourceServiceImpl --- addResource --- 获取网页图片失败！");
				}
			}
			
			Print print= new Print();
			print.setObjectid(res.getResourceId());
			print.setOwnid(res.getCreator());
			print.setOperativeid(res.getCreator());
			print.setObjectname(res.getResourceTitle());
			print.setObjecttype("ARTICE");
			print.setOperativetype("CREATE");
			printService.insert(print);//添加印记
			
			//如果保存资料成功，则添加关联关系
			if (resourceInt > 0)
			{
				ResourceRela rela = new ResourceRela();
				rela.setRelaId(Get32Primarykey.getRandom32PK());
				rela.setRelaResourceId(res.getResourceId());
				rela.setRelaUserId(res.getCreator());
				rela.setRelaExploreNum("0");
				getSqlSession().insert("resourceSql.insertResourceRela", rela);
				
				return 1;
			}
		}
		catch(Exception ex)
		{
			log.error("add resource infomation has some error!" + ex.toString());
			throw ex;
		}
		
		return 0;
	}
	
	/**
	 * 查询系统推荐数据
	 * @return
	 * @throws Exception
	 */
	public List<Resource> findResourceBySys(Resource res)
	{
		return getSqlSession().selectList("resourceSql.findResourceBySys",res);
	}
}
