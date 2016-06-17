package com.takshine.core.service.business.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.AccountService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;

/**
 * 客户服务
 * @author dengbo
 *
 */
@Service("accountService")
public class AccountServiceImpl implements AccountService {
	protected static Logger logger = Logger.getLogger(AccountServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public List<CustomerAdd> getCustomerList(Customer sche)
			throws CRMException {
		
		try {
			CustomerResp sResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				return sResp.getCustomers();
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new CRMException(errorCode,sResp.getErrmsg());
				}
			}
			return new ArrayList<CustomerAdd>();
		} catch (CRMException e) {
			throw e;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	}

	public List<CustomerAdd> getCustomerListByCurrentUser(
			HttpServletRequest request, Customer sche) throws CRMException {
		try {
			
			// 绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			// 获取绑定的账户 在sugar系统的id
			if (!"".equals(crmId)) {
				sche.setCrmId(crmId);
				return getCustomerList(sche);
			}
			throw new CRMException(ErrCode.ERR_CODE_1001001,ErrCode.ERR_MSG_UNBIND);
		} catch (CRMException e) {
			throw e;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	}

	/**
	 * 获取单个客户信息
	 * @param cust 前台传入的查询对象
	 * @param flag 客户标志
	 * @return CustomerAdd 返回的客户对象
	 * @exception 
	 */
	public CustomerAdd getCustomerSingle(Customer cust, String flag) throws CRMException
	{
		CustomerAdd retCust = null;
		try
		{
			CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerSingle(cust, flag);
			if (null != cResp && null != cResp.getCustomers() && cResp.getCustomers().size() > 0)
			{
				retCust = cResp.getCustomers().get(0);
			}
			else
			{
				throw new CRMException(ErrCode.ERR_CODE_1001004,ErrCode.ERR_MSG_SEARCHEMPTY);
			}
		}
		catch(Exception e)
		{
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
		return retCust;
	}
	
	/**
	 * 判断是否在团队中
	 * @param request 请求对象
	 * @param rowId 前台传入的记录Id
	 * @param crmId 前台传入的suger Id
	 * @param source 查询时的parentType
	 * @return boolean 返回校验结果<预留>
	 * @exception 
	 */
	public List<ShareAdd> getShareUsers(HttpServletRequest request, String rowId, String crmId, String source) throws CRMException
	{
		boolean isTeamFlag = false;
		try
		{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			
			//查询当前关联的共享用户
			Share share = new Share();
			share.setParentid(rowId);
			share.setParenttype(Constants.PARENT_TYPE_CUSTOMER);
			share.setCrmId(crmId);
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			ShareAdd sa = null;
			for(int i=0;i<shareAdds.size();i++)
			{
				sa = shareAdds.get(i);
				if(crmId.equals(sa.getShareuserid()))
				{
					isTeamFlag = true;
					break;
				}
			}
			//CRM团队成员
			if(!isTeamFlag)
			{
				TeamPeason search = new TeamPeason();
				search.setRelaId(rowId);
				//查询团队列表-好友列表
				List<TeamPeason> fteamlist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
				for(int i=0;i<fteamlist.size();i++)
				{
					search = fteamlist.get(i);
					if(openId.equals(search.getOpenId()))
					{
						isTeamFlag = true;
						break;
					}
				}
			}
			//非团队成员
			/*if(!isTeamFlag)
			{
				throw new CRMException(ErrCode.ERR_CODE_1,ErrCode.ERR_MSG_1);
			}*/
			
			return shareAdds;
		}
		catch(Exception e)
		{
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
		
	}
	
	/**
	 * 判断是否绑定账户，并返回crmId和orgId
	 * @param request 请求对象
	 * @param orgId 前台传入的orgId
	 * @param rowId 前台传入的记录Id
	 * @return List 校验完成后返回的crmId和orgId，分别取下表0和1
	 * @exception 
	 */
	public List<String> checkBind(HttpServletRequest request, String orgId, String rowId) throws CRMException
	{
		ArrayList<String> retList = new ArrayList<String>();
		try
		{
			String openId = UserUtil.getCurrUser(request).getOpenId();
			String publicId = PropertiesUtil.getAppContext("app.publicId");
			
			String crmId = "";
			if(StringUtils.isNotNullOrEmptyStr(orgId))
			{
				crmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(openId, publicId, orgId);
			}
			else
			{
				crmId = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(rowId).getCrm_id();
				orgId = cRMService.getDbService().getCacheCustomerService().getOrgId(openId,publicId, crmId);
			}
			
			if(!StringUtils.isNotNullOrEmptyStr(crmId))
			{
				throw new CRMException(ErrCode.ERR_CODE_1001001, ErrCode.ERR_MSG_UNBIND);
			}
			
			//保存获取的crmId和orgId返回
			retList.add(crmId);
			retList.add(orgId);
		}
		catch (Exception e)
		{
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
		
		return retList;
	}
	
	/**
	 * 删除查询条件
	 * @param request 请求对象
	 * @param keyPrefix 存储redis的key前缀，不同的模块传入的不同，取常量
	 * @param condition 传入的查询条件
	 * @return String 响应对象
	 */
	public String delSearchCondition(HttpServletRequest request, String keyPrefix, String condition) throws CRMException
	{
		try
		{
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			if(StringUtils.isNotNullOrEmptyStr(condition)&&!StringUtils.regZh(condition))
			{
				condition = new String(condition.getBytes("ISO-8859-1"),"UTF-8");
			}
			CrmError crmErr = new CrmError();
			if(StringUtils.isNotNullOrEmptyStr(crmId))
			{
				Set<String> rs = RedisCacheUtil.getSortedSetRange(keyPrefix+ crmId, 0, 0);
				List<String> searchList = new ArrayList<String>();
				if(rs!=null)
				{
					RedisCacheUtil.delete("customer_search_" + crmId);
				}
				try
				{
					for (Iterator iterator = rs.iterator(); iterator.hasNext();)
					{
						String searchcon = (String) iterator.next();
						logger.info("CustomerController searchcache method searchcon=>"+ searchcon);
						if(!searchcon.contains(condition))
						{
							searchList.add(searchcon);
						}
					}
					for (int i = 0; i < searchList.size(); i++)
					{
						RedisCacheUtil.addToSortedSet(keyPrefix+crmId, searchList.get(i), i);
					}
					crmErr.setErrorCode("0");
				}
				catch(Exception e)
				{
					crmErr.setErrorCode("9");
				}
			}
			else
			{
				crmErr.setErrorCode(ErrCode.ERR_CODE__1);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_FAIL);
			}
			
			return JSONObject.fromObject(crmErr).toString();
		}
		catch(Exception e)
		{
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	}
}
