package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.ShareResp;

/**
 * 共享  业务处理接口
 *
 * @author liulin
 */
public interface Share2SugarService extends EntityService {
	
	/**
	 * 查询共享用户数据列表
	 * @return
	 */
	public ShareResp getShareUserList(Share sche,String source);
	
	/**
	 * 共享记录列表
	 * @param sche
	 * @param source
	 * @return
	 */
	public ShareResp getShareRecordList(Share sche) ;

	/**
	 * 增加或者取消共享用户
	 * @param ojb
	 * @return
	 */
	public CrmError updShareUser(Share obj);
	
}
