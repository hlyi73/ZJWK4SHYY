package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BugResp;
/**
 * 缺陷  相关业务接口实现
 * @author lilei
 *
 */
public interface Bug2SugarService extends EntityService {
	/**
	 * 查询 bug数据列表
	 * @return
	 */
	public BugResp getBugList(Bug bug);
	
	/**
	 * 查询单个bug数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public BugResp getBug(String rowId, String crmId);
	
	/**
	 * 保存bug信息
	 * @param obj
	 * @return
	 */
	public CrmError addBug(Bug obj);
	
	/**
	 * bug的完成操作
	 * @param bug
	 * @param crmId
	 * @return
	 */
	public CrmError updateBugStatus(Bug bug, String crmId);
}
