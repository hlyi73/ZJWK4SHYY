package com.takshine.wxcrm.interceptors;

import java.util.Iterator;
import java.util.Map;
import java.util.Queue;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.ServiceUtils;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.service.AccessLogsService;

/**
 * 访问日志  拦截器
 * @author liulin
 *
 */
public class AccessLogsInterceptor implements HandlerInterceptor {

	private static Logger log = Logger.getLogger(AccessLogsInterceptor.class.getName());
	
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 视图渲染后拦截
	 */
	//@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	/**
	 * 试图渲染前拦截
	 */
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	/**
	 * 前置拦截回调
	 */
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		StringBuffer url = request.getRequestURL();
		log.info("------------------------进入服务器 02----: "+DateTime.long2DateTime(System.currentTimeMillis()) + "【"+url+"】");
		log.info("------------------------url.indexOf('coreServlet') 02----: "+ url.indexOf("coreServlet"));
        if(url.indexOf("coreServlet") != -1){
        	log.info("------------------------coreservlet true 02----: ");
        	return true;
        }
		long startTime = System.currentTimeMillis();
        log.info("AccessLogsInterceptor preHandle Request URL::" + request.getRequestURL().toString()
                + ":: Start Time=" + System.currentTimeMillis());
        request.setAttribute("startTime", startTime);
		if(url.indexOf("/wxuser/getUser") == -1 
				&& url.indexOf("/msgs/syncmsglist") == -1
				&& url.indexOf("/feed/allfeedlist") == -1
				&& url.indexOf("/msgs/syncmsgcount") == -1
				&& url.indexOf("/wxuser/getImgHeader") == -1
				&& url.indexOf("/wxuser/getImgHeader") == -1
				&& url.indexOf("/lovuser/attenuserlist") == -1
				&& url.indexOf("/lovuser/userlist") == -1
				&& url.indexOf("/entr/access") == -1 
				&& url.indexOf("/teampeason/asynclist") == -1
				&& url.indexOf("/oppty/searchcache") == -1
				&& url.indexOf("/starModel/isStar") == -1
				&& url.indexOf("/msgs/asynclist") == -1
				&& url.indexOf("/modelTag/list") == -1
				&& url.indexOf("/f/") == -1
				&& url.indexOf("/dcCrm/psumry") == -1
				&& url.indexOf("/customer/searchcache") == -1
				&& url.indexOf("/fchart/list") == -1){
			//访问日志
			accessLogHandler(request);
		}
        return true;
	}
	
	/**
	 * 访问日志
	 */
	private void accessLogHandler(HttpServletRequest request ) throws Exception{
		
		if(!UserUtil.hasCurrUser(request)){
			return;
		}
		
		String reqUrl = request.getRequestURL().toString();
		
		AccessLogs accLog = new AccessLogs();
        accLog.setId(Get32Primarykey.getRandom32BeginTimePK());
        accLog.setCreateTime(DateTime.currentDate());
        accLog.setIp(getIpAddr(request));
        accLog.setUrl(reqUrl);
        try{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");
			String crmId = request.getParameter("crmId");
			String orgId = request.getParameter("orgId");
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				orgId = cRMService.getDbService().getAccessLogsService().getOrgId(openId, publicId, crmId);
			}
			accLog.setOrgId(orgId);
			String partyId = UserUtil.getCurrUser(request).getParty_row_id();
			accLog.setPartyId(partyId);
        }catch(Exception e){
        	log.info("未找到openId,请求地址："+reqUrl);
        }
        //参数
        String paraStr = "";
        Map<String, String[]> params =  request.getParameterMap();
        for (Iterator<String> iterator = params.keySet().iterator(); iterator.hasNext();) {
			String signPara = iterator.next();
			if("content".equals(signPara)){
				continue;
			}
			String [] signParaVal = params.get(signPara);
			paraStr += signPara + "=" + StringUtils.arrToStr(signParaVal) + "&";
		}
        	accLog.setParams(paraStr);
        
		//访问控制
        logQueue.add(accLog);
 	}
	public static final Queue<AccessLogs> logQueue = new java.util.concurrent.ConcurrentLinkedQueue<AccessLogs>();
	static{
		new WriteLogThread().start();
	}
	/**
	 * 独立线程保存 日志
	 * @author 易海龙
	 *
	 */
	static class WriteLogThread extends Thread{
		public void run(){
			while(true){
				try{
					while(logQueue.size() > 0){
						AccessLogs accLog = null;
						try {
							accLog = logQueue.poll();
							ServiceUtils.getCRMService().getDbService().getAccessLogsService().addObj(accLog);
						} catch (Exception e) {
							e.printStackTrace();
							if (accLog!=null){
								logQueue.add(accLog);
							}
							throw e;
						}
					}
				}catch(Exception ec){
					
				}
				try {
					Thread.sleep(100);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 獲得IP地址
	 * @param request
	 * @return
	 */
	private  String getIpAddr(HttpServletRequest request) {
		 String ip = request.getHeader("x-forwarded-for");
		 if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		  ip = request.getHeader("Proxy-Client-IP");
		 }
		 if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		  ip = request.getHeader("WL-Proxy-Client-IP");
		 }
		 if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		  ip = request.getRemoteAddr();
		 }
		 if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		  ip = request.getHeader("http_client_ip");
		 }
		 if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		  ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		 }
		 // 如果是多级代理，那么取第一个ip为客户ip
		 if (ip != null && ip.indexOf(",") != -1) {
		  ip = ip.substring(ip.lastIndexOf(",") + 1, ip.length()).trim();
		 }
		 //logger.info("AccessLogsInterceptor getIpAddr is= >" + ip);
		 return ip;
	}

}
