package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Itinerary;

/**
 * 行程
 *
 */
public interface ItineraryService extends EntityService{

	public boolean addItinerary(Itinerary itinerary) throws Exception;
	
	public boolean delItinerary(String id) throws Exception;
	public List<Itinerary> searchMyAndFriendItinerary(Itinerary itinerary) throws Exception;
	public List<String> searchMyAndFriendItineraryDate(Itinerary itinerary) throws Exception;
}
