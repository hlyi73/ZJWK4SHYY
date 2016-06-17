package com.takshine.marketing.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Participant;
import com.takshine.marketing.service.ParticipantService;

/**
 *  查询参与用户
 */
@Service("participantService")
public class ParticipantServiceImpl extends BaseServiceImpl implements ParticipantService {
	
	private static Logger logger = Logger.getLogger(ParticipantServiceImpl.class.getName());
	
	
	@Override
	protected String getDomainName() {
		return "Participant";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "ParticipantSql.";
	}
	
	public BaseModel initObj() {
		return new Participant();
	}

	/**
	 * 查询参与用户列表
	 */
	public List<Participant> getParticipantList(Participant par) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 查询单个用户
	 */
	public Participant getParticipantById(Participant par) {
		Participant part = getSqlSession().selectOne("ParticipantSql.findParticipantById", par.getId());
		return part;
	}

	/**
	 * 删除参与用户
	 */
	public void delParticipant(Participant par) {
		// TODO Auto-generated method stub
		
	}

	/**
	 * 修改参与用户
	 */
	public Participant updateParticipant(Participant par) {
		// TODO Auto-generated method stub
		return null;
	}

	public boolean addParticipant(Participant par,String activityid,String sourceid,String source) throws Exception {
		logger.info("ParticipantServiceImpl ---> 报名开始");
		boolean flag = false;
		par.setId(Get32Primarykey.getRandom32PK());
		
		int result = getSqlSession().insert("ParticipantSql.saveParticipant", par);
		if(result != -1){
			ActivityParticipant ap = new ActivityParticipant();
			ap.setId(Get32Primarykey.getRandom32PK());
			ap.setActivityid(activityid);
			ap.setParticipantid(par.getId());
			ap.setSource(source);
			ap.setSourceid(sourceid);
			result = getSqlSession().insert("activityparticipantsql.saveActivityParticipant", ap);
			if(result != -1){
			flag = true;
			}
		}
		logger.info("ParticipantServiceImpl --> 报名结束");
		return flag;
	}

	public boolean addParticipant(Participant par) throws Exception {
		logger.info("ParticipantServiceImpl ---> 添加参与者开始");
		boolean flag = false;
		par.setId(Get32Primarykey.getRandom32PK());
		
		int result = getSqlSession().insert("ParticipantSql.saveParticipant", par);

			if(result != -1){
			flag = true;
			}
		logger.info("ParticipantServiceImpl --> 添加参与者结束");
		return flag;
	}

	public List<Participant> getParticipantListByActivity(ActivityParticipant ap) {
		List<Participant> list = getSqlSession().selectList("activityparticipantsql.findActivityParticipantList", ap);
		return list;
	}

	public void updateSyncStatus(String id) {
		getSqlSession().selectList("ParticipantSql.updateParticipantSyncStatusById", id);
		
	}
	
	/**
	 * 更新用户状态
	 * @param participant
	 */
	public int updateStatus(Participant participant) throws Exception{
		return getSqlSession().update("ParticipantSql.updateParticipantStatusById", participant);
	}
	
	/**
	 * 批量更新用户状态
	 * @param participant
	 */
	public int updateeBatchStatus(Participant participant) throws Exception{
		return getSqlSession().update("ParticipantSql.updateBatchParticipantStatusById", participant);
	}
	
}