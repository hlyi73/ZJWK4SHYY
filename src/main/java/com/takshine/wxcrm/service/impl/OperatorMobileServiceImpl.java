package com.takshine.wxcrm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.message.sugar.AuthReq;
import com.takshine.wxcrm.message.sugar.AuthResp;
import com.takshine.wxcrm.service.OperatorMobileService;

/**
 * 用户和手机绑定关系   相关业务接口实现
 *
 * @author liulin
 */
@Service("operatorMobileService")
public class OperatorMobileServiceImpl extends BaseServiceImpl implements OperatorMobileService {
	
	private static Logger logger = Logger.getLogger(OperatorMobileServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "OperatorMobile";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "operatorMobileSql.";
	}
	
	public BaseModel initObj() {
		return new OperatorMobile();
	}

	/**
	 * 根据查询条件查询 用户和手机绑定关系列表数据
	 * @param entId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<OperatorMobile> getOperMobileListByPara(String orgId){
		//search param
		OperatorMobile obj = new OperatorMobile();
		if(null != orgId && !"".equals(orgId)) obj.setOrgId(orgId);//企业ID
		return (List<OperatorMobile>)findObjListByFilter(obj);
	}
	
	/**
	 * 根据查询条件查询 用户和手机绑定关系列表数据
	 * @param entId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<OperatorMobile> getOperMobileListByPara(OperatorMobile obj){
		return (List<OperatorMobile>)findObjListByFilter(obj);
	}
	
	/**
	 * 分页查询 用户和手机绑定关系 数据信息
	 * @param entId
	 * @param page
	 * @param pageRows
	 * @return
	 */
	public Page getOperMobileListByPage(String entId, String page, String pageRows){
		
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
	@Cacheable(value="wxCrmSerCache", key="'operatorMobile_' + #id")
	public OperatorMobile getOperMobileById(String id) {
		return (OperatorMobile)findObjById(id);
	}
	
	/**
	 * 删除用户和手机绑定关系 同时从缓存中去除
	 * @param id
	 */
	@CacheEvict(value="wxCrmSerCache", key= "'operatorMobile_' + #id")
	public void delOperMobile(String id){
		try {
			deleteObjById(id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	/**
	 * 跟进crmId 删除用户和手机绑定关系 
	 * @param id
	 */
	public boolean delOperMobileByCrmId(String crmId){
		try {
			int result = getSqlSession().delete("operatorMobileSql.deleteOperatorMobileByCrmId", crmId);
			if(result != -1){
				return true;
			}else{
				return false;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}
	}
	
	/**
	 * 修改用户和手机绑定关系 同时更新缓存
	 * @param obj
	 * @return
	 */
	@CachePut(value="wxCrmSerCache", key= "'operatorMobile_' + #obj.getId()")
	public OperatorMobile updateOperMobile(OperatorMobile obj){
		try {
			updateObj(obj);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return obj;
		
	}
	
	
	/**
	 * 帐号绑定
	 * @param obj
	 * @return
	 */
	public AuthResp bindCrmAccount(OperatorMobile obj) throws Exception{
		AuthReq aq = new AuthReq();
		aq.setCrmaccount(obj.getCrmAccount());
		aq.setCrmpwd(obj.getCrmPass());
		aq.setModeltype(Constants.MODEL_TYPE_USER);
		aq.setType(Constants.ACTION_BINDING);
		aq.setSource(Constants.SYS_SOURCE);
		aq.setInitorgid(obj.getOrgId());
		log.info("bindCrmAccount start => aq is : " + aq);
		String jsonStr = JSONObject.fromObject(aq).toString();
		log.info("bindCrmAccount jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr, Constants.INVOKE_SINGLE);
		log.info("bindCrmAccount rst => rst is : " + rst);
		if("".equals(rst)) throw new Exception("绑定接口调用失败 请与管理员联系");
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")).toString());
		if(jsonObject.containsKey("errcode")){
			//错误代码和消息
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("bindCrmAccount errcode => errcode is : " + errcode);
			log.info("bindCrmAccount errmsg => errmsg is : " + errmsg);
			return new AuthResp();
		}else{
			AuthResp aRes = new AuthResp();
			aRes.setCrmaccount(jsonObject.getString("crmaccount"));
			aRes.setCrmid(jsonObject.getString("crmid"));
			aRes.setModeltype(jsonObject.getString("modeltype"));
			aRes.setOpname(jsonObject.getString("opname"));
			aRes.setOpduty(jsonObject.getString("opduty"));
			aRes.setOpmobile(jsonObject.getString("opmobile"));
			aRes.setOpemail(jsonObject.getString("opemail"));
			aRes.setOpaddress(jsonObject.getString("opaddress"));
			aRes.setOpdepart(jsonObject.getString("opdepart"));
			return aRes;
		}
	}
	
	/**
	 * 查询组织列表
	 * @param oper
	 * @return
	 * @throws Exception
	 */
	public List<OperatorMobile> getOrgList(OperatorMobile oper) throws Exception{
		return getSqlSession().selectList("operatorMobileSql.findOrgListByOpenId", oper);
	}

	/**
	 * 根据openId获取所有绑定的系统列表，排除个人版
	 */
	public List<OperatorMobile> getBindingOrgList(OperatorMobile oper) throws Exception {
		return getSqlSession().selectList("operatorMobileSql.findBindingOrgListByOpenId", oper);
	}

	public List<OperatorMobile> getNoBindingOrgList(OperatorMobile oper) throws Exception {
		return getSqlSession().selectList("operatorMobileSql.findNoBindingOrgListByOpenId", oper);
	}
	
}