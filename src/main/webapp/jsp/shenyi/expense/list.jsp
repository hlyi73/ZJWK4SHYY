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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<style type="text/css">
.none
{
	display:none;
}
</style>
<script type="text/javascript">
	$(function () {
		initForm();
		//initAproveBtn();//初始化批量审批
		//disApproBtn();//控制审批按钮
		//initWeixinFunc();
		
	});
	
	/* //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	
	function topage(){
		$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/expense/expenselist' || '',
		      //async: false,
		      data: {type:'${subtype}',exAssigner:'${exAssigner}',viewtype:'${viewtype}',currpage:currpage,pagecount:'10',publicId:'${publicId}',openId:'${openId}',depart:'${depart}',expensedate:'${expensedate}',approval:'${approval}',startDate:'${startDate}',endDate:'${endDate}',orderString:'${orderString}'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_expense_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d == ""||""==d.rowCount){
		    	    	$("#div_next").css("display",'none');
		    	    }else{
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							var status = this.expensestatusname;
							var statusimg = "";
							if(status == "新建"){
								statusimg = '<img src="<%=path %>/image/expense_status_new.png" border=0 width="30px">';
							}else if(status == "待审批"){
								statusimg = '<img src="<%=path %>/image/expense_status_wait.png" border=0 width="30px">';
							}else if(status == "已批准"){
								statusimg = '<img src="<%=path %>/image/expense_status_ok.png" border=0 width="30px">';
							}else if(status == "驳回"){
								statusimg = '<img src="<%=path %>/image/expense_status_ng.png" border=0 width="30px">';
							}else{
								statusimg = '<img src="<%=path %>/image/expense_status_null.png" border=0 width="30px">';
							}
							var typeimg = "";
							if(this.parentid != "" && this.parenttype == "Accounts"){
								typeimg = '<img src="<%=path%>/image/acounts.png" width="20px" border=0>';
							}else if(this.parentid != "" && this.parenttype == "Opportunities"){
								typeimg = '<img src="<%=path%>/image/opptys.png" width="20px" border=0>';
							}else if(this.parentid != "" && this.parenttype == "Tasks"){
								typeimg = '<img src="<%=path%>/image/tasks.png" width="20px" border=0>';
							}
							val += '<a href="<%=path%>/expense/detail?rowId='+this.rowid+'&orgId='+this.orgId+'" class="list-group-item listview-item">'
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon" style="background-color:#ffffff;width:30px;height:30px;"> '
								+ statusimg +'</div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">报销日期：'+this.expensedate+'&nbsp;&nbsp;金额：￥'+this.expenseamount+'</p> '
								+ '<p class="text-default">'+typeimg+this.parentname+'</p>'
								+ '</div></div> '
								+ '<div class="list-group-item-fd detailAprDiv"><span class="icon icon-uniE603"></span></div>'
								+ '<div class="input-radio none sglAprHref" style="display:none" title="选择该条记录" ></div>'
								+ '</a>';
						});
		    	    }
					$("#div_expense_list").html(val);
					
					$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
		      }
		 });
		//初始化分页审批显示
		//disTopageView();
		//initAproveBtn();
	}
	
	//报销查询
	function searchExpense(){
		if(!$("#div_search_content4").hasClass("modal")){
			$("#div_search_content4").addClass("modal");
			$("#div_expense_list").removeClass("modal");
			//$("#div_next").removeClass("modal");
			return;
		}
		
		$("#div_search_content4").removeClass("modal");
		$("#div_expense_list").addClass("modal");
		var viewtype = $("input[name=viewtype]").val();
		if("teamview"==viewtype){
			$("#search_div3").css("display","");
		}
	}
	
	function displayDiv(){
		if($("#analytics").hasClass("modal")){
			$("#analytics").removeClass("modal");
		}else{
			$("#analytics").addClass("modal");
		}
		$("#div_search_content4").addClass("modal");
		$("#div_expense_list").removeClass("modal");
		//$("#div_next").removeClass("modal");
	}
	
	//取消报销查询
	function closeSearch(){
		$("#div_search_content4").removeClass("modal");
		$("#assigner-more").addClass("modal");
		$("#site-nav").removeClass("modal");
		$("#div_search_content2").removeClass("modal");
		$("#div_expense_list").removeClass("modal");
	}
	
	//初始化表单按钮和控件
	function initForm(){
		//责任人选择事件
		$(".assignerChoose").click(function(){
			//$("#div_search_content2").addClass("modal");
			//$("#site-nav").addClass("modal");
			$("#assigner-more").removeClass("modal");
			$("#div_search_content4").addClass("modal");
		});
		$(".assignerGoBak").click(function(){
			//$("#div_search_content2").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#div_search_content4").removeClass("modal");
			//$("#site-nav").addClass("modal");
			});
		// 责任人 的 确定按钮
		$(".assignerbtn").click(function(){
			var assId=null; 
			var assName=null;
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
				$("#addAssigner").append("<span>"+assName+"</span>");
			});
			if(assId==""||null==assId){
				$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
			assId = assId.replace("null","");
			assId = assId.substring(0,assId.lastIndexOf(","));
			$("input[name=assignerId]").val(assId);
			$("#div_search_content").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav").removeClass("modal");
			$("#div_search_content2").removeClass("modal");
			$(".assignerGoBak").trigger("click");
		});
		
		//查看详情
		$(".detailAprDiv").click(function(){
			window.location.href = $(this).parent().attr("href");
		});
		
		//下拉框初始化
		var selObj = $("select[name=viewtypesel]");
		selObj.change(function(){
			var val = selObj.val();
			if(val == "myview_approval"){
				$("input[name=approval]").val('approving');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_new"){
				$("input[name=approval]").val('new');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_approved"){
				$("input[name=approval]").val('approved');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_certified"){
				$("input[name=approval]").val('certified');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_reject"){
				$("input[name=approval]").val('reject');
				$("input[name=viewtype]").val('myview');
			}else if(val == "approvalview"){
				$("input[name=approval]").val('');
				$("input[name=viewtype]").val('approvalview');
			}else if(val == "teamview"){
				$("input[name=approval]").val('');
				$("input[name=viewtype]").val('teamview');
			}else if(val == "teamview_approved"){
				$("input[name=approval]").val('approved');
				$("input[name=viewtype]").val('teamview');
			}
			//$("input[name=approval]").val(selObj.getAttribute("lang"));
			$("form[name=viewtypeForm]").submit();
			return false ;
		});
		//获取类型值
		selObj.val('${viewtypesel}');
		$(".viewtypelabel").html(selObj.find("option:selected").text());
	}

	function disTopageView(){
		var cssval = $(".batchAprHref").css("display");
		if(cssval !== 'none'){//审批状态
			batchApr();
		}
	}
	
	//批量审批
	function batchApr(){
			$(".batchAprDiv").css("display",'none');
			$(".detailAprDiv").css("display",'none');
			$(".calBatchAprDiv").css("display",'');
			$(".batchAprHref").css("display",'');
			$(".sglAprHref").css("display",'');
			$(".approveTip").html('');
	}
	//取消批量审批
	function calBatchApr(){
		$(".batchAprDiv").css("display",'');
		$(".detailAprDiv").css("display",'');
		$(".calBatchAprDiv").css("display",'none');
		$(".batchAprHref").css("display",'none');
		$(".sglAprHref").css("display",'none');
		$("#div_expense_list a").removeClass("checked");
		//取消提交到下一审批人
		//提交到下一个审批人
		$(".userList").css('display', 'none');
		$(".expenseList").css("display", "");
    	$("#site-nav .select").css("display", "");
    	$("#site-nav h3").html("");
    	$(".approveTip").html('');
	}
	
	function disApproBtn(){
		if($("#viewtype").val() === "approvalview" && "${fn:length(expenseList)}" != 0 ){
			$(".batchAprDiv").css("display","");	
		}else{
			$(".batchAprDiv").css("display","none");
		}
	}
	
	//初始化全选和不全选按钮
	function initAproveBtn(){
		//勾选某个 业务机会  的超链接
		$("#div_expense_list > a").unbind("click").bind("click", function(){
			var cssval = $(".batchAprHref").css("display");
			if(cssval !== 'none'){//审批状态
				var i = $(this).index();
				if(i !== 0){
					if($(this).hasClass("checked")){
						$(this).removeClass("checked");
					}else{
						$(this).addClass("checked");
					}
				}
			}else{//非审批状态
				window.location.href = $(this).attr("href");
			}
			
			return false;
		});
		$(".checkAllBtn").unbind("click").bind("click", function(){
			if($(this).parent().hasClass("checked")){
				$(this).parent().removeClass("checked");
				$("#div_expense_list a").removeClass("checked");
			}else{
				$(this).parent().addClass("checked");
				$("#div_expense_list a").addClass("checked");
			}
			return false;
		});
		//同意
		$(".approveOkDiv").unbind("click").bind("click", function(){
			var rowIds = getRowIds();
			if(!rowIds){
				$(".approveTip").html('请选择记录！');
				return false;
			}else{
				$(".approveTip").html('');
			}
			
			//审批字段
	    	$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=approvalstatus]").val('approved');
			
			//提交到下一个审批人
			$(".userList").css('display', '');
			$(".expenseList").css("display", "none");
	    	$("#site-nav .select").css("display", "none");
	    	$("#site-nav h3").html("请选择下一个审批人");
	    	
	    	initUsersCheck();
		 });
		//不同意
		$(".approveNoDiv").unbind("click").bind("click", function(){
			var rowIds = getRowIds();
			if(!rowIds){
				$(".approveTip").html('请选择记录！');
				return false;
			}else{
				$(".approveTip").html('');
			}
			//审批字段
	    	$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=approvalstatus]").val('reject');
			//提交
	    	$("form[name=batchApprForm]").submit();
		});
	}
	
	//获取rowids
	function getRowIds(){
		var rowids = '';
		var assIds= '';
		$("#div_expense_list a.checked").each(function(i){
			rowids += $(this).find(":hidden[name=sglRowId]").val() + ',';
			assIds += $(this).find(":hidden[name=sglAssId]").val() + ',';
		});
		$(":hidden[name=recordid]").val(rowids);
		$(":hidden[name=assignid]").val(assIds);
		return rowids;
	}
	
	function initUsersCheck(){
    	//勾选某个 业务机会  的超链接
		$("#div_user_list > a").click(function(){
			$("#div_user_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var userId = $(this).find(":hidden[name=userId]").val();
				var userName = $(this).find(":hidden[name=userName]").val();
				var email = $(this).find(":hidden[name=email]").val();
				$(":hidden[name=approvalid]").val(userId);
				$(":hidden[name=approvalname]").val(userName);
				$(":hidden[name=approvaemail]").val(email);
			}
			return false;
		});
    }
	
	//提交到下一个审批人
    function approNextExam(){
    	var uid = $(":hidden[name=approvalid]").val();
    	if(!uid){
    		$(".nextApproveDivTip").css("display","");	
    		return;
    	}else{
    		$(".nextApproveDivTip").css("display","none");	
    	}
    	//提交
    	$("form[name=batchApprForm]").submit();
    }
    
    //结算审批
    function approEndExam(){
    	//赋值
    	$(":hidden[name=approvalid]").val('');
    	$(":hidden[name=approvalname]").val('');
    	//提交
    	$("form[name=batchApprForm]").submit();
    }

	//提交报销查询
	function searchList(){
		var subtypeId = $("input[name=subtype]").val();
		var assId = $("input[name=assignerId]").val();
/* 		var view = $("input[name=viewtype1]").val();
		var status = $("input[name=approval1]").val(); */
		$("input[name=expensedate]").val($("input[name=month]").val());
		$("input[name=subtype]").val(subtypeId);
		$("input[name=exAssigner]").val(assId);
		
		$("form[name=alistForm]").submit();
	}	

	function add(){
		window.location.href="<%=path%>/operorg/list?source=Expense&redirectUrl=" + encodeURIComponent('/expense/get?parentId=${parentId}&parentType=${patentType}&parentName=${parentName}');
	}
	//选择orgId
	function searchDataByOrgId(orgId)
	{
		window.location.replace("<%=path%>/expense/list?type=${subtype}&exAssigner=${exAssigner}&depart=${depart}&expensedate=${expensedate}&approval=${approval}&startDate=${startDate}&endDate=${endDate}&viewtype=${viewtype}&orgId=" + orgId);
	}
    </script>
