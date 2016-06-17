package com.takshine.wxcrm.service;

import java.util.Date;
import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.CalendarRss;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.domain.Comments;
/**
 * 评论
 * @author dengbo
 *
 */
public interface CommentsService extends EntityService{
	public Integer	findWorkReportNoEvalCount(Comments comments) throws Exception;
}
