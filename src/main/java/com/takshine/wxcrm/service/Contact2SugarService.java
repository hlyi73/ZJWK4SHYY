package com.takshine.wxcrm.service;

import java.util.List;
import java.util.Map;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContactResp;

/**
 * 联系人  业务处理接口
 *
 * @author liulin
 */
public interface Contact2SugarService extends EntityService {
	
	/**
	 * 保存联系人信息
	 * @param obj
	 * @return
	 */
	public CrmError addContact(Contact obj);
	public Map<String,CrmError> addContact(Map<String,Contact> obj);
	
	/**
	 * 保存联系人关系信息
	 * @param obj
	 * @return
	 */
	public CrmError saveContact(Contact obj);
	
	/**
	 * 查询单个联系人数据列表
	 * @return
	 */
	public ContactResp getContactSingle(String rowId, String crmId) throws Exception;
	
	/**
	 * 根据parentId查询联系人数据列表
	 * @return
	 */
	public ContactResp getContactList(Contact con, String source) throws Exception;
	
	/**
	 * 手工分组查询
	 * @return
	 * @throws Exception
	 */
	public List<Tag> getHandGroupList(Contact con) ;

	/**
	 * 修改联系人
	 * @param con
	 * @return
	 */
	public CrmError updateContactById(Contact con);
	
	/**
	 * 删除联系人
	 * @param obj
	 * @return
	 */
	public CrmError delContact(Contact obj);
	
	/**
	 * 查询联系人列表
	 */
	public ContactResp getContactClist(Contact con, String source) throws Exception;
	
	/**
	 * 修改联系人并保存联系人
	 */
	public CrmError updateContact(Contact con);
	
	/**
	 * 查找联系人关系
	 * @param con
	 * @return
	 */
	public ContactResp getContactRelation(Contact con);
	
	/**
	 * 添加联系人关系
	 * @param obj
	 * @return
	 */
	public CrmError addContactRelation(Contact obj);
	
	
	/**
	 * 修改影响力
	 * @param obj
	 * @return
	 */
	public CrmError updateContectEffect(Contact obj);
	
	/**
	 * 删除影响力
	 * @param obj
	 * @return
	 */
	public CrmError deleteContactEffect(Contact obj);
	
	
	/**
	 * 删除联系人
	 * @param obj
	 * @return
	 */
	public CrmError deleteContact(Contact obj);
}
