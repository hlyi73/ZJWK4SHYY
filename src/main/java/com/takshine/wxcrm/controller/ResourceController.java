package com.takshine.wxcrm.controller;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.ActivityPrint;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.CatchPicture;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.ResourceRela;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;

/**
 * 资料 页面控制器
 * 
 * @author zhihe
 * 
 */
@Controller
@RequestMapping("/resource")
public class ResourceController
{
	// 日志
	protected static Logger logger = Logger.getLogger(ResourceController.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询 资料列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception 
	{
		logger.info("ResourceController-->in list");
		
		request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
		
		//查询对象
		Resource res = new Resource();
		res.setPagecounts(new Integer(999));
		res.setCurrpages(new Integer(0));
		//设置查询条件
		//调用入口
		String source = request.getParameter("source");
		if (StringUtils.isNotNullOrEmptyStr(source))
		{
			String condition = request.getParameter("cond");
			String dgid = request.getParameter("dgid");
			request.setAttribute("source", source);
			request.setAttribute("dgid", dgid);
			if (StringUtils.isNotNullOrEmptyStr(condition))
			{
				if (!StringUtils.regZh(condition))
				{
					condition = new String(condition.getBytes("ISO-8859-1"), "UTF-8");
				}
				res.setResourceInfo3(condition);
			}
		}
		else
		{
			request.setAttribute("source", "");
		}
		try
		{
			//获取用户信息
			if (StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUser(request).getParty_row_id()))
			{
				res.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			}
			else
			{
				logger.error(ErrCode.ERR_MSG_1);
				throw new Exception(ErrCode.ERR_MSG_UNBIND);
			}
			
			//获取传递过来的查询条件
			String queryCond = request.getParameter("resourceInfo3");
			if (StringUtils.isNotNullOrEmptyStr(queryCond))
			{
				res.setResourceInfo3(queryCond);
			}
			//标签上关联的文章id
			String modelId = request.getParameter("modelId");
			if (StringUtils.isNotNullOrEmptyStr(modelId))
			{
				res.setResourceId(modelId);
			}
			
			List<Resource>resList = cRMService.getDbService().getResourceService().findResourceListByFilter(res);
			
			if (null != resList && !resList.isEmpty())
			{
				request.setAttribute("resList", resList);
				
				//获取文章相关的标签
				List<Tag> allResTag = new ArrayList<Tag>();
				List<Tag> resItemList = null;
				Tag tag = null;
				for (Resource r : resList)
				{
					tag = new Tag();
					tag.setModelId(r.getResourceId());
					tag.setModelType("resource_tag");//标签类型
					resItemList = cRMService.getDbService().getTagModelService().findTagListByModelId(tag);
					r.setTagList(resItemList);
					allResTag.addAll(resItemList);
					
					if(StringUtils.isNotNullOrEmptyStr(r.getResourceUrl())){
						String[] urls = r.getResourceUrl().split(",");
						for(String url : urls){
							r.getImgUrlList().add(url);
						}
					}
				}
				request.setAttribute("allResTag", allResTag);
				
				//获取所有标签名，去重
				ArrayList<String> tgNList = new ArrayList<String>();
				for (Tag tg : allResTag)
				{
					if (!tgNList.contains(tg.getTagName()))
					{
						tgNList.add(tg.getTagName());
					}
				}
				request.setAttribute("tgNList", tgNList);
			}
			else
			{
				request.setAttribute("resList", new ArrayList<Resource>());
				request.setAttribute("resListSize", 0);
				request.setAttribute("resTagList", new ArrayList<Resource>());
				request.setAttribute("allResTag", new ArrayList<Tag>());
				request.setAttribute("tgNList",  new ArrayList<String>());
			}
			
			//获取系统推荐文章列表
			res.setCreator(null);
			List<Resource> sysList = this.getSysTopResources(res);
			if (null != sysList && !sysList.isEmpty())
			{
				request.setAttribute("sysList", sysList);
			}
			else
			{
				request.setAttribute("sysList", new ArrayList<Resource>());
			}
		}
		catch(Exception ex)
		{
			throw ex;
		}
		
		logger.info("ResourceController-->out list");
		return "resource/list";
	}
	
