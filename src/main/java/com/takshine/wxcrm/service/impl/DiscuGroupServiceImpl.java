package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.service.DiscuGroupService;

/**
 * 讨论组 服务类
 *
 * @author liulin
 */
@Service("discuGroupService")
public class DiscuGroupServiceImpl extends BaseServiceImpl implements DiscuGroupService {
	
	//private static Logger log = Logger.getLogger(DiscuGroupServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "DiscuGroup";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "discuGroupSql.";
	}
	
	public BaseModel initObj() {
		return new DiscuGroup();
	}
	
	/**
	 * 查询讨论组用户列表
	 * @return
	 */
	public List<DiscuGroupUser> findDiscuGroupUserList(DiscuGroupUser dg){
		return getSqlSession().selectList(getNamespace() + "findDiscuGroupUserList", dg);
	}

	/**
	 * 新增讨论组话题
	 */
	public CrmError addDiscuGroupTopic(DiscuGroupTopic dgt) 
	{
		CrmError ret = new CrmError();
		
		dgt.setId(Get32Primarykey.getRandom32PK());
		int retInt = getSqlSession().insert("discuGroupSql.insertDiscuGroupTopic", dgt);
		if (retInt > 0)
		{
			ret.setErrorCode(ErrCode.ERR_CODE_0);
			ret.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			ret.setRowId(dgt.getId());
		}
		else
		{
			ret.setErrorCode(ErrCode.ERR_CODE__1);
			ret.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}
		return ret;
	}

	/**
	 * 更新话题：目前只有加精予否
	 */
	public CrmError updateDiscuGroupTopic(DiscuGroupTopic dgt) 
	{
		CrmError ret = new CrmError();
		
		int retInt = getSqlSession().update("discuGroupSql.updateDiscuGroupTopicById", dgt);
		
		if (retInt > 0)
		{
			ret.setErrorCode(ErrCode.ERR_CODE_0);
			ret.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		}
		else
		{
			ret.setErrorCode(ErrCode.ERR_CODE__1);
			ret.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}
		
		return ret;
	}
	
	/**
	 * 根据话题ID 删除讨论组话题
	 */
	public void delDiscuGroupTopicByTopicId(String topicid){
		DiscuGroupTopic dgt = new DiscuGroupTopic();
		dgt.setTopic_id(topicid);//删除的状态
		getSqlSession().update("discuGroupSql.deleteDiscuGroupTopicByTopicId", dgt);
	}

	/**
	 * 删除话题
	 */
	public CrmError deleteDiscuGroupTopic(DiscuGroupTopic dgt) 
	{
		CrmError ret = new CrmError();
		
		int retInt = getSqlSession().update("discuGroupSql.deleteDiscuGroupTopicById", dgt);
		
		if (retInt > 0)
		{
			ret.setErrorCode(ErrCode.ERR_CODE_0);
			ret.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		}
		else
		{
			ret.setErrorCode(ErrCode.ERR_CODE__1);
			ret.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}
		
		return ret;
	}

	public List<DiscuGroupTopic> findDiscuGroupTopicList(DiscuGroupTopic dgt) 
	{
		return getSqlSession().selectList("discuGroupSql.findDiscuGroupTopicById",dgt);
	}
	
	public List<DiscuGroupTopic> findDiscuGroupTopicByParam(DiscuGroupTopic dgt) 
	{
		return getSqlSession().selectList("discuGroupSql.findDiscuGroupTopicByParam",dgt);
	}
	
	
	public List<DiscuGroup> findJoinDiscuGroupList(DiscuGroup dg){
		return getSqlSession().selectList("discuGroupSql.findJoinDiscuGroupList",dg);
	}
	
	public List<DiscuGroup> findConditionGroupListByFilter(DiscuGroup dg){
		return getSqlSession().selectList("discuGroupSql.findConditionGroupListByFilter",dg);
	}
	
	public List<DiscuGroup> findWeightDiscuGroupList(DiscuGroup dg){
		return getSqlSession().selectList("discuGroupSql.findWeightDiscuGroupList",dg);
	}
	
	/**
	 * 根据活动id查询活动
	 */
	public Activity findActivityById(String id){
		log.info("findActivityById begin => ");
		if(StringUtils.isNotBlank(id)){
			Activity act = (Activity)cRMService.getDbService().getActivityService().findObjById(id);
			if(act != null){
				return act;
			}
		}
		return new Activity();
	}
	
	/**
	 * 根据类型查询活动列表 owner join
	 */
	public List<CampaignsAdd> findActivityListByType(String userid, String type){
		List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();
		log.info("findActivityListByType begin => ");
		log.info("userid => " + userid);
		log.info("type => " + type);
		if(StringUtils.isBlank(userid) || StringUtils.isBlank(type)){
			return cams;
		}
		String url = "";
		if("owner".equals(type)){//创建的
			url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/synclist?source=WK&sourceid="+ userid +"&currpage=0&pagecount=10&viewtype=" + type;
		}else if("join".equals(type)){//参与的
			url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/asynclistbyid?sourceid="+userid+"&currpage=0&pagecount=10&viewtype=" + type;
		}
		log.info(" url => " + url);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		log.info(" rst => " + rst);
		if(StringUtils.isBlank(rst)){
			return cams;
		}
		JSONArray jsonArray = JSONArray.fromObject(rst);
		log.info(" jsonArray.size => " + jsonArray.size());
		for(int i = 0 ; i < jsonArray.size() ; i++){
			JSONObject jsonObject = jsonArray.getJSONObject(i);
			CampaignsAdd campaignsAdd = new CampaignsAdd();
			campaignsAdd.setRowid(jsonObject.getString("id"));
			campaignsAdd.setName(jsonObject.getString("title"));
			campaignsAdd.setStartdate(jsonObject.getString("start_date"));
			campaignsAdd.setEnddate(jsonObject.getString("end_date"));
			campaignsAdd.setLogo(jsonObject.getString("logo"));
			campaignsAdd.setPlace(jsonObject.getString("place"));
			campaignsAdd.setRemark(jsonObject.getString("remark"));
			campaignsAdd.setReadnum(jsonObject.getString("readnum"));
			campaignsAdd.setPraisenum(jsonObject.getString("praisenum"));
			campaignsAdd.setForwardnum(jsonObject.getString("forwardnum"));
			campaignsAdd.setJoinnum(jsonObject.getString("joinnum"));
			campaignsAdd.setHeadImageUrl(jsonObject.getString("headImageUrl"));
			campaignsAdd.setCreater(jsonObject.getString("createName"));
			cams.add(campaignsAdd);
		}
		return cams;
	}
	
	/**
	 * 根据文章id查询文章
	 */
	public Resource findArticleById(String id){
		//拿详情
		Resource res = new Resource();
		res.setResourceId(id);
		res.setResourceStatus("1");
		res.setPagecounts(new Integer(999));
		res.setCurrpages(new Integer(0));
		List<Resource> retList = cRMService.getDbService().getResourceService().findResourceListByFilter(res);
		if (retList.size() > 0){
			return retList.get(0);
		}
		return new Resource();
	}
	
	/**
	 * 解散讨论组
	 */
	public void updateDiscuGroupStatus(DiscuGroup dg){
		getSqlSession().update("discuGroupSql.updateDiscuGroupStatus", dg);
	}
}