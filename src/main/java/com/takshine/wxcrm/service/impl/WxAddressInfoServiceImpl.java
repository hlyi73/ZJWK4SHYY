package com.takshine.wxcrm.service.impl;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.service.WxAddressInfoService;

/**
 * 地址服务信息
 * @author liulin
 *
 */
@Service("wxAddressInfoService")
public class WxAddressInfoServiceImpl implements WxAddressInfoService {
	
	private static Logger log = Logger.getLogger(WxAddressInfoServiceImpl.class.getName());
	
	//谷歌地图API地址
	private static final String google_map_url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=LAT,LNG&sensor=true";

	/**
	 * 根据经纬度查询地址信息
	 * @param lat
	 * @param lng
	 * @return
	 */
	public String getAddressNameByLatLng(String lat, String lng){
		String rst = "";
		//拼接调用地址
		String url = google_map_url.replace("LAT", lat).replace("LNG", lng);
		 // 获取网页源代码  
        String html = WxUtil.httpRequest(url);  
        log.info("getAddressNameByLatLng html =: > " + html);
        JSONObject jsonObject = JSONObject.fromObject(html);
        JSONArray jsonArr =  jsonObject.getJSONArray("results");
        if(jsonArr.size() > 0){
        	JSONObject fst = (JSONObject)jsonArr.get(1);
        	rst = (String)fst.getString("formatted_address");
        }
        log.info("rst =: > " + rst);
		return rst;
	}

}
