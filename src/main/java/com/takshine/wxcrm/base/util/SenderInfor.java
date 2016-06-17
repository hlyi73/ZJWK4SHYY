package com.takshine.wxcrm.base.util;

import java.util.Map;

/**
 * 发送邮件的基本属性类
 * @author dengbo
 *
 */
public class SenderInfor {
	
	//发件人邮箱服务器 
    private String emailHost;  
    //发件人邮箱 
    private String emailFrom;  
    //发件人用户名 
    private String emailUserName;  
    //发件人密码 
    private String emailPassword;  
    //收件人邮箱，多个邮箱以“;”分隔 
    private String toEmails;  
    //邮件主题 
    private String subject;  
    //邮件内容 
    private String content;
    //抄送人
    private String ccemail;
    //邮件中的图片，为空时无图片。map中的key为图片ID，value为图片地址 
    private Map<String, String> pictures;  
    //邮件中的附件，为空时无附件。map中的key为附件ID，value为附件地址 
    private Map<String, String> attachments;  
    
    public String getEmailHost() {  
        emailHost = StringUtils.objToStr(emailHost);  
        if (!StringUtils.isNotNullOrEmptyStr(emailHost)) {  
            emailHost = PropertiesUtil.getMailContext("mail.smtp.host");  
        }  
        return emailHost;  
    }  
  
    public void setEmailHost(String emailHost) {  
        this.emailHost = emailHost;  
    }  
  
    public String getEmailFrom() {  
        emailFrom = StringUtils.objToStr(emailFrom);  
        if (!StringUtils.isNotNullOrEmptyStr(emailFrom)) {  
            emailFrom = PropertiesUtil.getMailContext("mail.smtp.from");  
        }  
        return emailFrom;  
    }  
  
    public void setEmailFrom(String emailFrom) {  
        this.emailFrom = emailFrom;  
    }  
  
    public String getEmailUserName() {  
        emailUserName = StringUtils.objToStr(emailUserName);  
        if (!StringUtils.isNotNullOrEmptyStr(emailUserName)) {  
            emailUserName = PropertiesUtil.getMailContext("mail.smtp.username");  
        }  
        return emailUserName;  
    }  
  
    public void setEmailUserName(String emailUserName) {  
        this.emailUserName = emailUserName;  
    }  
  
    public String getEmailPassword() {  
        emailPassword = StringUtils.objToStr(emailPassword);  
        if (!StringUtils.isNotNullOrEmptyStr(emailPassword)) {  
            emailPassword = PropertiesUtil.getMailContext("mail.smtp.password");  
        }  
        return emailPassword;  
    }  

    public void setEmailPassword(String emailPassword) {  
        this.emailPassword = emailPassword;  
    }  
  
    public String getToEmails() {  
        return StringUtils.objToStr(toEmails);  
    }  
  
    public void setToEmails(String toEmails) {  
        this.toEmails = toEmails;  
    }  
  
    public String getSubject() {  
        subject = StringUtils.objToStr(subject);  
        if (!StringUtils.isNotNullOrEmptyStr(subject)) {  
            subject = "无主题";  
        }  
        return StringUtils.objToStr(subject);  
    }  
  
    public void setSubject(String subject) {  
        this.subject = subject;  
    }  
  
    public String getContent() {
        return StringUtils.objToStr(content);  
    }  
  
    public void setContent(String content) {  
        this.content = content;  
    }  

	public Map<String, String> getPictures() {  
        return pictures;  
    }  
  
    public void setPictures(Map<String, String> pictures) {  
        this.pictures = pictures;  
    }  
  
    public Map<String, String> getAttachments() {  
        return attachments;  
    }  
  
    public void setAttachments(Map<String, String> attachments) {  
        this.attachments = attachments;  
    }

	public String getCcemail() {
		return ccemail;
	}

	public void setCcemail(String ccemail) {
		this.ccemail = ccemail;
	}
    
}