	/**
	 * 根据查询条件查询对应的
	 * @param res
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getTags")
	@ResponseBody
	public String getTags(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		return null;
	}
	
	/**
	 * 异步查询资料列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/rlist")
	@ResponseBody
	public String rlist(HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		return null;
	}

	/**
	 * 新增资料
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	public String add(Resource obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception 
	{
		ZJWKUtil.getRequestURL(request);//获取请求的url
		//客户端类型
		boolean isMobile = ZJWKUtil.isMobileAccess(request);
		if(isMobile){
			return "resource/add";
		}else{
			return "resource/pcadd";
		}
	}

	/**
	 * 保存
	 * 
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public String save(Resource obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception 
	{
		//返回值对象
		CrmError retMess = new CrmError();
		logger.info("ResourceController-->resource content == "+obj.getResourceContent());
		logger.info("ResourceController-->resource resourceInfo1 == "+obj.getResourceInfo1());
		if(!StringUtils.isNotNullOrEmptyStr(obj.getResourceTitle())){
			if(StringUtils.isNotNullOrEmptyStr(obj.getResourceContent())){
				if(obj.getResourceContent().length()>50){
					obj.setResourceTitle(obj.getResourceContent().substring(0,50));
				}else{
					obj.setResourceTitle(obj.getResourceContent());
				}
			}
		}
		obj.setResourceId(Get32Primarykey.getRandom32PK());
		obj.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
	
		int flg = cRMService.getDbService().getResourceService().addResource(obj);
		if(flg ==1){
			retMess.setErrorCode(ErrCode.ERR_CODE_0);
			retMess.setRowId(obj.getResourceId());
		}else{
			retMess.setErrorCode(ErrCode.ERR_CODE__1);
			retMess.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}
		return JSONObject.fromObject(retMess).toString();
	}
	
	/**
	 * 异步保存
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/asynsave", method = RequestMethod.POST)
	@ResponseBody
	public String syncSave(Resource obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception
	{
		logger.info("ResourceController-->in asynsave");
		//返回值对象
		CrmError retMess = new CrmError();
		//前台传递的url--粘贴链接
		String url = request.getParameter("url");
		String type = "other";
		try
		{
			//获取当前用户
			if(StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUser(request).getParty_row_id()))
			{
				obj.setCreator(UserUtil.getCurrUser(request).getParty_row_id());

				if (StringUtils.isNotNullOrEmptyStr(url))
				{
					obj.setResourceUrl(url);
					
					//判断url是否是微信体系
					if (url.indexOf("weixin.qq") >0 || url.indexOf("WEIXIN.QQ")>0)
					{
						type = "wx";
					}

					if ("other".equals(type))
					{
						processOtherUrl(url,obj);
					}
					else if ("wx".equals(type))
					{
						//微信系统的文章
						processWxUrl(url,obj);
					}
					//处理完成后保存后台
					int ret = cRMService.getDbService().getResourceService().addResource(obj);
					
					if (ret == 1)
					{
						retMess.setErrorCode(ErrCode.ERR_CODE_0);
						retMess.setErrorMsg(ErrCode.ERR_MSG_SUCC);
					}
					else
					{
						retMess.setErrorCode(ErrCode.ERR_CODE__1);
						retMess.setErrorMsg(ErrCode.ERR_MSG_FAIL);
					}
				}
				else
				{
					retMess.setErrorCode(ErrCode.ERR_CODE__1);
					retMess.setErrorMsg(ErrCode.ERR_MSG_FAIL);
				}
			}
			else
			{
				//当前无登陆用户
				retMess.setErrorCode(ErrCode.ERR_CODE_1001001);
				retMess.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			
			logger.info("ResourceController-->out asynsave");
			
		}
		catch(Exception ex)
		{
			logger.error(ex);
			retMess.setErrorCode(ErrCode.ERR_CODE__1);
			retMess.setErrorMsg(ErrCode.ERR_MSG_FAIL);
		}
		
		return JSONObject.fromObject(retMess).toString();
	}
	
	/**
	 * 预处理wx url，获取文档的标题和简要描述
	 * @param url
	 * @param res
	 */
	private void processWxUrl(String url, Resource res) throws Exception
	{
		StringBuffer temp = new StringBuffer();  
        try 
        {  
        	HttpURLConnection uc = (HttpURLConnection)new URL(url). openConnection();  
            uc.setConnectTimeout(10000);  
            uc.setDoOutput(true);  
            uc.setRequestMethod("GET");  
            uc.setUseCaches(false);  

            InputStream in = new BufferedInputStream(uc.getInputStream());  
            Reader rd = new InputStreamReader(in, "UTF-8");  
            int c = 0;  
            while ((c = rd.read()) != -1) 
            {  
                temp.append((char) c);  
            }  
         
            try
            {
            	//获取最后一个js脚本，获取链接相关信息
                String info =temp.substring(temp.lastIndexOf("<script"),temp.length());
                //拿到标题的起始位置
                int title_post = info.indexOf("var msg_title");
                //拿到描述的起始位置
                int desc_post = info.indexOf("var msg_desc");
                //拿到url的起始位置
                int url_post = info.indexOf("var msg_cdn_url");
                //截取后根据=分割获取值
                String title_temp = info.substring(title_post,desc_post).split("=")[1];
                String title = title_temp.substring(title_temp.indexOf("\"")+1,title_temp.lastIndexOf("\""));
                res.setResourceTitle(title);
               //截取后根据=分割获取值
                String desc = info.substring(desc_post,url_post).split("=")[1];
                res.setResourceContent(desc);
            }
            catch(Exception ex)
            {
            	//如果无法获取标题和描述则直接使用登陆用户的信息
            	WxuserInfo query = new WxuserInfo();
            	query.setParty_row_id(res.getCreator());
            	WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(query);
            	if (null != wxuser)
            	{
            		res.setResourceTitle(wxuser.getNickname());
            		res.setResourceContent(url);
            	}
            }
            
            in.close();  
        } 
        catch (Exception e)
        {  
            logger.error(e);  
            throw e;
        }  
	}
	
