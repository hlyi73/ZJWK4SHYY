package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.DiscuGroupUser;

/**
 * 讨论组用户  处理接口
 *
 * @author liulin
 */
public interface DiscuGroupUserService extends EntityService {
	
	/**
	 * 更新用户的状态
	 * @param dgu
	 */
	public void updateDiscuGroupUserType(DiscuGroupUser dgu);
	
	/**
	 * 删除群用户
	 * @param dgu
	 */
	public void removeDiscuGroupUser(String dgid, String user_id, String dgname);
	
	/**
	 * 根据参数查询讨论组用户
	 * @param dgu
	 * @return
	 */
	public List<DiscuGroupUser> findDiscuGroupUserByParam(DiscuGroupUser dgu);
	
	/**
	 * 根据参数查询所有的讨论组用户
	 * @param dgu
	 * @return
	 */
	public List<DiscuGroupUser> findAllDiscuGroupUser(DiscuGroupUser dgu);
	
}