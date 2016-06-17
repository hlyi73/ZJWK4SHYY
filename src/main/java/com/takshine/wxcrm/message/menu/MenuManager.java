package com.takshine.wxcrm.message.menu;



import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.apache.log4j.Logger;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.message.oauth.AccessToken;

/**
 * 菜单管理器类
 * 
 * @author liulin
 * @date 2014-02-26
 */
public class MenuManager {
	private static Logger log = Logger.getLogger(MenuManager.class.getName());

	public static void main(String[] args) {
		
		// 调用接口获取access_token
		AccessToken at = WxUtil.getAccessToken("wx8a0246a7c339833e", "a51f4512b732ec5a8db0eb9412521f46");
		
		log.info("access_token =>" + at.getToken());
		log.info("expires_in =>" + at.getExpiresIn());

		if (null != at) {
			// 调用接口创建菜单
			int result = WxUtil.createMenu(getMenu(), at.getToken());

			// 判断菜单创建结果
			if (0 == result)
				log.info("菜单创建成功！");
			else
				log.info("菜单创建失败，错误码：" + result);
		}
	}

	/**
	 * 组装菜单数据
	 * 
	 * @return
	 */
	private static Menu getMenu() {
			
		CommonButton btn12 = new CommonButton();
		btn12.setName("客户管理");
		btn12.setType("click");
		btn12.setKey("12");

		CommonButton btn13 = new CommonButton();
		btn13.setName("业务机会管理");
		btn13.setType("click");
		btn13.setKey("13");

		CommonButton btn14 = new CommonButton();
		btn14.setName("联系人管理");
		btn14.setType("click");
		btn14.setKey("14");
		
		CommonButton btn15 = new CommonButton();
		btn15.setName("合同管理");
		btn15.setType("click");
		btn15.setKey("15");

		CommonButton btn22 = new CommonButton();
		btn22.setName("日程");
		btn22.setType("click");
		btn22.setKey("22");
		
		CommonButton btn23 = new CommonButton();
		btn23.setName("费用报销");
		btn23.setType("click");
		btn23.setKey("23");
		
		CommonButton btn24 = new CommonButton();
		btn24.setName("活动流");
		btn24.setType("click");
		btn24.setKey("24");
		
		CommonButton btn31 = new CommonButton();
		btn31.setName("账号绑定");
		btn31.setType("click");
		btn31.setKey("31");
		
		CommonButton btn32 = new CommonButton();
		btn32.setName("账号注销");
		btn32.setType("click");
		btn32.setKey("32");

		CommonButton btn33 = new CommonButton();
		btn33.setName("帮助");
		btn33.setType("click");
		btn33.setKey("33");
		
		ViewButton btn34 = new ViewButton();
		btn34.setName("指尖微客");
		String return_url = "http://zjuat.fingercrm.cn/ZJWK/home/index";
//		try {
//			return_url = URLEncoder.encode(return_url,"UTF-8");
//		} catch (UnsupportedEncodingException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		//String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+PropertiesUtil.getAppContext("wxcrm.appid")+"&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
		btn34.setUrl(return_url);
		btn34.setType("view");
		
		
		ComplexButton mainBtn1 = new ComplexButton();
		mainBtn1.setName("生意");
		mainBtn1.setSub_button(new Button[] {  btn12, btn13 ,btn14,btn15});

		ComplexButton mainBtn2 = new ComplexButton();
		mainBtn2.setName("任务");
		mainBtn2.setSub_button(new Button[] { btn22,btn23,btn24 });
		
		ComplexButton mainBtn3 = new ComplexButton();
		mainBtn3.setName("更多");
		mainBtn3.setSub_button(new Button[] { btn31,btn32,btn34});
		
		/**
		 * 这是公众号xiaoqrobot目前的菜单结构，每个一级菜单都有二级菜单项<br>
		 * 
		 * 在某个一级菜单下没有二级菜单的情况，menu该如何定义呢？<br>
		 * 比如，第三个一级菜单项不是“更多体验”，而直接是“幽默笑话”，那么menu应该这样定义：<br>
		 * menu.setButton(new Button[] { mainBtn1, mainBtn2, btn33 });
		 */
		Menu menu = new Menu();
		//menu.setButton(new Button[] { mainBtn1, mainBtn2, mainBtn3 });
		menu.setButton(new Button[] { btn34});
		
		return menu;
	}
}