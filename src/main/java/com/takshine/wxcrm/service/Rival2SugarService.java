package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Rival;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.RivalResp;

/**
 * 竞争对手 业务处理接口
 * @author dengbo
 *
 */
public interface Rival2SugarService extends EntityService {
	/**
	 * 保存竞争对手信息
	 * @param obj
	 * @return
	 */
	public CrmError addRival(Rival obj);
	
	/**
	 * 查询竞争对手数据列表
	 * @return
	 */
	public RivalResp getRivalList(Rival rival, String source);
	
	/**
	 * 删除竞争对手
	 * @param rival
	 * @return
	 */
	public CrmError delRival(Rival rival);
}
