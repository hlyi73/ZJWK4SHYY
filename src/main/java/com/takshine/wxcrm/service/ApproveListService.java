package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveListAdd;
import com.takshine.wxcrm.message.sugar.ApproveListResp;

/**
 * 审批service类
 * @author dengbo
 *
 */
public interface ApproveListService extends EntityService{

	/**
	 * 查询审批列表
	 * @param approve
	 * @param source
	 * @return
	 */
	public ApproveListResp getApproveList(ApproveListAdd approve, String source)throws Exception;
	
	/**
	 * 批量审批
	 * @param approve
	 * @return
	 */
	public CrmError updateApproveList(ApproveListAdd approve);
}
