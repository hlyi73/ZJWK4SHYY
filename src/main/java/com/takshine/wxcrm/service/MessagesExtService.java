package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.MessagesExt;

/**
 * 应收款/回款 内容回复
 * @author dengbo
 *
 */
public interface MessagesExtService extends EntityService{
	public void delMessagesExt(MessagesExt ext);

}
