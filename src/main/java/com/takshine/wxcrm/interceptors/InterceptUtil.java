package com.takshine.wxcrm.interceptors;

import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class InterceptUtil {
	
	private static Logger log = Logger.getLogger(InterceptUtil.class.getName());
	
	private static Set<String> urlset_nologin = new HashSet<String>();// 不需要登陆的url集合
	
	private static void initData() {
		urlset_nologin.add("home/index");//主页
		urlset_nologin.add("/home/valicode");//主页验证码
		urlset_nologin.add("coreServlet");//微信核心拦截
		urlset_nologin.add("/entr/access");//消息统一入口
		urlset_nologin.add("/msgentr/access");
		urlset_nologin.add("/login/login");
		urlset_nologin.add("/login/auth");//
		urlset_nologin.add("/login/qrcode");//
		urlset_nologin.add("/oppty/wk_oppty_save");//
		urlset_nologin.add("/contact/wk_contact_save_json");//
		urlset_nologin.add("/operorg/synorglist");//
		urlset_nologin.add("/out/");//外部系统对内的访问
		urlset_nologin.add("/zjactivity/teamMembers");//团队成员
		urlset_nologin.add("/wxuser/isAtten");//
		urlset_nologin.add("/wxjs/getsign");//
		urlset_nologin.add("/out/sync_act");//
		urlset_nologin.add("/f/");//
		urlset_nologin.add("/login/");//
		urlset_nologin.add("/dcCrm/psumry");//统计页面
		urlset_nologin.add("/userRela/zjlist");//
		urlset_nologin.add("/businesscard/checkemail");//检查email页面
		urlset_nologin.add("/zjwkactivity/new_detail");//活动 从SMS短信页面访问的链接
		urlset_nologin.add("/zjwkactivity/new_meetdetail");//聚会 从SMS短信页面访问的链接
		urlset_nologin.add("/discuGroup/detail_fsms");//讨论组 从SMS短信页面访问的链接
		urlset_nologin.add("/participant/sendMsg");//活动，发送短信获取验证码
		urlset_nologin.add("/participant/save");//活动，非session报名 
		urlset_nologin.add("/lovuser/initlovcache");//初始化lov数据
		urlset_nologin.add("/resource/detail");//文章详情不校验session
		urlset_nologin.add("/msgs/asynclist");//异步加载消息
		
		urlset_nologin.add("/workplan/workPlansForAutoEmail");//取工作计划发邮件不校验session
	}

	/**
	 * 检查不需要登陆的 url
	 * 
	 * @param url
	 * @return
	 */
	public static boolean checkNoLoginUrl(String url) {
		log.info("checkNoLoginUrl url = >" + url);
		if(urlset_nologin.isEmpty()){
			initData();
		}
		if(StringUtils.isNotBlank(url)){
			for (String pv : urlset_nologin) {
				if(url.indexOf(pv) != -1){
					return true;
				}
			}
		}
		return false;
	}
}
