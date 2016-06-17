package com.takshine.wxcrm.base.util.runtime;

import java.util.HashMap;
import java.util.Map;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.PropertiesUtil;

public class SMSSentThread implements ThreadRun {
	String code;
	String mobile;
	String content;
	public SMSSentThread(String code,String mobile,String content){
		this.code = code;
		this.mobile = mobile;
		this.content = content;
	}

	public void run() throws CRMException {
		Map<String, Object> msgMap = new HashMap<String, Object>();
		String url = PropertiesUtil.getMsgContext("service.url1");
		msgMap.put("code", code);
		msgMap.put("mobile", mobile);
		msgMap.put("content", content);
		try {
			HttpClient3Post.request(url, msgMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
