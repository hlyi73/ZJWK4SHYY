package com.takshine.wxcrm.service;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.impl.DiscuGroupMainServiceImpl;
import com.takshine.core.service.exception.CRMException;

@RunWith(SpringJUnit4ClassRunner.class)  
@ContextConfiguration(locations = { "classpath:spring-mvc.xml","classpath:applicationContext.xml" }) 
public class DiscuGroupMainServiceTest {
	
	protected static Logger log = Logger.getLogger(DiscuGroupMainServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Test
	public void getDiscuGroupUsers(){
		String disId = "20150306092648228917794ad7ea9177";
		cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupUsers(disId);
	}
	
	@Test
	public void sendTextTopic() throws CRMException {
		String disId = "20150306092648228917794ad7ea9177";
		String content = "1111";
		String sendUserId = "1111";
		cRMService.getBusinessService().getDiscuGroupMainService().sendTextTopic(disId, content, sendUserId);
	}
}
