<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<!--js-->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" ></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js" ></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js" ></script>
<script src="<%=path%>/scripts/plugin/jquery/ui/jquery.ui.js" ></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.fullPage.min.js"></script>
<script src="<%=path%>/scripts/plugin/json2.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" ></script>
<script src="<%=path%>/scripts/util/takshine.util.js" ></script>
<!--css-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/ui/jquery.ui.min.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<link rel="stylesheet" href="<%=path%>/css/acttemp/tpladd.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">

<script type="text/javascript">
		$(function () {
			initWeixinFunc();
			initDatePicker();
			dyncAddTempContent();
		});
		
		//微信网页按钮控制
		function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		}
   
       //初始化日期控件
       function initDatePicker(){
	    	var opt = {
	    		date : {preset : 'date'},
	    		datetime : { preset : 'datetime', minDate: new Date(), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
	    		time : {preset : 'time'},
	    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
	    		image_text : {preset : 'list', labels: ['Cars']},
	    		select : {preset : 'select'}
	    	};
	    	$('#start_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	    	$('#end_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	   		
	    	//结束日期
	    	$('#end_date').click(function(){
		  		alert($('#end_date').val());
				var start = date2utc($('#start_date').val());
				var end = date2utc($('#end_date').val()); 
				if(end>start){
					$('#end_date').val('').attr("placeholder","结束时间不能晚于开始时间,请重新选择结束时间!");
					return;
				}
			});
	  }
       
      //表单提交
      function submitForm(){
    	  if(!validates()){
			  $("#activityform").submit();
		  }
	  }
		
	  //验证所有的参数是否都已经填写
	  function validates(){
	 		var flag= false ;
	 		var errorMsg='填写不完整!请您将带有*标签的字段都填上!';
	  	 	$("#activityform").find(":hidden").each(function(){
	  			var val=$(this).val();
	  			if(!val){
	  				if( $(this).attr("name") != 'return_url' && $(this).attr("name") != 'logo' && $(this).attr("name") != 'openId' && $(this).attr("name") != 'publicId'&& $(this).attr("name") != 'orgId' && $(this).attr("name") != 'content'&& $(this).attr("name") != 'sourceid' && $(this).attr("name") != 'source'){
	  					flag=true;
	  				}
	  			}
	  		});
	  		$("#activityform").find("input").each(function(){
	  			var val=$(this).val();
	  			if(!val){
	  				if( $(this).attr("name") != 'return_url' && $(this).attr("name") != 'logo' && $(this).attr("name") != 'openId' && $(this).attr("name") != 'publicId'&& $(this).attr("name") != 'limit_number'&& $(this).attr("name") != 'expense'&& $(this).attr("name") != 'orgId'&& $(this).attr("name") != 'sourceid' && $(this).attr("name") != 'source'){
	  					flag=true;
	  				}
	  			}
	  		}); 
	  		
	  		$("textarea[name=content]").val($(".activity_div").html());
	  		
	  		if(!($("textarea[name=content]").val())){
	  			flag=true;
	  		}
			var start = date2utc($('#start_date').val());
			var end = date2utc($('#end_date').val()); 
		    if(end>start){
		    	$('#end_date').val('').attr("placeholder","结束时间不能晚于开始时间,请重新选择结束时间!");
				flag=true;
				errorMsg='结束时间不能晚于开始时间,请重新选择结束时间!'
			}
		    if(flag){
				$(".myMsgBox").css("display","").html(errorMsg);
	   	    	$(".myMsgBox").delay(2000).fadeOut();
			}
			return flag;
	  }
	  
	  //选择模板 
	  function selectTemplate(){
		  $(".activity_template_list").removeClass("none");
		  $(".activity_template_content").css("display","none");
		  $(".activity_div").css("display","none");
		  $(".nextdiv").css("display","none");
	  }
	  
	  //添加模板内容
	  function dyncAddTempContent(){
		  $(".selecttemplate").click(function(){
			  var num = $(":hidden[name=currtemppage]").val();
			  $(".template_list").each(function(){
				  if($(this).hasClass("t_selected")){
					  var sobj = null;
					  $(".activity_content").find("[data-anchor]").each(function(){
						  if($(this).attr("data-anchor") == "page"+num){
							  sobj = $(this);
						  }
						  $(this).css("display","none");
					  });
					  
					  $(this).find("[data-anchor]").attr("data-anchor","page"+num);
					  if(sobj){
						 sobj.before($(this).html());
						 $(sobj).remove();
					  }else{
					  	 $(".activity_content").append($(this).html());
					  }
				  }
			  });
			  $(".activity_template_content").css("display","");
			  $(".activity_template_list").addClass("none");
			  $(".nextdiv").css("display","");
			  $(".activity_div").css("display","");
			  
			  //dragDiv contenteditable
			  //$(".dragDiv").resizable();
			  $(".activity_content").find("div[contenteditable=false]").each(function(){
				  $(this).attr("contenteditable", true);
			  });
		  });
	  }
	  
	  //选择页面
	  function selectPage(p){
		  $(".activity_content").find("[data-anchor]").each(function(){
			  if($(this).attr("data-anchor") == "page"+p){
				  $(this).css("display","");
			  }else{
			 	  $(this).css("display","none");
			  }
		  });
		  
		  $(".template_page").each(function(){
			  $(this).css("background-color","#eee");
			  $(this).css("color","#999");
		  });
		  $(".pages"+p).css("background-color","#9584E4");
		  $(".pages"+p).css("color","#fff");
		  
		  $(":hidden[name=currtemppage]").val(p);
	  }
	  
	  //添加页面
	  function addPage(){
		  if($(".template_page").size() >= 10){
			  $(".myMsgBox").css("display","").html("最多添加10页");
	 	    	  $(".myMsgBox").delay(2000).fadeOut();
			  return;
		  }
		  
		  //获取最大页
		  var page = 0;
		  page = $(".template_page").last().html();
		  page = parseInt(page)+1;
		  var val = '<div class="template_page pages'+page+'" onclick="selectPage(\''+page+'\')" style="border-radius: 10px 0px 0px 10px;line-height:25px;text-align:center;margin:5px 0px 0px 0px;">'+page+'</div>';
	  	  $(".page_div").append(val);
	  	  
	  	  $(":hidden[name=currtemppage]").val(page);
	  	  
	  	  selectPage(page);
	  }
	  
	  function nextStep(){
		  $(".activity_base_content").removeClass("none");
		  $(".activity_template_content").css("display","none");
		  $(".activity_div").css("display","none");
		  $(".nextdiv").css("display","none");
		  $(".savediv").removeClass("none");
	  }
	  
	  function prevStep(){
		  $(".activity_base_content").addClass("none");
		  $(".activity_template_content").css("display","");
		  $(".activity_div").css("display","");
		  $(".nextdiv").css("display","");
		  $(".savediv").addClass("none");
	  }
	  
</script>
</head>
<body class="bg">
	<div id="task-create">
		<div id="site-nav" class="navbar">
			<div class="fl">
				<a href="javascript:void(0)" onclick="javascript:history.go(-1)" class="tpl-hd-back">
					<img src="<%=path%>/image/back.png" class="pd5 w40">
				</a>
			</div>
			<h3 class="pr45">发起活动(模板)</h3>
		</div>
		<form id="activityform" action="<%=path%>/activity/save" method="post">
			<input type="hidden" name="currtemppage" value="1"/>
		    <input type="hidden" name="openId" value="${openId}" /> 
			<input type="hidden" name="publicId" value="${publicId}" /> 
			<input type="hidden" name="sourceid" value="${sourceid}" /> 
			<input type="hidden" name="source" value="${source}" /> 
			<input type="hidden" name="type" value="${type}" />
			<input type="hidden" name="orgId" value="${orgId}" />
			<input type="hidden" name="status" value="publish" />
			<input type="hidden" name="charge_type" value="free" />
			<input type="hidden" name="return_url" value="${return_url}" />
			<textarea name="content" class="none" ></textarea>
			<div class="activity_base_content none"> 
				<!-- 活动主题 -->
				<div class="form-group">
					<label class="control-label" >
						主题&nbsp;<span class="cred">*</span>
					</label>
					<input name="title" type="text" class="form-control" placeholder="请输入活动主题"/>
				</div>	
				<div class="form-group">
					<label class="control-label" >
						活动开始时间&nbsp;<span class="cred">*</span>
					</label>
					<input name="start_date" type="text" id="start_date" format="yy-mm-dd HH:ii:ss" placeholder="点击选择日期" >
				</div>	
				<div class="form-group">
					<label class="control-label" >
						报名截止时间&nbsp;<span class="cred">*</span>
					</label>
					<input name="end_date" type="text" id="end_date" format="yy-mm-dd HH:ii:ss" placeholder="点击选择日期"  class="dateBtn">									  
				</div>
				<div class="form-group">
					<label class="control-label" >
						是否公开&nbsp;
					</label>
					<select name="ispublish">
						<c:forEach items="${lov_activity_ispublish}" var="item">
							<option value="${item.key }">${item.value}</option>
						</c:forEach>
					</select>
				</div>
				<div class="form-group">
					<label class="control-label">人数限制&nbsp;</label>
					<input name="limit_number" type="number"  placeholder="报名人数限制" >
				</div>
			</div>
		</form>
		<!-- tpl edit -->
		<div class="activity_template_content ">
			<!-- 选择模板 -->
			<div class="tplcon" onclick="selectTemplate()">
				<div class="tplcon-btn zd999">模板</div>
			</div>
			<!-- 页码 -->
			<div>
				<div class="tpladdcon zd999" onclick="addPage()"> 
					<div class="tpladdbtn">+</div>
				</div>
				<div class="page_div zd999">
					<div class="template_page pages1" onclick="selectPage('1')">1</div>
				</div>
			</div>
		</div>
		<!-- tpl list -->
		<div class="activity_template_list none">
			<jsp:include page="/common/marketing/acttemp.jsp"></jsp:include>
		</div>
	</div>
	
	<!-- 主页 -->
	<div class="activity_div">
		<div id="superContainer" class="activity_content"></div>
	</div>
	
    <!-- btn -->
	<div class="flooter nextdiv" onclick="nextStep()">
		<!-- <a class="btn btn-block preview" onclick="preview()">预览</a> -->
		<a class="btn btn-block btn-success nextdiv-btn">下一步</a>
	</div>
	<div class="flooter savediv none"> 
		<a class="btn btn-block savediv-pre" onclick="prevStep()">上一步</a>
		<a class="btn btn-block btn-success submitbtn" onclick="submitForm()">保存</a>
	</div>
	
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBox"></div>
</body>
</html>