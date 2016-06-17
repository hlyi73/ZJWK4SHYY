<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
</head>
<body style="  font-size: 32px;">
	<p id="demo">点击这个按钮，获得您的位置：</p>
	<button onclick="getLocation()">试一下</button>
	<div id="mapholder"></div>
	<div id="txtPosition"></div>

	<script>
		var x = document.getElementById("demo");
		function getLocation() {
			if (navigator.geolocation) {
				navigator.geolocation.getCurrentPosition(showPosition,
						showError);
			} else {
				x.innerHTML = "Geolocation is not supported by this browser.";
			}
		}

		function showPosition(position) {
			//获得经度纬度 
			 var x = position.coords.latitude;
			var y = position.coords.longitude;
			alert('latitude = >' + x);
			alert('longitude = >' + y); 
			//x = '28.21352';
			//y = '112.88376';

			//配置Baidu Geocoding API 
			var url = "http://api.map.baidu.com/geocoder/v2/?ak=C93b5178d7a8ebdb830b9b557abce78b"
					+ "&callback=renderReverse"
					+ "&location="
					+ x
					+ ","
					+ y
					+ "&output=json" + "&pois=0";
			$.ajax({
				type : "GET",
				dataType : "jsonp",
				url : url,
				success : function(json) {
					if (json == null || typeof (json) == "undefined") {
						return;
					}
					if (json.status != "0") {
						return;
					}
					setAddress(json.result.addressComponent);

				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					alert("[x:" + x + ",y:" + y + "]地址位置获取失败,请手动选择地址");
				}
			});
		}

		function showError(error) {
			switch (error.code) {
			case error.PERMISSION_DENIED:
				x.innerHTML = "User denied the request for Geolocation."
				break;
			case error.POSITION_UNAVAILABLE:
				x.innerHTML = "Location information is unavailable."
				break;
			case error.TIMEOUT:
				x.innerHTML = "The request to get user location timed out."
				break;
			case error.UNKNOWN_ERROR:
				x.innerHTML = "An unknown error occurred."
				break;
			}
		}

		/** 
		 * 设置地址 
		 */
		function setAddress(json) {
			var position = $("#txtPosition");
			//省 
			var province = json.province;
			//市 
			var city = json.city;
			//区 
			var district = json.district;
			var street = json.street;
			province = province.replace('市', '');
			position.html(province + "," + city + "," + district + "," + street);
		}
	</script>
</body>
</html>