package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Expense;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ExpenseResp;

/**
 * 费用报销  业务处理接口
 *
 * @author liulin
 */
public interface Expense2CrmService extends EntityService {
	
	/**
	 * 查询 日程数据列表
	 * @return
	 */
	public ExpenseResp getExpenseList(Expense sche, String source) throws Exception;
	
	/**
	 * 查询单个日程数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ExpenseResp getExpenseSingle(Expense sche, String crmId) throws Exception;
	
	/**
	 * 查询已核销的报销原始数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ExpenseResp getOriginalExpense(Expense expense) throws Exception;
	
	/**
	 * 保存日程信息
	 * @param obj
	 * @return
	 */
	public CrmError addExpense(Expense obj) throws Exception;
	
	/**
	 * 批量提交 费用信息
	 * @param obj
	 * @return
	 */
	public CrmError batchApproval(Expense obj) throws Exception;
	
}
