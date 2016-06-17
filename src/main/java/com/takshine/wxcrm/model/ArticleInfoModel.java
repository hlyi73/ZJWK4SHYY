package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 文章信息
 * @author liulin
 *
 */
public class ArticleInfoModel extends BaseModel{
	
	private String typeId;//文章类别ID
	private String typeName;//文章类别名称
	private String orgName;//组织名称
	private String title;//标题
	private String descrition;//摘要
	private String content;//内容
	private String status;//状态
    private String image;//图片

	
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescrition() {
		return descrition;
	}
	public void setDescrition(String descrition) {
		this.descrition = descrition;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	
}
