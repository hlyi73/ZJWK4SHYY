package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.InnerUser;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Subscribe;

/**
 * 用户新闻订阅
 *  * @author lilei
 *
 */
public interface InnerUserService extends EntityService{
	public List<InnerUser> getInnerUserByOpenId(String openid,String firstChar)throws Exception;
	public List<String> getFirstList(String openid) throws Exception ;
	public List<InnerUser> getRssUserByOpenId(Subscribe subscribe)throws Exception;
}
