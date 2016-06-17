<%@page import="com.takshine.wxcrm.message.sugar.ScheduleAdd"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	Object rowId = request.getAttribute("rowId");
	Object sign = request.getAttribute("sign");   //这个状态用来标记该子任务的父任务是否已经被提交
	Object schetype = request.getAttribute("schetype");
	Object sd = request.getAttribute("sd");
	String orgId = "";
	if(null != sd){
		orgId = ((ScheduleAdd)sd).getOrgId();
	}
	String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?orgId="+orgId+"&parentId="+rowId+"&parentType=schedule&schetype="+schetype);
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/zjwk.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/calendar/fullcalendar2.css" />
	<!-- 日历控件 -->
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css" rel="stylesheet" type="text/css" />
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
    <link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
 <script type="text/javascript">

    $(function () {
    	//完成状态 控制现实区域
    	var compStatus = '${sd.status}';
    	initButton();
    	initDatePicker();    	
    	initForm();
    	initQuanTianEvent();
    	if(document.getElementById("desc")){
    		autoTextAreaDetail("desc");
		}
	});

    //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date'},
    		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
    		time : {preset : 'time'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	$('.scheduleDetail #enddate').val('${sd.enddate}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    	$('.scheduleDetail #startdate').val('${sd.startdate}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }

    //初始化按钮
    function initButton(){
		 //是否显示修改按钮
	   	 var assignerid = '${sd.assignerid}';
	   	 if('${crmId}'==assignerid){
	   		//$("#deletediv").css("display","");
	   		//$("#savecontact").css("display","");
	   		$(".tasks_menu").css("display","");
	   	 }
    }
    
    function initForm(){
    	//保存
    	$("#savecontact").click(function(){
    		var start = $('.scheduleDetail #startdate').val();
    		var end = $('.scheduleDetail #enddate').val();
    		if (end != null && end != "" && end!="0000-00-00 00:00:00" && start > end){
    			$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("结束时间不能小于开始时间！");
    	    	$(".myDefMsgBox").delay(2000).fadeOut();
    	    	return;
    		}
    		var wximgids =$("input[name=wximgids]").val();
    		
    		//有图片才从微信下载并上传OSS
				if (wximgids){
					var req = {
		    			imgids:wximgids,
		    			relaId:"${rowId}",
		    			relaType:'Resource',
		    			fileType:'img'
		    		};
					try{
						calendarDown4wx(req, {
							success: function(res){
								if(res.status == 'success'){
									$("form[name=scheduleDetail]").submit();
								}
							}
							
						});
					}catch (e) {
						// TODO: handle exception
					}
				}else{
					$("form[name=scheduleDetail]").submit();
				}
    		//$(".myDefMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("保存成功!");
	    	//$(".myDefMsgBox").delay(2000).fadeOut(	
    	});
    	//状态
    	$("input[name=statusname]").click(function(){
    		lovjs_choose('statusDom',{
        		success: function(res){
        			$(".scheduleDetail :hidden[name=status]").val(res.key);
        			$("input[name=statusname]").val(res.val);
        		}
        	});
    	});
    	
    	//选择客户
    	$("input[name=parentName]").click(function(){
    		customerjs_choose({
        		success: function(res){
        			$(".scheduleDetail :hidden[name=parentId]").val(res.key);
        			$(".scheduleDetail :hidden[name=parentType]").val('Accounts');
        			
        			$("input[name=parentName]").val(res.val);
        			
        			//清空联系人
        			$(".scheduleDetail :hidden[name=contact]").val('');
        			$("input[name=contactname]").val('');
        		}
        	});
    	});
    	
    	//选择联系人
    	$("input[name=contactname]").click(function(){
    		var cid = $(".scheduleDetail :hidden[name=parentId]").val();
    		var ctype = "Accounts";
    		contactjs_choose(cid,ctype,{
        		success: function(res){
        			$(".scheduleDetail :hidden[name=contact]").val(res.key);
        			$("input[name=contactname]").val(res.val);
        		}
        	});
    	});
    	
    	//选择责任人
    	$("input[name=assigner]").click(function(){
    		//var cid = $(".scheduleDetail :hidden[name=parentId]").val();
    		//var ctype = "Users";
    		userjs_choose({
        		success: function(res){
        			$(".scheduleDetail :hidden[name=contact]").val(res.key);
        			$("input[name=assigner]").val(res.val);
        		}
        	});
    	});
    	
    	//新增子任务
    	$(".addsubtask").click(function(){
    		var req = {
    			relaId:"${sd.rowid}",
    			relaType:'Tasks',
    			orgId:'${sd.orgId}'
    		};
    		schedulejs_choose(req,{
        		success: function(res){
        			var val = '<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">'+res.startdate.substr(5,5)+'</div>'
							+ '<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">'
						    + '<a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&return_id=${return_id}&return_type=${return_type}&rowId='+res.rowid+'">'+res.title+'</a>&nbsp;('+res.statusname+')'
							+ '</div>';
					$(".subtasklist").before(val);
        		}
        	});
    	});
    }
    
    //全天事件
    function initQuanTianEvent(){
    	//TODO
    	var startdate = $("input[name=startdate]").val();
    	var enddate = $("input[name=enddate]").val();
    	if(startdate === enddate){
    		$("input[name=enddate]").val(enddate.split(" ")[0] + " 23:59:59");
    	}
    }
    
    //修改是否公开
    function updatePublic(){
    	 var obj = $("select[name=publicSel]");
    	 var v = obj.val();
    	 $(".scheduleDetail :hidden[name=ispublic]").val(v);
    }
    
    //删除实体对象
    function delSchedule(){
    	if(!confirm("确定删除吗?")){
			return;
		}
	  	$.ajax({
    		url: '<%=path%>/schedule/delSchedule',
    		type: 'post',
    		data: {rowid:'${sd.rowid}',optype:'del'},
    		dataType: 'text',
    	    success: function(data){
    	    	
    	    	$(".myDefMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("操作成功!");
    	    	$(".myDefMsgBox").delay(2000).fadeOut();
    	    	
    	    	if("${workId}")
    	    	{
    	    		window.location.replace("<%=path%>/workplan/detail?rowId=${workId}&orgId=${orgId}&flag=${workFlag}&viewtype=${workViewtype}&index=${workIndex}");
    	    	}
    	    	else if("${return_type}" == 'custsubtask'){
    	    		window.location.replace("<%=path%>/customer/detail?rowId=${return_id}&orgId=${orgId}");
    	    	}
    	    	else if("${return_type}" == 'opptysubtask'){
    	    		window.location.replace("<%=path%>/oppty/detail?rowId=${return_id}&orgId=${orgId}");
    	    	}
    	    	else
    	    	{
        	    	window.location.replace("<%=path%>/calendar/calendar");
    	    	}
    	    }
    	});
    }
    
    //取消操作
    function cancel(){
    	window.location.replace("<%=path%>/calendar/calendar");
    }
    
    function disable(d)
    {
        for(var i=0;i<d.childNodes.length;i++)
        {
            if(d.childNodes[i].disabled!=null)
            {
                d.childNodes[i].disabled = true;
            }
        }
    }
    function enable(d)
    {
        for(var i=0;i<d.childNodes.length;i++)
        {
            if(d.childNodes[i].disabled!=null)
            {
                d.childNodes[i].disabled = false;
            }
        }
    }
	function webChange(){ 
		//if(element.value){document.getElementById("test").innerHTML = element.value};
		enable(document.getElementById("deletediv"));
		enable(document.getElementById("savecontact"));
	} 
    function appendChangedEvent(element){ 
    	if("\v"=="v") { 
    		element.onpropertychange = webChange; 
    	}else{ 
    		element.addEventListener("input",webChange,false); 
    	} 
    } 
    
    
    function autoTextAreaDetail(elemid){
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
	    
	    change(true);
	    
	    function change(flag){
	    	document.getElementById("_textareacopy").value= document.getElementById("desc").value;
	    	var height = document.getElementById("_textareacopy").scrollHeight;
	    	if(height>200){
	    		return;
	    	}
	    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
	    		document.getElementById("desc").style.height= "40px";
	    	}else{
	    		if (flag)
	    		{
	    			document.getElementById("desc").style.height= document.getElementById("_textareacopy").scrollHeight * 1.6 + "px";
	    		}
	    		else
	    		{
	    			document.getElementById("desc").style.height= document.getElementById("_textareacopy").scrollHeight + "px";
	    		}
	    	}
	    }
	    
	    $("#desc").bind("propertychange",function(){
	    	change(false);
	    });
	    $("#desc").bind("input",function(){
	    	change(false);
	    });
	    $("#desc").bind("onfocus",function(){
	    	change(false);
	    });
	
	    document.getElementById("desc").style.overflow="hidden";//一处隐藏，必须的。
	    document.getElementById("desc").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
	}
  </script>
</head>
<body>
<div id="task-create">
	<%--<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div id="deletediv" class="act-secondary" style="display:none;">
			<img src="<%=path %>/image/fasdel.png" style="margin:5px;" width="20px;" onclick="delSchedule()">
		</div>
		<div id="savecontact" class="act-secondary" style="display:none;margin-right:40px;">
			<img src="<%=path %>/image/save_information.png" style="margin:5px;" width="28px;">
		</div>
		
		<h3 style="padding-right:45px;"><c:if test="${schetype ne 'plan' }">任务详情</c:if><c:if test="${schetype eq 'plan' }">计划任务详情</c:if></h3>
	</div>
	 --%>
	 
	<div id="site-nav" class="tasks_menu" style="<c:if test="${sd.authority ne 'Y' }">display:none;</c:if>font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
	  <c:if test="${sign ne 'ytj'}">
	    <a href="javascript:void(0)"  id="deletediv" onclick="delSchedule()" style="padding:5px 8px;">删除</a>
	  </c:if>
		<a href="javascript:void(0)" id="savecontact" style="padding:5px 8px;">保存</a>
		<a href="javascript:void(0)" id="cancel" onclick="cancel()" style="padding:5px 8px;">取消</a>
	</div>
	
	<div id="scheduleDetail" style="font-size:14px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;">
		<div class="recommend-box scheduleDetailForm">
				<form class="scheduleDetail"  name="scheduleDetail" action="<%=path%>/schedule/scheduleComplete?action=calendar" method="post" novalidate="true" >
					<input type="hidden" name="rowId" value="${rowId}" />
					<input type="hidden" name="driority" value="${sd.driority}" />
					<input type="hidden" name="participant" value="${sd.participant}" />
			        <!-- <input type="hidden" name="desc" value="${sd.desc}" /> -->
			        <input type="hidden" name="cycliKey" value="${sd.cyclikey}" />
			        <input type="hidden" name="cycliValue" value="${sd.cyclivalue}" />
			        <input type="hidden" name="schetype" value="${schetype}" />
					<input type="hidden" name="ispublic" value="${ispublic}" />
					<input type="hidden" name="crmId" value="${crmId}" />
					<input type="hidden" name="orgId" value="${sd.orgId}" />
					<input name="contact" id="contact" value="${sd.contact }" type="hidden" >
					<input name="parentType" id="parentType" value="${sd.relamodule }" type="hidden" />
					<input name="parentId" id="parentId" value="${sd.relarowid}" type="hidden" />
					
					<!-- 保存从工作计划过来的信息 -->
					<input name="workId" value="${workId }" type="hidden"/>
					<input name="workIndex" value="${workIndex }" type="hidden"/>
					<input name="workFlag" value="${workFlag }" type="hidden"/>
					<input name="workViewtype" value="${workViewtype }" type="hidden"/>
					
					<!--  -->
					<input type="hidden" name="return_id" value="${return_id}">
					<input type="hidden" name="return_type" value="${return_type}">
					<input type="hidden" name="wximgids" value="" />
				<%--主题 --%>
			    <div style="width:100%;padding:5px 10px;background-color:#fff;border-bottom:1px solid #ddd;">
					<div style="margin:0.5em 0;">
						<input name="title" required="required" id="title" value="${sd.title }" type="text" readonly="readonly"
							class="form-control" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					<div style="margin:0.5em 0;">
						<input name="addr" id="addr" value="${sd.addr }" type="text" class="form-control" placeholder="地点" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					
					<div style="margin:0.5em 0;">
						<input name="startdate" required="required" id="startdate" value="${sd.startdate }" type="text" format="yy-mm-dd HH:ii:ss" readonly="readonly"
							class="form-control" style="width:45%;border: 0px;border-bottom: 1px solid #ddd;float:left"/>
						<div style="float:left;width:8%;line-height: 30px;text-align: center;"> — </div> 
						<input name="enddate" required="required" id="enddate" value="${sd.enddate }" type="text" format="yy-mm-dd HH:ii:ss" readonly="readonly"
							class="form-control" style="width:45%;border: 0px;border-bottom: 1px solid #ddd;float:left;"/>
					</div>
					
					<div style="clear:both;"></div>
					
					
					<div>
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">状态</div>
						<input name="statusname" id="statusname" value="${sd.statusname}" type="text" class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;" />
						<input name="status" id="status" value="${sd.status }" type="hidden">
						<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
					</div>
					
					<div style="width:100%;">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">备注</div>
							<textarea name="desc" id="desc" rows="2"  style="border:0px;padding-left:100px;"
								 placeholder="备注">${sd.desc}</textarea> 
					</div>
						<!-- 上传图片 -->
					<div style="width:100%;padding: 5px 8px;">
						<div style="padding-top: 15px; font-size: 8px; color: #fff;clear: both;min-height:200px;" class="imageContaint">
								<c:if test="${fn:length(imgList) >0 }">
									<c:forEach items="${imgList}" var="img">
										<div  style="float: left;" >
										<img onclick="zjwk_prev_img(this);" class="messages_imgs_list" style="float:left;width:64px;height:64px;" val="${img.source_filename}"  width="64px;" height="64px"   id="${img.id }" src="<%=ossImgPath %>/${img.source_filename}">
										<img src="<%=path %>/image/fasdel.png" class="delImg" style="margin-top:-50;margin-left: -10px;cursor: pointer; height: 15px; width: 15px; position: relative; top: 22px; left: 0px;">
										
										</div>
									</c:forEach>
								</c:if>
							 
								<div style="width:100%;" class="addimg_div">
									<div style="padding-top: 15px; font-size: 8px; color: #fff;clear: both;" >
										<img src="<%=path %>/image/mem_add.png" class="addimg" style="float:left;padding: 2px; color: #fff; border-radius: 5px;width:64px;">								
									</div>   
								</div>
							</div>	
				</div>
				<script type="text/javascript">
				/* $('input[name="slider1"]')
				appendChangedEvent();
				appendChangedEvent(title);
				appendChangedEvent(startdate);
				appendChangedEvent(enddate);
				appendChangedEvent(statusname);
				appendChangedEvent(desc);
				disable(document.getElementById("deletediv"));
				disable(document.getElementById("savecontact")); */
				</script>
				</form>
				
				<div style="width:100%;padding:5px 10px;background-color:#fff;border-bottom:1px solid #ddd;margin-top:5px;">
					<div style="padding:3px 5px;border-bottom: 1px solid #ddd;">
						<div style="position: absolute;line-height: 40px;color:#666;">负责人</div>
						<input name="assigner" id="assigner" value="${sd.assigner}" type="text" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
						<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
					</div>
					<div style="clear:both;"></div>
					<%-- 加载团队 --%>
					<jsp:include page="/common/teamlist.jsp">
						<jsp:param value="Tasks" name="relaModule"/>
						<jsp:param value="${rowId}" name="relaId"/>
						<jsp:param value="${crmId }" name="crmId"/>
						<jsp:param value="${sd.title }" name="relaName"/>
						<jsp:param value="${sd.authority}" name="assFlg"/>
						<jsp:param value="${sd.orgId}" name="orgId"/>
					</jsp:include>
					
					<div style="clear:both;"></div>
					
					<div style="padding:3px 5px;border-bottom: 1px solid #ddd;">
						<div style="position: absolute;line-height: 40px;color:#666;">客户</div>
						<input name="parentName" id="parentName" value="${sd.relaname}" type="text" placeholder="点击选择客户" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;margin-top: 6px;" />
						<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
					</div>
					<div style="clear:both;"></div>
					
					<div style="padding:3px 5px;">
						<div style="position: absolute;line-height: 40px;color:#666;">联系人</div>
						<input name="contactname" id="contactname" value="${sd.contactname }" type="text" placeholder="点击选择联系人" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;margin-top: 6px;" />
						<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
					</div>
					<div style="clear:both;"></div>
					
				</div>
				
				
				<div style="width:100%;padding:5px 10px;background-color:#fff;margin-top:5px;">
					<div style="line-height:30px;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">子任务
							<div class="addsubtask" style="float:right;padding:5px;font-size:28px;font-weight:bold;margin-top: -10px;">+</div>
						</div>
						
						<div style="font-size:14px;color:#666;" class="subtasklist">
							<c:forEach items="${subTaskList }" var="subtask">
								<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">${fn:substring(subtask.startdate, 5, 10)}</div>
								<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">
									<a href="<%=path %>/schedule/detail?orgId=${subtask.orgId }&schetype=${subtask.schetype}&rowId=${subtask.rowid}&return_id=${return_id}&return_type=${return_type}">${subtask.title}</a>&nbsp;(${subtask.statusname})
								</div>
								
								<p style="border-top: 1px solid #FAFAFA;"></p>
							</c:forEach>
						</div>
					</div>
				</div>
				
				<br/>
				
				<!-- 消息显示区域 -->
				<jsp:include page="/common/msglist.jsp">
					<jsp:param value="schedule" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
				</jsp:include>
			</div>
		</div>
		<!-- 图片显示info -->	
		<div id="img_info"  style="z-index:9999;background-color: #ffffff;position: absolute;top:0px;display:none;width: 100%;height:100%;">
			  <div class="navbar" style="width: 100%;">
				<div style="float: left;line-height:50px;">
					<a href="javascript:void(0);" id="img_info_back" style="padding:10px 5px;">
						<img  src="<%=path %>/image/back.png" width="30px">
					</a>
				</div>	
				  
			</div>
			<div  id="img_info_div" style="width: 100%;height:100%;">
			 	<img id="img_info_body" src="" style="width:100%;">
			</div>
		</div>
		<!-- 发送消息的区域 -->
		<div class="flooter" id="flootermenu" 
		       style="z-index: 99999;background: #FFF;background: rgb(253, 253, 255);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!--发送消息的区域  -->
			<jsp:include page="/common/sendmsg.jsp">
				<jsp:param value="schedule" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
				<jsp:param value="${sd.title}" name="relaName"/>
			</jsp:include>
		</div>
	</div>
	
	<div class="myDefMsgBox" style="display:none;">&nbsp;</div>
	<script type="text/javascript">
	$("#img_info_back").click(function(){
		  $("#img_info").hide();
		 
	});
	function zjwk_prev_img(o){
		  $("#img_info_body").attr("src",$(o).attr("src"));
		  $("#img_info").show();
		  
	}
	
	
	$("#img_info_body").click(function () {
		  $("#img_info").hide();
	});
	
	</script>
</div>
	<%-- lov --%>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	 
	<%--子任务 --%>
	<jsp:include page="/common/add/addtask.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	
	<%-- 客户 --%>
	<jsp:include page="/common/rela/selcustToCalendar.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	
	<%-- 联系人 --%>
	<jsp:include page="/common/rela/selcont.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	
	<%-- 责任人 --%>
	<jsp:include page="/common/rela/seluser.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	
	<jsp:include page="/common/ertuserlist.jsp">
		<jsp:param value="schedule" name="relaModule"/>
	</jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	 var serverids="";
	  wx.ready(function () {
		  var opt = {
			  title: "分享任务",
			  desc: "${sd.title}",
			  link: "<%=shortUrl%>",
			  imgUrl: "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png" 
		  };
		  wxjs_initMenuShare(opt);
			$(".addimg").click(function(){
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
	  								 var v = "";
	  								 
	  								 for(var i=0;i<localids.length;i++){
	  									 v += '<div style="float: left;"><img style="margin:2px;" val="'+images.serverId+'" class="messages_imgs_list" onclick="zjwk_prev_img(\"messages_imgs_list\",this)" src="'+localids[i]+'" width="64px;" height="64px" style="float:left;width:64px;height:64px;">';
	  									 v += '<img src="<%=path %>/image/fasdel.png" class="delImg" style="margin-top:-50;margin-left: -10px;cursor: pointer; height: 15px; width: 15px; position: relative; top: -2px; left: 0px;"></div>';
	  								 }
	  								 serverids+= images.serverId+",";
	  								 $(".addimg_div").before(v);
	  								 $(":hidden[name=wximgids]").val(serverids);
	  								  //删除图片
	  								 $(".delImg").click(function(){
	  									 var val=$(this).parent().find(".messages_imgs_list").attr("val");
	  									 var str =serverids.indexOf(val);
	  									 if(val&&str>-1){
	  										 serverids=serverids.replace(val+",","");
	  										 $(":hidden[name=wximgids]").val(serverids);
	  									 }
	  									 $(this).parent().remove();
	  									 
	  								 });
	  							 }
	  						 });
	  					  }
	  				});
	  		});
		  
	  });
	  //删除图片
		 $(".delImg").click(function(){
			 var val=$(this).parent().find(".messages_imgs_list").attr("val");
			 var str =serverids.indexOf(val);
			 if(val&&str>-1){
				 serverids=serverids.replace(val+",","");
				 $(":hidden[name=wximgids]").val(serverids);
			 }
			 $(this).parent().remove();
			 
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
	  	$(function(){
	  		$(".messages_imgs_list").each(function(){
		  		  var val =$(this).attr("val");
		  		  if(val){
		  			serverids+=val+",";
		  		  }	  
		  	});
	  		$("input[name=wximgids]").val(serverids);
	  	});
     
	  //从微信服务器上下载文件
	  function calendarDown4wx(req,setting){
	  	if(!setting) setting = {};
	  	var res = {
	  		status :[]
	  	};
	  	$.ajax({
	  		type: 'post',
	  		url : getContentPath()+'/files/calendarDown4wx',			
	      data: {
	      	serverids:req.imgids,
	      	relaid:req.relaId,
	      	relatype:req.relaType,
	      	filetype:req.fileType
	      },
	      dataType: 'text',
	  	    success: function(data){
	  	    	if(data && data == 'success'){
	  		    	if(setting.success){
	  		    		res.status = 'success';
	  		      		setting.success(res);
	  		      	}
	  	    	}else{
	  	    		alert("上传文件失败！");
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
	 
	</script>
</body>
</html>