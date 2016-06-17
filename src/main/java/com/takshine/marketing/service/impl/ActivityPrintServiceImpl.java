package com.takshine.marketing.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.marketing.domain.ActivityPrint;
import com.takshine.marketing.service.ActivityPrintService;
/**
 * 
 * @author dengbo
 *
 */
@Service("activityPrintService")
public class ActivityPrintServiceImpl   extends BaseServiceImpl implements ActivityPrintService{


	public int getActivityPrintCount(String activityid, String type)
			throws Exception {

		return 0;
	}

	protected String getNamespace(){
		return "activityPrintSql.";
	}
	
	public BaseModel initObj() {
		return new ActivityPrint();
	}
	protected String getDomainName() {
		return "ActivityPrint";
	}

	public List<ActivityPrint> searchActivityPrintList(ActivityPrint item)
			throws Exception {
		return getSqlSession().selectList("activityPrintSql.findActivityPrintByFilter", item);
	}
	
	public List<ActivityPrint> searchActivityPrintListById(ActivityPrint item)
			throws Exception {
		return getSqlSession().selectList("activityPrintSql.findActivityPrintById", item);
	}

}
