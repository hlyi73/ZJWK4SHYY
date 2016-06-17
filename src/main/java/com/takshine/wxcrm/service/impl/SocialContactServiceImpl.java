package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.SocialContact;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.SocialContactService;

/**
 * 微博联系人关联
 * @author dengbo
 *
 */
@Service("socialContactService")
public class SocialContactServiceImpl extends BaseServiceImpl implements SocialContactService{

	@Override
	protected String getDomainName() {
		return "SocialContact";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "socialContactSql.";
	}
	
	public BaseModel initObj() {
		return new SocialContact();
	}
	
}
