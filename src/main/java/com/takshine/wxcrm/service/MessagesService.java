package com.takshine.wxcrm.service;

import java.util.Date;
import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Messages;

/**
 * 应收款/回款 内容回复
 * @author dengbo
 *
 */
public interface MessagesService extends EntityService{
	
	/**
	 * 修改消息标志
	 * @param ids
	 * @throws Exception
	 */
	public void updateMessagesFlag(Messages msg) throws Exception;
	
	public List<Messages> searchMessagesByRelaIds(Messages msg) throws Exception;
	
	
	public List<Messages> searchSystemMessages(Messages msg) throws Exception;
	
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
			            String relaId, String SubRelaId, String msgType, 
			              String readFlag, Date createTime, String relaName);

	public boolean deleteMessagesByTargetUId(Messages msg) throws Exception;

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
			            String relaId, String SubRelaId, String msgType, 
			              String readFlag, Date createTime, String relaName);

}
