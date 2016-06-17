/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.UserRelaService;

/**
 * 多的通讯录
 * 
 * 
 */
@Controller
@RequestMapping("/cbooks")
public class ContactBooksController {
	// 日志
	protected static Logger logger = Logger
			.getLogger(ContactBooksController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	

	/**
	 * 
	 * 通讯录首页
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		boolean outFlag = false;
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			//获取联系人
			Contact contact = new Contact();
		    contact.setCrmId(crmId);
			contact.setPagecount(null);
			contact.setCurrpage("1");
			contact.setPagecount(Constants.ALL_PAGECOUNT +"");
			contact.setViewtype(Constants.SEARCH_VIEW_TYPE_MYALLVIEW);
			contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			
			ContactResp cResp = new ContactResp();
			String parentId = request.getParameter("parentId");
			String parentType = request.getParameter("parentType");
			String orgId = request.getParameter("orgId");
			contact.setOrgId(orgId);
			//如果是个人账户的查询，则只查询 缓存表的数据 不用调用后台
			if("Default Organization".equals(contact.getOrgId()) 
					|| !StringUtils.isNotNullOrEmptyStr(contact.getOrgId())){
				contact.setViewtype("");
			}
			
			if (StringUtils.isNotNullOrEmptyStr(parentId) && StringUtils.isNotNullOrEmptyStr(parentType))
			{
				cResp = cRMService.getSugarService().getContact2SugarService().getContactList(contact, "WEB");
				request.setAttribute("parentId", parentId);
				request.setAttribute("parentType", parentType);
				outFlag = true;
			}
			else
			{
				cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
			}
			request.setAttribute("orgId", orgId);
			List<ContactAdd> list = cResp.getContacts();
			
			//获取我的好友
			UserRela userRela = new UserRela();
			userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
			userRela.setCurrpages(Constants.ZERO);
			userRela.setPagecounts(Constants.ALL_PAGECOUNT);
			List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
			
			List<String> charList = new ArrayList<String>();
			
			// 放到页面上
			if (null != list && list.size() > 0) {
				ContactAdd con = null;
				for(int i=0;i<list.size();i++){
					con = list.get(i);
					if(con.getFirstname() != null && !charList.contains(con.getFirstname())){
						charList.add(con.getFirstname());
					}
				}
			} else {
				list = new ArrayList<ContactAdd>();
			}
			if(null != userRelaList && userRelaList.size() >0){
				UserRela ur = null;
				for(int i=0;i<userRelaList.size();i++){
					ur = userRelaList.get(i);
					list.add(transUserRela(ur,charList));
				}
			}
			//获取首字母集合
			//首字母排序
			Collections.sort(charList);
			 Collections.sort(list,new Comparator<ContactAdd>(){
		            public int compare(ContactAdd arg0, ContactAdd arg1) {
		                return arg0.getConname().compareTo(arg1.getConname());
		            }
		        });
			request.setAttribute("contactList", list);
			request.setAttribute("charList", charList);
			
			//更新未读消息
			Messages obj = new Messages();
			//更新消息标志(根据targetUID更新)
			obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			obj.setRelaModule(Constants.MESSAGE_MODULE_TYPE_BATCH_IMP_CONTACTS);
			cRMService.getDbService().getMessagesService().updateMessagesFlag(obj);
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		
		if (outFlag)
		{
			return "perslInfo/outlist";
		}
		else
		{
			return "perslInfo/conlist";
		}
	}
	
	/**
	 * 
	 * 通讯录分组
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	//自动分组
	@RequestMapping("/conlist_group")
	public String conlist_group(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxuser =  UserUtil.getCurrUser(request);
		//取类别
		String contype = request.getParameter("contype");
		logger.info("contype = >" +contype);
		if(!StringUtils.isNotNullOrEmptyStr(contype)){
			contype = "company";//company , school, area, position
		}
		Contact con = new Contact();
		con.setCrmId(wxuser.getCrmId());
		con.setOpenId(wxuser.getOpenId());
		con.setContype(contype);
		con.setViewtype(Constants.SEARCH_VIEW_TYPE_BOOKSVIEW);
		ContactResp conResp = cRMService.getSugarService().getContact2SugarService().getContactClist(con, "WEB");
		if(null != conResp && conResp.getContacts().size()>0){
			request.setAttribute("conList", conResp.getContacts());
		}else{
			request.setAttribute("conList", new ArrayList<ContactAdd>());
		}
		request.setAttribute("contype", contype);
		return "conlist/listgroup";
	}
	
	/**
	 * 人工分组 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/hand_group")
	public String hand_group(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxuser =  UserUtil.getCurrUser(request);
		//取类别
		/*String tagtype = request.getParameter("tagtype");
		logger.info("tagtype = >"+tagtype);
		*/
		Contact con = new Contact();
		con.setCrmId(wxuser.getCrmId());
		con.setOpenId(wxuser.getOpenId());
		con.setViewtype(Constants.SEARCH_VIEW_TYPE_MYVIEW);
		List<Tag> clist = cRMService.getSugarService().getContact2SugarService().getHandGroupList(con);
		if(null != clist){
			request.setAttribute("groupList", clist);
		}else{
			request.setAttribute("groupList", new ArrayList<ContactAdd>());
		}
		return "conlist/handgroup";
	}
	
