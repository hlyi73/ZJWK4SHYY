package com.takshine.wxcrm.service;


import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Product;
import com.takshine.wxcrm.message.sugar.ProductResp;
/**
 * 产品  业务处理接口
 *
 * @author huangpeng
 */
public interface Product2SugarService extends EntityService{
      
	
	/**
	 * 查询 产品数据列表
	 * @return
	 */
	public ProductResp getProductList(Product pro,String source);
	
	
	/**
	 * 查询单个 产品数据
	 * @param rowId
	 * @param crmId
	 * @param flag
	 * @return
	 */
	public ProductResp getProductSingle(String rowId, String crmId);

}
