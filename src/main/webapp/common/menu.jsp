<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil,com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String partyId = UserUtil.getCurrUser(request).getParty_row_id();
    String reqUrl = request.getRequestURI();
    System.out.println("========reqUrl=========="+reqUrl);
    String currindex = "";
    if(reqUrl.indexOf("/home/") != -1){
    	currindex = "1";
    }else if(reqUrl.indexOf("/conlist") != -1 || reqUrl.indexOf("/resource/") != -1 || reqUrl.indexOf("/contact/") != -1){
    	currindex = "3";
    }else if(reqUrl.indexOf("/perslInfo/") != -1 || reqUrl.indexOf("/sys/") != -1){
    	currindex = "4";
    }else if(reqUrl.indexOf("/calendar/") != -1 || reqUrl.indexOf("/oppty/") != -1 || reqUrl.indexOf("/customer/") != -1
    		|| reqUrl.indexOf("/workplan/") != -1 || reqUrl.indexOf("/expense/") != -1){
    	currindex = "2";
    }else if(reqUrl.indexOf("/activity/") != -1 || reqUrl.indexOf("/ZJMarketing/") != -1 || reqUrl.indexOf("/ZJRM/") != -1 || reqUrl.indexOf("/zjactivity/") != -1 
    		|| reqUrl.indexOf("/zjwkactivity/") != -1 || reqUrl.indexOf("/discugroup/") != -1
    		|| reqUrl.indexOf("conlist/handgroup") != -1
    		|| reqUrl.indexOf("conlist/listgroup") != -1){
    	currindex = "3";
    }
    
%>

<style>
._menu {
	width: 100%;
	height: 50px;
	background-color: #fff;
	border-top: 1px solid #ddd;
	padding-left:5px;
	padding-right:5px;
	opacity:1;
}

._submenu{
	width:100%;
	left:0;
	height:0px;
	margin-bottom:50px;
	background-color: #fff;
	/*border-top:1px solid #efefef;*/
	opacity:1;
	OVERFLOW-X: hidden;
}

._submenu_item{
	width:25%;
	float:left;
	height:84.5px;
	text-align:center;
	font-size:14px;
	color:#666;
	padding:8px; 
	border-bottom:1px solid #efefef;
	border-right:1px solid #efefef;
}

._submenu_item1{
	width:25%;
	float:left;
	height:70px;
	text-align:center;
	font-size:14px;
	color:#666;
	padding:5px;
	border-bottom:1px solid #efefef;
	border-right:1px solid #efefef;
}
._submenu_item_arrow{
	float:right;
	color:#999;
}

._menu_font_color{
	color: rgb(174,189,202);
}

._menu_sel_font_color{
	color: rgb(64,186,132);
}
</style>

<div class="_menu flooter">
	<div id="menu_switch" style="display:none;height:50px;float: left; padding-top:10px;padding-right:5px;border-right:1px solid #efefef;"  onclick="switchDownMenu()">
		<a href="javascript:void(0)"> 
			<img src="<%=path%>/scripts/plugin/menu/images/downmenu1.png" width="30px">
		</a>
	</div>
	<div class="maindiv" style="width:100%;height:50px;"></div>
</div>
<div class="_submenu flooter"></div>
<div class="menu_shade" style="display: none"></div>
	
<script>
var menus = [];
//初始菜单
function initMenu(classid, params){
	$("."+classid).html('');
	var m = "";
	var height = 0;
	var pid= '';
	for(var i = 0; i < params.length ; i++ ){
		if(i%4 == 0 && i !=0){
			m+= '<div style="clear:both;"></div>';
		}
		m += '<a id="'+params[i].id+'" href="javascript:void(0)" onclick="menuClick(\''+params[i].link+'\')">';
		m += '<div class="_submenu_item"><img src="'+params[i].image+'" width="50px" style="vertical-align:top;opacity: 1;">'; 
		m += '<div style="padding:5px;color: #000;">'+params[i].name+'</div>';
		m += '</div></a>'; 
		//给父id赋值
		pid = params[i].parentid;
	}
	if(pid === 'm_menu_2'){
		//m += '<a href="<%=path%>/urperf/menumng?parentid='+ pid +'">';
		//m += '  <div class="_submenu_item"><img src="<%=path%>/image/followup.png" width="50px" style="vertical-align:top;opacity: 1;">'; 
		//m += '  <div style="padding:5px;color: #000;">自定义</div>';
		//m += '</div></a>';
		//height = Math.ceil((params.length+1)/4) * 85;
		height = Math.ceil((params.length)/4) * 85;
	}else{
		height = Math.ceil((params.length)/4) * 85; 
	}
	
	$("."+classid).html(m);
	
	var screenHeight = $(window).height();
	if(height>screenHeight-80){
		$("._submenu").css("overflow-y","auto");
		$("._submenu").animate({height : screenHeight-80}, [ 10000 ]);
	}else{
		$("._submenu").css("overflow-y","none");
		$("._submenu").animate({height : height}, [ 10000 ]);
	}	
}

