package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Feeds;
import com.takshine.wxcrm.message.sugar.FeedsResp;

/**
 * 报表  业务处理接口
 *
 */
public interface FeedsService extends EntityService {
	
	/**
	 * 活动流
	 * @return
	 */
	public FeedsResp getFeedList(Feeds feed);
	
	public FeedsResp getAllFeedList(Feeds feed) throws Exception;
	
	public FeedsResp getFeedById(Feeds feed);
	
	public FeedsResp replyFeed(Feeds feed);
	
	public FeedsResp getNewFeedList(Feeds feed);
}
