package com.takshine.core.service.business;

import java.util.List;
import java.util.Map;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupExam;
import com.takshine.wxcrm.domain.DiscuGroupNotice;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.Tag;



/**
 * 讨论组主服务
 * @author dengbo
 *
 */
public interface DiscuGroupMainService{
	
	public Map<String, String> getOrgList(String openId);
	
	public void handlerMesssageFlag(String targetUserId, String relaId);
	
	public DiscuGroup getDiscuGroupById(String id);
	
	public List<DiscuGroupUser> getDiscuGroupUsers(String disId);
	
	public List<DiscuGroupUser> getDiscuGroupAdminUsers(String disId);
	
	public List<DiscuGroupUser> getDiscuGroupAdminRelaUsers(String disId, String userId);

	public List<DiscuGroupNotice> getDiscuGroupNotices(String disId);
	
	public List<DiscuGroupExam> getDiscuGroupExams(String disId, String eventType);
	
	public List<DiscuGroupTopic> getGroupTopicList(String disId);
	
	/**
	 * 查询讨论组中的单个话题详情信息
	 * @param id 话题主键id
	 * @return DiscuGroupTopic 讨论组中的话题详情信息
	 */
	public DiscuGroupTopic getSingleGroupTopic(String id);
	
	public List<Tag> getTagModelList(String modelId, String modelType);
	
	public boolean isDiscuOwner(String disId, String userId);
	
	public boolean isDiscuAdmin(String disId, String userId);
	
	public boolean isDiscuIn(String disId, String userId);
	
	public boolean isDiscuAudit(String disId, String userId);
	
	public void sendMassInfo(String disId, String userId, String userName, String topicId, String topicType) throws Exception;
	
	/**
	 * 在讨论组中可以直接发表话题
	 * @param disId 讨论组id [必填]
	 * @param content 话题内容 [必填]
	 * @param sendUserId 发送人用户id [必填]
	 * @return String 话题ID:成功 ，空字符串:失败
	 */
	public String sendTextTopic(String disId, String content, String sendUserId) throws CRMException;
	
	
}
