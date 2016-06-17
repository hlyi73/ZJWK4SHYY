package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.UserFocus;

/**
 * 用户关注关系  业务处理接口
 *
 * @author liulin
 */
public interface UserFocusService extends EntityService {
    
	/**
	 * 根据查询条件查询 用户关注 关系列表
	 * @param entId
	 * @return
	 */
	public List<UserFocus> getUserFocusListByPara(String entId);
	
	/**
	 * 分页查询用户关注 关系数据信息
	 * @param mobile
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getUserFocusListByPage(String entId, String page, String pageRows);
	
	/**
	 * 根据ID 获取用户关注 关系对象
	 * @param id
	 * @return
	 */
	public UserFocus getUserFocusById(String id);
	
	/**
	 * 删除用户关注 关系
	 * @param id
	 */
	public void delUserFocus(String id);
	
	/**
	 * 修改用户关注 关系
	 * @param obj
	 * @return
	 */
	public UserFocus updateUserFocus(UserFocus obj);
	
}