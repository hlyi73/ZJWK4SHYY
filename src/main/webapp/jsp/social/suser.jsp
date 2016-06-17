<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/css/style.css">
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

<style>
.tagdiv{
float: left;
width: auto;
padding: 5px;
margin: 10px 10px 0px 0px;
color:#fff;
background-color: #3e6790;
}
</style>
<script type="text/javascript">
$(function(){
	loadTags();
	initButton();
}); 

//初始化按钮
function initButton(){
	//选择联系人退回
	$(".acctGoBack").click(function(){
		$("#site-nav").css("display","");
		$("#wbuserinfo").css("display","");
		$("#acct_more").addClass("modal");
		$(".btnContainer").css("display","");
		$(".acctList").empty();
	});
	//勾选某个联系人的超链接
	chooseContact();
	//取消按钮
	$(".cannel").click(function(){
		$(".btnContainer").css("display","none");
		$("._menu ").css("display","");
	});
	
	// 联系人的确定按钮
	$(".acctbtn").click(function(){
		var assId = null;
		$(".acctList > a.checked").each(function(){
			assId = $(this).find(":hidden[name=conId]").val();
		});
		var dataObj= [];
		dataObj.push({name:'openId',value:'${openId}'});
		dataObj.push({name:'publicId',value:'${publicId}'});
		dataObj.push({name:'contactid',value:assId});
		dataObj.push({name:'uid', value:'${socialUID}'});
		dataObj.push({name:'access_token', value:'${accesstoken}'});
		$.ajax({
			type: 'post',
			url: '<%=path%>/social/asysave',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				if(data==""){
					 $(".myMsgBox").css("display","").html("关联已有联系人失败!");
		    		 $(".myMsgBox").delay(2000).fadeOut();
		    		 return;
				}else if(data=="success"){
					$("#site-nav").css("display","");
					$("#wbuserinfo").css("display","");
					$("#acct_more").addClass("modal");
					$(".btnContainer").css("display","none");
					$(".acctList").empty();
				}
			}
		});
	});
}

function chooseContact(){
	$(".acctList > a").click(function(){
		$(".acctList > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
}

	//分页查询联系人
	function contoPage() {
		var currpage = $("input[name=currPage]").val();
		$("input[name=currPage]").val(parseInt(currpage) + 1);
		loadContact();
}

	function loadContact(){
		var currpage = $("input[name=currPage]").val();
		$.ajax({
			type : 'get',
			url : '<%=path%>/contact/asyclist' || '',			
		    async: false,
	        data: {currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10'} || {},
		    dataType: 'text',
		    success: function(data){
	    	if(!data){
	    		$(".contact_div").css("display","");
	    		var val = '<div class="alert-info text-center contact_div" style="display:none;padding: 2em 0; margin: 3em 0">无数据</div>';
	    		$(".acctList").append(val);
	    		$("#div_next_con").css("display", 'none');
	    		return;
	    	}
	    	$("#contactbook-btn").css("display","");
	   	    var val = $(".acctList").html();
	   	    var d = JSON.parse(data);
			if(d != ""){
	   	    	if($(d).size() == 10){
	   	    		$("#div_next_con").css("display",'');
	   	    	}else{
	   	    		$("#div_next_con").css("display",'none');
	   	    	}
				$(d).each(function(i){
					val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
						+  '<div class="list-group-item-bd"> <input type="hidden" name="conId" value="'+this.rowid+'"/>'
						+  '<input type="hidden" name="conName" value="'+this.conname+'"/>'
						+  '<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">';
					if(""==this.filename){
						val +='<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
					}else{
						if("ok"==this.iswbuser){
							val +='<img src="'+this.filename+'" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
						}else{
							val +='<img src="<%=path %>/contact/download?fileName='+this.filename+'" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
						}
					}
					val +='</div><div class="content" style="text-align: left"><h1>'+this.conname+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
					    + this.salutation+'</span></h1><p>'+this.conjob+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+this.phonemobile+'</p></div></div>'
						+ '<div class="input-radio" title="选择该条记录"></div></a>';
				});
			} else {
				$("#div_next_con").css("display", 'none');
			}
			$(".acctList").html(val);
			chooseContact();
		}
	});
	}
	
//加载标签
function loadTags(){
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'accesstoken', value:'${accesstoken}'});
	dataObj.push({name:'socialUID', value:'${socialUID}'});
	$.ajax({
		type: 'post',
		url: '<%=path%>/social/synctags',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d || d.length==0){
					return;
				}
				$(".taglist").empty();
				var val = "";
				$(d).each(function(i){
					val += '<div class="tagdiv">'+this.tag+'</div>';
				});
				$(".taglist").append(val);
			}
	});
}

//关联已有联系人
function relContact(){
	$("#site-nav").css("display","none");
	$("#wbuserinfo").css("display","none");
	$("#acct_more").removeClass("modal");
	$(".btnContainer").css("display","none");
	$("input[name=currPage]").val(1);
	loadContact();
}

