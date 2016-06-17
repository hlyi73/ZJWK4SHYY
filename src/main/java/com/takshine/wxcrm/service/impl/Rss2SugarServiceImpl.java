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
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.message.sugar.RssReq;
import com.takshine.wxcrm.service.Rss2SugarService;
@Service("rss2SugarService")
public class Rss2SugarServiceImpl extends BaseServiceImpl implements
		Rss2SugarService {
	private static Logger log = Logger.getLogger(Rss2SugarServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

	public Trackhis getTrackhisList(RssReq rssReq) {
				Trackhis resp = new Trackhis();
		//转换为json
				String jsonStr = JSONObject.fromObject(rssReq).toString();
				log.info("getTrackhisList jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
				log.info("getTrackhisList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if(!jsonObject.containsKey("errcode")){
					//错误代码和消息
					String count = jsonObject.getString("count");
					if(!"".equals(count) 
							&& Integer.parseInt(count) > 0){
						List<Trackhis> slist = (List<Trackhis>)JSONArray.toCollection(jsonObject.getJSONArray("Trackhis"), Trackhis.class);
						resp.setHis(slist);
					}
					resp.setCount(count);//数字
				}else{
					String errcode = jsonObject.getString("errcode");
					String errmsg = jsonObject.getString("errmsg");
					log.info("getTrackhisList errcode => errcode is : " + errcode);
					log.info("getTrackhisList errmsg => errmsg is : " + errmsg);
					resp.setErrcode(errcode);
					resp.setErrmsg(errmsg);
				}
				return resp;
	}

}
