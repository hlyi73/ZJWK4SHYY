package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Tag;

public interface TagModelService extends EntityService{

	
	
    public List<Tag> findTagListByModelId(Tag mg);
	
	//public int deleteModelTagByModelId(String modelId);
	
	/**
	 * 保存标签信息，完成标签表、实体与标签表关联表同步保存
	 * @param mg 标签内容信息  modelId:实体id, tagnames:以逗号隔开多标签内容, relamodel:模式，重建实体与标签关联表的方式
	 * @throws Exception
	 */
	public void saveTag(Tag tag)  throws Exception;
	
	public boolean delStar(Tag tag) throws Exception;
	
	public List<Customer> findCustomerListByTag(Tag tag);
	
	public List<Opportunity> findOpptyListByTag(Tag tag);
	
	public List<Contact> findContactListByTag(Tag tag);
	
	public void updateTag(Tag tag)  throws Exception;
	public void deleteById(String id)throws Exception;

}
