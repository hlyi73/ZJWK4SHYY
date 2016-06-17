package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.service.TeamPeasonService;

/**
 * 团队成员
 * @author liulin
 *
 */
@Service("teamPeasonService")
public class TeamPeasonServiceImpl extends BaseServiceImpl implements TeamPeasonService{

	@Override
	protected String getDomainName() {
		return "TeamPeason";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "teamPeasonSql.";
	}
	
	public BaseModel initObj() {
		return new TeamPeason();
	}
	
	/**
	 * 删除团队成员
	 * @param tp
	 */
	public void deleteTeamPeason(TeamPeason tp){
		getSqlSession().delete("teamPeasonSql.deleteTeamPeason", tp);
	}
	
	/**
	 * 查询关注的团队成员
	 * @param tp
	 */
	public List<String> findCheckedAtten(TeamPeason tp){
		return getSqlSession().selectList("teamPeasonSql.findCheckedAtten", tp);
	}
	
}