</head>
<body>
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Workpalan" name="relaModule"/>
	</jsp:include>
	
	<div id="site-nav" class="zjwk_fg_nav_2">
	    <a href="javascript:void(0)" onclick='searchExpense()' style="padding:5px 8px; ">筛选</a>
	    <a href="javascript:void(0)" onclick='$("#sort_div").removeClass("modal");$(".sortshade").css("display","");' style="padding:5px 8px;">排序</a>
	    <a href="javascript:void(0)" onclick='add()' style="padding:5px 8px;">创建</a>
	</div>

	<div id="site-nav" class="navbar none">
		<jsp:include page="/common/back.jsp"></jsp:include>
	    <c:if test="${viewtype ne 'analyticsview' }">
		<div class="batchAprDiv flooter" onclick="batchApr();" style="display:none;cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;">
			<img src="<%=path %>/image/top.png" border=0 width="30px">
		</div>
		<div class="calBatchAprDiv flooter" onclick="calBatchApr();" style="display:none;cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;margin-bottom:45px;">
			<img src="<%=path %>/image/bottom.png" border=0 width="30px">
		</div>	
		</c:if>
		<div class="act-secondary">
			<a href="javascript:void(0)" onclick="add()" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<input type="hidden" name="currpage" value="1" />
		<a href="javascript:void(0)" class="list-group-item listview-item">
		  <form name="viewtypeForm" action="<%=path%>/expense/list" method="post">
		  	<input type="hidden" name="approval" id="approval" value="" />
		  	<input type="hidden" name="viewtype" id="viewtype" value="${viewtype }" />
			<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
				<p>
					<div class="form-control select _viewtype_select">
						<c:if test="${viewtype eq 'analyticsview' }">
							<span style="color:white">费用报销列表</span>
						</c:if>
						<c:if test="${viewtype ne 'analyticsview' }">
								<div class="select-box viewtypelabel">我的待审批报销</div>
									<select name="viewtypesel" id="viewtypesel" style="display:none;">
										<option value="myview_approval" lang="approval">我的待审批报销</option>
										<option value="myview_new" lang="new">待提交的报销列表</option>
										<option value="myview_approved" lang="approved">我的已批准报销列表</option>
										<option value="myview_certified" lang="certified">我的已核销报销列表</option>
										<option value="myview_reject" lang="reject">驳回的报销列表</option>
										<option value="approvalview" lang="">提交给我审批的报销</option>
										<option value="teamview" lang="">我团队的报销列表</option>
										<option value="teamview_approved" lang="">待核销的报销列表</option>
									</select>
						</c:if>
					</div>
					<h3 style="color:white"></h3>
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
				$("#_viewtype_menu").animate({height : 225}, [ 10000 ]);
				$(".site-recommend-list").css("display","none");
			}else{
				$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
				$("#_viewtype_menu").css("display","none");
				$(".site-recommend-list").css("display","");
			}
		}
		</script>
		<div class="_viewtype_menu_class none" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approval&approval=approving">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的待审批报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;驳回的报销
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_new&approval=new">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的待提交的报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approved&approval=approved">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的已批准报销
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/expense/list?viewtype=approvalview&viewtypesel=approvalview">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;需我审批的报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=teamview&viewtypesel=teamview">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我团队报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_certified&approval=certified">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的已核销报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=teamview&viewtypesel=teamview_approved&approval=approved">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;待核销的报销
				</div>
			</a>
			<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
			<a href="<%=path%>/analytics/expense/type">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;费用用途分析
				</div>
			</a>
			<a href="<%=path%>/analytics/expense/subtype">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;费用类型占比分析
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/analytics/expense/depart">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;部门费用分析
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
		<div style="clear:both"></div>
		<div id="div_search_content2" class="site-recommend-list page-patch expenseList">
			<!-- 导航 -->
			<%-- <c:if test="${viewtype ne 'analyticsview' }">
				<div style="width:100%;text-align:center;background-color: #fff;height: 40px;line-height: 40px;border-bottom:1px solid #DBD9D9;">
					<div style="float:left;width:50%;border-right: 1px solid #eee;">
						<a href="javascript:void(0)" onclick="searchExpense();">
							<div style="width:100%;">筛选<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
					<div style="float:left;width:33.33333%;border-right: 1px solid #eee;">
						<a href="javascript:void(0)" onclick='displayDiv()'>
							<div style="width:100%;">报表<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
					
					<div style="float:left;width:50%">
						<a href="javascript:void(0)" onclick='$("#sort_div").removeClass("modal");$(".sortshade").css("display","");'>
							<div style="width:100%;">排序<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
				</div>
				<div style="clear:both;"></div>
			</c:if> --%>
			
			<!-- 查询 -->
			<form name="alistForm" method="post" action="<%=path%>/expense/list">
					<input type="hidden" name="type"  value=""/>
					<input type="hidden" name="subtype"  value=""/>
					<input type="hidden" name="month"  value=""/>
					<input type="hidden" name="exAssigner"  value=""/>
					<input type="hidden" name="expensedate"  value=""/>
					<input type="hidden" name="orgId"  value="${orgId }"/>
					<input type="hidden" id="viewtype1" name="viewtype1"  value="${viewtype }"/>
					<input type="hidden" id="viewtypesel1" name="viewtypesel1"  value="${viewtypesel}"/>
					<input type="hidden" name="approval1" id="approval1" value="${approval}" />
			</form>
			<div id="div_search_content4" class="site-card-view modal" style="width:100%;padding-bottom:10px;z-index:999;background:#fff;">
				<div style="width:100%;">
					<div id="search_div0" class="search_div" >
					    <div style="float:left;padding-top:4px;">查询区间：</div>
					    <div style="line-height:25px;padding-left:78px">
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myview')">我的报销</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'teamview')">我下属的报销</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myallview')">所有报销</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'approvalview')">需我审批</a></li>																		
						</div>
					</div>
					<div style="clear:both;"></div>
					<div id="search_div1" class="search_div" >
					    <div style="float:left;padding-top:4px;">报销状态：</div>
					    <div style="line-height:25px;padding-left:78px">
							<li><a href="javascript:void(0)"
									onclick="selectStatus(this,'approving')">待审批</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectStatus(this,'reject')">已驳回</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectStatus(this,'new')">待提交</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectStatus(this,'approved')">已批准</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectStatus(this,'certified')">已核销</a></li>	
						</div>
					</div>
					<div style="clear:both;"></div>
					<script>
						function selectSubType(obj,subtype){
							var search_div=$("#search_div");
							search_div.find("a").each(function(index){
								search_div.find("a").removeClass("selected");
						    });
							obj.className = "selected";
							$("input[name=subtype]").val(subtype);
						}
						function selectMonth(obj,month){
							var search_div=$("#search_div2");
							search_div.find("a").each(function(index){
								search_div.find("a").removeClass("selected");
						    });
							obj.className = "selected";
							$("input[name=month]").val(month);
						}
						function selectViewType(obj,viewtype)
						{
							var search_div=$("#search_div0");
							search_div.find("a").each(function(index){
								search_div.find("a").removeClass("selected");
						    });
							obj.className = "selected";
							$("input[name=viewtype1]").val(viewtype);
						}
						function selectStatus(obj,status)
						{
							var search_div=$("#search_div1");
							search_div.find("a").each(function(index){
								search_div.find("a").removeClass("selected");
						    });
							obj.className = "selected";
							$("input[name=approval1]").val(status);
						}
					</script>
					<div id="search_div" class="search_div" >
					    <div style="float:left;padding-top:4px;">费用类型：</div>
					    <div style="line-height:25px;padding-left:78px">
							<c:forEach items="${expenseSubTypeList}" var="expenseSubTypeItem">
								<li><a href="javascript:void(0)" onclick="selectSubType(this,'${expenseSubTypeItem.key}')">${expenseSubTypeItem.value}</a></li>
							</c:forEach>
						</div>
					</div>
					<div style="clear:both;"></div>
					<div id="search_div3" class="search_div" style="display:none;">
					    <div style="float:left;margin-top:3px;">责&nbsp;任&nbsp;人:&nbsp;</div>
					    <div>
					    	<input name="assignerId" id="assignerId" value="" type="hidden" class="form-control" >
							<span style="margin-left:10px;" id="addAssigner">
								
							</span>
							<img src="<%=path%>/image/addusers.png" width="30px" border="0"name="assignerName" id="assignerName" class="assignerChoose" style="margin-left:15px;" />
						</div>
					</div>
					<div id="search_div2" class="search_div" >
					    <div style="float:left">报销月份：</div>
					    <div>
					    	<li><a href="javascript:void(0)" onclick="selectMonth(this,'current')">当月报销</a></li>
							<li><a href="javascript:void(0)" onclick="selectMonth(this,'before')">上月报销</a></li>
						</div>
					</div>
					<div style="clear:both;"></div>
				</div>
				<div class="wrapper" style="margin-top:8%;">
						<div class="button-ctrl">
							<fieldset class="">
								<div class="">
									<a href="javascript:void(0)"  class="btn btn-success btn-block" style="background-color:#49af53;margin:0px 20px 0px 20px;"
										style="font-size: 14px;" onclick="searchList()"> 查 询 </a>
								</div>
							</fieldset>
					</div>
				</div>
			</div>
			<!-- 查询End -->
			
			<!-- 排序 -->
			<div id="sort_div" class="modal" style="position:absolute;width:125px;font-size:14px;right:0;top:89px;z-index:99999;background-color: #fff;line-height: 35px;border:1px solid #ddd;padding:5px;">
				<a href="<%=path%>/expense/list?type=${subtype}&exAssigner=${exAssigner}&depart=${depart}&expensedate=${expensedate}&approval=${approval}&startDate=${startDate}&endDate=${endDate}&viewtype=${viewtype}&orderString=dedate">
					<div style="width:100%;border-bottom:1px solid #efefef;">&nbsp;按报销时间倒序</div>
				</a>
				<a href="<%=path%>/expense/list?type=${subtype}&exAssigner=${exAssigner}&depart=${depart}&expensedate=${expensedate}&approval=${approval}&startDate=${startDate}&endDate=${endDate}&viewtype=${viewtype}&orderString=aedate">
					<div style="width:100%;">&nbsp;按报销时间升序</div>
				</a>
			</div>
			<div class="shade sortshade" style="display:none;opacity:0.3;" onclick='$("#sort_div").addClass("modal");$(".sortshade").css("display","none");'></div>
			<!-- 排序结束 -->
						
			<div id="div_expense_list" class="list-group listview">
			    <a href="javascript:void(0)" class="list-group-item listview-item  radio batchAprHref flooter" style="display:none;padding:.3em;padding-bottom: .3em;">
			    	<form name="batchApprForm" method="post" action="<%=path%>/expense/batchApproval">
			    		<!-- 审批字段 -->
						<input type="hidden" name="crmId" value="${crmId}" ><!-- crmID -->
						<input type="hidden" name="recordid" value="" ><!-- 提交人ID -->
						<input type="hidden" name="type" value="batchapproval" ><!-- 批量报销 -->
						<input type="hidden" name="commitid" value="" ><!-- 提交人ID -->
						<input type="hidden" name="commitname" value="" ><!-- 提交人名字 -->
						<input type="hidden" name="approvalid" value="" ><!-- 提交给谁 -->
						<input type="hidden" name="approvalname" value="" ><!-- 提交给谁的名字 -->
						<input type="hidden" name="approvalstatus" value="" ><!-- 提交的状态 new approving待审批 approved已批准 reject驳回-->
						<input type="hidden" name="approvaldesc" value="" ><!-- 审批的意见 -->
						<input type="hidden" name="approvaemail" value="" ><!-- 责任人邮箱-->
						<input type="hidden" name="assignid" value="">
			    	</form>
			        <div class="list-group-item-bd ">
							<div class="thumb list-icon approveOkDiv" style="background-color:#ffffff;width:20px;height:10px;">
							 	<!-- <img src="<%=path %>/scripts/plugin/wb/css/images/approveOk.png" border="0" width="30px" title="审批通过"
							 	 style="background-color:#ffffff;"> -->
							 	 <input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;background-color:green" value="同意">
							</div>
							<div class="thumb list-icon approveNoDiv" style="background-color:#ffffff;width:20px;height:10px;margin-left:10px;">
							 	<!-- <img src="<%=path %>/scripts/plugin/wb/css/images/approveNo.png" border="0" width="30px" title="审批不通过"
							 	 style="background-color:#ffffff;"> -->
							 	<input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;background-color: orange;" value="驳回">
							</div>
							
					</div>	
					<div class="approveTip" style="color:red;margin-right:10px"></div>
					<div class="input-radio checkAllBtn" title="全选"></div>
				</a>
				<c:forEach items="${expenseList}" var="exp">
					<a href="<%=path%>/expense/detail?rowId=${exp.rowid}&orgId=${exp.orgId}"
						class="list-group-item listview-item ">
						<input type="hidden" name="sglRowId" value="${exp.rowid}" ><!-- rowID -->
						<input type="hidden" name="sglAssId" value="${exp.assignid}" ><!-- rowID -->
						<div class="list-group-item-bd">
							 <div class="thumb list-icon" style="background-color:#ffffff;width:30px;height:30px;">${exp.expensestatusname}
							 	<c:if test="${exp.expensestatusname eq '待审批'}">
									<img src="<%=path %>/image/expense_status_wait.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname eq '新建'}">
									<img src="<%=path %>/image/expense_status_new.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname eq '已批准'}">
									<img src="<%=path %>/image/expense_status_ok.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname eq '核销通过'}">
									<img src="<%=path %>/image/expense_status_ok.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname eq '核销不通过'}">
									<img src="<%=path %>/image/expense_status_ng.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname eq '驳回'}">
									<img src="<%=path %>/image/expense_status_ng.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
								<c:if test="${exp.expensestatusname ne '驳回' && exp.expensestatusname ne '已批准' && exp.expensestatusname ne '核销通过' && exp.expensestatusname ne '核销不通过' && exp.expensestatusname ne '新建' && exp.expensestatusname ne '待审批'}">
									<img src="<%=path %>/image/expense_status_null.png" border=0 width="30px" style="background-color:#ffffff;">
								</c:if>
							</div>
							<div class="content" style="text-align: left">
								<h1>报销${exp.expensesubtypename}${exp.expenseamount}&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${exp.assigner }</span></h1>
								<p class="text-default">${exp.expensedate}&nbsp;报销&nbsp;${exp.expensesubtypename}&nbsp;￥${exp.expenseamount}</p>
								<p class="text-default">
									<c:if test="${exp.parentid !=null && exp.parenttype eq 'Accounts'}">
										<img src="<%=path%>/image/acounts.png" width="20px" border=0>${exp.parentname}
									</c:if>
									<c:if test="${exp.parentid !=null && exp.parenttype eq 'Opportunities'}">
										<img src="<%=path%>/image/opptys.png" width="20px" border=0>${exp.parentname}
									</c:if>
									<c:if test="${exp.parentid !=null && exp.parenttype eq 'Tasks'}">
										<img src="<%=path%>/image/tasks.png" width="20px" border=0>${exp.parentname}
									</c:if>
									<c:if test="${exp.parentid !=null && exp.parenttype eq 'Project'}">
										<img src="<%=path%>/image/tasks.png" width="20px" border=0>${exp.parentname}
									</c:if>
								</p>
							</div>
						</div>
						<div class="list-group-item-fd detailAprDiv" >
							<span class="icon icon-uniE603"></span>
						</div>
						<div class="input-radio none sglAprHref" style="display:none" title="选择该条记录"></div>
					</a>
				</c:forEach>
				
				<c:if test="${fn:length(expenseList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
			</div>
			<c:if test="${fn:length(expenseList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path %>/image/nextpage.png" width="24px"/>
				</a>
			</div>
			</c:if>
		</div>	
		
		<!-- 责任人列表DIV -->
		<jsp:include page="/common/systemuser.jsp"></jsp:include>
		<!-- 用户列表 -->
		<div class=" userList" style="display: none">
			<div class="list-group listview listview-header" id="div_user_list">
				<c:forEach items="${usersList}" var="uitem">
						<a href="javascript:void(0)" class="list-group-item listview-item radio">
							<div class="list-group-item-bd">
								<input type="hidden" name="userId" value="${uitem.userid}"/>
								<input type="hidden" name="userName" value="${uitem.username}"/>
								<input type="hidden" name="email" value="${uitem.email}"/>
								<h2 class="title assName">${uitem.username}</h2>
								<p>职称：${uitem.title}</p>
								<p>
									部门：<b>${uitem.department}</b>
								</p>
							</div>
							<div class="input-radio" title="选择该条记录"></div>
						</a>
				</c:forEach>
			</div>
			<div class="flooter">
				<div class="button-ctrl" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 1px;">
					<fieldset class="">
						<div class="ui-block-a" style="width:50%;padding-bottom: 4px;">
							<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;" onclick="approNextExam()">提交下一审批人</a>
						</div>
						<div class="ui-block-a" style="width:50%;padding-bottom: 4px;">
							<a href="javascript:void(0)" class="btn btn-success btn-block"
										style="font-size: 14px;" onclick="approEndExam()">审批完成</a>
						</div>
					</fieldset>
				</div>
			</div>
			<div class="wrapper nextApproveDivTip " style="display:none">
				<div class="button-ctrl">
					<div style="margin-top: 0.5em">
						<p class="alert text-center alert-warning" style="color:red">请选择下一个审批人</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>