<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<!-- css -->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" />
 <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
 <style>
 	.none {
		display: none
	}
 </style>
<script type="text/javascript">
var params="";

$(function () {
	initAproveBtn();//
});

//初始化全选和不全选按钮
function initAproveBtn(){
	
	//若没有好友，则只显示跳过
	var userList = '${isEmpty}';
	if("true"==userList){
		$(".confirmdiv").css("display","none");
		$(".skipdiv").css("width","100%");
	}
	
	//单选或多选
	$("#div_expense_list > a").unbind("click").bind("click", function(){
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
	
	$(".skip").click(function(){
		$("#div_expense_list > a").each(function(){
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}
		});
	});
	
	$(".confirm").click(function(){
		var id="";
		$("#div_expense_list > a.checked").each(function(){
			var userid = $(this).find(":hidden[name=userid]").val();
			var phone = $(this).find(":hidden[name=phonenumber]").val();
			var email = $(this).find(":hidden[name=email]").val();
			var name = $(this).find(":hidden[name=name]").val();
			if ('msg' == '${shareType}')
			{
				if(null!=userid && ''!=userid && null!=phone && ''!=phone)
				{
					params += userid+","+phone+"," +name+";";
				}
			}
			if ('mail' == '${shareType}')
			{
				if(null!=userid && ''!=userid && null!=email && ''!=email)
				{
					params += userid+","+email+"," +name+";";
				}
			}
			
		});
		if(!params){
			$(".myMsgBox").css("display","").html("联系不能为空或已选联系人没有设置电话/邮箱！");
			$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		
		//调用后台异步方法
		gotoShare('${shareType}','${qrCode}','${partyId}');
		//调用完成后清理全局变量
		params = "";
	});
	
	//直接分享
	$(".direct_share").click(function(){
		//取用户输入的手机或邮箱地址
		params = $("input[name=share_address]").val();
		//需要验证邮箱或手机  、、暂未验证
		if(!params){
			$(".myMsgBox").css("display","").html("请输入正确的参数");
 		    $(".myMsgBox").delay(2000).fadeOut();
 		    return;
		}
		else
		{
			var regMail = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/; //验证邮箱
			var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证手机号码
			if ('msg' == '${shareType}')
			{
				if(!regPhone.test(params))
				{
					$(".myMsgBox").css("display","").html("请务必输入正确的手机号码");
		 		    $(".myMsgBox").delay(2000).fadeOut();
			        return false;
				}
			}
			else
			{
				if(!regMail.test(params))
			    {
					$(".myMsgBox").css("display","").html("请输入正确的邮箱地址");
		 		    $(".myMsgBox").delay(2000).fadeOut();
			        return false;
			    }
			}
		}
		directShare('${shareType}','${qrCode}','${partyId}');
	});
	
	//搜索
	$("input[name=search]").keyup(function(){
		searchContact();
	});
	
	$(".listtoinput").click(function(){
		$(".site-recommend-list").addClass("none");
		$(".flooter").addClass("none");
		$(".direct_share_").removeClass("none");
	});
	
	$(".listtoinput2").click(function(){ 
		$(".direct_share_").removeClass("none");
		$(".searchnodata").addClass("none");
	});
	
	$(".inputtolist").click(function(){
		var dataSize = "${fn:length(conList)}";
		$(".direct_share_").addClass("none");
		if(dataSize >0){
			$(".site-recommend-list").removeClass("none");
			$(".flooter").removeClass("none");
		}else{
			$(".searchnodata").removeClass("none");
		}
	});
}
//搜索
function searchContact(){
	var searchContent = $("input[name=search]").val();
	if(searchContent){
		var isSearch = false;
		$(".contact_list_item").css('display',"none");
		$(".contact_list_item").each(function(){
			var name = $(this).find(":hidden[name=name]").val();
			var mobile = $(this).find(":hidden[name=phonenumber]").val();
			if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1){
				isSearch = true;
				$(this).css("display","");
			}
		});
		if(!isSearch){
			$(".nodata").removeClass("none")
		}else{
			$(".nodata").addClass("none");
		}
	}else{
		$(".contact_list_item").css('display',"");
		$(".nodata").addClass("none");
	}
}

//输入内容直接分享
function directShare(shareType,qrCode,partyId)
{
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/businesscard/directShare',
	      data: {params: params, type: shareType, flag:'${isMy}',partyId:partyId},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0')
	    	    {
	    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg + "未成功的联系人" + d.rowId);
	    			$(".myMsgBox").delay(2000).fadeOut();
  	    	   } 
	    	   else
    		   {
	    		   $(".myMsgBox").css("display","").html("分享成功");
	    		   $(".myMsgBox").delay(2000).fadeOut();
	    		   if ('' != qrCode)
	    			{
	    			   window.location.href = "<%=path%>/dcCrm/make?partyId="+partyId;
	    			}
	    		   else
    			   {
	    			   window.location.href = "<%=path%>/businesscard/detail?partyId="+partyId;
    			   }
	    		  
    		   }
	      }
	 });
}


function gotoShare(shareType,qrCode,partyId)
{
	params = params.substr(0,params.length-1);
	
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/businesscard/gotoShare',
	      data: {params: params, type: shareType, flag:'${isMy}',partyId:partyId},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0')
	    	    {
	    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg + "未成功的联系人" + d.rowId);
	    			$(".myMsgBox").delay(2000).fadeOut();
  	    	   } 
	    	   else
    		   {
	    		   $(".myMsgBox").css("display","").html("分享成功");
	    		   $(".myMsgBox").delay(2000).fadeOut();
	    		   if ('' != qrCode)
	    			{
	    			   window.location.href = "<%=path%>/dcCrm/make?partyId="+partyId;
	    			}
	    		   else
    			   {
	    			   window.location.href = "<%=path%>/businesscard/detail?partyId="+partyId;
    			   }
	    		  
    		   }
	      }
	 });
}

