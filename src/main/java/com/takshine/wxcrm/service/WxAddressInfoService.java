package com.takshine.wxcrm.service;

/**
 * 地址信息服务
 * @author admin
 *
 */
public interface WxAddressInfoService {
	
	/**
	 * 根据经纬度查询地址信息
	 * @param lat
	 * @param lng
	 * @return
	 */
	public String getAddressNameByLatLng(String lat, String lng);
}
