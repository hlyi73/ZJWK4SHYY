package com.takshine.wxcrm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.UserFocus;
import com.takshine.wxcrm.service.UserFocusService;

/**
 * 用户关注   相关业务接口实现
 *
 * @author liulin
 */
@Service("userFocusService")
public class UserFocusServiceImpl extends BaseServiceImpl implements UserFocusService {
	
	private static Logger logger = Logger.getLogger(UserFocusServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "UserFocus";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "userFocusSql.";
	}
	
	public BaseModel initObj() {
		return new UserFocus();
	}

	/**
	 * 根据查询条件查询 用户关注 关系列表数据
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<UserFocus> getUserFocusListByPara(String crmId){
		//search param
		UserFocus obj = new UserFocus();
		if(null != crmId && !"".equals(crmId)) obj.setCrmId(crmId);//crmID
		return (List<UserFocus>)findObjListByFilter(obj);
	}
	
	/**
	 * 分页查询 用户关注 关系 数据信息
	 * @param entId
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getUserFocusListByPage(String entId, String page, String pageRows){
		
		Map<String, String> likeMap = new HashMap<String, String>();
		likeMap.put("entId", entId);
		//查询条件
		QueryFilter qf = new QueryFilter();
		qf.setLike(likeMap);
		//页和每页的条数
		qf.setPage(Integer.valueOf(page));//第几页
		qf.setRows(Integer.valueOf(pageRows));//每页的条数
		
		return findObjListByPage(qf);
	}
	
	/**
	 * 根据ID 获取用户关注 关系对象 同时存入到缓存中
	 * @param id
	 * @return
	 */
	@Cacheable(value="wxCrmSerCache", key="'userFocus_' + #id")
	public UserFocus getUserFocusById(String id) {
		return (UserFocus)findObjById(id);
	}
	
	/**
	 * 删除用户关注 关系 同时从缓存中去除
	 * @param id
	 */
	@CacheEvict(value="wxCrmSerCache", key= "'userFocus_' + #id")
	public void delUserFocus(String id){
		try {
			deleteObjById(id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	/**
	 * 修改用户关注 关系 同时更新缓存
	 * @param obj
	 * @return
	 */
	@CachePut(value="wxCrmSerCache", key= "'userFocus_' + #obj.getId()")
	public UserFocus updateUserFocus(UserFocus obj){
		try {
			updateObj(obj);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return obj;
		
	}
	
}