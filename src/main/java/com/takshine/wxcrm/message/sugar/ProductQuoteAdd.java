package com.takshine.wxcrm.message.sugar;

/**
 * 产品报价model
 * @author dengbo
 *
 */
public class ProductQuoteAdd extends BaseCrm{
	
	private String producttype;//产品型号
	private String productname;//产品名称
	private String productamount;//预估单价
	private String productnumber;//数量
	private String productdecount;//产品折扣
	private String producttotal ;//产品总价格
	private String rowid;
	private String parentid;
	private String name;//报价名称
	private String productid;//产品ID
	private String assignerid;
	private String assignername;
	private String creater = "";//创建人
	private String createdate = "";//创建日期
	private String modifier = "";//修改人
	private String modifydate = "";//修改日期
	private String optype;//
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAssignername() {
		return assignername;
	}
	public void setAssignername(String assignername) {
		this.assignername = assignername;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public String getModifydate() {
		return modifydate;
	}
	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}
	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public String getProductid() {
		return productid;
	}
	public void setProductid(String productid) {
		this.productid = productid;
	}
	public String getRowid() {
		return rowid;
	}
	public void setRowid(String rowid) {
		this.rowid = rowid;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getProducttype() {
		return producttype;
	}
	public void setProducttype(String producttype) {
		this.producttype = producttype;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public String getProductamount() {
		return productamount;
	}
	public void setProductamount(String productamount) {
		this.productamount = productamount;
	}
	public String getProductnumber() {
		return productnumber;
	}
	public void setProductnumber(String productnumber) {
		this.productnumber = productnumber;
	}
	public String getProducttotal() {
		return producttotal;
	}
	public void setProducttotal(String producttotal) {
		this.producttotal = producttotal;
	}
	public String getProductdecount() {
		return productdecount;
	}
	public void setProductdecount(String productdecount) {
		this.productdecount = productdecount;
	}
	public String getAssignerid() {
		return assignerid;
	}
	public void setAssignerid(String assignerid) {
		this.assignerid = assignerid;
	}
}
