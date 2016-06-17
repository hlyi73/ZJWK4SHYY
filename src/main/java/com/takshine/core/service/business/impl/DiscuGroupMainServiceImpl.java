package com.takshine.core.service.business.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.DiscuGroupMainService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupExam;
import com.takshine.wxcrm.domain.DiscuGroupNotice;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.message.error.CrmError;

/**
 * 讨论组主服务
 * @author liulin
 *
 */
@Service("discuGroupMainService")
public class DiscuGroupMainServiceImpl implements DiscuGroupMainService {
	//日志
	protected static Logger log = Logger.getLogger(DiscuGroupMainServiceImpl.class.getName());
	
	//ehcache 缓存键
	protected static final String  EHCACHE_DISCU_USERS_ = "EHCACHE_DISCU_USERS_";
	protected static final String  EHCACHE_DISCU_NOTICES_ = "EHCACHE_DISCU_NOTICES_";
	protected static final String  EHCACHE_DISCU_EXAMS_ = "EHCACHE_DISCU_EXAMS_";
	protected static final String  EHCACHE_DISCU_ADMIN_USERS_ = "EHCACHE_DISCU_ADMIN_USERS_";
	protected static final String  EHCACHE_DISCU_ADMIN_RELA_USERS_ = "EHCACHE_DISCU_ADMIN_RELA_USERS_";
	protected static final String  EHCACHE_DISCU_ = "EHCACHE_DISCU_";
	protected static final String  EHCACHE_TAG_MODEL_ = "EHCACHE_TAG_MODEL_";
	
