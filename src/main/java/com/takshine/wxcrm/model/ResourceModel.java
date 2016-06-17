package com.takshine.wxcrm.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.domain.Tag;

/**
 * 资料模型
 * @author zhihe
 *
 */
public class ResourceModel extends BaseModel{
	
	private String resourceId = null; //资料ID 主键
	private String resourceName = null;//资料名称
	private String resourceType = null;//资料类型 link:链接/img:图片/txt:文本/fix:混合
	private String resourceTitle = null;//资料标题
	private String resourceContent = null;//资料内容
	private String resourceUrl = null;//资料URl
	private String resourceMark = null; //资料访问量
	private String resourceStatus = null;//资料状态
	private String resourceRemark = null;//资料备注
	private Date resourceCreateDate = null;//创建时间
	private Date resourceModifyDate = null;//修改时间
	private String resourceInfo1 = null;//预留字段1
	private String resourceInfo2 = null;//预留字段2
	private String resourceInfo3 = null;//预留字段3
	private String creator = null;//创建人
	private int readnum = 0;
	private String createName = null;
	private List<String> imgUrlList = new ArrayList<String>();
	private String createUrl =null;
	private String headImgUrl =null;
	private String resourceImg = null; //图片
	private String notinresid = null; //资源id notin
	
	
	public String getHeadImgUrl() {
		return headImgUrl;
	}
	public void setHeadImgUrl(String headImgUrl) {
		this.headImgUrl = headImgUrl;
	}
	public String getResourceImg() {
		return resourceImg;
	}
	public void setResourceImg(String resourceImg) {
		this.resourceImg = resourceImg;
	}
	public String getCreateUrl() {
		return createUrl;
	}
	public void setCreateUrl(String createUrl) {
		this.createUrl = createUrl;
	}
	public List<String> getImgUrlList() {
		return imgUrlList;
	}
	public void setImgUrlList(List<String> imgUrlList) {
		this.imgUrlList = imgUrlList;
	}
	public String getCreateName() {
		return createName;
	}
	public void setCreateName(String createName) {
		this.createName = createName;
	}
	public int getReadnum() {
		return readnum;
	}
	public void setReadnum(int readnum) {
		this.readnum = readnum;
	}
	private List<Tag> tagList = null;
	
	public List<Tag> getTagList() {
		return tagList;
	}
	public void setTagList(List<Tag> tagList) {
		this.tagList = tagList;
	}
	public String getResourceId() {
		return resourceId;
	}
	public void setResourceId(String resourceId) {
		this.resourceId = resourceId;
	}
	public String getResourceName() {
		return resourceName;
	}
	public void setResourceName(String resourceName) {
		this.resourceName = resourceName;
	}
	public String getResourceType() {
		return resourceType;
	}
	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}
	public String getResourceTitle() {
		return resourceTitle;
	}
	public void setResourceTitle(String resourceTitle) {
		this.resourceTitle = resourceTitle;
	}
	public String getResourceContent() {
		return resourceContent;
	}
	public void setResourceContent(String resourceContent) {
		this.resourceContent = resourceContent;
	}
	public String getResourceUrl() {
		return resourceUrl;
	}
	public void setResourceUrl(String resourceUrl) {
		this.resourceUrl = resourceUrl;
	}
	public String getResourceMark() {
		return resourceMark;
	}
	public void setResourceMark(String resourceMark) {
		this.resourceMark = resourceMark;
	}
	public String getResourceStatus() {
		return resourceStatus;
	}
	public void setResourceStatus(String resourceStatus) {
		this.resourceStatus = resourceStatus;
	}
	public String getResourceRemark() {
		return resourceRemark;
	}
	public void setResourceRemark(String resourceRemark) {
		this.resourceRemark = resourceRemark;
	}
	public Date getResourceCreateDate() {
		return resourceCreateDate;
	}
	public void setResourceCreateDate(Date resourceCreateDate) {
		this.resourceCreateDate = resourceCreateDate;
	}
	public Date getResourceModifyDate() {
		return resourceModifyDate;
	}
	public void setResourceModifyDate(Date resourceModifyDate) {
		this.resourceModifyDate = resourceModifyDate;
	}
	public String getResourceInfo1() {
		return resourceInfo1;
	}
	public void setResourceInfo1(String resourceInfo1) {
		this.resourceInfo1 = resourceInfo1;
	}
	public String getResourceInfo2() {
		return resourceInfo2;
	}
	public void setResourceInfo2(String resourceInfo2) {
		this.resourceInfo2 = resourceInfo2;
	}
	public String getResourceInfo3() {
		return resourceInfo3;
	}
	public void setResourceInfo3(String resourceInfo3) {
		this.resourceInfo3 = resourceInfo3;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getNotinresid() {
		return notinresid;
	}
	public void setNotinresid(String notinresid) {
		this.notinresid = notinresid;
	}
	
}