	/**
	 * 预处理other url，获取文档的标题和简要描述
	 * @param url
	 * @param res
	 */
	private void processOtherUrl(String url, Resource res) throws Exception
	{
		StringBuffer temp = new StringBuffer();  
		//登陆用户的信息
    	WxuserInfo query = new WxuserInfo();
    	query.setParty_row_id(res.getCreator());
    	WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(query);
		
        try 
        {  
        	HttpURLConnection uc = (HttpURLConnection)new URL(url). openConnection();  
            uc.setConnectTimeout(10000);  
            uc.setDoOutput(true);  
            uc.setRequestMethod("GET");  
            uc.setUseCaches(false);  

            InputStream in = new BufferedInputStream(uc.getInputStream());  
            Reader rd = new InputStreamReader(in, "UTF-8");  
            int c = 0;  
            while ((c = rd.read()) != -1) 
            {  
                temp.append((char) c);  
            }  
         
            try
            {
            	//获取标题
            	if (temp.indexOf("<title") > 0)
            	{
            		 String title_temp =temp.substring(temp.indexOf("<title"),temp.indexOf("</title>"));
            		 String title =title_temp.substring(title_temp.indexOf(">")+1,title_temp.length());
                     if (StringUtils.isNotNullOrEmptyStr(title))
                     {
                    	 if (!StringUtils.regZh(title))
                         {
                         	title =  new String(title.getBytes("ISO-8859-1"), "UTF-8");
                         }
                         res.setResourceTitle(title);
                     }
                     else
                     {
                    	 res.setResourceTitle(wxuser.getNickname());
                     }
            	}
            	else
            	{
                	if (null != wxuser)
                	{
                		res.setResourceTitle(wxuser.getNickname());
                	}
            	}
               
                //获取正文或描述等其他信息
            	 String desc_text = "";
            	 String desc_p = "";
                if (temp.indexOf("<textarea") > 0)
                {
                	 String desc_text_temp = temp.substring(temp.indexOf("<textarea"),temp.indexOf("</textarea>"));
                	 desc_text = desc_text_temp.substring(desc_text_temp.indexOf(">")+1,desc_text_temp.length());
                }
                if (temp.indexOf("<p") > 0)
                {
                	 String desc_p_temp = temp.substring(temp.indexOf("<p"),temp.indexOf("</p>"));
                     desc_p = desc_p_temp.substring(desc_p_temp.indexOf(">")+1,desc_p_temp.length());
                }
                
                if (StringUtils.isNotNullOrEmptyStr(desc_text))
                {
                	if (StringUtils.isNotNullOrEmptyStr(desc_p))
                	{
                		if (desc_text.length() > desc_p.length())
                		{
                			res.setResourceContent(desc_text);
                		}
                		else
                		{
                			res.setResourceContent(desc_p);
                		}
                	}
                	else
                	{
                		res.setResourceContent(desc_text);
                	}
                }
                else
                {
                	res.setResourceContent(url);
                }
            }
            catch(Exception ex)
            {
            	res.setResourceContent(url);
            }
            
            in.close();  
        } 
        catch (Exception e)
        {  
        	logger.error(e);
            throw e;
        }  
	}
	
