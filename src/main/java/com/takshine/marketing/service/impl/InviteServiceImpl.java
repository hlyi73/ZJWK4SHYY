package com.takshine.marketing.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.marketing.domain.Invite;
import com.takshine.marketing.service.InviteService;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
/**
 * 
 * @author dengbo
 *
 */
@Service("inviteService")
public class InviteServiceImpl extends BaseServiceImpl implements InviteService {
	private static Logger logger = Logger.getLogger(InviteServiceImpl.class.getName());

	@Override
	protected String getDomainName() {
		return "Invite";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "inviteSql.";
	}
	
	public BaseModel initObj() {
		return new Invite();
	}
	
	/**
	 * 得到所有的短信邀请情况
	 */
	public List<Invite> findAllSmsInviteList(Invite invite) throws Exception{
		return getSqlSession().selectList("inviteSql.findAllSmsInviteList", invite);
	}
	
	/**
	 * 得到所有的讨论组邀请情况
	 */
	public List<Invite> findAllDiscuGroupInviteList(Invite invite) throws Exception{
		return getSqlSession().selectList("inviteSql.findAllDiscuGroupInviteList", invite);
	}
}
