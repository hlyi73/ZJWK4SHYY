package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.common.LovVal;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PhoneUtil;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.QRCodeUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.PlatformStatistics;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.model.PrintModel;

@Controller
@RequestMapping("/businesscard")
public class BusinessCardController {
	protected static Logger logger = Logger.getLogger(BusinessCardController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
     * 名片主页
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/get")
    public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
	    String partyId=user.getParty_row_id();
	    if(!StringUtils.isNotNullOrEmptyStr(partyId)){
	    	throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    BusinessCard bc = new BusinessCard();
	    bc.setPartyId(partyId);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null&&list.size()>0){
	    	bc=list.get(0);
	    }
	    request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);
		return "perslInfo/newlist";
	}
	
	/**
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getConfig")
	public String  getConfig(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
	    String partyId=user.getParty_row_id();
	    if(!StringUtils.isNotNullOrEmptyStr(partyId)){
	    	throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }   
	    request.setAttribute("user",user);
		return "perslInfo/config";
	}
	/**
     * 搜索
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/search")
    public String search(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
	    String partyId=user.getParty_row_id();
	    if(!StringUtils.isNotNullOrEmptyStr(partyId)){
	    	throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    String searchStr=request.getParameter("searchcard");
	    BusinessCard bc = new BusinessCard();
	    bc.setName(searchStr);
	    bc.setPhone(searchStr);
	    bc.setCompany(searchStr);
	    bc.setShortcompany(searchStr);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().searchBusinessCard(bc);
	    request.setAttribute("user",user);
	    request.setAttribute("businessCardList",list);
		return "perslInfo/businessCardList";
	}
	/**
     * 完善资料
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/modify")
    public String modify(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
	    String partyId=user.getParty_row_id();
	    BusinessCard bc = new BusinessCard();
	    bc.setPartyId(partyId);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null&&list.size()>0){
	    	bc=list.get(0);
	    }
	    request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);
	    request.setAttribute("PerfectionRate",getPerfectionRate(bc));
		return "perslInfo/newmodify";
	}
	public List<Tag> getTagList(String partyid){
		String modelId = partyid;
		Tag mt = new Tag();
		mt.setModelId(modelId);
		return cRMService.getDbService().getTagModelService().findTagListByModelId(mt);
	}

	public int getPerfectionRate(String partyId){
		int rate = 0;
	    BusinessCard bc = new BusinessCard();
	    bc.setPartyId(partyId);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    for(BusinessCard lbc : list){
	    	return getPerfectionRate(lbc);
	    }
	    return rate;
	}
	
	/**
	 * 统计个人资料的完善度
	 * @param bc
	 * @return
	 */
	public int getPerfectionRate(BusinessCard bc){
		if (bc == null) return 0;
		int rate = 0;
		//姓名、性别、手机填写完成，30%
		if (bc.getName() !=null && !"".equals(bc.getName())){
			rate += 10;
		}
		if (bc.getSex() !=null && !"".equals(bc.getSex())){
			rate += 10;
		}
		if (bc.getPhone() !=null && !"".equals(bc.getPhone())){
			rate += 10;
		}
		//公司   3%  职位 3%  公司简称  4%
		if (bc.getCompany() !=null && !"".equals(bc.getCompany())){
			rate += 3;
		}
		if (bc.getPosition() !=null && !"".equals(bc.getPosition())){
			rate += 3;
		}
		if (bc.getShortcompany() !=null && !"".equals(bc.getShortcompany())){
			rate += 4;
		}
		//手机验证  10%
		if ("1".equals(bc.getIsValidation())){
			rate += 10;
		}
		//邮箱填写   3%    邮箱验证   7% 
		if (bc.getEmail() !=null && !"".equals(bc.getEmail())){
			rate += 3;
		}
		if ("1".equals(bc.getIsEmailValidation())){
			rate += 7;
		}
		//地址  10%
		if (bc.getAddress() !=null && !"".equals(bc.getAddress())){
			rate += 10;
		}
		//每编辑一个标签  1%
		try{
			List<Tag> tags = getTagList(bc.getPartyId());
			if (tags!=null){
				rate += tags.size();
			}
		}catch(Exception ec){
			
		}
	    return rate;
	}
	
	private String getQRCodeBarFile(BusinessCard bc,HttpServletRequest request) throws Exception{
		//WxuserInfo user=UserUtil.getCurrUser(request);
		//最新修改2015-04-13
		WxuserInfo wx = new WxuserInfo();
		wx.setParty_row_id(bc.getPartyId());
		WxuserInfo user = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wx);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		String logoPath = "";
		if(user!=null){
			logoPath=user.getHeadimgurl();
		}
		String path = request.getSession().getServletContext().getRealPath("cache/");
		return QRCodeUtil.encode(user.getParty_row_id(),bc.toVCARDString(), logoPath, true,path);

	}
	
	/**
     * 完善资料
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/detail")
    public String detail(HttpServletRequest request, HttpServletResponse response) throws Exception{
		ZJWKUtil.getRequestURL(request);
		String partyId=request.getParameter("partyId");
		String flag = request.getParameter("flag");
		
		//如果标志为1则为系统中的用户，走正常逻辑，如果为0则非系统用户，仅可查看传入partyId的信息
		String isSys = request.getParameter("isSys");
		if (!StringUtils.isNotNullOrEmptyStr(isSys) || "1".equals(isSys))
		{
			WxuserInfo user=UserUtil.getCurrUser(request);
			if(user==null){
				//抛出异常
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
						+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
			}
			if(!StringUtils.isNotNullOrEmptyStr(partyId)){
				partyId=user.getParty_row_id();
			 /*   request.setAttribute("weixinHeadImage",user.getHeadimgurl());*/
			}/*else{
			WxuserInfo wu = new WxuserInfo();
			wu.setParty_row_id(partyId);
			wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wu);
			 request.setAttribute("weixinHeadImage",wu.getHeadimgurl());
			}*/
			Print pm = new Print();
			pm.setObjectid(partyId);
			pm.setObjecttype(LovVal.PRINT_OBJECT_TYPE_PERSONAL_HOMEPAGE);
			pm.setOperativetype(LovVal.PRINT_OPERATIVE_TYPE_VISIT);
	        int visitCount=cRMService.getDbService().getPrintService().countObjByFilter(pm);
	        if(!partyId.equals(user.getParty_row_id())){
	        	pm.setOperativeid(user.getParty_row_id());
	        	pm.setOwnid(partyId);
	        	cRMService.getDbService().getPrintService().insert(pm);
	        	visitCount=visitCount+1;
	        }
	        PrintModel pm2 = new PrintModel();
	    	pm2.setObjectid(partyId);
			pm2.setObjecttype(LovVal.PRINT_OBJECT_TYPE_PERSONAL_HOMEPAGE);
			pm2.setOperativetype(LovVal.PRINT_OPERATIVE_TYPE_PRAISE);
		    int praiseCount=cRMService.getDbService().getPrintService().countObjByFilter(pm2);
			pm2.setOperativeid(user.getParty_row_id());
			boolean isPraise=false;
			boolean isFriend=false;
			boolean isAddfreind=false;
			if(!partyId.equals(user.getParty_row_id())){
				 if(cRMService.getDbService().getPrintService().countObjByFilter(pm2)<1){//未点赞
					 isPraise=true;
				 }
				 UserRela userRela = new UserRela();
				 userRela.setUser_id(user.getParty_row_id());
				 userRela.setRela_user_id(partyId);
				 isFriend= cRMService.getDbService().getUserRelaService().isFriendsByPartyId(userRela);
				 if(!isFriend){
					 if("Change".equals(flag)){
						request.setAttribute("changecardflag",true);
						}
				/*	 Messages msg = new Messages();
					 msg.setUserId(partyId);
					 msg.setTargetUId(user.getParty_row_id());
					 msg.setRelaId(partyId);
					 msg.setReadFlag("N");
					 msg.setRelaModule("System_ChangeCard");
					List<Messages> msgList= (List<Messages>) messagesService.findObjListByFilter(msg);
					if(msgList!=null&&msgList.size()>0){
						isAddfreind=true;
					}*/
				 }
			 }
			PlatformStatistics ps = new PlatformStatistics();
			ps.setModel("Card");
			ps.setRela_id(partyId);
			ps.setR_type("out");
			int forwardcount= cRMService.getDbService().getPlatformStatisticsService().countObjByFilter(ps);
		    BusinessCard bc = new BusinessCard();
		    bc.setPartyId(partyId);
		    bc.setStatus("0");
		    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
		    if(list!=null&&list.size()>0){
		    	bc=list.get(0);
		    }
		    Tag tag = new Tag();
		    tag.setModelId(partyId);
		    WxuserInfo visitUser = new WxuserInfo();
		    visitUser.setParty_row_id(partyId);
		    visitUser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(visitUser);
		    visitUser= cRMService.getWxService().getWxUserinfoService().getUserConfig(visitUser);//获取被访问用户配置信息
		    List<Tag> mylist=cRMService.getDbService().getModelTagService().getTagListByMy(tag);
		    request.setAttribute("visitUser",visitUser);
		    request.setAttribute("user",user);
		    request.setAttribute("BusinessCard",bc);
		    request.setAttribute("tagList",mylist);
		    request.setAttribute("partyId",partyId);
		    request.setAttribute("visitCount",visitCount);
		    request.setAttribute("praiseCount",praiseCount);
		    request.setAttribute("isPraise",isPraise);
		    request.setAttribute("forwardcount",forwardcount);
		    request.setAttribute("isfriend",isFriend);
		    request.setAttribute("isAddfriend",isAddfreind);
			request.setAttribute("filename", this.getQRCodeBarFile(bc, request));
		    
		    //消息处理
			Messages msg = new Messages();
			msg.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			msg.setRelaId(partyId);
			cRMService.getDbService().getMessagesService().updateMessagesFlag(msg);
			
			return "perslInfo/newdetail";
		}
		else
		{
			BusinessCard bc = new BusinessCard();
		    bc.setPartyId(partyId);
		    bc.setStatus("0");
		    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
		    if(list!=null&&list.size()>0)
		    {
		    	bc=list.get(0);
			    request.setAttribute("BusinessCard",bc);
				request.setAttribute("filename", this.getQRCodeBarFile(bc, request));
		    }
		    return "perslInfo/noAuthDetail";
		}
	}
	
	public BusinessCard getBusinessCardByPartyId(String partyId){
		BusinessCard bc = new BusinessCard();
	    bc.setPartyId(partyId);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null)
	    {
	    	for(BusinessCard bcc : list){
	    		return bcc;
	    	}
	    }
	    return null;
	}
	
	/**
     * 完善资料
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/update")
    public String update(BusinessCard bc,HttpServletRequest request, HttpServletResponse response) throws Exception{
		bc.setCity(bc.getProvince() + "-" + bc.getCity());
		WxuserInfo user=UserUtil.getCurrUser(request);

	    if(user==null){
	    	//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    String partyId=user.getParty_row_id();
	  /*  List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null&&list.size()>0){
	    	bc=list.get(0);
	    }
	    request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);*/
	    
	    
		String code = request.getParameter("code");
		String value = RedisCacheUtil.getString("BusinessCard_Enlist_MessageCode_"+partyId+bc.getId());
		if(StringUtils.isNotNullOrEmptyStr(value)){
			String[] strs = value.split(",");
			for(String str : strs){
				if(code.equals(str)){
					if(differ("BusinessCard_Enlist_MessageCode_StartTime"+partyId+bc.getId()+"_"+code,"BusinessCard_Enlist_MessageCode_EndTime"+partyId+bc.getId()+"_"+code)){
					    bc.setIsValidation("1");
					}	
				}
			}
		}
	    bc.setPartyId(partyId);
	    bc.setOpenId(user.getOpenId());
	    if(StringUtils.isNotNullOrEmptyStr(bc.getId())){
	    	  if(!StringUtils.isNotNullOrEmptyStr(bc.getAddress())){//未填写地址时 根据电话获取归属地
	    		  bc.setAddress(PhoneUtil.getPhonePlace(bc.getPhone()));
	  	    }
	    	cRMService.getDbService().getBusinessCardService().update(bc);
	    	
	    }else{
	    		String rowid=cRMService.getDbService().getBusinessCardService().insert(bc);
	    		bc.setId(rowid);
	    }
	    
	    request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);
	    request.setAttribute("message", "保存成功");
		//return "redirect:/businesscard/get";
	    return this.get(request, response);
	}
	
	/**
     * 异步完善资料
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/save")
	@ResponseBody
    public String save(HttpServletRequest request, HttpServletResponse response) throws Exception{
		WxuserInfo user=UserUtil.getCurrUser(request);		
		BusinessCard bc = new BusinessCard();
	    if(user==null){
	    	//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
	    }
	    String id=request.getParameter("id");
	    String sex =request.getParameter("sex");
	    String headImageUrl =request.getParameter("headImageUrl");
	    String isSendMsg =request.getParameter("isSendMsg");
	    String isValidation =request.getParameter("isValidation");
	    String name =request.getParameter("name");
	    String company =request.getParameter("company");
	    String shortcompany =request.getParameter("shortcompany");
	    String position =request.getParameter("position");
	    String phone =request.getParameter("phone");
	    String email =request.getParameter("email");
	    String address =request.getParameter("address");
	    String city =request.getParameter("province") + "-" + request.getParameter("city");
	    String partyId=user.getParty_row_id();
	  /*  List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null&&list.size()>0){
	    	bc=list.get(0);
	    }
	    request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);*/
	  /*  if(StringUtils.isNotNullOrEmptyStr(name)){
	    	name=new String(name.getBytes("ISO-8859-1"),"UTF-8");
	    }
	    if(StringUtils.isNotNullOrEmptyStr(company)){
	    	company=new String(company.getBytes("ISO-8859-1"),"UTF-8");
	    }
	    if(StringUtils.isNotNullOrEmptyStr(position)){
	    	position=new String(position.getBytes("ISO-8859-1"),"UTF-8");
	    }
	    if(StringUtils.isNotNullOrEmptyStr(address)){
	    	address=new String(address.getBytes("ISO-8859-1"),"UTF-8");
	    }*/
	    if(!StringUtils.isNotNullOrEmptyStr(address)){//未填写地址时 根据电话获取归属地
	    	address=PhoneUtil.getPhonePlace(phone);
	    }
	    bc.setId(id);
	    bc.setAddress(address);
	    bc.setCity(city);
	    bc.setSex(sex);
	    bc.setCompany(company);
	    bc.setShortcompany(shortcompany);
	    bc.setName(name);
	    bc.setHeadImageUrl(headImageUrl);
	    bc.setIsValidation(isValidation);
	    bc.setPosition(position);
	    bc.setPartyId(partyId);
	    bc.setEmail(email);
	    bc.setPhone(phone);
		String code = request.getParameter("code");
		String value = RedisCacheUtil.getString("BusinessCard_Enlist_MessageCode_"+partyId+bc.getId());
		if(StringUtils.isNotNullOrEmptyStr(value)){
			String[] strs = value.split(",");
			for(String str : strs){
				if(code==null||"".equals(code.trim())){
					bc.setIsValidation("0");
				}else if(code.equals(str)){
					if(differ("BusinessCard_Enlist_MessageCode_StartTime"+partyId+bc.getId()+"_"+code,"BusinessCard_Enlist_MessageCode_EndTime"+partyId+bc.getId()+"_"+code)){
					    bc.setIsValidation("1");
					}	
				}
			}
		}
	    bc.setPartyId(partyId);
	    bc.setOpenId(user.getOpenId());
	    if(StringUtils.isNotNullOrEmptyStr(bc.getId())){
	    	cRMService.getDbService().getBusinessCardService().update(bc);
	    	
	    }else{
	    		String rowid=cRMService.getDbService().getBusinessCardService().insert(bc);
	    		bc.setId(rowid);
	    }
	    
	    //更新session
	    UserUtil.setCurrUserByPartyId(request, partyId,  cRMService.getWxService().getWxUserinfoService(), cRMService.getDbService().getBusinessCardService());
	    
	  /*  request.setAttribute("user",user);
	    request.setAttribute("BusinessCard",bc);*/
		return "1";
	}
	
	/**
	 * 发送短信获取验证码
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sendMsg")
	@ResponseBody
	public String sendMsg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String phoneNumber = request.getParameter("phonenumber");
		String code = request.getParameter("code");
		String partyId = request.getParameter("partyId");
		String businessCardId = request.getParameter("businessCardId");
		logger.info("ParticipantController sendMsg phoneNumber ==>"+phoneNumber);
		logger.info("ParticipantController sendMsg code ==>"+code);
		//缓存code的开始时间
		RedisCacheUtil.setString("BusinessCard_Enlist_MessageCode_StartTime"+partyId+businessCardId+"_"+code, DateTime.currentTimeMillis()+"");
		String str = RedisCacheUtil.getString("BusinessCard_Enlist_MessageCode_"+partyId+businessCardId);
		if(StringUtils.isNotNullOrEmptyStr(str)){
			str = str+","+code;
		}else{
			str =code;
		}
		//缓存到redies
		RedisCacheUtil.setString("BusinessCard_Enlist_MessageCode_"+partyId+businessCardId,str);
		System.out.println(RedisCacheUtil.getString("BusinessCard_Enlist_MessageCode_"+partyId+businessCardId));
		//缓存code的结束时间
		RedisCacheUtil.setString("BusinessCard_Enlist_MessageCode_EndTime"+partyId+businessCardId+"_"+code, DateTime.currentTimeMillis()+"");
		String url = PropertiesUtil.getMsgContext("service.url1");
		String content = PropertiesUtil.getMsgContext("message.model1").replace("$$code", code);
		String signature = PropertiesUtil.getMsgContext("msg.signature");
		String msgmodule = content+signature;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mobile", phoneNumber);
		map.put("content", msgmodule);
		map.put("code", code);
		String result = HttpClient3Post.request(url,map);
		if(StringUtils.isNotNullOrEmptyStr(result)&&result.equals(code)){
			return "0";
		}else{
			return "1";
		}
	}
	
	public void sendEmail(String email,String content,String subject){
		SenderInfor senderInfor = new SenderInfor();
		senderInfor.setToEmails(email);
		senderInfor.setContent(content);
		senderInfor.setSubject(subject);
		MailUtils.sendEmail(senderInfor);
	}
	/**
	 * 发送验证邮件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sendEmailCheckMsg")
	@ResponseBody
	public String sendEmailCheckMsg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		try{
			String email = request.getParameter("email");
			String partyId = request.getParameter("partyId");
			String businessCardId = request.getParameter("businessCardId");
			logger.info("ParticipantController sendEmailCheckMsg email ==>"+email);
			UUID uuid = UUID.randomUUID();
			String key = "BusinessCard_Email_MessageCode_" + partyId + businessCardId + "-" + uuid.toString();
			//缓存到redies
			BusinessCard bc = this.getBusinessCardByPartyId(partyId);
			bc.setEmail(email);
			cRMService.getDbService().getBusinessCardService().update(bc);
			RedisCacheUtil.set(key, bc,60*60*24*5);
			System.out.println("EmailCheckResult == " + RedisCacheUtil.get(key));

			String content = PropertiesUtil.getMsgContext("message.businesscard.emailcheck").replace("$$url", String.format("%s/businesscard/checkemail?key=%s",PropertiesUtil.getAppContext("app.content"),key));
			
			sendEmail(email,content,"【指尖微客】邮箱验证");
		}catch(Exception ec){
			return "验证邮件发送失败：" + ec.getMessage();
		}
		return "验证邮件已经发送，请查看您的邮箱！";
	}	
	/**
	 * 发送验证邮件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/checkemail")
	public String checkemail(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String key = request.getParameter("key");
		Object obj = RedisCacheUtil.get(key);
		if (obj!=null && obj instanceof BusinessCard){
			BusinessCard bc = (BusinessCard)obj;
			bc.setIsEmailValidation("1");
			cRMService.getDbService().getBusinessCardService().updateEmailValidation(bc);
			RedisCacheUtil.deleteObjectKey(key);
			BusinessCard bc2 = this.getBusinessCardByPartyId(bc.getPartyId());
		    request.setAttribute("BusinessCard",bc2);  
		    String msg = "系统繁忙，请稍后再试。";
		    if(null!= bc2 && "1".equals(bc2.getIsEmailValidation()))
		    {
		    	msg = "您的邮箱校验成功！";
		    }
		    else
		    {
		    	msg = "您的邮箱校验失败，请联系管理员！";
		    }
		    request.setAttribute("msg",msg);  
		}else{
			
		}
	    return "perslInfo/checkemailok";
	}	
	/**
	 * 验证是否过期
	 * @param startKey
	 * @param endKey
	 * @return
	 */
	public boolean differ(String startKey,String endKey){
		int time  = Integer.parseInt(PropertiesUtil.getMsgContext("service.time"));
		//缓存code的开始时间
		String startTime = RedisCacheUtil.getString(startKey);
		String endTime = RedisCacheUtil.getString(endKey);
		if(StringUtils.isNotNullOrEmptyStr(startTime)&&StringUtils.isNotNullOrEmptyStr(endTime)){
			int differTime = Integer.parseInt(StringUtils.getMargin(endTime, startTime));
			if(differTime<=time){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/share")
	public String shareByMsg(HttpServletRequest request,HttpServletResponse response)throws Exception
	{
		//分享类型
		String shareType = request.getParameter("shareType");
		//url中传递的用户id
		String partyId = request.getParameter("partyId");
		//从request中获取当前用户
		WxuserInfo user=UserUtil.getCurrUser(request);
		boolean isMy = true;
		//判断当前用户于传入的partyId是否一致，
		if (!user.getParty_row_id().equals(partyId))
		{
			//不是分享自己的名片
			isMy = false;
		}
		
		//缓存到分享页面
		request.setAttribute("partyId", partyId);
		request.setAttribute("shareType", shareType);
		request.setAttribute("qrCode", request.getParameter("qrCode"));
		request.setAttribute("isMy", isMy);
		
		//存放处理好的联系人好友列表
		List<ContactAdd> retList = new ArrayList<ContactAdd>();

		//获取联系人
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		
		// 获取绑定的账户 在sugar系统的id
		if (StringUtils.isNotNullOrEmptyStr(crmId)) 
		{
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

			if (isMy)
			{
				//过滤掉已经是好友的联系人
				List<ContactAdd> removeList = new ArrayList<ContactAdd>();
				//存放所有的好友id
				List<String> userRelaIds = new ArrayList<String>();
				if (null != userRelaList && !userRelaList.isEmpty())
				{
					UserRela ur = null;
					for (int i=0;i<userRelaList.size();i++)
					{
						ur = userRelaList.get(i);
						userRelaIds.add(ur.getRela_user_id());
					}
				}
				//开始查找已经是好友的联系人
				if (null != list && !list.isEmpty())
				{
					ContactAdd con = null;
					for(int i=0;i<list.size();i++)
					{
						con = list.get(i);
						for(int j=0;j<userRelaIds.size();j++)
						{
							if (con.getRowid().equals(userRelaIds.get(j)))
							{
								removeList.add(con);
								break;
							}
						}
					}
				}
				//遍历完成后，过滤掉查找出来的联系人
				list.removeAll(removeList);
			}
			else
			{
				//所有的联系人和好友
				if(null != userRelaList && userRelaList.size() >0)
				{
					UserRela ur = null;
					for(int i=0;i<userRelaList.size();i++)
					{
						ur = userRelaList.get(i);
						//优先判断该好友曾经是否是联系人，如果是则不添加到联系人list
						boolean inConList = false;
						for (int j=0;j<list.size();j++)
						{
							if (list.get(j).getRowid().equals(ur.getRela_user_id()))
							{
								inConList = true;
							}
						}
						
						if (!inConList)
						{
							list.add(transUserRela(ur,charList));
						}
					}
				}
				
				//查找完成后需要过滤掉当前查看的联系人
				for (int i=0;i<list.size();i++)
				{
					if (partyId.equals(list.get(i).getRowid()))
					{
						list.remove(i);
						break;
					}
				}
			}

			retList.addAll(list);
			
			if (retList.size() > 0)
			{
				ContactAdd con = null;
				for(int i=0;i<retList.size();i++)
				{
					con = retList.get(i);
					if(!charList.contains(con.getConname()))
					{
						charList.add(con.getConname());
					}
				}
			} 
			
			Collections.sort(charList);
			request.setAttribute("conList", retList);
			request.setAttribute("contactList", retList);
			request.setAttribute("charList", charList);
		}
		
		return "commom/share";
		//return "commom/shareProfessinal";
	}
	
	/**
	 * 异步分享
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gotoShare")
	@ResponseBody
	public String gotoShare(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		CrmError crmErr = new CrmError();
		String params = request.getParameter("params");
		String type = request.getParameter("type");
		boolean isMy = request.getParameter("flag").equals("true") ? true:false;
		String partyId = request.getParameter("partyId");
		//记录失败的联系人
		List<String> failUser = new ArrayList<String>();
		
		//获取当前用户信息
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		//判断参数是否正确
		if (!StringUtils.isNotNullOrEmptyStr(params) || !StringUtils.isNotNullOrEmptyStr(type))
		{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_1);
		}
		else
		{
			//发送短信
			if ("msg".equals(type))
			{
				//号码
				String[] param = params.split(";");
				
				//发送
				Map<String, Object> map = new HashMap<String, Object>();
				WxuserInfo queryFiter = new WxuserInfo();
				WxuserInfo queryUser = null;
				for (int i = 0; i < param.length; i++)
				{
					//正文，根据是否是二维码标志设置不同的内容
					String msgcontent = "";
					String surl = "";
					if (StringUtils.isNotNullOrEmptyStr(request.getParameter("qrCode")))
					{
						if (isMy)
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您分享了他的二维码名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/make?partyId=" + wxuser.getParty_row_id();
						}
						else
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您推荐了他的好友二维码名片。点击查看。";
							//判断选择的是好友还是联系人
							queryFiter.setParty_row_id(param[i].split(",")[0]);
							queryUser =  cRMService.getWxService().getWxUserinfoService().getWxuserInfo(queryFiter);
							if (StringUtils.isNotNullOrEmptyStr(queryUser.getParty_row_id()))
							{
								surl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/make?partyId=" + partyId + "&relaPartyId=" + param[i].split(",")[0];
							}
							else
							{
								surl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/make?partyId=" + partyId;
							}
						}
					}
					else
					{
						if (isMy)
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您分享了他的名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/businesscard/detail?partyId=" + wxuser.getParty_row_id();
						}
						else
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您推荐了他好友的名片。点击查看。";
							//判断选择的是好友还是联系人
							queryFiter.setParty_row_id(param[i].split(",")[0]);
							queryUser =  cRMService.getWxService().getWxUserinfoService().getWxuserInfo(queryFiter);
							if (StringUtils.isNotNullOrEmptyStr(queryUser.getParty_row_id()))
							{
								surl = PropertiesUtil.getAppContext("app.content") + "/businesscard/detail?partyId=" + partyId + "&relaPartyId=" + param[i].split(",")[0];
							}
							else
							{
								surl = PropertiesUtil.getAppContext("app.content") + "/businesscard/detail?partyId=" + partyId;
							}
						}
						
					}

					logger.info("source url = >" + surl);
					msgcontent += PropertiesUtil.getAppContext("zjwk.short.url")+ "/sms?u=" + ZJWKUtil.shortUrl(surl);
					msgcontent += " 7天内有效。";
					logger.info("msgcontent =>" + msgcontent);
					
					map.put("mobile", param[i].split(",")[1]);
					map.put("content", msgcontent);
					map.put("code", "888888");
					
					String result = HttpClient3Post.request("",map);
					
					if(StringUtils.isNotNullOrEmptyStr(result)&&("888888").equals(result))
					{
						continue;
					}
					else
					{
						failUser.add(param[i]);
					}
				}
				
				//返回界面处理
				if (failUser.isEmpty())
				{
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
				}
				else
				{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1);
					crmErr.setErrorMsg("短信分享已执行，但部分联系人分享失败");
					String failStr = "";
					for (int i=0;i<failUser.size();i++)
					{
						failStr += failUser.get(i).split(",")[1];
					}
					crmErr.setRowId(failStr);
				}
			}
			else if ("mail".equals(type))
			{
				//邮箱地址
				String[] param = params.split(";");
				SenderInfor senderInfor = new SenderInfor();
				
				//生成名片二维码
				String filename = "";
				
				//查找名片详情
				BusinessCard bc = new BusinessCard();
				if (isMy)
				{
				    bc.setPartyId(wxuser.getParty_row_id());
				}
				else
				{
					bc.setPartyId(partyId);
				}
			    bc.setStatus("0");
			    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
			    if(list!=null&&list.size()>0)
			    {
			    	bc=list.get(0);
					
					filename = QRCodeUtil.encode(UserUtil.getCurrUser(request).getOpenId(),bc.toVCARDString(), null, true,request.getSession().getServletContext().getRealPath("cache/"));
					
					String qCodePath = PropertiesUtil.getAppContext("app.content") + "/cache/" + filename;
					logger.info(qCodePath);
					senderInfor.setSubject("分享通知");
					
					for (int i = 0; i < param.length; i++)
					{
						String[] para = param[i].split(",");
						String msgcontent = "";
						String str = "";
						//中文乱码转换
						if (!StringUtils.regZh(para[2]))
						{
							str = new String(para[2].getBytes("ISO-8859-1"),"UTF-8");
						}
						
						if (isMy)
						{
							msgcontent = "亲爱的 " +str + "!<br>  您好，您的朋友" + wxuser.getNickname() + "向您分享了他的名片。您可以直接扫描下面的二维码查看。<br>";
						}
						else
						{
							msgcontent = "亲爱的 " + str + "!<br>  您好，您的朋友" + wxuser.getNickname() + "向您推荐了他好友的名片。您可以直接扫描下面的二维码查看。<br>";
						}
						msgcontent += qCodePath;
						msgcontent += "  <br>您的朋友：指尖微客运营团队";
						logger.info("msgcontent =>" + msgcontent);
						senderInfor.setContent(msgcontent);
						
						senderInfor.setToEmails(para[1]);
						MailUtils.sendEmail(senderInfor);
					}
					
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			    }
			}
		}
		
		return JSONObject.fromObject(crmErr).toString();
	}
	/**
	 * 异步直接分享（用户输入手机或邮箱）
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/directShare")
	@ResponseBody
	public String directShare(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		CrmError crmErr = new CrmError();
		String params = request.getParameter("params");
		String type = request.getParameter("type");
		boolean isMy = request.getParameter("flag").equals("true") ? true:false;
		String partyId = request.getParameter("partyId");
		//记录失败的联系人
		List<String> failUser = new ArrayList<String>();
		
		//获取当前用户信息
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		//判断参数是否正确
		if (!StringUtils.isNotNullOrEmptyStr(params) || !StringUtils.isNotNullOrEmptyStr(type))
		{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_1);
		}
		else
		{
			//发送短信
			if ("msg".equals(type))
			{
				//号码
				String[] param = params.split(";");
				
				//发送
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 0; i < param.length; i++)
				{
					//正文，根据是否是二维码标志设置不同的内容
					String msgcontent = "";
					String surl = "";
					if (StringUtils.isNotNullOrEmptyStr(request.getParameter("qrCode")))
					{
						if (isMy)
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您分享了他的二维码名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/make?partyId=" + wxuser.getParty_row_id();
						}
						else
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您推荐了他的好友二维码名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/make?partyId=" + partyId;
						}
					}
					else
					{
						if (isMy)
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您分享了他的名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/businesscard/detail?partyId=" + wxuser.getParty_row_id();
						}
						else
						{
							msgcontent = "您好，您的朋友" + wxuser.getNickname() + "向您推荐了他好友的名片。点击查看。";
							surl = PropertiesUtil.getAppContext("app.content") + "/businesscard/detail?partyId=" + partyId;
						}
						
					}

					logger.info("source url = >" + surl);
					msgcontent += PropertiesUtil.getAppContext("zjwk.short.url")+ "/sms?u=" + ZJWKUtil.shortUrl(surl);
					msgcontent += " 7天内有效。";
					logger.info("msgcontent =>" + msgcontent);
					
					map.put("mobile", param[i]);
					map.put("content", msgcontent);
					map.put("code", "888888");
					
					String result = HttpClient3Post.request("",map);
					
					if(StringUtils.isNotNullOrEmptyStr(result)&&("888888").equals(result))
					{
						continue;
					}
					else
					{
						failUser.add(param[i]);
					}
				}
				
				//返回界面处理
				if (failUser.isEmpty())
				{
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
				}
				else
				{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1);
					crmErr.setErrorMsg("短信分享已执行，但部分联系人分享失败");
					String failStr = "";
					for (int i=0;i<failUser.size();i++)
					{
						failStr += failUser.get(i).split(",")[1];
					}
					crmErr.setRowId(failStr);
				}
			}
			else if ("mail".equals(type))
			{
				//邮箱地址
				String[] param = params.split(";");
				SenderInfor senderInfor = new SenderInfor();
				
				//生成名片二维码
				String filename = "";
				StringBuffer stringBuffer = new StringBuffer();
				stringBuffer.append("BEGIN:VCARD\n");
				stringBuffer.append("VERSION:3.0\n");
				
				//查找名片详情
				BusinessCard bc = new BusinessCard();
				if (isMy)
				{
				    bc.setPartyId(wxuser.getParty_row_id());
				}
				else
				{
					bc.setPartyId(partyId);
				}
			    bc.setStatus("0");
			    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
			    if(list!=null&&list.size()>0)
			    {
			    	bc=list.get(0);
			    	stringBuffer.append("N:"+bc.getName()+"\n");
					stringBuffer.append("EMAIL:"+bc.getEmail()+"\n");
					stringBuffer.append("TEL;WORK,CELL:"+bc.getPhone()+"\n");
					stringBuffer.append("ADR;TYPE=WORK:"+bc.getAddress()+"\n");
					stringBuffer.append("TITLE:"+bc.getPosition()+"\n");
					stringBuffer.append("ORG:"+bc.getCompany()+"\n");
					stringBuffer.append("END:VCARD");
					
					filename = QRCodeUtil.encode(UserUtil.getCurrUser(request).getOpenId(),stringBuffer.toString(), null, true,request.getSession().getServletContext().getRealPath("cache/"));
					
					String qCodePath = PropertiesUtil.getAppContext("app.content") + "/cache/" + filename;
					logger.info(qCodePath);
					senderInfor.setSubject("分享通知");
					
					for (int i = 0; i < param.length; i++)
					{
						String msgcontent = "";
												
						if (isMy)
						{
							msgcontent = "您好！<br>  您好，您的朋友" + wxuser.getNickname() + "向您分享了他的名片。您可以直接扫描下面的二维码查看。<br>";
						}
						else
						{
							msgcontent = "您好！<br>  您好，您的朋友" + wxuser.getNickname() + "向您推荐了他好友的名片。您可以直接扫描下面的二维码查看。<br>";
						}
						msgcontent += qCodePath;
						msgcontent += "  <br>您的朋友：指尖微客运营团队";
						logger.info("msgcontent =>" + msgcontent);
						senderInfor.setContent(msgcontent);
						
						senderInfor.setToEmails(param[i]);
						MailUtils.sendEmail(senderInfor);
					}
					
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			    }
			}
		}
		
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 好友与联系人对像转换
	 * @param ur
	 * @return
	 */
	private ContactAdd transUserRela(UserRela ur,List<String> charList)
	{
		ContactAdd ca = new ContactAdd();
		ca.setConname(ur.getRela_user_name());
		ca.setRowid(ur.getRela_user_id());
		ca.setConjob(ur.getPosition());
		ca.setDepartment(ur.getDepart());
		ca.setPhonemobile(ur.getMobile_no_1());
		ca.setEmail(ur.getEmail_1());
		String findex = StringUtils.getFirstSpell(ur.getRela_user_name());
		if(!charList.contains(findex)){
			charList.add(findex);
		}
		ca.setAccountname(ur.getCompany());
		ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
		ca.setFirstname(findex);
		ca.setType("friend");
		return ca;
	}
	
	/**
	 * 完善我的名片，用户关注时，如果没有名片，则跳用此方法 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/card")
	public String card(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		String redirectUrl = request.getParameter("redirectUrl");
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		BusinessCard bc = new BusinessCard();
	    bc.setPartyId(wxuser.getParty_row_id());
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(null != list && list.size() > 0){
	    	request.setAttribute("busicard", list.get(0));
	    }else{
	    	request.setAttribute("busicard", bc);
	    }
	    request.setAttribute("redirectUrl", redirectUrl);
		return "perslInfo/card";
	}
	
	/**
	 * 保存名片（关注时未完善名片时使用）
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savecard")
	@ResponseBody
	public String savecard(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String company = request.getParameter("company");
		String shortcompany = request.getParameter("shortcompany");
		String position = request.getParameter("position");
		String sex = request.getParameter("sex");
		
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(UserUtil.getCurrUser(request).getParty_row_id());
		bc.setStatus("0");
		List<BusinessCard> cardList = cRMService.getDbService().getBusinessCardService().getList(bc);
		if(null != cardList && cardList.size() >0){
			bc = cardList.get(0);
		}else{
			bc.setId(Get32Primarykey.getRandom32PK());
			WxuserInfo wxuser =  cRMService.getWxService().getWxUserinfoService().getWxuserInfo(UserUtil.getCurrUser(request).getOpenId());
			if(StringUtils.isNotNullOrEmptyStr(wxuser.getHeadimgurl())){
				bc.setHeadImageUrl(WxUtil.compressImger(wxuser.getHeadimgurl()));
			}
			bc.setCity(wxuser.getCity());
		}
		if(StringUtils.isNotNullOrEmptyStr(name)){
			if(!StringUtils.regZh(name)){
				name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		if(StringUtils.isNotNullOrEmptyStr(position)){
			if(!StringUtils.regZh(position)){
				position = new String(position.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		if(StringUtils.isNotNullOrEmptyStr(company)){
			if(!StringUtils.regZh(company)){
				company = new String(company.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		if(StringUtils.isNotNullOrEmptyStr(shortcompany)){
			if(!StringUtils.regZh(shortcompany)){
				shortcompany = new String(shortcompany.getBytes("ISO-8859-1"),"UTF-8");
			}
		}
		bc.setName(name);
		bc.setPhone(phone);
		bc.setCompany(company);
		bc.setShortcompany(shortcompany);
		bc.setPosition(position);
		bc.setSex(sex);
		if(null != cardList && cardList.size() >0){
			int flag = cRMService.getDbService().getBusinessCardService().update(bc);
			if(flag >0){
				return "success";
			}
			return "fail";
		}else{
			String id = cRMService.getDbService().getBusinessCardService().insert(bc);
			if(StringUtils.isNotNullOrEmptyStr(id)){
				return "success";
			}
			return "fail";
		}
	}
}
