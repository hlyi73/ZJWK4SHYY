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
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script type="text/javascript">
    $(function () {
    	initSystemForm_();
		initSystemFriChar_();
		initSystemData_();
    	initForm();
	});
    
    var systemObj_={};
	function initSystemForm_(){
		systemObj_.fstchar = $(":hidden[name=assignerfstChar]");
		systemObj_.currtype = $(":hidden[name=assignercurrType]");
		systemObj_.currpage = $(":hidden[name=assignercurrPage]");
		systemObj_.pagecount = $(":hidden[name=assignerpageCount]");
		systemObj_.chartlist = $(".assignerChartList");
		systemObj_.assignerlist = $(".assignerList");
		systemObj_.assignerNoData = $("#assignerNoData");
	}

	//异步加载首字母
	function initSystemFriChar_(){
		systemObj_.chartlist.empty();
		systemObj_.fstchar.val('');
		var type=systemObj_.currtype.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/fchart/list',
		      data: {crmId: '${crmId}',type: type},
		      dataType: 'text',
		      success: function(data){
		    	    if(!data) return;
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	systemObj_.chartlist.html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	    $(".systemdiv_").css("display","none");
		    	    	return;
	    	    	}
		    	    var ahtml = '';
		    	    $(d).each(function(i){
		    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseFristCharts_(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
		    	    });
		    	    systemObj_.chartlist.html(ahtml);
		      }
		 });
	}

	//选择字母查询
	function chooseFristCharts_(obj){
		systemObj_.currpage.val(1);
		systemObj_.fstchar.val($(obj).html());
		initSystemData_();
	}

	//异步查询责任人
	function initSystemData_(){
		var currpage = systemObj_.currpage.val();
		var pagecount = systemObj_.pagecount.val();
		var firstchar = systemObj_.fstchar.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/lovuser/userlist',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    if(null==data||""==data){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerNoData.css("display","");
		    	    	}
		    	    	return;
		    	    }
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerNoData.css("display","");
		    	    		systemObj_.chartlist.css("display",'none');
		    	    	}
		    	    	return;
		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerlist.html(d.errorMsg);
		    	    	}
		    	    	return;
		    	    }else{
						$(d).each(function(i){
							val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
								+  '<div class="list-group-item-bd"><input type="hidden" name="assId" value="'+this.userid+'"/>'
								+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
								+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
						});
						systemObj_.chartlist.css("display",'');
			    	}
		    	    systemObj_.assignerlist.html(val);
		      }
		 });
	}
    
    function initForm(){
    	var selObj = $("select[name=viewtype]");//列表类型
    	var userObj = $("select[name=userlist]");//团队用户的下拉列表
    	var focusUserObj = $("select[name=focusUserlist]");//关注用户的下拉列表
    	
    	//获取类型值
    	selObj.val('${viewtype}');
    	$(".viewtypelabel").html(selObj.find("option:selected").text());

    	if(selObj.val() == "subview"){//我团队的日程列表
    		$(".userdiv").removeClass("modal");
    	}else if(selObj.val() == "focusview"){//我关注的日程列表
        	$(".focusUserdiv").removeClass("modal");
    	}
    	
    	//列表类型 下拉框初始化
    	selObj.change(function(){
        	if(selObj.val() == "subview"){//我团队的日程列表
            	$(".userdiv").removeClass("modal");
            	$(".tasklist").addClass("modal");
            	$(".focusUserdiv").addClass("modal");
            	userObj.val("-999");//清空选择
            	
            } else if(selObj.val() == "focusview"){//我关注的日程列表
            	$(".focusUserdiv").removeClass("modal");
            	$(".userdiv").addClass("modal");
            	$(".tasklist").addClass("modal");
            	
            }
        	//提交更新数据
        	$("form[name=viewtypeForm]").submit();
        	return false ;
    	});
    	
    	//团队用户下拉列表
    	userObj.change(function(){
    		if(userObj.val() != "-999"){
    			$("form[name=viewtypeForm]").attr("action","<%=path%>/schedule/list?viewtype=subview&assignId="+userObj.val());
    			$("form[name=viewtypeForm]").submit();
    			return false ;
    		}
    		
    	});
    	
    	//关注用户下拉列表
    	focusUserObj.change(function(){
    		//添加关注
    		if($(this).val() === "addFocus"){
    			$(".userList").removeClass("modal");
    			$(".tasklist").addClass("modal");
    			$("#div_next").addClass("modal");
    		}else{
    			$("form[name=viewtypeForm]").attr("action","<%=path%>/schedule/list?viewtype=focusview&assignId="+focusUserObj.val());
    			$("form[name=viewtypeForm]").submit();
    		}
    		return false ;
    		
    	});
    	
    	var assId = '${assignerId}', vtype = '${viewtype}';
    	if(!assId && vtype === 'focusview'){
    		var len = focusUserObj.find("option").size();
        	if(len >= 3){
        		var id = focusUserObj.find("option").eq(2).val();
        		$("form[name=viewtypeForm]").attr("action","<%=path%>/schedule/list?assignId="+id);
    			$("form[name=viewtypeForm]").submit();
        	}	
    	}
    	
    	//用户选择控制
    	systemObj_.assignerlist.click(function(){
    	      if($(this).hasClass("checked")){
    	    	  $(this).removeClass("checked");
    	      }else{
    	    	  $(this).addClass("checked");
    	      }
    	      return false;
    	});
    	
    	//点击关注按钮
    	$(".assignerbtn").click(function(){
    		var assIdsNames = '';
    		$(".assignerList.checked").each(function(){
    			assIdsNames += $(this).find(":hidden[name=assId]").val() + "|" + encodeURI($(this).find(".assName").text()) +",";
    		});
    		//拼装提交参数
    		var url = "<%=path%>/schedule/userFocus";
    		$(":hidden[name=assIdsNames]").val(assIdsNames);
    		$("form[name=viewtypeForm]").attr("action", url);
			$("form[name=viewtypeForm]").submit();
			return false;
    	});
    }
    
    function topage(){
    	
    	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
    	$(".nextspan").text('努力加载中...');
    	var currpage = $("input[name=currpage]").val();
		
    	$("input[name=currpage]").val(parseInt(currpage) + 1);
    	currpage = $("input[name=currpage]").val();
		
    	var selObj = $("select[name=viewtype]");//列表类型
    	var userObj = $("select[name=userlist]");//团队用户的下拉列表
    	var focusUserObj = $("select[name=focusUserlist]");//关注用户的下拉列表
    	var assignId = "";
    	if(selObj.val() == "subview"){
    		assignId = userObj.val();
    	}else if(selObj.val() == "focusview"){
    		assignId = focusUserObj.val();
    	}
    	
    	
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/schedule/tlist' || '',
		      //async: false,
		      data: {viewtype:'${viewtype}',currpage:currpage,pagecount:'10',assignId:assignId} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_tasks_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_next").css("display",'none');
	    	    	    return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							var schetype = this.schetype;
							var img = '<img src="<%=path %>/image/schedule.png" width="16px">';
							if(schetype == 'meeting'){
								 img = '<img src="<%=path %>/image/oppty_partner.png" width="16px">';
							}else if(schetype == 'phone'){
								img = '<img src="<%=path %>/image/mb_card_contact_tel.png" width="16px">';
							}
							val += '<a href="<%=path%>/schedule/detail?rowId='+this.rowid+'&orgId='+this.orgId+'&schetype='+schetype+'" class="list-group-item listview-item">'
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'+this.statusname+'</b> </div>';
							if(this.orgId=='Default Organization'){
								 val += '<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">';
							}
							val += '<div class="content" style="text-align: left">'
								+ '<h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">'+img+'开始时间：'+this.startdate+'</p>'
								+ '</div></div> '
								+ '<div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	$("#div_next").css("display",'none');
		    	    }
					$("#div_tasks_list").html(val);
					$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
					$(".nextspan").text('下一页');
		      }
		 });
	}
    
    function add(){
    	window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/schedule/get');
    }
    </script>