//增加为新联系人
function addContact(){
	var dataObj = [];
	dataObj.push({name:'conname',value:'${wbuser.wbname}'});
	dataObj.push({name:'conaddress',value:'${wbuser.location}'});
	dataObj.push({name:'filename',value:'${wbuser.headimgurl}'});
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'uid', value:'${socialUID}'});
	dataObj.push({name:'access_token', value:'${accesstoken}'});
	dataObj.push({name:'add_wb', value:'add_wb'});
	$.ajax({
		type:'post',
		url:'<%=path%>/contact/asynsave',
		data:dataObj||{},
		dataType : 'text',
		success : function(data) {
			if(!data) return;
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
    		   $(".myMsgBox").delay(2000).fadeOut();
    		   return;
	    	}else{
	    		$(".btnContainer").css("display","none");
	    		$("._menu ").css("display","");
	    	}
		}
	});
}

</script>
</head>
<body style="background-color: #fff;min-height:100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a href="javascript:void(0);"  onclick='$(".btnContainer").css("display","");$("._menu ").css("display","none");' style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<h3 style="padding-right:30px;">${wbuser.wbname}的微博</h3>
	</div>
	<div id="wbuserinfo">
		<div style="width:100%;background-color: #eee;">
			<div style="float:left;width:100px;padding:20px;border-radius: 5px; ">
				<img src="${wbuser.headimgurl}" width="60px;">
			</div>
			<div style="padding:20px;line-height:20px;font-size:14px;">
				<p>昵称：${wbuser.nickname }</p>
					<p>粉丝数：${wbuser.followers_count }</p>
					<p>关注数：${wbuser.friends_count }</p>
			</div>
		</div>
		<div style="clear:both;"></div>
		<div class="taglist" style="padding-left:20px;padding-bottom:20px;">
			
		</div>
		<div style="clear:both;"></div>
		<div style="width:100%;padding:0px 20px 0 20px;margin-top:10px;font-size:14px;">
			<c:if test="${wbuser.location ne ''}">
			<div style="width:100%;line-height:35px;border-bottom:1px solid #efefef;">
				<div style="width:70px;float:left;padding-left:10px;">地址：</div>
				<div>${wbuser.location }</div>
			</div>
			</c:if>
			<c:if test="${wbuser.url ne ''}">
			<div style="width:100%;line-height:35px;border-bottom:1px solid #efefef;">
				<div style="width:70px;float:left;padding-left:10px;">博客：</div>
				<div><a href="${wbuser.url }">${wbuser.url }</a></div>
			</div>
			</c:if>
			<c:if test="${wbuser.desc ne ''}">
			<div style="width:100%;line-height:35px;">
				<div style="width:70px;float:left;padding-left:10px;">签名：</div>
				<div style="padding-left:70px;">${wbuser.desc }</div>
			</div>
			</c:if>
		</div>
		<div style="clear:both;line-height:30px;"></div>
		<c:forEach items="${wbuser.msgList }" var="wlist">
			<div style="width:100%;line-height:45px;margin-top:20px;background-color:#eee;padding-left:20px;">最新微博</div>
			<div style="width:100%;padding:0px 20px 0px 20px;margin-top:15px;">
					<div style="line-height:23px;font-size:14px;">&nbsp;&nbsp;&nbsp;&nbsp;${wlist.text }</div>
					<div>
						<c:forEach items="${wlist.picList }" var="plist">
							<div style="padding:10px 10px 0px 0px;float:left;">
								<img src="${plist.pic_urls }" height="100px;">
							</div>
						</c:forEach>
					</div>
					<div style="width:100%;text-align:right;"><fmt:formatDate value="${wlist.createTime }" type="both" pattern="yyyy-MM-dd" /></div>
			</div>
			<div style="margin-bottom:20px;clear:both"></div>
		</c:forEach>
	</div>
	
	<input type="hidden" name="currPage" value="1" />
				
	<!-- 关联联系人 -->
	<div id="acct_more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary acctGoBack"><i class="icon-back"></i></a>
			联系人列表
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
				<div class="list-group listview listview-header acctList">
				</div>
				<div style="width: 100%; text-align: center;display:none;" id="div_next_con">
					<a href="javascript:void(0)" onclick="contoPage()"><img
						src="/TAKWxCrmSer//image/nextpage.png" width="32px" /></a>
				</div>
				<div id="contactbook-btn" class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;display:none;padding-right:25px;">
					<input class="btn btn-block acctbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
				</div>
		</div>
	</div>
	
	<!--按钮的区域  -->
	<div class="examiner" style="margin-top:5px;text-align:center;">
		<div class="flooter" style="z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!--按钮的区域  -->
			<div class="btnContainer" style="display: none">
				<div class="ui-block-a agree" id="agree" style="margin: 10px 12px 10px 12px;padding-bottom: 5px; ">
					<a href="javascript:void(0)" class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="relContact();">关联已有联系人</a>
				</div>
				<div class="ui-block-a agreeAnd2Next" id="agreeAnd2Next" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
					<a href="javascript:void(0)" class="btn btn-success btn-block" style="background:#f0ad4e;font-size: 14px;padding:0px;margin:0px;" onclick="addContact();">新增为联系人</a>
				</div>
				<div class="ui-block-a cannel" style="margin: 10px 12px 10px 12px;padding-bottom: 10px;padding-top:10px;font-family: 'Microsoft YaHei';color: #878C91;font-size: 14px;cursor: pointer;">
					<span>取             &nbsp;消</span>
				</div>
			</div>
		</div>
	</div>	
		<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>				
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>