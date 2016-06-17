package com.takshine.wxcrm.domain;

import java.util.List;

import com.takshine.wxcrm.model.ItineraryModel;

public class ItineraryInfo {
   private String itinerarydate;
   private List<Itinerary> list;
public String getItinerarydate() {
	return itinerarydate;
}
public void setItinerarydate(String itinerarydate) {
	this.itinerarydate = itinerarydate;
}
public List<Itinerary> getList() {
	return list;
}
public void setList(List<Itinerary> list) {
	this.list = list;
}
}
