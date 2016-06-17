package com.takshine.wxcrm.base.util;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 调用外部接口 工具类统一汇总
 * 
 * @author liulin
 *
 */
public class InvokeUtil {
	// 日志
	private static Log out01 = LogFactory.getLog("out01");
	
	private static WxHttpConUtil util = new WxHttpConUtil();
	//指尖微客URL
	private static String ZJRM_URL = PropertiesUtil.getAppContext("zjrm.url");
	//指尖人脉-> 判断是否在群里面
	private static String RM_ISINGROUP = "/out/group/isingroup";
	//指尖人脉-> 同意入群
	private static String RM_GROUP_AGREE = "/out/group/agree";

	/**
	 * 判断用户是否在群中
	 * @param partyId
	 * @return
	 */
	public static String isInGroup(String group_id, String target_uid) {
		out01.info("group_id = >" + group_id);
		out01.info("target_uid = >" + target_uid);
		if(StringUtils.isNotBlank(group_id) 
				&& StringUtils.isNotBlank(target_uid)){
			String url = ZJRM_URL + RM_ISINGROUP;
			out01.info("url = >" + url);
			Map<String, String> params = new HashMap<String, String>();
			params.put("group_id", group_id);
			params.put("target_uid", target_uid);
			String rst = util.postKeyValueData(url, params);
			out01.info("InvokeUtil isInGroup rst = >" + rst);
			// 做空判断
			if (StringUtils.isNotBlank(rst)) {
				// 解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst);
				String errorCode = jsonObject.getString("errorCode");
				out01.info("errorCode = >" + errorCode);
				if("0".equals(errorCode)){
					String isInGroupFlag = jsonObject.getString("isInGroupFlag");
					out01.info("isInGroupFlag = >" + isInGroupFlag);
					return isInGroupFlag;
				}
			}
		}
		return "";
	}
	
	/**
	 * 同意入群
	 * @param partyId
	 * @return
	 */
	public static String groupAgree(String group_id, String target_uid) {
		out01.info("group_id = >" + group_id);
		out01.info("target_uid = >" + target_uid);
		if(StringUtils.isNotBlank(group_id) 
				&& StringUtils.isNotBlank(target_uid)){
			String url = ZJRM_URL + RM_GROUP_AGREE;
			out01.info("url = >" + url);
			Map<String, String> params = new HashMap<String, String>();
			params.put("group_id", group_id);
			params.put("target_uid", target_uid);
			String rst = util.postKeyValueData(url, params);
			out01.info("InvokeUtil groupAgree rst = >" + rst);
			// 做空判断
			if (StringUtils.isNotBlank(rst)) {
				// 解析JSON数据
				JSONObject jsonObject = JSONObject.fromObject(rst);
				String errorCode = jsonObject.getString("errorCode");
				out01.info("errorCode = >" + errorCode);
				if("0".equals(errorCode)){
					return "success";
				}
			}
		}
		return "fail";
	}
}
