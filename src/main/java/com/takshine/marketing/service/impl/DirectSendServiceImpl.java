package com.takshine.marketing.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.marketing.model.DirectSendModel;
import com.takshine.marketing.service.DirectSendService;
import com.takshine.wxcrm.service.MessagesService;

/**
 * 图文直播
 * @author dengbo
 *
 */
@Service("directSendService")
public class DirectSendServiceImpl extends BaseServiceImpl implements DirectSendService{

	@Override
	protected String getDomainName() {
		return "DirectSendModel";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "directSendModelSql.";
	}
	
	public BaseModel initObj() {
		return new DirectSendModel();
	}
	
}
