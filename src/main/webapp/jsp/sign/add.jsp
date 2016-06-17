<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=134eca242394acd37ffbae329150e589"></script>
<script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/zjwk.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<style>
.noselect{
	display:none;
}

.selected{
	display:block;
}

</style>
<script type="text/javascript">
	 //微信网页按钮控制
	/* function initWeixinFunc(){
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});

		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	$(function () { 
		
		//initWeixinFunc();
		
		initForm2();
	});
	
	function initForm(){
		/*$(".currpois").click(function(){
			$(".currpois").each(function(){
				$(this).find(".flagdiv:eq(0)").removeClass("selected");
				$(this).find(".flagdiv:eq(0)").addClass("noselect");
			});
			$(this).find(".flagdiv:eq(0)").removeClass("noselect");
			$(this).find(".flagdiv:eq(0)").addClass("selected");
			$(":hidden[name=signAddr]").val($(this).find(".title:eq(0)").html() +"("+$(this).find(".addr:eq(0)").html()+")");
			//setPosition($(this).find(".title:eq(0)").attr("point"),$(this).find(".title:eq(0)").html());
			$(".address").html($(this).find(".title:eq(0)").html());
			$("#panel").hide();
		});*/
	} 
	
	function setCurrPosition(title,city,addr,obj){
		$(".flagdiv").addClass("noselect").removeClass("selected");
		$(obj).find(".flagdiv").addClass("selected");
		$(":hidden[name=signAddr]").val(title +"("+city+addr+")");
		$(".address").html(title);
		$("#panel").hide();
	}
	
	
	function initForm2(){
		$(".commitsign").click(function(){
			if($(":hidden[name=signAddr]").val()){
				$(":hidden[name=remark]").val($("#myContent").val());
				$("form[name=signform]").submit();
			}else{
				alert('无法确定您所在的地址，请重新定位！');
			}
		});
	}
</script>


</head>
<body style="min-height:100%;background-color:#fff;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;" class="_title_"><img src="<%=path%>/image/loading.gif">正在定位您的位置...</h3>
		
		<div class="act-secondary commitsign">
			<a href="javascript:void(0)" style="color:#fff;padding: 8px;">确定</a> 
		</div>
	</div>
	<a href="javascript:void(0);" id="address_list">
		<div style="font-size: 20px;width: 95%;margin-left: auto; margin-right: auto;padding:5px 0px;min-height:50px;">
			<div  class="address" style="float:left;font-size:16px;line-height:40px;">定位中...</div>
			<div style="float:right;margin-right: 5px;color:#ddd;line-height:40px;">></div>
		</div>
	</a>
	<%--地图 --%>
	<div style="width:100%;height:260px;" id="container">
	
	</div>
	
	<div class="content" style="margin: 8px;">
		<textarea id="myContent" class="myContent" style="border:0px;border-bottom:1px solid #ddd;" rows="3" placeholder="在此输入文字信息"></textarea>
	</div>
	<div style="clear:both"></div>
	<div style="width:100%;padding: 5px 8px;">
		<div style="padding-top: 15px; font-size: 8px; color: #fff;clear: both;" class="imageContaint">
			<img src="<%=path %>/image/mem_add.png" class="addimg" style="float:left;padding: 2px; color: #fff; border-radius: 5px;width:64px;">								
		</div>
	</div>
	<%--附近位置列表 --%>
	<div style="display:none;width:100%;position: absolute;top:0px;z-index:9999;background-color: #ffffff;min-height: 500px;" id="panel">
	
	</div>
	<form name="signform" action="<%=path%>/sign/save" method="post">
		<input type="hidden" name="signType" value="${signType}">
		<input type="hidden" name="signLongitude" value="${signLongitude}">
		<input type="hidden" name="signLatitude" value="${signLatitude}">
		<input type="hidden" name="openId" value="${openId}">
		<input type="hidden" name="orgId" value="${orgId}">
		<input type="hidden" name="crmId" value="${crmId}">
		<input type="hidden" name="signAddr" value="">
		<input type="hidden" name="wximgids" value="">
		<input type="hidden" name="remark" value="">
	</form>
</body>
</html>
<jsp:include page="/common/wxjs.jsp"></jsp:include>
<script type="text/javascript">
var signLatitude = "${signLatitude}";
var signLongitude = "${signLongitude}";
var map = new BMap.Map("container");
//var mPoint = new BMap.Point(112.897252, 28.216368);
var mPoint = new BMap.Point(signLatitude, signLongitude);
map.centerAndZoom(mPoint, 15);
map.enableScrollWheelZoom();        //启用滚轮缩放
map.addControl(new BMap.NavigationControl());