function init(){
	$("._submenu").css('height','0px');
	$("#botbounceInUp").attr("lang","1");
	$(".menu_shade").css("display","none");
}

//添加子菜单
function menuClick(link){
	$("._submenu").css('height','0px');
	if(link){
		window.location.href = link;	
	}
}

function initMenuData(){
	var dataObj = {};
	$.ajax({
	      url: '<%=path%>/urperf/menulist',
	      data: dataObj,
	      async : false,
	      success: function(data){
	    	  var data = JSON.parse(data);
	    	  menus = [];
	    	  $(data).each(function(){
	    		  var link = this.menu_link;
	    		      link = link.replace("{{path}}","<%=path%>");//.replace("{{openId}}","${openId}").replace("{{publicId}}","${publicId}");
	    		      link = link.replace("{{partyId}}","<%=partyId %>").replace("{{zjrm.url}}","<%=PropertiesUtil.getAppContext("zjrm.url")%>");
	    		  var image = this.menu_image;
	    		      image = image.replace("{{path}}","<%=path%>");
	    		  var level = this.menu_level;
	    		  var parentid = this.menu_parentid;
	    		  if(level === '1'){
	    			  menus.push({                	
	                 	  id: this.menu_id,
	                 	  parentid: parentid,
	          		      name: this.menu_name,
	           		      image: image, 
	           		      link: link,
	           		      submenus: []
		              });
	    		  }else if(level === '2'){
	    			  var i = searchSubItem(parentid);
	    			  if(i > 0){
		    			  menus[i]["submenus"].push({                	
		                 	  id: this.menu_id,
		                 	  parentid: parentid,
		          		      name: this.menu_name,
		           		      image: image, 
		           		      link: link
			              }); 
	    			  }
	    		  }
	    	  });
	    	  
	      }
	});
	
	
	//自定义菜单
	<%-- $.ajax({
	      url: '<%=path%>/urperf/urperflist',
	      data: dataObj,
	      async : false,
	      success: function(data){
	    	  if(data){
	 			var data = JSON.parse(data);
	 			$(data).each(function(){
	 				var c = this.contents;
	 				if(c){
	 					var p = '';
	 					var ar = c.split(",");
	 					for(var i = 0 ; i < ar.length ; i++){
	 						if(ar[i]){
	 							var ar01 = ar[i].split("|");
	 							var parentid = ar01[4];
	 							p = parentid;
	 							var link = ar01[3];
	 							if(link){
	 			    		      link = link.replace("{{path}}","<%=path%>");//.replace("{{openId}}","${openId}").replace("{{publicId}}","${publicId}");
	 			    		      link = link.replace("{{partyId}}","<%=partyId %>").replace("{{zjrm.url}}","<%=PropertiesUtil.getAppContext("zjrm.url")%>");
	 							}
	 			    		    var image = ar01[2];
	 							if(image){
	 			    		        image = image.replace("{{path}}","<%=path%>");
	 							}
	 							  var k  = searchSubItem(parentid);
	 			    			  if(k >= 0){
	 				    			  menus[k]["submenus"].push({                	
	 				                 	  id: ar01[0],
	 				                 	  parentid: parentid,
			 		          		      name: ar01[1],
			 		           		      image: image, 
			 		           		      link: link
	 					              }); 
	 			    			  }
	 						}
	 					}
	 				}
	 			});
		 	  }
	      }
	}); --%>
}

function searchSubItem(parentid){
	var index = -1 ;
	$(menus).each(function(i){
		if(this.id == parentid){
			index =  i;
		}
	});
	return index;
}