</head>
<body>
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a href="javascript:void(0)" onclick="add()" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
			<a href="javascript:void(0)" class="list-group-item listview-item">
			    <form name="viewtypeForm" action="<%=path%>/schedule/list" method="post">
			        <input type="hidden" name="currpage" value="1" />
			        <input type="hidden" name="assIdsNames" value="" />
					<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
						<p>
							<div class="form-control select _viewtype_select">
								<c:if test="${viewtype eq 'noticeview'}">
									<span style="color: white">延期未完成任务</span>
								</c:if>
								<c:if test="${viewtype ne 'noticeview'}">
								<div class="select-box2"><span class="viewtypelabel"></span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
								<%--<div class="select-box viewtypelabel"></div> --%>
									<select name="viewtype" id="viewtype" style="display:none;">
										<option value="calendar">我的日程表</option>
										<option value="todayview">我的当日任务</option>
										<option value="historyview">我的历史任务</option>
										<option value="planview">我的计划任务</option>
										<option value="teamview">我下属的任务</option>
										<option value="shareview">我参与的任务</option>
										<option value="focusview">我关注的任务</option>
									</select>
								</c:if>
							</div>
						</p>
					</div>
				</form>
			</a>
	</div>
	
	<!-- 下拉菜单选项 -->
	<script>
	$(function () {
		$("._viewtype_select").click(function(){
			viewtypeClick();
		});	
		
		$("body").click(function(e){
			if($("#_viewtype_menu").css("display") == "block" && e.target.className == ''){
				viewtypeClick();
			}
		});
	});
	
	function viewtypeClick(){
		if($("#_viewtype_menu").css("display") == "none"){
			$("#_viewtype_menu").css("display","");
			$("#_viewtype_menu").animate({height : 155}, [ 10000 ]);
			$(".site-recommend-list").css("display","none");
			$("#focusUserdiv").css("display","none");
		}else{
			$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu").css("display","none");
			$(".site-recommend-list").css("display","");
			$("#focusUserdiv").css("display","");
		}
	}
	</script>
	<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/calendar/calendar">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的日程表
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=todayview">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的当日任务
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=historyview">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的历史任务
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=planview">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的计划任务
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=teamview">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的任务
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=shareview">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我参与的任务
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=focusview">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我关注的任务
			</div>
		</a>
		<a href="javascript:void(0)">
			<div style="float:right;padding:10px;width:50%;">
				&nbsp;
			</div>
		</a>
		<div style="clear:both"></div>
	</div>
	<!-- 下拉菜单选项 end -->
	
	<!-- 团队用户下拉列表   与 我团队的日程列表 关联-->
	<div id="userdiv" class="info typo modal userdiv"
		style="width: 150px; margin: 0 auto; padding-top: 5px; padding-bottom: 5px;">
		<div class="select-box"></div>
		<select name="userlist" id="userlist"
			style="width: 150px; padding-top: 5px; padding-bottom: 5px;">
			<option value="">请选择</option>
			<c:forEach var="item" items="${userList}">
				<c:if test="${item.userid ne crmId }">
					<c:if test="${item.userid == assignerId}">
						<option value="${item.userid}" selected>${item.username}</option>
					</c:if>
					<c:if test="${item.userid != assignerId}">
						<option value="${item.userid}">${item.username}</option>
					</c:if> 
				</c:if>
			</c:forEach>
		</select>
	</div>
	<!-- 关注用户下拉列表   与 我关注的用户的日程列表 关联-->
	<div id="focusUserdiv" class="info typo modal focusUserdiv"
		style=" margin: 0 auto; padding-top: 5px; padding-bottom: 5px;text-align: center;">
		<div class="select-box"></div>
		<select name="focusUserlist" id="focusUserlist"
			style="width: 180px; padding-top: 5px; padding-bottom: 5px;height: 40px;">
			<option value="">请选择</option>
			<option value="addFocus">添加关注</option>
			<c:forEach var="item" items="${focusUserList}" varStatus="i">
				<c:if test="${item.focusCrmId == assignerId}">
					<option value="${item.focusCrmId}" selected>${item.focusCrmName}</option>
				</c:if>
				<c:if test="${item.focusCrmId != assignerId}">
					<option value="${item.focusCrmId}">${item.focusCrmName}</option>
				</c:if> 
			</c:forEach>
		</select>
	</div>
	<div class="site-recommend-list page-patch ">
	    <!-- 日程列表 -->
		<div class="list-group listview tasklist" style="margin-top:-1px;" id="div_tasks_list">
			<c:forEach items="${taskList }" var="task">
				<a href="<%=path%>/schedule/detail?rowId=${task.rowid}&schetype=${task.schetype}&orgId=${task.orgId}" 
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b>${task.statusname}</b>
						</div>
						<c:if test="${task.orgId eq 'Default Organization' }">
							<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">
						</c:if>
						<div class="content">
							<h1>${task.title }&nbsp;<span
									style="color: #AAAAAA; font-size: 12px;">${task.assigner }</span></h1>
							<p class="text-default">
								<c:if test="${task.schetype eq 'phone' }">
									<img src="<%=path %>/image/mb_card_contact_tel.png" width="16px">
								</c:if>
								<c:if test="${task.schetype eq 'meeting' }">
									<img src="<%=path %>/image/oppty_partner.png" width="16px">
								</c:if>
								<c:if test="${task.schetype ne 'phone' && task.schetype ne 'meeting'}">
									<img src="<%=path %>/image/schedule.png" width="16px">
								</c:if>
								开始时间：${task.startdate}</p>
							</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
				
			</c:forEach>
			
			<c:if test="${fn:length(taskList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
		</div>
		<c:if test="${fn:length(taskList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					<span class="nextspan">下一页</span>&nbsp;<img id="nextpage" src="<%=path %>/image/nextpage.png" width="24px"/>
				</a>
			</div>
		</c:if>
		<!-- 用户列表 -->
		<div id="userList" class="modal">
			<input type="hidden" name="assignerfstChar" />
		    <input type="hidden" name="assignercurrType" value="userList" />
		    <input type="hidden" name="assignercurrPage" value="1" />
		    <input type="hidden" name="assignerpageCount" value="1000" />
			<!-- 字母区域 -->
			<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
			</div>
			<div class="list-group listview listview-header assignerList">
				<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
			</div>
			<div id="phonebook-btn systemdiv" class="wrapper" style="">
				<input class="btn btn-block assignerbtn" type="submit" value="关&nbsp&nbsp&nbsp注">
			</div>
		</div>
		
		
		<c:if test="${userFocusRst != null}">
			<div class="view site-phonebook">
				<div class="well text-center wrapper" style="padding: 3em 0">
					<h3 class="text-info" style="font-size: 18px;">添加关注成功!</h3>
				</div>
			</div>
		</c:if>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>