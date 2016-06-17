<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=yes" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/calendar/fullcalendar2.css" />
	
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/zjwk.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
	
	<script type="text/javascript">
		$(function () {
			initForm();
			initDatePicker();
		});
		
		function initForm(){
			$(".event_type").click(function(){
				$(".event_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=allDay]").val($(this).attr('key'));
				if($(this).attr('key') == '1'){
					modifyDatePicker();
				}else{
					initDatePicker();
				}
			});
			
			$(".period_type").click(function(){
				$(".period_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=cycliKey]").val($(this).attr('key'));
			});
			
			$(".open_type").click(function(){
				$(".open_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=ispublic]").val($(this).attr('key'));
			});
			
			//选择客户
	    	$("input[name=parentName]").click(function(){
	    		customerjs_choose({
	        		success: function(res){
	        			$(".wrapper :hidden[name=parentId]").val(res.key);
	        			$(".wrapper :hidden[name=parentType]").val('Accounts');
	        			
	        			$("input[name=parentName]").val(res.val);
	        			
	        		}
	        	});
	    	});
			
		}
		//初始化日期控件
		function initDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'datetime', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 1  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			
			
			var startdate = $("input[name=startdate]").val();
			
			if(!startdate){
				var clickDate ="${clickDate}";
				if(clickDate!=null){
					startdate =	clickDate;
				}else{
					startdate = dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss");
				}
			}else if(startdate.length <=10){
				startdate = startdate + " 00:00:00";
			}
/* 			var enddate = $("input[name=enddate]").val();
			if(enddate){
				if(enddate.length <=10){
					enddate = enddate + " 00:00:00";
				}
			} */
			
			var enddate = $("input[name=enddate]").val();
			if(!enddate){
				
				var endtime = new Date();
				endtime.setHours(endtime.getHours()+1);
				var clickDate ="${clickDate}";
				if(clickDate!=null){
					enddate =	clickDate;
				}else{
					enddate = dateFormat(endtime, "yyyy-MM-dd hh:mm:ss");
				}
		    }	
			else if(enddate){
				if(enddate.length <=10){
					enddate = enddate + " 01:00:00";
				}
			} 
			
			$("input[name=startdate]").attr("format","yy-mm-dd HH:ii:ss");
			$("input[name=enddate]").attr("format","yy-mm-dd HH:ii:ss");
			
			$('#startdate').val(startdate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$('#enddate').val(enddate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			
		}
		
		
		//修改日期控件
		function modifyDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'date', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 1  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			var startdate = $("input[name=startdate]").val();
			if(startdate){
				startdate = startdate.substr(0,10);
			}
			var enddate = $("input[name=enddate]").val();
			if(enddate){
				enddate = enddate.substr(0,10);
			}
			
			$("input[name=startdate]").attr("format","yy-mm-dd");
			$("input[name=enddate]").attr("format","yy-mm-dd");
			
			$('#startdate').val(startdate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$('#enddate').val(startdate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		}
		
	/* 	
		function saveschedule(){
			//
			var title = $("input[name=title]").val();
			if(!$.trim(title)){
				$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请输入任务标题");
	   	    	$(".myDefMsgBox").delay(2000).fadeOut();
				return;
			}
    		var start = $('.schedule_form #startdate').val();
    		var end = $('.schedule_form #enddate').val();
    		if (end != null && end != "" && end!="0000-00-00 00:00:00" && start > end){
    			$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("结束时间不能早于开始时间!");
    	    	$(".myDefMsgBox").delay(2000).fadeOut();
    	    	return;
    		}

			$("form[name=schedule_form]").submit();
		} */
		
		
		function saveschedule(){
			var title = $("input[name=title]").val();
			if(!$.trim(title)){
				$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请输入任务标题");
	   	    	$(".myDefMsgBox").delay(2000).fadeOut();
				return;
			}
			var start = $('.schedule_form #startdate').val();
			var end = $('.schedule_form #enddate').val();
    		if (end != null && end != "" && end!="0000-00-00 00:00:00" && start > end){
    			$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("结束时间不能早于开始时间!");
    	    	$(".myDefMsgBox").delay(2000).fadeOut();
    	    	return;
    		}
    		var dataObj = [];
    		var crmId =$("input[name=crmId]").val();
    		var assignerId =$("input[name=assignerId]").val();
    		var orgId =$("input[name=orgId]").val();
    		var schetype =$("input[name=schetype]").val();
    		var status =$("input[name=status]").val();
    		var allDay =$("input[name=allDay]").val();
    		var ispublic =$("input[name=ispublic]").val();
    		var cycliKey =$("input[name=cycliKey]").val();
    		var parentId =$("input[name=parentId]").val();
    		var parentType =$("input[name=parentType]").val();
    		var flag =$("input[name=flag]").val();
    		var wximgids =$("input[name=wximgids]").val();
    		var startdate =$("input[name=startdate]").val();
    		var enddate =$("input[name=enddate]").val();
    		
    		var desc = $("#desc").val();
    		
    		if(!parentId){
    			$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择相关客户");
	   	    	$(".myDefMsgBox").delay(2000).fadeOut();
				return;
    		}
    		
    		dataObj.push({name:"crmId",value:crmId});
    		dataObj.push({name:"assignerId",value:assignerId});
    		dataObj.push({name:"orgId",value:orgId});
    		dataObj.push({name:"schetype",value:schetype});
    		dataObj.push({name:"status",value:status});
    		dataObj.push({name:"allDay",value:allDay});
    		dataObj.push({name:"ispublic",value:ispublic});
    		dataObj.push({name:"cycliKey",value:cycliKey});
    		dataObj.push({name:"parentId",value:parentId});
    		dataObj.push({name:"parentType",value:parentType});
    		dataObj.push({name:"flag",value:flag});
    		dataObj.push({name:"wximgids",value:wximgids});
    		dataObj.push({name:"startdate",value:startdate});
    		dataObj.push({name:"enddate",value:enddate});
    		dataObj.push({name:"title",value:title});
    		dataObj.push({name:'desc',value:desc});
    		  $.ajax({
  	        	type: 'post',
  				url : '<%=path%>/schedule/asynsave',			
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
  					
  					//有图片才从微信下载并上传OSS
  					if (wximgids){
  						var req = {
  			    			imgids:wximgids,
  			    			relaId:d.rowId,
  			    			relaType:'Resource',
  			    			fileType:'img'
  			    		};
  						download4WXServer(req, {
  							success: function(res){
  								if(res.status == 'success'){
  									window.location.replace("<%=path%>/schedule/detail?rowId="+d.rowId+"&orgId="+orgId);
  								}
  							}
  						});
  					}
  					else
  					{
  						window.location.replace("<%=path%>/schedule/detail?rowId="+d.rowId+"&orgId="+orgId);
  					}
  			    },
  			    error:function(){
  			    	alert('error');
  			    }
  		    });
		}
	</script>

<style>
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}

