package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Activity;
import com.takshine.wxcrm.domain.Group;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.service.Group2ZjrmService;

@Service("group2ZjrmService")
public class Group2ZjrmServiceImpl extends BaseServiceImpl implements
		Group2ZjrmService {
	private static Logger log = Logger.getLogger(Group2ZjrmServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}
     public static final String GROUP_PUBLIC_LIST="GROUP_PUBLIC_LIST";
     public static final String GROUP_DETAIL="GROUP_DETAIL";
	public List<Group> getPublicGroupList(String openId) throws Exception {
		List<Group> returnList=new ArrayList<Group>();
		List<Group> list =this.getPublicGroupList();
		if(list==null||list.size()<1){
			return null;
		}
		Subscribe sub= new Subscribe();
		sub.setOpenId(openId);
		sub.setType("group");
		sub.setPagecounts(1000);
		sub.setCurrpages(0);
		List<Subscribe> sublist= getSqlSession().selectList("subscribeSql.findSubscribeList", sub);
		for(Group group:list){
			for(Subscribe subObj:sublist){
				if(group.getId().equals(subObj.getFeedid())){
					group.setRssId(subObj.getId());
					sublist.remove(subObj);
					break;
				}
			}
			returnList.add(group);
		}
		return returnList;
	}

	public List<Group> getPublicGroupList() throws Exception {
		List<Group> list=new ArrayList<Group>();
		if(RedisCacheUtil.checkKeyExisted(this.GROUP_PUBLIC_LIST)){
			list=(ArrayList<Group>) RedisCacheUtil.get(this.GROUP_PUBLIC_LIST);
			
		}else{
		String url = PropertiesUtil.getAppContext("zjsso.url")+"/out/group/public_list";
		log.info("getPublicGroupList url => url is : " + url);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		log.info("getPublicGroupList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return null;
		//解析JSON数据
		JSONArray jsonObject = JSONArray.fromObject(rst);
		list = (ArrayList<Group>)JSONArray.toCollection(jsonObject,Group.class);
		RedisCacheUtil.set(this.GROUP_PUBLIC_LIST, list);
		}
		return list;
	}
	
	public Group getGroupDetail(String groupId) throws Exception {
		Group group=null;
		if(RedisCacheUtil.checkKeyExisted(this.GROUP_DETAIL+"_"+groupId)){
			group=(Group) RedisCacheUtil.get(this.GROUP_DETAIL+"_"+groupId);
			
		}
		if(group==null){
		String url = PropertiesUtil.getAppContext("zjsso.url")+"/out/group/activity_list/"+groupId;
		log.info("getPublicGroupList url => url is : " + url);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		log.info("getPublicGroupList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return null;
		//解析JSON数据
		JSONArray jsonStr = JSONArray.fromObject(rst);
		JSONObject jsonObject=jsonStr.optJSONObject(0);
		if(!jsonObject.containsKey("errcode")){
			group=new Group();
			group.setId(groupId);
			group.setName(jsonObject.getString("name"));
			group.setLogo(jsonObject.getString("logo"));
			JSONArray jsonArray = jsonObject.getJSONArray("groupActivitys");
			if(null != jsonArray && jsonArray.size()>0){
				ArrayList<Activity> IdList = new ArrayList<Activity>();
				ArrayList<Activity> activityList = new ArrayList<Activity>();
				JSONObject jsonObject1 = null;
				for(int i=0;i<jsonArray.size();i++){
					Activity ac = new Activity();
					jsonObject1 = jsonArray.getJSONObject(i);
					ac.setRowid(jsonObject1.getString("activityId"));
					IdList.add(ac);
					
				}
				activityList=this.getActivity(IdList);//通过Id列表查询活动详情列表
				group.setList(activityList);
				
			}
			RedisCacheUtil.set(this.GROUP_DETAIL+"_"+groupId, group,3600);
		}
		}
		return group;
	}
	
	public ArrayList<Activity> getActivity(ArrayList<Activity> idList){
		String url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/synclistbyidlist";
		log.info("getActivity url => url is : " + url);
		String respStr = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", JSONArray.fromObject(idList).toString(), Constants.INVOKE_MULITY);
		log.info("getActivity respStr => respStr is : " + respStr);
		ArrayList<Activity> list=new ArrayList<Activity>();
		if(StringUtils.isNotNullOrEmptyStr(respStr)){
			JSONArray jsonArray = JSONArray.fromObject(respStr);
			for(int i=0;i<jsonArray.size();i++){
				Activity act = new Activity();
				JSONObject jsonObject = jsonArray.getJSONObject(i);
				act.setRowid(jsonObject.getString("id"));
				act.setDeadline(jsonObject.getString("end_date"));
				act.setStartdate(jsonObject.getString("start_date"));
				act.setTitle(jsonObject.getString("title"));
				act.setDesc(jsonObject.getString("content"));
				act.setPlace(jsonObject.getString("place"));
				act.setImagename(jsonObject.getString("logo"));
				act.setType(jsonObject.getString("type"));
				list.add(act);
			}
			}
		return list;
		
	}
}
