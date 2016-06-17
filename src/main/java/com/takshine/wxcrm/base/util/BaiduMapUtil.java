package com.takshine.wxcrm.base.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.takshine.wxcrm.domain.UserLocation;
import com.takshine.wxcrm.message.baidu.BaiduPlace;
import com.takshine.wxcrm.message.resp.Article;

/**
 * 百度地图工具类
 * 
 * @author liulin
 * @date 2014-03-16
 */

public class BaiduMapUtil {
	private static Logger log =  Logger.getLogger(BaiduMapUtil.class.getName());

    /**
     * 原型区域检索
     * @param query
     * @param lng
     * @param lat
     * @return
     */
	public static List<BaiduPlace> searchPlace(String query, String lng, String lat) {
		List<BaiduPlace>  placeList = null;
		//拼装请求地址
		try {
			String requestUrl = "http://api.map.baidu.com/place/v2/search?query=QUERY&location=LAT,LNG&radius=2000&output=xml&scope=1&page_size=10&page_num=0&ak=AK";
			requestUrl = requestUrl.replace("QUERY", URLEncoder.encode(query, "UTF-8"));
			requestUrl = requestUrl.replace("LAT", lat);
			requestUrl = requestUrl.replace("LNG", lng);
			requestUrl = requestUrl.replace("AK", PropertiesUtil.getAppContext("baidu.ak"));
			log.info("searchPlace requestUrl :" + requestUrl);
			//调用Place API 圆形区域检索
			String respXml = httpRequest(requestUrl);
			log.info("searchPlace respXml :" + respXml);
			//解析返回的XML
			placeList = parsePlaceXml(respXml);
		} catch (Exception e) {
			log.info("searchPlace exception :" + e.getMessage());
		}
		return placeList;
	}
	
	/** 
     * 发起http get请求获取网页源代码 
     *  
     * @param requestUrl 
     * @return 
     */  
    public static String httpRequest(String requestUrl) {  
        StringBuffer buffer = null;  
  
        try {  
            // 建立连接  
            URL url = new URL(requestUrl);  
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();  
            httpUrlConn.setDoInput(true);  
            httpUrlConn.setRequestMethod("GET");  
  
            // 获取输入流  
            InputStream inputStream = httpUrlConn.getInputStream();  
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");  
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);  
  
            // 读取返回结果  
            buffer = new StringBuffer();  
            String str = null;  
            while ((str = bufferedReader.readLine()) != null) {  
                buffer.append(str);  
            }  
  
            // 释放资源  
            bufferedReader.close();  
            inputStreamReader.close();  
            inputStream.close();  
            httpUrlConn.disconnect();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return buffer.toString();  
    }
    
    /**
     * 根据百度地图 返回的流解析出地址信息
     * @param xml
     * @return
     */
    @SuppressWarnings("unchecked")
    private static List<BaiduPlace> parsePlaceXml(String xml){
    	List<BaiduPlace> placeList = null;
    	try {
			Document document = DocumentHelper.parseText(xml);
			//得到XML跟元素
			Element root = document.getRootElement();
			//从根元素获得<result>
			Element resultsElement = root.element("results"); 
			//从<results> 中获取<result>集合
			
			List<Element> resultElementList = resultsElement.elements("result");
			//判断 <result>集合的大小
			if(resultElementList.size() > 0){
				placeList = new ArrayList<BaiduPlace>();
				//POI名称
				Element nameElement = null;
				//POI地址信息
				Element addressElement = null;
				//POI经纬度坐标
				Element locationElement = null;
				//POI电话信息
				Element telephoneElement = null;
				//POI扩展信息
				Element detailInfoElement = null;
				//距离中心点的距离
				Element distanceElement = null;
				//遍历<result>集合
				for(Element resultElement : resultElementList){
					nameElement = resultElement.element("name");
					addressElement = resultElement.element("address");
					locationElement = resultElement.element("location");
					telephoneElement = resultElement.element("telephone");
					detailInfoElement = resultElement.element("detail_info");
					
					BaiduPlace place = new BaiduPlace();
					place.setName(nameElement.getText());
					place.setAddress(addressElement.getText());
					place.setLng(locationElement.element("lng").getText());
					place.setLat(locationElement.element("lat").getText());
					//当<telephone>元素存在时获取电话号码
					if(null != telephoneElement)
						place.setTelephone(telephoneElement.getText());
					//当<detail_info>元素存在时获取 <distance>
					if(null != detailInfoElement){
						distanceElement = detailInfoElement.element("distance");
						if(null != distanceElement)
							place.setDistance(Integer.parseInt(distanceElement.getText()));
					}
					placeList.add(place);
				}
				//按距离由远及近排序
				Collections.sort(placeList);
			}
		} catch (Exception e) {
			log.info("parsePlaceXml exception :" + e.getMessage());
		}
    	return placeList;
    }
    
    /**
     * 根据place组装图文列表
     * @param placeList
     * @param bd09Lng
     * @param bd09Lat
     * @return
     */
    public static List<Article> makeArticleList(List<BaiduPlace> placeList, String bd09Lng, String bd09Lat){
    	//项目的根路径
    	String basePath = PropertiesUtil.getAppContext("app.content");
    	List<Article> list = new ArrayList<Article>();
    	BaiduPlace place = null;
    	for(int i=0 ; i < placeList.size() ; i++){
    		place = placeList.get(i);
    		Article article = new Article();
    		article.setTitle(place.getName());//+ "\n距离约" + place.getDistance() + "米"
    	    //P1表示用户发送的位置(坐标转换后), P2表示当前POI所在的位置
    		article.setUrl(String.format(basePath + "baidu/route?p1=%s,%s&p2=%s,%s", bd09Lng, bd09Lat,
    				         place.getLng(), place.getLat()));
    		//将首条图文的图片设置为大图
    		if(i == 0)
    			article.setPicUrl(basePath + "image/poisearch.png");
    		else
    			article.setPicUrl(basePath + "image/navi.png");
    		
    		list.add(article);
    	}
    	return list;
    }
    
    /**
     * 将微信定位的坐标转换为百度坐标
     * @param lng
     * @param lat
     * @return
     */
    public static UserLocation convertCoord(String lng, String lat){
    	//百度坐标转换接口
    	String convertUrl = "http://api.map.baidu.com/geoconv/v1/?coords=LNG,LAT&form=3&to=5&ak=AK&output=json";
    	convertUrl = convertUrl.replace("LNG", lng);
    	convertUrl = convertUrl.replace("LAT", lat);
    	convertUrl = convertUrl.replace("AK", PropertiesUtil.getAppContext("baidu.ak"));
    	log.info("convertCoord convertUrl :" + convertUrl);
    	UserLocation location = new UserLocation();
    	try {
			String jsonCoord = httpRequest(convertUrl);
			log.info("convertCoord jsonCoord :" + jsonCoord);
			JSONObject jsonObject = JSONObject.fromObject(jsonCoord);
			JSONArray jsonArray = jsonObject.getJSONArray("result");
			if(jsonArray.size() >0 ){
				JSONObject jo = (JSONObject)jsonArray.get(0);
				log.info("convertCoord jsonObject : " + jo.getString("x"));
				//对转换后的坐标进行base64解码 Base64.decode(
				location.setBd09Lng(jo.getString("x"));
				location.setBd09Lat(jo.getString("y"));
			}
		} catch (Exception e) {
			location = null;
			log.info("convertCoord exception :" + e.getMessage());
		}
    	return location;
    }
	
}
