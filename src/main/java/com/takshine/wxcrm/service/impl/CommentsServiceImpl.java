package com.takshine.wxcrm.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Comments;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.service.CommentsService;
import com.takshine.wxcrm.service.MessagesService;

/**
 * 评论
 * @author dengbo
 *
 */
@Service("commentsService")
public class CommentsServiceImpl extends BaseServiceImpl implements CommentsService{

	@Override
	protected String getDomainName() {
		return "Comments";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "commentsSql.";
	}
	
	public BaseModel initObj() {
		return new Comments();
	}

	public Integer findWorkReportNoEvalCount(Comments comments)
			throws Exception {
		// TODO Auto-generated method stub
		return getSqlSession().selectOne("commentsSql.findWorkReportNoEvalCount", comments);
		
	}
	
}
