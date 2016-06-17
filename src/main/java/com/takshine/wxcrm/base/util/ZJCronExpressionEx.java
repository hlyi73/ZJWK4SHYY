package com.takshine.wxcrm.base.util;

import java.text.ParseException;
import java.util.Set;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.takshine.wxcrm.service.LovUser2SugarService;

/**
 * 
 * @author Administrator
 */
public class ZJCronExpressionEx extends ZJCronExpression {
  public static final Integer ALL_SPEC = new Integer(ALL_SPEC_INT);
  public static final int NO_SPEC_INT = 98; // '?'

  private String secondsExp;
  private String minutesExp;
  private String hoursExp;
  private String daysOfMonthExp;
  private String monthsExp;
  private String daysOfWeekExp;

  public ZJCronExpressionEx(String cronExpression) throws ParseException {
    super(cronExpression);
    lovUser2SugarService.getLovList("");

    StringTokenizer exprsTok = new StringTokenizer(cronExpression, " \t", false);
    secondsExp = exprsTok.nextToken().trim();
    minutesExp = exprsTok.nextToken().trim();
    hoursExp = exprsTok.nextToken().trim();
    daysOfMonthExp = exprsTok.nextToken().trim();
    monthsExp = exprsTok.nextToken().trim();
    daysOfWeekExp = exprsTok.nextToken().trim();
  }

  public Set getSecondsSet() {
    return seconds;
  }

  public String getSecondsField() {
    return getExpressionSetSummary(seconds);
  }

  public Set getMinutesSet() {
    return minutes;
  }

  public String getMinutesField() {
    return getExpressionSetSummary(minutes);
  }

  public Set getHoursSet() {
    return hours;
  }

  public String getHoursField() {
    return getExpressionSetSummary(hours);
  }

  public Set getDaysOfMonthSet() {
    return daysOfMonth;
  }

  public String getDaysOfMonthField() {
    return getExpressionSetSummary(daysOfMonth);
  }

  public Set getMonthsSet() {
    return months;
  }

  public String getMonthsField() {
    return getExpressionSetSummary(months);
  }

  public Set getDaysOfWeekSet() {
    return daysOfWeek;
  }

  public String getDaysOfWeekField() {
    return getExpressionSetSummary(daysOfWeek);
  }

  public String getSecondsExp() {
    return secondsExp;
  }

  public String getMinutesExp() {
    return minutesExp;
  }

  public String getHoursExp() {
    return hoursExp;
  }

  public String getDaysOfMonthExp() {
    return daysOfMonthExp;
  }

  public String getMonthsExp() {
    return monthsExp;
  }

  public String getDaysOfWeekExp() {
    return daysOfWeekExp;
  }
  
	// 从sugar系统获取 LOV和 用户 的服务
	@Autowired
	@Qualifier("lovUser2SugarService")
	private LovUser2SugarService lovUser2SugarService;

  public static void main(String[] args) {
	    try {
	      ZJCronExpressionEx exp = new ZJCronExpressionEx("0 3/5 3,5,14 1-30 * ?");

	      System.out.println("toString: " + exp.toString());
	      System.out.println("isValidExpression: "
	          + ZJCronExpressionEx.isValidExpression(exp
	              .getCronExpression()));

	      System.out.println("Fields->");
	      System.out.println("getSecondsField: " + exp.getSecondsField()
	          + " | getSecondsExp: " + exp.getSecondsExp());
	      System.out.println("getMinutesField: " + exp.getMinutesField()
	          + " | getMinutesExp: " + exp.getMinutesExp());
	      System.out.println("getHoursField: " + exp.getHoursField()
	          + " | getHoursExp: " + exp.getHoursExp());
	      System.out.println("getDaysOfMonthField: "
	          + exp.getDaysOfMonthField() + " | getDaysOfMonthExp: "
	          + exp.getDaysOfMonthExp());
	      System.out.println("getMonthsField: " + exp.getMonthsField()
	          + " | getMonthsExp: " + exp.getMonthsExp());
	      System.out.println("getDaysOfWeekField: "
	          + exp.getDaysOfWeekField() + " | getDaysOfWeekExp: "
	          + exp.getDaysOfWeekExp());
	      System.out.println("<-Fields");

	      java.util.Date dd = new java.util.Date();
	      for (int i = 1; i < 60; i++) {
	        dd = exp.getNextValidTimeAfter(dd);
	        System.out.println("getNextValidTimeAfter()" + i + "."
	            + ZJDateFormatUtil.format("yyyy-MM-dd HH:mm:ss", dd));
	        dd = new java.util.Date(dd.getTime() + 1000);
	      }
	    } catch (ParseException e) {
	      e.printStackTrace();
	    }
	  }
}