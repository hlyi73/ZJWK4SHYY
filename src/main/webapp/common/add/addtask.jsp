<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String taskpath = request.getContextPath();
%>

	<script type="text/javascript">
		$(function () {
			initSyncForm();
			initSyncDatePicker();
			
			$(".cancel").click(function(){
				hide_scheduleform();
				rFunction = null;
			});
		});
		
		function initSyncScheduleForm(){
			$(".sync_schedule_form :hidden[name=sync_allDay]").val('2');
			$(".sync_schedule_form :hidden[name=sync_ispublic]").val('0');
			$(".sync_schedule_form :hidden[name=sync_cycliKey]").val('');
			$(".sync_schedule_form input[name=sync_title]").val('');
			$(".sync_schedule_form input[name=sync_addr]").val('');
			//$(".sync_schedule_form input[name=sync_startdate]").val(dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss"));
			//$(".sync_schedule_form input[name=sync_enddate]").val('');
			$(".sync_schedule_form textarea[name=sync_desc]").val('');
			$(".sync_schedule_form textarea[name=sync_status]").val('Not Started');
			
			$(".savetaskbtn").css("display","");
			$(".quicksavetask").css("display","");
		}
		
		var rFunction = null;
		var parentId,parentType,orgId;
		
		
		function schedulejs_choose(req,setting){
			if(!setting){
				setting = {};
			}
			initSyncScheduleForm();
			parentId = req.relaId;
			parentType = req.relaType;
			orgId = req.orgId;
			rFunction = setting;
			
			$(".scheduleform").removeClass("none");
		}
		
		//返回
		function hide_scheduleform(){
			$(".scheduleform").removeClass("none").addClass("none");
		}
		
		//异步保存
		function syncsave(){
			var startdate = $(".sync_schedule_form input[name=sync_startdate]").val();
			var enddate = $(".sync_schedule_form input[name=sync_enddate]").val();
			var schetype = $(".sync_schedule_form input[name=sync_schetype]").val();
			var allDay = $(".sync_schedule_form input[name=sync_allDay]").val();
			var ispublic = $(".sync_schedule_form input[name=sync_ispublic]").val();
			var cyclikey = $(".sync_schedule_form input[name=sync_cycliKey]").val();
			var title = $(".sync_schedule_form input[name=sync_title]").val();
			var desc = $(".sync_schedule_form textarea[name=sync_desc]").val();
			var addr = $(".sync_schedule_form input[name=sync_addr]").val();
			var status = $(".sync_schedule_form input[name=sync_status]").val();
			var wximgids = $(".sync_schedule_form input[name=wximgids]").val();

			if(!$.trim(title)){
				$(".ScheduleMsgBox").css("display","").html("请输入任务标题");
	    		$(".ScheduleMsgBox").delay(2000).fadeOut();
	    		return;
			}
			
/* 			if(allDay=='1' && startdate != enddate){
				$(".ScheduleMsgBox").css("display","").html("全天事件开始结束时间必须是同一天");
	    		$(".ScheduleMsgBox").delay(2000).fadeOut();
	    		return;
			} */			
			
    		if (enddate != null && enddate != "" && enddate!="0000-00-00 00:00:00" && startdate > enddate){
    			$(".ScheduleMsgBox").css("display","").html("结束时间不能早于开始时间!");
    			$(".ScheduleMsgBox").delay(2000).fadeOut();
    	    	return;
    		}
			
			var dataObj = [];
			dataObj.push({name:"orgId",value:orgId});
			dataObj.push({name:"startdate",value:startdate});
			dataObj.push({name:"enddate",value:enddate});
			dataObj.push({name:"schetype",value:schetype});
			dataObj.push({name:"allDay",value:allDay});
			dataObj.push({name:"ispublic",value:ispublic});
			dataObj.push({name:"cycliKey",value:cyclikey || ''});
			dataObj.push({name:"title",value:title});
			dataObj.push({name:"desc",value:desc});
			dataObj.push({name:"addr",value:addr});
			dataObj.push({name:"status",value:status});
			if(parentType == "Tasks"){
				dataObj.push({name:"subtaskid",value:parentId});
			}else{
				dataObj.push({name:"parentId",value:parentId});
				dataObj.push({name:"parentType",value:parentType});
			}
			
			//
			$(".savetaskbtn").css("display","none");
			$(".quicksavetask").css("display","none");
			
			$.ajax({
			    type: 'post',
			      url: '<%=taskpath%>/schedule/asynsave',
			      data: dataObj,
			      dataType: 'text',
			      success: function(data){
			    	  if(!data){
				    	   $(".ScheduleMsgBox").css("display","").html("添加任务失败!");
			    		   $(".ScheduleMsgBox").delay(2000).fadeOut();
				    	   return;
				       }
				       var d = JSON.parse(data);
				       if(!d){
				    	   $(".ScheduleMsgBox").css("display","").html("添加任务失败!");
			    		   $(".ScheduleMsgBox").delay(2000).fadeOut();
				    	   return;
				       }
				       
				       if(d.errorCode && d.errorCode !== '0'){
				    	   $(".ScheduleMsgBox").css("display","").html("添加任务失败!");
			    		   $(".ScheduleMsgBox").delay(2000).fadeOut();
				    	   return;
				       }
				       
				       if(!d.rowId){
				    	   $(".ScheduleMsgBox").css("display","").html("添加任务失败!");
			    		   $(".ScheduleMsgBox").delay(2000).fadeOut();
			    		   return;
				       }
				       
				       var rowid = d.rowId;
					   var res = {
						 	rowid: rowid,
						 	startdate: startdate,
						 	enddate: enddate,
						 	title: title,
						 	status:status,
						 	statusname:'未开始',
						 	desc:desc
						};
						if(rFunction && rFunction.success){
							rFunction.success(res);
						}
						hide_scheduleform();
						rFunction = null;
						if (wximgids){
	  						var req = {
	  			    			imgids:wximgids,
	  			    			relaId:d.rowId,
	  			    			relaType:'Resource',
	  			    			fileType:'img'
	  			    		};
	  						download4WXServer(req, {
	  							success: function(res){
	  								 
	  							}
	  						});
						} 
					 },
	  			    error:function(){
	  			    	alert('error');
	  			    }
			});
		}
		
		function initSyncForm(){
			$(".sync_schedule_form .event_type").click(function(){
				$(".sync_schedule_form .event_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(".sync_schedule_form :hidden[name=sync_allDay]").val($(this).attr('key'));
				if($(this).attr('key') == '1'){
					modifySyncDatePicker();
				}else{
					initSyncDatePicker();
				}
			});
			
			$(".sync_schedule_form .period_type").click(function(){
				$(".sync_schedule_form .period_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(".sync_schedule_form :hidden[name=sync_cycliKey]").val($(this).attr('key'));
			});
			
			$(".sync_schedule_form .open_type").click(function(){
				$(".sync_schedule_form .open_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(".sync_schedule_form :hidden[name=sync_ispublic]").val($(this).attr('key'));
			});
			
		}
		//初始化日期控件
		function initSyncDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'datetime', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 1  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			var currdate = new Date();
            var m = currdate.getMonth () + 1;
            m = m < 10 ? "0" + m : m;
            var d = currdate.getDate ();
            d = d < 10 ? "0" + d : d;
			var h = currdate.getHours ();
            h = h < 10 ? "0" + h : h;
            var mm = currdate.getMinutes();
            mm = mm < 10 ? "0" + mm : mm;
            var ii = currdate.getSeconds();
            ii= ii < 10 ? "0" +ii:ii;
			var startdate = $(".sync_schedule_form input[name=sync_startdate]").val();
			if(!startdate){
				startdate = dateFormat(currdate, "yyyy-MM-dd hh:mm:ss");
			}else if(startdate.length <=10){
				startdate = startdate + " "+h+":"+mm+":"+ii;
			}
			var enddate = $(".sync_schedule_form input[name=sync_enddate]").val();
			if(enddate){
				if(enddate.length <=10){
					currdate.setHours (currdate.getHours () + 1);
					var hh = currdate.getHours ();
		            hh = hh < 10 ? "0" + hh : hh;
					enddate = enddate + " "+hh+":"+mm+":"+ii;
				}
			}else{
				currdate.setHours (currdate.getHours () + 1);
				var hh = currdate.getHours ();
	            hh = hh < 10 ? "0" + hh : hh;
	            enddate = currdate.getFullYear()+"-"+m+"-"+d+" "+hh+":"+mm+":"+ii+"";
			}
			
			$(".sync_schedule_form #sync_startdate").attr("format","yy-mm-dd HH:ii:ss");
			$(".sync_schedule_form #sync_enddate").attr("format","yy-mm-dd HH:ii:ss");
			
			$('.sync_schedule_form #sync_startdate').val(startdate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$(".sync_schedule_form #sync_enddate").val(enddate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		}
		
		
		//修改日期控件
		function modifySyncDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'date', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 1  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			var startdate = $(".sync_schedule_form input[name=sync_startdate]").val();
			if(startdate){
				startdate = startdate.substr(0,10);
			}
			var enddate = $(".sync_schedule_form input[name=sync_enddate]").val();
			if(enddate){
				enddate = enddate.substr(0,10);
			}
			
			$(".sync_schedule_form #sync_startdate").attr("format","yy-mm-dd");
			$(".sync_schedule_form #sync_enddate").attr("format","yy-mm-dd");
			
			$('.sync_schedule_form #sync_startdate').val(startdate).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$('.sync_schedule_form #sync_enddate').val(startdate).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
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

.scheduleform{
	position: fixed;
	width: 100%;
	z-index: 99999;
	background-color: #FAFAFA;
	top: 0px;
	height: 100%;
	font-size:14px;
	overflow-y: auto;
	max-width: 640px;
}

.cancel{
	float:left;
}
</style>

	<!-- 日程创建FORM DIV -->
	<div class="scheduleform none">
		<div id="site-nav" class="navbar">
			<div class="cancel">取消</div>
			<h3 style="padding-right:45px;">创建任务</h3>
			<div class="act-secondary quicksavetask" onclick="syncsave()"  style="padding: 0px 15px;">
				保存
			</div>
			
		</div>
		<input type="hidden" name="currpage" value="1"/>
		<input type="hidden" name="firstchar"/>
		<input type="hidden" name="pagecount" value="10"/>
		
		
		<div class="wrapper" style="margin:0px;font-size:14px;">
			<form class="sync_schedule_form" id="sync_schedule_form" method="post" novalidate="true" >
			    <input type="hidden" name="sync_schetype" value="task" />
			    <input type="hidden" name="sync_status" value="Not Started" />
			    <input type="hidden" name="sync_allDay" value="2" />
			    <input type="hidden" name="sync_ispublic" value="0" />
			    <input type="hidden" name="sync_cycliKey" value="" />
			     <input type="hidden" name="wximgids" value="" />
			    <%--主题 --%>
			    <div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group" style="margin:0.5em 0;">
						<input name="sync_title" required="required" id="sync_title" value="" type="text"
							class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="标题(必填)" style="border: 0px;border-bottom: 1px solid #ddd;"/>
						<div class="help-block empty">请填写标题</div>
					</div>
					<div class="form-group" style="margin:0.5em 0;">
						<input name="sync_addr" id="sync_addr" value="" type="text" class="form-control" placeholder="地点" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
				</div>
				<br/>
				
				<%--事件部份 --%>
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div style="line-height:40px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="float:left;color:#666;padding-left:5px;">全天事件</div>
						<div style="padding-left:100px;">
							<a href="javascript:void(0)" class="event_type" key='1' style="">是</a>
							&nbsp;&nbsp;&nbsp;
							<a href="javascript:void(0)" class="event_type selected" key='2' style="">否</a>
						</div>
					</div>

					<div class="form-group" style="margin:0.5em 0;">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">开始时间</div>
						<input name="sync_startdate" id="sync_startdate" value="" type="text" format="yy-mm-dd HH:ii:ss"  class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;" />
					</div>
					
					<div class="form-group" style="margin:0.5em 0;">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">结束时间</div>
						<input name="sync_enddate" id="sync_enddate" value="" type="text" format="yy-mm-dd HH:ii:ss"  class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;" />
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
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group">
						<textarea name="sync_desc" id="sync_desc" rows="2" style="border: 0px;min-height: 3em;border-bottom: 1px solid #ddd;"
							class="form-control" placeholder="备注"></textarea> 
					</div>
				</div>
					<!-- 上传图片 -->
				
				<div style="width:100%;padding: 5px 8px;">
					<div style="padding-top: 15px; font-size: 8px; color: #fff;clear: both;" class="imageContaint">
						<img src="<%=taskpath %>/image/mem_add.png" class="addimg" style="float:left;padding: 2px; color: #fff; border-radius: 5px;width:64px;">								
				</div>
				<br/>
<!-- 				<br/>
				<div style="margin:10px 80px;">
					<input type="button" onclick="syncsave();" class="savetaskbtn btn btn-block btn-success" value="保存">
				</div>
 -->			</form>
			<br/>
		</div>
	</div>
</div>	
	<div class="ScheduleMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 999999;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