	/**
	 * 修改资料
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/upd")
	public String update(Resource obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		return "redirect:/resource/list";
	}
	
	/**
	 * 删除资料
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/del")
	@ResponseBody
	public String delete(Resource obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception 
	{
		logger.info("ResourceController-->in delete");
		//返回值对象
		CrmError retMess = new CrmError();
		String type = request.getParameter("type");
		
		//获取登陆用户信息
		String userId = UserUtil.getCurrUser(request).getParty_row_id();
		if (!StringUtils.isNotNullOrEmptyStr(userId))
		{
			retMess.setErrorCode(ErrCode.ERR_CODE_1001001);
			retMess.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		else
		{
			Resource res = new Resource();
			//根据传入的操作类型处理单一删除或者批量删除
			if ("single".equals(type))
			{
				String singleId = request.getParameter("id");//详情界面才会传递单一的id
				res.setResourceId(singleId);
				res.setResourceStatus("0");
				res.setCreator(userId);
				cRMService.getDbService().getResourceService().updateResourceById(res);
				//资源删除 同步到讨论组
				if(org.apache.commons.lang.StringUtils.isNotBlank(singleId)){
					cRMService.getDbService().getDiscuGroupService().delDiscuGroupTopicByTopicId(singleId);
				}
			}
			else if ("mulit".equals(type))
			{
				//获取需要删除的资料id
				String delList = request.getParameter("delIds");
				String ids[] = delList.substring(0,delList.length()-1).split(",");
				
				for (String id : ids)
				{
					res.setResourceId(id);
					res.setResourceStatus("0");
					res.setCreator(userId);
					cRMService.getDbService().getResourceService().updateResourceById(res);
					//资源删除 同步到讨论组
					if(org.apache.commons.lang.StringUtils.isNotBlank(id)){
						cRMService.getDbService().getDiscuGroupService().delDiscuGroupTopicByTopicId(id);
					}
				}
			}
			
			retMess.setErrorCode(ErrCode.ERR_CODE_0);
			retMess.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		}
		
		logger.info("ResourceController-->out delete");
		return JSONObject.fromObject(retMess).toString();
	}
	
	/**
	 * 资料详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request, HttpServletResponse response)
			throws Exception 
	{
		ZJWKUtil.getRequestURL(request);
		logger.info("ResourceController-->in detail");
		
		String url = request.getParameter("resurl");
		String id = request.getParameter("id");
		String resType = request.getParameter("restype");
		String isSys = request.getParameter("isSys");
		
		logger.info("ResourceController-->in detail id is:" + id);
		
		//根据id查询文章详情
		//拿详情
		Resource query = new Resource();
		query.setResourceId(id);
		query.setPagecounts(new Integer(999));
		query.setCurrpages(new Integer(0));
		List<Resource> retList = cRMService.getDbService().getResourceService().findResourceListByFilter(query);
		if (null != retList && !retList.isEmpty())
		{
			Resource res = retList.get(0);
			
			request.setAttribute("res", retList.get(0));
			
			//根据资源类型返回对应的值
			if ("link".equals(res.getResourceType()))
			{
				if (StringUtils.isNotNullOrEmptyStr(url))
				{
					request.setAttribute("resourceUrl", url);
				}
				else
				{
					request.setAttribute("resourceUrl", res.getResourceUrl());
				}
			}
			else if ("img".equals(res.getResourceType()))
			{
				//拿所有图片
				MessagesExt mext = new MessagesExt();
				mext.setRelaid(id);
				mext.setPagecounts(new Integer(999));
				mext.setCurrpages(new Integer(0));
				List<MessagesExt>imgList = cRMService.getDbService().getResourceService().getAllMessagesExtByRelaId(mext);
				if (null != imgList && !imgList.isEmpty())
				{
					request.setAttribute("imgList", imgList);
				}
				else
				{
					request.setAttribute("imgList", new ArrayList<MessagesExt>());
				}
			}
			else if ("timg".equals(res.getResourceType())) //图文列表（PC端新建文章）
			{
				
			}
			else
			{
				throw new Exception("数据不正确");
			}
			
			//页面按钮控制
			boolean ispraise = false;
			if (UserUtil.hasCurrUser(request))
			{
				String userId = UserUtil.getCurrUser(request).getParty_row_id();
				//优先判断是不是自己进入
				if (userId.equals(res.getCreator()))
				{
					//如果是自己，判断是否是系统的
					if (StringUtils.isNotNullOrEmptyStr(isSys))
					{
						request.setAttribute("discuBtn", true);
						request.setAttribute("openBtn", false);
					}
					else
					{
						request.setAttribute("discuBtn", true);
						request.setAttribute("openBtn", true);
					}
				}
				else
				{
					if (StringUtils.isNotNullOrEmptyStr(isSys))
					{
						//不是自己,但是系统的
						request.setAttribute("backBtn", true);
						request.setAttribute("saveBtn", true);
						request.setAttribute("nextBtn", true);
					}
					else
					{
						//不是自己,也不是系统的
						request.setAttribute("saveBtn", true);
						request.setAttribute("backBtn", false);
						request.setAttribute("nextBtn", false);
					}
				}
				
				//是否允许点赞
				if (StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUserId(request)))
				{
					ispraise = true;
					request.setAttribute("userId", UserUtil.getCurrUserId(request));
				}

				// 点赞统计
				ActivityPrint ap2 = new ActivityPrint();
				ap2.setActivityid(id);
				ap2.setType("PRAISE");
				int praiseCount = cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2);//点赞数
				if (praiseCount > 0)
				{
					request.setAttribute("praiseCount", praiseCount);
				}
				else
				{
					request.setAttribute("praiseCount", 0);
				}
				
				//List<ActivityPrint> praiseList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(ap2);// 点赞列表
				//是否已点赞
				ap2.setSourceid(UserUtil.getCurrUserId(request));
				if (cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2) > 0)
				{
					ispraise = false;
				}
				
				request.setAttribute("ispraise", ispraise);
			}
			else
			{
				request.setAttribute("discuBtn", false);
				request.setAttribute("openBtn", false);
				request.setAttribute("backBtn", false);
				request.setAttribute("saveBtn", false);
				request.setAttribute("nextBtn", true);
			}
			
			request.setAttribute("resId", id);
			if (StringUtils.isNotNullOrEmptyStr(resType))
			{
				request.setAttribute("resType", resType);
			}
			else
			{
				request.setAttribute("resType", res.getResourceType());
			}
			request.setAttribute("isSys", isSys);
			request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
			
			//打开详情则增加一次浏览量
			this.processRes(res,"explorer");
			
			//判断是否显示查看原文按钮
			if(StringUtils.isNotNullOrEmptyStr(res.getResourceUrl()) && res.getResourceUrl().indexOf("mp.weixin.qq.com") > 0)
			{
				request.setAttribute("originBtn", true);
			}
			else
			{
				request.setAttribute("originBtn", false);
			}
			
			//short url
			request.setAttribute("shorturl", PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/resource/detail?id="+query.getResourceId()));
			
			//获取系统推荐文章
			Resource r = new Resource();
			r.setCurrpages(new Integer(0));
			r.setPagecounts(new Integer(3));
			r.setNotinresid(id);
			List<Resource> resList = cRMService.getDbService().getResourceService().findResourceBySys(r);
			if (null != resList && resList.size()>0)
			{
				request.setAttribute("sysList", resList);
			}
			else
			{
				request.setAttribute("sysList", new ArrayList<Resource>());
			}

			logger.info("ResourceController-->out detail");
			return "resource/detail";
		}
		else
		{
			throw new Exception("未找到对应的数据");
		}
	}
	
	/**
	 * 下一篇
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/nextFromSys")
	public String nextFromSys(HttpServletRequest request, HttpServletResponse response)
			throws Exception 
	{
		logger.info("ResourceController-->in nextFromSys");
		Resource retRes = null;//需要返回的文章
		int allSysCount = 0;
		int allReadCount = 0;
		int myselfCount = 0;
		
		String id = request.getParameter("resid");
		String isSys = request.getParameter("isSys");
		String creator = request.getParameter("creator");
		
		//页面按钮控制
		String userId = UserUtil.getCurrUser(request).getParty_row_id();
		
		//获取session中已有的文章id
		String readIds = (String)(request.getSession().getAttribute("READ_RESOURCE_IDS") == null ? "":request.getSession().getAttribute("READ_RESOURCE_IDS"));

		if (StringUtils.isNotNullOrEmptyStr(readIds))
		{
			readIds += "," + id;
		}
		else
		{
			readIds = id;
		}
		request.getSession().setAttribute("READ_RESOURCE_IDS", readIds);//再次保存
		String idList[] = readIds.split(",");
		allReadCount =idList.length;
		
		//查询当前文章作者的系统推荐的文章
		Resource res = new Resource();
		res.setPagecounts(new Integer(999));
		res.setCurrpages(new Integer(0));
		res.setCreator(creator);
		List<Resource> sysListByCreator = this.getSysTopResources(res);
		
		//查询当前文章作者的系统推荐的文章
		Resource res_sys = new Resource();
		res_sys.setPagecounts(new Integer(999));
		res_sys.setCurrpages(new Integer(0));
		List<Resource> sysList = this.getSysTopResources(res_sys);
		allSysCount = sysList.size();
		
		//查询当前用户的系统推荐文章
		Resource res_my = new Resource();
		res_my.setPagecounts(new Integer(999));
		res_my.setCurrpages(new Integer(0));
		res_my.setCreator(userId);
		List<Resource> myList = this.getSysTopResources(res_my);
		myselfCount = myList.size();
		
		if (sysListByCreator != null && !sysListByCreator.isEmpty())
		{
			for (Resource temp : sysListByCreator)
			{
				boolean flag = false;
				for (String tempId : idList)
				{
					if (temp.getResourceId().equals(tempId))
					{
						flag = true;
						break;
					}
				}
				
				if (flag)
				{
					continue;
				}
				
				retRes  = new Resource();
				retRes = temp;
				break;
			}
		}
		
		//如果在该作者下面没有新的下一篇，则在所有的系统推荐里面找
		if (null == retRes)
		{
			if (sysList != null && !sysList.isEmpty())
			{
				for (Resource temp : sysList)
				{
					boolean flag = false;
					for (String tempId : idList)
					{
						if (temp.getResourceId().equals(tempId))
						{
							flag = true;
							break;
						}
					}
					
					//已阅读的跳过
					if (flag)
					{
						continue;
					}
					
					//如果是自己推荐出来的文章，默认跳过
					if (temp.getCreator().equals(userId))
					{
						continue;
					}
					
					//没阅读过，也不是自己推荐的系统文章，返回
					retRes  = new Resource();
					retRes = temp;
					break;
				}
			}
		}
		
		if((allReadCount +1 >= (allSysCount - myselfCount)))
		{
			request.setAttribute("lastFlag", true);
			request.getSession().removeAttribute("READ_RESOURCE_IDS");
		}
		
		request.setAttribute("res", retRes);
		//根据资源类型返回对应的值
		if ("link".equals(retRes.getResourceType()))
		{
			request.setAttribute("resourceUrl", retRes.getResourceUrl());
		}
		else if ("img".equals(retRes.getResourceType()))
		{
			//拿所有图片
			MessagesExt mext = new MessagesExt();
			mext.setRelaid(retRes.getResourceId());
			mext.setPagecounts(new Integer(999));
			mext.setCurrpages(new Integer(0));
			List<MessagesExt>imgList = cRMService.getDbService().getResourceService().getAllMessagesExtByRelaId(mext);
			if (null != imgList && !imgList.isEmpty())
			{
				request.setAttribute("imgList", imgList);
			}
		}
		else
		{
			throw new Exception(ErrCode.ERR_CODE_100007001);//没有找到数据
		}

		//优先判断是不是自己进入
		if (userId.equals(retRes.getCreator()))
		{
			//如果是自己，判断是否是系统的
			if (StringUtils.isNotNullOrEmptyStr(isSys))
			{
				request.setAttribute("discuBtn", true);
				request.setAttribute("openBtn", false);
			}
			else
			{
				request.setAttribute("discuBtn", true);
				request.setAttribute("openBtn", true);
			}
		}
		else
		{
			if (StringUtils.isNotNullOrEmptyStr(isSys))
			{
				//不是自己,但是系统的
				request.setAttribute("backBtn", true);
				request.setAttribute("saveBtn", true);
				request.setAttribute("nextBtn", true);
			}
			else
			{
				//不是自己,也不是系统的
				request.setAttribute("saveBtn", true);
				request.setAttribute("backBtn", false);
				request.setAttribute("nextBtn", false);
			}
		}
		
		//判断是否显示查看原文按钮
		if(null != retRes.getResourceUrl() && retRes.getResourceUrl().indexOf("mp.qq.com") > 0)
		{
			request.setAttribute("originBtn", true);
		}
		else
		{
			request.setAttribute("originBtn", false);
		}
		
		request.setAttribute("resId", retRes.getResourceId());
		request.setAttribute("resType", retRes.getResourceType());
		request.setAttribute("isSys", isSys);
		request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
			
		//打开详情则增加一次浏览量
		this.processRes(retRes,"explorer");
			//short url
		request.setAttribute("shorturl", PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?parentId="+retRes.getResourceId()+"&parentType=resource"));
		
		logger.info("ResourceController-->out nextFromSys");
		return "resource/detail";
	}
	
	/**
	 * 显示讨论组
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/showDiscu")
	public String showDiscu(HttpServletRequest request,
			HttpServletResponse response) throws Exception
	{
		logger.info("ResourceController-->in showDiscu");
		//缓存文章id
		String resId = request.getParameter("resid");
		request.setAttribute("resId", resId);
		//缓存文章类型
		String resType = request.getParameter("restype");
		request.setAttribute("resType", resType);
		//缓存文章url resType为link时才有值
		String resUrl = request.getParameter("resurl");
		request.setAttribute("resUrl", resUrl);
		//获取登陆用户
		String partyId = null;
		if (StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUser(request).getParty_row_id()))
		{
			partyId = UserUtil.getCurrUser(request).getParty_row_id();
		}
		else
		{
			logger.error(ErrCode.ERR_MSG_UNBIND);
			throw new Exception(ErrCode.ERR_CODE_1001001);
		}
		//获取登陆用户发起和参与的讨论组信息
		DiscuGroup dg = new DiscuGroup();
		
		//传递了查询条件
		String condition = request.getParameter("condition");
		if (StringUtils.isNotNullOrEmptyStr(condition))
		{
			dg.setName(condition);
		}
		
		dg.setCreator(partyId);
		List<DiscuGroup>dgList =  cRMService.getDbService().getDiscuGroupService().findJoinDiscuGroupList(dg);
		
		if (null != dgList && !dgList.isEmpty())
		{
			request.setAttribute("dgList", dgList);
		}
		//响应界面
		logger.info("ResourceController-->out showDiscu");
		return "resource/resDiscu";
	}
	
	/**
	 * 推荐到讨论组
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/pushDiscu")
	@ResponseBody
	public String pushDiscu(HttpServletRequest request,
			HttpServletResponse response) throws Exception
	{
		logger.info("ResourceController-->in pushDiscu");
		CrmError ret = new CrmError();
		//选择的讨论组id
		String selectIds = request.getParameter("selectIds");
		String messageType = request.getParameter("type");
		String resId = request.getParameter("resId");
		ArrayList<String> succIds = new ArrayList<String>();
		ArrayList<String> failIds = new ArrayList<String>();
		//获取登陆用户
		String partyId = null;
		if (StringUtils.isNotNullOrEmptyStr(UserUtil.getCurrUser(request).getParty_row_id()))
		{
			partyId = UserUtil.getCurrUser(request).getParty_row_id();
			//循环
			DiscuGroupTopic dgt = null;
			
			String ids[] = selectIds.substring(0,selectIds.length()-1).split(",");
			
			for(String id : ids)
			{
				dgt = new DiscuGroupTopic();
				dgt.setCreator(partyId);
				dgt.setDis_id(id);
				dgt.setTopic_id(resId);
				dgt.setTopic_type("article");
				dgt.setTopic_status("audited");
				
				ret = cRMService.getDbService().getDiscuGroupService().addDiscuGroupTopic(dgt);
				if (null != ret && ErrCode.ERR_CODE_0.equals(ret.getErrorCode()))
				{
					succIds.add(id);
					continue;
				}
				else
				{
					failIds.add(id);
					break;
				}
			}
			
			//完成关系建立，开始针对成功的讨论组发送消息
			if (!succIds.isEmpty())
			{
				//发送消息
				logger.info("选择的消息类型：" + messageType);
				for (int i=0;i<succIds.size();i++)
				{
					HashMap<String, Object> inparams = new HashMap<String, Object>();
					DiscuGroupUser dgu = new DiscuGroupUser();
					dgu.setDis_id(succIds.get(i));
					List<?> dguList = cRMService.getDbService().getDiscuGroupUserService().findObjListByFilter(dgu);
					String content = UserUtil.getCurrUser(request).getName() + "在讨论组[dis_name]分享了新的话题，点击进入该讨论组查看";
					String url = "/discuGroup/detail?rowId=" + succIds.get(i);
					
					inparams.put("users", dguList);
					inparams.put("content", content);
					inparams.put("url", url);
					
					this.sendMessage(inparams);
				}
			}
			
			ret.setErrorCode(ErrCode.ERR_CODE_0);
			ret.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			if (!failIds.isEmpty())
			{
				ret.setRowCount(""+failIds.size());
			}
		}
		else
		{
			ret.setErrorCode(ErrCode.ERR_CODE_1001001);
			ret.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		
		logger.info("ResourceController-->out pushDiscu");
		//返回
		return JSONObject.fromObject(ret).toString();
	}
	
	/**
	 * 公开推荐
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/pushToSys")
	@ResponseBody	
	public String pushToSys(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		logger.info("ResourceController-->in pushToSys");
		
		String retStr = "0";
		
		String resId = request.getParameter("id");
		
		Resource res = new Resource();
		try
		{
			res.setResourceId(resId);
			res.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			//推荐前先校验是否已被推荐
			List<Resource> resList = cRMService.getDbService().getResourceService().findResourceListByFilter(res);
			Resource temp = new Resource();
			if (null != resList && resList.size()>0)
			{
				temp = resList.get(0);
				
				//如果该文章已推荐
				if ("public".equals(temp.getResourceInfo2()))
				{
					retStr = "2";//文章已推荐
				}
				else
				{
					res.setResourceInfo2("public");//公开推荐标识
					cRMService.getDbService().getResourceService().updateResourceById(res);
				}
			}
			else
			{
				retStr = "1";//未找到对应的记录
			}
			//待处理，增加操作轨迹
		}
		catch(Exception ex)
		{
			logger.error(ex);
			retStr = "1";//异常
		}
		//返回
		logger.info("ResourceController-->out pushToSys");
		return retStr;
	}
	
	/**
	 * 获取系统推荐文章
	 * @return
	 */
	private List<Resource> getSysTopResources(Resource res)
	{
		return cRMService.getDbService().getResourceService().findResourceBySys(res);
	}
	
