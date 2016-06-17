package com.takshine.wxcrm.base.util;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URI;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import net.fortuna.ical4j.data.CalendarOutputter;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.TimeZoneRegistry;
import net.fortuna.ical4j.model.TimeZoneRegistryFactory;
import net.fortuna.ical4j.model.ValidationException;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.parameter.Cn;
import net.fortuna.ical4j.model.parameter.PartStat;
import net.fortuna.ical4j.model.parameter.Role;
import net.fortuna.ical4j.model.parameter.Rsvp;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.CalScale;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.Method;
import net.fortuna.ical4j.model.property.ProdId;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.model.property.Uid;
import net.fortuna.ical4j.model.property.Version;
import net.fortuna.ical4j.util.UidGenerator;

import org.apache.log4j.Logger;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.takshine.wxcrm.domain.Pair;


/**
 * 发送邮件的工具类
 * @author dengbo
 *
 */
public class MailUtils {
	
	//日志
	protected static Logger logger = Logger.getLogger(MailUtils.class);
	
	/**
     * 发送普通邮件,可以发送包含html内容的邮件
     * @param senderInfor
     */
    public static void sendEmail(SenderInfor senderInfor){
    	String emailHost = senderInfor.getEmailHost();
    	String emailFrom = senderInfor.getEmailFrom();
    	String emailUserName = senderInfor.getEmailUserName();
    	String emailPassword = senderInfor.getEmailPassword();
    	String toEmails = senderInfor.getToEmails();
    	String subject = senderInfor.getSubject();
    	String content = senderInfor.getContent();
//    	String ccemail = senderInfor.getCcemail();
//    	Map<String, String> pictures = senderInfor.getPictures();
    	Map<String, String> attachments =senderInfor.getAttachments();
        if ( !StringUtils.isNotNullOrEmptyStr(emailHost) ||!StringUtils.isNotNullOrEmptyStr(emailFrom)|| !StringUtils.isNotNullOrEmptyStr(emailUserName)||!StringUtils.isNotNullOrEmptyStr(emailPassword)) {  
        	logger.info("发件人信息不完全，请确认发件人信息！");  
        }  
        JavaMailSenderImpl senderImpl = new JavaMailSenderImpl();  
        // 设定mail server  
        senderImpl.setHost(emailHost); 
        logger.info("发送Start2.....");
        // 建立邮件消息  
        MimeMessage mailMessage = senderImpl.createMimeMessage();  
        try{
	        MimeMessageHelper messageHelper = null;  
	        messageHelper = new MimeMessageHelper(mailMessage, true, "UTF-8");  
	        // 设置发件人邮箱  
	        messageHelper.setFrom(emailFrom);  
	        // 设置收件人邮箱  
	        String[] toEmailArray = toEmails.split(";");
	        List<String> toEmailList = new ArrayList<String>();  
	        if (toEmailArray !=null && toEmailArray.length > 0) {  
	            for (String s : toEmailArray) {  
	            	if (StringUtils.isNotNullOrEmptyStr(s)&&s.contains("@")) { 
	            		//s="dengbo@takshine.com";
	            		toEmailList.add(s);  
	            	}  
	            }  
	            if (toEmailList!=null && toEmailList.size()> 0) {  
	            	toEmailArray = new String[toEmailList.size()];  
	            	for (int i = 0; i < toEmailList.size(); i++) { 
	            		toEmailArray[i] = toEmailList.get(i);  
	            	}

	            	messageHelper.setTo(toEmailArray);
	            	// 邮件主题  
	            	messageHelper.setSubject(subject);

	            	messageHelper.setText(content, true);  

	            	// 添加附件  
			        if (null != attachments) {  
			            for (Iterator<Map.Entry<String, String>> it = attachments  
			                    .entrySet().iterator(); it.hasNext();) {  
			                Map.Entry<String, String> entry = it.next();  
			                String cid = entry.getKey();  
			                String filePath = entry.getValue();  
			                if (null == cid || null == filePath) {  
			                    logger.info("请确认每个附件的ID和地址是否齐全！");  
			                }  
			  
			                File file = new File(filePath);  
			                if (!file.exists()) {  
			                    logger.info("附件" + filePath + "不存在！");  
			                }  
			  
			                FileSystemResource fileResource = new FileSystemResource(file);  
			                messageHelper.addAttachment(cid, fileResource);  
			            }  
			        }  
	            	Properties prop = new Properties(); 
	            	//将这个参数设为true，让服务器进行认证,认证用户名和密码是否正确
	            	prop.put("mail.smtp.auth", "true");   
	            	prop.put("mail.smtp.timeout", "25000");  
	            	//添加验证  
	            	MyAuthenticator auth = new MyAuthenticator(emailUserName, emailPassword);  
	            	Session session = Session.getDefaultInstance(prop, auth); 
	            	senderImpl.setSession(session); 
	            	// 发送邮件  
	            	senderImpl.send(mailMessage);
	            }  
	        } 
        }
        catch(Exception e){
        	logger.info("发送失败");
        } 
    } 
    
    
    /**
     * 发送事件类邮件
     * @param reqs
     * @param opts
     * @param startTime
     * @param endTime
     * @param location
     * @param name
     * @param content
     * @throws IOException
     * @throws ValidationException
     * @throws IllegalArgumentException
     */
    public static void sendEventEmail(List<Pair<String, String>> reqs, List<Pair<String, String>> opts, Date startTime, Date endTime, String location, String name, String content) throws IOException,
			ValidationException, IllegalArgumentException {
		if (reqs == null || reqs.isEmpty()) {
			throw new IllegalArgumentException("Required participant should not be empty!");
		}
		List<String> tos = new ArrayList<String>();
		
		DateTime start = new DateTime(startTime);
		DateTime end = new DateTime(endTime);
		VEvent meeting = new VEvent(start, end, name);
		TimeZoneRegistry registry = TimeZoneRegistryFactory.getInstance().createRegistry();
		// 设置时区
		TimeZone timezone = registry.getTimeZone("Asia/Shanghai");
		VTimeZone tz = timezone.getVTimeZone();
		meeting.getProperties().add(tz.getTimeZoneId());
		
		meeting.getProperties().add(new Location(location));
		meeting.getProperties().add(new Summary(name));
		meeting.getProperties().add(new Description(content));
		
		// 设置uid
		UidGenerator ug;
		Uid uid;
		ug = new UidGenerator("uidGen");
		uid = ug.generateUid();
		meeting.getProperties().add(uid);
		for (Pair<String, String> participant : reqs) {
			Attendee attendee = new Attendee(URI.create("mailto:" + participant.first()));
			attendee.getParameters().add(Role.REQ_PARTICIPANT);
			attendee.getParameters().add(PartStat.NEEDS_ACTION);
			attendee.getParameters().add(Rsvp.TRUE);
			attendee.getParameters().add(new Cn(participant.second()));
			meeting.getProperties().add(attendee);
			tos.add(participant.first());
		}
		
		if (opts != null && !opts.isEmpty()) {
			for (Pair<String, String> participant : opts) {
				Attendee attendee = new Attendee(URI.create("mailto:" + participant.first()));
				attendee.getParameters().add(Role.OPT_PARTICIPANT);
				attendee.getParameters().add(new Cn(participant.second()));
				meeting.getProperties().add(attendee);
				tos.add(participant.first());
			}
		}
		
		Calendar icsCalendar = new Calendar();
		icsCalendar.getProperties().add(new ProdId("-//Events Calendar//iCal4j 1.0//EN"));
		icsCalendar.getProperties().add(Version.VERSION_2_0);
		icsCalendar.getProperties().add(Method.REQUEST);
		icsCalendar.getProperties().add(CalScale.GREGORIAN);
		icsCalendar.getComponents().add(meeting);
		
		CalendarOutputter co = new CalendarOutputter(false);
		Writer wtr = new StringWriter();
		co.output(icsCalendar, wtr);
		String mailContent = wtr.toString();
		
		sendEmail(tos, name, mailContent);
	}
    
