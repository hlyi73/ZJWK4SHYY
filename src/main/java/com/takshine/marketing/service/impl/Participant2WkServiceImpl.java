package com.takshine.marketing.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Participant;
import com.takshine.marketing.service.Participant2WkService;
@Service("participant2WkService")
public class Participant2WkServiceImpl extends BaseServiceImpl implements
		Participant2WkService {
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	public String syncParticipant2Contact(String source,String sourceid,Participant pc)
			throws Exception {
//		String url = "";
//		if("PC".equals(source)){
//			url = PropertiesUtil.getAppContext("pczjwk.url")+"/contact/wk_contact_save_json?";
//		}else{
//			url = PropertiesUtil.getAppContext("zjwk.url")+"/contact/wk_contact_save_json?";
//		}
//		Map map = new HashMap();
//		map.put("partyid", sourceid);
//		map.put("name", pc.getOpName());
//		map.put("email", pc.getOpEmail());
//		map.put("address", pc.getOpAddress());
//		map.put("position", pc.getOpDuty());
//		map.put("mobile", pc.getOpMobile());
//		map.put("phone", pc.getOpMobile());
//		map.put("sex", pc.getOpGender());
//		map.put("crmid", pc.getCrmId());
//		map.put("orgId", pc.getOrgId());
//		String rst = util.postJsonData(url,"", JSONObject.fromObject(map).toString(), Constants.INVOKE_SINGLE);
//		log.info("syncParticipant2Contact rst => rst is : " + rst);
//		//做空判断
//		if(null == rst || "".equals(rst)) return null;
//		//解析JSON数据
//		JSONObject jsonObject =JSONObject.fromObject(rst);
//		String errcode = jsonObject.getString("errorCode");
//		String errmsg = jsonObject.getString("errorMsg");
//		log.info("getSourceObject errcode => errcode is : " + errcode);
//		log.info("getSourceObject errmsg => errmsg is : " + errmsg);
//		return rst;
		
		/**
		 * 20150317修改
		 */
		String crmid = pc.getCrmId();
		if(sourceid!=null&&!"".equals(sourceid.trim())){
			//根据partyid查找openId
			WxuserInfo wxuser = new WxuserInfo();
			wxuser.setParty_row_id(sourceid);
			wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
			if(!StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
				return "{\"errorCode\":\"-1\",\"errorMsg\":\"同步失败\",\"rowId\":\"\"}";
			}
			OperatorMobile obj = new OperatorMobile();
			obj.setOpenId(wxuser.getOpenId());
			obj.setOrgId(pc.getOrgId());
			List<OperatorMobile> list =cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(obj);
			if(list!=null&&list.size()>0){
				crmid = list.get(0).getCrmId();
			}else{
				return "{\"errorCode\":\"-1\",\"errorMsg\":\"同步失败\",\"rowId\":\"\"}";
			}
		}
		if(null == crmid || "".equals(crmid) ||
			null == pc.getOpName() || "".equals(pc.getOpName()) ||
			null ==  pc.getOpMobile() || "".equals( pc.getOpMobile())){
			return "{\"errorCode\":\"7\",\"errorMsg\":\"参数填写不完整\"}";
		}
		//创建对象
		Contact ct = new Contact();
		ct.setCrmId(crmid);
		ct.setSalutation(pc.getOpGender());
		ct.setConname(pc.getOpName());
		ct.setEmail0(pc.getOpEmail());
		ct.setConaddress(pc.getOpAddress());
		ct.setConjob(pc.getOpDuty());
		ct.setPhonemobile(pc.getOpMobile());
		ct.setPhonework(pc.getOpPhone());
		ct.setAssignerId(crmid);
		ct.setOrgId(pc.getOrgId());
		//保存联系人
		CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(ct);
		String rowId = crmErr.getRowId();
		return "{\"errorCode\":\"0\",\"errorMsg\":\"success\",\"rowId\":\""+ rowId +"\"}";
	}
}