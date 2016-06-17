package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.Itinerary;
import com.takshine.wxcrm.service.ItineraryService;


@Service("itineraryService")
public class ItineraryServiceImpl extends BaseServiceImpl implements ItineraryService{

	@Override
	protected String getDomainName() {
		return "Itinerary";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "ItinerarySql.";
	}
	
	public BaseModel initObj() {
		return new Itinerary();
	}
	public boolean addItinerary(Itinerary itinerary) throws Exception {
		itinerary.setId(Get32Primarykey.getRandom32PK());
		int flag = this.getSqlSession().insert("ItinerarySql.insertItinerary", itinerary);
		if(flag>0){
			return true;
		}else{
			return false;
		}
	}

	public List<Itinerary> searchMyAndFriendItinerary(Itinerary itinerary)
			throws Exception {
		return this.getSqlSession().selectList("ItinerarySql.findMyAndFriendItineraryByOPenId", itinerary);
	}

	public List<String> searchMyAndFriendItineraryDate(Itinerary itinerary)
			throws Exception {
		return this.getSqlSession().selectList("ItinerarySql.findMyAndFriendItineraryDateByOPenId", itinerary);
	}

	public boolean delItinerary(String id) throws Exception {
		int flag =this.getSqlSession().delete("ItinerarySql.deleteItinerary", id);
		if(flag>0){
			return true;
		}else{
			return false;
		}
	}
	
	
}
