<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.takshine.wxcrm.base.util.PropertiesUtil" %>
<%
	String path = request.getContextPath();
    String ak = "2luih2a5UwPH2miq9CB0B6Gk";//PropertiesUtil.getAppContext("baidu.ak");
    String p1 = request.getParameter("p1");
    String p2 = request.getParameter("p2");
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
	<title>步行导航</title>    
	<style type="text/css">
		body, html, #allmap {width:100%; height:100%; overflow: hidden; margin:0;}
	</style>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=<%=ak%>"></script>
</head>
<body>
   	<div id="allmap"></div>
</body>
</html>
<script type="text/javascript">
	//创建起点 终点 的经纬度坐标
	var p1 = new BMap.Point(<%=p1%>);
	var p2 = new BMap.Point(<%=p2%>);
	//创建地图 设置中心坐标和默认缩放级别
	var map = new BMap.Map("allmap");
	map.centerAndZoom(new BMap.Point(<%=p1%>), 17);
	//右下角添加缩放按钮
	//map.addControl(new BMap.NavigationControl({anchor: BMAP_ANCHOR_BOTTOM_RIGHT, type: BMAP_NAVIGATION_CONTROL_ZOOM}));
	
	//步行导航检索
	var walking = new BMap.WalkingRoute(map, {renderOptions:{map: map, autoViewport: true}});
	walking.search(p1, p2);
</script>