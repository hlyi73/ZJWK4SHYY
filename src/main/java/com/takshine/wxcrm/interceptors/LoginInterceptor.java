package com.takshine.wxcrm.interceptors;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;


/**
 * 登录 拦截器
 * @author liulin
 *
 */
public class LoginInterceptor implements HandlerInterceptor {

	private static Logger logger = Logger.getLogger(LoginInterceptor.class.getName());
	
	// 用户和手机绑定关系  服务
	@Autowired
	@Qualifier("lovUser2SugarService")
	private LovUser2SugarService lovUser2SugarService;
	
	// 微信用户  服务
	@Autowired
	@Qualifier("wxUserinfoService")
	private WxUserinfoService wxUserinfoService;
	
	/**
	 * 视图渲染后拦截
	 */
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
        logger.info("------------------------返回---: "+DateTime.long2DateTime(System.currentTimeMillis()) + "【"+request.getRequestURL()+"】");
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
		long startTime = System.currentTimeMillis();
		StringBuffer url = request.getRequestURL();
        request.setAttribute("startTime", startTime);
        logger.info("------------------------进入服务器----: "+DateTime.long2DateTime(System.currentTimeMillis()) + "【"+url+"】");
        logger.info("------------------------url.indexOf('coreServlet')----: "+ url.indexOf("coreServlet"));
        if(url.indexOf("coreServlet") != -1){
        	 logger.info("------------------------coreservlet true----: ");
        	return true;
        }
		String userAgent = request.getHeader("User-Agent");
		logger.info("userAgent =>" + userAgent);
		if(userAgent.contains("MicroMessenger")){
			logger.info("userAgent contains MicroMessenger=> ");
		}
		
		//验证是否有消息队列
		Map<String, String> map1 = RedisCacheUtil.getStringMapAll(Constants.ZJWK_NOTICE_SEND);
		if(null!=map1&&map1.keySet().size()>0){
			String openId = UserUtil.getCurrUser(request).getOpenId();
			//若包含，则删除当前登录人的消息
			if(map1.keySet().contains(openId)){
				map1.remove(openId);
			}
			RedisCacheUtil.putStringToMap(Constants.ZJWK_NOTICE_SEND,map1);
		}
		//检查面登陆的url
		if(!InterceptUtil.checkNoLoginUrl(url.toString())){
			// 验证Session
			UserUtil.getCurrUser(request);
			
			saveLoginTime(request);
		}
		
		return true;
	}
	
	/**
	 * 记录当前用户最后一次登录时间
	 * @param request
	 */
	private void saveLoginTime(HttpServletRequest request) throws Exception{
		// 登陆用户对象
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		
		String loginTime = DateTime.currentDateTime(DateTime.DateTimeFormat1);
		HashMap<String, String> paramContain = new HashMap<String, String>();
		paramContain.put("loginTime", loginTime);
		paramContain.put("partyId", partyId);
		paramContain.put("openId", openId);
		RedisCacheUtil.set(Constants.LOGINTIME_KEY + "_" + partyId, paramContain);
		RedisCacheUtil.set(Constants.LOGINTIME_KEY + "_" + openId, paramContain);
	}
	
}
