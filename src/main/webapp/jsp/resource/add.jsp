<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/zjwk.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css"  />
<link rel="stylesheet" href="<%=path%>/css/style.css"  />

<script type="text/javascript">

	$(function(){
		if(document.getElementById("myContent")){
			autoTextArea("myContent");
		}
		
		$(".cancelBtn").click(function(){
			window.history.back(1);
		})
		$(".saveBtn").click(function(){
			//保存资料
			var wximgids = $(":hidden[name=wximgids]").val();
			/* if(!wximgids){
				 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("至少添加一张图片!");
				 $(".myMsgBox").delay(2000).fadeOut();
		  		 return;
			} */
			var content = $("textarea[id=myContent]").val();
			var title = $("textarea[id=resourceTitle]").val();
			if(!$.trim(content)){
				 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请填写资料内容!");
				 $(".myMsgBox").delay(2000).fadeOut();
		  		 return;
			}
			if($.trim(content).length > 300){
				 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("输入的字符内容过长!");
				 $(".myMsgBox").delay(2000).fadeOut();
		  		 return;
			}
			
			var dataObj = [];
	        dataObj.push({name:"resourceType",value:"img"});
	        dataObj.push({name:"resourceTitle",value:title});
	        dataObj.push({name:"resourceContent",value:content});
	        $.ajax({
	        	type: 'post',
				url : '<%=path%>/resource/save',			
		        data: dataObj,
		        dataType: 'text',
			    success: function(data){
					if(!data){
						 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败!");
						 $(".myMsgBox").delay(2000).fadeOut();
				  		 return;

					}
					
					var d = JSON.parse(data);
					if(!d || d.errorCode != "0" || !d.rowId){
						 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("保存失败!");
						 $(".myMsgBox").delay(2000).fadeOut();
				  		 return;
					}
					
					//
					$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("保存成功!");
					$(".myMsgBox").delay(2000).fadeOut();
					
					//有图片才从微信下载并上传ftp
					if (wximgids)
					{
						var req = {
			    			imgids:wximgids,
			    			relaId:d.rowId,
			    			relaType:'Resource',
			    			fileType:'img'
			    		};
						download4WXServer(req, {
							success: function(res){
								if(res.status == 'success'){
									window.location.replace("<%=path%>/resource/list");
								}
							}
						});
					}
					else
					{
						window.location.replace("<%=path%>/resource/list");
					}
			    },
			    error:function(){
			    	alert('error');
			    }
		    });
		});
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
	        t.style.fontSize="14px";
	        document.body.appendChild(t);
	    }
	    function change(){
	    	document.getElementById("_textareacopy").value= document.getElementById("myContent").value;
	    	var height = document.getElementById("_textareacopy").scrollHeight;
	    	if(height>200){
	    		return;
	    	}
	    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
	    		document.getElementById("myContent").style.height= "40px";
	    	}else{
	        	document.getElementById("myContent").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
	    	}
	    }
	    
	    $("#myContent").bind("propertychange",function(){
	    	change();
	    });
	    $("#myContent").bind("input",function(){
	    	change();
	    });
	
	    document.getElementById("myContent").style.overflow="hidden";//一处隐藏，必须的。
	    document.getElementById("myContent").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
	}
	
	function _initMessageControl(){
		if(document.getElementById("myContent")){
			document.getElementById("myContent").style.height = "40px";
			document.getElementById("myContent").value = "";
			document.getElementById("myContent").rows = "1";
			document.body.removeChild(document.getElementById("_textareacopy"));
	    	autoTextArea("myContent");
		}
	}

	
</script>

</head>
<body style="background-color:#fff;height:100%;font-size:14px;">
	<div id="site-nav" class="navbar" style="display:none" >
	</div>
	<input type="hidden" name="wximgids" value="">
	<!-- 控制区域 -->
	<div style="width:100%;line-height:50px;background-color:#fff;padding:5px;border-bottom: 1px solid #ddd;text-align:right;padding-right:20px;" id="opArea">
		<a href="javascript:void(0)" class="btn btn-default cancelBtn" style="font-size: 16px;height: 2em;line-height: 2em;"> 取消</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" class="btn saveBtn" style="font-size: 16px;height: 2em;line-height: 2em;"> 保存</a>				

	</div>
	<div style="line-height:10px;background-color:#eee;height:10px;"></div>
	<div class="resourceTitle" style="margin: 8px;">
		<textarea id="resourceTitle" class="resourceTitle" style="border:0px;border-bottom:1px solid #ddd;" rows="1" placeholder="在此输入文章标题"></textarea>
	</div>
	<div class="content" style="margin: 8px;">
		<textarea id="myContent" class="myContent" style="border:0px;border-bottom:1px solid #ddd;" rows="3" placeholder="在此输入文字信息"></textarea>
	</div>
	<div style="clear: both"></div>
	<div style="width:100%;padding: 5px 8px;">
		<div style="padding-top: 5px; font-size: 8px; color: #fff;clear: both;" class="imageContaint">
			<img src="<%=path %>/image/mem_add.png" class="addimg" style="float:left;padding: 2px; color: #fff; border-radius: 5px;width:64px;">								
		</div>
	</div>
	
	
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<div class="myMsgBox" style="display:none;">&nbsp;</div>
	<jsp:include page="/common/wxjs.jsp"></jsp:include>
	<script type="text/javascript">
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
								 $(":hidden[name=wximgids]").val(serverids);
								 
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
		
		
		
	</script>
</body>
</html>