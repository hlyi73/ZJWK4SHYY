/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.ArticleInfo;
import com.takshine.wxcrm.domain.ArticleType;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.AccessLogsService;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.ArticleTypeService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;

/**
 * 文章信息 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/articleInfo")
public class ArticleInfoController {
	// 日志
	protected static Logger logger = Logger
			.getLogger(ArticleInfoController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询所有传播信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		//通过openId,publicId来拿到crmId
		String crmId = cRMService.getDbService().getArticleInfoService().getCrmId(openId, publicId);
		String typeId = request.getParameter("typeId");
		String typeName = request.getParameter("typeName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		//如果导航类型等于null，默认等于compProf，如果不等于null，就等于当前值
		typeName = (typeName == null) ? "compProf" : typeName;
		//模糊查询标题
		String title = request.getParameter("title");

		if (null != title)
			title = "%" + title + "%";

		request.setAttribute("typeName", typeName);

		if (null != title)title = "%" + title + "%";

		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			List<OperatorMobile> list = (List<OperatorMobile>) cRMService.getDbService().getOperatorMobileService()
					.getOperMobileListByPara(operatorMobile);
			ArticleInfo articleInfo = new ArticleInfo();
			articleInfo.setTypeId(typeId);
			articleInfo.setTypeName(typeName);
			articleInfo.setTitle(title);

			// 获取导航类型动态值
			List<ArticleType> artTypeList = cRMService.getDbService().getArticleTypeService()
					.findArticleTypeByFilter(null);

			if (StringUtils.isNotNullOrEmptyStr(startDate)) {
				articleInfo.setStartDate(startDate);
			}
			if (StringUtils.isNotNullOrEmptyStr(endDate)) {
				articleInfo.setEndDate(endDate);
			}
			articleInfo.setCurrpage(null);
			articleInfo.setPagecount(null);
			articleInfo.setOrgId(list.get(0).getOrgId());
			List<ArticleInfo> mlist = (List<ArticleInfo>) cRMService.getDbService().getArticleInfoService()
					.findObjListByFilter(articleInfo);
			System.out.println(mlist.size());
			request.setAttribute("mlist", mlist);
			request.setAttribute("artTypeList", artTypeList);
		} else {
			// 抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}


		/*// 对导航类型进行判断
		if ("compProf".equals(typeName)) {
			return "communications/list";

		} else if ("compNews".equals(typeName)) {
			return "communications/list";

		} else if ("compProd".equals(typeName)) {
			return "communications/list";

		} else if ("compIntro".equals(typeName)) {
			return "communications/list";*/

		request.setAttribute("typeName", typeName);

		return "communications/list";
	}

	/**
	 * 查询单个传播信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String crmId = cRMService.getDbService().getArticleInfoService().getCrmId(openId, publicId);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			OperatorMobile operatorMobile = new OperatorMobile();
			operatorMobile.setCrmId(crmId);
			List<OperatorMobile> list = (List<OperatorMobile>) cRMService.getDbService().getOperatorMobileService()
					.getOperMobileListByPara(operatorMobile);
			ArticleInfo articleInfo = new ArticleInfo();
			articleInfo.setId(id);

			// 拿到orgId
			articleInfo.setOrgId(list.get(0).getOrgId());
			ArticleInfo aInfo = (ArticleInfo) cRMService.getDbService().getArticleInfoService()
					.findObjById(id);

			// 获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			currResp.getUsers();
			if (null != currResp.getUsers()
					&& null != currResp.getUsers().get(0).getUsername()) {
				request.setAttribute("userName", currResp.getUsers().get(0)
						.getUsername());
			}

			// 统计访问数量
			String accessAount = cRMService.getDbService().getAccessLogsService().countAccessLogs(crmId,
					"articleInfo/detail", "id=" + id, null, null);
			logger.info("detail accessAount =>" + accessAount);
			request.setAttribute("accessAount", accessAount);

			request.setAttribute("aInfo", aInfo);
			request.setAttribute("title", aInfo.getTitle());
			request.setAttribute("crmId", crmId);
			request.setAttribute("id", id);

		} else {
			// 抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		//分享控制按钮
		request.setAttribute("appid", Constants.APPID);
		request.setAttribute("appcontent",  PropertiesUtil.getAppContext("app.content"));
		return "communications/detail";
	}
}