	/**
	 * 收藏系统文章
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/saveFromSys")
	@ResponseBody	
	public String saveFromSys(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		String resId = request.getParameter("resId");
		//查询文章详情
		Resource query = new Resource();
		query.setResourceId(resId);
		query.setPagecounts(new Integer(999));
		query.setCurrpages(new Integer(0));
		List<Resource> retList = cRMService.getDbService().getResourceService().findResourceListByFilter(query);
		
		if (null != retList && !retList.isEmpty())
		{
			Resource tempRes = retList.get(0);
			Resource newRes = new Resource();
			newRes.setResourceId(Get32Primarykey.getRandom32PK());
			//创建者为当前登陆用户
			newRes.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			//从系统文章中获取标题、内容、url、类型
			newRes.setResourceTitle(tempRes.getResourceTitle());
			newRes.setResourceContent(tempRes.getResourceContent());
			newRes.setResourceUrl(tempRes.getResourceUrl());
			newRes.setResourceType(tempRes.getResourceType());
			
			//根据title判断重复
			Resource searRes = new Resource();
			searRes.setResourceTitle(tempRes.getResourceTitle());
			searRes.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			searRes.setResourceUrl(tempRes.getResourceUrl());
			List<Resource> objSearRes = (List<Resource>)cRMService.getDbService().getResourceService().findObjListByFilter(searRes);
			int retInt = 0;
			if(objSearRes.size() == 0){
				retInt = cRMService.getDbService().getResourceService().addResource(newRes);
			}else{
				retInt = 2;
			}
			
			//为1则保存成功
			if (retInt == 1)
			{
				//拿到文章所有的图片关系，如果有则新增一套关系
				MessagesExt mext = new MessagesExt();
				mext.setRelaid(resId);
				mext.setPagecounts(new Integer(999));
				mext.setCurrpages(new Integer(0));
				List<MessagesExt>imgList = cRMService.getDbService().getResourceService().getAllMessagesExtByRelaId(mext);
				
				if (null != imgList && !imgList.isEmpty())
				{
					MessagesExt newMext = new MessagesExt();
					for (MessagesExt temp : imgList)
					{
						newMext.setRelaid(newRes.getResourceId());
						newMext.setFilename(temp.getFilename());
						newMext.setFiletype(temp.getFiletype());
						newMext.setSource_filename(temp.getSource_filename());
						newMext.setRelatype(temp.getRelatype());
						
						cRMService.getDbService().getMessagesExtService().addObj(newMext);
					}
				}
				
				//收藏成功则在原文章关系表中增加收藏量
				this.processRes(tempRes, "save");
			}
			else if (retInt == 2)
			{
				return "2";
			}
			else
			{
				return "1";
			}
		}
		
		return "0";//成功
	}
	
	/**
	 * 查询系统文章列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syslist")
	public String syslist(HttpServletRequest request, HttpServletResponse response)
			throws Exception 
	{
		logger.info("ResourceController-->in syslist");
		//查询对象
		Resource res = new Resource();
		//查询条件
		String condition = request.getParameter("resourceInfo3");
		
		//分页
		String currpage = request.getParameter("currpage");
		
		if (StringUtils.isNotNullOrEmptyStr(currpage))
		{
			res.setCurrpages(Integer.valueOf(currpage) * new Integer(10) + 1);
			res.setPagecounts(res.getCurrpages() - 1 + new Integer(10));
		}
		else
		{
			res.setCurrpages(new Integer(0));
			res.setPagecounts(new Integer(10));
			currpage = "0";
		}

		if (StringUtils.isNotNullOrEmptyStr(condition))
		{
			if (!StringUtils.regZh(condition))
			{
				condition = new String(condition.getBytes("ISO-8859-1"), "UTF-8");
			}
			res.setResourceInfo3(condition);
		}
		
		try
		{
			List<Resource>resList = cRMService.getDbService().getResourceService().findResourceBySys(res);
			
			if (null != resList && !resList.isEmpty())
			{
				request.setAttribute("sysList", resList);
			}
			else
			{
				request.setAttribute("sysList", new ArrayList<Resource>());
			}
			
			request.setAttribute("currpage", currpage);
			
			request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
			
		}
		catch(Exception ex)
		{
			throw ex;
		}
		
		logger.info("ResourceController-->out syslist");
		
		return "resource/syslist";
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syncsyslist")
	@ResponseBody
	public String syncsyslist(HttpServletRequest request, HttpServletResponse response)
			throws Exception 
	{
		logger.info("ResourceController-->in syslist");
		//查询对象
		Resource res = new Resource();
		//分页
		String currpages = request.getParameter("currpages");
		String pagecounts = request.getParameter("pagecounts");
		
		if (StringUtils.isNotNullOrEmptyStr(currpages))
		{
			res.setCurrpages(Integer.valueOf(currpages));
		}
		else
		{
			res.setCurrpages(new Integer(0));
		}
		
		if (StringUtils.isNotNullOrEmptyStr(pagecounts))
		{
			res.setPagecounts(Integer.valueOf(pagecounts));
		}
		else
		{
			res.setPagecounts(new Integer(10));
		}

		try
		{
			List<Resource>resList = cRMService.getDbService().getResourceService().findResourceBySys(res);
			
			if (null != resList && !resList.isEmpty())
			{
				return JSONArray.fromObject(resList).toString();
			}
		}
		catch(Exception ex)
		{
			throw ex;
		}
		logger.info("ResourceController-->out syncsyslist");
		
		return "";
	}
	
	/**
	 * 浏览文章后，增加浏览次数
	 * @param res
	 */
	public void processRes(Resource res, String type)
	{
		logger.info("ResourceController-->in explorRes");
		ResourceRela rela = new ResourceRela();
		rela.setRelaResourceId(res.getResourceId());
		rela.setRelaUserId(res.getCreator());
		if ("explorer".equals(type))
		{
			rela.setRelaExploreNum("1");
		}
		else if ("save".equals(type))
		{
			rela.setRelaInfo1("1");
		}
		else if ("share".equals(type))
		{
			rela.setRelaInfo2("1");
		}
		cRMService.getDbService().getResourceService().updateResourceRelaById(rela);
		logger.info("ResourceController-->out explorRes");
	}
	
