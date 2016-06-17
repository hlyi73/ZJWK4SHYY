<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指尖微客</title>
<%@ include file="/common/comlibs.jsp"%>
<link href="<%=path%>/css/pc/zjwk.module.css" rel="stylesheet">
<link href="<%=path%>/css/pc/style.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wx.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wxedit.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wxlist.css" rel="stylesheet">
<link href="<%=path%>/css/pc/font-awesome.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/bootstrap.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/charts-graphs.css" rel="stylesheet">
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/css/pc/bootstrap.min.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<meta charset="UTF-8">
<script type="text/javascript">
	$(function() {
		var height = screen.height;
		$(".dashboard-wrapper").css("min-height", parseInt(height) * 0.9);
		topage('${viewtype}');
		initButton();
	});

	//初始化按钮
	function initButton() {
		//增加指尖活动
		$(".jsCreate").click(function(){
			
		});
	}
	
	//初始化活动数据
	 function topage(viewtype){
		var dataObj = [];
		dataObj.push({name:'viewtype', value: viewtype });
		dataObj.push({name:'currpage', value: '1' });
		dataObj.push({name:'pagecount', value: '9999999' });
		$.ajax({
		      type: 'post',
		      url: '<%=path%>/activity/synclist' ,
		      data: dataObj ,
		      dataType: 'text',
		      success: function(data){
		    	  	if(!data ){
		    	  		return;
		    	  	}
		    	    var d = JSON.parse(data);
		    	    var url_det = '<%=path%>/activity/detail?sourceid=${sourceid}&source=${source}&id=';
		    	    var url_mod = '<%=path%>/activity/modify?sourceid=${sourceid}&source=${source}&id=';
		    	    var imgurl = '<%=path%>/attachment/download?flag=headImage&fileName= ';
					if(d != ""){
						$(d).each(function(i){
								var val = template.join("");	
								val = val.replace("$$id",this.id);
								val = val.replace("$$delid",this.id);
								val = val.replace("$$title",this.title);
								val = val.replace("$$detailurl",url_det+this.id);
								val = val.replace("$$time",this.start_date);
								val = val.replace("$$imgsrc",imgurl+this.logo);
								val = val.replace("$$desc",this.remark);
								val = val.replace("$$modifyurl",url_mod+this.id);
								if((i+1)%3==0){
									$("#appmsgList3").append(val);
								}else if((i+1)%3==1){
									$("#appmsgList1").append(val);
								}else if((i+1)%3==2){
									$("#appmsgList2").append(val);
								}
							});
						} 
					}
				});
	}
	
var template = [
      		'<div id="$$id"><div class="appmsg "><div class="appmsg_content"><h4 class="appmsg_title">',
            '<a href="$$detailurl" target="_blank">$$title</a></h4><div class="appmsg_info"><em class="appmsg_date">$$time</em>',
            '</div><div class="appmsg_thumb_wrp"><img src="$$imgsrc" alt="" class="appmsg_thumb"></div>',
            '<p class="appmsg_desc">$$desc</p></div><div class="appmsg_opr"><ul>',
			'<li class="appmsg_opr_item grid_item size1of2"><a class="js_tooltip" href="$$modifyurl"data-tooltip="编辑">&nbsp;',
			'<i class="icon18_common edit_gray">编辑</i></a></li><li class="appmsg_opr_item grid_item size1of2 no_extra">',
			'<a class="js_del no_extra js_tooltip"	href="javascript:void(0);" onclick="delRecord(this);" data-id ="$$delid" data-tooltip="删除">&nbsp;<i	class="icon18_common del_gray">删除</i></a>',
			'</li></ul></div></div></div>'
			];

function delRecord(obj){
	var id = $(obj).attr("data-id");
	$("#"+id).remove();
}
</script>
</head>
<body style="background: #0B4364;">
	<!-- 菜单 -->
	<header style="line-height: 100px;">
		<div style="float: left; padding-bottom: 80px;">
			<a href="java" class="logo" data-original-title="" title=""> <span
				style="color: #fff; font-size: 30px; font-weight: bold;">指尖活动</span>
				<span style="color: #aaa; font-size: 18px;">&nbsp;&nbsp;连接企业资源，世界尽在指尖</span>
			</a>
		</div>
	</header>
	<!-- Header End -->
	<!-- Main Container start -->
	<div class="dashboard-container" style="margin-top: 100px;">
		<div class="container">
			<!-- Top Nav Start -->
			<div class="top-nav hidden-xs hidden-sm">
				<div class="clearfix"></div>
			</div>
		</div>
	</div>
	<!-- 菜单结束 -->
	<div class="dashboard-wrapper">
		<!-- Left Sidebar Start -->
		<div class="main_bd" style="padding-top: 30px;">
			<div class="appmsg_list" id="appmsgList">
				<div class="appmsg_col tj_item">
					<div class="inner" id="appmsgList1">
						<span class="create_access jsCreate" style="cursor:pointer;font-size:18px;color:black;">
							发起活动
						</span>
					</div>
				</div>
				&nbsp;
				<div class="appmsg_col tj_item">
					<div class="inner" id="appmsgList2">
					</div>
				</div>
				&nbsp;
				<div class="appmsg_col">
					<div class="inner" id="appmsgList3">
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 底栏 -->
	<footer style="margin-top: 15px;">
		<p>@2015 指尖活动</p>
	</footer>
	<!-- 底栏结束 -->
</body>
</html>