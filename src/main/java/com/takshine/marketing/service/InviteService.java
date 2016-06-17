package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityItem;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Invite;

/**
 * 邀请处理接口
 * @author dengbo
 *
 */
public interface InviteService extends EntityService{
	
	public List<Invite> findAllSmsInviteList(Invite invite) throws Exception;
	public List<Invite> findAllDiscuGroupInviteList(Invite invite) throws Exception;
}
