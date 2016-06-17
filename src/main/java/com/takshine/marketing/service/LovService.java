package com.takshine.marketing.service;

import java.util.Map;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Lov;

/**
 * 下拉列表服务类
 *
 */
public interface LovService extends EntityService {
	
	/**
	 * 获取下拉列表 
	 * @return
	 */
	public Map<String, Map<String, String>> getLovList(Lov lov);

}
