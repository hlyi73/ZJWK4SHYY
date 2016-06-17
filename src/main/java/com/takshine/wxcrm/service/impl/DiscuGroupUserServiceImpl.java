package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.DiscuGroupUserService;

/**
 * 讨论组用户  服务类
 *
 * @author liulin
 */
@Service("discuGroupUserService")
public class DiscuGroupUserServiceImpl extends BaseServiceImpl implements DiscuGroupUserService {
	
	//private static Logger log = Logger.getLogger(DiscuGroupServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Override
	protected String getDomainName() {
		return "DiscuGroupUser";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "discuGroupUserSql.";
	}
	
	public BaseModel initObj() {
		return new DiscuGroupUser();
	}
	
	/**
	 * 更新用户的状态
	 * @param dgu
	 */
	public void updateDiscuGroupUserType(DiscuGroupUser dgu){
		getSqlSession().update(getNamespace() + "updateDiscuGroupUserType", dgu);
	}
	
	/**
	 * 删除群用户
	 * @param dgu
	 */
	public void removeDiscuGroupUser(String dgid, String user_id, String dgname){
		//讨论组用户对象
		DiscuGroupUser dgu = new DiscuGroupUser();
		dgu.setDis_id(dgid);
		dgu.setUser_id(user_id);
		getSqlSession().update(getNamespace() + "deleteDiscuGroupUserByUserId", dgu);
		
		//推送微信消息
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(user_id);
		String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
		log.info("respSimpCustMsg openId =>" + openId);
		cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "您已被移除讨论组【"+dgname+"】", "");
		
	}
	
	/**
	 * 根据参数查询讨论组用户
	 * @param dgu
	 * @return
	 */
	public List<DiscuGroupUser> findDiscuGroupUserByParam(DiscuGroupUser dgu){
		return getSqlSession().selectList(getNamespace() + "findDiscuGroupUserByParam", dgu);
	}
	
	/**
	 * 根据参数查询所有的讨论组用户
	 * @param dgu
	 * @return
	 */
	public List<DiscuGroupUser> findAllDiscuGroupUser(DiscuGroupUser dgu){
		return getSqlSession().selectList(getNamespace() + "findAllDiscuGroupUser", dgu);
	}
}