	/**
	 * 发送微信通知
	 * @param inparams
	 */
	public void sendMessage(HashMap<String, Object> inparams)
	{
		if (!inparams.isEmpty())
		{
			String redirectUrl = (String)inparams.get("url");
			String content = (String)inparams.get("content");
			List<DiscuGroupUser> users = (List<DiscuGroupUser>)inparams.get("users");
			String type =  (String)inparams.get("messageType");
			
			if (!com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(type))
			{
				type = "auto";
			}
			
			if ("auto".equals(type))
			{
				for(DiscuGroupUser user : users)
				{
					content = content.replace("dis_name", "测试");
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId("oEImns7oxhKcCwKq-vPJ_6DvORUQ",null,null,content,redirectUrl);	
					
					/*Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.LOGINTIME_KEY+ "_" +user.getUser_id());
					if(null!=map&&map.keySet().size()>0)
					{
						String relaOpenId = (String)map.get("openId");
						String loginTime = (String)map.get("loginTime");
						String differtime = 172800000+"";//48小时
						if(!com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(loginTime)&&DateTime.comDate(loginTime, differtime, DateTime.DateTimeFormat1))
						{
							content = content.replace("dis_name", "测试");
							cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(relaOpenId,null,null,content,redirectUrl);	
						}
					}*/
				}
				
			}
			else if ("mail".equals(type))
			{
				
			}
			else if ("weixin".equals(type))
			{
				
			}
			else if ("message".equals(type))
			{
				/*for(DiscuGroupUser user : users)
				{
					Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.LOGINTIME_KEY+ "_" +user.getUser_id());
					if(null!=map&&map.keySet().size()>0){
						String relaOpenId = (String)map.get("openId");
						String loginTime = (String)map.get("loginTime");
						String differtime = 172800000+"";//48小时
						//若48小时未登录，则发送短信(20150204  短信模板没有定下来  暂时处理)
						if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(loginTime)&&DateTime.comDate(loginTime, differtime, DateTime.DateTimeFormat1)){
							String url = PropertiesUtil.getMsgContext("service.url1");
							String sn = PropertiesUtil.getMsgContext("service.sn");
							String pwd = PropertiesUtil.getMsgContext("service.pwd");
							pwd = MD5Util.getMD5(sn+pwd);
							String msg = PropertiesUtil.getMsgContext("message.model3");
							String signature = PropertiesUtil.getMsgContext("msg.signature");
							String msgmodule = URLEncoder.encode(msg+signature, "utf-8");
							List<NameValuePair> params = new ArrayList<NameValuePair>();
							params.add(new NameValuePair("sn", sn));
							params.add(new NameValuePair("pwd",pwd));
							params.add(new NameValuePair("mobile", str.split(",")[1]));
							params.add(new NameValuePair("content",msgmodule));
							params.add(new NameValuePair("ext", ""));
							params.add(new NameValuePair("stime", ""));
							params.add(new NameValuePair("rrid", ""));
							params.add(new NameValuePair("msgfmt", ""));
							HttpClient3Post.request(url, params.toArray(new NameValuePair[params.size()]));
						}else{//微信推送消息
							cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(relaOpenId,null,null,content,url);	
						}
					}
				}*/
			}
		}
	}
	
