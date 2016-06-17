package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.CalendarRss;
import com.takshine.wxcrm.domain.Subscribe;

public interface CalendarService extends EntityService {
   public CalendarRss getCalendarRss(Subscribe s,String startDate,String endDate) throws Exception;
}
