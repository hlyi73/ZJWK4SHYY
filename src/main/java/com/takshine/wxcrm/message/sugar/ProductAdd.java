package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 传递给crm 新增产品接口的参数
 * 
 * @author huangpeng
 *
 */
public class ProductAdd extends BaseCrm {

	private String rowid = null; // 记录ID
	private String name = null; // 产品名称
	private String startdate = null;// 开始时间
	private String enddate = null;// 结束时间
	private String version = null;
	private String type; // 类型
	private String paytype; // 付款类型
	private String price; // 价格
	private String showname; // 类别名称
	private String picklist; // 销售产品类别
	private String desc; // 产品说明
	private String assigner;//责任人名称
	
	private List<ProductAdd> parent = new ArrayList<ProductAdd>();// 产品父类
	private List<ProductPriceAdd> productPrice = new ArrayList<ProductPriceAdd>();// 价格列表
	private List<ProductCostAdd> costPrice = new ArrayList<ProductCostAdd>();// 成本列表

	
	public String getAssigner() {
		return assigner;
	}

	public void setAssigner(String assigner) {
		this.assigner = assigner;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPaytype() {
		return paytype;
	}

	public void setPaytype(String paytype) {
		this.paytype = paytype;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getShowname() {
		return showname;
	}

	public void setShowname(String showname) {
		this.showname = showname;
	}

	public String getPicklist() {
		return picklist;
	}

	public void setPicklist(String picklist) {
		this.picklist = picklist;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public List<ProductPriceAdd> getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(List<ProductPriceAdd> productPrice) {
		this.productPrice = productPrice;
	}

	public List<ProductCostAdd> getCostPrice() {
		return costPrice;
	}

	public void setCostPrice(List<ProductCostAdd> costPrice) {
		this.costPrice = costPrice;
	}

	public List<ProductAdd> getParent() {
		return parent;
	}

	public void setParent(List<ProductAdd> parent) {
		this.parent = parent;
	}

}
