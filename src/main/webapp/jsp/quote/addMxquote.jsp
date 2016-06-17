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
		
		var p={};
		//初始化dom节点
		function initDom(){
			p.fstChar = $(":hidden[name=fstChar]");
			p.seachUrl=$(":hidden[name=seachUrl]");
			p.currPage=$(":hidden[name=currPage]");
			p.pageCount=$(":hidden[name=pageCount]");
			p.currType=$(":hidden[name=currType]");
			p.productid=$(":hidden[name=productid]");
			p.productname=$("input[name=productname]");
			p.productamount=$("input[name=productamount]");
		}
		
		//初始化表单按钮和控件
		function initForm(){
			//相关选择事件
			$(".parentChoose").click(function(){
				var v = $(this).attr("val");
				var type="productList";
				var url='<%=path%>/product/asylist';
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
				var parentId='', parentName='',price='';
				$(".parentList > a.checked").each(function(){
					parentId = $(this).find(":hidden[name=parentId]").val();
					parentName = $(this).find(":hidden[name=parentName]").val();
					price = $(this).find(":hidden[name=price]").val();
				});
				if(''==parentId){
					$(".myMsgBox").css("display","").html("产品不能为空,请选择产品!");
	    	    	$(".myMsgBox").delay(2000).fadeOut();
	  				return true;
				}
				p.productid.val(parentId);
				p.productname.val(parentName);
				p.productamount.val(price);
				$(".parentGoBak").trigger("click");
			});
			
			//相关数据返回点击事件
			$(".parentGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#parent-more").addClass("modal");
			});
			
			//直接保存
			$(".submitBtn").click(function(){
				$(":hidden[name=mxquoteflag]").val('end');
				if(!validates()){
					$("form[name=quoteform]").submit();
				}
			});
			
			//保存并继续添加
			$(".submitToOtherBtn").click(function(){
				$(":hidden[name=mxquoteflag]").val('continue');
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
    		      data: {orgId:'${orgId}',crmId: '${crmId}',openId:'${openId}',publicId:'${publicId}',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
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
			  	    	  	$("#div_next").css("display",'none');
			  	    	  	if('1'==currpage){
		  	    	  			$(".parentList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
			  	    	  	}
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
   								val +='<a href="javascript:void(0)" class="list-group-item listview-item radio">'
	   									+'<div class="list-group-item-bd">'
	   									+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
	   									+'<input type="hidden" name="price" value="'+this.price+'"/>'
	   							        +'<input type="hidden" name="parentName" value="'+this.name+'"/><h1 class="title">'+this.name+'&nbsp;<span '
	   									+'style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1><p class="text-default">'
	   									+'开始时间：'+this.startdate+'&nbsp;&nbsp;&nbsp;&nbsp;结束时间：'+this.enddate+'</p>'
	   									+'产品价格：￥'+this.price+'元&nbsp;&nbsp;&nbsp;&nbsp;产品类型：'+this.type+'</p>'
	   									+'</div><div class="input-radio" title="选择该条记录"></div></a>';
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
	    	if(parenttype == "Product"){
	    		scheduleReleation("productList");
	    	}
	    }
	  	
	  	//验证所有的参数是否都已经填写
	  	function validates(){
  			var flag= false ;
  			var productnumber = $("input[name=productnumber]");
  			var exp = /^([1-9][0-9]*)$/;
  			if(!exp.test(productnumber.val())){
  				$(".myMsgBox").css("display","").html("请输入正确的产品数量!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
  				return true;
  			}
	  		$("#quoteform").find(":hidden").each(function(){
	  			var val=$(this).val();
	  			var name=$(this).attr("name");
	  			if('opptyId'!=name&&!val){
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
			<h3 style="padding-right:45px;">创建报价明细</h3>
		</div>
		<input type="hidden" name="currType" />
	    <input type="hidden" name="seachUrl" />
	    <input type="hidden" name="fstChar" />
	    <input type="hidden" name="currPage" value="1" />
	    <input type="hidden" name="pageCount" value="10" />
		<input type="hidden" name="flag" value=""/>
		<div class="wrapper">
			<form id="quoteform" name="quoteform" action="<%=path%>/quote/saveMxquote" method="post"  >
			    <input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="parentid" value="${parentId}" /> 
				<input type="hidden" name="opptyId" value="${opptyId}" /> 
				<input type="hidden" name="assignerid" value="${crmId}" /> 
				<input type="hidden" name="productid" value="" /> 
				<input type="hidden" name="productamount" value="" /> 
				<input type="hidden" name="mxquoteflag" value="" /> 
				<input type="hidden" name="source" value="${source}" /> 
				<input type="hidden" name="orgId" value="${orgId}" /> 
				<!-- 相关产品 -->
				<div class="form-group">
					<label class="control-label" for="parent">产品名称&nbsp;<span style="color:red;">*</span></label>
					<input name="productname" id="productname" val="Product" type="text" 
					       class="form-control parentChoose" value=""  placeholder="【点击  选择相关产品】  >>  " readonly="readonly" >
				</div>
				<!-- 产品数量 -->
				<div class="form-group">
					<label class="control-label" >产品数量&nbsp;<span style="color:red;">*</span></label>
					<input name="productnumber" id="productnumber" value="" type="text"
						class="form-control" placeholder="请输入产品数量"/>
				</div>
				<div class="button-ctrl">
					<fieldset class="">
							<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">
							   保存</a>
						</div>
						<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitToOtherBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">保存并继续</a>
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