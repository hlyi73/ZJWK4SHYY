package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.ProductType;
import com.takshine.wxcrm.message.sugar.ProductTypeReq;
import com.takshine.wxcrm.message.sugar.ProductTypeResp;

/**
 * 产品类别 业务处理接口
 *
 * @author huangpeng
 */
public interface ProductType2SugarService extends EntityService {

	/**
	 * 查询 产品类型列表
	 * 
	 * @return
	 */
	public ProductTypeResp getProducTypetList(ProductType proReq);

}
