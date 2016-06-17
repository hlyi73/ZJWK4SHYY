package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.message.sugar.BaseCrm;

public class IndexKPI extends BaseCrm{
   private String crmId;
   private String salesTargets="0";
   private String salesCompleted="0";
   private String collectionTargets="0";
   private String collectionCompleted="0";
   private String unfinishedTask="0";
   private String percentage="0";
public String getPercentage() {
	return percentage;
}
public void setPercentage(String percentage) {
	this.percentage = percentage;
}
public String getCrmId() {
	return crmId;
}
public void setCrmId(String crmId) {
	this.crmId = crmId;
}
public String getSalesTargets() {
	return salesTargets;
}
public void setSalesTargets(String salesTargets) {
	this.salesTargets = salesTargets;
}
public String getSalesCompleted() {
	return salesCompleted;
}
public void setSalesCompleted(String salesCompleted) {
	this.salesCompleted = salesCompleted;
}
public String getCollectionTargets() {
	return collectionTargets;
}
public void setCollectionTargets(String collectionTargets) {
	this.collectionTargets = collectionTargets;
}
public String getCollectionCompleted() {
	return collectionCompleted;
}
public void setCollectionCompleted(String collectionCompleted) {
	this.collectionCompleted = collectionCompleted;
}
public String getUnfinishedTask() {
	return unfinishedTask;
}
public void setUnfinishedTask(String unfinishedTask) {
	this.unfinishedTask = unfinishedTask;
}
}
