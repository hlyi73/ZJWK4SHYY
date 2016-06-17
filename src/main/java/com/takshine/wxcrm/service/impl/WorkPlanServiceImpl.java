package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.WorkReport;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.WorkPlanService;

/**
 * 工作计划
 * @author dengbo
 *
 */
@Service("workPlanService")
public class WorkPlanServiceImpl extends BaseServiceImpl implements WorkPlanService{

	@Override
	protected String getDomainName() {
		return "WorkReport";
	}
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "workReportSql.";
	}
	
	public BaseModel initObj() {
		return new WorkReport();
	}

	public boolean updateWorkPlanStatusById(WorkReport wr) throws Exception {
		int rst = getSqlSession().update("workReportSql.updateWorkReportStatusById", wr);
		if(rst >0){
			return true;
		}
		return false;
	}

	/**
	 * 查询工作计划列表
	 */
	public List<WorkReport> searchWorkPlanList(WorkReport wr) throws Exception {
		List<WorkReport> wrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
		//我的
//		if(Constants.SEARCH_VIEW_TYPE_MYVIEW.equals(wr.getViewtype())){
//			wrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//		}
//		//我下属的
//		else if(Constants.SEARCH_VIEW_TYPE_TEAMVIEW.equals(wr.getViewtype())){
//			UserReq uReq  = new UserReq();
//			uReq.setCrmaccount(wr.getCrmId());
//			uReq.setCurrpage("1");
//			uReq.setPagecount("9999");
//			uReq.setFlag("");
//			uReq.setOpenId(wr.getOpenId());
//			UsersResp uResp = lovUser2SugarService.getUserList(uReq);
//			List<String> rstuid = new ArrayList<String>();
//			List<UserAdd> ulist = uResp.getUsers();
//			if(null != ulist && ulist.size()>0){
//				for (int j = 0; j < ulist.size(); j++) {
//					UserAdd ua = ulist.get(j);
//					String uid = ua.getUserid();
//					log.info("uid = >" + uid);
//					rstuid.add(uid);
//				}
//				wr.setCrm_id_in(rstuid);
//				wrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//			}			
//		}
//		//本部门的
//		else if(Constants.SEARCH_VIEW_TYPE_DEPARTVIEW.equals(wr.getViewtype())){
//			UserReq uReq  = new UserReq();
//			uReq.setCrmaccount(wr.getCrmId());
//			uReq.setCurrpage("1");
//			uReq.setPagecount("9999");
//			uReq.setFlag("depart");
//			uReq.setOpenId(wr.getOpenId());
//			UsersResp uResp = lovUser2SugarService.getUserList(uReq);
//			List<String> rstuid = new ArrayList<String>();
//			List<UserAdd> ulist = uResp.getUsers();
//			if(null != ulist && ulist.size()>0){
//				for (int j = 0; j < ulist.size(); j++) {
//					UserAdd ua = ulist.get(j);
//					String uid = ua.getUserid();
//					log.info("uid = >" + uid);
//					rstuid.add(uid);
//				}
//				wr.setCrm_id_in(rstuid);
//				wrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//			}
//		}
//		//好友的
//		else if(Constants.SEARCH_VIEW_TYPE_SHAREVIEW.equals(wr.getViewtype())){
//			List<String> rstuid = new ArrayList<String>();
//			TeamPeason team = new TeamPeason();
//			team.setOpenId(wr.getOpenId());
//			team.setRelaModel("WorkReport");
//			List<TeamPeason> list = (List<TeamPeason>)teamPeasonService.findObjListByFilter(team);
//			if(null != list && list.size() >0){
//				for(TeamPeason teampeoson : list){
//					String rowid = teampeoson.getRelaId();
//					log.info("rowid = >" + rowid);
//					rstuid.add(rowid);
//				}
//				wr.setRowid_in(rstuid);
//				wrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//			}
//		}
//		//所有的
//		else if(Constants.SEARCH_VIEW_TYPE_MYALLVIEW.equals(wr.getViewtype())){
//			//我的
//			wrList = new ArrayList<WorkReport>();
//			List<WorkReport> mywrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//			if(null != mywrList && mywrList.size() > 0){
//				wrList.addAll(mywrList);
//			}
//			//我下属的
//			UserReq uReq  = new UserReq();
//			uReq.setCrmaccount(wr.getCrmId());
//			uReq.setCurrpage("1");
//			uReq.setPagecount("9999");
//			uReq.setFlag("");
//			uReq.setOpenId(wr.getOpenId());
//			UsersResp uResp = lovUser2SugarService.getUserList(uReq);
//			List<String> rstuid = new ArrayList<String>();
//			List<UserAdd> ulist = uResp.getUsers();
//			if(null != ulist && ulist.size()>0){
//				for (int j = 0; j < ulist.size(); j++) {
//					UserAdd ua = ulist.get(j);
//					String uid = ua.getUserid();
//					log.info("uid = >" + uid);
//					rstuid.add(uid);
//				}
//				wr.setCrm_id_in(rstuid);
//				List<WorkReport> teamwrList = getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//				if(null != teamwrList && teamwrList.size() > 0){
//					wrList.addAll(teamwrList);
//				}
//			}	
//			//我好友的
//			rstuid.clear();
//			TeamPeason team = new TeamPeason();
//			team.setOpenId(wr.getOpenId());
//			team.setRelaModel("WorkReport");
//			List<TeamPeason> list = (List<TeamPeason>)teamPeasonService.findObjListByFilter(team);
//			if(null != list && list.size() >0){
//				for(TeamPeason teampeoson : list){
//					String rowid = teampeoson.getRelaId();
//					log.info("rowid = >" + rowid);
//					rstuid.add(rowid);
//				}
//				wr.setRowid_in(rstuid);
//				List<WorkReport> sharewrList = this.getSqlSession().selectList("workReportSql.findWorkReportListByFilter", wr);
//				if(null != sharewrList && sharewrList.size() > 0){
//					wrList.addAll(sharewrList);
//				}
//			}
//			
//			//排序
//			if(wrList.size() >0){
//				// 字符串排序
//			    Collections.sort(wrList, new Comparator() {
//			      public int compare(Object o1, Object o2) {
//			    	  return ((WorkReport)o2).getCreate_time().compareTo(((WorkReport)o1).getCreate_time());
//			      }
//			    });
//			}
//		}
		return wrList;
	}
	
	public int updateWorkPlanById(WorkReport workReport)throws Exception{
		int flag = this.getSqlSession().update("workReportSql.updateWorkReportById", workReport);
		return flag;
	}

	public List<WorkReport> searchAnalyticsList(WorkReport wr) throws Exception {
		return getSqlSession().selectList("workReportSql.analyticsWorkReport", wr);
	}

	public String checkWorkPlan(WorkReport wr) throws Exception {
		List<WorkReport> list = getSqlSession().selectList("workReportSql.findWorkReportByPartyIdAndDate", wr);
		if(list!=null&&list.size()>0){
			return "true";
		}else{
			return "false";
		}
	}

	public List<WorkReport> findWorkReportComments(WorkReport wr)
			throws Exception {
		return this.getSqlSession().selectList("workReportSql.findWorkReportComments", wr);
	}
	
}
