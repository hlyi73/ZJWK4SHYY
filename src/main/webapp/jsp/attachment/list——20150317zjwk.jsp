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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		initForm();
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
		      url: '<%=path%>/sample/samplelist' || '',
		      //async: false,
		      data: {viewtype:'${viewtype}',currpage:currpage,publicId:'${publicId}',openId:'${openId}'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_sample_list").html();
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
							var status = this.statusname;
							var statusimg = "";
							if(status == "待审批"){
								statusimg = '<img src="<%=path %>/image/expense_status_wait.png" border=0 width="30px">';
							}else if(status == "已批准"){
								statusimg = '<img src="<%=path %>/image/expense_status_ok.png" border=0 width="30px">';
							}else if(status == "驳回"){
								statusimg = '<img src="<%=path %>/image/expense_status_ng.png" border=0 width="30px">';
							}else{
								statusimg = '<img src="<%=path %>/image/expense_status_null.png" border=0 width="30px">';
							}
							val+= '<a href="<%=path%>/sample/detail?rowId=${attach.rowid}&openId=${openId}&publicId=${publicId}"'
							   + 'class="list-group-item listview-item radio"><div class="list-group-item-bd"><div class="thumb list-icon" style="background-color:#ffffff;width:30px;height:30px;">'
							   + statusimg +'</div><div class="content" style="text-align: left"><h1>'
							   + this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1><p>'
							   + '开始：'+this.startdate+'&nbsp;&nbsp;&nbsp;&nbsp;结束：'+this.enddate+'</p></div></div>'
							   + '<div class="list-group-item-fd" ><span class="icon icon-uniE603"></span></div></a>';
						});
		    	    }
					$("#div_sample_list").html(val);
					$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
		      }
		 });
	}
	
	
	//初始化表单按钮和控件
	function initForm(){
		//下拉框初始化
		var selObj = $("select[name=viewtypesel]");
		selObj.change(function(){
			var val = selObj.val();
			if(val == "myview_approval"){
				$("input[name=approval]").val('approving');
				$("input[name=viewtype]").val('myview');
			}else if(val == "myview_approved"){
				$("input[name=approval]").val('approved');
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
			}
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
			<input type="hidden" name="currpage" value="1" />
			<a href="javascript:void(0)" class="list-group-item listview-item">
				<form name="viewtypeForm" action="<%=path%>/expense/list?openId=${openId}&publicId=${publicId}" method="post">
				 <input type="hidden" name="viewtype" id="viewtype" value="${viewtype }" />
					<div class="list-group-item-bd native" style="color:#fff;width:180px;margin:0 auto;padding-top:5px;" >
						附件列表
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
				$("#_viewtype_menu").animate({height : 125}, [ 10000 ]);
				$(".site-recommend-list").css("display","none");
			}else{
				$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
				$("#_viewtype_menu").css("display","none");
				$(".site-recommend-list").css("display","");
			}
		}
		</script>
		<!-- 下拉菜单选项 end -->
		
		<div id="div_search_content2" class="site-recommend-list page-patch sampleList">
			<div id="div_sample_list" class="list-group listview">
				<c:forEach items="${dataList}" var="attach">
					<a href='<%=PropertiesUtil.getAppContext("sugar.service") %>/downloadfile.php?id=${attach.url}&type=${attach.mimetype}&fileName=${attach.filename}' target="_blank"
						class="list-group-item listview-item ">
						<div class="list-group-item-bd">
							<div class="content" style="text-align: left">
								<h1>
									${attach.filename}&nbsp;
								</h1>
								<p>附件类型:  ${attach.filetype}</p>
							</div>
						</div>
						<div class="list-group-item-fd" >
							<span class="icon icon-uniE603"></span>
						</div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(dataList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
			</div>
			<c:if test="${fn:length(sampleList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path%>/image/nextpage.png" width="24px"/>
				</a>
			</div>
			</c:if>
		</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>