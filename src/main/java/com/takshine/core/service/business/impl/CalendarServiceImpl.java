package com.takshine.core.service.business.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.core.service.business.CalendarService;
import com.takshine.core.service.exception.CRMException;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;

/**
 * 客户服务
 * @author dengbo
 *
 */
@Service("calendarCoreService")
public class CalendarServiceImpl implements CalendarService {
	protected static Logger logger = Logger.getLogger(CalendarServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public List<ScheduleAdd> getScheduleList(Schedule sche)
			throws CRMException {
		
		try {
			ScheduleResp sResp = cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				return sResp.getTasks();
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new CRMException(errorCode,sResp.getErrmsg());
				}
			}
			return new ArrayList<ScheduleAdd>();
		} catch (CRMException e) {
			throw e;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	}

	public ScheduleAdd getSchedule(String rowid) throws CRMException {
		// TODO Auto-generated method stub
		return null;
	}

	public void addSchedule(Schedule obj) throws CRMException{
		// TODO Auto-generated method stub
		
	}

	public void deleteSchedule(String rowid) throws CRMException{
		try {
			CrmError sResp = cRMService.getSugarService().getSchedule2SugarService().deleteSchedule(rowid);
			String errorCode = sResp.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode) == false){
				throw new CRMException(errorCode,sResp.getErrorMsg());
			}
		} catch (CRMException e) {
			throw e;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	
	}

	public void updateSchedule(Schedule obj) throws CRMException{
		try {
			CrmError sResp = cRMService.getSugarService().getSchedule2SugarService().updateScheduleComplete(obj, obj.getCrmId());
			String errorCode = sResp.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode) == false){
				throw new CRMException(errorCode,sResp.getErrorMsg());
			}
		} catch (CRMException e) {
			throw e;
		} catch (Exception e) {
			throw new CRMException(ErrCode.ERR_CODE_UNKNOWN,ErrCode.ERR_MSG_UNKNOWN + " : " + e.getMessage());
		}
	
	}

}
