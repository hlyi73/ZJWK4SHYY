package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.marketing.domain.SourceObject;

public interface SourceObject2SourceSystemService extends EntityService {
     public SourceObject getSourceObject(String sourceid,String source) throws Exception;
     
     
     public List<Organization> getOrgList(String sourceid) throws Exception;

     public List<Organization> getOrgList(String sourceid,String orgId) throws Exception ;
     
}