//var marker = new BMap.Marker(mPoint);  // 创建标注
//map.addOverlay(marker);               // 将标注添加到地图中
//marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画

var task = setTimeout(function(){
    BMap.Convertor.translate(mPoint,0,translateCallback);     //真实经纬度转成百度坐标
}, 2000);

//坐标转换完之后的回调函数
function translateCallback(point){
	mPoint = point;
	clearTimeout(task);
    //var marker1 = new BMap.Marker(point);
    //map.addOverlay(marker1);
    //var label = new BMap.Label(" ",{offset:new BMap.Size(20,-10)});
    //marker1.setLabel(label); //添加百度label
    map.setCenter(point);
	$("._title_").html('选择当前位置');
	displayPOI();
	mSearch();
}

function displayPOI(){
	var mOption = {
		poiRadius : 1000,           //半径为1000米内的POI,默认100米 
		numPois : 10              //列举出50个POI,默认10个 
	}
	var myGeo = new BMap.Geocoder();        //创建地址解析实例
    //map.addOverlay(new BMap.Circle(mPoint,500));        //添加一个圆形覆盖物
    myGeo.getLocation(mPoint,
        function mCallback(rs){
            var allPois = rs.surroundingPois;       //获取全部POI（该点半径为100米内有6个POI点）
            var val = "";
            var i = 0;
            if(allPois.length > 0){
	            	$(".address").html(allPois[i].title);
	            	val += "<div class='currpois' onclick='setCurrPosition(\""+allPois[i].title+"\",\""+allPois[i].city+"\",\""+allPois[i].address+"\",this)' style='line-height:20px;font-size:14px;border-top:1px solid #efefef;min-height:55px;'>"; 
	            	val += '<div style="float:left;width:40px;padding:5px;"><img src="<%=path%>/image/map_icon.png" style="width:24px;"></div>'; 
	                val += '<div style="float:left;width:70%;"><div class="title" style="padding:5px 0px;color:#000;">' + allPois[i].title + '</div>';
					val += '<div class="addr" style="padding-bottom:5px;color:#999;font-size:12px;line-height:20px;">' + allPois[i].city + allPois[i].address + '</div></div>';
	                $(":hidden[name=signAddr]").val(allPois[i].title +"(" + allPois[i].city+allPois[i].address+")");
					setPosition(allPois[i].point,allPois[i].title)
	                val += '<div class="flagdiv selected" style="float:right;width:25px;min-height:55px;line-height:55px;margin-right:5px;"><img src="<%=path%>/image/oper_success.png" style="width:24px;"></div>';
	                val += "</div>";
	                val += "<div style='clear:both;'></div>";
            }
            $("#panel").html(val);
        },mOption
    );
}
var local;
var num = 0;
function mSearch(){
	var myKeys = ['公司企业','金融','教育','医院','医疗','建筑'];

	//var myKeys = ['酒店', '加油站'];
    local = new BMap.LocalSearch(map, {onSearchComplete:onSearchComplete});  
    //local.setSearchCompleteCallback(onSearchComplete);  
    num = 0;
    local.searchNearby(myKeys,mPoint,500);
}

function onSearchComplete(result){
   var size = result.length;
   for(var i=0;i<size;i++){
       var n = result[i].getNumPois();  
       var j = 0;  
 
       for (j = 0; j < result[i].getCurrentNumPois() ; j++) { 
           var poi = result[i].getPoi(j); 
           if(!poi.title || !poi.address){
        	   continue;
           }
           var val = "";
           val += "<div class='currpois' onclick='setCurrPosition(\""+poi.title+"\",\""+poi.city+"\",\""+poi.address+"\",this)' style='line-height:20px;font-size:14px;border-top:1px solid #efefef;min-height:55px;'>"; 
       	   val += '<div style="float:left;width:40px;padding:5px;"><img src="<%=path%>/image/map_icon.png" style="width:24px;"></div>'; 
           val += '<div style="float:left;width:70%;"><div class="title" style="padding:5px 0px;color:#000;">' + poi.title + '</div>';
		   val += '<div class="addr" style="padding-bottom:5px;color:#999;font-size:12px;line-height:20px;">' + poi.city + poi.address + '</div></div>';
           val += '<div class="flagdiv noselect" style="float:right;width:25px;min-height:55px;line-height:55px;margin-right:5px;"><img src="<%=path%>/image/oper_success.png" style="width:24px;"></div>';
           val += "</div>";
           val += "<div style='clear:both;'></div>";
           num ++;
           $("#panel").append(val);
       }  
       // 判断是否到最后一页，如果是则不再搜索  
       //因数据量太大，目前最多支持3页
       if (result[i].getPageIndex() < result[i].getNumPages() - 1 && result[i].getPageIndex() <= 3){
           local.gotoPage(result[i].getPageIndex() + 1);  
       }
   }
   $(".anchorBL").css('display','none');
   initForm();
   
}

