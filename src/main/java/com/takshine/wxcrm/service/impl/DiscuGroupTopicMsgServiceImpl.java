package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DiscuGroupTopicMsg;
import com.takshine.wxcrm.service.DiscuGroupTopicMsgService;

/**
 * 讨论组话题消息 服务类
 *
 * @author liulin
 */
@Service("discuGroupTopicMsgService")
public class DiscuGroupTopicMsgServiceImpl extends BaseServiceImpl implements DiscuGroupTopicMsgService {
	
	//private static Logger log = Logger.getLogger(DiscuGroupServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "DiscuGroupTopicMsg";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "discuGroupTopicMsgSql.";
	}
	
	public BaseModel initObj() {
		return new DiscuGroupTopicMsg();
	}
}