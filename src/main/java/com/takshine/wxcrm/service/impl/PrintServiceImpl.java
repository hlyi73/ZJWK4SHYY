package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.domain.cache.CacheBase;
import com.takshine.wxcrm.model.ModelTag;
import com.takshine.wxcrm.model.PrintModel;
import com.takshine.wxcrm.service.PrintService;
import com.takshine.wxcrm.service.TagService;
@Service("printService")
public class PrintServiceImpl extends BaseServiceImpl  implements PrintService {

	@Override
	protected String getDomainName() {
		return "Print";
	}
	/**
	 * 获取sql配置文件命名空间
	 * 
	 * @return
	 */
	@Override
	protected String getNamespace() {
		return "printSql.";
	}

	public BaseModel initObj() {
		return new PrintModel();
	}

	public List<Print> getListAboutMy(PrintModel pm) {
		return getSqlSession().selectList(
				getNamespace() + "findPrintAboutMy", pm);
	}
    public int insert(Print print){
    	print.setId(Get32Primarykey.getRandom32PK());
    	return getSqlSession().insert(
				getNamespace() + "insertPrint", print);
    }
    
    /**
     * 获取访客列表
     * @return
     */
    public List<Print> getVisitUserList(PrintModel pm){
    	return getSqlSession().selectList(getNamespace() + "findVisitUserList", pm);
    }

    
    /**
     * 获取我的动态列表
     * @return
     */
    public List<Print> getMyPrintList(PrintModel pm){
    	return getSqlSession().selectList(getNamespace() + "findMyPrint", pm);
    }
}
