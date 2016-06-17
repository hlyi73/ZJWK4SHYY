package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Message;
import com.takshine.wxcrm.service.MessageService;

/**
 * 消息 服务类
 *
 * @author liulin
 */
@Service("messageService")
public class MessageServiceImpl extends BaseServiceImpl implements MessageService {
	
	//private static Logger log = Logger.getLogger(MessageServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "Message";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "messageSql.";
	}
	
	public BaseModel initObj() {
		return new Message();
	}
	

}