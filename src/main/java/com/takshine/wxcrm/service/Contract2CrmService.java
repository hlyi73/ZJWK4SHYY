package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Contract;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContractResp;
import com.takshine.wxcrm.message.sugar.PaymentMethod;

/**
 * 合同 业务处理接口
 * @author dengbo
 *
 */
public interface Contract2CrmService extends EntityService{
	
	/**
	 * 查询 合同数据列表
	 * @return
	 */
	public ContractResp getContractList(Contract sche, String source)throws Exception;
	
	/**
	 * 查询单个合同数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	public ContractResp getContractSingle(String rowId, String crmId);
	
	/**
	 * 增加合同信息
	 * @param obj
	 * @return
	 */
	public CrmError addContract(Contract obj);
	
	/**
	 * 增加合同条款信息
	 * @param obj
	 * @return
	 */
	public CrmError addPayments(PaymentMethod obj);
	
	/**
	 * 修改并保存合同信息
	 * @param obj
	 * @return
	 */
	public CrmError updateContract(Contract obj);
	
	/**
	 * 删除
	 * @param obj
	 * @return
	 */
	public CrmError deleteContract(Contract obj);
	
}
