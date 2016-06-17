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
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
    $(function () {
    	//initWeixinFunc();
    	initForm();
	});
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
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
		      url: '<%=path%>/weekreport/asylist' || '',
		      //async: false,
		      data: {viewype:'${viewtype}',countweek:'${countweek}',currpage:currpage,openId:'${openId}',publicId:'${publicId}',assignerid:'${assignerid}',pagecount:'10'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_oppty_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_oppty_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							var week = this.key.substring(0,4)+"年第"+this.key.substring(4,6)+"周";
							var content = '';
							var report = JSON.parse(this.val);
							if(!report||$(report).size()==0){
								if('${viewtype}'== 'myview'){
									content += '<div style="text-align: center; font-size: 16px;">本周还没有提交周报哦！<a href="<%=path%>/weekreport/get?openId=${openId}&publicId=${publicId}">现在填写？</a></div>';
								}else{
									content +='<div style="text-align: center; font-size: 16px;">本周还没有人提交周报哦！</div>';
								}
							}
							$(report).each(function(){
								if('${viewtype}'== 'myview'){
									content += '<p><a href="<%=path%>/weekreport/detail?rowId='+this.rowid+'&openId=${openId}&publicId=${publicId}">'
											+ this.reporttypename+'</a></p>';
								}else{
									content += '<p><a href="<%=path%>/weekreport/detail?viewtype=myview&assignerid='+this.assignerid+'&countweek='+this.countweek+'&openId=${openId}&publicId=${publicId}">'
									+ this.reporttypename+'</a></p>';
								}
							});
							
							val += '<div class="list-group-item listview-item" style="display:flex;cursor: default;">'+week+'</div>'
								+  '<div class="list-group-item listview-item" style="margin-top:0px;">'
								+  '<div class="list-group-item-bd" style="margin-left: 10px;line-height: 30px;">'
								+ content+'</div></div>';
							});
						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_oppty_list").html(val);
						
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
					}
				});
	}
    
  //初始化表单按钮和控件
	function initForm(){
		//下拉框初始化
		var selObj = $("select[name=viewtypesel]");
		selObj.change(function(){
			$("form[name=viewtypeForm]").submit();
			return false ;
		});
		//获取类型值
		selObj.val('${viewtypesel}');
		$(".viewtypelabel").html(selObj.find("option:selected").text());
	}
    
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a href="<%=path%>/weekreport/get?openId=${openId}&publicId=${publicId}" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<a href="javascript:void(0)" class="list-group-item listview-item">
				<form name="viewtypeForm" action="<%=path%>/weekreport/list?openId=${openId}&publicId=${publicId}" method="post">
				 <input type="hidden" name="viewtype" id="viewtype" value="${viewtype}" />
				<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
					<p>
						<div class="form-control select _viewtype_select">
						<div class="select-box viewtypelabel">周报列表</div>
						<select name="viewtypesel" id="viewtypesel" style="display:none;">
							<option value="myview">个人周报</option>
							<option value="teamview">团队周报</option>
						</select>
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
				$("#_viewtype_menu").animate({height : 60}, [ 10000 ]);
				$(".site-recommend-list").css("display","none");
			}else{
				$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
				$("#_viewtype_menu").css("display","none");
				$(".site-recommend-list").css("display","");
			}
		}
		</script>
		<div class="_viewtype_menu_class" id="_viewtype_menu" style="padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
			<a href="<%=path%>/weekreport/list?viewtype=myview&viewtypesel=myview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;个人周报
				</div>
			</a>
			<a href="<%=path%>/weekreport/list?viewtypesel=teamview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;团队周报
				</div>
			</a>
		</div>
		
	<input type="hidden" name="currpage" value="1" /> 
	<div class="site-recommend-list page-patch listContainer">
		<div class="list-group listview" id="div_oppty_list">
			<c:forEach items="${weekList }" var="week">
				<div class="list-group-item listview-item" style="border:0px;display:flex;cursor: default;">${fn:substring(week.countweek,0,4)}年第${fn:substring(week.countweek,4,6)}周(${week.startdate}-${week.enddate })</div>
				<div class="list-group-item listview-item" style="margin-top:0px;border:0px;">
				<div class="list-group-item-bd" style="margin-left: 10px;line-height: 30px;">
					<c:if test="${fn:contains(maps,week.countweek)}">
						<c:forEach items="${maps}" var="item" >
							<c:if test="${week.countweek eq item.key}">
								<c:forEach items="${item.value}" var="report">
									<c:if test="${viewtype eq 'myview'}">
										<p>
											<a href="<%=path%>/weekreport/detail?rowId=${report.rowid}&openId=${openId}&publicId=${publicId}">
												${report.reporttypename}
											</a>
										</p>
									</c:if>
									<c:if test="${viewtype ne 'myview'}">
										<span style="padding-left:20px;padding-bottom:20px;">
											<a href="<%=path%>/weekreport/list?viewtype=myview&assignerid=${report.assignerid}&countweek=${report.countweek}&openId=${openId}&publicId=${publicId}">
												${report.assigner}
											</a>
										</span>
									</c:if>
								</c:forEach>
							</c:if>
						</c:forEach>
					</c:if>
					<c:if test="${!fn:contains(maps,week.countweek)}">
						<c:if test="${week.countweek eq currweek }">
							<a href="<%=path%>/weekreport/get?openId=${openId}&publicId=${publicId}"><div style="width:100%;text-align:center;color:#999">现在填写？</div></a>
						</c:if>
						<c:if test="${week.countweek ne currweek }">
							<div style="width:100%;text-align:center;color:#999">没有提交周报</div> 
						</c:if>
					</c:if>
				</div></div>
			</c:forEach>
			
			<!-- 
			<c:forEach items="${maps}" var="item" >
				<div class="list-group-item listview-item" style="display:flex;cursor: default;">${fn:substring(item.key,0,4)}年第${fn:substring(item.key,4,6)}周</div>
				<div class="list-group-item listview-item" style="margin-top:0px;">
					<div class="list-group-item-bd" style="margin-left: 10px;line-height: 30px;">
							<c:forEach items="${item.value}" var="report">
								<c:if test="${viewtype eq 'myview'}">
									<p>
										<a href="<%=path%>/weekreport/detail?rowId=${report.rowid}&openId=${openId}&publicId=${publicId}">
											${report.reporttypename}
										</a>
									</p>
								</c:if>
								<c:if test="${viewtype ne 'myview'}">
									<span style="padding-left:20px;padding-bottom:20px;">
										<a href="<%=path%>/weekreport/list?viewtype=myview&assignerid=${report.assignerid}&countweek=${report.countweek}&openId=${openId}&publicId=${publicId}">
											${report.assigner}
										</a>
									</span>
								</c:if>
							</c:forEach>
							<c:if test="${fn:length(item.value)==0}">
								<c:if test="${viewtype eq 'myview'}">
									<div style="text-align: center; font-size: 16px;">本周还没有周报哦!赶快去写吧</div>
								</c:if>
								<c:if test="${viewtype ne 'myview' }">
									<div style="text-align: center; font-size: 16px;">本周还没有人提交周报哦</div>
								</c:if>
							</c:if>
					</div>
				</div>
			</c:forEach>
			<c:if test="${fn:length(maps) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
			 -->
		</div>
<%-- 		<c:if test="${fn:length(maps)==10 }"> --%>
<!-- 			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next"> -->
<!-- 				<a href="javascript:void(0)" onclick="topage()"> -->
<%-- 					下一页&nbsp;<img id="nextpage" src="<%=path%>/image/nextpage.png" width="24px"/> --%>
<!-- 				</a> -->
<!-- 			</div> -->
<%-- 		</c:if> --%>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>