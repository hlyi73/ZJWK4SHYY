package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.service.TagModelService;

/**
 * 标签与实体关联实现类
 *
 */
@Service("tagModelService")
public class TagModelServiceImpl extends BaseServiceImpl implements
		TagModelService {
	 
	/**
	 * 获取sql配置文件命名空间
	 * 
	 * @return
	 */
	@Override
	protected String getNamespace() {
		return "tagModelSql.";
	}
	

	public BaseModel initObj() {
		return new Tag();
	}


	public List<Tag> findTagListByModelId(Tag mg) {
		List<Tag> tagList = getSqlSession().selectList("tagModelSql.findModelTagListByFilter", mg);
		return tagList;
	}


	public void saveTag(Tag tag) throws Exception {
		getSqlSession().insert("tagModelSql.insertModelTag", tag);
	}


	public boolean delStar(Tag tag) throws Exception {
		int rst = getSqlSession().delete("tagModelSql.deleteModelTag", tag);
		return rst > 0 ? true : false;
		
	}
	
	public void deleteById(String id) throws Exception {
		getSqlSession().delete("tagModelSql.deleteModelTagById", id);
		
	}
	
	public List<Customer> findCustomerListByTag(Tag tag) {
		 List<Customer> customerList = getSqlSession().selectList("tagModelSql.findCustomerListByTag",tag);
		return customerList;
	}

	
	public List<Opportunity> findOpptyListByTag(Tag tag) {
		 List<Opportunity> opptyList = getSqlSession().selectList("tagModelSql.findOpptyListByTag",tag);
			return opptyList;
	}

	
	public List<Contact> findContactListByTag(Tag tag) {
		List<Contact> contactList = getSqlSession().selectList("tagModelSql.findContactListByTag",tag);
		return contactList;
	}


	public void updateTag(Tag tag) throws Exception {
		getSqlSession().delete("tagModelSql.updateTageInfo", tag);
	}
}
