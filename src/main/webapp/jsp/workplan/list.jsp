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
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />

<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>

<script type="text/javascript">
	function add(){
		window.location.replace("<%=path%>/operorg/list?source=WorkReport&redirectUrl=" + encodeURIComponent('/workplan/get'));
	}
	
	$(function(){
		var width=$(".workplanlist").width();
		$("#more_div_praise").css("margin-left",parseInt(width)-70);
		$("#more_div_praise1").css("margin-left",parseInt(width)-70);
		$("#more_div_praise11").css("margin-left",parseInt(width)-70);
		$("#more_div_praise2").css("margin-left",parseInt(width)-70);
		initDatePicker();
		initForm();
		$(".commensspan").each(function(){
			var obj = $(this);
			var id = obj.attr("id");
			if(id){
				$.ajax({
					   type: 'post',
					   url: '<%=path%>/workplan/getCalcAvg',
					   data: {rowId:id},
					   dataType: 'text',
					   success: function(data){
						   if(!data){
							   return;
						   }
						   obj.css("display","");
						   obj.html(data);						   
					   }
					});
			}
		});

		
		 $(".type_sel").click(function(){
         	var type = $(this).attr("key");
         	$(":hidden[name=type]").val(type);
         	$(".type_sel").removeClass("selected").addClass("noselected");
         	$(this).removeClass("noselected").addClass("selected");
         });
		 
		 $(".viewtype_sel").click(function(){
	         	var type = $(this).attr("key");
	         	if(type != 'myview'){
	         		$(".assigner_list_div").css("display","");
	         	}else{
	         		$(".assigner_list_div").css("display","none");
	         	}
	         	$(":hidden[name=viewtype]").val(type);
	         	$(".viewtype_sel").removeClass("selected").addClass("noselected");
	         	$(this).removeClass("noselected").addClass("selected");
	     });
		 
		 $(".status_sel").click(function(){
	        	var type = $(this).attr("key");
	         	$(":hidden[name=status]").val(type);
	         	$(".status_sel").removeClass("selected").addClass("noselected");
	         	$(this).removeClass("noselected").addClass("selected");
	     });
		 
		 $(".searchbtn").click(function(){
			 var viewtype = $(":hidden[name=viewtype]").val();
			 if(!viewtype){
				 $(".viewtype_sel").each(function(){
					if($(this).hasClass("selected")){
						 viewtype = $(this).attr("key"); 
						 $(":hidden[name=viewtype]").val(viewtype);
					 }
				 });
			 }
				var start = $('#start_date').val();
				var end = $('#end_date').val();
				if (end != null && end != "" && end!="0000-00-00" && start > end){
					alert('结束时间不能早于开始时间!');
					return;
				}
			 $("form[name=searchform]").submit();
		 });
		 
		 $(".workplan_sort").click(function(){
			 $(":hidden[name=orderString]").val($(this).attr("key"));
			 $("form[name=searchform]").find(":hidden[name=flag]").val('');
			 $("form[name=searchform]").submit();
		 });
		 
		 
		//责任人选择事件
		$("#addAssigner").click(function(){
				$(".workplanlist").addClass("modal");
				$("#site-nav").addClass("modal");
				$("#assigner-more").removeClass("modal");
				$(".workplan_menu").addClass("modal");
				$("#_org_div").addClass("modal");
				initSystemFriChar();
				initSystemData();
		});
		$(".assignerGoBak").click(function(){
				$(".workplanlist").removeClass("modal");
				$("#assigner-more").addClass("modal");
				$("#site-nav").removeClass("modal");
				$(".workplan_menu").removeClass("modal");
				$("#_org_div").removeClass("modal");
		});
		// 责任人 的 确定按钮
		$(".assignerbtn").click(function(){
				var assId=null; 
				var assName=null;
				var assigner = "";
				$("#addAssigner").empty();
				var i=0;
				var size = $(".assignerList > a.checked").size();
				$(".assignerList > a.checked").each(function(){
					i++;
					assId += $(this).find(":hidden[name=assId]").val()+",";
					assName = $(this).find(".assName").html()+",";
					assName = assName.replace("null","");
					if(i==size){
						assName = assName.substring(0,assName.lastIndexOf(","));
					}
					assigner += assName;
				});

				if(assId==""||null==assId){
								$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
				    	    	$(".myMsgBox").delay(2000).fadeOut();
					    	    return;
							}
				$("#addAssigner").val(assigner);
				assId = assId.replace("null","");
				assId = assId.substring(0,assId.lastIndexOf(","));
				$("input[name=assignerId]").val('');
				$("input[name=assignerId]").val(assId);
				$(".workplanlist").removeClass("modal");
				$("#assigner-more").addClass("modal");
				$("#site-nav").removeClass("modal");
				$(".assignerGoBak").trigger("click");
		});
		
		//隐藏个人账户
		$("._org_list_item").each(function(){
			if($(this).attr('key') == 'Default Organization'){
				$(this).remove();
			}
		});
	});
	
	function initDatePicker() {
		var opt = {
			datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
		};
		
		$('#start_date').val('${start_date}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		$('#end_date').val('${end_date}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
	
	function initForm(){
		var viewtype = "${viewtype}";
		var status = "${status}";
		var type = "${type}";
		if(''!='${showflag}'&& viewtype != 'myview'){
			$(".assigner_list_div").css("display","");
		}
		if(""!='${showflag}'){
			$(".viewtype_sel").each(function(){
				if($(this).attr("key") == viewtype){
					$(this).removeClass("noselected").addClass("selected");
				}else{
					$(this).removeClass("selected").addClass("noselected");
				}
			});
		}
		$(".type_sel").each(function(){
			if($(this).attr("key") == type){
				$(this).removeClass("noselected").addClass("selected");
			}else{
				$(this).removeClass("selected").addClass("noselected");
			}
		});
		$(".status_sel").each(function(){
			if($(this).attr("key") == status){
				$(this).removeClass("noselected").addClass("selected");
			}else{
				$(this).removeClass("selected").addClass("noselected");
			}
		});
		//重置按钮点击事件
		$(".resettingbtn").click(function(){
			$("form[name=searchform]").find("input").each(function(){
				var name = $(this).attr("name");
				if('flag'==name){
					return;
				}
				$(this).val('');
			});
			$(".viewtype_sel").removeClass("selected").addClass("noselected");
			$(".viewtype_sel").first().removeClass("noselected").addClass("selected");
			$(".type_sel").removeClass("selected").addClass("noselected");
			$(".type_sel:eq(2)").removeClass("noselected").addClass("selected");
			$(".status_sel").removeClass("selected").addClass("noselected");
			$(".status_sel:eq(2)").removeClass("noselected").addClass("selected");
			$(".assigner_list_div").css("display","none");
		});
	}
	
	function searchDataByOrgId(orgId){
		$("form[name=searchform]").find(":hidden[name=orgId]").val(orgId);
		$("form[name=searchform]").find(":hidden[name=flag]").val('');
		$("form[name=searchform]").submit();
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

.viewtype_sel{
	padding: 3px 5px;
}

.type_sel{
	padding: 3px 5px;
}

.status_sel{
	padding: 3px 5px;
}
</style>

</head>
<body>
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Workpalan" name="relaModule"/>
	</jsp:include>
	<div id="site-nav" class="workplan_menu zjwk_fg_nav_2" style="margin-bottom:0px;">
	    <a href="javascript:void(0)" onclick='$("#sort_div1").removeClass("modal");$(".sortshade").css("display","");' style="padding:5px 8px;">筛选</a>
	    <a href="javascript:void(0)" onclick='$("#sort_div3").removeClass("modal");$(".sortshade").css("display","");' style="padding:5px 8px;">排序</a>
	    <a href="<%=path %>/workplan/analytics" style="padding:5px 8px;">报表</a>
		<a href="javascript:void(0)" id="addbtn" onclick='add()' style="padding:5px 8px;">新增</a>
	</div>
	
	<div style="clear: both"></div>
	<div class="site-recommend-list page-patch workplanlist" style="font-size:14px;">
		<div style="clear:both;"></div>
		<form name="searchform" action="<%=path%>/workplan/list" method="post">
		<input type="hidden" name="viewtype" value="${viewtype}"/>
		<input type="hidden" name="type" value="${type}"/>
		<input type="hidden" name="status" value="${status }"/>
		<input type="hidden" name="flag" value="search"/>
		<input type="hidden" name="orderString" value="${orderString }"/>
		<input type="hidden" name="orgId" value="${orgId }"/>
		<!-- 筛选 -->
		<div id="sort_div1" class="modal _sort_div_" style="z-index:999;top:38px;font-size:14px;">
			<div style="line-height:35px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;float:left;">区间</div>
				<div style="padding-left: 50px;">
					<a class="viewtype_sel selected" href="javascript:void(0)" key="myview">我的</a>&nbsp;&nbsp;
					<a class="viewtype_sel noselected" href="javascript:void(0)" key="teamview">我下属的</a>&nbsp;&nbsp;
				</div>
			</div>
			<div style="clear:both;"></div>
			
			<div style="line-height:35px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;float:left;">类型</div>
				<div style="padding-left: 50px;">
					<a class="type_sel noselected" href="javascript:void(0)" key="day">日计划</a>&nbsp;&nbsp;
					<a class="type_sel noselected" href="javascript:void(0)" key="week">周计划</a>&nbsp;&nbsp;
					<a class="type_sel noselected" href="javascript:void(0)" key="">所有</a>&nbsp;&nbsp;
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;">时间</div>
				<div style="" class="free_time">
					<input name="start_date" id="start_date" placeholder="开始时间" value="" type="text" format="yy-mm-dd" readonly="readonly"
									class="form-control" style="width:45%;float:left"/>
					<div style="float:left;width:8%;line-height: 30px;text-align: center;"> — </div> 
					<input name="end_date" id="end_date"  placeholder="结束时间" value="" type="text" format="yy-mm-dd" readonly="readonly"
									class="form-control" style="width:45%;float:left;"/>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:35px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;float:left;">状态</div>
				<div style="padding-left: 50px;">
					<a class="status_sel noselected" href="javascript:void(0)" key="draft">新建</a>&nbsp;&nbsp;
					<a class="status_sel noselected" href="javascript:void(0)" key="audit">已评价</a>&nbsp;&nbsp;
					<a class="status_sel noselected" href="javascript:void(0)" key="">所有</a>&nbsp;&nbsp;
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="assigner_list_div" style="line-height:45px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;padding-bottom:10px;display:none;">
				<div style="color: #999; padding-left: 5px;float:left;">责任人</div>
				<div style="padding-left: 50px;">
					<input name="assignerId" id="assignerId" value="${assignerId}" type="hidden" readonly="readonly"> 
					<input name="addAssigner" id="addAssigner" value="${addAssigner}" type="text" readonly="readonly" style="width:80%;">
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="button-ctrl" style="text-align:center;">
				<a href="javascript:void(0)" class="btn resettingbtn" style="height: 2.0em;line-height: 2.0em;">重置</a>
				&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)"  class="btn searchbtn" style="height: 2.0em;line-height: 2.0em;">查询</a>
					<%--<fieldset class="">
						<div class="ui-block-a" style="width: 48%;padding: 20px 4em;">
							<a href="javascript:void(0)" class="btn btn-block resettingbtn"
								style="font-size: 16px;"> 重置</a>
						</div>
						<div class="ui-block-a" style="width: 48%;padding: 20px 4em;">
							<a href="javascript:void(0)" class="btn btn-block searchbtn"
								style="font-size: 16px;"> 查询</a>
						</div>
					</fieldset> --%>
			</div>
		
		</div>
		</form>
		<!-- 排序 -->
		<div id="sort_div3" class="modal _sort_div_" style="top:38px;">
			<a href="javascript:void(0)" class="workplan_sort" key="acdate">
				<div style="width:100%;border-bottom: 1px solid #FAFAFA;">&nbsp;按时间升序</div>
			</a>
			<a href="javascript:void(0)" class="workplan_sort" key="dcdate">
				<div style="width:100%;border-bottom: 1px solid #FAFAFA;">&nbsp;按时间倒序</div>
			</a>
			<a href="javascript:void(0)" class="workplan_sort" key="aname">
				<div style="width:100%;border-bottom: 1px solid #FAFAFA;">&nbsp;按责任人排序</div>
			</a>
		</div>
		<div class="shade sortshade" style="display:none;opacity:0.3;z-index:99;" onclick='$("._sort_div_").addClass("modal");$(".sortshade").css("display","none");'></div>
		<!-- 排序结束 -->
		<!-- 我的工作计划 -->
		
		<ul id="div_accnt_list" style="background-color: #fff;">
			<c:if test="${fn:length(myWorkPlanList) > 0 }">
				<div class="zjwk_fg_wrap">
				<div class="tmod titbox">
		           <h3>我的工作计划</h3>
		     	</div>
		     	</div>
			<c:forEach items="${myWorkPlanList}" var="workplan" varStatus="stat">
				<c:if test="${stat.index == 5}">
					<div id="more_div_praise" style="float: inherit;display: initial;line-height: 28px;"><a href="javascript:void(0)"
						onclick='$("#more_div_praise").css("display","none");$("#more_list_praise").css("display","initial");'>更多 ></a></div>
					<div id="more_list_praise" style="display: none;float: inherit;">
				</c:if>
				<!-- 序号大于5的情况 -->
				<c:if test="${stat.index >= 5 }">
					<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
						<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myview&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
							${workplan.title}
						</a>
						(
							<c:if test="${workplan.status eq 'draft'}">
								   	新建
								</c:if>
								<c:if test="${workplan.status eq 'share'}">
								   	已提交
								</c:if>
								<c:if test="${workplan.status eq 'audit'}">
								   	已评价
								</c:if>
								<c:if test="${workplan.status eq 'upd'}">
								   	修改
								</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
						 )
					</li>
				</c:if>
				<!-- 序号小于5的情况 -->
				<c:if test="${stat.index < 5 }">
					<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
						<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myview&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
							${workplan.title}
						</a>
						(
							<c:if test="${workplan.status eq 'draft'}">
								   	新建
								</c:if>
								<c:if test="${workplan.status eq 'share'}">
								   	已提交
								</c:if>
								<c:if test="${workplan.status eq 'audit'}">
								   	已评价
								</c:if>
								<c:if test="${workplan.status eq 'upd'}">
								   	修改
								</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
						 )
					</li>
				</c:if>
			</c:forEach>
			</ul>
			</c:if>
		<c:if test="${fn:length(myBranchWorkPlanList)>0 }">
		<!-- 我下属的工作计划 -->
		
		<ul id="div_accnt_list" style="background-color: #fff;">
			<c:if test="${showflag ne '' && viewtype eq 'teamview'}" > 
				<div class="zjwk_fg_wrap">
				<div class="tmod titbox">
		           <h3>我下属的工作计划</h3>
		     	</div>
		     	</div>
				<c:forEach items="${myBranchWorkPlanList}" var="workplan" varStatus="stat">
					<c:if test="${stat.index == 20}">
						<div id="more_div_praise11" style="float: inherit;display: initial;line-height: 28px;"><a href="javascript:void(0)"
							onclick='$("#more_div_praise11").css("display","none");$("#more_list_praise11").css("display","initial");'>更多 ></a></div>
						<div id="more_list_praise11" style="display: none;float: inherit;">
					</c:if>
					<!-- 序号大于5的情况 -->
					<c:if test="${stat.index >= 20 }">
						<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
							<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myBranch&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myBranchWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
								${workplan.title}
							</a>
							(
							    ${workplan.creator}&nbsp;&nbsp;
								<c:if test="${workplan.status eq 'draft'}">
									   	新建
									</c:if>
									<c:if test="${workplan.status eq 'share'}">
									   	已提交
									</c:if>
									<c:if test="${workplan.status eq 'audit'}">
									   	已评价
									</c:if>
									<c:if test="${workplan.status eq 'upd'}">
									   	修改
									</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
							 )
						</li>
					</c:if>
					<!-- 序号小于5的情况 -->
					<c:if test="${stat.index < 20 }">
						<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
							<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myBranch&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myBranchWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
								${workplan.title}
							</a>
							( ${workplan.creator}&nbsp;&nbsp;
								<c:if test="${workplan.status eq 'draft'}">
									   	新建
									</c:if>
									<c:if test="${workplan.status eq 'share'}">
									   	已提交
									</c:if>
									<c:if test="${workplan.status eq 'audit'}">
									   	已评价
									</c:if>
									<c:if test="${workplan.status eq 'upd'}">
									   	修改
									</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
							 )
						</li>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${showflag eq '' || empty(showflag)}" >
				<div class="zjwk_fg_wrap">
				<div class="tmod titbox">
		           <h3>我直接下属的工作计划</h3>
		     	</div>
		     	</div>
				<c:forEach items="${myBranchWorkPlanList}" var="workplan" varStatus="stat">
					<c:if test="${stat.index == 5}">
						<div id="more_div_praise1" style="float: inherit;display: initial;line-height: 28px;"><a href="javascript:void(0)"
							onclick='$("#more_div_praise1").css("display","none");$("#more_list_praise1").css("display","initial");'>更多 ></a></div>
						<div id="more_list_praise1" style="display: none;float: inherit;">
					</c:if>
					<!-- 序号大于5的情况 -->
					<c:if test="${stat.index >= 5 }">
						<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
							<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myBranch&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myBranchWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
								${workplan.title}
							</a>
							(
							    ${workplan.creator}&nbsp;&nbsp;
								<c:if test="${workplan.status eq 'draft'}">
									   	新建
									</c:if>
									<c:if test="${workplan.status eq 'share'}">
									   	已提交
									</c:if>
									<c:if test="${workplan.status eq 'audit'}">
									   	已评价
									</c:if>
									<c:if test="${workplan.status eq 'upd'}">
									   	修改
									</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
							 )
						</li>
					</c:if>
					<!-- 序号小于5的情况 -->
					<c:if test="${stat.index < 5 }">
						<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
							<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=myBranch&flag=${showflag}&index=${stat.index}&planLength=${fn:length(myBranchWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
								${workplan.title}
							</a>
							( ${workplan.creator}&nbsp;&nbsp;
								<c:if test="${workplan.status eq 'draft'}">
									   	新建
									</c:if>
									<c:if test="${workplan.status eq 'share'}">
									   	已提交
									</c:if>
									<c:if test="${workplan.status eq 'audit'}">
									   	已评价
									</c:if>
									<c:if test="${workplan.status eq 'upd'}">
									   	修改
									</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
							 )
						</li>
					</c:if>
				</c:forEach>
				</c:if>
			</ul>
		</c:if>
		<c:if test="${fn:length(shareWorkPlanList)>0}">
		<!-- 分享给我的工作计划 -->
		
		<ul id="div_accnt_list" style="background-color: #fff;">
			<div class="zjwk_fg_wrap">
			<div class="tmod titbox">
	           <h3>分享给我的工作计划</h3>
	     	</div>
	     	</div>
			<c:forEach items="${shareWorkPlanList}" var="workplan" varStatus="stat">
				<c:if test="${stat.index == 5}">
					<div id="more_div_praise2" style="float: inherit;display: initial;line-height: 28px;"><a href="javascript:void(0)"
						onclick='$("#more_div_praise2").css("display","none");$("#more_list_praise2").css("display","initial");'>更多 ></a></div>
					<div id="more_list_praise2" style="display: none;float: inherit;">
				</c:if>
				<!-- 序号大于5的情况 -->
				<c:if test="${stat.index >= 5 }">
					<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
						<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=share&flag=${showflag}&index=${stat.index}&planLength=${fn:length(shareWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
							${workplan.title}
						</a>
						( ${workplan.creator}&nbsp;&nbsp;
							<c:if test="${workplan.status eq 'draft'}">
								   	新建
								</c:if>
								<c:if test="${workplan.status eq 'share'}">
								   	已提交
								</c:if>
								<c:if test="${workplan.status eq 'audit'}">
								   	已评价
								</c:if>
								<c:if test="${workplan.status eq 'upd'}">
								   	修改
								</c:if><span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
						 )
					</li>
				</c:if>
				<!-- 序号小于5的情况 -->
				<c:if test="${stat.index < 5 }">
					<li style="line-height:28px;border-bottom: 1px solid #eee;padding:3px 10px;">
						<a href="<%=path%>/workplan/detail?rowId=${workplan.id}&viewtype=share&flag=${showflag}&index=${stat.index}&planLength=${fn:length(shareWorkPlanList)}" class="list-group-item listview-item" style="margin:0px 0px 5px 0px;">
							${workplan.title}
						</a>
						( ${workplan.creator}&nbsp;&nbsp;
							<c:if test="${workplan.status eq 'draft'}">
								   	新建
								</c:if>
								<c:if test="${workplan.status eq 'share'}">
								   	已提交
								</c:if>
								<c:if test="${workplan.status eq 'audit'}">
								   	已评价
								</c:if>
								<c:if test="${workplan.status eq 'upd'}">
								   	修改
								</c:if>
								<span class="commensspan" id="${workplan.id}" style="display:none;">&nbsp;</span>
						 )
					</li>
				</c:if>
			</c:forEach>
		</ul>
		</c:if>
		<c:if test="${fn:length(myWorkPlanList) == 0 && fn:length(myBranchWorkPlanList) == 0 && fn:length(shareWorkPlanList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
		</c:if>
	</div>
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	</br></br></br></br>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>