package com.takshine.wxcrm.service.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SocialUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.SocialContact;
import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactReq;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.Contact2SugarService;

/**
 * 联系人   相关业务接口实现
 *
 * @author liulin
 */
@Service("contact2SugarService")
public class Contact2SugarServiceImpl extends BaseServiceImpl implements Contact2SugarService {
	
	private static Logger log = Logger.getLogger(Contact2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 保存联系人关系信息
	 * @param obj
	 * @return
	 */
	public CrmError saveContact(Contact obj){
		CrmError crmErr = new CrmError();
		log.info("saveContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_ADDRELA);
		sa.setParentid(obj.getParentId());//关联ID
		sa.setParenttype(obj.getParentType());//关联的名称
		sa.setAdapting(obj.getAdapting());
		sa.setPlight(obj.getPlight());
		sa.setRoles(obj.getRoles());
		sa.setRowid(obj.getRowid());
		sa.setOrgId(obj.getOrgId());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("saveContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("saveContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("saveContact errcode => errcode is : " + errcode);
			log.info("saveContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 保存联系人信息
	 * @param obj
	 * @return
	 */
	public CrmError addContact(Contact obj){
		CrmError crmErr = new CrmError();
		log.info("addContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_ADD);
		sa.setSalutation(obj.getSalutation());//称谓
		sa.setConname(obj.getConname());//姓名
		sa.setEmail(obj.getEmail0());//邮箱
		sa.setEmail0(obj.getEmail0());//邮箱
		sa.setConaddress(obj.getConaddress());//地址
		sa.setConjob(obj.getConjob());//职位
		sa.setPhonemobile(obj.getPhonemobile());//移动电话
		sa.setPhonework(obj.getPhonework());//办公电话
		sa.setParentid(obj.getParentId());//关联ID
		sa.setParentname(obj.getParentType());//关联类型
		sa.setParenttype(obj.getParentType());//关联的名称
		sa.setDepartment(obj.getDepartment());//部门
		sa.setAssigner(obj.getAssigner());//责任人
		sa.setAssignerId(obj.getAssignerId());//责任人ID
		sa.setFilename(obj.getFilename());//图片名称
		sa.setTimefre(obj.getTimefre());//联系人频率
		sa.setOrgId(obj.getOrgId());
		sa.setBirthdate(obj.getBirthdate());
		sa.setBatchno(obj.getBatchno());
		sa.setCompanyname(obj.getCompanyname());
		sa.setAccountid(obj.getAccountid());
		sa.setAccountname(obj.getAccountname());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContact errcode => errcode is : " + errcode);
			log.info("addContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");// 记录ID
				log.info("addContact rowid => rowId is : " + rowId);
				crmErr.setRowId(rowId);
				
				try {
					//同步到缓存
					CacheContact cache = cRMService.getDbService().getCacheContactService().transf(obj.getOrgId(), sa);
					cache.setRowid(rowId);
					cRMService.getDbService().getCacheContactService().addObj(cache);
				} catch (Exception e) {
					log.info("cache error = >" + e.getMessage());
				}
			}
		}
		return crmErr;
	}
	public Map<String, CrmError> addContact(Map<String, Contact> map) {
		final Map<String, CrmError> retmap = new HashMap<String, CrmError>();
		
		for(final String key : map.keySet()){
			final Contact contact = map.get(key);
			new Thread(){
				public void run(){
					try{
						CrmError crmerror = addContact(contact);
						retmap.put(key, crmerror);
					}catch(Exception ec){
						retmap.put(key, null);
					}
				}
			}.start();
		}
		while(retmap.size() < map.size()){
			try {
				Thread.sleep(100);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return retmap;
	}

	/**
	 * 查询 单个联系人
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	@SuppressWarnings("unchecked")
	public ContactResp getContactSingle(String rowId, String crmId) throws Exception{
		CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(rowId);
		log.info("newCrmId = >" + cacheContact.getCrm_id());
		
		//业务机会响应
	    ContactResp resp = new ContactResp();
		resp.setCrmaccount(crmId);//crm id
		resp.setModeltype(Constants.MODEL_TYPE_CONTACT);
		//业务机会请求
		ContactReq single = new ContactReq();
		single.setCrmaccount(crmId);//sugar id
		single.setOrgId(cacheContact.getOrg_id());
		single.setModeltype(Constants.MODEL_TYPE_CONTACT);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowId);
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getContactList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getContactList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.trim().indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			if(StringUtils.isNotNullOrEmptyStr(jsonObject.getString("contacts"))){
				List<ContactAdd> clist = new ArrayList<ContactAdd>();
				//联系人跟进
				JSONArray jarr = jsonObject.getJSONArray("contacts");
				for (int i = 0; i < jarr.size(); i++) {
					ContactAdd cr = new ContactAdd();
					JSONObject jobj = (JSONObject) jarr.get(i);
					cr.setRowid(jobj.getString("rowid"));
					cr.setConname(jobj.getString("conname"));
					cr.setSalutation(jobj.getString("salutation"));
					cr.setConjob(jobj.getString("conjob"));
					cr.setDepartment(jobj.getString("department"));
					cr.setPhonework(jobj.getString("phonework"));
					cr.setPhonemobile(jobj.getString("phonemobile"));
					cr.setConaddress(jobj.getString("conaddress"));
					cr.setEmail0(jobj.getString("email0"));
					cr.setAssigner(jobj.getString("assigner"));
					cr.setAssignerId(jobj.getString("assignerId"));
					cr.setCreater(jobj.getString("creater"));
					cr.setCreatedate(jobj.getString("createdate"));
					cr.setModifier(jobj.getString("modifier"));
					cr.setModifydate(jobj.getString("modifydate"));
					cr.setDesc(jobj.getString("desc"));
					cr.setFilename(jobj.getString("filename"));
					cr.setTimefre(jobj.getString("timefre"));
					cr.setTimefrename(jobj.getString("timefrename"));
					cr.setAuthority(jobj.getString("authority"));
					cr.setBirthdate(jobj.getString("birthdate"));
					cr.setOrgId(cacheContact.getOrg_id());
					cr.setParentname(jobj.getString("parentname"));
					cr.setParentid(jobj.getString("parentid"));
					cr.setParenttype(jobj.getString("parenttype"));
				
					if("女士".equals(cr.getSalutation())||"小姐".equals(cr.getSalutation())){
						cr.setSalutation("Mrs.");
					}
					if("先生".equals(cr.getSalutation())){
						cr.setSalutation("Mr.");
					}
					//联系人跟进
					if(null != jobj.getString("audits") && !"".equals(jobj.getString("audits"))){
						List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), OpptyAuditsAdd.class);
						cr.setAudits(auditsList);
					}

					clist.add(cr);
				}
				
				
				resp.setContacts(clist);//列表
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContactList errcode => errcode is : " + errcode);
			log.info("getContactList errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}

	/**
	 * 根据parentId查询联系人列表
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	@SuppressWarnings("unchecked")
	public ContactResp getContactList(Contact con, String source) throws Exception {
		//联系人响应
		ContactResp resp = new ContactResp();
		resp.setCrmaccount(con.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_CONTACT);//联系人
		resp.setViewtype(con.getViewtype());//视图类型
		//联系人请求
		ContactReq req = new ContactReq();
		req.setCrmaccount(con.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_CONTACT);
		req.setType(Constants.ACTION_SEARCHPID);//执行的是查询所有的操作
		req.setPagecount(con.getPagecount());
		req.setCurrpage(con.getCurrpage());
		req.setParentId(con.getParentId());//关联ID
		req.setParentType(con.getParentType());//关联类型
		req.setFlag(con.getFlag());
		req.setOrgId(con.getOrgId());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getContactList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getContactList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<ContactAdd> list = (List<ContactAdd>)JSONArray.toCollection(jsonObject.getJSONArray("contacts"),ContactAdd.class);
				List<ContactAdd> clist = new ArrayList<ContactAdd>();
				for(ContactAdd contact:list){
					ContactAdd contactAdd  = new ContactAdd();

					BeanUtils.copyProperties(contactAdd, contact);
					if(SocialUtil.IS_OPEN_SOCIAL==1){
						String rowId = contact.getRowid();
						SocialContact socialContact1 = (SocialContact)cRMService.getDbService().getSocialContactService().findObjById(rowId);
						if(socialContact1!=null){
							String uid = socialContact1.getUid();
							String accesstoken = socialContact1.getAccess_token();
							if(StringUtils.isNotNullOrEmptyStr(uid)&&StringUtils.isNotNullOrEmptyStr(accesstoken)){
								SocialUserInfo wbuser = SocialUtil.getWBUserInfo(accesstoken,uid);
								if(!StringUtils.isNotNullOrEmptyStr(list.get(0).getFilename())&&StringUtils.isNotNullOrEmptyStr(wbuser.getHeadimgurl())){
									contactAdd.setFilename(wbuser.getHeadimgurl());
									contactAdd.setIswbuser("ok");
								}
							}
						}
					}
					if(contact.getFilename().contains("http:")){
						contactAdd.setIswbuser("ok");
					}
					
					contactAdd.setOrgId(con.getOrgId());
					clist.add(contactAdd);
				}
				resp.setContacts(clist);//联系人列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContactList errcode => errcode is : "+errcode);
			log.info("getContactList errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	/**
	 * 查询联系人列表
	 */
	public ContactResp getContactClist(Contact con, String source) throws Exception{
		//联系人响应
		ContactResp resp = new ContactResp();
		resp.setCrmaccount(con.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_CONTACT);//联系人
		resp.setViewtype(con.getViewtype());//视图类型
		//联系人请求
		ContactReq req = new ContactReq();
		req.setCrmaccount(con.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_CONTACT);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(con.getPagecount());
		req.setCurrpage(con.getCurrpage());
		req.setViewtype(con.getViewtype());
		req.setTimefre(con.getTimefre());
		req.setAssignerId(con.getAssignerId());
		req.setDatetime(con.getDatetime());
		req.setFirstchar(con.getFirstchar());
		req.setConnname(con.getConname());
		req.setPhonemobile(con.getPhonemobile());
		req.setOrderString(con.getOrderByString());
		req.setOrgId(con.getOrgId());
		//转换为json
		/*String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getContactClist jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getContactClist rst => is : "+rst);*/
		
		String viewtype = req.getViewtype();
		log.info("viewtype => " + viewtype);
		if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(viewtype)){//团队的 下属的
			//List<Organization> crmIds = getCrmIdAndOrgIdArr(con.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
			//log.info("crmIds size = >" + crmIds.size());
			
			List<String> rstuid = new ArrayList<String>();
			List<CacheContact> cachelist = new ArrayList<CacheContact>();
			
//			for (int i = 0; i < crmIds.size(); i++) {
//				String crmid = crmIds.get(i).getCrmId();
//				log.info("crmid = >" + crmid);
//				
//				UserReq uReq  = new UserReq();
//				uReq.setCrmaccount(crmid);
//				uReq.setCurrpage("1");
//				uReq.setPagecount("9999");
//				uReq.setFlag("");
//				uReq.setOpenId(con.getOpenId());
//				uReq.setOrgUrl(crmIds.get(i).getCrmurl());
//				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
//					List<UserAdd> ulist = uResp.getUsers();
//					if(null != ulist && ulist.size()>0){
//						for (int j = 0; j < ulist.size(); j++) {
//							UserAdd ua = ulist.get(j);
//							String uid = ua.getUserid();
//							log.info("uid = >" + uid);
//							rstuid.add(uid);
//						}
//					}
//			}
			
			//在lovuser service中，已经根据id进行循环，此外不需要再循环了
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(req.getCrmaccount());
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			uReq.setFlag("");
			uReq.setOpenId(con.getOpenId());
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			List<UserAdd> ulist = uResp.getUsers();
			if(null != ulist && ulist.size()>0){
				for (int j = 0; j < ulist.size(); j++) {
					UserAdd ua = ulist.get(j);
					String uid = ua.getUserid();
					log.info("uid = >" + uid);
					rstuid.add(uid);
				}
			}
			
			if(rstuid.size() > 0){
				CacheContact csear = new CacheContact();
				csear.setCrm_id_in(rstuid);
				csear.setMobile(req.getPhonemobile());
				csear.setName(req.getConnname());
				csear.setOrderByString(req.getOrderString());
				cachelist = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ContactAdd> rstlist = new ArrayList<ContactAdd>();
			for (CacheContact cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContactService().invstransf(cacheCustomer));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContacts(rstlist);
			return resp;
		}
		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(viewtype)){//共享的 我参与的
			List<Organization> crmIds = getCrmIdAndOrgIdArr(con.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				log.info("crmid = >" + crmid);
				
				Share sc = new Share();
				sc.setCrmId(crmid);
				sc.setParenttype("Contacts");
				sc.setOrgUrl(crmIds.get(i).getCrmurl());
				ShareResp scResp = cRMService.getSugarService().getShare2SugarService().getShareRecordList(sc);
				List<ShareAdd> respList = scResp.getShares();
				for (int j = 0; j < respList.size(); j++) {
					ShareAdd sa = respList.get(j);
					String rowid = sa.getParentid();
					log.info("rowid = >" + rowid);
					rstuid.add(rowid);
				}
			}
			
			TeamPeason team = new TeamPeason();
			team.setOpenId(con.getOpenId());
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(team);
			for(TeamPeason teampeoson : list){
				String rowid = teampeoson.getRelaId();
				log.info("rowid = >" + rowid);
				rstuid.add(rowid);
			}
			
			List<CacheContact> cachelist = new ArrayList<CacheContact>();
			if(rstuid.size() > 0){
				CacheContact csear = new CacheContact();
				csear.setRowid_in(rstuid);
				csear.setCurrpage(new Integer(0));
				csear.setPagecount(new Integer(999));
				csear.setMobile(req.getPhonemobile());
				csear.setName(req.getConnname());
				csear.setOrderByString(req.getOrderString());
				cachelist = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findObjListByFilter(csear);
			}
			log.info("cachelist = > " + cachelist.size());
			
			List<ContactAdd> rstlist = new ArrayList<ContactAdd>();
			for (CacheContact cacheCustomer : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContactService().invstransf(cacheCustomer));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContacts(rstlist);
			return resp;
			
		}else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(viewtype) //myallview 我的所有的 
				|| Constants.SEARCH_VIEW_TYPE_NOTICEVIEW.equals(viewtype)){  //noteice view 循环查询后台 查询所有的数据 到前台
			List<Organization> crmIds = getCrmIdAndOrgIdArr(con.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
			log.info("crmIds size = >" + crmIds.size());
			List<String> rstuid = new ArrayList<String>();
			
			
			List<String> jsonArray = new LinkedList<String>();
			for (int i = 0; i < crmIds.size(); i++) {
				String crmid = crmIds.get(i).getCrmId();
				if(StringUtils.isNotNullOrEmptyStr(con.getOrgId())&&!con.getOrgId().equals(crmIds.get(i).getOrgId())){
					continue;
				}
				log.info("crmid = >" + crmid);
				req.setCrmaccount(crmid);
				req.setCurrpage("1");
				req.setPagecount("99999");
				req.setOrgUrl(crmIds.get(i).getCrmurl());
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
				jsonArray.add(jsonStr);
			}

			// 单次调用sugar接口
			List<String> rstAray = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonArray, Constants.INVOKE_MULITY);
			List<ContactAdd> retlist = new LinkedList<ContactAdd>();
			for(String rst : rstAray){
				try{
					log.info("getCustomerList rst => rst is : " + rst);
					JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
					if (!jsonObject.containsKey("errcode")) {
						// 错误代码和消息
						String count = jsonObject.getString("count");
						if (!"".equals(count) && Integer.parseInt(count) > 0) {
							List<ContactAdd> list = (List<ContactAdd>) JSONArray.toCollection(jsonObject.getJSONArray("contacts"),ContactAdd.class);
							/*for(ContactAdd contactAdd : list){
								rstuid.add(contactAdd.getRowid());
							}*/
							retlist.addAll(list);
						}
					}
				}catch(Exception ec){
					
				}
			}

			
		/*	List<CacheContact> cachelist = new ArrayList<CacheContact>();
			if(rstuid.size() > 0){
				CacheContact csear = new CacheContact();
				csear.setRowid_in(rstuid);
				csear.setMobile(req.getPhonemobile());
				csear.setName(req.getConnname());
				csear.setOrderByString(req.getOrderString());
				csear.setCurrpage(( new Integer(con.getCurrpage()) - 1 ) * new Integer(con.getPagecount()) );
				csear.setPagecount(new Integer(con.getPagecount()));
				cachelist = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findObjListByFilter(csear);
			}
			
			List<ContactAdd> rstlist = new ArrayList<ContactAdd>();
			for (CacheContact cacheContact : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContactService().invstransf(cacheContact));
			}
			*/
			log.info("cachelist = > " + retlist.size());
			resp.setCount(String.valueOf(retlist.size()));// 数字
			resp.setContacts(retlist);
			return resp;
			
		}
		//通讯录自动分组
		else if(Constants.SEARCH_VIEW_TYPE_BOOKSVIEW.equals(viewtype)){
			req.setContype(con.getContype());
			req.setContype_val(con.getContype_val());
			//查多个账户
			List<Organization> crmIds = getCrmIdAndOrgIdArr(con.getOpenId(), PropertiesUtil.getAppContext("app.publicId"),null);
			log.info("crmIds size = >" + crmIds.size());
			List<ContactAdd> retlist = new ArrayList<ContactAdd>();
			List<String> jsonStrArray = new ArrayList<String>();
			Map<String,Organization> tempOrganizations = new HashMap<String,Organization>();
			for (Organization  org : crmIds) {
				String crmid = org.getCrmId();
				if(StringUtils.isNotNullOrEmptyStr(con.getOrgId())&&!con.getOrgId().equals(con.getOrgId())){
					continue;
				}
				log.info("crmid = >" + crmid);
				req.setCrmaccount(crmid);
				req.setCurrpage("1");
				req.setPagecount("99999");
				req.setOrgUrl(org.getCrmurl());
				String jsonStr = JSONObject.fromObject(req).toString();
				log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
				jsonStrArray.add(jsonStr);
				tempOrganizations.put(crmid, org);
			}
			// 单次调用sugar接口
			List<String> rstArray = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStrArray, Constants.INVOKE_MULITY);
			for(String rst : rstArray){
				log.info("getCustomerList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					String count = jsonObject.getString("count");
					if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<ContactAdd> list = (List<ContactAdd>) JSONArray.toCollection(jsonObject.getJSONArray("contacts"),ContactAdd.class);
						if(null != list){
							for(ContactAdd ca : list){
								String crmid = jsonObject.getString("crmaccount");
								Organization org = tempOrganizations.get(crmid);
								ca.setOrgId(org.getOrgId());
								//""  判断, 为“”时 分组是空的 需要排除
								if(!"".equals(ca.getParentname())){
									retlist.add(ca);
								}
							}
						}
					}
				}
			}
			
			resp.setContacts(retlist);
			return resp;
		}
		else{
			//查询缓存表
			CacheContact csear = new CacheContact();
			csear.setCrm_id(req.getCrmaccount());
			csear.setMobile(req.getPhonemobile());
			csear.setName(req.getConnname());
			csear.setTagtype(con.getTagtype());
			if(StringUtils.isNotNullOrEmptyStr(req.getOrgId())){
				csear.setOrg_id(req.getOrgId());
			}
			csear.setOrderByString(req.getOrderString());
			List<CacheContact> cachelist = (List<CacheContact>)cRMService.getDbService().getCacheContactService().findCacheContactListByCrmId(csear);
			log.info("cachelist = > " + cachelist.size());
			List<ContactAdd> rstlist = new ArrayList<ContactAdd>();
			for (CacheContact cacheContact : cachelist) {
				rstlist.add(cRMService.getDbService().getCacheContactService().invstransf(cacheContact));
			}
			resp.setCount(String.valueOf(rstlist.size()));// 数字
			resp.setContacts(rstlist);
			return resp;
		}
		
		/*JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<ContactAdd> list = (List<ContactAdd>)JSONArray.toCollection(jsonObject.getJSONArray("contacts"),ContactAdd.class);
				List<ContactAdd> clist = new ArrayList<ContactAdd>();
				for(ContactAdd contact:list){
					ContactAdd contactAdd  = new ContactAdd();
					BeanUtils.copyProperties(contactAdd, contact);
					if(SocialUtil.IS_OPEN_SOCIAL==1){
						String rowId = contact.getRowid();
						SocialContact socialContact1 = (SocialContact)socialContactService.findObjById(rowId);
						if(socialContact1!=null){
							String uid = socialContact1.getUid();
							String accesstoken = socialContact1.getAccess_token();
							if(StringUtils.isNotNullOrEmptyStr(uid)&&StringUtils.isNotNullOrEmptyStr(accesstoken)){
								SocialUserInfo wbuser = SocialUtil.getWBUserInfo(accesstoken,uid);
								if(!StringUtils.isNotNullOrEmptyStr(contact.getFilename())&&StringUtils.isNotNullOrEmptyStr(wbuser.getHeadimgurl())){
									contactAdd.setFilename(wbuser.getHeadimgurl());
									contactAdd.setIswbuser("ok");
								}
							}
						}
					}
					if(contact.getFilename().contains("http:")){
						contactAdd.setIswbuser("ok");
					}
					clist.add(contactAdd);
				}
				resp.setContacts(clist);//联系人列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContactClist errcode => errcode is : "+errcode);
			log.info("getContactClist errmsg => errmsg is : "+errmsg);
		}
		return resp;
		*/
	}

	/**
	 * 手工分组查询
	 * @return
	 * @throws Exception
	 */
	public List<Tag> getHandGroupList(Contact con) {
		ContactReq req = new ContactReq();
		req.setCrmaccount(con.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_CONTACT);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(con.getPagecount());
		req.setCurrpage(con.getCurrpage());
		req.setViewtype(con.getViewtype());
		req.setTimefre(con.getTimefre());
		req.setAssignerId(con.getAssignerId());
		req.setDatetime(con.getDatetime());
		req.setFirstchar(con.getFirstchar());
		req.setConnname(con.getConname());
		req.setPhonemobile(con.getPhonemobile());
		req.setOrderString(con.getOrderByString());
		
		List<Organization> crmIds = getCrmIdAndOrgIdArr(con.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<String> rstuid = new ArrayList<String>();
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i).getCrmId();
			if(StringUtils.isNotNullOrEmptyStr(con.getOrgId())&&!crmid.equals(req.getCrmaccount())){
				continue;
			}
			log.info("crmid = >" + crmid);
			req.setCrmaccount(crmid);
			req.setCurrpage("1");
			req.setPagecount("99999");
			req.setOrgUrl(crmIds.get(i).getCrmurl());
			String jsonStr = JSONObject.fromObject(req).toString();
			log.info("getCustomerList jsonStr => jsonStr is : " + jsonStr);
			// 单次调用sugar接口
			String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
			log.info("getCustomerList rst => rst is : " + rst);
			JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
			if (!jsonObject.containsKey("errcode")) {
				// 错误代码和消息
				String count = jsonObject.getString("count");
				if (!"".equals(count) && Integer.parseInt(count) > 0) {
					List<ContactAdd> list = (List<ContactAdd>) JSONArray.toCollection(jsonObject.getJSONArray("contacts"),ContactAdd.class);
					for(ContactAdd contactAdd : list){
						rstuid.add(contactAdd.getRowid());
					}
				}
			}
		}
		List<Tag> cachelist = new ArrayList<Tag>();
		if(rstuid.size() > 0){
			CacheContact csear = new CacheContact();
			csear.setRowid_in(rstuid);
			csear.setMobile(req.getPhonemobile());
			csear.setName(req.getConnname());
			csear.setOrderByString(req.getOrderString());
			cachelist = (List<Tag>)cRMService.getDbService().getCacheContactService().findHandGroupCacheContactListByFilter(csear);
			log.info("cachelist = >" + cachelist);
			return cachelist;
		}
		return null;
	}
	
	public CrmError updateContactById(Contact obj) {
		CrmError crmErr = new CrmError();
		log.info("addContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(obj.getRowid());
		sa.setAdapting(obj.getAdapting());
		sa.setPlight(obj.getPlight());
		sa.setParentid(obj.getParentId());
		sa.setParenttype(obj.getParentType());
		sa.setRoles(obj.getRoles());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContact errcode => errcode is : " + errcode);
			log.info("addContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 删除联系人
	 * @param obj
	 * @return
	 */
	public CrmError delContact(Contact obj){
		CrmError crmErr = new CrmError();
		log.info("delContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_DELETE);
		sa.setParentid(obj.getParentId());//关联ID
		sa.setParenttype(obj.getParentType());//关联的名称
		sa.setRowid(obj.getRowid());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("delContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("delContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("delContact errcode => errcode is : " + errcode);
			log.info("delContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}

	/**
	 * 修改联系人并保存联系人
	 */
	public CrmError updateContact(Contact con) {
		CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(con.getRowid());
		log.info("newCrmId = >" + cacheContact.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("updateContact start => con is : " + con);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(con.getCrmId());
		sa.setOrgId(cacheContact.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setConname(con.getConname());
		sa.setSalutation(con.getSalutation());
		sa.setConjob(con.getConjob());
		sa.setPhonemobile(con.getPhonemobile());
		sa.setPhonework(con.getPhonework());
		sa.setConaddress(con.getConaddress());
		sa.setEmail0(con.getEmail0());
		sa.setDepartment(con.getDepartment());
		sa.setRowid(con.getRowid());
		sa.setDesc(con.getDesc());
		sa.setTimefre(con.getTimefre());
		sa.setTimefrename(con.getTimefrename());
		sa.setFilename(con.getFilename());
		sa.setAssignerId(con.getAssignerId());
		sa.setEmail(con.getEmail0());
		sa.setBirthdate(con.getBirthdate());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("updateContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateContact errcode => errcode is : " + errcode);
			log.info("updateContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		
		try {
			//同步到缓存
			CacheContact cache = cRMService.getDbService().getCacheContactService().transf(null, sa);
			cRMService.getDbService().getCacheContactService().updateObj(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		return crmErr;
	}
	
	/**
	 * 查找联系人关系
	 */
	public ContactResp getContactRelation(Contact con) {
		// 联系人响应
		ContactResp resp = new ContactResp();
		resp.setCrmaccount(con.getCrmId());// crmId
		resp.setModeltype(Constants.MODEL_TYPE_CONTACT);// 联系人
		// 联系人请求
		ContactReq req = new ContactReq();
		req.setCrmaccount(con.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_CONTACT);
		req.setType(Constants.ACTION_RELA);// 执行的是查询所有的操作
		req.setRowid(con.getRowid());
		// 转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getContactClist jsonStr => is : " + jsonStr);
		// 多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getContactClist rst => is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
				// 把json对象转换成list集合
				List<ContactAdd> list = (List<ContactAdd>) JSONArray.toCollection(jsonObject.getJSONArray("contacts"), ContactAdd.class);
				resp.setContacts(list);// 联系人列表
			}
			// 记录条数
			resp.setCount(count);
		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContactClist errcode => errcode is : " + errcode);
			log.info("getContactClist errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}

	
	/**
	 * 添加联系人关系
	 */
	public CrmError addContactRelation(Contact obj) {
		CrmError crmErr = new CrmError();
		log.info("addContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_ADDEFFECT);
		sa.setRelaid(obj.getRelaid());
		sa.setRowid(obj.getRowid());
		sa.setEffect(obj.getEffect());
		sa.setRelation(obj.getRelation());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContact errcode => errcode is : " + errcode);
			log.info("addContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");// 记录ID
				log.info("addContact rowid => rowId is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

	
	/**
	 * 修改影响力
	 */
	public CrmError updateContectEffect(Contact obj) {
		CrmError crmErr = new CrmError();
		log.info("addContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_UPDEFFECT);
		sa.setRelaid(obj.getRelaid());
		sa.setRowid(obj.getRowid());
		sa.setEffect(obj.getEffect());
		sa.setRelation(obj.getRelation());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContact errcode => errcode is : " + errcode);
			log.info("addContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}

	
	/**
	 * 删除影响力
	 */
	public CrmError deleteContactEffect(Contact obj) {
		CrmError crmErr = new CrmError();
		log.info("addContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_CONTACT);
		sa.setType(Constants.ACTION_DELEFFECT);
		sa.setRelaid(obj.getRelaid());
		sa.setRowid(obj.getRowid());
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addContact errcode => errcode is : " + errcode);
			log.info("addContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}

	/**
	 * 删除联系人
	 */
	public CrmError deleteContact(Contact obj) {
		CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(obj.getRowid());
		log.info("newCrmId = >" + cacheContact.getCrm_id());
		
		CrmError crmErr = new CrmError();
		log.info("delContact start => obj is : " + obj);
		ContactAdd sa = new ContactAdd();
		sa.setCrmaccount(cacheContact.getCrm_id());
		sa.setOrgId(cacheContact.getOrg_id());
		sa.setModeltype(Constants.MODEL_TYPE_ACCNT);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(obj.getRowid());
		sa.setOptype(obj.getOptype());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("deleteContact jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("deleteContact rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("delContact errcode => errcode is : " + errcode);
			log.info("delContact errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		try {
			//同步到缓存
			CacheOppty cache = new CacheOppty();
			cache.setRowid(obj.getRowid());
			cache.setEnabled_flag("disabled");
			cRMService.getDbService().getCacheContactService().updateEnabledFlag(cache);
		} catch (Exception e) {
			log.info("cache error = >" + e.getMessage());
		}
		return crmErr;
	}

}
