package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.TagService;
@Service("businessCardService")
public class BusinessCardImpl extends BaseServiceImpl implements
		BusinessCardService {
	@Override
	protected String getDomainName() {
		return "BusinessCard";
	}

	/**
	 * 获取sql配置文件命名空间
	 * 
	 * @return
	 */
	@Override
	protected String getNamespace() {
		return "businessCardSql.";
	}
	public BaseModel initObj() {
		return new BusinessCard();
	}

	public List<BusinessCard> getList(BusinessCard bc) {
		return getSqlSession().selectList(getNamespace()+"findBusinessCardListByFilter", bc);
	}

	public BusinessCard getBusinessCard(String id) {
		BusinessCard bc = new BusinessCard();
		bc.setId(id);
	    List<BusinessCard> list= getSqlSession().selectList(getNamespace()+"findBusinessCardListByFilter", bc);
	    if(list==null||list.size()<1){
		return null;
	    }else{
	    	return list.get(0);
	    }
	}

	public String insert(BusinessCard bc) {
		bc.setId(Get32Primarykey.getRandom32PK());

		if(this.getSqlSession().insert(getNamespace()+"insertBusinessCard", bc)>0){
			return bc.getId();
		}
		return null;
	}

	public int update(BusinessCard bc) {
		return this.getSqlSession().update(getNamespace()+"updateBusinessCardById", bc);
	}

	public int updatePhoneValidation(BusinessCard bc) {
		return this.getSqlSession().update(getNamespace()+"updatePhoneValidationStatus", bc);
	}
	public int updateEmailValidation(BusinessCard bc) {
		return this.getSqlSession().update(getNamespace()+"updateEmailValidationStatus", bc);
	}

	public List<BusinessCard> searchBusinessCard(BusinessCard bc) {
		return getSqlSession().selectList(getNamespace()+"searchBusinessCardListByFilter", bc);
	}

	public List<OperatorMobile> getOrgList(OperatorMobile oper)
			throws Exception {
		return getSqlSession().selectList("operatorMobileSql.findOrgListByOpenId", oper);
	}

	

}
