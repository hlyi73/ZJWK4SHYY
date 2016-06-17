package com.takshine.wxcrm.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 团队成员  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/teampeason")
public class TeamPeasonController {
	    // 日志
		protected static Logger log = Logger.getLogger(TeamPeasonController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 *  查询绑定的团队成员列表
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/asynclist")
		@ResponseBody
		public String asynclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String relaId = request.getParameter("relaId");
			log.info("asynclist relaId = >" + relaId);
			TeamPeason search = new TeamPeason();
			search.setRelaId(relaId);
			search.setCurrpages(Constants.ZERO);
			search.setPagecounts(Constants.ALL_PAGECOUNT);
			
			//查询列表是否存在
			List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
			log.info("asynclist list = >" + list.size());
			
			return JSONArray.fromObject(list).toString();
		}
		
		/**
		 *  新增 团队成员
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save")
		@SuppressWarnings("unchecked")
		@ResponseBody
		public String save(TeamPeason teamPeason, HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrmError crmErr = new CrmError();
			
			String ownerOpenId = teamPeason.getOwnerOpenId();
			String openIds = teamPeason.getOpenId();
			String nickNames = teamPeason.getNickName();
			String relaId = teamPeason.getRelaId();
			String relaModel = teamPeason.getRelaModel();
			String relaName = teamPeason.getRelaName();
			String assigner = UserUtil.getCurrUser(request).getNickname(); //teamPeason.getAssigner();
			if(StringUtils.isNotNullOrEmptyStr(teamPeason.getRelaModel()) && "Contacts".equals(teamPeason.getRelaModel())){
					if(StringUtils.isNotNullOrEmptyStr(relaName)){
						//relaName = new String(relaName.getBytes("ISO-8859-1"),"UTF-8");
					}
					if(StringUtils.isNotNullOrEmptyStr(assigner)){
						//assigner = new String(assigner.getBytes("ISO-8859-1"),"UTF-8");
					}
			}
			//遍历openId
			String [] args = openIds.split(",");
			String [] names = nickNames.split(",");
			for (int i = 0; i < args.length; i++) {
				String openId = args[i];
				String name = names[i];
				if(StringUtils.isNotNullOrEmptyStr(teamPeason.getRelaModel()) && "Contacts".equals(teamPeason.getRelaModel())){
					if(StringUtils.isNotNullOrEmptyStr(name)){
						//name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
					}
				}
				
				if(null != openId && !"".equals(openId)){
					TeamPeason search = new TeamPeason();
					search.setOpenId(openId);
					search.setRelaId(relaId);
					//查询列表是否存在
					List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
					if(list.size() == 0 ){
						//插入新的数据
						TeamPeason add = new TeamPeason();
						add.setCreateTime(DateTime.currentDate());
						add.setOpenId(openId);
						add.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
						add.setNickName(name);
						add.setRelaId(relaId);
						add.setRelaModel(relaModel);
						add.setRelaName(relaName);
						add.setCreateBy(UserUtil.getCurrUserId(request));
						add.setCreateName(assigner);
						cRMService.getDbService().getTeamPeasonService().addObj(add);
						
						//发送客服消息
						sendMsg(teamPeason.getOrgId(),ownerOpenId, openId, name, relaModel, relaId, assigner, relaName, request);
					}
				}
			}
			
			crmErr.setErrorCode(ErrCode.ERR_CODE_0);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			return JSONObject.fromObject(crmErr).toString();
		}
		
		
//		/**
//		 * 发送消息给团队成员
//		 * @param relaId
//		 * @param name
//		 * @param relaName
//		 * @param relaModel
//		 * @param request
//		 */
//		private void sendMessage2Team(String relaId,String name,String relaName,String relaModel,HttpServletRequest request){
//			//通知团队所有成员
//			//查询当前任务下关联的共享用户
//			Share share = new Share();
//			share.setParentid(relaId);
//			share.setParenttype(relaModel);
//			share.setCrmId(UserUtil.getCurrUser(request).getCrmId());
//			//查询分享的用户名
//			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
//			List<ShareAdd> shareAdds = sresp.getShares();
//			String crmId = UserUtil.getCurrUser(request).getCrmId();
//			//遍历用户列表
//			for (int i = 0; i < shareAdds.size(); i++) {
//				ShareAdd add = shareAdds.get(i);
//				String uid = add.getShareuserid();
//				
//				//不给自己发
//				if(uid.equals(crmId)) continue;
//				
//				String param="";
//				
//				if("Opportunities".equals(relaModel)){
//					relaModel = "oppty";
//				}
//				else if("Accounts".equals(relaModel)){
//					relaModel = "customer";
//				}
//				else if("Cases".equals(relaModel)){
//					relaModel = "complaint";
//				}
//				else if("schedule".equals(relaModel)){
//					//param = "&schetype="+schetype;
//				}
//				else if("Campaigns".equals(relaModel)){
//					relaModel = "campaigns";
//				}
//				else if("Activity".equals(relaModel)){
//					relaModel = "zjactivity";
//				}
//				String cont = UserUtil.getCurrUser(request).getNickname()+ " 添加团队成员\r\n" + name;
//								
//				String url = "/"+relaModel+"/detail?rowId="+relaId+"&rowid="+relaId+"&orgId="+msg.getOrgId()+param;
//				//发送客服消息
//				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(uid, cont, url);
//			}
//		}
		
		
		/**
		 *  删除 团队成员
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/del")
		@ResponseBody
		public String del(TeamPeason teamPeason, HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrmError crmErr = new CrmError();
			
			TeamPeason tp = new TeamPeason();
			tp.setOpenId(teamPeason.getOpenId());
			tp.setRelaId(teamPeason.getRelaId());
			
			cRMService.getDbService().getTeamPeasonService().deleteTeamPeason(tp);
			
			crmErr.setErrorCode(ErrCode.ERR_CODE_0);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 发送客服消息
		 * @param openid 微信用户uID
		 * @param parenttype 关联模块类型
		 * @param rowId 关联模块ID
		 * @param crmname 发送人名字
		 * @param modelname 关联模块ID名字
		 * @param request 请求对象
		 */
		private void sendMsg(String orgId,String ownerOpenId,String openid, String nickname, String parenttype, String rowid, 
				                String crmname, String modelname, HttpServletRequest request){
			String model = "";
			String param = "&orgId="+orgId; //关注用户的openid
			StringBuffer sBuffer = new StringBuffer();
			sBuffer.append(crmname+"共享了");
			if("Accounts".equals(parenttype)){
				model = "/customer";
				sBuffer.append("客户"); 
			}else if("Opportunities".equals(parenttype)){
				model = "/oppty";
				sBuffer.append("业务机会"); 
			}else if("Contacts".equals(parenttype)){
				model = "/contact";
				sBuffer.append("联系人");  
			}else if("Tasks".equals(parenttype)){
				param += "&schetype=" + request.getParameter("schetype");
				model = "/schedule";
				sBuffer.append("任务"); 
			}else if("Contract".equals(parenttype)){
				model = "/contract";
				sBuffer.append("合同");  
			}else if("Project".equals(parenttype)){
				model = "/project";
				sBuffer.append("项目"); 
			}else if("Activity".equals(parenttype)){
				model = "/zjwkactivity";
				param += "&id=" + rowid+"&source=wkshare&ownerOpenId="+ownerOpenId;
			}else if("WorkReport".equals(parenttype)){
				model = "/workplan";
				sBuffer.append("工作计划"); 
			}
//			else if("Cases".equals(parenttype)){
//				model = "/complaint";
//				sBuffer.append("市场活动"); 
//				return;
//			}
			sBuffer.append("【"+modelname+"】"+"给您"); 
			
			cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(openid, ownerOpenId, PropertiesUtil.getAppContext("app.publicId"), 
				                                       sBuffer.toString(), model+"/detail?rowId=" + rowid + param);
		}
		
}
