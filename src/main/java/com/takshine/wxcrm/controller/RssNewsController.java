package com.takshine.wxcrm.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.log4j.Logger;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.ParseRss;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.RssNews;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.RssNewsService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 百度新闻订阅
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/news")
public class RssNewsController {
	    // 日志
		protected static Logger logger = Logger.getLogger(RssNewsController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		@RequestMapping("/subnews")
		public String subnews(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			logger.info("RssNewsController subnews openId ==>"+openId);
			logger.info("RssNewsController subnews publicId ==>"+publicId);
			logger.info("RssNewsController subnews crmId ==>"+crmId);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			return "rss/sub";
		}
		
		@RequestMapping("/list")
		public String list(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			currpage = (null == currpage ? "0" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			logger.info("RssNewsController list openId ==>"+openId);
			logger.info("RssNewsController list publicId ==>"+publicId);
			logger.info("RssNewsController list crmId ==>"+crmId);
			logger.info("RssNewsController list currpage ==>"+currpage);
			logger.info("RssNewsController list pagecount ==>"+pagecount);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				RssNews rssNews = new RssNews();
				rssNews.setCrmId(crmId);
				rssNews.setCurrpages(Integer.parseInt(currpage));
				rssNews.setPagecounts(Integer.parseInt(pagecount));
				List<RssNews> list = (List<RssNews>)cRMService.getDbService().getRssNewsService().findObjListByFilter(rssNews);
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("cssNews", list);
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			return "rss/list";
		}
		
		@RequestMapping("/alist")
		@ResponseBody
		public String alist(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			currpage = (null == currpage ? "0" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			String str="";
			CrmError crmErr = new CrmError();
			logger.info("RssNewsController alist openId ==>"+openId);
			logger.info("RssNewsController alist publicId ==>"+publicId);
			logger.info("RssNewsController alist crmId ==>"+crmId);
			logger.info("RssNewsController alist currpage ==>"+currpage);
			logger.info("RssNewsController alist pagecount ==>"+pagecount);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				RssNews rssNews = new RssNews();
				rssNews.setCrmId(crmId);
				rssNews.setCurrpages(Integer.parseInt(currpage)*Integer.parseInt(pagecount));
				rssNews.setPagecounts(Integer.parseInt(pagecount));
				List<RssNews> list = (List<RssNews>)cRMService.getDbService().getRssNewsService().findObjListByFilter(rssNews);
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				logger.info("cList is ->" + list.size());
				if(list!=null&&list.size()>0){
					str = JSONArray.fromObject(list).toString();
				}else{
					crmErr.setErrorCode("000000000");
					crmErr.setErrorMsg("操作失败!");
					str = JSONObject.fromObject(crmErr).toString();
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
				str = JSONObject.fromObject(crmErr).toString();
			}
			return str;
		}
		
		
		/**
		 * 查看订阅新闻的详情
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception 
		 */
		@RequestMapping("/detail")
		public String detail(HttpServletRequest request,HttpServletResponse response) throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String type=request.getParameter("type");
			String c=request.getParameter("class");
			String content = request.getParameter("content");
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			String url = "";
			String keyurl = Constants.RSSNEWS_KEYWORDS_URL;
			String digurl = Constants.RSSNEWS_DIGEST_URL;
			if(!StringUtils.regZh(content)){
				content = new String(content.getBytes("ISO-8859-1"),"UTF-8");
			}
			if("keywords".equals(type)){
				String word = URLEncoder.encode(content,"UTF-8");
				url= keyurl.replace("%word",word);
			}else{
				url =digurl.replace("%class", type+"&class="+c);
			}
			logger.info("RssNewsController saveRss openId ==>"+openId);
			logger.info("RssNewsController saveRss publicId ==>"+publicId);
			logger.info("RssNewsController saveRss crmId ==>"+crmId);
			logger.info("RssNewsController saveRss type ==>"+type+c);
			logger.info("RssNewsController saveRss word ==>"+content);
			try {
				List<RssNews> list = ParseRss.parseRss(url);
				request.setAttribute("rssnews", list);
			} catch (Exception e) {
				throw new Exception(e.getMessage());
			}
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			return "rss/detail";
		}
		
		/**
		 * 用户订阅
		 * @return
		 */
		@RequestMapping("/saveRss")
		@ResponseBody
		public String saveRss(RssNews rssNews ,HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = rssNews.getOpenId();
			String publicId = rssNews.getPublicId();
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			CrmError crmError = new CrmError();
			String url = "";
			String keyurl = Constants.RSSNEWS_KEYWORDS_URL;
			String digurl = Constants.RSSNEWS_DIGEST_URL;
			if("keywords".equals(rssNews.getType())){
				String word = URLEncoder.encode(rssNews.getContent(),"UTF-8");
				url= keyurl.replace("%word",word);
			}else{
				url =digurl.replace("%class", rssNews.getType());
			}
			logger.info("RssNewsController saveRss openId ==>"+openId);
			logger.info("RssNewsController saveRss publicId ==>"+publicId);
			logger.info("RssNewsController saveRss crmId ==>"+crmId);
			logger.info("RssNewsController saveRss type ==>"+rssNews.getType());
			logger.info("RssNewsController saveRss word ==>"+rssNews.getContent());
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				rssNews.setCrmId(crmId);
				rssNews.setUrl(url);
				String id = cRMService.getDbService().getRssNewsService().addObj(rssNews);
				if(StringUtils.isNotNullOrEmptyStr(id)){
					crmError.setErrorCode("0");
				}else{
					crmError.setErrorCode("1000000");
					crmError.setErrorMsg("操作失败");
				}
			}else{
				crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmError).toString();
		}
		
		/**
		 * 用户取消订阅
		 * @return
		 */
		@RequestMapping("/delRss")
		@ResponseBody
		public String delRss(RssNews rssNews ,HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = rssNews.getOpenId();
			String publicId = rssNews.getPublicId();
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			String flag = request.getParameter("flag");
			CrmError crmError = new CrmError();
			logger.info("RssNewsController delRss openId ==>"+openId);
			logger.info("RssNewsController delRss publicId ==>"+publicId);
			logger.info("RssNewsController delRss crmId ==>"+crmId);
			logger.info("RssNewsController delRss type ==>"+rssNews.getType());
			logger.info("RssNewsController delRss typflage ==>"+flag);
			logger.info("RssNewsController delRss word ==>"+rssNews.getContent());
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				try {
					cRMService.getDbService().getRssNewsService().deleteObjById(rssNews.getId());
					cRMService.getWxService().getWxHttpConUtil().removeSubRssFlag(crmId+";"+rssNews.getType());
					if("endRecoed".equals(flag)){
						rssNews.setType(null);
						rssNews.setCurrpages(0);
						rssNews.setCrmId(crmId);
						rssNews.setPagecounts(999999999);
						List<RssNews> list = (List<RssNews>)cRMService.getDbService().getRssNewsService().findObjListByFilter(rssNews);
						if(list!=null&&list.size()>0){
							crmError.setErrorCode("0");
							crmError.setErrorMsg("notEndRecoed");
						}
					}else{
						crmError.setErrorCode("0");
					}
				} catch (Exception e) {
					crmError.setErrorCode("00000000");
					crmError.setErrorMsg("操作失败!");
				}
			}else{
				crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmError).toString();
		}
		
		
		/**
		 * 用户是否订阅
		 */
		@RequestMapping("/isSub")
		@ResponseBody
		private String isSub(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String type = request.getParameter("type");
			CrmError crmError = new CrmError();
			String crmId = cRMService.getDbService().getRssNewsService().getCrmId(openId, publicId);
			logger.info("RssNewsController isSub openId ==>"+openId);
			logger.info("RssNewsController isSub publicId ==>"+publicId);
			logger.info("RssNewsController isSub crmId ==>"+crmId);
			logger.info("RssNewsController isSub type ==>"+type);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				try {
					String rst = cRMService.getWxService().getWxHttpConUtil().getCrmUserSubRssFlag(crmId+";"+type);
					logger.info("RssNewsController isSub rst ==>"+rst);
					crmError.setErrorCode("0");
					crmError.setErrorMsg(rst);
				} catch (Exception e) {
					crmError.setErrorCode("10000000");
					crmError.setErrorMsg("操作失败!");
				}
			}else{
				crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmError).toString();
		}
		
}
