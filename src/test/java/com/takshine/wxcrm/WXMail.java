package com.takshine.wxcrm;

import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
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

import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.domain.Pair;

public class WXMail {
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

	public static void sendEmail(List<String> tos, String subject, String content) {
		Properties properties = new Properties();
		properties.put("mail.transport.protocol", "smtp");
		properties.put("mail.smtp.user", PropertiesUtil.getMailContext("mail.smtp.username"));
		properties.put("mail.smtp.host", PropertiesUtil.getMailContext("mail.smtp.host"));
		properties.put("mail.smtp.port", "25");
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
			e.printStackTrace();
		} finally {
			if (transport != null)
				try {
					transport.close();
				} catch (MessagingException logOrIgnore) {
				}
		}
	}
	
	public static void main(String[] args) throws Exception { 
		List<Pair<String, String>> reqs = new ArrayList<Pair<String,String>>();
		Pair<String,String> p = new Pair<String, String>("pengmd@takshine.com", "pengmd@takshine.com");
		reqs.add(p);
		List<Pair<String, String>> opts = new ArrayList<Pair<String,String>>();
		
		sendEventEmail(reqs,opts,new Date(),new Date(),"changsha","subject","content");
		
	}
}
