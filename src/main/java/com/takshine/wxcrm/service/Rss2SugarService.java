package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.message.sugar.BugResp;
import com.takshine.wxcrm.message.sugar.RssReq;

public interface Rss2SugarService extends EntityService {
	/**
	 * 查询订阅 Trackhis数据列表
	 * @return
	 */
	public Trackhis  getTrackhisList(RssReq rssReq);
}
