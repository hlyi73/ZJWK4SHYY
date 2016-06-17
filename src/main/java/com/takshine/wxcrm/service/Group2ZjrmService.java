package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Group;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BugResp;
/**
 * 群  相关业务接口实现
 * @author lilei
 *
 */
public interface Group2ZjrmService extends EntityService {
	public List<Group> getPublicGroupList(String openId)throws Exception;//所有的公开群 包含订阅ID
	public List<Group> getPublicGroupList()throws Exception;//所有的公开群
	public Group getGroupDetail(String groupId) throws Exception;//查询群详情 包含活动列表
}
