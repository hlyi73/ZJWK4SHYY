package com.takshine.wxcrm.service.impl;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Menu;
import com.takshine.wxcrm.service.MenuService;

/**
 * 菜单服务
 * @author liulin
 *
 */
@Service("menuService")
public class MenuServiceImpl extends BaseServiceImpl implements MenuService{

	@Override
	protected String getDomainName() {
		return "Menu";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "menuSql.";
	}
	
	public BaseModel initObj() {
		return new Menu();
	}
	
}