	//msg类型
	protected static final String  MSGTYPE_DISCUGROUP_APPLYMASS = "Discugroup_ApplyMass";//申请加群
	protected static final String  MSGTYPE_DISCUGROUP_MASS = "Discugroup_Mass";//加群成功
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 获取组织列表
	 * @param id 讨论组id
	 * @return DiscuGroup 讨论组基本信息对象
	 */
	public Map<String, String> getOrgList(String openId){
		Map<String, String> accMap = new HashMap<String,String>();
		try {
			OperatorMobile om = new OperatorMobile();
			om.setOpenId(openId);
			List<OperatorMobile> orgList = cRMService.getDbService().getOperatorMobileService().getOrgList(om);
			if(null != orgList && orgList.size() >0){
				for(int i=0;i<orgList.size();i++){
					accMap.put(orgList.get(i).getOrgId(), orgList.get(i).getOrgName());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return accMap;
	}
	
	/**
	 * 处理消息设置为已读
	 * @param targetUserId 目标用户的id
	 * @param relaId 关联的实体id
	 */
	public void handlerMesssageFlag(String targetUserId, String relaId){
		try {
			Messages msg = new Messages();
			msg.setTargetUId(targetUserId);
			msg.setRelaId(relaId);
			cRMService.getDbService().getMessagesService().updateMessagesFlag(msg);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 根据讨论组id查询讨论组基本信息
	 * @param id 讨论组id
	 * @return DiscuGroup 讨论组基本信息对象
	 */
	public DiscuGroup getDiscuGroupById(String id){
		if(StringUtils.isNotBlank(id)){
			/*Object caobj = EhcacheUtil.get(EHCACHE_DISCU_ + id);
			if(caobj != null){
				return (DiscuGroup)caobj;
			}*/
			DiscuGroup dg = new DiscuGroup();
			dg.setId(id);
			Object obj = cRMService.getDbService().getDiscuGroupService().findObj(dg);//查询讨论组
			if(obj != null){
				DiscuGroup discuGroup = (DiscuGroup)obj;
				//放入缓存
				EhcacheUtil.put(EHCACHE_DISCU_ + id, discuGroup);
				return discuGroup;
			}
		}
		return new DiscuGroup();
	}
	
	/**
	 * 查询讨论组下所有的用户列表
	 * @param disId 讨论组id
	 * @return List<DiscuGroupUser> 讨论组中的所有用户列表
	 */
	@SuppressWarnings("unchecked")
	public List<DiscuGroupUser> getDiscuGroupUsers(String disId){
		log.info("getDiscuGroupUsers begin = >");
		/*Object obj = EhcacheUtil.get(EHCACHE_DISCU_USERS_ + disId);
		if(obj != null){
			return (List<DiscuGroupUser>)obj;
		}*/
		//讨论组成员信息
		DiscuGroupUser dgu = new DiscuGroupUser();
		dgu.setDis_id(disId);
		dgu.setCurrpages(new Integer(0));
		dgu.setPagecounts(new Integer(9999));
		List<DiscuGroupUser> dguList = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupUserService().findObjListByFilter(dgu);
		log.info("dguList size = >" + dguList.size());
		//放入缓存
		EhcacheUtil.put(EHCACHE_DISCU_USERS_ + disId, dguList);
		return dguList;
	}
	
	/**
	 * 查询讨论组下所有的管理员用户列表
	 * @param disId 讨论组id
	 * @return List<DiscuGroupUser> 讨论组中的所有用户列表
	 */
	@SuppressWarnings("unchecked")
	public List<DiscuGroupUser> getDiscuGroupAdminUsers(String disId){
		log.info("getDiscuGroupAdminUsers begin = >");
		/*Object obj = EhcacheUtil.get(EHCACHE_DISCU_ADMIN_USERS_ + disId);
		if(obj != null){
			return (List<DiscuGroupUser>)obj;
		}*/
		DiscuGroupUser dgu = new DiscuGroupUser();
		dgu.setDis_id(disId);
		dgu.setUser_type("admin");
		List<DiscuGroupUser> dguList = cRMService.getDbService().getDiscuGroupUserService().findAllDiscuGroupUser(dgu);
		log.info("dguList = >" + dguList.size());
		//放入缓存
		EhcacheUtil.put(EHCACHE_DISCU_ADMIN_USERS_ + disId, dguList);
		return dguList;
	}
	
	/**
	 * 查询讨论组下所有的公告列表
	 * @param disId 讨论组id
	 * @return List<DiscuGroupNotice> 讨论组中的所有公告列表
	 */
	@SuppressWarnings("unchecked")
	public List<DiscuGroupNotice> getDiscuGroupNotices(String disId) {
		log.info("getTagModelList begin = >");
		/*Object obj = EhcacheUtil.get(EHCACHE_DISCU_NOTICES_ + disId);
		if(obj != null){
			return (List<DiscuGroupNotice>)obj;
		}*/
		DiscuGroupNotice dgnc = new DiscuGroupNotice();
		dgnc.setRela_id(disId);
		dgnc.setRela_type("discugroup");
		List<DiscuGroupNotice> dgnclist = (List<DiscuGroupNotice>)cRMService.getDbService().getDiscuGroupNoticeService().findObjListByFilter(dgnc);
		log.info("dgnclist = >" + dgnclist.size());
		//放入缓存
		EhcacheUtil.put(EHCACHE_DISCU_NOTICES_ + disId, dgnclist);
		return dgnclist;
	}
	
	/**
	 * 查询讨论组下所有的管理员列表 带关联用户
	 * @param disId 讨论组id
	 * @return List<DiscuGroupUser> 讨论组中的理员列表 带关联用户
	 */
	public List<DiscuGroupUser> getDiscuGroupAdminRelaUsers(String disId, String userId) {
		log.info("getDiscuGroupAdminRelaUsers begin = >");
		/*Object obj = EhcacheUtil.get(EHCACHE_DISCU_ADMIN_RELA_USERS_ + disId);
		if(obj != null){
			return (List<DiscuGroupUser>)obj;
		}*/
		DiscuGroupUser dgu = new DiscuGroupUser();
		dgu.setDis_id(disId);
		dgu.setUser_type("admin");
		dgu.setCurr_user_id(userId);
		List<DiscuGroupUser> dguadminlist = cRMService.getDbService().getDiscuGroupService().findDiscuGroupUserList(dgu);
		//放入缓存
		EhcacheUtil.put(EHCACHE_DISCU_ADMIN_RELA_USERS_ + disId, dguadminlist);
		return dguadminlist;
	}

	/**
	 * 查询讨论组下审核的列表
	 * @param disId 讨论组id
	 * @return List<DiscuGroupExam> 讨论组中的审核列表
	 */
	public List<DiscuGroupExam> getDiscuGroupExams(String disId, String eventType) {
		log.info("getDiscuGroupExams begin = >");
		/*Object obj = EhcacheUtil.get(EHCACHE_DISCU_EXAMS_ + disId + "_" + eventType);
		if(obj != null){
			return (List<DiscuGroupExam>)obj;
		}*/
		DiscuGroupExam exam = new DiscuGroupExam();
		exam.setDis_id(disId);
		exam.setEvent_type(eventType);
		@SuppressWarnings("unchecked")
		List<DiscuGroupExam> dgexlist = (List<DiscuGroupExam>)cRMService.getDbService().getDiscuGroupExamService().findObjListByFilter(exam);
		log.info("dgnclist = >" + dgexlist.size());
		//放入缓存
		EhcacheUtil.put(EHCACHE_DISCU_EXAMS_ + disId + "_" + eventType, dgexlist);
		return dgexlist;
	}
	
	/**
	 * 查询讨论组中的话题列表
	 * @param disId 讨论组id
	 * @return List<DiscuGroupTopic> 讨论组中的话题列表
	 */
	public List<DiscuGroupTopic> getGroupTopicList(String disId){
		if(StringUtils.isBlank(disId)){
			return new ArrayList<DiscuGroupTopic>();
		}
		//获取话题
		DiscuGroupTopic dgt = new DiscuGroupTopic();
		dgt.setDis_id(disId);
		dgt.setCurrpages(new Integer(0));
		dgt.setPagecounts(new Integer(999));
		dgt.setTopic_status("audited");
		List<DiscuGroupTopic> dgtlist = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicList(dgt);
		log.info("dgtlist size = >" + dgtlist.size());
		//遍历查询话题列表 文章 article   活动 activity  调查 survey 互助 help 文本 text
		for (int i = 0; i < dgtlist.size(); i++) {
			DiscuGroupTopic sdgt = (DiscuGroupTopic)dgtlist.get(i);
			String ttp = sdgt.getTopic_type();
			String tid = sdgt.getTopic_id();
			if(StringUtils.isNotBlank(sdgt.getTopic_sendname())){
				sdgt.setCreator_name(sdgt.getTopic_sendname());
			}
			if(StringUtils.isBlank(sdgt.getCardimg())){
				sdgt.setTopic_imgurl(sdgt.getHeadimgurl());
			}else{
				sdgt.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + sdgt.getCardimg());
			}
			log.info("ttp = >" + ttp);
			log.info("tid = >" + tid);
			if("activity".equals(ttp)){//活动
				Activity act = cRMService.getDbService().getDiscuGroupService().findActivityById(tid);
				if(StringUtils.isBlank(act.getId())){
					sdgt.setTopic_status("deleted");
				}
				sdgt.setTopic_name(act.getTitle());
				sdgt.setTopic_startdate(act.getStart_date());
				sdgt.setTopic_addr(act.getPlace());
			}else if("article".equals(sdgt.getTopic_type())){//文章
				Resource res = cRMService.getDbService().getDiscuGroupService().findArticleById(tid);
				if(StringUtils.isNotBlank(res.getResourceId())){//删除的文章不显示了
					sdgt.setTopic_name(res.getResourceTitle());
					//sdgt.setTopic_imgurl(res.getResourceInfo1());
				}else{
					sdgt.setTopic_status("deleted");
				}
			}else if("survey".equals(sdgt.getTopic_type())){
				
			}else if("help".equals(sdgt.getTopic_type())){
				
			}else if("text".equals(sdgt.getTopic_type())){
				
			}
		}
		return dgtlist;
	}
	
	/**
	 * 查询讨论组中的单个话题详情信息
	 * @param id 话题主键id
	 * @return DiscuGroupTopic 讨论组中的话题详情信息
	 */
	public DiscuGroupTopic getSingleGroupTopic(String id){
		if(StringUtils.isNotBlank(id)){
			DiscuGroupTopic dgt = new DiscuGroupTopic();
			dgt.setId(id);
			List<DiscuGroupTopic> list = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicByParam(dgt);
			log.info("list size = >" + list.size());
			if(list.size() > 0){
				return list.get(0);
			}
		}
		return new DiscuGroupTopic();
	}
	
	/**
	 * 查询讨论组下所有的管理员用户列表
	 * @param modelId 标签关联id
	 * @param modelType 标签关联类型
	 * @return List<Tag> 标签列表
	 */
	@SuppressWarnings("unchecked")
	public List<Tag> getTagModelList(String modelId, String modelType){
		log.info("getTagModelList begin = >");
		//2015-04-30修改，暂时不从缓存中取；在保存和删除的时候并没有同步更新缓存，导致数据不同步
//		Object obj = EhcacheUtil.get(EHCACHE_TAG_MODEL_ + modelId + "_" +  modelType);
//		if(obj != null){
//			return (List<Tag>)obj;
//		}
		Tag tag = new Tag();
		tag.setModelId(modelId);
		tag.setModelType(modelType);
		List<Tag> list = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
		log.info("list = >" + list);
		//放入缓存
		EhcacheUtil.put(EHCACHE_TAG_MODEL_ + modelId + "_" +  modelType, list);
		return list;
	}

	/**
	 * 判断是否是讨论组创建者
	 * @param disId 讨论组id
	 * @param userId 用户id
	 * @return true 是 ， false 不是
	 */
	public boolean isDiscuOwner(String disId, String userId) {
		DiscuGroup discuGroup = getDiscuGroupById(disId);
		if(userId.equals(discuGroup.getCreator())){
			return true;
		}
		return false;
	}

	/**
	 * 判断是否是讨论组管理员
	 * @param disId 讨论组id
	 * @param userId 用户id
	 * @return true 是 ， false 不是
	 */
	public boolean isDiscuAdmin(String disId, String userId) {
		List<DiscuGroupUser> dgulist = getDiscuGroupUsers(disId);
		log.info("dguList size = >" + dgulist.size());
		//遍历讨论组成员列表
		for (int i = 0; i < dgulist.size(); i++) {
			DiscuGroupUser sdg = (DiscuGroupUser)dgulist.get(i);
			String uid = sdg.getUser_id();
			String ut = sdg.getUser_type();
			log.info("uid = >" + uid);
			log.info("ut = >" + ut);
			if(uid.equals(userId) && "admin".equals(ut)){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 判断是否是讨论组成员
	 * @param disId 讨论组id
	 * @param userId 用户id
	 * @return true 是 ， false 不是
	 */
	public boolean isDiscuIn(String disId, String userId) {
		List<DiscuGroupUser> dgulist = getDiscuGroupUsers(disId);
		log.info("dguList size = >" + dgulist.size());
		//遍历讨论组成员列表
		for (int i = 0; i < dgulist.size(); i++) {
			DiscuGroupUser sdg = (DiscuGroupUser)dgulist.get(i);
			String uid = sdg.getUser_id();
			String ut = sdg.getUser_type();
			log.info("uid = >" + uid);
			log.info("ut = >" + ut);
			if(uid.equals(userId)){
				return true;
			}
		}
		return false;
	}

	/**
	 * 判断是否是在审核
	 * @param disId 讨论组id
	 * @param userId 用户id
	 * @return true 是 ， false 不是
	 */
	public boolean isDiscuAudit(String disId, String userId) {
		//判断人是否有 未审核的记录
		DiscuGroupExam dge = new DiscuGroupExam();
		dge.setDis_id(disId);
		dge.setApply_user_id(userId);
		dge.setEvent_type("join_apply");//申请加入
		dge.setExam_result_flag(null);//查询等待审核的记录
		Object objdge = cRMService.getDbService().getDiscuGroupExamService().findObj(dge);
		if(objdge != null){
			return true;
		}//其他情况下需要申请加入
		return false;
	}
	
	/**
	 * 讨论组群发文章活动等信息
	 * @param disId 讨论组id
	 * @param userId 登陆用户id
	 * @param userName 登陆用户名字
	 * @param topicId 文章或活动id
	 * @param topicType 文章或者活动类型 
	 */
	public void sendMassInfo(String disId, String userId, String userName, String topicId, String topicType) throws Exception{
		DiscuGroup dg = getDiscuGroupById(disId);
		String msggroupflag = dg.getMsg_group_flag();
		log.info("msggroupflag = >" + msggroupflag);
		
		//如果不用审核 , 则直接发送指尖消息
		String topicstatus = "unaudit";
		if("no".equals(msggroupflag)){
			topicstatus = "audited";//已审核
		}else if("yes".equals(msggroupflag)){
			//如果创建者或者管理员 ，则无须审核
			if(dg.getCreator().equals(userId) 
					|| isDiscuAdmin(disId, userId)){
				topicstatus = "audited";//已审核
			}else{
				topicstatus = "auditing";//审核中
			}
		}
		log.info("topicstatus = >" + topicstatus);
		
		//保存关联
		DiscuGroupTopic dgt = new DiscuGroupTopic();
		CrmError ret = new CrmError();
		dgt.setDis_id(disId);
		dgt.setTopic_id(topicId);
		dgt.setTopic_type(topicType);
		dgt.setCreator(userId);
		dgt.setTopic_status(topicstatus);//审核通过为1
		dgt.setEss_flag("0");//0 为未加精
		ret = cRMService.getDbService().getDiscuGroupService().addDiscuGroupTopic(dgt);
		log.info("save discugroupTopic id:" + ret.getRowId());
		
		//发送消息 不需要审核的讨论组 直接发送消息
		if("no".equals(msggroupflag) || "audited".equals(topicstatus)){
			//获取讨论组成员
			List<DiscuGroupUser> dgulist = getDiscuGroupUsers(disId);
			log.info("dgulist size = >" + dgulist.size());
			
			String content = userName;
			if("activity".equals(topicType)){
				content += "在讨论组【"+dg.getName()+"】中发起了一个活动";
			}else{
				content += "在讨论组【"+dg.getName()+"】中发表了一篇文章";
			}
			
			//给群组里所有成员发消息
			for(int i = 0; i < dgulist.size() ;i++){
				DiscuGroupUser sdgu = (DiscuGroupUser)dgulist.get(i);
				String sduid = sdgu.getUser_id();
				if(sduid.equals(userId)){
					continue;
				}
				cRMService.getDbService().getMessagesService().sendMsg(userId, userName, sduid, "", 
																			content, MSGTYPE_DISCUGROUP_MASS, disId, topicType,
																				"txt", "N", DateTime.currentDate(), "");
				//推送微信消息
				String url = "/discuGroup/detail?rowId="+disId;
				String smsurl = "/discuGroup/detail_fsms?rowId="+disId;
				if(topicType.equals("activity")){//活动
					url =  "/zjwkactivity/detail?id="+topicId+"&source=wkshare&sourceid="+userId;
					smsurl =  "/zjwkactivity/new_detail?id="+topicId+"&source=wkshare";
				}else if(topicType.equals("article")){//文章
					url = "/resource/detail?id="+topicId;
				}
				//批量发送
				List<BusinessCard> cardList = new ArrayList<BusinessCard>();
				BusinessCard bc = new BusinessCard();
				bc.setPartyId(sduid);
				cardList.add(bc);
				cRMService.getWxService().getZjwkSystemTaskService().intelligentSendMessages(cardList, content, url, smsurl, url, true, "0");
			}
			
		}else if("yes".equals(msggroupflag)){
			//审核中的数据  向审核表中插入一条数据记录
			DiscuGroupExam dge = new DiscuGroupExam();
			dge.setDis_id(disId);
			dge.setApply_time(DateTime.currentDateTime());
			dge.setApply_user_id(userId);
			dge.setRela_id(ret.getRowId());
			dge.setRela_type(topicType);
			dge.setEvent_type("mass_apply");//群发申请
			try {
				cRMService.getDbService().getDiscuGroupExamService().addObj(dge);
			} catch (Exception e1) {
				e1.printStackTrace();
				throw new CRMException(e1.getMessage(), e1.getMessage());
			}
			
			//向管理员发送申请审核的消息 ,给群主和管理发送申请加入的消息
			List<DiscuGroupUser> userList = getDiscuGroupAdminUsers(disId);
			List<BusinessCard> cardList = new ArrayList<BusinessCard>();
			for (@SuppressWarnings("rawtypes")Iterator iterator = userList.iterator(); iterator.hasNext(); ) {
				DiscuGroupUser obj = (DiscuGroupUser) iterator.next();
				String uid = obj.getUser_id();
				log.info("uid = >" + uid);
				//给发送消息  申请加群
				String content = "在您的讨论组【"+dg.getName()+"】中, " + userName +" 申请群发话题";
				cRMService.getDbService().getMessagesService().sendMsg(userId, userName, uid, "", 
																		 content, MSGTYPE_DISCUGROUP_APPLYMASS, disId, "", 
																			"txt", "N", DateTime.currentDate(), "");
			    BusinessCard bc = new BusinessCard();
				bc.setPartyId(uid);
				cardList.add(bc);
			}
			//发送微信消息 -- 智能发送 --需要查看用户信息
			if(cardList.size() > 0){
				try {
					String content = userName+ "在您的讨论组【"+dg.getName()+"】中，" + " 申请群发话题";
					String url = "/discuGroup/manage?dgid="+disId;
					cRMService.getWxService().getZjwkSystemTaskService().intelligentSendMessages(cardList, content, url, true, "0");
				} catch (Exception e) {
					e.printStackTrace();
					throw new CRMException(e.getMessage(), e.getMessage());
				}
			}
		}
	}

	/**
	 * 在讨论组中可以直接发表话题
	 * @param disId 讨论组id [必填]
	 * @param content 话题内容 [必填]
	 * @param sendUserId 发送人用户id [必填]
	 * @return String 话题ID:成功 ，空字符串:失败
	 */
	public String sendTextTopic(String disId, String content, String sendUserId) throws CRMException{
		if(StringUtils.isNotBlank(disId)
				&& StringUtils.isNotBlank(content)
				&& StringUtils.isNotBlank(sendUserId)){
			DiscuGroupTopic upd = new DiscuGroupTopic();
		    upd.setDis_id(disId);
		    upd.setTopic_id("");
		    upd.setTopic_type("text");//文章 article   活动 activity  调查 survey 互助 help  文本 text
		    upd.setEss_flag("0");
		    upd.setCreator(sendUserId);
		    upd.setContent(content);
		    upd.setTopic_status("audited");
			cRMService.getDbService().getDiscuGroupService().addDiscuGroupTopic(upd);
			
			//获取讨论组成员
			List<DiscuGroupUser> dgulist = getDiscuGroupUsers(disId);
			log.info("dgulist size = >" + dgulist.size());
			String sendCon = "在讨论组中【"+ getDiscuGroupById(disId).getName() +"】发起了一个原创话题";
			//给群组里所有成员发消息
			for(int i = 0; i < dgulist.size() ;i++){
				DiscuGroupUser sdgu = (DiscuGroupUser)dgulist.get(i);
				String sduid = sdgu.getUser_id();
				if(sduid.equals(sendUserId)){
					continue;
				}
				cRMService.getDbService().getMessagesService().sendMsg(sendUserId, "", sduid, "", 
																			sendCon, MSGTYPE_DISCUGROUP_MASS, disId, "text",
																				"txt", "N", DateTime.currentDate(), "");
				//推送微信消息
				String url = "/discuGroup/detail?rowId="+disId;
				//批量发送
				List<BusinessCard> cardList = new ArrayList<BusinessCard>();
				BusinessCard bc = new BusinessCard();
				bc.setPartyId(sduid);
				cardList.add(bc);
				try {
					cRMService.getWxService().getZjwkSystemTaskService().intelligentSendMessages(cardList, sendCon, url, url, url, true, "0");
				} catch (Exception e) {
					
				}
			}
			//返回讨论组话题id
			return upd.getId();
		}
		return "";
	}
}
