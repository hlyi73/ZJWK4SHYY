package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DiscuGroupExam;
import com.takshine.wxcrm.service.DiscuGroupExamService;

/**
 * 讨论组审批 服务类
 *
 * @author liulin
 */
@Service("discuGroupExamService")
public class DiscuGroupExamServiceImpl extends BaseServiceImpl implements DiscuGroupExamService {
	
	//private static Logger log = Logger.getLogger(DiscuGroupServiceImpl.class.getName());

	@Override
	protected String getDomainName() {
		return "DiscuGroupExam";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "discuGroupExamSql.";
	}
	
	public BaseModel initObj() {
		return new DiscuGroupExam();
	}
}