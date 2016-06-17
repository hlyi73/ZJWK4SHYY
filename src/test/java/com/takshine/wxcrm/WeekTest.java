package com.takshine.wxcrm;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
 
public class WeekTest {
 
    public static void main(String[] args) {
    	List<String> weekList = getCurrYearWeeks();
    	Collections.sort(weekList, new Comparator<String>(){ 
			public int compare(String s1,String s2){ 
                                //降序排列 
			    return Integer.valueOf(s2).compareTo(Integer.valueOf(s1)); 

                               //升序排列 
			   //return Long.valueOf(map1.getValue()).compareTo(Long.valueOf(map2.getValue())); 
			} 
		}); 
 
    	for(int i=0;i<weekList.size();i++){
    		System.out.println(weekList.get(i));
    	}
    }
 
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
    private static DecimalFormat df = new DecimalFormat("00");
 
    private static List<String> getCurrYearWeeks() {
		List<String> weekList = new ArrayList<String>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	    DecimalFormat df = new DecimalFormat("00");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        int currweek = calendar.get(Calendar.WEEK_OF_YEAR);
        int year = calendar.get(Calendar.YEAR);
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        calendar.set(Calendar.WEEK_OF_YEAR, 1);
        int week = 1;
        while (calendar.get(Calendar.YEAR) <= year) {
            if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY) {
            	
            	weekList.add(year + "" + df.format(week++));
                //StringBuilder builder = new StringBuilder();
                //builder.append("第").append(df.format(week++)).append("周 (");
                //builder.append(sdf.format(calendar.getTime())).append(" - ");
                calendar.add(Calendar.DATE, 6);
                //builder.append(sdf.format(calendar.getTime())).append(")");
                //System.out.println(builder.toString());
                if(week > currweek){
            		break;
            	}
            }
            calendar.add(Calendar.DATE, 1);
        }
        return weekList;
    }
}