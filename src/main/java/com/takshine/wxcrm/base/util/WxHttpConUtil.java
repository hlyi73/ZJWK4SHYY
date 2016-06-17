package com.takshine.wxcrm.base.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import net.sf.json.JSONObject;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.RssNews;
import com.takshine.wxcrm.domain.Subscribe;


/**
 * 微信调用后台sugar系统 http 接口工具类
 * @author liulin
 *
 */
@Service("wxHttpConUtil")
public class WxHttpConUtil extends BaseServiceImpl{
	
	private static Logger logger = Logger.getLogger(WxHttpConUtil.class.getName());
	
	//sugar服务器的配置总入口
	//private String sugarSerPath = PropertiesUtil.getAppContext("sugar.service");

	/**
	 * 设置请求头信息
	 */
	private void setPostHeader(HttpPost httppost){
        //HTTP客户端运行的浏览器类型的详细信息。通过该头部信息，web服务器可以判断到当前HTTP请求的客户端浏览器类别
		//User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11
		httppost.addHeader("user-agent", "Mozilla/4.0");
		//指定客户端能够接收的内容类型，内容类型中的先后次序表示客户端接收的先后次序
		httppost.addHeader("accept", "*/*");
		//请求的web服务器域名地址 115.28.27.20
		httppost.addHeader("host", "127.0.0.1");
		//显示此HTTP请求提交的内容类型。一般只有post提交时才需要设置该属性 text/xml application/xml
		httppost.addHeader("content-type", "text/xml;charset=gb2312");
		//表示web服务器返回消息正文的长度
		//httppost.addHeader("content-length", "274");
		//包括实现特定的指令，它可应用到响应链上的任何接收方
		httppost.addHeader("pragma", "no-cache");
		/*表示是否需要持久连接。如果web服务器端看到这里的值为“Keep-Alive”，
		     或者看到请求使用的是HTTP 1.1（HTTP 1.1默认进行持久连接），
		    它就可以利用持久连接的优点，当页面包含多个元素时（例如Applet，图片），
		    显著地减少下载所需要的时间。要实现这一点， web服务器需要在返回给客户端
		 HTTP头信息中发送一个Content-Length（返回信息正文的长度）头，最简单的实现方法是
		 :先把内容写入ByteArrayOutputStream，然 后在正式写出内容之前计算它的大小。*/
		httppost.addHeader("connection", "Keep-Alive");
	}

	/**
	 * 实现多次循环连接
	 * @param httpclient
	 * @param httppost
	 * @return
	 */
	private HttpResponse mulityConn(CloseableHttpClient httpclient, HttpPost httppost){
		for(int i = 0; i < 3 ; i ++){
			try {
				//不报错 直接返回,一但超时报错, 直接不断循环
				return execCon(httpclient, httppost);
			} catch (IOException e) {
				logger.error("第" + (i+1) +"次连接, IOException :=> " + e.getMessage());
				try {
					httpclient.close();
				} catch (Exception ex) {
					logger.error("第" + (i+1) +"次连接, httpclient close Exception :=> " + ex.getMessage());
				}
				httpclient = HttpClients.createDefault();
			}
		}
		return null;
	}
	
	/**
	 * 单次连接
	 * @param httpclient
	 * @param httppost
	 * @return
	 */
	private HttpResponse singleConn(CloseableHttpClient httpclient, HttpPost httppost){
		try {
			//不报错 直接返回,一但超时报错, 直接不断循环
			return execCon(httpclient, httppost);
		} catch (IOException e) {
			logger.error("singleConn IOException :=> " + e.getMessage());
		}
		return null;
	}
	
	/**
	 * 连接方法
	 * @param httpclient
	 * @param httppost
	 * @return
	 * @throws Exception
	 */
	private HttpResponse execCon(CloseableHttpClient httpclient, HttpPost httppost) throws IOException{
		long l1 = System.currentTimeMillis();
		try{
			return httpclient.execute(httppost);//第二次连接
		}finally{
			logger.debug(String.format(">>>>>>>>>>>>>>>>>&&&>>>>>>>>>>>>>>>>>>>>>>>----------------> %s (execCon) Cost =>%dms , %s", this.getClass().getName(),System.currentTimeMillis() - l1,httppost.getURI().toString()));
		}
	}
	
	
	public Collection<String> postData(Map<String,String> urlbody,final String invcType,final int timeout,final boolean close){
		
		Map<String,String> retmap = this.postDataRetMap(urlbody, invcType, timeout, close);
		return retmap.values();
	}