	/*public static void main(String[] args) 
	{
		StringBuffer temp = new StringBuffer();  
        try 
        {  
            //String url = "http://mp.weixin.qq.com/s?__biz=MzA5NzEzNjIwMQ==&mid=200319795&idx=3&sn=4ecd5fab9f572c12c0d3054f574b6a24&scene=2#rd";  
            String url = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5NDkzNTg2MQ==&appmsgid=200081705&itemidx=3&sign=35149432f15bcd3313050b7900673022&scene=2";
        	HttpURLConnection uc = (HttpURLConnection)new URL(url).  
                                   openConnection();  
            uc.setConnectTimeout(10000);  
            uc.setDoOutput(true);  
            uc.setRequestMethod("GET");  
            uc.setUseCaches(false);  

            InputStream in = new BufferedInputStream(uc.getInputStream());  
            Reader rd = new InputStreamReader(in, "UTF-8");  
            int c = 0;  
            while ((c = rd.read()) != -1) {  
                temp.append((char) c);  
            }  
         
            String info =temp.substring(temp.lastIndexOf("<script"),temp.length());
            //System.out.println(info);
            int title_post = info.indexOf("var msg_title");
            System.out.println("var msg_title:" + title_post);
            int desc_post = info.indexOf("var msg_desc");
            System.out.println("var msg_desc:" + desc_post);
            int url_post = info.indexOf("var msg_cdn_url");
            System.out.println("var msg_cdn_url:" + url_post);
            String title = info.substring(title_post,desc_post).split("=")[1];
            System.out.println(title);
            String desc = info.substring(desc_post,url_post).split("=")[1];
            System.out.println(desc);
            
            in.close();  
  
        } catch (Exception e)
        {  
            e.printStackTrace();  
        }  
	}*/
	
	
	@RequestMapping("/resInit")
	@ResponseBody	
	public String resInit(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		CatchPicture.initResourceImg(cRMService);
		return "resource/init";
	}
}