function setPosition(point,title){
	var marker = new BMap.Marker(point);
	map.addOverlay(marker);
	var label = new BMap.Label(title,{offset:new BMap.Size(20,-10)});
	marker.setLabel(label); //添加百度label
}
 


 var fileName="";

wx.ready(function () {
	//alert('wx ready');
	$(".addimg").click(function(){
		//alert('addimg click');
		if($(".messages_imgs_list").size() > 9){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("上传的图片不能超过9张!");
			$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		wxjs_chooseImage({
			  success: function(res){
				 //alert('服务器上传成功');
				 sleep(1000);
				 wxjs_uploadImage({
					 success: function(images){
						 var localids = images.localId;
						 var serverids = images.serverId;
						 var v = "";
						 for(var i=0;i<localids.length;i++){
							 v += '<div class="single_image" style="float: left;"><img style="margin:2px;" class="messages_imgs_list" onclick="zjwk_prev_img(\"messages_imgs_list\",this)" src="'+localids[i]+'" width="64px;" height="64px" style="float:left;width:64px;height:64px;">';
							 v += '<img src="<%=path %>/image/fasdel.png" class="delImg" style="margin-top:-50;margin-left: -10px;cursor: pointer; height: 15px; width: 15px; position: relative; top: -2px; left: 0px;"></div>';
						 }

						 $(".imageContaint").before(v);
						 try{
							 var req = {
						    			imgids:serverids,
						    			relaId:"11",
						    			relaType:'Resource',
						    			fileType:'img'
						    		};
								 download4WXToOss(req, {
										success: function(res){
											if(res.status!='unknown'){
												//alert("res.status:"+res.status)
												fileName+=res.status;
												 $(":hidden[name=wximgids]").val(fileName);
											}
										}
								}); 
						 }catch (e) {
							// TODO: handle exception
 
						}	
						 sleep(1000);
						// $(":hidden[name=wximgids]").val(serverids);
						// $(":hidden[name=wximgids]").val(fileName);
						 //wxjs_downloadImage();
						 //删除图片
						 $(".delImg").click(function(){
							 $(this).parent().remove();
						 });
					 }
				 });
			  }
		});
	});
});

//睡一秒
function sleep(numberMillis) { 
   var now = new Date();
   var exitTime = now.getTime() + numberMillis;  
   while (true) { 
       now = new Date(); 
       if (now.getTime() > exitTime)    return;
   }
}

$("#address_list").click(function(){
    $("#panel").show();
	
});

//从微信服务器上下载文件
function download4WXToOss(req,setting){
	if(!setting) setting = {};
	var res = {
		status :[]
	};
	$.ajax({
		type: 'post',
		url : getContentPath()+'/files/down4wxToOss',	
    data: {
    	relaid:req.relaId,
    	serverids:"'"+req.imgids+"'",
    	relatype:req.relaType,
    	filetype:req.fileType
    },
    dataType: 'text',
	    success: function(data){
	    	if(data && data != 'unknown'){
		    	if(setting.success){
		    		res.status =data;
		      		setting.success(res);
		      	}
	    	}else{
	    		//alert("上传文件失败！");
	    	}
	    },
	    error:function(){
	    	if(setting.success){
	    		res.status = 'error';
	      		setting.success(res);
	      	}
	    }
	});
}

/*poidata[20]='西式快餐';
poidata[21]='洗浴按摩';
poidata[22]='歌舞厅/夜总会/娱乐城';
poidata[23]='批发市场/集市';
poidata[24]='电器商场';
poidata[25]='停车场/停车区';
poidata[26]='党派团体';
poidata[27]='ktv';
poidata[28]='星级宾馆酒店';
poidata[29]='便利店';
poidata[30]='机关单位';
poidata[31]='东南亚菜';
poidata[32]='厂矿';
poidata[33]='度假村/度假区';
poidata[34]='运输';
poidata[35]='飞机场';
poidata[36]='培训机构';
poidata[37]='高等教育';
poidata[38]='银行';
poidata[39]='物业管理';
poidata[40]='文化馆/文化宫/活动中心';
poidata[41]='旅店';
poidata[42]='小区/楼盘';
poidata[43]='文化媒体';
poidata[44]='综合商场/购物中心';
poidata[45]='休闲广场';
poidata[46]='体育场馆';
poidata[47]='职业介绍/人才交流';
poidata[48]='证券公司';
poidata[49]='综合医院';
poidata[50]='美容美发';
poidata[51]='邮局';
poidata[52]='健身中心';
poidata[53]='初等教育(小学)';
poidata[54]='福利机构';
poidata[55]='村庄';
poidata[56]='学前教育';
poidata[57]='家居建材';
poidata[58]='中等教育';
poidata[59]='烟酒茶叶';
poidata[60]='招待所';
poidata[61]='公交车站';
poidata[62]='地铁/轻轨';
poidata[63]='售楼处';
poidata[64]='洗衣/干洗';
poidata[65]='汽车配件/装饰';
poidata[66]='旅行社';
poidata[67]='科研机构/教育';
poidata[68]='连锁快捷酒店';
poidata[69]='摄影冲印';
poidata[70]='保险公司';
poidata[71]='服装鞋帽';
poidata[72]='风景区/旅游区';
poidata[73]='超市';
poidata[74]='社区医疗/诊所/卫生所';
poidata[75]='atm';
poidata[76]='农村信用社/城市信用社';
poidata[77]='汽车维修/养护/洗车';
poidata[78]='公园';
poidata[79]='公用事业';
poidata[80]='高新科技';
poidata[81]='文化办公';
poidata[82]='钟表眼镜';
poidata[83]='事务所';
poidata[84]='出入口';
poidata[85]='房屋租售中介';
poidata[86]='农林园艺';
poidata[87]='各级政府';
poidata[88]='珠宝饰品';
poidata[89]='礼品花卉';
poidata[90]='投资公司';
poidata[91]='乡镇';
poidata[92]='典当/当铺';
poidata[93]='婚介婚庆';
poidata[94]='新闻出版';
poidata[95]='美术馆/艺术馆';
poidata[96]='图书馆';
poidata[97]='工商业区';
poidata[98]='文物古玩';
poidata[99]='电子数码';
poidata[100]='交叉路口';
poidata[101]='博物馆';
poidata[102]='保安';
poidata[103]='药店/药房';
poidata[104]='彩票发行';
poidata[105]='迪吧';
poidata[106]='电影院';
poidata[107]='电信公司';
poidata[108]='展览馆/纪念馆';
poidata[109]='公检法机构';
poidata[110]='售票处';
poidata[111]='建筑装修';
poidata[112]='4s/汽车销售';
poidata[113]='汽车检验场';
poidata[114]='驾校';
poidata[115]='汽车租赁';
poidata[116]='长途汽车站';
poidata[117]='出租车站';
poidata[118]='电信营业厅';
poidata[119]='图书音像';
poidata[120]='高科技园区';
poidata[121]='网吧';
poidata[122]='加油站';
poidata[123]='火车站';
poidata[124]='医疗保健';
poidata[125]='涉外机构';
poidata[126]='家政服务';
poidata[127]='服务区';
poidata[128]='文印图文';
poidata[129]='母婴儿童';
poidata[130]='体育户外';
poidata[131]='摄影器材';
poidata[132]='家电维修';
poidata[133]='别墅';
poidata[134]='房地产开发';
poidata[135]='殡葬';
poidata[136]='出国留学';
poidata[137]='公厕';
poidata[138]='搬家';
poidata[139]='驻地机构';
poidata[140]='游乐园';
poidata[141]='diy手工';
poidata[142]='音乐厅';
poidata[143]='港口/码头';
poidata[144]='送水';
poidata[145]='报亭';
poidata[146]='文物古迹';
poidata[147]='动物园';
poidata[148]='植物园';
poidata[149]='教堂';
poidata[150]='剧院';
poidata[151]='道路名称';
poidata[152]='水族馆';
poidata[153]='桥';
poidata[154]='电子游戏';
poidata[155]='私人诊所';
poidata[156]='青年旅舍';
poidata[157]='中央机构';
poidata[158]='收费处/收费站';
poidata[159]='环岛';
poidata[160]='红绿灯';
poidata[161]='科技馆';
poidata[162]='教育';
poidata[163]='箱包日用';
poidata[164]='区县';
poidata[165]='地级市';
poidata[166]='商圈';
poidata[167]='专科医院';
poidata[168]='宠物';
poidata[169]='急救中心';
poidata[170]='下属科室机构';
poidata[171]='防疫站';
poidata[172]='中医医院';
poidata[173]='职工医院';*/


</script>