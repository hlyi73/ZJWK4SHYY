package com.takshine.marketing.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Participant;

public interface Participant2WkService extends EntityService {
     public String syncParticipant2Contact(String source,String sourceid,Participant pc) throws Exception;
}
