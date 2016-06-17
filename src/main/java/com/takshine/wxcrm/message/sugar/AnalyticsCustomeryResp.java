package com.takshine.wxcrm.message.sugar;

/**
 * 客户报表接口 从crm响应回来的参数
 * 
 * @author chengzhiming
 *
 */
public class AnalyticsCustomeryResp extends BaseCrm {
	// 行业
	private String industry;

	// 人数
	private String accnt;
	
	//客户名称
	private String customername;  


	// 客户潜在时间
	private String duration;

	// 客户潜在数量
	private String customerNumber;

	// 行业
	private String industryname;

	private String rowid;
	
    private String province; //省
    private String city ; //地市
    
    private String value; //客户已产生价值

	
	

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getAccnt() {
		return accnt;
	}

	public void setAccnt(String accnt) {
		this.accnt = accnt;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public String getIndustryname() {
		return industryname;
	}

	public void setIndustryname(String industryname) {
		this.industryname = industryname;
	}

	public String getCustomername() {
		return customername;
	}

	public void setCustomername(String customername) {
		this.customername = customername;
	}


	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
