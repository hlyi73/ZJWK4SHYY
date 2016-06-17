package com.takshine.marketing.domain;

import java.util.ArrayList;
import java.util.List;

import com.takshine.marketing.model.ActivityModel;

/**
 * 
 * @author dengbo
 * 活动基本信息
 */
public class Activity extends ActivityModel {
	private String id;//主键
	private String title;//主题
	private String content;//内容
	private String start_date;//开始时间
	private String end_date;//报名截止时间
	private String expense;//预计费用
	private String type;//类型
	private String place;//活动地点
	private String logo; //活动主题图片	
	private Integer limit_number; //人数限制
	private String charge_type; //费用类型
	private String charge_typename; //费用类型
	private String display_member; //显示报名成员;
	private String status; //状态
	private String source;//来源
	private String createName;
	private String headImageUrl;
	private String firstChar;//首字母
	private String remark;//摘要
	private String enabled_flag;//enabled：可用；disabled：不可用
	private String create_by;
	private String ispublish;//是否公开
	private String islive;//1:直播；2：不直播
	private String isregist;//1：需要报名；2：不需要报名
	private String live_parameter;//需要直播，open：开放式；regist：需要报名
	private String charges;//需要直播，open：开放式；regist：需要报名
	private String contactlistval;//联系人列表
	private String customerlistval;//客户列表
	private String contactlistval1;//联系人列表 用于界内修改用
	private String customerlistval1;//客户列表 用于界面修改用
	private String phone;//联系人电话号码
	
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	private List<String> crm_id_in = null;
	private List<String> assignid_in = null;
	private String act_end_date;//活动结束时间
	
	private int readnum = 0;
	private int praisenum = 0;
	private int joinnum = 0;
	private int forwardnum = 0;
	private int commentnum=0;
	
	
	public String getContactlistval1() {
		return contactlistval1;
	}
	public void setContactlistval1(String contactlistval1) {
		this.contactlistval1 = contactlistval1;
	}
	public String getCustomerlistval1() {
		return customerlistval1;
	}
	public void setCustomerlistval1(String customerlistval1) {
		this.customerlistval1 = customerlistval1;
	}
	public String getCharge_typename() {
		return charge_typename;
	}
	public void setCharge_typename(String charge_typename) {
		this.charge_typename = charge_typename;
	}
	private String resopentime; //资料公开时间 0：马上公开，1：活动结束后公开
	
	public String getResopentime() {
		return resopentime;
	}
	public void setResopentime(String resopentime) {
		this.resopentime = resopentime;
	}
	public String getAct_end_date() {
		return act_end_date;
	}
	public void setAct_end_date(String act_end_date) {
		this.act_end_date = act_end_date;
	}
	public List<String> getCrm_id_in() {
		return crm_id_in;
	}
	public void setCrm_id_in(List<String> crm_id_in) {
		this.crm_id_in = crm_id_in;
	}
	public List<String> getAssignid_in() {
		return assignid_in;
	}
	public void setAssignid_in(List<String> assignid_in) {
		this.assignid_in = assignid_in;
	}
	public String getLive_parameter() {
		return live_parameter;
	}
	public void setLive_parameter(String live_parameter) {
		this.live_parameter = live_parameter;
	}
	public String getIslive() {
		return islive;
	}
	public void setIslive(String islive) {
		this.islive = islive;
	}
	public String getIsregist() {
		return isregist;
	}
	public void setIsregist(String isregist) {
		this.isregist = isregist;
	}
	public String getIspublish() {
		return ispublish;
	}
	public void setIspublish(String ispublish) {
		this.ispublish = ispublish;
	}
	public int getReadnum() {
		return readnum;
	}
	public void setReadnum(int readnum) {
		this.readnum = readnum;
	}
	public int getPraisenum() {
		return praisenum;
	}
	public void setPraisenum(int praisenum) {
		this.praisenum = praisenum;
	}
	public int getCommentnum() {
		return commentnum;
	}
	public void setCommentnum(int commentnum) {
		this.commentnum = commentnum;
	}
	public int getJoinnum() {
		return joinnum;
	}
	public void setJoinnum(int joinnum) {
		this.joinnum = joinnum;
	}
	public int getForwardnum() {
		return forwardnum;
	}
	public void setForwardnum(int forwardnum) {
		this.forwardnum = forwardnum;
	}
	//暂时把报名列表当成活动的一个字段传到PC端
	private List<Participant> pList = new ArrayList<Participant>();
	
	public List<Participant> getpList() {
		return pList;
	}
	public void setpList(List<Participant> pList) {
		this.pList = pList;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getEnabled_flag() {
		return enabled_flag;
	}
	public void setEnabled_flag(String enabled_flag) {
		this.enabled_flag = enabled_flag;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getFirstChar() {
		return firstChar;
	}
	public void setFirstChar(String firstChar) {
		this.firstChar = firstChar;
	}
	public String getCreateName() {
		return createName;
	}
	public void setCreateName(String createName) {
		this.createName = createName;
	}
	public String getHeadImageUrl() {
		return headImageUrl;
	}
	public void setHeadImageUrl(String headImageUrl) {
		this.headImageUrl = headImageUrl;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getLogo() {
		return logo;
	}
	public void setLogo(String logo) {
		this.logo = logo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	public String getExpense() {
		return expense;
	}
	public void setExpense(String expense) {
		this.expense = expense;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
	public Integer getLimit_number() {
		return limit_number;
	}
	public void setLimit_number(Integer limit_number) {
		this.limit_number = limit_number;
	}
	public String getCharge_type() {
		return charge_type;
	}
	public void setCharge_type(String charge_type) {
		this.charge_type = charge_type;
	}
	public String getDisplay_member() {
		return display_member;
	}
	public void setDisplay_member(String display_member) {
		this.display_member = display_member;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCharges() {
		return charges;
	}
	public void setCharges(String charges) {
		this.charges = charges;
	}
	public String getContactlistval() {
		return contactlistval;
	}
	public void setContactlistval(String contactlistval) {
		this.contactlistval = contactlistval;
	}
	public String getCustomerlistval() {
		return customerlistval;
	}
	public void setCustomerlistval(String customerlistval) {
		this.customerlistval = customerlistval;
	}
}