.period_type{
	padding: 3px 5px;
}

.event_type {
	padding: 3px 5px;
}

.open_type {
	padding: 3px 5px;
}

a{
	color:#555;
}
</style>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="task-create" class=" " style="background-color: #FAFAFA;">
		<%--<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"/>
			<div class="act-secondary" style="padding: 0px 15px;" onclick="saveschedule();">
				保存
			</div>
			<h3 style="padding-right:45px;">创建任务</h3>
		</div>
		 --%>
		<input type="hidden" name="currpage" value="1"/>
		<input type="hidden" name="firstchar"/>
		<input type="hidden" name="pagecount" value="10"/>
		
		<div id="site-nav" class="tasks_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
			<a href="javascript:void(0)" onclick='saveschedule()' style="padding:5px 8px;">保存</a>
		</div>
		
		<div class="wrapper" style="margin:0px;font-size:14px;">
			<form class="schedule_form" name="schedule_form" id="schedule_form" action="<%=path%>/schedule/save" method="post">
			    <input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="assignerId" value="${crmId}" />
			    <input type="hidden" name="orgId" value="${orgId}" />
			    <input type="hidden" name="schetype" value="task" />
			    <input type="hidden" name="status" value="Not Started" />
			    <input type="hidden" name="allDay" value="2" />
			    <input type="hidden" name="ispublic" value="0" />
			    <input type="hidden" name="cycliKey" value="" />
			    <input type="hidden" name="desc" value="" />
			    <!--  外部调用 传入的关联参数-->
			    <input type="hidden" name="parentId" value="${parentId}" />
			    <input type="hidden" name="parentType" value="${parentType}" />
			    <input type="hidden" name="flag" value="${flag}" />
			    <input type="hidden" name="wximgids" value="" />
                 
			    <%--主题 --%>
			   <div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group" style="margin:0.5em 0;">
						<input name="title" required="required" id="sync_title" value="" type="text"
							class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="标题(必填)" style="border: 0px;border-bottom: 1px solid #ddd;"/>
						<div class="help-block empty">请填写标题</div>
					</div>
					<div class="form-group" style="margin:0.5em 0;">
						<input name="addr" id="addr" value="" type="text" class="form-control" placeholder="地点" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
				</div>
				<br/>
				
				<%--事件部份 --%>
						<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div style="line-height:40px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="float:left;color:#666;padding-left:5px;">全天事件</div>
						<div style="padding-left:100px;">
							<a href="javascript:void(0)" class="event_type selected" key='1' style="">是</a>
							&nbsp;&nbsp;&nbsp;
							<a href="javascript:void(0)" class="event_type" key='2' style="">否</a>
						</div>
					</div>

					<div class="form-group" style="margin:0.5em 0;">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">开始时间</div>
						<input name="startdate" id="startdate" value="" type="text" format="yy-mm-dd HH:ii:ss" class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;" />
					</div>
					
					<div class="form-group" style="margin:0.5em 0;">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">结束时间</div>
						<input name="enddate" id="enddate" value="" type="text" format="yy-mm-dd HH:ii:ss" class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;" />
					</div>
					
					<div style="padding:3px 5px;border-bottom: 1px solid #ddd;">
						<div style="position: absolute;line-height: 40px;color:#666;">客户</div>
						<input name="parentName" id="parentName" value="${sd.relaname}" type="text" placeholder="点击选择客户" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;margin-top: 6px;" />
						<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
					</div>
					
					<div style="line-height:30px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">是否重复</div>
						<div style="padding-left:15px;">
							<a class="period_type selected" href="javascript:void(0)" key="">永不</a>&nbsp;&nbsp;
							<c:forEach items="${periodList}" var="p">
								<a class="period_type" href="javascript:void(0)" key="${p.key}">${p.value}</a>&nbsp;&nbsp;
							</c:forEach>
						</div>
					</div>
					
					
					<div style="line-height:30px;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">行程公开<span style="color:#999;">(好友可见时间和地点所在城市)</span></div>
						<div style="padding-left:15px;">
							<a href="javascript:void(0)" class="open_type selected" key='0' style="">不公开</a>
							&nbsp;&nbsp;&nbsp;
							<a href="javascript:void(0)" class="open_type" key='1' style="">公开</a>
						</div>
					</div>
				</div>
				
				<br/>
				
				<%--备注 --%>
				<div style="width:100%;padding:5px 10px;background-color:#fff;border-bottom:1px solid #ddd;">
					<div class="form-group">
						<textarea name="desc" id="desc" rows="2" style="border: 0px;min-height: 3em;"
							class="form-control" placeholder="备注"></textarea> 
					</div>
				</div>
				
				<!-- 上传图片 -->
				
				<div style="width:100%;padding: 5px 8px;">
					<div style="padding-top: 15px; font-size: 8px; color: #fff;clear: both;" class="imageContaint">
						<img src="<%=path %>/image/mem_add.png" class="addimg" style="float:left;padding: 2px; color: #fff; border-radius: 5px;width:64px;">								
				</div>
				<br/>
	      </div>
<!-- bugID=38 创建日程多个保存按钮
				<div style="margin:10px 80px;">
					<input type="button" class="btn btn-block btn-success" onclick="saveschedule();" value="保存">
				</div>
 -->			</form>
			
			<div class="myDefMsgBox" style="display:none;">&nbsp;</div>
			<br/>
			<br/>
			<br/>
			<br/>
			<br/>
		</div>
	</div>

<jsp:include page="/common/wxjs.jsp"></jsp:include>

<%-- 客户 --%>
<jsp:include page="/common/rela/selcustToCalendar.jsp">
	<jsp:param value="${orgId}" name="orgId"/>
</jsp:include>
	
<script type="text/javascript">
var serverids="";
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
							// alert('服务器上传成功');
							 sleep(1000);
							 wxjs_uploadImage({
								 success: function(images){
									 var localids = images.localId;
									 serverids+= images.serverId+",";
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