package com.takshine.core.service.business.impl;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.LOVService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.message.sugar.CustomerAdd;

/**
 * 系统中微信通用接口
 * @author dengbo
 *
 */
@Service("lOVService")
public class LOVServiceImpl implements LOVService {
	protected static Logger logger = Logger.getLogger(LOVServiceImpl.class
			.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public Map<String, Map<String, String>> getLovValues(
			HttpServletRequest request) throws CRMException {
		try {
			
			// 绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			// 获取绑定的账户 在sugar系统的id
			if (!"".equals(crmId)) {
				return cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			}
			throw new CRMException(ErrCode.ERR_CODE_1001001,ErrCode.ERR_MSG_UNBIND);
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN);
		}
	}


}
