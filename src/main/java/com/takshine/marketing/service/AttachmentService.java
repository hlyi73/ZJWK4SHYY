package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.Attachment;

/**
 * 附件处理类
 *
 */
public interface AttachmentService extends EntityService{
	
	/**
	 * 查询 附件列表
	 * @return
	 */
	public List<Attachment> getAttachmentList(Attachment att)throws Exception;
	
	
	/**
	 * 新建活动
	 * @param pro
	 * @return
	 * @throws Exception
	 */
	public boolean addAttachment(Attachment att)throws Exception;
	/**
	 * 删除活动
	 * @return
	 * @throws Exception
	 */
	public boolean delAttachment(Attachment att)throws Exception;
	
	/**
	 *查询活动附件列表
	 * @param Activity
	 * @return List<Attachment>
	 * @throws Exception
	 */
	public List<Attachment> getActivityAttachmentList(String activityid) throws Exception;
	
	
	public List<Attachment> getActivityAttachmentListByActId(String activityid) throws Exception;
}
