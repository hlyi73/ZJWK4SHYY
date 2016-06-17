package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.model.PrintModel;


public interface PrintService extends EntityService{
	
 public List<Print> getListAboutMy(PrintModel pm);
 public int insert(Print print);
 
 /**
  * 获取访客列表
  * @return
  */
 public List<Print> getVisitUserList(PrintModel pm);
 
 
 /**
  * 获取我的动态列表
  * @return
  */
 public List<Print> getMyPrintList(PrintModel pm);
 
}
