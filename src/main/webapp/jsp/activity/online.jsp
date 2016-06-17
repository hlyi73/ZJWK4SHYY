<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->

<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/style.css" />
<link rel="stylesheet" href="<%=path%>/css/share.css" />
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css" />
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<style type="text/css"> 
    ul,li{list-style:none; margin:0; padding:0;} 
    .scroll{overflow:hidden;height:50px;} 
    .scroll li{height: 50px;line-height: 50px;overflow: hidden;margin-left: 15px;} 
    .scroll li a{ font-size:14px; font-family:"宋体";color:#333; text-decoration:none;} 
    .scroll li a:hover{ text-decoration:underline;} 
</style> 
<script type="text/javascript">
	$(function() {
		initWeixinFunc();
		initForm();
		loadData();
		window.setInterval('autoScroll(".scroll")',2000);
	});

	/** 
	* 文字逐行向上滚动
	* edit:www.jbxue.com
	*/ 
	function autoScroll(obj){ 
		$(obj).find(".msglist").animate({ 
			marginTop : "-50px" 
		},500,function(){ 
			$(this).css({marginTop : "0px"}).find("li:first").appendTo(this); 
		}) 
	} 
	
	//微信网页按钮控制
	function initWeixinFunc() {
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideOptionMenu');
				});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideToolbar');
				});
	}
	
	$(function(){
		if(!document.getElementById("inputMsg")){
			return;
		}
		$("#inputMsg").bind("propertychange",function(){
	    	var v = $(this).val();
			if(v !== ''){
	    		$(".examinerSend").css("display","");
	    		$(".addBtn").css("display","none");
	    	}else{
	    		$(".addBtn").css("display","");
	    	}
			
	    });
		$("#inputMsg").bind("input",function(){
	    	var v = $(this).val();
			if(v !== ''){
	    		$(".examinerSend").css("display","");
	    		$(".addBtn").css("display","none");
	    	}else{
	    		$(".addBtn").css("display","");
	    	}
	    });
		
		autoTextArea("inputMsg");
	});
	    
	function autoTextArea(elemid){
	    //新建一个textarea用户计算高度
	    if(!document.getElementById("_textareacopy")){
	        var t = document.createElement("textarea");
	        t.id="_textareacopy";
	        t.style.position="absolute";
	        t.style.left="-9999px";
	        t.rows = "1";
	        t.style.lineHeight="20px";
	        t.style.fontSize="16px";
	        document.body.appendChild(t);
	    }
	    function change(){
	    	document.getElementById("_textareacopy").value= document.getElementById("inputMsg").value;
	    	var height = document.getElementById("_textareacopy").scrollHeight;
	    	if(height>100){
	    		return;
	    	}
	    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
	    		document.getElementById("inputMsg").style.height= "40px";
	    	}else{
	        	document.getElementById("inputMsg").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
	    	}
	    }
	    
	    $("#inputMsg").bind("propertychange",function(){
	    	change();
	    });
	    $("#inputMsg").bind("input",function(){
	    	change();
	    });

	    document.getElementById("inputMsg").style.overflow="hidden";//一处隐藏，必须的。
	    document.getElementById("inputMsg").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
	}

	function _initMessageControl(){
		if(document.getElementById("inputMsg")){
			document.getElementById("inputMsg").style.height = "40px";
			document.getElementById("inputMsg").value = "";
			document.getElementById("inputMsg").rows = "1";
			document.body.removeChild(document.getElementById("_textareacopy"));
	    	autoTextArea("inputMsg");
		}
	}
	
	//定时刷新
	var seq = 0; //
	var second=3000; //间隔时间2秒钟
	var t1,t2;
	var errcount = 0;
	var start = 0;
	
	
	function initForm(){
		$(".examinerSend").click(function(){
			//先翻译表情
			$("#inputMsg").emotionsToHtml();
			var content = $("textarea[name=inputMsg]").val();
			var re=/\r\n/;  
			content=content.replace(re,"\n");  
			//消息不为空则不发送
			if(!content.trim()){ return; }
			
			var actid = "${activity.id}";
			var createby = "${sourceid}";
			var compere = "";
			if('${activity.createBy}'==createby){
				compere = "1";
			}
			var msgtype = "txt";
			var createname="${username}";
			var dateStr = dateFormat(new Date(), "MM-dd hh:mm");
			var headimgurl = "${headimgurl}";
		    var val = '<div class="item" style="border-bottom:1px solid #efefef;">'
				 +'<div style="float:left;width:30px;padding-top:2px;">';
		    if(headimgurl){
				val += '<img src="'+headimgurl+'" width="24px" style="border-radius:12px;">';
			}else{
				val += '<img src="<%=path%>/image/defailt_person.png" width="24px" style="border-radius:12px;">';
			}
				
			val += '</div>'
				 +'<div style="margin-left:30px;padding:5px;line-height:22px;">'
				 +'<div class="freecontent">'
				 + content
				 +'</div>'
			     +'</div>'
			     +'</div>';
				$(".freecommentlist").prepend(val);
				
			//$(".commentlist").prepend(val);
			$("textarea[name=inputMsg]").val('');
			//
			var dataObj = [];
			dataObj.push({name:'created_by', value: createby});
			dataObj.push({name:'activity_id', value: actid});
			dataObj.push({name:'content', value: content});
			dataObj.push({name:'msg_type', value:msgtype });
			dataObj.push({name:'soruce', value:'M' });
			dataObj.push({name:'create_name', value: createname});
			dataObj.push({name:'created_time',value:dateFormat(new Date(),'yyyy-MM-dd hh:mm:ss')})
			dataObj.push({name:'headimgurl', value: headimgurl});			
			dataObj.push({name:'compere', value: compere});			
			//保存消息
			$.ajax({
				   type: 'post',
				   url: '<%=path%>/zjwkactivity/savedirect',
				   data: dataObj || {},
				   dataType: 'text',
				   success: function(data){
					  start = parseInt(start) + 1;
				   }
			});
		});
	}
	
	
	//加载数据到消息滚动区域
	function loadScrollData(name,content){
		//var scrollwidth = document.getElementById("scroll").scrollWidth;
		//var offsetwidth = document.getElementById("scroll").offsetWidth;
		//if (scrollwidth > offsetwidth){
		  //	var len = (offsetwidth/ scrollwidth) * content.length;
	    var re = content.replace(/[^\u4e00-\u9fa5]/gi,"");
		if(re.length>18){
		 content = content.replace(/[^\u4e00-\u9fa5]/gi,re.substring(0,18));
	    }
		//}
		var modelHtml = '<li><a href="#" style="cursor:default;">'+name+'：'+content+'</a></li>';
		$(".msglist").append(modelHtml);
	}
	
	//初始化数据
	function loadData(){
		//加载消息
		$.ajax({
			   url: '<%=path%>/zjwkactivity/initdirect',
			   data: {
					activity_id: '${activity.id}'
			   },
			   dataType: 'text',
			   success: function(data){
				   if(!data){
			    		return;
			       }
			       var d = JSON.parse(data);
			       if(d){
					    start = $(d).size();
			    		$(d).each(function(i){
			    			var headimgurl = "";
			    			if(this.headimgurl){
			    				headimgurl = this.headimgurl;
			    			}else{
			    				headimgurl = "<%=path%>/image/defailt_person.png";
			    			}
			    			
			    			//主持人
			    			if(this.compere && this.compere == '1'){
				    			var val = '<div class="item" style="margin-bottom:8px;">'
									 +'<div style="float:left;width:50px;text-align:center;">'
									 + '<img src="'+headimgurl+'" width="40px" style="border-radius:5px;">'
									 +'<span style="color:red;font-size:12px;padding-top:5px;">主持人</span>'
									 + '</div>'
									 +'<div style="margin-left:50px;padding:5px;line-height:22px;background-color:#F2F7FD;border-radius:8px;">'
									 + '<div>'
									 +'<div style="float:left;">'+this.create_name
									 //+'<span style="margin-left:115px;font-size:16px;color:red;">主持人</span>'
									 +'</div><div style="float:right;padding-right:5px;font-size:14px;">'+this.created_time+'</div>'
									 +'</div>'
									 +'<div style="clear: both;"></div>'
									 +'<div class="content">';
									 var type = this.msg_type;
									 var content = this.content;
									 if("link"==type){
										 if(content.indexOf("$$sourceid")!=-1){
											 content = content.replace("$$sourceid",'${sourceid}');
										 }
									 }
									val += content
									 +'</div>'
								     +'</div>'
								     +'</div>';
									$(".commentlist").append(val);
			    			}else{
			    				var val = '<div class="item" style="border-bottom:1px solid #efefef;">'
									 +'<div style="float:left;width:30px;padding-top:2px;">' 
									 + '<img src="'+headimgurl+'" width="24px" style="border-radius:12px;">'
									 + '</div>'
									 +'<div style="margin-left:30px;padding:5px;line-height:22px;">'
									 +'<div class="freecontent">'
									 + this.content
									 +'</div>'
								     +'</div>'
								     +'</div>';
									$(".freecommentlist").append(val);
									loadScrollData(this.create_name,this.content);
			    			}
			    		});
			    		t2 = window.setInterval(waiting2,1000); 
			       }
			       t1 = window.setInterval(load,second);  
			   }
		});
	}
		
	function waiting(){
		$(".commentlist .content img").each(function() {
			if($(this).attr("refresh") != "Y"){
	            //var src = $(this).attr("src");
	            //src += "&randomnum="+Math.random();
	            //$(this).attr("src",src);
				if($(this).width() > $(window).width()-80){
	            	$(this).css("width",$(window).width()-80);
				}
	            $(this).attr("refresh","Y");
			}
        });
		
		window.clearInterval(t2); 
	}
	
	function waiting2(){
		$(".commentlist .content img").each(function() {
			if($(this).attr("refresh") != "Y"){
				if($(this).width() > $(window).width()-80){
	            	$(this).css("width",$(window).width()-80);
				}
	            $(this).attr("refresh","Y");
			}
        });
		
		window.clearInterval(t2); 
	}
	
	function load(){
		$.ajax({
			url: '<%=path%>/zjwkactivity/readdirect',
			dataType: 'text',
			data: {
				activity_id: '${activity.id}',
				start:start
			},
			success: function(data){
				errcount = 0;
		    	if(!data){
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	if(d){
		    		start = parseInt(start) + $(d).size();
		    		$(d).each(function(i){
		    			var dateStr = dateFormat(new Date(this.created_time), "MM-dd hh:mm");
		    			var headimgurl = "";
		    			if(this.headimgurl){
		    				headimgurl = this.headimgurl;
		    			}else{
		    				headimgurl = "<%=path%>/image/defailt_person.png";
		    			}
		    			//主持人
		    			if(this.compere && this.compere == '1'){
			    			var val = '<div class="item" style="margin-bottom:8px;">'
								 +'<div style="float:left;width:50px;text-align:center;">'
								 + '<img src="'+headimgurl+'" width="40px" style="border-radius:5px;">'
								 +'<span style="color:red;font-size:12px;padding-top:5px;">主持人</span>'
								 + '</div>'
								 +'<div style="margin-left:50px;padding:5px;line-height:22px;background-color:#F2F7FD;border-radius:8px;">'
								 + '<div>'
								 +'<div style="float:left;">'+this.create_name
								 //+'<span style="margin-left:115px;font-size:16px;color:red;">主持人</span>'
								 +'</div><div style="float:right;padding-right:5px;font-size:14px;">'+dateStr+'</div>'
								 +'</div>'
								 +'<div style="clear: both;"></div>'
								 +'<div class="content">';
			    			 var type = this.msg_type;
							 var content = this.content;
							 if("link"==type){
								 if(content.indexOf("$$sourceid")!=-1){
									 content = content.replace("$$sourceid",'${sourceid}');
								 }
							 }
								val += content
								 +'</div>'
							     +'</div>'
							     +'</div>';
								$(".commentlist").prepend(val);
		    			}else{
		    				var val = '<div class="item" style="border-bottom:1px solid #efefef;">'
								 +'<div style="float:left;width:30px;padding-top:2px;">'
								 + '<img src="'+headimgurl+'" width="24px" style="border-radius:12px;">'
								 + '</div>'
								 +'<div style="margin-left:30px;padding:5px;line-height:22px;">'
								 +'<div class="freecontent">'
								 + this.content
								 +'</div>'
							     +'</div>'
							     +'</div>';
								$(".freecommentlist").prepend(val);
								loadScrollData(this.create_name,this.content);
		    			}
		    		});
		    		
		    		t2 = window.setInterval(waiting,1000); 
		    	}
		    },
		    error:function(){
		    	errcount ++;
		    	if(errcount > 5){
		    		window.clearInterval(t1); 
		    	}
		    }
		});
	}
</script>
</head>
<body style="background-color: rgba(250, 250, 250, 0.180392);height:100%;">
<div id="mainDiv" class="maindiv">
	<div id="site-nav" class="navbar"
		style="font-size: 16px;position: fixed; top: 0px; width: 100%;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">直播间</h3>
	</div>
	<div style="clear: both;"></div>
	<!-- 直摠 -->
	<div class="commentlist" style="margin-bottom: 50px;width: 100%; text-align: left; top:60px;font-size: 14px; color: #999;padding:5px;position: absolute;overflow-y: auto;">
	</div>
	<%-- 评论区域 --%>
	<script>
	function showComments(){
		$(".commentlist").css("display","none");
		$(".freecommentlist").css("display","");
		$(".freecommentlist").css("position","");
		$(".freecommentlist").css("height","100%");
		$(".hidediv").css("display",""); 
		$(".hidediv").css("margin-top","40px"); 
		$(".hidediv").css("position","");
		$(".hideimg").attr("src","<%=path%>/image/nextpage.png");
		$("#scroll").css("display","none");
		$("#update").css("display","");
	}
	
	function hideComments(){
		$(".commentlist").css("display","");
		$(".freecommentlist").css("display","none");
		$(".freecommentlist").css("display","none");
		$(".hidediv").css("display","none"); 
		$("#scroll").css("display","");
		$("#update").css("display","none");
	}
	
	</script>
	<div class="hidediv"  onclick="hideComments()"style="background-color: rgba(250, 250, 250, 0.180392);display:none;z-index:999;position:fixed;bottom:150px;width:100%;text-align:center;">
		<img class="hideimg" src="<%=path %>/image/hide.png" width="48px" style="padding:10px;">
	</div>
	<!-- 评论区域 -->
	<div class="freecommentlist" style="margin-bottom: 50px;display:none;background-color:rgba(250, 250, 250, 0.18);position:fixed;height:130px;border-top:1px solid #efefef;bottom:51px;width: 100%; text-align: left; font-size: 14px; color: #999;padding:5px;overflow-y: auto;">
	</div>
	<!-- 评论消息实时滚动 -->
	<div id="scroll" class="flooter scroll" style="border-top: 1px solid #ddd; background: #FFF; opacity: 1;">
		<!-- 评论向上滚动 -->
		<ul class="ui-block-a msglist" style="float:left;text-align:left;width: 50%;"> 
              
        </ul>
		<!--发送消息的区域  -->
		<div class="ui-block-a" style="float: right; width: 60px; margin: 5px 5px 5px 0px;">
			<a href="javascript:void(0)" onclick="showComments()" class="btn  btn-block " style="font-size: 14px; width: 100%;">参与</a>
		</div>
		<div style="clear: both;"></div>
	</div>
	<%--发送评论 --%>
	<div id="update" class="flooter"
		style="border-top: 1px solid #ddd; background: #FFF; opacity: 1;display:none">
		<!--发送消息的区域  -->
		<div class="msgContainer" >
			<div class="ui-block-a replybtn" style="width: 98%; margin: 5px 0px 5px 0px; padding-right: 98px;">
				<!-- 消息输入框 -->
				<textarea name="inputMsg" id="inputMsg"
					style="width: 98%; font-size: 16px; line-height: 20px; height: 40px; margin-left: 5px; margin-top: 0px;"
					class="form-control" placeholder="我来说两句"></textarea>
			</div>
			<jsp:include page="emotion.jsp">
				<jsp:param value="mainDiv" name="parentDiv"/>
			</jsp:include>
			<div class="ui-block-a " style="float: right; width: 60px; margin: -45px 5px 5px 0px;">
				<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px; width: 100%;">评论</a>
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
</div>
<!-- 表情区域 -->
<div id="container">
</div>	
</body>
</html>