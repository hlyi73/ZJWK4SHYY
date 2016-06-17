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
	
	function initForm(){
		var selObj = $("select[name=viewtypesel]");
		//下拉框初始化
		selObj.change(function(){
			var val = selObj.val();
			if(val == "myview_wait"){
				$("input[name=status]").val('wait');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_notreceive"){
				$("input[name=status]").val('notreceive');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_received"){
				$("input[name=status]").val('received');
				$("input[name=viewtype]").val('myview');
			}else if(val == "teamview"){
				$("input[name=status]").val('');
				$("input[name=viewtype]").val('teamview');
			}else if(val == "myview_stoped"){
				$("input[name=status]").val('');
				$("input[name=verifityStatus]").val('3');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_verified"){
				$("input[name=status]").val('');
				$("input[name=verifityStatus]").val('2');
				$("input[name=viewtype]").val('myview');
			}
			$("form[name=viewtypeForm]").submit();
			return false ;
		});
		//获取类型值
		selObj.val('${viewtypesel}');
		$(".viewtypelabel").html(selObj.find("option:selected").text());
	}
	
	function topage(){
		$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/gathering/gatheringlist' || '',
		      //async: false,
		      data: {viewtype:'${viewtype}',currpage:currpage,publicId:'${publicId}',openId:'${openId}',status:'${status}',verifityStatus:'${verifityStatus}'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_gathering_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	       $("#div_gathering_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
		    	    if(d == ""){
		    	    	$("#div_next").css("display",'none');
		    	    }else{
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							var status = this.status;
							var typeimg = "";
							if(this.parentid != "" && this.parenttype == "Accounts"){
								typeimg = '<img src="<%=path%>/image/acounts.png" width="20px" border=0>';
							}else if(this.parentid != "" && this.parenttype == "Opportunities"){
								typeimg = '<img src="<%=path%>/image/opptys.png" width="20px" border=0>';
							}else if(this.parentid != "" && this.parenttype == "Tasks"){
								typeimg = '<img src="<%=path%>/image/tasks.png" width="20px" border=0>';
							}
							val += '<a href="<%=path%>/gathering/detail?rowId='+this.rowid+'&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item">'
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'+status +'</b></div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">计划:&nbsp;&nbsp;'+this.planDate+'&nbsp;&nbsp;￥'+this.planAmount+'</p> '
								+ '<span><p class="text-default">实际:&nbsp;&nbsp;'+this.receivedDate+'&nbsp;&nbsp;￥'+this.receivedAmount+'</p>'
								+ '<p class="text-default">'+typeimg+this.parentName+'</p></span>'
								+ '</div></div> '
								+ '<div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div>'
								+ '</a>';
						});
		    	    }
					$("#div_gathering_list").html(val);
					
					$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
		      }
		 });
	}
	
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
<!-- 			<i class="icon-menu"><b></b></i> -->
		</div>
		<input type="hidden" name="currpage" value="1" />
		<a href="javascript:void(0)" class="list-group-item listview-item">
		  <form name="viewtypeForm" action="<%=path%>/gathering/list?openId=${openId}&publicId=${publicId}" method="post">
		  	<input type="hidden" name="viewtype" id="viewtype" value="${viewtype }" />
		  	<input type="hidden" name="verifityStatus" id="verifityStatus" value="" />
		  	<input type="hidden" name="status" id="status" value="" />
			<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
				<p>
					<div class="form-control select">
						<c:if test="${viewtype eq 'analyticsview' }">
							<span style="color:white">应收款/回款列表</span>
						</c:if>
						<c:if test="${viewtype ne 'analyticsview' }">
						<div class="select-box viewtypelabel">我的待回款列表</div>
							<select name="viewtypesel" id="viewtypesel">
								<option value="myview_wait">我的待回款列表</option>
								<option value="myview_notreceive">我的未及时回款列表</option>
								<option value="myview_received">我的已回款列表</option>
								<option value="myview_verified">我的已核销列表</option>
								<option value="myview_stoped">驳回列表</option>
								<option value="teamview">我团队的收款列表</option>
							</select>
						</c:if>
					</div>
				</p>
			</div>
		  </form>	
		</a>
		</div>
		<jsp:include page="/common/navbar.jsp"></jsp:include>
		<div class="site-recommend-list page-patch">
			<div id="div_gathering_list" class="list-group listview">
				<c:forEach items="${gatheringList}" var="gath">
					<a href="<%=path%>/gathering/ilist?rowId=${gath.rowid}&openId=${openId}&publicId=${publicId}"
						class="list-group-item listview-item">
						<div class="list-group-item-bd">
							 <div class="thumb list-icon">
								<b>${gath.status}</b>
							</div>
							<div class="content" style="text-align: left">
								<h1>${gath.title }&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${gath.assigner }</span></h1>
								<p class="text-default">计划:&nbsp;&nbsp;${gath.planDate}&nbsp;&nbsp;￥${gath.planAmount}万元</p>
								<span>
									<c:if test="${gath.receivedDate ne ''}">
										<p class="text-default">实际:&nbsp;&nbsp;${gath.receivedDate}&nbsp;&nbsp;￥${gath.receivedAmount}万元</p>
									</c:if>
									<p class="text-default">
									<c:if test="${gath.parentId !=null && gath.parentType eq 'Accounts'}">
										<img src="<%=path%>/image/acounts.png" width="20px" border=0>${gath.parentName}
									</c:if>
									<c:if test="${gath.parentId !=null && gath.parentType eq 'Opportunities'}">
										<img src="<%=path%>/image/opptys.png" width="20px" border=0>${gath.parentName}
									</c:if>
									<c:if test="${gath.parentId !=null && gath.parentType eq 'Tasks'}">
										<img src="<%=path%>/image/tasks.png" width="20px" border=0>${gath.parentName}
									</c:if>
								</p>
								</span>
							</div>
						</div>
						<div class="list-group-item-fd">
							<span class="icon icon-uniE603"></span>
						</div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(gatheringList) == 0 }">
					<div style="text-align:center;padding:50px;">没有找到数据</div>
				</c:if>
				</div>
				<c:if test="${fn:length(gatheringList)==10 }">
					<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
						<a href="javascript:void(0)" onclick="topage()">
							下一页&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
						</a>
					</div>
				</c:if>
		</div>
		<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>