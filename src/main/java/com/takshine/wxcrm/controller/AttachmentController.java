package com.takshine.wxcrm.controller;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Attachment;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.message.error.CrmError;

/**
 * 附件的控制类
 * 
 * @author liulin
 *
 */
@Controller
@RequestMapping("/attachment")
public class AttachmentController {
	// 日志
	protected static Logger logger = Logger.getLogger(AttachmentController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询附件列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String id = request.getParameter("id");
		//附件
		List<Attachment> attList = new ArrayList<Attachment>();
		if(UserUtil.hasCurrUser(request)){
			attList = cRMService.getDbService().getAttachmentService().getActivityAttachmentListByActId(id);
		}
		String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
		//request.setAttribute("zjwk_file_service", PropertiesUtil.getAppContext("zjmarketing.file.service.userpath"));
		request.setAttribute("zjwk_file_service", ossImgPath);
		request.setAttribute("attList", attList);
		return "attachment/list";
	}

	/**
	 * 异步查询附件列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asycnlist")
	@ResponseBody
	public String asycnlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("CustomerController acclist method begin=>");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String parentid = request.getParameter("parentid");
		String parenttype = request.getParameter("parenttype");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);

		logger.info("AttachmentController list method openId =>" + openId);
		logger.info("AttachmentController list method publicId =>" + publicId);
		logger.info("AttachmentController list method currpage =>" + currpage);
		logger.info("AttachmentController list method pagecount =>" + pagecount);

		// 绑定对象
		String crmId = cRMService.getSugarService().getAttachment2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		// error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
//			Attachment attachment = new Attachment();
//			attachment.setCrmId(crmId);
//			AttachmentResp sResp = cRMService.getSugarService().getAttachment2CrmService().getAttachmentList(attachment, "WEB");
//
//			String errorCode = sResp.getErrcode();
//			if (ErrCode.ERR_CODE_0.equals(errorCode)) {
//				List<AttachmentAdd> list = sResp.getDatas();
//				str = JSONArray.fromObject(list).toString();
//				logger.info("str:-> is =" + str);
//				return str;
//			} else {
//				crmErr.setErrorCode(sResp.getErrcode());
//				crmErr.setErrorMsg(sResp.getErrmsg());
//			}
		} else {
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return str = JSONObject.fromObject(crmErr).toString();
	}

	/**
	 * 附件下载
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/download")
	@ResponseBody
	public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("download=>");
		String id = request.getParameter("id");
		String fileName = request.getParameter("fileName");
		String type = request.getParameter("type");

		logger.info("type=>" + type);
		try {
			String contentType = type + ";charset=GBK";
			if (StringUtils.isNotNullOrEmptyStr(fileName)) {
				fileName = URLDecoder.decode(fileName, "UTF-8");
				fileName = new String(fileName.getBytes("ISO-8859-1"), "UTF-8");
			}
			logger.info("fileName=>" + fileName);
			ServletOutputStream out = response.getOutputStream();
			logger.info("url=>" + PropertiesUtil.getAppContext("sugar.service") + "/downloadfile.php?id=" + id);
			getUrlFileData(PropertiesUtil.getAppContext("sugar.service") + "/downloadfile.php?id=" + id,out);
			
			response.setCharacterEncoding("utf-8");  
			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			response.setContentType(contentType);
			out.flush();
			out.close();

		} catch (Exception e) {
			logger.error("下载文件出现异常" + e.toString());
		}
	}

	// 获取链接地址文件的byte数据
	private void getUrlFileData(String fileUrl,OutputStream out) throws Exception {
		URL url = new URL(fileUrl);
		HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
		httpConn.connect();
		InputStream cin = httpConn.getInputStream();
		//ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = cin.read(buffer)) != -1) {
			out.write(buffer, 0, len);
		}
		cin.close();
		//byte[] fileData = outStream.toByteArray();
		//outStream.close();
		//return fileData;
	}
	
}
