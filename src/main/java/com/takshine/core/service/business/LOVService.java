package com.takshine.core.service.business;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.message.sugar.CustomerAdd;


/**
 * 客户服务
 * @author dengbo
 *
 */
public interface LOVService{
	/**
	 * 行业
	 */
	public static final String KEY_INDUSTRY = "industry_dom";
	/**
	 * 客户类型
	 */
	public static final String KEY_ACCOUNT_TYPE = "account_type_dom";

	public Map<String, Map<String, String>> getLovValues(HttpServletRequest request)throws CRMException;

}