	public Map<String,String> postDataRetMap(Map<String,String> urlbody,final String invcType,final int timeout,final boolean close){
		final Map<String,String> retmap = new ConcurrentHashMap<String, String>();
		for(final String url : urlbody.keySet()){
			final String body = urlbody.get(url);
			ThreadRun run = new ThreadRun(){
				public void run() throws CRMException {
					try{
						retmap.put(url,postData(url, body, invcType, timeout, close));
					}catch(Exception ec){
						retmap.put(url,"");
					}
				}
			};
			ThreadExecute.push(run);		
		}
		while (retmap.size()<urlbody.size()){
			try {
				Thread.sleep(10);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		return retmap;
	}
	
	public String postData(String url,String body, String invcType,int timeout,boolean close){
		//string buffer 返回值
		String respRst = "";
		//客户端对象 httpclient invoke 获得响应结果  
		CloseableHttpClient httpclient = null;
		try {
			//创建HTTPPOST请求对象
			HttpPost httppost = new HttpPost(url);
			//设置post方式的头信息
			setPostHeader(httppost);
			//设置 请求主体
			httppost.setEntity(new StringEntity(body, "utf-8"));
			//设置请求和传输超时时间 设置为30秒钟
			RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(timeout).setConnectTimeout(timeout).build();
			httppost.setConfig(requestConfig);
			
			//执行http调用
			httpclient = HttpClients.createDefault();
			//多次或者单次调用获取响应
			HttpResponse response = null;
			if(Constants.INVOKE_MULITY.equals(invcType)){
				 response = mulityConn(httpclient, httppost);
			}else{
				 response = singleConn(httpclient, httppost);
			}
			//判断响应是否有结果
			if(response != null){
				// 检验状态码，如果成功接收数据
				int code = response.getStatusLine().getStatusCode();
				if (code == 200) {
					// 返回json格式
					//respRst.append(EntityUtils.toString(response.getEntity()));
					
					HttpEntity resEntity = response.getEntity();
					//获取返回的内容
					//获取返回的内容
					respRst = StringUtils.inputStream2String(resEntity.getContent());
					
				}
			}
			
		} catch (Exception e) {
			logger.error("WxHttpConUtil postData notice Exception :=> " + e.getMessage());
		}finally{
			if (httpclient!=null && close){
				try {
					httpclient.close();
				} catch (Exception e) {
				}
			}
		}
		return respRst;
	}
	
	/**
	 * post格式的 xml数据  五秒内收不到响应会断掉连接，并且重新发起请求，总共重试三次
	 */
	public String postXmlData(String sugarSerPath,String xmlStr, String invcType){
		return postData(sugarSerPath,xmlStr,invcType,5000,true);
	}
	
	/**
	 * post json格式的数据
	 * @param jsonStr
	 * @param invcType 单次还是多次调用
	 * @return
	 */
	public String postJsonData(String model, String jsonStr, String invcType){
		try {
			String sugarSerPath = getCrmUrlRoute(jsonStr);
			return JsonUtil.removeSepcStr(postData(sugarSerPath + model,jsonStr,invcType,5000,false));

		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public List<String> postJsonData(String model, List<String> jsonList, String invcType){
		List<String> retlist = new ArrayList<String>();
		try {
			Map<String,String> map = new HashMap<String,String>();
			for(String jsonStr : jsonList){
				String sugarSerPath = getCrmUrlRoute(jsonStr);
				map.put(sugarSerPath + model, jsonStr);
			}
			Collection<String> list = postData(map,invcType,20000,false);
			for(String result : list){
				retlist.add(JsonUtil.removeSepcStr(result));
			}
			return retlist;

		} catch (Exception e) {
			e.printStackTrace();
			return retlist;
		}
	}
	public Map<String,String> postJsonDataRetMapBodyKey(String model, List<String> jsonList, String invcType){
		Map<String,String> retmap = new HashMap<String,String>();
		try {
			Map<String,String> map = new HashMap<String,String>();
			for(String jsonStr : jsonList){
				String sugarSerPath = getCrmUrlRoute(jsonStr);
				map.put(sugarSerPath + model, jsonStr);
			}
			Map<String,String> rmap = postDataRetMap(map,invcType,5000,false);
			for(String url : rmap.keySet()){
				String data = rmap.get(url);
				String body = map.get(url);
				retmap.put(body,JsonUtil.removeSepcStr(data));
			}
			return retmap;

		} catch (Exception e) {
			e.printStackTrace();
			return retmap;
		}
	}

	/**
	 * 直接通过url
	 * @param urlPath
	 * @param model
	 * @param jsonStr
	 * @param invcType
	 * @return
	 */
	public String postJsonData(String urlPath,String model, String jsonStr, String invcType){
		return JsonUtil.removeSepcStr(postData(urlPath + model,jsonStr,invcType,5000,false));
	}


	
	/**
	 * 重写post请求,设置响应请求时间为30秒,适应于简报
	 * @param urlPath
	 * @param model
	 * @param jsonStr
	 * @param invcType
	 * @return
	 */
	public String postJsonData(String urlPath,String model, String jsonStr, String invcType,int timeOut){
		return JsonUtil.removeSepcStr(postData(urlPath + model,jsonStr,invcType,timeOut,false));
	}
	
	/**
	 * key-value方式post数据
	 */
	public String postKeyValueData(String path, Map<String, String> params) {
		CloseableHttpClient httpclient = HttpClients.createDefault();
		CloseableHttpResponse response = null;
		try {
			HttpEntity entity = null;
			HttpPost httpost = new HttpPost(path); // 引号中的参数是：servlet的地址
			//设置post方式的头信息
			

			List<NameValuePair> nvps = new ArrayList<NameValuePair>();
			for (@SuppressWarnings("rawtypes")Iterator iterator = params.keySet().iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				//放入请求参数
				nvps.add(new BasicNameValuePair(key, params.get(key)));
			}
			
			httpost.setEntity(new UrlEncodedFormEntity(nvps,"UTF-8")); // 将参数传入post方法中

			response = httpclient.execute(httpost); // 执行
			entity = response.getEntity(); // 返回服务器响应
			log.info(response.getStatusLine()); // 服务器返回状态

			if(response.getStatusLine().getStatusCode() != 200){
				log.info("请求地址：【"+httpost + "】出错！！！"); // 服务器返回状态
				return "";
			}
			
			Header[] headers = response.getAllHeaders(); // 返回的HTTP头信息
			for (int i = 0; i < headers.length; i++) {
				log.info(headers[i]);
			}
			String responseString = "";
			if (response.getEntity() != null) {
				responseString = EntityUtils.toString(response.getEntity()); // 返回服务器响应的HTML代码
				log.info(responseString); // 打印出服务器响应的HTML代码
			}
			EntityUtils.consume(entity);
			log.info("-----reponse---------"+responseString); // 服务器返回状态
			return responseString;
		} catch (Exception e) {
			log.info(e.getMessage());
		} finally {
			try {
				response.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return "";
	}
	
	/**
	 * 
	 * @return
	 */
	private String getCrmUrlRoute(String str) throws Exception {
		
		JSONObject jo = JSONObject.fromObject(str);
		
		if(jo.has("orgUrl")){
			String orgUrl = jo.getString("orgUrl");
			logger.info("getCrmUrlRoute　orgUrl =>" + orgUrl);
			if(StringUtils.isNotNullOrEmptyStr(orgUrl)){
				return orgUrl; //getCrmUrlByOrgId(orgUrl);
			}
		}
		
		if(jo.has("initorgid")){
			String initorgid = jo.getString("initorgid");
			logger.info("getCrmUrlRoute　initorgid =>" + initorgid);
			if(StringUtils.isNotNullOrEmptyStr(initorgid)){
				logger.info("getCrmUrlRoute　initorgid =>" + initorgid);
				return getCrmUrlByOrgId(initorgid);
			}
		}
		
		if(jo.has("orgId")){
			String orgId = jo.getString("orgId");
			logger.info("getCrmUrlRoute　orgId =>" + orgId);
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				logger.info("getCrmUrlRoute　orgId =>" + orgId);
				return getCrmUrlByOrgId(orgId);
			}
		}
		
		String rst = "";
		String crmId = jo.getString("crmaccount");
		logger.info("getCrmUrlRoute　crmId =>" + crmId);
		OperatorMobile s = new OperatorMobile();
		s.setCrmId(crmId);
		List<OperatorMobile> opList = getSqlSession().selectList("operatorMobileSql.findOperatorMobileListByFilter", s);
		logger.info("getCrmUrlRoute opList =>" + opList.size());
		if(null != opList && opList.size() > 0){
			OperatorMobile r = (OperatorMobile)opList.get(0);
			String orgId = r.getOrgId();
			rst = getCrmUrlByOrgId(orgId);
		}
		logger.info("getCrmUrlRoute rst =>" + rst);
		return rst;
	}
	
	
	/**
	 * 查询url
	 * @param orgId
	 * @return
	 */
	private String getCrmUrlByOrgId(String orgId){
		if(null == orgId || "".equals(orgId)){
			return "";
		}
		String rst = "";
		//Object sObj = WxCrmCacheUtil.get("Organization_" + orgId);//从缓存中获取菜单访问该状态
		//rst = (sObj == null) ? "" : (String)sObj; 
		//logger.info("getCrmUrlByOrgId rst before=>" + rst);
		//if(!"".equals(rst)) return rst;
		logger.info("getCrmUrlByOrgId rst before=>orgId====" + orgId);
		Organization sorg = new Organization();
		sorg.setId(orgId);
		List<Organization> orgList = getSqlSession().selectList("organizationSql.findOrganizationListByFilter", sorg);
		logger.info("getCrmUrlRoute orgList =>" + orgList.size());
		if(null != orgList && orgList.size() > 0){
			Organization rorg = (Organization)orgList.get(0);
			rst = rorg.getCrmurl();
			EhcacheUtil.put("Organization_" + orgId, rst);
		}
		logger.info("getCrmUrlByOrgId rst =>" + rst);
		return rst;
	}
	
	/**
	 * 通过crmId+feedId判断用户是否订阅
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public String getCrmUserSubFlag(String id)throws Exception{
		String rst = "";
		Object sObj = EhcacheUtil.get("Subcribe_"+id);
		if(null!=sObj){
			return "false";
		}
		Subscribe subscribe = new Subscribe();
		subscribe.setCrmId(id.split(";")[0]);
		subscribe.setFeedid(id.split(";")[1]);
		subscribe.setCurrpages(0);
		subscribe.setPagecounts(999999999);
		List<String> list = getSqlSession().selectList("subscribeSql.findSubscribeListByFilter",subscribe);
		if(list!=null&&list.size()>0&&list.get(0)!=null){
			rst="false";
			EhcacheUtil.put("Subcribe_"+id,rst);
		}else{
			rst="true";
		}
		return rst;
	}
	
	
	
	/**
	 * 通feedId+type获取订阅列表
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public List<Subscribe> getCrmUserSubList(Subscribe subscribe)throws Exception{
		String rst = "";
		List<Subscribe> list= (List<Subscribe>) EhcacheUtil.get("Subcribe_"+subscribe.getFeedid()+";"+subscribe.getType());
		if(null!=list&&list.size()>0){
			return list;
		}
		subscribe.setCurrpages(0);
		subscribe.setPagecounts(999999999);
		list = getSqlSession().selectList("subscribeSql.findSubscribeList",subscribe);
		if(list!=null&&list.size()>0&&list.get(0)!=null){
			EhcacheUtil.put("Subcribe_"+subscribe.getFeedid()+";"+subscribe.getType(),list);
		}
		return list;
	}
	/**
	 * 通过crmId+type判断用户是否订阅
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public String getCrmUserSubRssFlag(String id)throws Exception{
		String rst = "";
		Object sObj = EhcacheUtil.get("SubcribeRss_"+id);
		if(null!=sObj){
			return "false";
		}
		RssNews rssNews = new RssNews();
		rssNews.setCrmId(id.split(";")[0]);
		rssNews.setType(id.split(";")[1]);
		rssNews.setCurrpages(0);
		rssNews.setPagecounts(999999999);
		List<RssNews> list = getSqlSession().selectList("rssNewsSql.findRssNewsListByFilter",rssNews);
		if(list!=null&&list.size()>0&&list.get(0)!=null){
			rst="false";
			EhcacheUtil.put("SubcribeRss_"+id,rst);
		}else{
			rst="true";
		}
		return rst;
	}
	
	/**
	 * 移除指定的元素(内部订阅)
	 * @param id
	 * @throws Exception
	 */
	public void removeSubFlag(String id)throws Exception{
		EhcacheUtil.remove("Subcribe_"+id);
	}
	
	/**
	 * 移除指定的元素(外部订阅)
	 * @param id
	 * @throws Exception
	 */
	public void removeSubRssFlag(String id)throws Exception{
		EhcacheUtil.remove("SubcribeRss_"+id);
	}
	
	public static void main(String[] args) throws Exception {
	}
}
