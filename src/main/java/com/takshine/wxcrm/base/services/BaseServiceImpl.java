package com.takshine.wxcrm.base.services;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.log4j.Logger;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.BeanUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.util.StringUtils;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.ServiceUtils;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.domain.cache.CacheBase;
import com.takshine.wxcrm.message.sugar.inf.SugarRequest;

/**
 * 业务操作基类
 * @author liulin
 *
 */
public  class BaseServiceImpl extends SqlSessionDaoSupport {
	
	private static Logger logger =  Logger.getLogger(BaseServiceImpl.class.getName());
	
	/**
	 * 注入SqlSession
	 */
	@Resource
	public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
		super.setSqlSessionFactory(sqlSessionFactory);
	}
	
	protected static final String PRIMARY_KEY = "ID";
	protected static final String FINDALL_PREFFIX = "findAll";
	protected static final String FINDALL_SUFFIX = "List";
	protected static final String INSERT_PREFFIX = "insert";
	protected static final String DELETE_PREFFIX = "delete";
	protected static final String UPDATE_PREFFIX = "update";
	protected static final String FIND_PREFFIX = "find";
	protected static final String BYID_SUFFIX = "ById";
	protected static final String BYFILTER_SUFFIX = "ListByFilter";
	protected final Log log = LogFactory.getLog(getClass());

	public BaseServiceImpl() {
	}

	protected  String getDomainName() {
		return null;
	}

	protected String getNamespace(){
		return null;
	}
	
	public List<?> findAllObjList() {
		return getSqlSession().selectList(getNamespace() + getFindAllStatementId());
	}
	
	public List<?> findObjListByFilter(BaseModel obj) {
		return getSqlSession().selectList(getNamespace() + getFindbyfilterStatementId(), obj);
	}
	
	public List<?> findObjListByFilter(CacheBase obj) {
		return getSqlSession().selectList(getNamespace() + getFindbyfilterStatementId(), obj);
	}
	
	public int countObjByFilter(BaseModel baseModel){
		Integer total = (Integer)getSqlSession().selectOne(getNamespace() + getCountbyFilterStatementId(), baseModel);
		return total;
	}
	
	public Page findObjListByPage(QueryFilter filter) {
		
		if (filter.getStartNum() < 0 || filter.getEndNum() <= 0
				|| filter.getEndNum() <= filter.getStartNum()) {
			filter.setPage(1);//第几页
			filter.setRows(10);//每页的条数
		}
		if(null == filter.getOrderByString()){
			//排序
			filter.setOrderByString(" order by id desc ");
		}
		//根据查询条件查询分页数据 和 总数数据
		Integer total = (Integer)getSqlSession().selectOne(getNamespace() + getCountbyFilterStatementId(), filter);
		List<?> data = getSqlSession().selectList(getNamespace() + getFindbyPageStatementId(), filter);
		//分页对象
		Page p = new Page();
		p.setSize(total);//总数
		p.setData(data);
		p.setPage(filter.getPage());//第几页
		p.setPageSize(filter.getRows());//每页多少条
		
		return p;
	}

	public BaseModel findObj(BaseModel obj) {
		List<?> list = getSqlSession().selectList(getNamespace() + getFindbyfilterStatementId(), obj);
		if(null != list && list.size() > 0) return (BaseModel)list.get(0);
		else return null;
	}
	
	public CacheBase findObj(CacheBase obj) {
		List<?> list = getSqlSession().selectList(getNamespace() + getFindbyfilterStatementId(), obj);
		if(null != list && list.size() > 0) return (CacheBase)list.get(0);
		else return null;
	}
	
	public BaseModel findObjById(String id) {
		 Object obj = getSqlSession().selectOne(getNamespace() + getFindbyStatementId(), id);
		 if(null != obj){
			 return (BaseModel) getSqlSession().selectOne(getNamespace() + getFindbyStatementId(), id);
		 }else{
			 return null;
		 }
	}

	public String addObj(BaseModel Obj) throws Exception {
		if(null == Obj.getId()){
			Obj.setId(Get32Primarykey.getRandom32BeginTimePK());
		}
		if(Obj.getCreateTime() == null){
			Obj.setCreateTime(DateTime.currentDate());
		}
		getSqlSession().insert(getNamespace() + getInsertStatementId(), Obj);
		return Obj.getId();
	}
	
	public String addObj(CacheBase obj) throws Exception {
		if(obj.getCreate_date() == null){
			obj.setCreate_date(DateTime.currentDate(DateTime.DateFormat1));
		}
		getSqlSession().insert(getNamespace() + getInsertStatementId(),  obj);
		return obj.getRowid();
	}
	
	public void deleteObjById(String id) throws Exception {
		getSqlSession().delete(getNamespace() + getDeleteStatementId(), id);
	}
	public void deleteObjById(BaseModel Obj) throws Exception {
		getSqlSession().delete(getNamespace() + getDeleteStatementId(), Obj);
	}
	
	public void updateObj(BaseModel Obj) throws Exception {
		if(Obj.getUpdateTime() == null){
			Obj.setUpdateTime(DateTime.currentDate());
		}
		getSqlSession().update(getNamespace() + getUpdateStatementId(), Obj);
	}
	
	public void updateObj(CacheBase obj) throws Exception {
		if(obj.getModify_date() == null){
			obj.setModify_date(DateTime.currentDate(DateTime.DateFormat1));
		}
		getSqlSession().update(getNamespace() + getUpdateStatementId(), obj);
	}

	protected String getFindAllStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "findAll" + getDomainName() + "List";
	}
	
	protected String getFindbyfilterStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "find" + getDomainName() + "ListByFilter";
	}
	
	protected String getFindbyPageStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "find" + getDomainName() + "PageByFilter";
	}
	
	protected String getCountbyFilterStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "count" + getDomainName() + "ByFilter";
	}
	
	protected String getFindbyStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "find" + getDomainName() + "ById";
	}
	
	protected String getInsertStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "insert" + getDomainName();
	}
	
	protected String getDeleteStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "delete" + getDomainName() + "ById";
	}

	protected String getUpdateStatementId() {
		if (StringUtils.isEmpty(getDomainName())) {
			log.error("Currently no domain name specified in your ServiceImpl class which inherited from BaseServiceImpl");
			log.error("You have to implement method getDomainName() in order to execute sql");
		}
		return "update" + getDomainName() + "ById";
	}
	
	/**
     * 检测绑定
     * @param openId
     * @param publicId
     * @throws Exception
     */
	public OperatorMobile checkBinding(OperatorMobile obj) throws Exception {
		List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
		if(null != data && data.size() > 0 ){
			return data.get(0);
		}else{
			return new OperatorMobile();
		}
	}
	
    /**
     * 检测绑定
     * @param openId
     * @param publicId
     * @throws Exception
     */
	@Cacheable(value="wxCrmSerCache", key="#publicId + '_' + #openId + '_crmId'")
	public OperatorMobile checkBinding(String openId, String publicId) throws Exception {
		//空判断
		if(null == openId || "".equals(openId) 
				          || null == publicId
				          || "".equals(publicId)){
			return new OperatorMobile();
		}
		//查询用户绑定列表
		OperatorMobile s = new OperatorMobile();
		s.setOpenId(openId);
		s.setPublicId(publicId);
		//查询用户绑定表，默认为Default Organization
		s.setOrgId("Default Organization");
		List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", s);
		if(null != data && data.size() > 0 ){
			return data.get(0);
		}else{
			return new OperatorMobile();
		}
		
	}
	
	/**
	 * 检测绑定
	 * @param openId
	 * @param publicId
	 * @throws Exception
	 */
	public OperatorMobile checkBindByOrgId(String openId, String publicId, String orgId) throws Exception {
		//空判断
		if(null == openId || "".equals(openId) 
				|| null == publicId
				|| "".equals(publicId)
			    || null == orgId
			    || "".equals(orgId)){
			return new OperatorMobile();
		}
		//查询用户绑定列表
		OperatorMobile s = new OperatorMobile();
		s.setOpenId(openId);
		s.setPublicId(publicId);
		s.setOrgId(orgId);
		List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", s);
		if(null != data && data.size() > 0 ){
			return data.get(0);
		}else{
			return new OperatorMobile();
		}
		
	}
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public boolean JudgeBinding(String openId, String publicId) {
		OperatorMobile cb = new OperatorMobile();
		try {
			cb = checkBinding(openId, publicId);
		} catch (Exception e) {
			logger.info("checkBinding errormsg:-> is =" + e.getMessage());
		}
		String crmId = cb.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if(crmId != null && !"".equals(crmId)){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public String getCrmId(String openId, String publicId) {
		String cacheKey = "crmId_" + openId + "_" + publicId;
		//旧的crmId
		/*String oldCrmId = "";
		Object sObj = WxCrmCacheUtil.get(cacheKey);//从缓存中获取菜单访问该状态
		oldCrmId = (sObj == null) ? "" : (String)sObj; 
		logger.info("cacheCrmId rst before=>" + oldCrmId);
		if(!"".equals(oldCrmId)) return oldCrmId;*/
		//重新查询获取crmId
		OperatorMobile cb = new OperatorMobile();
		try {
			cb = checkBinding(openId, publicId);
		} catch (Exception e) {
			logger.info("checkBinding errormsg:-> is =" + e.getMessage());
		}
		String crmId = cb.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if(crmId != null && !"".equals(crmId)){
			EhcacheUtil.put(cacheKey, crmId);
			return crmId;
		}else{
			return "";
		}
	}
	
	/**
	 * 判断用户是否绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public String getCrmIdByOrgId(String openId, String publicId, String orgId) {
		String cacheKey = "crmId_" + openId + "_" + publicId + "_" + orgId;
		//旧的crmId
		/*String oldCrmId = "";
		Object sObj = WxCrmCacheUtil.get(cacheKey);//从缓存中获取菜单访问该状态
		oldCrmId = (sObj == null) ? "" : (String)sObj; 
		logger.info("cacheCrmId rst before=>" + oldCrmId);
		if(!"".equals(oldCrmId)) return oldCrmId;*/
		//重新查询获取crmId
		OperatorMobile cb = new OperatorMobile();
		try {
			cb = checkBindByOrgId(openId, publicId, orgId);
		} catch (Exception e) {
			logger.info("checkBinding errormsg:-> is =" + e.getMessage());
		}
		String crmId = cb.getCrmId();
		logger.info("crmId:-> is =" + crmId);
		if(crmId != null && !"".equals(crmId)){
			EhcacheUtil.put(cacheKey, crmId);
			return crmId;
		}else{
			return "";
		}
	}
	
	/**
	 * 通过openId 和 publicId 查询关联的所有crmId数据
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<String> getCrmIdArr(String openId, String publicId, String orgIdNot) {
		if(null == publicId || "".equals(publicId)){
			publicId = PropertiesUtil.getAppContext("app.publicId");
		}
		//空判断
		if(null == openId || "".equals(openId) 
				          || null == publicId
				          || "".equals(publicId)){
			return new ArrayList<String>();
		}
		//查询用户绑定列表
		try {
			OperatorMobile s = new OperatorMobile();
			s.setOpenId(openId);
			s.setPublicId(publicId);
			if(null != orgIdNot && !"".equals(orgIdNot)){
				s.setOrgIdNot(orgIdNot);
			}
			return getSqlSession().selectList("operatorMobileSql.finCrmIdListByOpenId", s);
		} catch (Exception e) {
			return new ArrayList<String>();
		}
	}
	
	/**
	 * 通过openId 和 publicId 查询关联的所有crmId数据
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<Organization> getCrmIdAndOrgIdArr(String openId, String publicId, String orgIdNot) {
		if(null == publicId || "".equals(publicId)){
			publicId = PropertiesUtil.getAppContext("app.publicId");
		}
		//空判断
		if(null == openId || "".equals(openId) 
				          || null == publicId
				          || "".equals(publicId)){
			return new ArrayList<Organization>();
		}
		//查询用户绑定列表
		try {
			OperatorMobile s = new OperatorMobile();
			s.setOpenId(openId);
			s.setPublicId(publicId);
			if(null != orgIdNot && !"".equals(orgIdNot)){
				s.setOrgIdNot(orgIdNot);
			}
			return getSqlSession().selectList("operatorMobileSql.finCrmIdAndOrgListByOpenId", s);
		} catch (Exception e) {
			return new ArrayList<Organization>();
		}
	}
	
	
	/**
	 * 得到用户是属于哪个组织的
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public String getOrgId(String openId,String publicId,String crmId) {
		String cacheKey = "orgId_"+openId+"_"+publicId+"_"+crmId;
		//旧的crmId
		String oldOrgId = "";
		Object sObj = EhcacheUtil.get(cacheKey);//从缓存中获取菜单访问该状态
		oldOrgId = (sObj == null) ? "" : (String)sObj; 
		logger.info("cacheCrmId rst before=>" + oldOrgId);
		if(!"".equals(oldOrgId)) return oldOrgId;
		//重新查询获取crmId
		OperatorMobile cb = new OperatorMobile();
		try {
			//查询用户绑定列表
			OperatorMobile obj = new OperatorMobile();
			obj.setCrmId(crmId);
			obj.setOpenId(openId);
			obj.setPublicId(publicId);
			List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
			if(null != data && data.size() > 0 ){
				cb = data.get(0);
			}
		} catch (Exception e) {
			logger.info("getOrgId errormsg:-> is =" + e.getMessage());
		}
		String orgId = cb.getOrgId();
		logger.info("orgId:-> is =" + orgId);
		if(orgId != null && !"".equals(orgId)){
			EhcacheUtil.put(cacheKey, orgId);
			return orgId;
		}else{
			return "";
		}
	}
	
	public String getOrgIdByCrmId(String crmId) {
		try {
			OperatorMobile obj = new OperatorMobile();
			obj.setCrmId(crmId);
			List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
			if(null != data && data.size() > 0 ){
				obj = data.get(0);
				return obj.getOrgId();
			}
		} catch (Exception e) {
			logger.info("getOrgId errormsg:-> is =" + e.getMessage());
		}
		return null;
	}
	public List<String> getAllCrmidsByCrmId(String crmId) {
		String openid = this.getOpenIdByCrmId(crmId);
		return getAllCrmidsByOpenId(openid);
	}
	public List<String> getAllCrmidsByOpenId(String openId) {
		List<String> retlist = new LinkedList<String>();
		try {
			//查询用户绑定列表
			OperatorMobile obj = new OperatorMobile();
			obj.setOpenId(openId);
			List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
			if(null != data && data.size() > 0 ){
				for(OperatorMobile om : data){
					retlist.add(om.getCrmId());	
				}
			}
		} catch (Exception e) {
			logger.info("getAllCrmidsByCrmId errormsg:-> is =" + e.getMessage());
		}
		return retlist;
	}

	
	public List<String> getOrgIdsByCrmId(String crmid) {
		return getOrgIds(getOpenIdByCrmId(crmid));
	}	
	public List<String> getOrgIds(String openId) {
		List<String> retlist = new LinkedList<String>();
		List<Organization> orgs = this.getCrmIdAndOrgIdArr(openId,null,null);
		if (orgs!=null)
		for(Organization org : orgs){
			retlist.add(org.getOrgId());
		}
		return retlist;
	}
	
	
	/**
	 * 跟进crmId 获得openId
	 * @param crmId
	 * @return
	 */
	public String getOpenIdByCrmId(String crmId){
		try {
			//查询用户绑定列表
			OperatorMobile obj = new OperatorMobile();
			obj.setCrmId(crmId);
			List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
			if(null != data && data.size() > 0 ){
				obj = data.get(0);
				return obj.getOpenId();
			}
		} catch (Exception e) {
			logger.info("getOrgId errormsg:-> is =" + e.getMessage());
		}
		return "";
	}

	/**
	 * 跟进orgid 获得openId
	 * @param orgId
	 * @return
	 */
	public List<String> getOpenIdByOrgId(String orgId){
		List<String> retlist = new LinkedList<String>();
		try {
			
			//查询用户绑定列表
			OperatorMobile obj = new OperatorMobile();
			obj.setOrgId(orgId);
			List<OperatorMobile> data = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", obj);
			if(null != data && data.size() > 0 ){
				for(OperatorMobile om : data){
					retlist.add(om.getOpenId());
				}
			}
		} catch (Exception e) {
			logger.info("getOrgId errormsg:-> is =" + e.getMessage());
		}
		return retlist;
	}

	/**
	 * 取消绑定
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public boolean cancelBinding(String openId, String publicId,String orgId) {
		// 空判断
		if (null == openId || "".equals(openId) || null == publicId
				|| "".equals(publicId)) {
			return false;
		}
		// 查询用户绑定列表
		OperatorMobile s = new OperatorMobile();
		s.setOpenId(openId);
		s.setPublicId(publicId);
		s.setOrgId(orgId);
		int result = getSqlSession().delete("operatorMobileSql.cancelBinding", s);
		if(result != -1){
			return true;
		}else{
			return false;
		}
	}
	
	/**
     * 查询 德成CRM用户 所拥有的功能菜单列表 
     * @param crmId
     * @throws Exception
     */
	@Cacheable(value="wxCrmSerCache", key="#crmId + '_UserFuncList'")
	public List<UserFunc> getDcUserFuncList(String crmId, String func, String fType){
		log.info("getDcUserFuncList method crmId =>" + crmId);
		//返回结果集
		List<UserFunc> rstList = new ArrayList<UserFunc>();
		try {
			//空判断
			if(null == crmId || "".equals(crmId)) return rstList;
			//查询用户绑定列表
			UserFunc s = new UserFunc();
			s.setCrmId(crmId);
			//设置其他 查询参数
			if(Constants.SEARCH_FUNC_TYPE_SUB.equals(fType)) s.setFunId(func);
			if(Constants.SEARCH_FUNC_TYPE_PARENT.equals(fType)) s.setFunParentId(func);
			//查询结果集
			rstList = getSqlSession().selectList("userFuncSql.findUserFuncListByFilter", s);
			log.info("getDcUserFuncList list =>" + rstList.size());
		} catch (Exception e) {
			log.info("getDcUserFuncList errormsg =>" + e.getMessage());
		}
		return rstList;
	}
	
    /**
     * 查询 德成CRM用户 所拥有的功能菜单列表 
     * @param crmId
     * @param func
     * @throws Exception
     */
	@SuppressWarnings("rawtypes")
	public boolean checkFunc(String crmId, String func)  {
		log.info("checkFunc method crmId =>" + crmId);
		log.info("checkFunc method func =>" + func);
		//空判断
		if(null == func || null == crmId
				        || "".equals(func)
				        || "".equals(crmId)){
			return false;
		}
		//遍历功能列表判断该德成CRM用户是否拥有某项权限
		UserFunc param = new UserFunc();
		param.setFunId(func);
		List<UserFunc> funList = getDcUserFuncList(crmId, func, Constants.SEARCH_FUNC_TYPE_SUB);
		for (
		Iterator iterator = funList.iterator(); iterator.hasNext();) {
			UserFunc userFunc = (UserFunc) iterator.next();
			String funId = userFunc.getFunId();
			if(funId.equals(func)){
				return true;
			}
		}
		return false;
	}
	
	
	
	public List<SugarRequest> callSugar(List<SugarRequest> erq,Class<?> classz){
		List<String> jsonStrArry = new LinkedList<String>();
		for (SugarRequest er : erq) {
			try{
				String jsonStr = JSONObject.fromObject(er).toString();
				jsonStrArry.add(jsonStr);
			}catch(Exception ec){
				log.error(ec);
			}
		}
		List<String> rstArry = ServiceUtils.getCRMService().getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArry, Constants.INVOKE_MULITY);
		List<SugarRequest> rstlist = new ArrayList<SugarRequest>();
		for(String rst : rstArry){
			try{
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						rstlist = (List<SugarRequest>) JSONArray.toCollection(jsonObject.getJSONArray("expenses"),classz);
					}
				}
			}catch(Exception ec){
				log.error(ec);
			}
		}
		return rstlist;
	}
	public  List<SugarRequest> callSugar(SugarRequest er,Class<?> classz){
		List<SugarRequest> ers = new ArrayList<SugarRequest>();
		ers.add(er);
		return callSugar(ers,classz);
	}
	public  List<SugarRequest> callAllSugar(SugarRequest er,List<String> orgIds,Class<?> classz) throws Exception{
		List<SugarRequest> ers = new ArrayList<SugarRequest>();
		for(String orgId :orgIds){
			SugarRequest newer = er.getClass().newInstance();
			BeanUtils.copyProperties(er, newer);
			newer.setOrgId(orgId);
			ers.add(newer);
		}
		return callSugar(ers,classz);
	}
}
