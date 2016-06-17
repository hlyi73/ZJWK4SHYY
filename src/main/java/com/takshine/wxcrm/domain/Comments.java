package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 评论
 * @author dengbo
 *
 */
public class Comments extends BaseModel{
	
	private String rela_id;//关联ID
	private String rela_type;//关联类型
	private String comments_grade;//评论等级
	private String comments;//评论内容
	private String creator;//创建者
	private String create_time;//创建时间
	private String assignerid;//责任人ID
	private String eval_type; //评价人等级（如上线、平级等）
	
	private String flag;//判断是否根据创建时间升序还是降序(asc升序；desc降序)
	
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getEval_type() {
		return eval_type;
	}
	public void setEval_type(String eval_type) {
		this.eval_type = eval_type;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
	public String getRela_id() {
		return rela_id;
	}
	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}
	public String getRela_type() {
		return rela_type;
	}
	public void setRela_type(String rela_type) {
		this.rela_type = rela_type;
	}
	public String getComments_grade() {
		return comments_grade;
	}
	public void setComments_grade(String comments_grade) {
		this.comments_grade = comments_grade;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	
	
}
