package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.RssNews;
import com.takshine.wxcrm.domain.SocialContact;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.SocialContactService;
import com.takshine.wxcrm.service.RssNewsService;
import com.takshine.wxcrm.service.SubscribeService;

/**
 * 用户新闻订阅
 * @author dengbo
 *
 */
@Service("rssNewsService")
public class RssNewsServiceImpl extends BaseServiceImpl implements RssNewsService{

	@Override
	protected String getDomainName() {
		return "RssNews";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "rssNewsSql.";
	}
	
	public BaseModel initObj() {
		return new RssNews();
	}
	
}
