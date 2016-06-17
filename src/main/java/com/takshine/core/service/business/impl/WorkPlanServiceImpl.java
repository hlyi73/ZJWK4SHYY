package com.takshine.core.service.business.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.WorkPlanService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Comments;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.UserPerferences;
import com.takshine.wxcrm.domain.WorkReport;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.template.TemplateUtils;

import edu.emory.mathcs.backport.java.util.Collections;

/**
 * 工作计划服务
 * @author Yihailong
 *
 */
@Service("coreBusinessWorkPlanService")
public class WorkPlanServiceImpl extends BaseServiceImpl implements WorkPlanService {
	protected static Logger logger = Logger.getLogger(WorkPlanServiceImpl.class.getName());
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;


	public List<WorkReport> getTeamWorkReports(String openid,Date start,Date end) throws CRMException {//我下属的
		try{
			WorkReport workReport = new WorkReport();
			if(start!=null){
				workReport.setStart_date(sdf.format(start));
			}
			if(end!=null){
				workReport.setEnd_date(sdf.format(end));
			}
			workReport.setOpenId(openid);
			workReport.setCurrpages(0);
			workReport.setPagecounts(999999);
			workReport.setOrderByString(" create_time asc ");
			workReport.setPagecounts(Constants.ALL_PAGECOUNT);
			
			
			
			List<WorkReport> wReportList = new ArrayList<WorkReport>();
			//默认查询我下属的工作计划
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setOpenId(openid);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			String assignerId = "";
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
				for(UserAdd userAdd:uResp.getUsers()){
					String userid = userAdd.getUserid();
					assignerId += userid+",";
				}
			}
			if(StringUtils.isNotNullOrEmptyStr(assignerId)){
				String[] assids = assignerId.split(",");
				List<String> assList = new ArrayList<String>();
				for(int i=0;i<assids.length;i++){
					assList.add(assids[i]);
				}
				workReport.setAssignid_in(assList);
				workReport.setAssigner_id("");
				wReportList = cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
				assignerId="";
			}
			return wReportList;
		}catch(Exception ec){
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,ec.getMessage()));
		}
	}

	public List<WorkReport> getMyWorkReports(String openid,Date start,Date end)  throws CRMException{
		try{
			WorkReport workReport = new WorkReport();
			if(start!=null){
				workReport.setStart_date(sdf.format(start));
			}
			if(end!=null){
				workReport.setEnd_date(sdf.format(end));
			}
			workReport.setOpenId(openid);
			workReport.setCurrpages(0);
			workReport.setPagecounts(999999);
			workReport.setOrderByString(" create_time asc ");
			workReport.setPagecounts(Constants.ALL_PAGECOUNT);

			return  cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
		}catch(Exception ec){
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,ec.getMessage()));
		}
	}

	public List<WorkReport> getAllWorkReports(Date start, Date end)
			throws CRMException {
		try{
			WorkReport workReport = new WorkReport();
			if(start!=null){
				workReport.setStart_date(sdf.format(start));
			}
			if(end!=null){
				workReport.setEnd_date(sdf.format(end));
			}
			workReport.setCurrpages(0);
			workReport.setPagecounts(999999);
			workReport.setOrderByString(" create_time asc ");
			workReport.setPagecounts(Constants.ALL_PAGECOUNT);

			return  cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
		}catch(Exception ec){
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,ec.getMessage()));
		}
	}

	public Set<String> getAllOpenId() throws CRMException {
		try{
			Set<String> retlist = new HashSet<String>();
			Organization obj = new Organization();
			obj.setCurrpages(0);
			obj.setPagecounts(10000);
			List<Organization> obs = (List<Organization>) this.cRMService.getDbService().getOrganizationService().findObjListByFilter(obj);
			for(Organization org : obs){
				try{
					for(String openid : this.getOpenIdByOrgId(org.getId())){
						try{
							if (retlist.contains(openid)) continue;
							retlist.add(openid);
						}catch(Exception ec){
							
						}
					}
				}catch(Exception ec){
					
				}
			}
			return retlist;
		}catch(Exception ec){
			ec.printStackTrace();
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,ec.getMessage()));
		}
	}

	public void exportAppraise(Date start,Date end) throws CRMException{
		try {
			for(String openid : getAllOpenId()){
				try{
					exportAppraise(openid, start, end);
				}catch(Exception ec){
					
				}
			}
		} catch (CRMException e) {
		}
		
	}

	public void exportAppraise(String openid, Date start, Date end)
			throws CRMException {
		List<WorkReport> myworkreports = new LinkedList<WorkReport>();
		List<WorkReport> teamworkreports = new LinkedList<WorkReport>();
		List<WorkReport> allworkreports = new LinkedList<WorkReport>();
		try{
			for(WorkReport wr : getMyWorkReports(openid, start, end)){
				try{
					if (wr.getCommnets().isEmpty()) continue;
					myworkreports.add(wr);
				}catch(Exception ec){
					
				}
			}
		}catch(Exception ec){
			
		}
		try{
			for(WorkReport wr : getTeamWorkReports(openid, start, end)){
				try{
					if (wr.getCommnets().isEmpty()) continue;
					teamworkreports.add(wr);
				}catch(Exception ec){
					
				}
			}
		}catch(Exception ec){
			
		}
		for(String crmid : this.getAllCrmidsByOpenId(openid)){
			try{
				for(WorkReport wr : getAllWorkReportsByHrManagerCrmId(crmid,start,end)){
					try{
						if (wr.getCommnets().isEmpty()) continue;
						allworkreports.add(wr);
					}catch(Exception ec){
						
					}
				}
			}catch(Exception ec){
				
			}
		}
		this.sendNotice(openid,myworkreports, teamworkreports, allworkreports,start, end);
	}

	
	public List<WorkReport> getAllWorkReportsByHrManagerCrmId(String crmid,
			Date start, Date end) throws CRMException {
		if (isHRInterface(crmid)){
			try{
				WorkReport workReport = new WorkReport();
				if(start!=null){
					workReport.setStart_date(sdf.format(start));
				}
				if(end!=null){
					workReport.setEnd_date(sdf.format(end));
				}
				String orgid = this.getOrgIdByCrmId(crmid);
				workReport.setOrgId(orgid);
				workReport.setCurrpages(0);
				workReport.setPagecounts(999999);
				workReport.setOrderByString(" create_time asc ");
				workReport.setPagecounts(Constants.ALL_PAGECOUNT);

				return  cRMService.getDbService().getWorkPlanService().searchWorkPlanList(workReport);
			}catch(Exception ec){
				throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,String.format("%s : %s", ErrCode.ERR_MSG_UNKNOWN,ec.getMessage()));
			}
		}
		throw new CRMException(ErrCode.ERR_CODE_1,ErrCode.ERR_MSG_1);
	}

	protected static final String HR_INTERFACE_CATEGORY = "HR_INTERFACE_CATEGORY";
	public void setHRInterface(String crmid, boolean isHrManager)
			throws CRMException {
		try {
			UserPerferences up = new UserPerferences();
			up.setUser_id(crmid);
			up.setCategory(HR_INTERFACE_CATEGORY);
			cRMService.getDbService().getUserPerferencesService().deleteUserPerferencesByParam(up);

			up.setId(Get32Primarykey.getRandom32PK());
			up.setUser_id(crmid);
			up.setCategory("HrManager");
			up.setContents(isHrManager ? "Y" : "N");
			up.setCreate_time(DateTime.currentDateTime());
			up.setModify_time(DateTime.currentDateTime());
			String id = cRMService.getDbService().getUserPerferencesService().addObj(up);
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + ":" + e.getMessage());
		}
		
	}

	
	public boolean isHRInterface(String crmid) throws CRMException {
		try {
			UserPerferences up = new UserPerferences();
			up.setUser_id(crmid);
			up.setCategory(HR_INTERFACE_CATEGORY);
			List<UserPerferences> list = (List<UserPerferences>) cRMService.getDbService().getUserPerferencesService().findObjListByFilter(up);
			if (list!=null){
				for(UserPerferences lup : list){
					return "Y".equals(lup.getContents());
				}
			}
			return false;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + ":" + e.getMessage());
		}
	}

	private BusinessCard getUser(String openid) throws Exception{
		WxuserInfo userinfo = this.cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openid);
		if (userinfo == null){
		    return null;
		}
		BusinessCard bc = new BusinessCard();
	    bc.setPartyId(userinfo.getParty_row_id());
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    for(BusinessCard bcl : list){
	    	return bcl;
	    }
	    return null;
	}
	
	public static final Comparator<WorkReport> sortWorkReport = new Comparator<WorkReport>(){

		public int compare(WorkReport o1, WorkReport o2) {
			if (o1.getCreator() == null) return -1;
			if (o2.getCreator() == null) return 1;
			int c1 = o1.getCreator().compareTo(o2.getCreator());
			//System.out.println(String.format("getCreator %s   %s   %d", o1.getCreator(),o2.getCreator(),c1));
			if (c1!=0) return c1;
			
			if (o1.getStart_date() == null) return -1;
			if (o2.getStart_date() == null) return 1;
			c1 = o1.getStart_date().compareTo(o2.getStart_date());
			//System.out.println(String.format("getStart_date %s   %s   %d", o1.getStart_date(),o2.getStart_date(),c1));
			if (c1!=0) return c1;
			
			if (o1.getTitle() == null) return -1;
			if (o2.getTitle() == null) return 1;
			c1 = o1.getTitle().compareTo(o2.getTitle());
			//System.out.println(String.format("getTitle %s   %s   %d", o1.getTitle(),o2.getTitle(),c1));
			if (c1!=0) return c1;
			return 0;
		}
		
		
	};
	
	public void sendNotice(String openid,List<WorkReport> myreport,
			List<WorkReport> teamreport, List<WorkReport> allreport,Date start, Date end)
			throws CRMException {
		try {
			if (myreport.isEmpty() && teamreport.isEmpty() && allreport.isEmpty() ) return;
			
			Collections.sort(myreport,sortWorkReport);
			Collections.sort(teamreport,sortWorkReport);
			Collections.sort(allreport,sortWorkReport);
			
			BusinessCard userinfo = getUser(openid);
			if (userinfo == null){
				throw new Exception("用户未找到");
			}
			Map<String,Object> data = new HashMap<String,Object>();
			data.put("myreport", myreport);
			data.put("teamreport", teamreport);
			data.put("allreport", allreport);
			data.put("userinfo", userinfo);
			data.put("now", sdf.format(new Date()));
			data.put("start", sdf.format(start));
			data.put("end", sdf.format(end));
			String content = TemplateUtils.getTemplateResult("exportAppraise.btl",data);
	
		
			SenderInfor senderInfor = new SenderInfor();
			
			senderInfor.setToEmails(userinfo.getEmail());
			//senderInfor.setToEmails("yihailong@takshine.com");
	    	if (!StringUtils.isNotNullOrEmptyStr(senderInfor.getToEmails())){
	    		throw new RuntimeException("Email Address is null!");
	    	}

			senderInfor.setContent(content);
			senderInfor.setSubject("评价结果报表");
			MailUtils.sendEmail(senderInfor);
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + ":" + e.getMessage());
		}
		
	}


	
	private void checkComment(Comments ci,List<Comments> list){
		if (ci.getCreate_time() == null){
			throw new RuntimeException("Create_time is null");
		}
		for(Comments c: list){
			if (c.getCreate_time() == null) continue;
			if (ci.getAssignerid().equals(c.getAssignerid())){
				if (ci.getCreate_time().compareTo(c.getCreate_time()) < 0){
					throw new RuntimeException("check Create_time is failure!");
				}
			}
		}
	}

	public List<Comments> getComments(String rowid) throws CRMException {
		List<Comments> retlist = new LinkedList<Comments>();
		try{
			Comments comments = new Comments();
			comments.setRela_id(rowid);
			comments.setRela_type("WorkReport");
			comments.setCurrpages(0);
			comments.setPagecounts(999999);
			List<Comments> list = (List<Comments>)cRMService.getDbService().getCommentsService().findObjListByFilter(comments);
			for(Comments comment : list){
				try{
					checkComment(comment,list);
					retlist.add(comment);
				}catch(Exception ec){
					
				}
			}
		}catch(Exception ec){
			
		}
		return retlist;
	}
	
	
	

}
