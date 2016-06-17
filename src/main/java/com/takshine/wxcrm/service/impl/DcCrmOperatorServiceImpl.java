package com.takshine.wxcrm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.service.DcCrmOperatorService;

/**
 * 德成CRM用户   相关业务接口实现
 *
 * @author liulin
 */
@Service("dcCrmOperatorService")
public class DcCrmOperatorServiceImpl extends BaseServiceImpl implements DcCrmOperatorService {
	
	private static Logger logger = Logger.getLogger(DcCrmOperatorServiceImpl.class.getName());
	
	
	@Override
	protected String getDomainName() {
		return "DcCrmOperator";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "DcCrmOperatorSql.";
	}
	
	public BaseModel initObj() {
		return new DcCrmOperator();
	}

	/**
	 * 根据查询条件查询 用户和手机绑定关系列表数据
	 * @param entId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DcCrmOperator> getDcCrmOperatorListByPara(String orgId){
		//search param
		DcCrmOperator obj = new DcCrmOperator();
		if(null != orgId && !"".equals(orgId)) obj.setOrgId(orgId);//企业ID
		return (List<DcCrmOperator>)findObjListByFilter(obj);
	}
	
	/**
	 * 分页查询 用户和手机绑定关系 数据信息
	 * @param entId
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getDcCrmOperatorListByPage(String entId, String page, String pageRows){
		
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
	 * 根据ID 获取用户和手机绑定关系对象 同时存入到缓存中
	 * @param id
	 * @return
	 */
	@Cacheable(value="wxCrmSerCache", key="'DcCrmOperator_' + #id")
	public DcCrmOperator getDcCrmOperatorById(String id) {
		return (DcCrmOperator)findObjById(id);
	}
	
	/**
	 * 删除用户和手机绑定关系 同时从缓存中去除
	 * @param id
	 */
	@CacheEvict(value="wxCrmSerCache", key= "'DcCrmOperator_' + #id")
	public void delDcCrmOperator(String id){
		try {
			deleteObjById(id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	/**
	 * 修改用户和手机绑定关系 同时更新缓存
	 * @param obj
	 * @return
	 */
	@CachePut(value="wxCrmSerCache", key= "'DcCrmOperator_' + #obj.getId()")
	public DcCrmOperator updateDcCrmOperator(DcCrmOperator obj){
		try {
			updateObj(obj);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return obj;
		
	}
	
	/**
	 * 修改用户和手机绑定关系 同时更新缓存
	 * @param obj
	 * @return
	 */
	@CachePut(value="wxCrmSerCache", key= "'DcCrmOperator_' + #obj.getId()")
	public DcCrmOperator updateDcCrmByCrmId(DcCrmOperator obj){
		try {
			getSqlSession().update("DcCrmOperatorSql.updateDcCrmOperatorBycrmId", obj);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return obj;
		
	}

	/**
	 * 根据Id查询一个
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DcCrmOperator> findDcCrmOperatorListByFilter(String crmId) {
		DcCrmOperator obj = new DcCrmOperator();
		if(null != crmId && !"".equals(crmId)) obj.setCrmId(crmId);
		return (List<DcCrmOperator>)findObjListByFilter(obj);
	}

	
	public DcCrmOperator findDcCrmOperatorByOpenId(DcCrmOperator obj) {
		try {
			obj = getSqlSession().selectOne("DcCrmOperatorSql.findUserNameByOpenId", obj);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return obj;
	}
	
	/**
	 * 跟进partyid 查询 德成用户
	 * @param partyId
	 * @return
	 */
	public DcCrmOperator findDcCrmOperatorByPartyId(String partyId) {
		List<DcCrmOperator> rst = null;
		try {
			rst = getSqlSession().selectList("DcCrmOperatorSql.findDcCrmOperatorByPartyId", partyId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		if(rst.size() > 0 ){
			return rst.get(0);
		}
		return new DcCrmOperator();
	}
}