</script>
<div id="site-nav" class="navbar" >
	<jsp:include page="/common/back.jsp"></jsp:include>
	<c:if test="${shareType eq 'msg' }">
		<h3 style="padding-right:45px;">短信分享</h3>
	</c:if>
	<c:if test="${shareType eq 'mail' }">
		<h3 style="padding-right:45px;">邮件分享</h3>
	</c:if>
	<div class="act-secondary" >
		<a href="<%=path %>/cbooks/list" style="color:#fff;">
			通讯录
		</a> 
	</div>
</div>
<input type="hidden" name="partyId" value="${partyId}">

<div class="direct_share_ none" style="width:100%;background-color:#fff;padding:10px;line-height:20px;border-bottom:1px solid #ddd;">
	<div style="float:left;width:80%;height: 40px;">
		<c:if test="${shareType eq 'msg' }">
			<input type="text" value="" name="share_address" placeholder="手动输入手机号码分享" style="font-size:14px;border:1px solid #ddd;">
		</c:if>
		<c:if test="${shareType eq 'mail' }">
			<input type="text" value="" name="share_address" placeholder="手动输入邮箱地址分享" style="font-size:14px;border:1px solid #ddd;">
		</c:if>
	</div>
	<div class="direct_share" style="float:left;width: 60px;font-size:14px;color:#fff;margin-left: 5px;text-align: center;background-color: #A29CF5;height: 30px;line-height: 30px;">发送</div>
	<div style="clear:both;"></div>
	<div style="font-size:14px;text-align:center;">
		<a href="javascript:void(0)" class="inputtolist">
			返回列表中选择
		</a>
	</div>
</div>
<div style="clear:both;"></div>

<div class="site-recommend-list page-patch" style="background-color:#fff;min-height:0px;border-bottom:1px solid #ddd;">
	<!-- 搜索区域 -->
	<c:if test="${fn:length(conList) > 0 }">
		<div style="width:100%;line-height:20px;background-color:#fff;padding:5px;border-bottom:1px solid #ddd;">
			<div style="height:44px;padding-top:3px;">
				<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
				<input type="text" value="" placeholder="搜索联系人" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
			</div>
			<div style="font-size:14px;text-align:center;">
				<a href="javascript:void(0)" class="listtoinput">
				<c:if test="${shareType eq 'msg' }">手动输入手机号码分享</c:if>
				<c:if test="${shareType eq 'mail' }">手动输入邮箱地址分享</c:if>
				</a>
			</div>
		</div>
	</c:if>
	<!-- 查询End -->
	<div id="div_expense_list" class="list-group listview listview-header" style="margin:0px;">
		<c:forEach items="${conList}" var="con">
			<a href="#" class="list-group-item listview-item radio contact_list_item" style="border: 0px;border-bottom:1px solid #eee;margin:0px;">
				<input type="hidden" name="userid" value="${con.rowid}" ><!-- rowid -->
				<input type="hidden" name="phonenumber" value="${con.phonemobile}" ><!-- phonemobile -->
				<input type="hidden" name="email" value="${con.email}" ><!-- email -->
				<input type="hidden" name="name" value="${con.conname}" ><!-- email -->
				<div class="list-group-item-bd">
					 <%-- <div class="thumb list-icon">
						<img style="border-radius: 10px;" width="50px" src="${user.headimgurl }"/>
					</div> --%>
					<div class="content" style="text-align: left">
						<h1>${con.conname}</h1>
						<p class="text-default" >电话：${con.phonemobile}</p>
						<p class="text-default" >职位：${con.conjob}</p>
					</div>
				</div>
				<div class="input-radio" title="选择该条记录"></div>
			</a>
		</c:forEach>
		<c:if test="${fn:length(conList) == 0 }">
			<div class="searchnodata" >
				<div style="text-align:center;padding-top:50px;font-size:14px;color:#999;">没有找到数据</div>
				<div style="font-size:14px;text-align:center;padding:20px 0px 50px 0px;">
					<a href="javascript:void(0)" class="listtoinput2">
					<c:if test="${shareType eq 'msg' }">手工输入手机号码分享</c:if>
					<c:if test="${shareType eq 'mail' }">手工输入邮箱地址分享</c:if>
					</a>
				</div>
			</div>
		</c:if>
	</div>
</div>	
<div class="flooter" style="color:#333;margin-top: 5px;opacity:1;background-color:#fff;height: 41px;line-height: 41px;border-top:1px solid #ddd;font-size:14px;">
	<div class="skipdiv skip" style="float:left;width:50%;border-right:1px solid #ddd;">
		<a href="javascript:void(0)"><img src="<%=path %>/image/reset.png" style="height:24px">&nbsp;重选</a>
	</div>
	<div class="confirmdiv confirm" style="float:left;width:50%;">
		<a href="javascript:void(0)"><img src="<%=path %>/image/share_count.png" style="height:24px">&nbsp;分享</a>
	</div>
</div>
<div class="none nodata" style="width:100%;text-align:center;margin-top: 50px;font-size: 14px;color: #999;">没有找到匹配的数据！</div>
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;text-align: center;height: 30px;line-height:30px;">121212</div>

