package com.takshine.wxcrm.service.impl;

import org.apache.ibatis.annotations.Param;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.service.MessagesExtService;

/**
 *
 */
@Service("messagesExtService")
public class MessagesExtServiceImpl extends BaseServiceImpl implements MessagesExtService{
	private static Logger logger = Logger.getLogger(MessagesExtServiceImpl.class.getName());
	@Override
	protected String getDomainName() {
		return "MessagesExt";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "messagesExtSql.";
	}
	
	public BaseModel initObj() {
		return new MessagesExt();
	}
	
	/**
	 * 
	 * @param id
	 */
	public void delMessagesExt(MessagesExt ext){
		try {
			deleteObjById(ext);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	

}
