package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Attachment;
import com.takshine.wxcrm.message.sugar.AttachmentResp;

/**
 * 附件  业务处理接口
 *
 * @author liulin
 */
public interface Attachment2CrmService extends EntityService {
	
	/**
	 * 查询 附件  数据列表
	 * @return
	 */
	public AttachmentResp getAttachmentList(Attachment sche, String source);

}
