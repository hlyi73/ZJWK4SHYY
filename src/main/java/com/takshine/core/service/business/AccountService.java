package com.takshine.core.service.business;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;


/**
 * 客户服务
 * @author dengbo
 *
 */
public interface AccountService{
	public List<CustomerAdd> getCustomerList(Customer sche)throws CRMException;
	public List<CustomerAdd> getCustomerListByCurrentUser(HttpServletRequest request,Customer sche)throws CRMException;
	public CustomerAdd getCustomerSingle(Customer cust, String flag)  throws CRMException;
	public List<ShareAdd> getShareUsers(HttpServletRequest request, String rowId, String crmId, String source) throws CRMException;
	public List<String> checkBind(HttpServletRequest request, String orgId, String rowId) throws CRMException;
	public String delSearchCondition(HttpServletRequest request, String keyPrefix, String condition) throws CRMException;

}