	/*
	 //单个类型下的联系人
	 @RequestMapping("/conlist_group_single")
	public String conlist_group_single(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxuser =  UserUtil.getCurrUser(request);
		//取类别
		String contype = request.getParameter("contype");
		String contype_val = request.getParameter("contype_val");
		logger.info("contype = >" +contype_val);
		logger.info("contype_val = >" +contype_val);
		if(!StringUtils.isNotNullOrEmptyStr(contype)){
			contype = "company";//company , school, area, position
		}

		Contact con = new Contact();
		con.setCrmId(wxuser.getCrmId());
		con.setOpenId(wxuser.getOpenId());
		con.setContype(contype);
		con.setViewtype(Constants.SEARCH_VIEW_TYPE_BOOKSVIEW);
		ContactResp conResp = contact2SugarService.getContactClist(con, "WEB");
		if(null != conResp && conResp.getContacts().size()>0){
			request.setAttribute("singleconList", conResp.getContacts());
		}else{
			request.setAttribute("singleconList", new ArrayList<ContactAdd>());
		}
		request.setAttribute("contype", contype);
		return "conlist/groupdetail";
	}*/
	
	/*public String conlist_group(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("conlist_group method = >");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId = >" + crmId);
		Contact contact = new Contact();
	    contact.setCrmId(crmId);
		contact.setPagecount(null);
		contact.setCurrpage(Constants.ZERO+"");
		contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		ContactResp cResp = contact2SugarService.getContactClist(contact,"WEB");
		List<ContactAdd> list = cResp.getContacts();
		logger.info("list = >" + list.size());
		return JSONArray.fromObject(list).toString();
	}*/
	
	
	/**
	 * 好友与联系人对像转换
	 * @param ur
	 * @return
	 */
	private ContactAdd transUserRela(UserRela ur,List<String> charList){
		ContactAdd ca = new ContactAdd();
		ca.setConname(ur.getRela_user_name());
		ca.setRowid(ur.getRela_user_id());
		ca.setConjob(ur.getPosition());
		ca.setDepartment(ur.getDepart());
		ca.setPhonemobile(ur.getMobile_no_1());
		ca.setEmail(ur.getEmail_1());
		if(StringUtils.isNotNullOrEmptyStr(ur.getRela_user_name())){
			String findex = StringUtils.getFirstSpell(ur.getRela_user_name());
			if(!charList.contains(findex)){
				charList.add(findex);
			}
			ca.setFirstname(findex);
		}else{
			if(!charList.contains("#")){
				charList.add("#");
			}
			ca.setFirstname("#");
		}
		ca.setAccountname(ur.getCompany());
		ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
		
		ca.setType("friend");
		return ca;
	}

