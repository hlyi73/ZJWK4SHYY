package com.takshine.wxcrm.base.util;

import java.util.Comparator;
import java.util.List;

import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;

import edu.emory.mathcs.backport.java.util.Collections;
/**
 * 索引工具类
 * @author Kater Yi
 *
 */
public class SortUtil {
	/**
	 * Modify by Kater Yi 2015/3/3 
	 * <br/>对ScheduleAdd/CampaignsAdd列表按开始时间，倒序排列
	 * @param list 需要排序的列表
	 * @return 排序结果
	 */
	public static final List<?> sortByDesc(List<?> list){
		//按开始时间倒序排列  modify by Kater Yi
		Comparator<Object> comp = new Comparator<Object>(){

			public int compare(Object o1, Object o2) {
				if (o1 instanceof ScheduleAdd && o2 instanceof ScheduleAdd){
					if (((ScheduleAdd)o1).getStartdate() == null) return -1;
					if (((ScheduleAdd)o2).getStartdate() == null) return 1;
					return ((ScheduleAdd)o2).getStartdate().compareTo(((ScheduleAdd)o1).getStartdate());
				}else
				if (o1 instanceof CampaignsAdd && o2 instanceof CampaignsAdd){
					if (((CampaignsAdd)o1).getStartdate() == null) return -1;
					if (((CampaignsAdd)o2).getStartdate() == null) return 1;
					return ((CampaignsAdd)o1).getStartdate().compareTo(((CampaignsAdd)o2).getStartdate());
				}else
					if (o1 instanceof ExpenseAdd && o2 instanceof ExpenseAdd){
						if (((ExpenseAdd)o1).getExpensedate() == null) return -1;
						if (((ExpenseAdd)o2).getExpensedate() == null) return 1;
						return ((ExpenseAdd)o1).getExpensedate().compareTo(((ExpenseAdd)o2).getExpensedate());
					}
					
				throw new RuntimeException("请检查需要排序的对象是否符合要求");
			}
			
		};
		Collections.sort(list,comp);
		return list;
	}

}
