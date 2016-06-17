package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.ActivityPrint;

public interface ActivityPrintService extends EntityService {
	/**
	 * 增加印迹
	 * @param ap
	 * @return
	 * @throws Exception
	 *//*
   public boolean addActivityPrint(ActivityPrint ap) throws Exception;*/
   /**
    * 计数统计
    * @param activityid
    * @param type
    * @return
    * @throws Exception
    */
   public int getActivityPrintCount(String activityid,String type) throws Exception;
   
   
   public List<ActivityPrint> searchActivityPrintList(ActivityPrint item) throws Exception;
   
   public List<ActivityPrint> searchActivityPrintListById(ActivityPrint item) throws Exception;
}
