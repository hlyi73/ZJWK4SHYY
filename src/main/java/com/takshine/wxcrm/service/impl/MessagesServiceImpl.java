package com.takshine.wxcrm.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.service.MessagesService;

/**
 * 应收款/回款 内容回复
 * @author dengbo
 *
 */
@Service("messagesService")
public class MessagesServiceImpl extends BaseServiceImpl implements MessagesService{

	@Override
	protected String getDomainName() {
		return "Messages";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "messagesSql.";
	}
	
	public BaseModel initObj() {
		return new Messages();
	}
	
	/**
	 * 修改消息标志
	 * @param ids
	 * @throws Exception
	 */
	public void updateMessagesFlag(Messages msg) throws Exception {
		int r = 0;
		if(StringUtils.isNotNullOrEmptyStr(msg.getTargetUId()) && (StringUtils.isNotNullOrEmptyStr(msg.getRelaId()) || StringUtils.isNotNullOrEmptyStr(msg.getRelaModule())))
		{
			r = getSqlSession().update("messagesSql.updateMessagesFlag",msg);
		}
		else if(StringUtils.isNotNullOrEmptyStr(msg.getTargetUId()))
		{
			r= getSqlSession().update("messagesSql.updateMessagesFlagByTargetUID",msg);
		}
		else if (StringUtils.isNotNullOrEmptyStr(msg.getId()))
		{
			r= getSqlSession().update("messagesSql.updateMessagesFlagById",msg);
		}
		log.info("updateMessagesFlag rst = > " + r);
	}

	
	public List<Messages> searchMessagesByRelaIds(Messages msg) throws Exception {
		// TODO Auto-generated method stub
		return getSqlSession().selectList("messagesSql.searchMessagesByRelaIds", msg);
	}

	public List<Messages> searchSystemMessages(Messages msg) throws Exception {
		// TODO Auto-generated method stub
		return getSqlSession().selectList("messagesSql.findSystemMessagesByTargetId", msg);
	}
	
	/**
	 * 发送消息
	 * @param userId
	 * @param userName
	 * @param targetUId
	 * @param targetUName
	 * @param content
	 * @param relaModule
	 * @param relaId
	 * @param SubRelaId
	 * @param msgType
	 * @param readFlag
	 * @param createTime
	 * @param relaName
	 */
	public void sendMsg(String userId, String userName, String targetUId,
			         String targetUName, String content, String relaModule,
			            String relaId, String subRelaId, String msgType, 
			              String readFlag, Date createTime, String relaName){
		log.info("userId = >" + userId);
		log.info("userName = >" + userName);
		log.info("targetUId = >" + targetUId);
		log.info("targetUName = >" + targetUName);
		log.info("content = >" + content);
		
		//消息对象
		Messages msg = new Messages();
		msg.setUserId(userId);
		msg.setUsername(userName);
		msg.setTargetUId(targetUId);
		msg.setTargetUName(targetUName);
		msg.setContent(content);
		msg.setRelaModule(relaModule);
		msg.setRelaId(relaId);
		msg.setSubRelaId(subRelaId);
		msg.setMsgType(msgType);
		msg.setReadFlag(readFlag);
		msg.setCreateTime(createTime);
		msg.setRelaName(relaName);
		try {
			String id=addObj(msg);
			msg.setId(id);
		} catch (Exception e) {
			log.info("error = >" + e.getMessage());
		}
	}


	/**
	 * 删除消息
	 */
	public boolean deleteMessagesByTargetUId(Messages msg) throws Exception {
		int flg = getSqlSession().delete("messagesSql.deleteMessagesByTargetId", msg);
		if(flg > 1){
			return true;
		}
		return false;
	}

	
	/**
	 * 发送消息
	 * @param userId
	 * @param userName
	 * @param targetUId
	 * @param targetUName
	 * @param content
	 * @param relaModule
	 * @param relaId
	 * @param SubRelaId
	 * @param msgType
	 * @param readFlag
	 * @param createTime
	 * @param relaName
	 */
	public Messages sendMsg2(String userId, String userName, String targetUId,
			         String targetUName, String content, String relaModule,
			            String relaId, String subRelaId, String msgType, 
			              String readFlag, Date createTime, String relaName){
		log.info("userId = >" + userId);
		log.info("userName = >" + userName);
		log.info("targetUId = >" + targetUId);
		log.info("targetUName = >" + targetUName);
		log.info("content = >" + content);
		
		//消息对象
		Messages msg = new Messages();
		msg.setUserId(userId);
		msg.setUsername(userName);
		msg.setTargetUId(targetUId);
		msg.setTargetUName(targetUName);
		msg.setContent(content);
		msg.setRelaModule(relaModule);
		msg.setRelaId(relaId);
		msg.setSubRelaId(subRelaId);
		msg.setMsgType(msgType);
		msg.setReadFlag(readFlag);
		msg.setCreateTime(createTime);
		msg.setRelaName(relaName);
		try {
			String id=addObj(msg);
			msg.setId(id);
		} catch (Exception e) {
			log.info("error = >" + e.getMessage());
		}
		return msg;
	}
}
