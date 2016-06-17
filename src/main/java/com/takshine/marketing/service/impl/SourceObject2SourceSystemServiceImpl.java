package com.takshine.marketing.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.SourceObject;
import com.takshine.marketing.service.SourceObject2SourceSystemService;
@Service("sourceObject2SourceSystemService")
public class SourceObject2SourceSystemServiceImpl extends BaseServiceImpl
		implements SourceObject2SourceSystemService {
	private static Logger log = Logger.getLogger(SourceObject2SourceSystemServiceImpl.class.getName());
	// http  服务
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}


	public SourceObject getSourceObject(String sourceid, String source)
			throws Exception {
		SourceObject resp = new SourceObject();
		resp.setSourceid(sourceid);
		resp.setSource(source);
		//20150317修改
		if("WX".equals(source)){
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(sourceid);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(obj != null){
				bc = (BusinessCard)obj;
				resp.setContacter(bc.getName());
				resp.setPhone(bc.getPhone());
				resp.setPosition(bc.getPosition());
				resp.setCompany(bc.getCompany());
			}
		}else if("share".equals(source)){
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(sourceid);
			resp.setNickName(wu.getNickname());
			resp.setHeadImageUrl(wu.getHeadimgurl());
			resp.setSourceid(wu.getParty_row_id());
			resp.setOpenId(wu.getOpenId());
		}else{
			WxuserInfo u = new WxuserInfo();
			u.setParty_row_id(sourceid);
			WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(u);
			resp.setNickName(wu.getNickname());
			resp.setHeadImageUrl(wu.getHeadimgurl());
			resp.setSourceid(wu.getParty_row_id());
			resp.setOpenId(wu.getOpenId());
		}
		return resp;
	}


	public List<Organization> getOrgList(String sourceid) throws Exception {
		//20150317修改
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(sourceid);
		wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
		if(!StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
			return null;
		}
		//查询用户绑定列表
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(wxuser.getOpenId());
		obj.setOrgIdNot(null);
		List<OperatorMobile> orglist = cRMService.getDbService().getBusinessCardService().getOrgList(obj);
		List<Organization> orgList = new ArrayList<Organization>();
		for(OperatorMobile operatorMobile: orglist){
			Organization organization = new Organization();
			organization.setId(operatorMobile.getOrgId());
			organization.setName(operatorMobile.getOrgName());
			orgList.add(organization);
		}
		return orgList;
	}
	
	public List<Organization> getOrgList(String sourceid,String orgId) throws Exception {
		//20150317修改
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(sourceid);
		wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
		if(!StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
			return null;
		}
		//查询用户绑定列表
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(wxuser.getOpenId());
		obj.setOrgIdNot(null);
		List<OperatorMobile> orglist = cRMService.getDbService().getBusinessCardService().getOrgList(obj);
		List<Organization> orgList = new ArrayList<Organization>();
		for(OperatorMobile operatorMobile: orglist){
			if(orgId.equals(operatorMobile.getOrgId())){
				Organization organization = new Organization();
				organization.setId(operatorMobile.getOrgId());
				organization.setName(operatorMobile.getOrgName());
				orgList.add(organization);
			}
		}
		return orgList;
	}
	
}
