package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Star;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.service.StarModelService;


/**
 * 星标与实体关联实现类
 *
 */
@Service("starModelService")
public class StarModelServiceImpl extends BaseServiceImpl implements StarModelService{

	/**
	 * 获取sql配置文件命名空间
	 * 
	 * @return
	 */
	@Override
	protected String getNamespace() {
		return "starModelSql.";
	}
	

	
	public BaseModel initObj() {
		return new Star();
	}

	public List<Star> findStarModelById(Star st) {
		List<Star> starList = getSqlSession().selectList("starModelSql.findStarModelById", st);
		return starList;
	}

	public void saveStar(Star st) throws Exception {
		getSqlSession().insert("starModelSql.insertModelStar", st);
		
	}



	public void delStar(Star st) throws Exception {
		getSqlSession().delete("starModelSql.deleteStarModel", st);
		
	}
	
	
     
}
