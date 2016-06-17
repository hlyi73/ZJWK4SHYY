package com.takshine.wxcrm.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.ArticleInfo;
import com.takshine.wxcrm.domain.ArticleType;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.ArticleTypeService;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;

/**
 * 
 * 传播PC端控制类
 * 
 * @author huangpeng 2014-08-06
 * 
 */
@Controller
@RequestMapping("/pccomm")
public class PCCommunicationController {

	// 日志
	protected static Logger logger = Logger.getLogger(ContactController.class
			.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	@RequestMapping("/list")
	@SuppressWarnings("unchecked")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		logger.info("PCCommController list method begin=>");
		String orgId = request.getParameter("orgId");
		String type = request.getParameter("type");
		ArticleInfo articleInfo = new ArticleInfo();
		// 获取导航类型动态值
		articleInfo.setCurrpage(null);
		articleInfo.setPagecount(null);
		articleInfo.setTypeName(type);
		articleInfo.setOrgId(orgId);
		// 得到文章数据
		List<ArticleInfo> mlist = (List<ArticleInfo>) cRMService.getDbService().getArticleInfoService()
				.findObjListByFilter(articleInfo);
		request.setAttribute("mlist", mlist);
		// }
		return "pc/communication/list";
	}

	@RequestMapping("/get")
	@SuppressWarnings("unchecked")
	public String add(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentId = request.getParameter("parentId");// 关联ID
		String parentType = request.getParameter("parentType");// 关联类型
		String crmId = cRMService.getSugarService().getContact2SugarService().getCrmId(openId, publicId);

		OperatorMobile operatorMobile = new OperatorMobile();
		operatorMobile.setCrmId(crmId);
		List<OperatorMobile> list = (List<OperatorMobile>) cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(operatorMobile);
		ArticleInfo articleInfo = new ArticleInfo();
		articleInfo.setOrgId(list.get(0).getOrgId());
		String orgId = list.get(0).getOrgId();

		// 查询org name
		Organization searOrg = new Organization();
		searOrg.setId(orgId);
		List<Organization> orgList = (List<Organization>) cRMService.getDbService().getOrganizationService()
				.findObjListByFilter(searOrg);
		if (orgList.size() > 0) {
			request.setAttribute("orgName", orgList.get(0).getName());
		}
		//
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			// 各种参数
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentType", parentType);
			request.setAttribute("crmId", crmId);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("orgId", orgId);
			// 获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			currResp.getUsers();
			if (null != currResp.getUsers()
					&& null != currResp.getUsers().get(0).getUsername()) {
				request.setAttribute("assignerid", currResp.getUsers().get(0)
						.getUserid());
			}
			// 获取文章类型
			List<ArticleType> artTypeList = cRMService.getDbService().getArticleTypeService()
					.findArticleTypeByFilter(null);
			for (int i = 0; i < artTypeList.size(); i++) {
				artTypeList.get(i).getName();
			}
		}
		return "pc/communication/index";
	}

	@RequestMapping("/save")
	public String save(ArticleInfo art, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String typeId = request.getParameter("typeId");
		String typeName = request.getParameter("typeName");
		String title = request.getParameter("title");
		String descrition = request.getParameter("descrition");
		String content = request.getParameter("content");
		String status = request.getParameter("status");
		String orgId = request.getParameter("orgId");
		String date = request.getParameter("bxDateInput");
		String assignerId = request.getParameter("assignerid");
		String image = request.getParameter("filename");
		// 日期格式转换
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = format.parse(date);

		if (!"".equals(typeId) && !StringUtils.regZh(typeId)) {
			art.setTypeId(new String(typeId.getBytes("ISO-8859-1"), "UTF-8"));
		}
		if (!"".equals(typeName) && !StringUtils.regZh(typeName)) {
			art.setTypeName(new String(typeName.getBytes("ISO-8859-1"), "UTF-8"));
		}
		if (!"".equals(title) && !StringUtils.regZh(title)) {
			art.setTitle(new String(title.getBytes("ISO-8859-1"), "UTF-8"));
		}
		if (!"".equals(descrition) && !StringUtils.regZh(descrition)) {
			art.setDescrition(new String(descrition.getBytes("ISO-8859-1"),
					"UTF-8"));
		}
		if (!"".equals(content) && !StringUtils.regZh(content)) {
			art.setContent(new String(content.getBytes("ISO-8859-1"), "UTF-8"));
		}
		if (!"".equals(status) && !StringUtils.regZh(status)) {
			art.setStatus(new String(status.getBytes("ISO-8859-1"), "UTF-8"));
		}
		art.setOrgId(orgId);
		art.setCreateTime(time);
		art.setCreateBy(assignerId);
		art.setImage(image);
		// save
		String id = cRMService.getDbService().getArticleInfoService().addObj(art);
		logger.info("PCCommController save method id=>" + id);
		return "pc/communication/list";
	}

	@RequestMapping("/pc_detail")
	public String pc_detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");

		OperatorMobile operatorMobile = new OperatorMobile();
		List<OperatorMobile> list = (List<OperatorMobile>) cRMService.getDbService().getOperatorMobileService()
				.getOperMobileListByPara(operatorMobile);
		ArticleInfo articleInfo = new ArticleInfo();
		
		articleInfo.setId(id);
		String orgId = list.get(0).getOrgId();
		
		// 根据ID查找该条记录信息
		articleInfo.setOrgId(list.get(0).getOrgId());
		ArticleInfo aInfo = (ArticleInfo) cRMService.getDbService().getArticleInfoService().findObjById(id);

		request.setAttribute("aInfo", aInfo);
		request.setAttribute("title", aInfo.getTitle());
		request.setAttribute("id", id);

		return "pc/communication/pc_detail";
	}

	@RequestMapping("/delete")
	public String delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String id = request.getParameter("id");
		logger.info("pccomm delete method >= ----------------------------------------------------------------------------------"
				+ id);
		ArticleInfo articleInfo = new ArticleInfo();
		articleInfo.setId(id);
		cRMService.getDbService().getArticleInfoService().deleteObjById(id);
		return null;
	}

	
	
	
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	   
	   String id = request.getParameter("id");
	   logger.info("poccomm modify method  id >====----------------------"+id);
	   OperatorMobile operatorMobile = new OperatorMobile();
		List<OperatorMobile> list = (List<OperatorMobile>) cRMService.getDbService().getOperatorMobileService()
				.getOperMobileListByPara(operatorMobile);
		ArticleInfo articleInfo = new ArticleInfo();
		articleInfo.setId(id);
		//根据ID查文章信息
		ArticleInfo aInfo = (ArticleInfo)cRMService.getDbService().getArticleInfoService().findObjById(id);
		// 获取文章类型
		List<ArticleType> artTypeList = cRMService.getDbService().getArticleTypeService()
				.findArticleTypeByFilter(null);
		for (int i = 0; i < artTypeList.size(); i++) {
			artTypeList.get(i).getName();
		}
		request.setAttribute("aInfo", aInfo);
		logger.info("poccomm modify method  aInfo >====----------------------"+aInfo);
		return "pc/communication/modify";
	}
}
