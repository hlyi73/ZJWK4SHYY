<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

<script type="text/javascript">
		$(function () {
			//initWeixinFunc();
			initDatePicker();
			initForm();
			initDom();
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
		
		//初始化日期控件
		function initDatePicker(){
			var opt = {
				date : {preset : 'date',maxDate: new Date(2099,11,30)},
				datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 5  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			//类型 date  datetime
			$('#quotedate').val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$('#valid').val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		}
		
		var p={};
		//初始化dom节点
		function initDom(){
			p.fstChar = $(":hidden[name=fstChar]");
			p.seachUrl=$(":hidden[name=seachUrl]");
			p.currPage=$(":hidden[name=currPage]");
			p.pageCount=$(":hidden[name=pageCount]");
			p.currType=$(":hidden[name=currType]");
			p.parentid=$(":hidden[name=parentid]");
			p.parenttype=$(":hidden[name=parenttype]");
			p.parentname=$(":hidden[name=parentname]");
		}
		
		//初始化表单按钮和控件
		function initForm(){
			//相关选择事件
			$(".parentChoose").click(function(){
				var v = $(this).attr("val");
				var type="";
				var url="";
				if(v === "Accounts"){
					type="accntList";
					url='<%=path%>/customer/list';
				}else if(v === "Opportunities"){
					type="opptyList";
					url='<%=path%>/oppty/list';
				}
				p.fstChar.val('');
				p.currPage.val('1');
				p.currType.val(v);
				p.seachUrl.val(url);
		    	searchFristCharts(type);
		    	scheduleReleation(type);
		    	$("#task-create").addClass("modal");
				$("#parent-more").removeClass("modal");
			});
		 	
			// 相关的确定按钮
			$(".parentbtn").click(function(){
				var v = p.currType.val();
				var parentId='', parentName='';
				$(".parentList > a.checked").each(function(){
					parentId = $(this).find(":hidden[name=parentId]").val();
					parentName = $(this).find(":hidden[name=parentName]").val();
				});
				if(''==parentId){
					$(".myMsgBox").css("display","").html("商机不能为空,请选择商机!");
	    	    	$(".myMsgBox").delay(2000).fadeOut();
	  				return true;
				}
				p.parentid.val(parentId);
				p.parenttype.val(v);
				p.parentname.val(parentName);
				$("input[name=opptyname]").val(parentName);
				$(".parentGoBak").trigger("click");
			});
			
			//相关数据返回点击事件
			$(".parentGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#parent-more").addClass("modal");
			});
			
			//直接保存
			$(".submitBtn").click(function(){
				if(!validates()){
					$("form[name=quoteform]").submit();
				}
			});
		}
		  
	   	 //勾选相关数据的超链接
		 function parentListSel(){
			$(".parentList > a").click(function(){
				$(".parentList > a").removeClass("checked");
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}else{
					$(this).addClass("checked");
				}
				return false;
			});
	    }
		
		 //查询模块的首字母
	    function searchFristCharts(type){
	    	$.ajax({
		  	      type: 'get',
		  	      url: '<%=path%>/fchart/list',
		  	      data: {orgId:'${orgId}',crmId: '${crmId}',type: type},
		  	      dataType: 'text',
		  	      success: function(data){
		  	    		$("#fristChartsList").empty();
		  	    	
		  	    	    if(!data) return;
		  	    	    var d = JSON.parse(data);
		  	    	    if(d.errorCode && d.errorCode !== '0'){
		  	    	  		$("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
				    	    return;
				    	}
		  	    	  	
		  	    	    var ahtml = '';
		  	    	    $(d).each(function(i){
		  	    	    	ahtml += '<a href="javascript:void(0)" style="margin: 0px 12px 0px 12px;" onclick="chooseFristCharts(\''+ type +"','"+this+'\')">'+ this +'</a>';
		  	    	    });
		  	    	    $("#fristChartsList").html(ahtml);
		  	      }
	    	 });
	    }

	    //点击首字母事件
	    function chooseFristCharts(type,obj){
	    	p.fstChar.val(obj);
	    	p.currPage.val('1');
	    	scheduleReleation(type);
	    }
	    
	  	//相关
	    function scheduleReleation(type){
	    	var currpage = p.currPage.val();
	    	if(parseInt(currpage) == 1){
	    		$("#div_prev").css("display",'none');
	    	}else{
	    		$("#div_prev").css("display",'');
	    	}
	    	var firstchar=p.fstChar.val();
	    	var pagecount=p.pageCount.val();
	    	$.ajax({
    		      type: 'post',
    		      url: p.seachUrl.val(),
    		      //async: false,
    		      data: {orgId:'${orgId}',crmId: '${crmId}',openId:'${openId}',publicId:'${publicId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
    		      dataType: 'text',
    		      success: function(data){
    		    	  if(!data){
    		    		  if('1'==currpage){
	    		    	  	$(".parentList").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
    		    		  }
    		    		 	$("#div_next").css("display",'none');
    		    	  		return;
    		    	 	 }
    		    	    var val = '';
    		    	    var d = JSON.parse(data);
    		    	    if(d.errorCode && d.errorCode !== '0'){
				  	    	if('1'==currpage){
			  	    	  		$(".parentList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
				  	    	}
			  	    	  	$("#div_next").css("display",'none');
		  	    	  		return;
				    	}
    					if(d == "" && $(d).size()==0){
    						if('1'==currpage){
    							$(".parentList").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
    						}
    		    	    	$("#div_next").css("display",'none');
    		    	    	return;
    		    	    }else{
   		    	    		if($(d).size() == pagecount){
   		    	    			$("#div_next").css("display",'');
   		    	    		}else{
   		    	    			$("#div_next").css("display",'none');
   		    	    		}
   							$(d).each(function(i){
   								if(type === "accntList"){
   									var content="";
   									if(this.phoneoffice != ''){
   										content = '<p class="text-default"><img src="<%=path%>/image/mb_card_contact_tel.png" width="16px">' + this.phoneoffice+'</p>';
									}
   									content += '<p class="text-default">';
									if(this.source != ''){
										content += '来源：' + this.source;
									}
									if(this.industry != ''){
										content += '行业：' + this.industry;
									}
									content += '</p>';
   									val += '<a href="javascript:void(0)" class="list-group-item listview-item radio"'
	  									+'><div class="list-group-item-bd">'
	  									+'<div class="thumb list-icon"><b>'+this.accnttype+'</b></div>'
	  									+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
	  									+'<input type="hidden" name="parentName" value="'+this.name+'"/>'
	  									+'<h1 class="title">'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
	  									+this.assigner+'</span></h1>'+content
	  									+'</div><div class="input-radio" title="选择该条记录"></div></a>';
   								}else if(type === "opptyList"){
   									val +='<a href="javascript:void(0)" class="list-group-item listview-item radio">'
   	   									+'<div class="list-group-item-bd"> <div class="thumb list-icon"><b>'+this.probability+'%</b></div>'
   	   									+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
   	   							        +'<input type="hidden" name="parentName" value="'+this.name+'"/><h1 class="title">'+this.name+'&nbsp;<span '
   	   									+'style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1><p class="text-default">'
   	   									+'预期:￥'+this.amount+'&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:'+this.salesstage+'</p>'
   	   									+'<p>关闭日期:'+this.dateclosed+'&nbsp;&nbsp;&nbsp;&nbsp;跟进天数:'+this.createdate+'</p>'
   	   									+'</div><div class="input-radio" title="选择该条记录"></div></a>';
   								}
   							});
    						$("#fristChartsList").css("display",'');
    		    	    }
    					$(".parentList").html(val);
    					parentListSel();
	    		      }
	    		 });
	  	}
	  	
	  	//翻页
	    function topage(type){
	    	var parenttype = p.currType.val();
	    	var currpage = p.currPage.val();
	    	if(type == "prev"){
	    		p.currPage.val(parseInt(currpage) - 1);
	    	}else if(type == "next"){
	    		p.currPage.val(parseInt(currpage) + 1);
	    	}
	    	if(parenttype == "Accounts"){
	    		scheduleReleation("accntList");
	    	}else if(parenttype == "Opportunities"){
	    		scheduleReleation("opptyList");
	    	}
	    }
	  	
	  	//验证所有的参数是否都已经填写
	  	function validates(){
  			var flag= false ;
  			var quotecode = $("input[name=quotecode]");
  			var amount = $("input[name=amount]");
  			var reg=/^[0-9]{8}$/;
  			 var reg1 = /^\d+(?=\.{0,1}\d{0,2}$|$)/;
  			if(!reg.test(quotecode.val())){
  				$(".myMsgBox").css("display","").html("请输入正确的八位数字编号!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
  				return true;
  			}
  			if(!reg1.test(amount.val())){
  				$(".myMsgBox").css("display","").html("请输入正确的报价金额!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
  				return true;
  			}
	  		$("#quoteform").find(":hidden").each(function(){
	  			var val=$(this).val();
	  			if(!val){
	  				flag=true;
	  			}
	  		});
			if(flag){
				$(".myMsgBox").css("display","").html("填写不完整!请您将带有*标签的字段都填上!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return true;
			}	
			return flag;
	  	}
	  	
	</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar" >
			<div style="float: left">
				<a href="javascript:void(0)" onclick="javascript:history.go(-1)" style="color: #fff;padding:5px 5px 5px 0px;">
					<img src="<%=path%>/image/back.png" width="40px" style="padding:5px;">
				</a>
			</div>
			<h3 style="padding-right:45px;">创建报价单</h3>
		</div>
		<input type="hidden" name="currType" />
	    <input type="hidden" name="seachUrl" />
	    <input type="hidden" name="fstChar" />
	    <input type="hidden" name="currPage" value="1" />
	    <input type="hidden" name="pageCount" value="10" />
		<input type="hidden" name="flag" value=""/>
		<div class="wrapper">
			<form id="quoteform" name="quoteform" action="<%=path%>/quote/save" method="post"  >
			    <input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="parenttype" value="${parenttype}" /> 
				<input type="hidden" name="parentid" value="${parentId}" /> 
				<input type="hidden" name="parentname" value="${parentName}" /> 
				<input type="hidden" name="assignerid" value="${crmId}" /> 
				<input type="hidden" name="source" value="${source}" /> 
				<input type="hidden" name="orgId" value="${orgId}" /> 
				<!-- 服务请求信息编号 -->
				<div class="form-group">
					<label class="control-label" >报价单编号&nbsp;<span style="color:red;">*</span></label>
					<input name="quotecode" id="quotecode" value="${quotecode}" type="text"
						class="form-control" placeholder="请输入八位数字编号"/>
				</div>
				<!-- 报价名称 -->
				<div class="form-group">
					<label class="control-label" for="realname">报价名称&nbsp;<span style="color:red;">*</span></label>
					<input name="name" id="name" type="text"
						class="form-control" placeholder="请输入报价名称" />
				</div>
				<!-- 报价金额 -->
				<div class="form-group">
					<label class="control-label" >报价金额&nbsp;<span style="color:red;">*</span></label>
					<input name="amount" id="amount" value="" type="text"
						class="form-control" placeholder="请输入报价金额"/>
				</div>
				<!-- 相关客户 -->
<!-- 				<div class="form-group"> -->
<!-- 					<label class="control-label" for="parent">客户 &nbsp;<span style="color:red;">*</span></label> -->
<!-- 					<input name="customername" id="customername" type="text" val="Accounts" -->
<!-- 					       class="form-control parentChoose" value="" placeholder="【点击  选择相关客户】  >>  " readonly="readonly" > -->
<!-- 				</div> -->
				<!-- 相关商机 -->
				<div class="form-group">
					<label class="control-label" for="parent">商机名称&nbsp;<span style="color:red;">*</span></label>
					<input name="opptyname" id="opptyname" val="Opportunities" type="text" 
					       class="form-control parentChoose" value="${parentName}"  placeholder="【点击  选择相关商机】  >>  " readonly="readonly" >
				</div>
				<!-- 报价日期 -->
				<div class="form-group">
					<label class="control-label" for="startdate">报价日期&nbsp;<span style="color:red;">*</span></label>
					<input name="quotedate" id="quotedate" type="text" format="yy-mm-dd" 
						class="form-control" placeholder="报价日期" readonly="" />
				</div>
				<!-- 有效期 -->
				<div class="form-group">
					<label class="control-label" for="participant">有效日期&nbsp;<span style="color:red;">*</span></label>
					<input name="valid" id="valid" type="text" format="yy-mm-dd" 
						class="form-control" placeholder="有效日期" readonly="" />
				</div>
				<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-a" style="width: 100%;">
							<a href="javascript:void(0)" class="btn btn-block submitBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">
							   保存</a>
						</div>
					</fieldset>
				</div>
			</form>
		</div>
	</div>
	
	<!-- 相关数据列表 -->
	<div id="parent-more" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary parentGoBak"><i class="icon-back"></i></a>
				数据列表
		</div>
		<div class="site-recommend-list page-patch">
			<div class="list-group-item listview-item radio" style="background: #fff;">
				<!-- 字母区域 -->
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span id="fristChartsList" ></span>
				</div>
			</div>
			<div style="width:100%;text-align:center;display:none;" id="div_prev" >
				<a href="javascript:void(0)" onclick="topage('prev')">
					<img  src="<%=path%>/image/prevpage.png" width="32px" >
				</a>
			</div>
			<!-- 相关数据列表 -->
			<div class="list-group listview listview-header parentList" style="margin: 2px;margin-bottom: 30px;">
			</div>
			<div id="phonebook-btn" class="flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				<input class="btn btn-block parentbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>
			<div style="width:100%;text-align:center;display:none;" id="div_next">
					<a href="javascript:void(0)" onclick="topage('next')">
					<img  src="<%=path%>/image/nextpage.png" width="32px" >
				</a>
			</div>
		</div>
	</div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br><br><br><br>
</body>
</html>