    /**
     * 发送事件类邮件
     * @param tos
     * @param subject
     * @param content
     */
    public static void sendEmail(List<String> tos, String subject, String content) {
		Properties properties = new Properties();
		properties.put("mail.transport.protocol", "smtp");
		properties.put("mail.smtp.user", PropertiesUtil.getMailContext("mail.smtp.username"));
		properties.put("mail.smtp.host", PropertiesUtil.getMailContext("mail.smtp.host"));
		properties.put("mail.smtp.port", PropertiesUtil.getMailContext("mail.smtp.port"));
		properties.put("mail.smtp.auth", PropertiesUtil.getMailContext("mail.smtp.auth"));

		final String username = PropertiesUtil.getMailContext("mail.smtp.username");
		final String password = PropertiesUtil.getMailContext("mail.smtp.password");
		Authenticator authenticator = new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		};

		Transport transport = null;

		try {
			Session session = Session.getDefaultInstance(properties, authenticator);
			MimeMessage mimeMessage = new MimeMessage(session);
			mimeMessage.setSubject(subject);

			for (String to : tos) {
				mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			}

			mimeMessage.setFrom(new InternetAddress(PropertiesUtil.getMailContext("mail.smtp.username")));

			mimeMessage.setContent(content, "text/calendar;method=REQUEST;charset=UTF-8");

			transport = session.getTransport();
			transport.connect(username, password);
			transport.sendMessage(mimeMessage, mimeMessage.getRecipients(javax.mail.Message.RecipientType.TO));
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			logger.error("发送事件类邮件错误："+e.toString());
		} finally {
			if (transport != null)
				try {
					transport.close();
				} catch (MessagingException logOrIgnore) {
					logger.error("发送事件类邮件错误："+logOrIgnore.toString());
				}
		}
	}
    
    //
    public static void main(String[] args) throws Exception { 
    	
    }  

}  
