package com.takshine.wxcrm.base.util;

import com.takshine.core.service.CRMService;

public class ServiceUtils {
	public static CRMService cRMService = null;

	public static CRMService getCRMService() {
		if (cRMService == null){
			throw new RuntimeException("服务还未初始化完！");
		}
		return cRMService;
	}

	public static void setCRMService(CRMService cRMService) {
		ServiceUtils.cRMService = cRMService;
	}

}
