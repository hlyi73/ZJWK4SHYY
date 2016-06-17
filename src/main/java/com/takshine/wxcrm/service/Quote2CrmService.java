package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProductQuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteResp;

/**
 * 报价业务处理接口
 * @author dengbo
 */
public interface Quote2CrmService extends EntityService {
	
	/**
	 * 查询 报价数据列表
	 * @return
	 */
	public QuoteResp getQuoteList(QuoteAdd sche, String source)throws Exception ;
	
	/**
	 * 查询单个报价数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public QuoteResp getQuoteSingle(String rowId, String crmId);
	
	/**
	 * 修改报价信息
	 * @param obj
	 * @return
	 */
	public CrmError updateQuote(QuoteAdd obj);
	
	/**
	 * 修改报价信息
	 * @param obj
	 * @return
	 */
	public CrmError saveQuote(QuoteAdd obj);
	
	/**
	 * 保存报价明细
	 * @param productQuoteAdd
	 * @return
	 */
	public CrmError saveMxquote(ProductQuoteAdd productQuoteAdd);
	
	/**
	 * copy报价单
	 * @param rowId
	 * @return
	 */
	public CrmError copyQuote(String rowId,String crmId,String flag);
	
	/**
	 * 查找单个报价明细
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ProductQuoteAdd getMxQuote(String rowId,String crmId);
	
	/**
	 * 修改报价明细
	 * @param productQuoteAdd
	 * @return
	 */
	public CrmError updateMxQuote(ProductQuoteAdd productQuoteAdd);
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteQuote(QuoteAdd obj);
	
}
