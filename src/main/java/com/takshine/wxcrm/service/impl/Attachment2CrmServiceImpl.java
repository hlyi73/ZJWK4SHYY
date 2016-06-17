package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Attachment;
import com.takshine.wxcrm.message.sugar.AttachmentAdd;
import com.takshine.wxcrm.message.sugar.AttachmentReq;
import com.takshine.wxcrm.message.sugar.AttachmentResp;
import com.takshine.wxcrm.service.Attachment2CrmService;

/**
 * 附件
 * @author liulin
 */
@Service("attachment2CrmService")
public class Attachment2CrmServiceImpl extends BaseServiceImpl implements Attachment2CrmService{
	
	private static Logger log = Logger.getLogger(Attachment2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询订单、 样品数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public AttachmentResp getAttachmentList(Attachment sche,String source){
		//附件响应
		AttachmentResp resp = new AttachmentResp();
		resp.setCrmaccount(sche.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_ATTACHMENT);
		//附件请求
		AttachmentReq sreq = new AttachmentReq();
		sreq.setCrmaccount(sche.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_ATTACHMENT);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setParentid(sche.getParentid());
		sreq.setParenttype(sche.getParenttype());
		
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getAttachmentList jsonStr => jsonStr is : " + jsonStr);
		//多次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		//String rst = "{\"crmaccount \": \"123456\",\"modeltype\": \"sample\",\"count\": \"1\",\"currpage\": \"1\",\"pagecount\": \"10\", \"datas\": [{\"rowid\": \"123123\",\"model\": \"正品\",\"count\": \"100\",\"senddate\": \"2014-10-10\",\"approvalstatusname\": \"草稿\"}]}";
		log.info("getAttachmentList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<AttachmentAdd> slist = (List<AttachmentAdd>)JSONArray.toCollection(jsonObject.getJSONArray("documents"), AttachmentAdd.class);
				resp.setDatas(slist);//费用列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getAttachmentList errcode => errcode is : " + errcode);
			log.info("getAttachmentList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
}
