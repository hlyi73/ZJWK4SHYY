package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Star;

public interface StarModelService extends EntityService {
	
	
	
	public List<Star> findStarModelById(Star st);

	public void saveStar(Star st) throws Exception;
	
	public void delStar(Star st) throws Exception;

}
