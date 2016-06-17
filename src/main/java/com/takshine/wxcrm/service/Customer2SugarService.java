package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerResp;

/**
 * 客户任务  业务处理接口
 *
 * @author liulin
 */
public interface Customer2SugarService extends EntityService {
	
	/**
	 * 查询 客户数据列表
	 * @return
	 */
	public CustomerResp getCustomerList(Customer sche,String source)throws Exception;
	
	/**
	 * 查询单个客户数据
	 * @param rowId
	 * @param crmId
	 * @param flag
	 * @return
	 */
	public CustomerResp getCustomerSingle(Customer cust,String flag);

	/**
	 * 增加客户
	 * @param ojb
	 * @return
	 */
	public CrmError addCustomer(Customer obj);
	
	/**
	 * 修改客户
	 * @param obj
	 * @return
	 */
	public CrmError updateCustomer(Customer obj);
	
	/**
	 * 删除客户
	 * @param obj
	 * @return
	 */
	public CrmError deleteCustomer(Customer obj);
	
}