	/**
	 * 导出联系人列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/export")
	@ResponseBody
	public String exportContactList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(partyId))
		{
			//查找用户是否有验证的邮箱
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(partyId);
			Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(null == obj || !StringUtils.isNotNullOrEmptyStr(((BusinessCard)obj).getEmail()))
			{
				//维护名片
				return "noemail";
			}
			
			if(!"1".equals(((BusinessCard)obj).getIsEmailValidation()))
			{
				//邮箱没有验证通过
				return "invalidemail";
			}
			
			String email = ((BusinessCard)obj).getEmail();
			//
			
			//获取联系人
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(null);
			contact.setCurrpage(Constants.ZERO+"");
			contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
			List<ContactAdd> list = cResp.getContacts();
			
			//获取我的好友
			UserRela userRela = new UserRela();
			userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
			userRela.setCurrpages(Constants.ZERO);
			userRela.setPagecounts(Constants.ALL_PAGECOUNT);
			List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
			
			List<String> charList = new ArrayList<String>();
			
			// 放到页面上
			if (null == list || list.size() == 0) {
				list = new ArrayList<ContactAdd>();
			}
			if(null != userRelaList && userRelaList.size() >0){
				UserRela ur = null;
				for(int i=0;i<userRelaList.size();i++){
					ur = userRelaList.get(i);
					list.add(transUserRela(ur,charList));
				}
			}
			
			//生成CSV文件
			File f = reportConlistToCSV(list);
			//发送邮件
			sendEmail(email, f,UserUtil.getCurrUser(request).getNickname(),list.size());
			
			return "success";
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	
	/**
	 * 创建日程任务的 excel 报告
	 * @param list
	 * @param assigner
	 * @param approvename
	 * @param email
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	private File reportConlistToCSV(List<ContactAdd> list){
		try {
			File f = new File("test.xls");
			if(!f.exists()){
				f.createNewFile();
			}
			FileOutputStream os = new FileOutputStream(f);
			 //创建工作薄
			WritableWorkbook workbook = Workbook.createWorkbook(os);
			//创建新的一页
			WritableSheet sheet = workbook.createSheet("通讯录",0);
			sheet.setColumnView(0, 20);
			sheet.setColumnView(1, 20);
			sheet.setColumnView(2, 20);
			sheet.setColumnView(3, 20);
			
			//合并单元格
			sheet.mergeCells(0, 0, 5, 0);
			sheet.setRowView(0, 750);
			//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
			Label rtile = new Label(0, 0, "我的指尖微客通讯录");
			rtile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,12));
			sheet.addCell(rtile);
			
			Label exportdatetxt = new Label(0, 1, "导出时间：");
			exportdatetxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(exportdatetxt);
			
			Label exportdate = new Label(1, 1, DateTime.currentDate(DateTime.DateFormat1));
			exportdate.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(exportdate);
			
			Label contactnumtxt = new Label(3, 1, "总数：");
			contactnumtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(contactnumtxt);
			
			Label contactnum = new Label(4, 1, list.size()+"");
			contactnum.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(contactnum);
			
			//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
			Label nametxt = new Label(0, 2, "姓名");
			nametxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(nametxt);
			
			Label companytxt = new Label(1, 2, "单位");
			companytxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(companytxt);
			
			Label mobiletxt = new Label(2,2,"电话");
			mobiletxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(mobiletxt);
			
			Label emailtxt = new Label(3,2,"邮箱");
			emailtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(emailtxt);
			
			Label departtxt = new Label(4,2,"部门");
			departtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(departtxt);
			sheet.setRowView(1, 500);
			
			Label addrtxt = new Label(5,2,"地址");
			addrtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(addrtxt);
			sheet.setRowView(1, 500);
			
			
			ContactAdd ca = null;
			for(int i=0;i<list.size();i++){
				ca = list.get(i);
				
				Label name = new Label(0, i+3,ca.getConname());
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(name);
				
				Label company = new Label(1, i+3,ca.getAccountname());
				company.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(company);
				
				Label mobile = new Label(2,i+3,ca.getPhonemobile());
				mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(mobile);
				
				Label email = new Label(3,i+3,ca.getEmail());
				email.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(email);
				
				Label depart = new Label(4,i+3,ca.getDepartment());
				depart.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(depart);
				
				Label addr = new Label(5,i+3,ca.getConaddress());
				addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(addr);
				sheet.setRowView(1, 500);
			}
			
			//把创建的内容写入到输出流中，并关闭输出流
			workbook.write();
			workbook.close();
			os.close();
			
			//返回数据
	        return f;
	        
		} catch (Exception e) {
			return null;
		}
	}
	
	/**
	 * 发送工作报告邮件
	 * @param startDate
	 * @param email
	 * @param assigner
	 * @param approvename
	 * @param wdays
	 * @param filePath
	 */
	private void sendEmail(String email,File f,String username,int conSize){
		SenderInfor senderInfor = new SenderInfor();
        StringBuffer content = new StringBuffer();  
        content.append("亲爱的").append(username).append("，您好！").append("<br/>").append("您本次共导出").append(conSize).append("个联系人，感谢您的使用！");
        senderInfor.setToEmails(email);  
        senderInfor.setSubject("我的指尖微客通讯录");  
        senderInfor.setContent(content.toString());
        Map<String, String> m = new HashMap<String, String>();
        m.put("通讯录_("+ DateTime.currentDateTime(DateTime.DateFormat1) + ").xls", f.getAbsolutePath());
        senderInfor.setAttachments(m);
        MailUtils.sendEmail(senderInfor);
        
        f.delete();
	}
	
	/**
	 * 设置格式
	 * @return
	 */
	private WritableCellFormat getCellFormat(Colour color, Alignment posi ,Integer size){
		try {
			//设置字体;  
			WritableFont font1 = new WritableFont(WritableFont.createFont("微软雅黑"), size, WritableFont.NO_BOLD);
			//WritableFont font1 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.RED);  

			WritableCellFormat cellFormat1 = new WritableCellFormat(font1);  
			//设置背景颜色;  
			//cellFormat1.setBackground(color); 
			//设置自动换行;  
			cellFormat1.setWrap(true);  
			//设置文字居中对齐方式;  
			cellFormat1.setAlignment(posi);  
			//设置垂直居中;  
			cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);
			
			return cellFormat1;
		} catch (WriteException e) {
			logger.info(e.getMessage());
			return null;
		} 
	}
}