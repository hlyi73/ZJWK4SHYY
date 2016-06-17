package com.takshine.marketing.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Participant;

/**
 * 参与用户处理
 *
 */
public interface ParticipantService extends EntityService {

	/**
	 * 查询参与用户列表
	 * 
	 * @param entId
	 * @return
	 */
	public List<Participant> getParticipantList(Participant par);
	
	/**
	 * 根据ID 获取参与用户
	 * 
	 * @param id
	 * @return
	 */
	public Participant getParticipantById(Participant par);

	/**
	 * 添加参与者
	 * 
	 * @param Participant
	 * @return
	 */
	public boolean addParticipant(Participant par)throws Exception;
	/**
	 * 报名
	 * 
	 * @param Participant
	 * @return
	 */
	public boolean addParticipant(Participant par,String activityid,String sourceid,String source)throws Exception;
	/**
	 * 删除参与用户
	 * 
	 * @param id
	 */
	public void delParticipant(Participant par);

	/**
	 * 修改参与用户
	 * 
	 * @param obj
	 * @return
	 */
	public Participant updateParticipant(Participant par);
	
	
	public List<Participant> getParticipantListByActivity(ActivityParticipant ap);
	public void updateSyncStatus(String id);
	
	/**
	 * 更新用户状态
	 * @param participant
	 */
	public int updateStatus(Participant participant) throws Exception;
	
	public int updateeBatchStatus(Participant participant) throws Exception;
}