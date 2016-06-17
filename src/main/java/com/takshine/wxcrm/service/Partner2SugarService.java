package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Partner;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.PartnerResp;

/**
 * 合作伙伴 业务接口
 * @author dengbo
 *
 */
public interface Partner2SugarService extends EntityService {
	
	/**
	 * 保存合作伙伴信息
	 * @param obj
	 * @return
	 */
	public CrmError addPartner(Partner obj);
	
	/**
	 * 查询合作伙伴数据列表
	 * @return
	 */
	public PartnerResp getPartnerList(Partner partner, String source);
	
	/**
	 * 删除合作伙伴
	 * @param obj
	 * @return
	 */
	public CrmError delPartner(Partner obj);
}
