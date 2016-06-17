package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.OperatorMobile;

public interface BusinessCardService extends EntityService {
   public List<BusinessCard> getList(BusinessCard bc);
   public List<BusinessCard> searchBusinessCard(BusinessCard bc);
   public BusinessCard getBusinessCard(String id);
   public String insert(BusinessCard bc);
   public int update(BusinessCard bc);
   public int updatePhoneValidation(BusinessCard bc);
   public int updateEmailValidation(BusinessCard bc);
   
   public List<OperatorMobile> getOrgList(OperatorMobile oper) throws Exception;

}
