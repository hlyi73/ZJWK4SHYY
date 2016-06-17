package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DiscuGroupNotice;
import com.takshine.wxcrm.service.DiscuGroupNoticeService;

/**
 * 讨论组公告 服务类
 *
 * @author liulin
 */
@Service("discuGroupNoticeService")
public class DiscuGroupNoticeServiceImpl extends BaseServiceImpl implements DiscuGroupNoticeService {
	
	//private static Logger log = Logger.getLogger(DiscuGroupServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "DiscuGroupNotice";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "discuGroupNoticeSql.";
	}
	
	public BaseModel initObj() {
		return new DiscuGroupNotice();
	}
}