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
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet"	href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"	type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js"	type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
		$(function () {
			initForm();
			initDatePicker();
		});

		function initForm(){
			//表单提交
			$(".conbtn").click(function(){
				if(!validates()){
					var dataObj = [];
					$("form[name=activityform]").find("input").each(function(){
						var name = $(this).attr("name");
						var v = $(this).val();
						dataObj.push({name:name,value:v});
					});
					var remark = $("textarea[name=remark]").val();
					dataObj.push({name:'remark',value:remark});
					dataObj.push({name:'creator',value:'${assignername}'});
					$.ajax({
						url:'<%=path%>/workplan/save',
						type:'post',
						dataType:'text',
						data:dataObj,
						success:function(data){
							if("99999"==data){
								$(".myMsgBox").css("display","").html("创建失败,一天只能创建一个同类型的工作计划");
						  		$(".myMsgBox").delay(3000).fadeOut();
							}else{
								window.location.href="<%=path%>/workplan/detail?rowId="+data+"&orgId=${orgId}";
							}
						}
					});
				}
			});
			
	    	//取消按钮
	    	$(".canbtn").click(function(){
	    		window.location.replace("<%=path%>/workplan/list");
	    	});
			
			//类型选择事件
            $(".type_sel").click(function(){
            	var type = $(this).attr("key");
            	$(":hidden[name=type]").val(type);
            	if('day'==type){
            		$(".end_date_div").css("display","none");
            		$("input[name=start_date]").attr("placeholder","选择日期");
            		$("input[name=end_date]").val('');
            		if($("input[name=start_date]").val() != ''){
            			settitle();
            		}
            	}else{
            		$(".end_date_div").css("display","");
            		$("input[name=start_date]").attr("placeholder","开始日期");
            	}
            	
            	$(".type_sel").removeClass("selected").addClass("noselected");
            	$(this).removeClass("noselected").addClass("selected");
            });
		}
	  	function showMyMsg(t){
	  		$(".myMsgBox").css("display","").html(t);
	  		$(".myMsgBox").delay(2000).fadeOut();
	  	}
	  	
	  	
	  	//验证所有的参数是否都已经填写
	  	function validates(){

	  		var start_date = $("#start_date").val();
	  		if(!start_date){
	  			showMyMsg('请选择开始时间');
	  			return true;
	  		}
	  		
	  		if($(":hidden[name=type]").val() != 'day'){
		  		var end_date = $("#end_date").val();
		  		if(!end_date){
		  			showMyMsg('请选择结束时间');
		  			return true;
		  		}
	  		}else{
	  			$("#end_date").val($("#start_date").val());
	  		}
	  		
  			var title = $("#title").val();
	  		if(!title){
	  			showMyMsg('请填写标题');
	  			return true;
	  		}
	  		
	  		/*
	  		var remark = $("textarea[name=remark]").val();
	  		if(!remark){
	  			showMyMsg('请输入备注');
	  			return true;
	  		}
	  		*/
			return false;
	}
	  	
	  	
	//初始化日期控件
	function initDatePicker() {
		var opt = {
			datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
		};
		var optSec = {
			theme: 'default', 
			mode: 'scroller', 
			display: 'modal', 
			lang: 'zh', 
			onSelect: function(){
				var start_date = $('#start_date').val();
				var type=$(":hidden[name=type]").val();
				if('day'==type){
					var title2 = $('#title').val();
					if(null!= title2 && title2 != '')
					{
						$("input[name=title]").val(title2);
					}
					else
					{
						$("input[name=title]").val(start_date+" 工作计划");
					}
					
				}else{
					var enddate = '';
					if('week' == type){
						var d = new Date(start_date);
						var n = d.getTime() + 6 * 24 * 60 * 60 * 1000;
						var result = new Date(n);
						var month = result.getMonth() + 1;
						if(month <10){
							month = "0"+month;
						}
						var day = result.getDate();
						if(day < 10){
							day = "0"+day;
						}
						enddate = result.getFullYear() + "-" + month + "-" + day; 
					}
				    initEndDate(start_date,enddate);
				}
			}
		};
		$('#start_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], optSec));
	}
	
	function initEndDate(start_date,enddate){
		var year = start_date.split("-")[0];
		var month = parseInt(start_date.split("-")[1])-1;
		var day = parseInt(start_date.substring(start_date.lastIndexOf("-")+1,start_date.lastIndexOf("-")+3));
		
		var opt = {
				datetime : { preset : 'date',minDate: new Date(year,month,day)}
			};
			var optSec = {
				theme: 'default', 
				mode: 'scroller', 
				display: 'modal', 
				lang: 'zh',
				onSelect: function(){
					settitle();
				}
			};
		$('#end_date').val(enddate).scroller('destroy').scroller($.extend(opt['datetime'], optSec));
		if(enddate){
			settitle();
		}
	}
	
	function settitle(){
		var title = $('#title').val();
		if(null!=title && title!='')
		{
			$("input[name=title]").val(title);		
		}
		else
		{
			var end_date = $('#end_date').val();
			var start_date = $('#start_date').val();
			var type=$(":hidden[name=type]").val();
			if('week'==type){
				$("input[name=title]").val(start_date+"至"+end_date+" 工作计划");
			}else if('month'==type){
				$("input[name=title]").val(start_date+"至"+end_date+" 工作计划");
			}else if('day' == type){
				$("input[name=title]").val(start_date+" 工作计划");
			}
		}
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

.type_sel{
	padding: 3px 5px;
}
</style>
</head>

<body>
	
	<div style="font-size:14px;">
		<div class="">
			<form id="activityform" name="activityform" method="post">
				<input type="hidden" name="status" value="draft">
				<input type="hidden" name="orgId" value="${orgId}">
				<input type="hidden" name="type" value="day">
				<!-- 工作计划类型 -->
				<div style="line-height:30px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;">
					<div style="padding:5px;">
						<a class="type_sel selected" href="javascript:void(0)" key="day">日计划</a>&nbsp;&nbsp;
						<a class="type_sel noselected" href="javascript:void(0)" key="week">周计划</a>&nbsp;&nbsp;
						<%--<a class="type_sel noselected" href="javascript:void(0)" key="month">月报</a>&nbsp;&nbsp; --%>
					</div>
				</div>
				<!-- 开始日期 -->
				<div style="line-height:30px;border-bottom:1px solid #ddd;background-color:#fff;">
					<input name="start_date" id="start_date" value="" type="text"
						format="yy-mm-dd"  placeholder="选择日期" readonly=""
						style="border: none;height:50px;" class="">
				</div>
				<!-- 结束日期 -->
				<div class="end_date_div" style="line-height:30px;border-bottom:1px solid #ddd;background-color:#fff;display:none;">
					<input name="end_date" id="end_date" value="" type="text"
						format="yy-mm-dd" placeholder="结束日期" class="dateBtn"
						readonly="" style="border: none;height:50px;">
				</div>
				<!-- 工作计划标题 -->
				<div style="line-height:30px;border-bottom:1px solid #ddd;background-color:#fff;">
					<input name="title" id="title" value="" type="text"
						 placeholder="标题" style="border: none;height:50px;">
				</div>
				<!-- 备注-->
				<div style="line-height:30px;border-bottom:1px solid #ddd;background-color:#fff;margin-top: -2px;">
					<textarea name="remark" id="remark" rows="2"
						style="border: none; min-height: 2em" class="form-control"
						placeholder="请输入备注"></textarea>
				</div>
				<!-- 责任人-->
				<div style="line-height:50px;padding-left: 5px;border-top:1px solid #ddd;border-bottom:1px solid #ddd;background-color:#fff;margin-top: -2px;">
					责任人：${assignername}
				</div>
				<br/>
				
				<!--确定/取消按钮-->	
				<div class="button-ctrl" style="margin-top:-2px;">
					<fieldset class="">
						<div class="ui-block-a canbtn">
							<a href="javascript:void(0)" 
								class="btn btn-default btn-block" style="font-size: 14px;">取消</a>
						</div>
						<div class="ui-block-a conbtn">
							<a href="javascript:void(0)" 
								class="btn btn-success btn-block" style="font-size: 14px;">保存</a>
						</div>
					</fieldset>
				</div>

				
			</form>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>