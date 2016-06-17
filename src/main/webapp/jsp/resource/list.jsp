<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />

<script type="text/javascript">
	var delList = "";//删除id列表
	var num=0;//选择计数器
	var currId="";//当前点击的id
	var isDel = false;//是否点击的删除
	var isTag = false;//是否点击的标签
    //新增文章
	function add()
    {
		//window.location.href="<%=path%>/operorg/list?source=Resource&redirectUrl=" + encodeURIComponent('/resource/add');
		window.location.href="<%=path%>/resource/add";
	}
	
	//编辑标签
	function tag()
	{
		if (!isTag)
		{
			isTag = true;
			$(".tagModel").removeClass("none");
		}
		else
		{
			isTag = false;
			$(".tagModel").addClass("none");
		}
	}
	
	//选择粘贴链接
	function copyLink()
	{
		cancel();
		
		$(".copy").removeClass("none");
		$(".g-mask").addClass("none");

		$(".dropdown-menu-group").addClass("none");
		$("#resContaint").addClass("none");
		$("#opArea").css("display","none");
		$("#copyUrl").val("http://");
		
		$(".searchCmd").removeClass("tabselected");
		$(".copyCmd").addClass("tabselected");
		$(".delCmd").removeClass("tabselected");
		
		$(".nodata").css("display","none");
		$("#sysContaint").addClass("none");
		copy();
	}
	
	//保存
	function save()
	{
		var copyUrl = $("#copyUrl").val();
		//检验链接是否有效
		if(!netPing(copyUrl))
		{
			$(".myMsgBox").css("display","").html("粘贴的链接错误或该链接已失效");
	    	$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		
		$(".copy").addClass("none");
		$("#resContaint").css("opacity","1");
		
		if ($("#resContaint").hasClass("none"))
		{
			$("#resContaint").removeClass("none");
		}
		$("#opArea").css("display","");
		
		//检验通过后继续提交后台
		$.ajax({
	  	      type: 'post',
	  	      url: '<%=path%>/resource/asynsave',
	  	      data: {url: copyUrl},
	  	      dataType: 'text',
	  	      success: function(data){
	  	    	    if(!data) return;
	  	    	    var d = JSON.parse(data);
	  	    	    if(d.errorCode && d.errorCode == '0')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("添加资料库成功");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
			    	}
	  	    	    else
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("添加资料库失败，可能已存在");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
		   	    		return;
	  	    	    }
	  	    	    
	  	    	    window.location.href = '<%=path%>/resource/list';
	  	      }
  	 	});
	}
	
	//清除文本域，隐藏以及还原列表
	function cleanTextArea()
	{
		$(".copy").addClass("none");
		$("#copyUrl").val("");
		$("#resContaint").css("opacity","1");
		$("#resContaint").removeClass("none");
		$("#opArea").css("display","");	
		
		$(".searchCmd").removeClass("tabselected");
		$(".copyCmd").removeClass("tabselected");
		$(".delCmd").removeClass("tabselected");
		
		$(".nodata").css("display","");
		$("#sysContaint").removeClass("none");
	}
	
	//获取剪切板内容赋值,目前支持IE
	function copy()
	{
		if (window.clipboardData)
		{
			 var str1=window.clipboardData.getData("Text");
			 document.getElementById("copyUrl").value = str1;
		}
	}
	
	//初始化
	$(function(){
		  $(".resourceUrlList").click(function(){
			    if(!isDel && !isTag)
			    {
				    var url = $(this).attr("resourceUrl");
				    var id = $(this).attr("id");
				    var type = $(this).attr("resourceType");
				    var isSys = $(this).attr("isSys");
				    $(":hidden[name=resurl]").val(url);
				    $(":hidden[name=id]").val(id);
				    $(":hidden[name=restype]").val(type);
				    $(":hidden[name=isSys]").val(isSys);
				    $("form[name=resourceForm]").submit();
			    }
		  });
		  
		  initForm();
		  
		  $(".submitBtn").click(function(){
			  save();
		  });
		  $(".copyBtn").click(function(){
			  copy();
		  });
		  $(".delBtn").click(function(){
			  delRes();
		  })
		  $(".cancelBtn").click(function(){
			  cancel();
		  })
		  $(".cancelCopyBtn").click(function(){
			  cleanTextArea();
		  })
		  
		  $("#rightNavbox").click(function(){
			  $("#more_res_praise").css("display","");
			  $("#more_list_res_praise").css("display","none");
			  $("#rightNavbox").addClass("none")
		  })
		  
		   $("#sysNavbox").click(function(){
			   goToSys();
		  })
		  
		  //如果没有图片内容则直接将描述居左显示
		  /* $(".myContent").each(function(){
			  var imgs = $(this).parent().find("img");
			  if (imgs && imgs.length>0)
			  {
				  $(this).css("padding-left","5");
			  }
			  else
			  {
				  $(this).css("padding-left","0");
			  } 
		  });
		  $(".sysContent").each(function(){
			  var imgs = $(this).parent().find("img");
			  if (imgs && imgs.length>0)
			  {
				  $(this).css("padding-left","5");
			  }
			  else
			  {
				  $(this).css("padding-left","0");
			  } 
		  }); */
		  
		  //如果没有查询到数据，则将列表区域遮蔽
		  if('${resListSize}' == '0')
		  {
              $("#resContaint").css("min-height","1%");
              $("#resContaint").css("display","none");
              $(".nodata").css("min-height","25%");
		  }
		  
		  if('${source}')
		  {
			  $("#sysNavbox").css("display","none");
		  }
		  
		  loadTag();
	});
	
	//判断输入的链接是否有效
	function netPing(url) 
	{
		var check = url.match(/http:\/\/.+/); 
		if (check == null)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	//初始化表单
	function initForm(){
		$(".menu-group").click(function() {
			if ($(".dropdown-menu-group").hasClass("none")) {
				$(".dropdown-menu-group").removeClass("none");
				$(".g-mask").removeClass("none");
			} else {
				$(".dropdown-menu-group").addClass("none");
				$(".g-mask").addClass("none");
			}
		});
		$(".g-mask").click(function() {
			$(".dropdown-menu-group").addClass("none");
			$(".g-mask").addClass("none");
		});
		
		/* $("#resContaint").css("min-height",($(window).height() - 120)/2);
		$("#sysContaint").css("min-height",($(window).height() - 120)/2); */
		
/* 		$("#resContaint").css("min-height","40%");
		$("#sysContaint").css("min-height","40%"); */
	}
	
	//搜索符合条件的资料
	function searchResource(param)
	{
		if (param)
		{
			$(":hidden[name=modelId]").val(param);
		}
		else
		{
			var searchContent = $("input[name=search]").val();
			 $(":hidden[name=resourceInfo3]").val(searchContent);
		}
		
		 $("form[name=resourceForm]").attr("action","<%=path%>/resource/list");
		 $("form[name=resourceForm]").submit();
	}
	
	//显示删除
	function showDel()
	{
		if ('${resListSize}' == '0')
		{
			$(".myMsgBox").css("display","").html("您还没有任何文章，无法使用删除，请添加文章后使用");
	    	$(".myMsgBox").delay(2000).fadeOut();
		}
		else
		{
			cleanTextArea();
			
			var child = $(".navbar");
			child.parent().find(".delImg").css("display","");
			$(".dropdown-menu-group").addClass("none");
			$(".g-mask").addClass("none");
			$(".mybtn").css("display","");
			//$(".mysearch").css("display","none");
			$(".mysearch").addClass("modal");
			$(".resource_list_div").css("padding-left","50px");
			isDel = true;
			
			$(".searchCmd").removeClass("tabselected");
			$(".copyCmd").removeClass("tabselected");
			$(".delCmd").addClass("tabselected");
			
			$("#sysContaint").addClass("none");
		}
	}

	//增加一个删除id
	function addDel(id)
	{
		//点击时先判断是否已经点击过
		if (delList != "")
		{
			var addFlag = false;
			var ids = delList.substring(0,delList.length-1).split(",");
			for (var i=0;i<ids.length;i++)
			{
				if (id == ids[i])
				{
					addFlag = true;
					currId = id;
					break;
				}
			}
			
			if (!addFlag)
			{
				//如果未点击过，则正常处理
				delList = delList + id + ",";
				$("#" + id + "_image").attr("src","<%=path%>/image/selected.png");
				
				num = num + 1;
				$("#selectNum").removeClass("none");
				$("#selectNum").html(" (" + num + ")");
			}
			else
			{
				//已点击过再次点击，则认为是反选
				$("#" + id + "_image").attr("src","<%=path%>/image/unselect.png");
				
				num = num - 1;
				$("#selectNum").removeClass("none");
				$("#selectNum").html(" (" + num + ")");
				//重组已选择的ids
				delList = "";
				for (var j=0;j<ids.length;j++)
				{
					if (currId == ids[j])
					{
						continue;
					}
					delList += ids[j] + ",";
				}
			}
		}
		else
		{
			//如果未点击过，则正常处理
			delList = delList + id + ",";
			$("#" + id + "_image").attr("src","<%=path%>/image/selected.png");
			
			num = num + 1;
			$("#selectNum").removeClass("none");
			$("#selectNum").html(" (" + num + ")");
		}
	}
	
	//批量删除资料
	function delRes()
	{
		if(delList != "")
		{
			$.ajax({
		  	      type: 'post',
		  	      url: '<%=path%>/resource/del',
		  	      data: {delIds: delList, type:'mulit'},
		  	      dataType: 'text',
		  	      success: function(data){
		  	    	    if(!data) return;
		  	    	    var d = JSON.parse(data);
		  	    	    if(d.errorCode && d.errorCode == '0')
		  	    	    {
		  	    	    	$(".myMsgBox").css("display","").html("删除资料成功");
			   	    		$(".myMsgBox").delay(2000).fadeOut();
			   	    	    //删除完成后清空全局变量
			   				delList = "";
			   				$(".resource_list_div").css("padding-left","0px");
				    	}
		  	    	    else
		  	    	    {
		  	    	    	$(".myMsgBox").css("display","").html("删除资料失败");
			   	    		$(".myMsgBox").delay(2000).fadeOut();
			   	    	    //删除完成后清空全局变量
			   				delList = "";
			   	    		return;
		  	    	    }
		  	    	    
		  	    	    window.location.href = '<%=path%>/resource/list';
		  	      }
		 	});
		}
		else
		{
			$(".myMsgBox").css("display","").html("没有选择任何文章进行删除");
    		$(".myMsgBox").delay(2000).fadeOut();
    		return;
		}
		
		$(".mybtn").css("display","none");
		$(".mysearch").css("display","");
		var child = $(".navbar");
		child.parent().find(".delImg").css("display","none");
	}
	
	//取消删除
	function cancel()
	{
		$(".mybtn").css("display","none");
		$(".mysearch").css("display","");
		var child = $(".navbar");
		child.parent().find(".delImg").css("display","none");
		if (delList != "")
		{
			var idStr = delList.substring(0,delList.length-1);
			var ids = idStr.split(",");
			for (var i=0;i<ids.length;i++)
			{
				$("#" + ids[i] + "_image").attr("src","<%=path%>/image/unselect.png");
			}
			
			delList = "";
		}
		
		$("#selectNum").addClass("none");
		$("#selectNum").html("");
		if (num > 0)
		{
			num = 0;
		}
		$(".resource_list_div").css("padding-left","0px");
		isDel = false;
		
		$("#sysContaint").removeClass("none");
	}
	
	function searchRes()
	{
		if ('${resListSize}' == '0')
		{
			//$(".myMsgBox").css("display","").html("您还没有任何文章，无法使用筛选，请添加文章后使用");
			$(".myMsgBox").delay(2000).fadeOut();
			$(".mysearch").removeClass("modal");
			$(".nodata").css("display","none");
			$("#sysContaint").addClass("none");
			$(".sysnodata").css("display","none");
		
		}
		else
		{
			if($(".mysearch").hasClass("modal"))
			{
				$(".mysearch").removeClass("modal");
				$("#resContaint").addClass("none");
				$("#sysContaint").addClass("none");
				$(".mybtn").css("display","none");
				
				$(".searchCmd").addClass("tabselected");
				$(".copyCmd").removeClass("tabselected");
				$(".delCmd").removeClass("tabselected");
			}
			else
			{
				$(".mysearch").addClass("modal");
				$("#resContaint").removeClass("none");
				$("#sysContaint").removeClass("none");
				
				$(".searchCmd").removeClass("tabselected");
				$(".copyCmd").removeClass("tabselected");
				$(".delCmd").removeClass("tabselected");
			}
			
			$(".copy").addClass("none");
			$(".g-mask").addClass("none");
			$("#opArea").css("display","");
			var child = $(".navbar");
			child.parent().find(".delImg").css("display","none");
			
		}
	}
	
	function redirect(id)
	{
		if (isDel)
		{
			addDel(id);
			return false;
		}
	}
	
	//跳转到系统文章列表
	function goToSys()
	{
		window.location.href = '<%=path%>/resource/syslist';
	}
	
	//加载标签
	function loadTag()
	{
    	$(".resource_tag").click(function(){
    		isTag = true;
    		var obj = $(this);
    		var tagMap = new TAKMap();
    		var relaId= $(this).attr("tag_rela_id");
    		tagMap.put("res_rela_id",relaId);
    		$(this).find(".resource_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'resource_tag',{
        		success: function(res){
        			if(res){
        				obj.empty();
        				//obj.append('<img  src="<%=path%>/image/tags_list.png" style="width: 20px;">&nbsp;&nbsp;');
        				res.each(function(key,value,index){ 
        					obj.append('<a class="resource_tag_item" href="javsscript:void(0)" style="color: #00D1DA;" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        				
        				if(!$.trim(obj.html()))
        				{
        					obj.empty();
        					obj.append('<font color="darkgray">编辑标签</font>');
        				}

        				isTag = false;
        			}
        		}
        	});
    	});
	}
	
	//选择标签
	function selectTagSearch(obj)
	{
		var modelId = obj.attr("key");
		searchResource(modelId);
	}
</script>
<style>
.tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
.dropdown-menu-group {
	font-size: 14px;
	position: fixed;
	width: 150px;
	right: 2px;
	left: 50%;
	top: 50%;
	text-align: left;
	z-index: 999;
	height:183px;
	margin: -150px 0px 0px -75px;
	line-height: 45px;
	background-color: RGB(75, 192, 171);
	-webkit-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-moz-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-ms-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-o-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
}
.dropdown-menu-group li {
	white-space: nowrap;
	margin-left: 10px;
	font-weight: 900;
	word-wrap: normal;
	border-bottom: 1px solid #365a7e;
}

.dropdown-menu-group li a {
	color: #fff
}
.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}

</style>
</head>
<body style="font-size:14px;">
	<div style="padding-bottom:15px">
	<!-- 从资源模块本身进入 -->
	<c:if test="${source eq '' }">
		<div id="site-nav" class="navbar none" ></div>
		<div id="site-nav" class="resource_menu zjwk_fg_nav">
		    <a href="javascript:void(0)" onclick='searchRes()' style="padding:5px 8px;" class="searchCmd">筛选</a>
		    <a href="javascript:void(0)" onclick='copyLink()' style="padding:5px 8px;" class="copyCmd">复制链接</a>
		    <a href="javascript:void(0)" onclick="showDel()" style="padding:5px 8px;" class="delCmd">删除</a>
		    <a href="javascript:void(0)" onclick='add()' style="padding:5px 8px;">发表文章</a>
		</div>
		<div style="clear: both"></div>
		<!-- 搜索区域 -->
		<div style="width:100%;line-height:50px;background-color:#fff;" id="opArea">
			<div style="height:150px;padding-top:3px;margin-right: 55px;padding-left:5px;margin-bottom: 5px;" class="mysearch modal"> 
				<div class="myinput">
					<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.5;width:30px;margin-left: 5px;right:15px" onclick="searchResource()">
					<input type="text"  value="" placeholder="按标题、描述" name="search" style="border-radius: 10px;font-size: 14px;padding-left:10px;border: 1px solid #ddd;line-height: 30px;">
				</div>
				<div style="clear: both"></div>
				<div style="background-color:#eee;width: 100%;min-height: 1px;margin-top: 5px;"></div>
				<div style="clear: both"></div>
				<div class="mytag" style="min-height: 30px;line-height: 30px;width: 100%;height: auto!important;word-break: break-all;">
					<c:if test="${fn:length(allResTag) >0}">
						<c:forEach items="${allResTag}" var="restag" >
							<a onclick="selectTagSearch($(this))" key="${restag.modelId}" href="javascript:void(0)">${restag.tagName }</a>&nbsp;&nbsp;
						</c:forEach>
					</c:if>
				</div>
			</div>
			<div class="button-ctrl mybtn" style="display: none;text-align:center;">
				<a href="javascript:void(0)" class="btn btn-default cancelBtn"
							style="font-size: 14px;padding: 0px 15px;height: 30px;line-height: 30px;"> 取消</a>
				<a href="javascript:void(0)" class="btn delBtn"
							style="font-size: 14px;padding: 0px 15px;height: 30px;line-height: 30px;"> 删除<label id="selectNum" class="none">0</label></a>
			</div>
		</div>
		<div class="copy none" style="margin: 8px;">
			<textarea id="copyUrl" style="" rows="10" placeholder="在此输入链接"></textarea>
			<div class="button-ctrl">
				<fieldset class="">
					<div class="ui-block-a" style="width: 50%;padding: 0px 3em;">
						<a href="javascript:void(0)" class="btn btn-block btn-default cancelCopyBtn"
							style="font-size: 16px;"> 取消</a>
					</div>
					<div class="ui-block-a" style="width: 50%;padding: 0px 3em;">
						<a href="javascript:void(0)" class="btn btn-block submitBtn"
							style="font-size: 16px;"> 保存</a>
					</div>
				</fieldset>
			</div>
		</div>
		<div style="clear: both"></div>
		<form name="resourceForm" action="<%=path%>/resource/detail" method="post">
			<input type="hidden" name="resurl" value="">
			<input type="hidden" name="restype" value="">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="resourceInfo3" value="">
			<input type="hidden" name="isSys" value="">
			<input type="hidden" name="sysIdList" value="">
			<input type="hidden" name="modelId" value="">
		</form>
		<div style="width:100%;" id="resContaint"> 
			<div style="line-height: 25px;padding:0px 10px;background-color:#eee;margin-top: -9px;">我的文章</div>
			<c:if test="${fn:length(resList) >0 }">
				<c:forEach items="${resList}" var="res" varStatus="resIndex">
				<c:if test="${resIndex.index == 3}">
				<!-- <div id="more_res_praise" style="line-height: 20px;background-color: #FAFAFA;text-align: right;"><a href="javascript:void(0)" style="float: right;margin-right: 10px;color:#078E46;"
						onclick='$("#more_res_praise").css("display","none");$("#more_list_res_praise").css("display","initial");$("#rightNavbox").removeClass("none");'>更多 ></a></div> -->
			<div style="clear: both"></div>
			 <div id="more_res_praise" style="line-height: 20px;background-color: #FAFAFA;text-align: right;padding-right: 10px;"><a href="#" style="color:#078E46;"
			 onclick='$("#more_res_praise").css("display","none");$("#more_list_res_praise").css("display","initial");$("#rightNavbox").removeClass("none");'>更多></a></div>
			 <div style="clear: both"></div>		
			<div id="more_list_res_praise" style="display: none;float: inherit;">
					
				</c:if>
				<c:if test="${resIndex.index >= 3}">
					<img src="<%=path%>/image/unselect.png" class="delImg" onclick="addDel('${res.resourceId}')" id="${res.resourceId}_image" style="float:left;cursor:pointer;display:none;height: 25px;width: 25px;position: relative;top: 30px;left: 2px;">
					<a href="javascript:void(0)" onclick="return redirect('${res.resourceId}')"  resourceUrl="${res.resourceUrl}" resourceType="${res.resourceType }" class="resourceUrlList" id="${res.resourceId}">
						<div style="background-color:#fff;width:100%;">
							<c:if test="${res.resourceImg ne '' && !empty(res.resourceImg) }">
								<div style="float:left;width:85px;padding:5px;">
									<div style="background:url(<%=ossImgPath%>}/${res.resourceImg}) no-repeat;height:70px;width:70px;background-size: cover;"></div>
								</div>
								<div>
									<div style="font-size:16px;padding-top:5px;min-height:50px;line-height:25px;">
										<c:if test="${fn:length(res.resourceTitle) > 30}">
											${fn:substring(res.resourceTitle,0,30)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 30}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;">
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div class="resource_tag" tag_rela_id="${res.resourceId }"  style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px 0px 0px;height: auto!important;word-break: break-all;">
											<c:if test="${fn:length(res.tagList) >0}">
												<c:forEach items="${res.tagList}" var="restag" varStatus="stat">
													<c:if test="${stat.index <2 }">
														<a class="resource_tag_item" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>&nbsp;&nbsp;
													</c:if>
												</c:forEach>
												<c:if test="${stat.index >= 2 }">
													<a class="resource_tag_item none" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>
												</c:if>
												<c:if test="${fn:length(res.tagList) > 2 }">
													...
												</c:if>
												
											</c:if>
											<c:if test="${fn:length(res.tagList) ==0}">
												<a><font color="darkgray">编辑标签</font></a>
											</c:if>
											
										</div>
										<div style="float:left;min-height: 25px;line-height: 25px;">&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }</div>
									</div>
								</div>
							</c:if>	
							<c:if test="${res.resourceImg eq '' || empty(res.resourceImg) }">
								<div>
									<div style="font-size:16px;padding:5px 10px;min-height:40px;line-height:25px;">
										<c:if test="${fn:length(res.resourceTitle) > 30}">
											${fn:substring(res.resourceTitle,0,30)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 30}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;padding-left:40px;">
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div class="resource_tag" tag_rela_id="${res.resourceId }"  style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px 0px 0px;height: auto!important;word-break: break-all;">
											<c:if test="${fn:length(res.tagList) >0}">
												<c:forEach items="${res.tagList}" var="restag" varStatus="stat">
													<c:if test="${stat.index <2 }">
														<a class="resource_tag_item" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>&nbsp;&nbsp;
													</c:if>
												<c:if test="${stat.index >= 2 }">
													<a class="resource_tag_item none" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>
												</c:if>
												</c:forEach>
												<c:if test="${fn:length(res.tagList) > 2 }">
													...
												</c:if>
											</c:if>
											<c:if test="${fn:length(res.tagList) ==0}">
												<a><font color="darkgray">编辑标签</font></a>
											</c:if>
											
										</div>
										<div style="float:left;min-height: 25px;line-height: 25px;">&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }</div>
									</div>
								</div>
							</c:if>
							<div style="clear:both;"></div>
						</div>
						<div style="clear:both;"></div>
						<div style="height: 1px;background-color:#F6F6F6;"></div>
					</a>	
				</c:if>
				<c:if test="${resIndex.index < 3}">
					<img src="<%=path%>/image/unselect.png" class="delImg" onclick="addDel('${res.resourceId}')" id="${res.resourceId}_image" style="float:left;cursor:pointer;display:none;height: 25px;width: 25px;position: relative;top: 30px;left: 2px;">
					<a href="javascript:void(0)" onclick="return redirect('${res.resourceId}')"  resourceUrl="${res.resourceUrl}" resourceType="${res.resourceType }" class="resourceUrlList" id="${res.resourceId}">
						<div style="background-color:#fff;width:100%;">
							<c:if test="${res.resourceImg ne '' && !empty(res.resourceImg) }">
								<div style="float:left;width:85px;padding:5px;">
									<div style="background:url(<%=ossImgPath%>/${res.resourceImg}) no-repeat;height:70px;width:70px;background-size: cover;"></div>
								</div>
								<div>
									<div style="font-size:16px;padding-top:5px;min-height:50px;line-height:25px;">
										<c:if test="${fn:length(res.resourceTitle) > 30}">
											${fn:substring(res.resourceTitle,0,30)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 30}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;padding-left:40px;">
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div class="resource_tag" tag_rela_id="${res.resourceId }"  style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px 0px 0px;height: auto!important;word-break: break-all;">
											<c:if test="${fn:length(res.tagList) >0}">
												<c:forEach items="${res.tagList}" var="restag" varStatus="stat">
													<c:if test="${stat.index <2 }">
														<a class="resource_tag_item" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>&nbsp;&nbsp;
													</c:if>
												<c:if test="${stat.index >= 2 }">
													<a class="resource_tag_item none" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>
												</c:if>
												</c:forEach>
												<c:if test="${fn:length(res.tagList) > 2 }">
													...
												</c:if>
											</c:if>
											<c:if test="${fn:length(res.tagList) ==0}">
												<a><font color="darkgray">编辑标签</font></a>
											</c:if>
											
										</div>
										<div style="float:left;min-height: 25px;line-height: 25px;">&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }</div>
									</div>
								</div>
							</c:if>	
							<c:if test="${res.resourceImg eq '' || empty(res.resourceImg) }">
								<div style="float:left;width:85px;padding:5px;">
									<img src="<%=path%>/image/noneimg.jpg"  width="70px" height="70px" />
								</div>
								<div>
									<div style="font-size:16px;padding:5px 50px;min-height:50px;line-height:25px;">
										<c:if test="${fn:length(res.resourceTitle) > 30}">
											${fn:substring(res.resourceTitle,0,30)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 30}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;padding-left:40px;">
										
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div class="resource_tag" tag_rela_id="${res.resourceId }"  style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px 0px 0px;height: auto!important;word-break: break-all;">
											<c:if test="${fn:length(res.tagList) >0}">
												<c:forEach items="${res.tagList}" var="restag" varStatus="stat">
													<c:if test="${stat.index <2 }">
														<a class="resource_tag_item" key="${restag.id }" href="javascript:void(0)" style="color: blue;"><font style="">${restag.tagName }</font></a>&nbsp;&nbsp;
													</c:if>
												</c:forEach>
												<c:if test="${fn:length(res.tagList) > 2 }">
													...
												</c:if>
											</c:if>
											<c:if test="${fn:length(res.tagList) ==0}">
												<a><font color="darkgray">编辑标签</font></a>
											</c:if>
											
										</div>
										<div style="float:left;min-height: 25px;line-height: 25px;">&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }</div>
									</div>
								</div>
							</c:if>
							<div style="clear:both;"></div>
						</div>
						
						<div style="clear:both;"></div>
						<div style="height: 1px;background-color:#F6F6F6;"></div>
					</a>
				</c:if>
				<div style="clear: both"></div>
			</c:forEach>
			</c:if>
			</div>
			<c:if test="${fn:length(resList) ==0 }">
				<div  style="text-align: center; padding-top: 50px;font-size:14px;color:#999;margin-top: 50px;" class="nodata">没有找到数据，您可以点击<a href="javascript:void(0)" onclick='copyLink()'><font color="blue">复制链接</font></a>或<a href="javascript:void(0)" onclick='add()' ><font color="blue">新增</font></a>添加文章</div>
			</c:if>

		<div style="clear: both;"></div>
		<div style="margin-top: 50px"></div>
		<!-- 系统推荐 -->
		<div style="width:100%;margin-bottom: 50px;" id="sysContaint" >
				<div style="line-height: 25px;padding:0px 10px;background-color:#eee;">系统推荐</div>
			   <c:if test="${fn:length(sysList) >0 }">
			   	 <c:forEach items="${sysList}" var="res" varStatus="sysIndex">
			   	 	<c:if test="${sysIndex.index < 3 }">
				   	 	<a href="javascript:void(0)" onclick="return redirect('${sys_res.resourceId}')"  resourceUrl="${res.resourceUrl}" resourceType="${res.resourceType }" class="resourceUrlList" id="${res.resourceId}" isSys="1">
							<div style="background-color:#fff;width:100%;">
								<c:if test="${res.resourceImg ne '' && !empty(res.resourceImg) }">
									<div style="float:left;width:85px;padding:5px;">
										<div style="background:url(<%=ossImgPath%>/${res.resourceImg}) no-repeat;height:70px;width:70px;background-size: cover;"></div>
									</div>
									<div>
										<div style="font-size:16px;padding-top:5px;min-height:50px;line-height:25px;">
											<c:if test="${fn:length(res.resourceTitle) > 30}">
												${fn:substring(res.resourceTitle,0,30)}...
											</c:if>
											<c:if test="${fn:length(res.resourceTitle) <= 30}">
												${res.resourceTitle}
											</c:if>
										</div>
										<div style="font-size: 10px;color: #AAA;padding-left:40px;">
											<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
											<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;">
												推荐人：<a href="<%=path %>/businesscard/detail?partyId=${res.creator }">${res.createName }</a>
												&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
											</div>
										</div>
									</div>
								</c:if>	
								<c:if test="${res.resourceImg eq '' || empty(res.resourceImg) }">
									<div style="float:left;width:85px;padding:5px;">
										<img src="<%=path%>/image/noneimg.jpg"  width="70px" height="70px" />
									</div>
									<div>
										<div style="font-size:16px;padding:5px 50px;min-height:50px;line-height:25px;">
											<c:if test="${fn:length(res.resourceTitle) > 30}">
												${fn:substring(res.resourceTitle,0,30)}...
											</c:if>
											<c:if test="${fn:length(res.resourceTitle) <= 30}">
												${res.resourceTitle}
											</c:if>
										</div>
										<div style="font-size: 10px;color: #AAA;">
											
											<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
											<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;">
												推荐人：<a href="<%=path %>/businesscard/detail?partyId=${res.creator }">${res.createName }</a>
												&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
											</div>
										</div>
									</div>
								</c:if>
								<div style="clear:both;"></div>
							</div>
							<div style="clear:both;"></div>
							<div style="height: 1px;background-color:#F6F6F6;"></div>
						</a>
					</c:if>
				 	<div style="clear: both"></div>
				</c:forEach>
			 </c:if>
			 <div style="clear: both"></div>
			 <div style="line-height: 20px;background-color: #FAFAFA;text-align: right;padding-right: 10px;" id="sysNavbox"><a href="#" style="color:#078E46;">更多推荐></a></div>
			 <div style="clear: both"></div>
		</div>
			<c:if test="${fn:length(sysList) ==0 }">
				<div class="sysnodata" style="text-align: center; padding-top: 50px;font-size:14px;color:#999;">没有找到数据</div>
			</c:if>
	</c:if>
	<!-- 从讨论组模块进入 -->
	<c:if test="${source ne '' }">
	    <div id="site-nav" class="navbar none" ></div>
		<div style="width:100%;padding:5px 8px 5px 0px;" id="resContaint">
			<c:if test="${fn:length(resList) >0 }">
			<c:forEach items="${resList}" var="res">
				<a href="javascript:void(0)"  resourceUrl="${res.resourceUrl}" class="chooseA" id="${res.resourceId}">
					<div class="resource_list_div" style="background-color: #fff;margin-bottom:5px;">
					
						<c:if test="${res.resourceImg ne '' && !empty(res.resourceImg) }">
							<div style="float:left;width:85px;padding:5px;">
								<div style="background:url(<%=ossImgPath%>/${res.resourceImg}) no-repeat;height:70px;width:70px;background-size: cover;"></div>
							</div>
							<div>
								<div style="font-size:16px;padding:0 10px;min-height:50px;line-height:25px;text-align:left;" id="${res.resourceId}_topic">
									<div class="massgouxuanbtn check-radio" style="float: right;margin: 10px 10px 10px 20px;" rowid="${res.resourceId}"></div>
									<c:if test="${fn:length(res.resourceTitle) > 30}">
										${fn:substring(res.resourceTitle,0,30)}...
									</c:if>
									<c:if test="${fn:length(res.resourceTitle) <= 30}">
										${res.resourceTitle}
									</c:if>
								</div>
								<div style="font-size: 10px;color: #AAA;padding-left:40px;">
									<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
									<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;text-align:left;">
										&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
									</div>
								</div>
							</div>
						</c:if>	
						<c:if test="${res.resourceImg eq '' || empty(res.resourceImg) }">
							<div>
								<div style="font-size:16px;padding:0px 10px;min-height:40px;line-height:25px;text-align:left;" id="${res.resourceId}_topic">
									<div class="massgouxuanbtn check-radio" style="float: right;margin: 10px 10px 10px 20px;" rowid="${res.resourceId}"></div>
									<c:if test="${fn:length(res.resourceTitle) > 30}">
										${fn:substring(res.resourceTitle,0,30)}...
									</c:if>
									<c:if test="${fn:length(res.resourceTitle) <= 30}">
										${res.resourceTitle}
									</c:if>
								</div>
								<div style="font-size: 10px;color: #AAA;">
									<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
									<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;text-align:left;">
										&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
									</div>
								</div>
							</div>
						</c:if>
						<div style="clear:both;"></div>
						<div style="height: 1px;background-color:#F6F6F6;"></div>
					</div>
				</a>
				<div style="clear: both"></div>
			</c:forEach>
			</c:if>
			<c:if test="${fn:length(resList) ==0 }">
				<div style="text-align: center; padding-top: 50px;font-size:14px;color:#999;">没有找到数据</div>
			</c:if>
		</div>
	</c:if>
	</div>
	<div class="g-mask none">&nbsp;</div>
	
	<jsp:include page="/common/menu.jsp"></jsp:include>
	
	<jsp:include page="/common/rela/tag.jsp">
		<jsp:param value="resource" name="reqSource"/>
	</jsp:include>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>