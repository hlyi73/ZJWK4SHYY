package com.takshine.marketing.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.marketing.domain.Activity_Rela;
import com.takshine.marketing.service.Activity_RelaService;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DiscuGroupUser;
/**
 * 
 * @author dengbo
 *
 */
@Service("activity_RelaService")
public class Activity_RelaServiceImpl extends BaseServiceImpl implements Activity_RelaService {
	private static Logger logger = Logger.getLogger(Activity_RelaServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "Activity_Rela";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "activity_RelaSql.";
	}
	
	public BaseModel initObj() {
		return new Activity_Rela();
	}
	
	public int batchAddActivityRela(List<Activity_Rela> aList) {
		return getSqlSession().insert(getNamespace() + "batchInsertActivity_Rela", aList);
	}
	
	public int deleteActivityRelaByActivityId(Activity_Rela ar){
		return getSqlSession().insert(getNamespace() + "deleteActivity_RelaByActivityId", ar);
	}

	public int deleteActivity_RelaByActivityIdAndRelaId(Activity_Rela ar) {
		return getSqlSession().insert(getNamespace() + "deleteActivity_RelaByActivityIdAndRelaId", ar);
	}

	public List<Activity_Rela> findActivity_RelaListByFilter(Activity_Rela ar){
		return getSqlSession().selectList(getNamespace() + "findActivity_RelaListByFilter", ar);
	}

}
