package com.takshine.wxcrm.domain;

import java.util.ArrayList;
import java.util.List;

import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContractAdd;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.ProductAdd;

/**
 * 
 * 客户投诉 与 服务请求 模型
 * @author liulin
 *
 */
public class Complaint extends BaseDtm{
	//part01
	private String case_number;//服务请求编号、客户投诉编号
	private String finish_time;//关闭日期
	private String handle;//受理人 、投诉类：结案人
	private String handle_name;//受理人名字 、投诉类：结案人
	private String handle_org_name;//受理单位	根据用户带出
	private String created_by;//录入人 默认操作用户
	private String create_date;//录入时间 系统时间
	private String modified_by;//修改人
	private String modify_date;//修改时间
	private String subtype;//服务分类  "共用，如果是非投诉类，则为调试、维护、安装、投运 如果是投诉，则为服务及时性、服务态度、服务质量、产品质量、合同交付"
	private String subtype_name;//服务分类  "共用，如果是非投诉类，则为调试、维护、安装、投运 如果是投诉，则为服务及时性、服务态度、服务质量、产品质量、合同交付"
	private String status;//服务状态 "共用，如果是非投诉类，则为新建、已提交、已接受、已退回、服务已完成、关闭、问题遗留如果是投诉类，则为新建、处理中、已关闭"
	private String status_name;//服务状态 "共用，如果是非投诉类，则为新建、已提交、已接受、已退回、服务已完成、关闭、问题遗留如果是投诉类，则为新建、处理中、已关闭"
	private String name;//客户诉求   共用，如果是投诉，则为投诉内容
	private String servertype;//类型   共用，咨询、投诉、…    【complaint：投诉】  【case：非投诉类服务请求】
	
	private CustomerAdd customer;//客户
	private String customerid;//客户id
	private ContactAdd contact;//联系人
	private String contactid;//联系人id
	private OpptyAdd oppty;//项目[商机]
	private String opptyid;//项目[商机]id
	private ContractAdd contract;//合同
	private String contractid;//合同id
	private ProductAdd product;//产品
	private String productname;//主要产品

	//part02
	private String position;//服务所在地点 非投诉类使用
	private String propose_time;//要求服务日期 非投诉类使用
	private String industry;//所属行业
	private String stopday;//服务处理时长

	private String belong_org;//所属产业单位 非投诉类使用
	private String handle_date;//受理日期 非投诉类使用
	private String sponsor;//发起人 非投诉类使用
	private String sponsor_org_name;//发起人单位名称 非投诉类使用
	
	//part03
	private String complaint_source;//投诉来源 投诉使用，内部、外部
	private String closed_audit;//结案审核 投诉使用
	private String opinion;//客户服务部意见 投诉使用
	private String complaint_target;//投诉对象 投诉使用
	private String authority;//是否有分配权限,Y代表有权限,N代表没有
	
	//part04
	List<Complaint> comps = new ArrayList<Complaint>();//查询时候返回的集合列表

	
	public String getAuthority() {
		return authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	public String getCustomerid() {
		return customerid;
	}

	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}

	public String getContactid() {
		return contactid;
	}

	public void setContactid(String contactid) {
		this.contactid = contactid;
	}

	public String getOpptyid() {
		return opptyid;
	}

	public void setOpptyid(String opptyid) {
		this.opptyid = opptyid;
	}

	public String getModify_date() {
		return modify_date;
	}

	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}

	public String getContractid() {
		return contractid;
	}

	public void setContractid(String contractid) {
		this.contractid = contractid;
	}

	public String getProductname() {
		return productname;
	}

	public void setProductname(String productname) {
		this.productname = productname;
	}


	public String getCase_number() {
		return case_number;
	}

	public void setCase_number(String case_number) {
		this.case_number = case_number;
	}

	public String getFinish_time() {
		return finish_time;
	}

	public void setFinish_time(String finish_time) {
		this.finish_time = finish_time;
	}

	public String getHandle() {
		return handle;
	}

	public void setHandle(String handle) {
		this.handle = handle;
	}

	public String getHandle_name() {
		return handle_name;
	}

	public void setHandle_name(String handle_name) {
		this.handle_name = handle_name;
	}

	public String getHandle_org_name() {
		return handle_org_name;
	}

	public void setHandle_org_name(String handle_org_name) {
		this.handle_org_name = handle_org_name;
	}

	public String getCreated_by() {
		return created_by;
	}

	public void setCreated_by(String created_by) {
		this.created_by = created_by;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

	public String getModified_by() {
		return modified_by;
	}

	public void setModified_by(String modified_by) {
		this.modified_by = modified_by;
	}

	public String getSubtype() {
		return subtype;
	}

	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getServertype() {
		return servertype;
	}

	public void setServertype(String servertype) {
		this.servertype = servertype;
	}

	public CustomerAdd getCustomer() {
		return customer;
	}

	public void setCustomer(CustomerAdd customer) {
		this.customer = customer;
	}

	public ContactAdd getContact() {
		return contact;
	}

	public void setContact(ContactAdd contact) {
		this.contact = contact;
	}

	public OpptyAdd getOppty() {
		return oppty;
	}

	public void setOppty(OpptyAdd oppty) {
		this.oppty = oppty;
	}

	public ContractAdd getContract() {
		return contract;
	}

	public void setContract(ContractAdd contract) {
		this.contract = contract;
	}

	public ProductAdd getProduct() {
		return product;
	}

	public void setProduct(ProductAdd product) {
		this.product = product;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getPropose_time() {
		return propose_time;
	}

	public void setPropose_time(String propose_time) {
		this.propose_time = propose_time;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getBelong_org() {
		return belong_org;
	}

	public void setBelong_org(String belong_org) {
		this.belong_org = belong_org;
	}

	public String getHandle_date() {
		return handle_date;
	}

	public void setHandle_date(String handle_date) {
		this.handle_date = handle_date;
	}

	public String getSponsor() {
		return sponsor;
	}

	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}

	public String getSponsor_org_name() {
		return sponsor_org_name;
	}

	public void setSponsor_org_name(String sponsor_org_name) {
		this.sponsor_org_name = sponsor_org_name;
	}

	public String getComplaint_source() {
		return complaint_source;
	}

	public void setComplaint_source(String complaint_source) {
		this.complaint_source = complaint_source;
	}

	public String getClosed_audit() {
		return closed_audit;
	}

	public void setClosed_audit(String closed_audit) {
		this.closed_audit = closed_audit;
	}

	public String getOpinion() {
		return opinion;
	}

	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}

	public String getComplaint_target() {
		return complaint_target;
	}

	public void setComplaint_target(String complaint_target) {
		this.complaint_target = complaint_target;
	}

	public List<Complaint> getComps() {
		return comps;
	}

	public void setComps(List<Complaint> comps) {
		this.comps = comps;
	}

	public String getStopday() {
		return stopday;
	}

	public void setStopday(String stopday) {
		this.stopday = stopday;
	}

	public String getStatus_name() {
		return status_name;
	}

	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}

	public String getSubtype_name() {
		return subtype_name;
	}

	public void setSubtype_name(String subtype_name) {
		this.subtype_name = subtype_name;
	}
	
}
