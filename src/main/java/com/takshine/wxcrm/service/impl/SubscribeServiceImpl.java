package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.service.SubscribeService;

/**
 * 用户订阅
 * @author dengbo
 *
 */
@Service("subscribeService")
public class SubscribeServiceImpl extends BaseServiceImpl implements SubscribeService{

	@Override
	protected String getDomainName() {
		return "Subscribe";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "subscribeSql.";
	}
	
	public BaseModel initObj() {
		return new Subscribe();
	}

	public List<Subscribe> getSubscribeList(Subscribe s) throws Exception {
		List<Subscribe> list= getSqlSession().selectList("subscribeSql.findSubscribeList", s);
		return list;
	}
	
}
