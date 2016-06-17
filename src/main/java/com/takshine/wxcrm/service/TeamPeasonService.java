package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.TeamPeason;

/**
 * 团队成员
 * @author liulin
 *
 */
public interface TeamPeasonService extends EntityService{
	/**
	 * 删除团队成员
	 * @param tp
	 */
	public void deleteTeamPeason(TeamPeason tp);
	
	/**
	 * 查询关注的团队成员
	 * @param tp
	 */
	public List<String> findCheckedAtten(TeamPeason tp);
	
}