function initMenuItem(){
	$(menus).each(function(){
		  var link = this.link;
		  var c = 'botbounceInUp';
		  if(link){
			  c = '';
		  }else{
			  link = 'javascript:void(0)';
		  }
  		  var h = '';
	    	  h += '<a class="'+ c +'" href="' + link + '" style="float: left;width:25%" lang="1" mid="'+this.id+'">'; 
	    	  h += '    <img src="'+ this.image +'" width="24px" style="margin:5px;">'; 
	    	  h += '	<div class="_menu_font_color" style="font-size:12px;">'+ this.name +'</div>'; 
	          h += '</a>';
			  $(".maindiv").append(h);
	  });
	  var currindex = "<%=currindex%>";
	  if(currindex == '1'){
		  $(".maindiv a:eq(0) img").attr("src","<%=path%>/image/menu/newmenu/menu_msg_1.png");
		  $(".maindiv a:eq(0) div").removeClass("_menu_font_color").addClass("_menu_sel_font_color");
	  }else if(currindex == '2'){
		  $(".maindiv a:eq(1) img").attr("src","<%=path%>/image/menu/newmenu/menu_office_1.png");
		  $(".maindiv a:eq(1) div").removeClass("_menu_font_color").addClass("_menu_sel_font_color");
	  }else if(currindex == '3'){
		  $(".maindiv a:eq(2) img").attr("src","<%=path%>/image/menu/newmenu/menu_circle_1.png");
		  $(".maindiv a:eq(2) div").removeClass("_menu_font_color").addClass("_menu_sel_font_color");
	  }else if(currindex == '4'){
		  $(".maindiv a:eq(3) img").attr("src","<%=path%>/image/menu/newmenu/menu_my_1.png");
		  $(".maindiv a:eq(3) div").removeClass("_menu_font_color").addClass("_menu_sel_font_color");
	  }
	  
}

$(function() {
	initMenuData();
	initMenuItem();
	//---------------------------------------------------------------------------
	$(".botbounceInUp").click(function(event){
		$(".maindiv a").each(function(){
			var src = $(this).find("img").attr("src");
			if(src.indexOf('_1.png') !== -1){
				src = src.substr(0, src.indexOf('_1.png')) + '.png';
				$(this).find("img").attr("src", src);
				$(this).find("div").css("color", "rgb(174,189,202)");
			}
		});
		var cobj = $(this).find("img");
		var cobj02 = $(this).find("div");
		var src = cobj.attr("src");
		if(src.indexOf('menu_office.png') !== -1){
			cobj.attr("src", "<%=path%>/image/menu/newmenu/menu_office_1.png");
			cobj02.css("color", "rgb(64,186,132)");
		}else if(src.indexOf('menu_circle.png') !== -1){
			cobj.attr("src", "<%=path%>/image/menu/newmenu/menu_circle_1.png");
			cobj02.css("color", "rgb(64,186,132)");
		}
		//if(this.lang == 1){
			var i = searchSubItem($(this).attr('mid'))
			initMenu('_submenu',menus[i].submenus);
			//this.lang = 0;
			$(".menu_shade").css("display","");
		//}else{
			//this.lang = 1;
			//$("._submenu").animate({height : '0px'}, [ 5000 ]);
			//$(".menu_shade").css("display","none");
		//}
	});
	
	$(".menu_shade").click(function(e){
		$("#botbounceInUp").attr("lang","1");
		$("._submenu").css("height","0px");
		$(".menu_shade").css("display","none");
	});
	
	$("#refreshpng").click(function(){
		window.location.reload();
	});
});
	
var target = null;
//显示菜单
function swicthUpMenu(targetId){
	target = targetId;
	$("._menu").css("height","0px");
	$("#menu_switch").css("display",""); 
	$(".maindiv").css("padding-left","45px");
	$("#"+target).css("display","none");
	$("._menu").animate({height :'50px'}, [ 5000 ]);
}

//显示菜单
function swicthUpMenu2(targetId){
	target = targetId;
	$("#"+target).css("display","none");
	$("._menu").css("height","50px");
}

//关闭菜单
function switchDownMenu(){
	$("._menu").animate({height :'0px'}, [ 5000 ]);
	$("._submenu").css("height","0px");
	$(".menu_shade").css("display","none");
	$(".maindiv").css("padding-left","0px");
	if(target){
		$("#"+target).css("display","");

		target = null;
	}
}
</script>