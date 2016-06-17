package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Subscribe;

/**
 * 用户订阅
 *  * @author dengbo
 *
 */
public interface SubscribeService extends EntityService{
	public List<Subscribe> getSubscribeList(Subscribe s) throws Exception;
}
