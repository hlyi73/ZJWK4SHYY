package com.takshine.marketing.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Attachment;
import com.takshine.marketing.service.AttachmentService;
/**
 * 
 * 附件服务类
 *
 */
@Service("attachmentService")
public class AttachmentServiceImpl extends BaseServiceImpl implements AttachmentService {
	
	private static Logger log = Logger.getLogger(AttachmentServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		

	@Override
	protected String getDomainName() {
		return "Attachment";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "attachmentSql.";
	}
	
	public BaseModel initObj() {
		return new Attachment();
	}

	/**
	 * 获取附件列表
	 */
	public List<Attachment> getAttachmentList(Attachment att) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * 获取活动附件列表
	 */
	public List<Attachment> getActivityAttachmentList(String activityid) throws Exception {
		List<Attachment> list = getSqlSession().selectList("attachmentSql.findAttachmentByActivityId", activityid);
		return list;
	}

	/**
	 * 添加附件
	 */
	public boolean addAttachment(Attachment att) throws Exception {
		// TODO Auto-generated method stub
		int flag = getSqlSession().insert("attachmentSql.saveAttachment", att);
		if(flag >0){
			flag = getSqlSession().insert("attachmentSql.saveRelaActivityAndAttachment", att);
			if(flag >0){
				return true;
			}
		}
		return false;
	}

	/**
	 * 删除附件
	 */
	public boolean delAttachment(Attachment att) throws Exception {
		int flag = getSqlSession().delete("attachmentSql.deleteAttachmentById", att.getId());
		if(flag >0){
			flag = getSqlSession().delete("attachmentSql.deleteAttachmentRelaById", att);
			if(flag >0){
				return true;
			}
		}
		return false;
	}

	public List<Attachment> getActivityAttachmentListByActId(String activityid)
			throws Exception {
//		String url = PropertiesUtil.getAppContext("pczjwk.url")+"/attachment/asyclist?parentId="+activityid;
//		
////		Map map = new HashMap();
////		map.put("parentId", activityid);
//		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_SINGLE);
//		log.info("syncParticipant2Contact rst => rst is : " + rst);
//		//做空判断
//		if(null == rst || "".equals(rst)) return null;
//		
//		List<Attachment> attList = new ArrayList<Attachment>();
//		//解析JSON数据
//		JSONArray jsonArr =JSONArray.fromObject(rst);
//		JSONObject jsonObject = null;
//		Attachment att = null;
//		for(int i=0;i<jsonArr.size();i++){
//			jsonObject = jsonArr.getJSONObject(i);
//			att = new Attachment();
//			att.setFile_name(jsonObject.getString("attachName"));
//			att.setUrl(jsonObject.getString("attachUrl"));
//			att.setFile_type(jsonObject.getString("attachType"));
//			att.setFile_size(jsonObject.getString("attachSize"));
//			attList.add(att);
//		}
//		
//		return attList;
		Attachment att = new Attachment();
		att.setActivity_id(activityid);
		return this.getSqlSession().selectList("attachmentSql.findAttachmentList", att);
	}

}
