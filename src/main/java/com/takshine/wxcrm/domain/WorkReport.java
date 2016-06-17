package com.takshine.wxcrm.domain;

import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;

import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.util.ServiceUtils;

/**
 * 工作计划
 * @author dengbo
 *
 */
public class WorkReport extends BaseModel{
	public static final DecimalFormat    df   = new DecimalFormat("######0.00");
	
	
	private String type;//week:周报,day:日报,month:月报
	private String start_date;//开始日期
	private String end_date;//结束日期
	private String title;//标题
	private String assigner_id;//责任人Id（关联partyId）
	private String status;//状态(draft:草稿，share:已分享，evaluation:已评价)
	private String remark;//备注
	private String create_time;//创建时间
	private String creator;//创建人
	private String headImgurl;//创建人头像
	private String rela_workid;
	private String viewtype;
	private String comments_grade;
	private String eval_type;
	private List<String> crm_id_in = null;
	private List<String> rowid_in = null;
	private List<String> assignid_in = null;

	public String getComments_grade() {
		return comments_grade;
	}
	public void setComments_grade(String comments_grade) {
		this.comments_grade = comments_grade;
	}
	public String getEval_type() {
		return eval_type;
	}
	public void setEval_type(String eval_type) {
		this.eval_type = eval_type;
	}
	public List<String> getAssignid_in() {
		return assignid_in;
	}
	public void setAssignid_in(List<String> assignid_in) {
		this.assignid_in = assignid_in;
	}
	public List<String> getCrm_id_in() {
		return crm_id_in;
	}
	public void setCrm_id_in(List<String> crm_id_in) {
		this.crm_id_in = crm_id_in;
	}
	public List<String> getRowid_in() {
		return rowid_in;
	}
	public void setRowid_in(List<String> rowid_in) {
		this.rowid_in = rowid_in;
	}
	public String getViewtype() {
		return viewtype;
	}
	public void setViewtype(String viewtype) {
		this.viewtype = viewtype;
	}
	public String getRela_workid() {
		return rela_workid;
	}
	public void setRela_workid(String rela_workid) {
		this.rela_workid = rela_workid;
	}
	public String getHeadImgurl() {
		return headImgurl;
	}
	public void setHeadImgurl(String headImgurl) {
		this.headImgurl = headImgurl;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAssigner_id() {
		return assigner_id;
	}
	public void setAssigner_id(String assigner_id) {
		this.assigner_id = assigner_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	
	public double getAppraisedGrade(){
		try {
			double total = 0;
			int count = 0;
			for(Comments c : getCommnets()){
				try{
					total += Double.parseDouble(c.getComments_grade());
					count++;
				}catch(Exception ec){
					
				}
			}
			if (count == 0){
				return 0;
			}
			return Double.parseDouble(df.format(total/count));
		} catch (Exception e) {
			return 0;
		}
	}
	List<Comments> comments = null;
	public List<Comments> getCommnets(){
		try {
			if (comments == null){
				comments = ServiceUtils.getCRMService().getBusinessService().getWorkPlanService().getComments(this.getId());
			}
			return comments;
		} catch (CRMException e) {
			return new LinkedList<Comments>();
		}
	}
}
