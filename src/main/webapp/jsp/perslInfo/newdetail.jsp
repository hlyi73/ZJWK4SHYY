<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="com.takshine.wxcrm.base.util.ZJWKUtil,com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%
	String headimg = UserUtil.getCurrUser(request).getHeadimgurl();
	String path = request.getContextPath();
	Object obj = request.getAttribute("partyId");
	String partyId = "";
	if(null != obj){
		partyId = obj.toString();
	}
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?parentId="+partyId+"&parentType=businesscard");
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs2.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/model/personalmsg.model.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/model/visituser.model.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/model/myprint.model.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/personalmsg.css">
<!-- template -->
<script type="text/html" id="singlePerMsgTemp01">
<div class="sglMsg" style="font-size:14px;">
	<div class="d1">
     <span class="cred"><a href="<%=path%>/businesscard/detail?partyId={{userId}}">{{username}}</a></span>
     {{if relaModule == 'System_Liu_Msg' }}  【留言】 {{/if}}
     {{if relaModule == 'System_Personal_Msg' }}  【私信】 {{/if}}
     <span class="pdate">{{createTime}}</span>
    </div>
	<div>{{content}}</div>
	<div class="d2" mid="{{id}}" tid="{{userId}}" tname="{{username}}">
		<span class="reply" style="background:#FFFFFF"><img src="<%=path%>/image/title-message.png" style="height: 21px;"></span>
		<span class="del" style="background:#FFFFFF"><img src="<%=path%>/image/fasdel.png" style="height: 18px;opacity:0.7">删除</span>
	</div>
	<div class="d3" mid="{{id}}" userid="{{userId}}"></div>
</div>
</script>
<script type="text/html" id="singlePerMsgTemp02">
<div class="sglMsg" style="font-size:14px;">
	<div class="d1">
     <span class="cred"><a href="<%=path%>/businesscard/detail?partyId={{userId}}">{{username}}</a></span>
     {{if relaModule == 'System_Liu_Msg' }}  【留言】 {{/if}}
     {{if relaModule == 'System_Personal_Msg' }}  【私信】 {{/if}}
     <span class="pdate">{{createTime}}</span>
    </div>
	<div>{{content}}</div>
	<div class="d3" mid="{{id}}" userid="{{userId}}"></div>
</div>
</script>
<script type="text/html" id="singlePerMsgReplyTemp">
<div class="pmt5">
	<div><span class="cblue"><a href="<%=path%>/businesscard/detail?partyId={{userId}}">{{username}}</a></span> 回复 <span class="cblue"><a href="<%=path%>/businesscard/detail?partyId={{targetUId}}">{{targetUName}}</a></span>：
		<span class="pdate">{{createTime}}</span>
	</div>
	<div>{{content}}</div>
</div>
</script>
<style type="text/css">
.dropdown-menu-group {
	font-size: 14px;
	position: absolute;
	width: 150px;
	right: 2px;
	left: auto;
	top: 45px;
	text-align: left;
	z-index: 999;
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

input:-moz-placeholder, textarea:-moz-placeholder {
	color: #DDD;
}

input:-ms-input-placeholder, textarea:-ms-input-placeholder {
	color: #DDD;
}

input::-webkit-input-placeholder, textarea::-webkit-input-placeholder {
	color: #DDD;
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

.div-img {
	width: 100%;
	max-width: 640px;
	position: fixed;
	left: 50%;
	top: 0px;
	z-index: 1031;
}

.div-bg {
	width: 100%;
	background: #333;
	filter: Alpha(Opacity = 40);
	-moz-opacity: 0.6;
	opacity: 0.6;
	position: fixed;
	right: 0px;
	top: 0px;
	z-index: 1031;
}
</style>
<script type="text/javascript">
	function showDoc(){
		var disnew = $("#newSign").css("display");
		if("none"==disnew){
			$("#oldSign").css("display","none");
			$("#newSign").css("display","");
			$("#editimg").attr("src","<%=path%>/image/oper_success.png");
		}else{
			$("#oldSign").css("display","");
			$("#newSign").css("display","none");
			//$("#editimg").attr("src","<%=path%>/image/edit_information.png");
			conform();
		}
	}
	function upload(){
		$(".fileInput").trigger("click");
	}
	var prefile = "";
	//异步修改
	function ajaxFileUpload(){
		if(prefile === ""){
			prefile = $(".fileInput").val();
		}else if(prefile == $(".fileInput").val()){
			return;
		}
		$.ajaxFileUpload({
			//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
			url:'<%=path%>/dcCrm/upload',
			secureuri:false,                       //是否启用安全提交,默认为false 
			fileElementId:'uploadFile',           //文件选择框的id属性
			dataType:'text',                       //服务器返回的格式,可以是json或xml等
			success:function(data, status){        //服务器响应成功时的处理函数
				prefile = "";
				$("#headImageDiv").empty();
				if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
					var width = $(window).width();
					if(width > 640){
						width = 640;
					}
	 				$(":hidden[name=headImageUrl]").val(data.substring(1));
					var path = "<%=path%>/contact/download?flag=dccrm&fileName="
									+ data.substring(1);
							$("#headImageDiv")
									.append(
											'<img style="height: 60px;" src="'+path+'"></img>');
						} else {
							$(".myMsgBox").css("display", "")
									.html("图片上传失败,请重试");
							$(".myMsgBox").delay(2000).fadeOut();
						}
/* 						$(".uptImg")
								.append(
										'<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">'); */
					},
					error : function(data, status, e) { //服务器响应失败时的处理函数
						prefile = "";
						$(".myMsgBox").css("display", "").html("图片上传失败,请联系管理员");
						$(".myMsgBox").delay(2000).fadeOut();
					/* 	$(".uptImg").empty();
						$(".uptImg")
								.append(
										'<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif, image/x-png,image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">'); */
					}
				});
	}
	$(function() {
		
		$(".searchbusicardbtn").click(function(){
			var searchStr = $("#searchcard").val();
			if(!searchStr){
				$('#searchcard').val('').attr("placeholder","点击搜索名片");
				return;
			}
			$("form[name=searchcFrom]").submit();
		});
		//交换名片拒绝
    	$(".cancelcard").click(function(){
    		var obj = [];
    		obj.push({name :'userId', value :'${user.party_row_id}'});
        	obj.push({name :'username', value :'${user.nickname}'});
        	obj.push({name :'targetUId', value :'${partyId}'});
        	obj.push({name :'targetUName', value :''});
        	obj.push({name :'msgType', value :'txt'});
        	obj.push({name :'content', value :'${user.nickname}拒绝了与您交换名片的请求！'});
        	obj.push({name :'relaModule', value :'System_RejectCard'});
        	obj.push({name :'relaId', value: '${user.party_row_id}'});
        	//发送名片交换申请
        	$.ajax({
    	  	      url: '<%=path%>/dcCrm/changecard',
    	  	      data: obj,
    	  	      success: function(data){
    	  	    	    if(data && data === "success"){
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	/* $(".myMsgBox").css("display","").html("发送成功！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut(); */
    	  	    	    }else{
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    /* 	$(".myMsgBox").css("display","").html("发送失败！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut(); */
    	  	    	    }
    	  	      }
    	  	});
    		
    	});
    	

    	$(".agreecard").click(function(){
    		var obj = [];
        	obj.push({name :'rela_user_id', value :'${user.party_row_id}'});
        	obj.push({name :'rela_user_name', value :'${user.nickname}'});
        	obj.push({name :'user_id', value :'${partyId}'});
        	//发送名片交换申请
        	$.ajax({
    	  	      url: '<%=path%>/dcCrm/agreecard',
    	  	      data: obj,
    	  	      success: function(data){
    	  	    	    if(data && data === "success"){
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$("#changecard").css("display","none");
    	  	    	    	$(".sms_share").css("width","33.33333%");
    	  	    	    	$(".email_share").css("width","33.33333%");
    	  	    	    	$(".add_busicard").css("width","33.33333%");
    	  	    	    }else{
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$(".myMsgBox").css("display","").html("操作失败！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }
    	  	      }
    	  	});
    		
    	});		
		$(".menu-group").click(function() {
			if ($(".dropdown-menu-group").hasClass("none")) {
				$(".dropdown-menu-group").removeClass("none");
				$(".g-mask").removeClass("none");
			} else {
				$(".dropdown-menu-group").addClass("none");
				$(".g-mask").addClass("none");
			} 
		});
		var width = $(window).width();
		if (width > 640) {
			width = 640;
		}
		$(".bgimg").attr("width", width);

		
		  $(".display_member_sel").click(function(){
	          	$(".display_member_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          		$(":hidden[name=sex]").val($(this).attr("val"));
	          	}
	          });
		  
		  
			//确定按钮
	    	$("#conbtn").click(function(){
	    		
	  			var opName = $("#name").val();
		  		if(!opName){
		  			$('#name').val('').attr("placeholder","请输入姓名");
		  			return;
		  		}
		  		var phone = $("#phone").val();
		  		if(!phone){
		  			$('#phone').val('').attr("placeholder","请输入联系电话");
		  			return;
		  		}else{
					var exp = /^1[3|4|5|8][0-9]{9}$/;
	  				var r = exp.test(phone);
		  				if (!r) {
		  					$('#phone').val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
		  					return;
		  				}
	  				}
	    		$("form[name=businessCardModify]").submit();
	    	});
			
			//消息对象
	    	var personalMsg = new PersonalMsg({con:'personalmsgcon', bid:'${BusinessCard.id}', uid:'${user.party_row_id}', bcpartyid:'${BusinessCard.partyId}',pagecounts:'5',currpages:'0'});
	    	//访客历史列表
	    	var visitUser = new VisitUser({visitname:'${visitUser.nickname}',currpartyid:'${user.party_row_id}',bcpartyid:'${visitUser.party_row_id}',con: 'visitusercon',pagecounts:'5',currpages:'0'});
	    	//动态列表
	    	var myPrint = new MyPrint({currpartyid:'${user.party_row_id}',bcpartyid:'${visitUser.party_row_id}',con: 'myprintcon',pagecounts:'5',currpages:'0'});
	    	$("input[name=searchcard]").focus(function(){
	    		$(".dropdown-menu-group").removeClass("none").addClass("none");
				$(".g-mask").removeClass("none");
				//显示按钮
				$(".menu-group").css("display","none");
				$(".searchcardbtn").css("display","");
				
	    	});
	    	
	    	$(".g-mask").click(function() {
				$(".dropdown-menu-group").addClass("none");
				$(".g-mask").addClass("none");
				//隐藏按钮
				$(".searchcardbtn").css("display","none");
				$(".menu-group").css("display","");
				
			});

	    	
	    	$(".div_codebar_more").click(function(){
	    		$('.div_codebar_packup').removeClass("none");
	    		$(".div_codebar_more").removeClass("none").addClass("none");
	    		$('.div_codebar').removeClass("none");
	    	});
	    	$(".div_codebar_packup").click(function(){
	    		$(".div_codebar_more").removeClass("none");
	    		$(".div_codebar_packup").removeClass("none").addClass("none");
	    		$(".div_codebar").removeClass("none").addClass("none");
	    	});
	    	
	    	
			//取消按钮
			$(".cancelTagBtn").click(function(){
				$(".addTagArea").css("display", "none");
				$("textarea[name=introduction]").val('');
				$("textarea[name=introduction]").attr("placeholder", "请填写");
			});
			//保存
			$(".saveTagBtn${parenttype}").click(function(){
				var introbj = $("textarea[name=introduction${parenttype}]");
				var tagName = $.trim(introbj.val());
				if(!tagName){
					introbj.attr("placeholder","请填写");
					return;
				}
				
				//判断长度
				var myReg = /^[\u4e00-\u9fa5]+$/;
				if (myReg.test(tagName)) {
	                //中文
					if(tagName.length>10){
						introbj.val('');
	                	introbj.attr("placeholder","标签长度超出限制，请重新输入");
	    				return;
	                }
	            } else {
	                //英文
	                if(tagName.length>16){
	                	introbj.val('');
	                	introbj.attr("placeholder","标签长度超出限制，请重新输入");
	    				return;
	                }
	            }
				var isExists = false;
				$(".tag_list_item").each(function(){
					if($(this).html() == tagName){
						isExists = true;
						return;
					}
				});
				if(isExists){
					introbj.val('');
					introbj.attr("placeholder","该标签已存在，请输入其他标签");
					return;
				}
				//判断是否有重复标签
				
				//绑定到后台
				var modelType = $(":hidden[name=modelTagType]").val();
				var obj = [];
				obj.push({name :'modelId', value :'${partyId}'});
				obj.push({name :'modelType', value : modelType});
				obj.push({name :'tagName', value : tagName});
				//发送保存标签申请
				$.ajax({
			  	      url: '<%=path%>/modelTag/add',
			  	      data: obj,
			  	      success: function(data){
			  	    	 var d= JSON.parse(data);
			    	      if(d && d.errorCode === "success")
			    	    	  introbj.val('');
			    	    	  var tag='	<span id="'+d.rowId+'" class="tagchecked tag_'+d.rowId+'" style="margin: 5px; line-height: 20px; float: left;">';
			    	    	  tag+='<img src="<%=path %>/image/add_tag.png" style="height:30px;">';
			    	    	  tag+='<span class="tag_list_item" style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;">'+tagName+'</span>';
			    	    	  tag+='<span style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">0</span>';
			    	    	  tag+='</span>';
			    	    	  $(".tagList").prepend(tag);
			    	    	  //initUserTagElem();
			    	    	  //changeColor();
			    	    	  $("textarea[name=introduction]").attr("placeholder", "请填写");
			    	    	  $(".addTagArea").css("display","none");
			    	      }
			  	     
			  	 });
			});
			$(".addTagBtn").click(function(){
				$(".addTagArea").css("display", "");
			});
			
			
			   $("#wxshare").click(function () {
	                $(".div-bg").height(window.screen.height);
	             /*    var img = new Image();
	                img.src =$('#shareImg').attr("src") ;
	                var w = img.width; */
	             	var dw= $(".div-img").width();
	                $('#shareImg').css("width",dw/2);
	               
	                $(".div-bg, .div-img").show();
	            });
			   $(".div-bg, .div-img").click(function () {
	                $(".div-bg, .div-img").hide();
	            });
	});
function update(){
	var opName = $("#name").val();
		if(!opName){
			$('#name').val('').attr("placeholder","请输入姓名");
			return;
		}
		var phone = $("#phone").val();
		if(!phone){
			$('#phone').val('').attr("placeholder","请输入联系电话");
			return;
		}else{
		var exp = /^1[3|4|5|8][0-9]{9}$/;
			var r = exp.test(phone);
				if (!r) {
					$('#phone').val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
					return;
				}
			}
		if($('#isSendMsg').val()=='1'){
			var code = $("#code").val();
			if(!code){
				$('#code').val('').attr("placeholder","请输入短信验证码");
				return;
			}
		}
	$("form[name=businessCardModify]").submit();
}	
function addFriend(){
	//交换名片按钮
		var obj = [];
    	obj.push({name :'userId', value :'${user.party_row_id}'});
    	obj.push({name :'username', value :'${user.nickname}'});
    	obj.push({name :'targetUId', value :'${partyId}'});
    	obj.push({name :'targetUName', value :''});
    	obj.push({name :'msgType', value :'txt'});
    	obj.push({name :'content', value :'${user.nickname}请求与您交换名片！'});
    	obj.push({name :'relaModule', value :'System_ChangeCard'});
    	obj.push({name :'relaId', value: '${user.party_row_id}'});
    	//发送名片交换申请
    	$.ajax({
	  	      url: '<%=path%>/dcCrm/changecard',
	  	      data: obj,
	  	      success: function(data){
	  	    	    if(data && data === "success"){
	  	    	    	$("#changecard").attr("href","");
	  	    	    	$("#addfriend").html("申请已发送");
	  	    	    	
	  	    	    }
	  	      }
	  	});

}


//timer处理函数  
function SetRemainTime() {  
    if (curCount == 0) {                  
        window.clearInterval(InterValObj);// 停止计时器  
        $("#btnSendCode").removeAttr("disabled");// 启用按钮  
        $("#btnSendCode").val("重新发送验证码");  
    }else {  
        curCount--;  
        $("#btnSendCode").val("请在" + curCount + "秒内输入验证码");  
    }  
} 
function gotoTag(){
	window.location.href="<%=path%>/modelTag/taglist";
}
function praise(){
	var dataObj = [];
	dataObj.push({name:'operativetype', value: 'PRAISE' });
	dataObj.push({name:'objectid', value: '${partyId}' });
	dataObj.push({name:'objecttype', value: 'PERSONAL_HOMEPAGE' });
	dataObj.push({name:'ownid', value: '${partyId}' });
	$("#praise").unbind("click");
	$("#praise").attr("href","");
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/print/savePrint' || '',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				if(!data || data === '-1'){
					$("#myMsgBox").css("display","").html("点赞失败!");
	    	    	$("#myMsgBox").delay(2000).fadeOut();
	    	    	$("#praise").attr("href","javascript:praise();");
				}else{
					var obj=$("#praise-span");
					var count =parseInt('${praiseCount}')+1;
					obj.html("赞("+count+")");
				}
			}
		});
 
}


function praiseTag(id){
	if('${user.party_row_id}'=='${partyId}'){
		$('.tag_'+id).unbind("click");
		return;
	}
	var dataObj = [];
	dataObj.push({name:'operativetype', value: 'PRAISE' });
	dataObj.push({name:'objectid', value: id});
	dataObj.push({name:'objecttype', value: 'TAG' });
	dataObj.push({name:'ownid', value: '${partyId}' });
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/print/savePrint' || '',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				if (!data || data === '-1') {
					$(".errMsgBox").css("display", "").html("您已经认可了ta的标签");
					$(".errMsgBox").delay(2000).fadeOut();
				} else {
					$(".successMsgBox").css("display", "").html("您认可了ta的标签");
					$(".successMsgBox").delay(2000).fadeOut();
					var obj = $('#tag_total_' + id);
					$('.tag_' + id).unbind("click");
					var count = parseInt(obj.html()) + 1;
					obj.html(count);
				}
			}
		});

	}
</script>
</head>

<body style="min-height: 100%;background-color:#eee;">
	<div class="div-bg" style="min-height: 100%; display: none;"></div>
	<div class="div-img" style="display: none;">
		<span> <img src="<%=path%>/image/share.png" id="shareImg">
		</span>
	</div>
	<div id="site-nav" class="navbar" style="">

		<h3 style="padding-right: 45px;">
			<c:if test="${user.party_row_id eq partyId}">
				<div style="height: 44px;">
					<div style="float: left;">
						<img src="<%=path%>/image/wxsearch.png"
							style="position: absolute; opacity: 0.6; width: 30px; margin-left: 5px; margin-top: 12px;">
					</div>
					<div>
						<form method="post" novalidate="true" action="<%=path%>/businesscard/search" id="searchcFrom"
							name="searchcFrom">
							<input type="text" value="" placeholder="点击搜索名片"
								name="searchcard" id="searchcard"
								style="border-radius: 10px; font-size: 14px; padding-left: 40px; background-color: RGB(79, 179, 144); border: 0px; color: #FFF;">
						</form>
					</div>
				</div>
			</c:if>
			<c:if test="${user.party_row_id ne partyId}">
				<jsp:include page="/common/back.jsp"></jsp:include>
				<c:if
					test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
						${BusinessCard.name}的名片
				</c:if>
				<c:if test="${BusinessCard.name eq '' or BusinessCard.name eq null}">
					${visitUser.nickname}的名片
				</c:if>
			</c:if>


		</h3>
		<div class="act-secondary searchcardbtn" style="display: none;">
			<span class="searchbusicardbtn"
				style="background-color: #42A3B5; border-radius: 8px; padding: 6px; font-size: 14px;">搜索</span>
		</div>
		<div class="act-secondary menu-group">
			<a href="javascript:void(0)"> <img
				src="<%=path%>/image/func_menu.png" width="36px;">
			</a>
		</div>
		<div class="dropdown-menu-group none">

			<li><a href="<%=path%>/businesscard/modify"
				style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;完善个人资料
			</a></li>
			<li><a
				href="<%=path%>/dcCrm/make?partyId=${BusinessCard.partyId}"
				style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;名片二维码
			</a></li>
			<li><a href="<%=path%>/cbooks/list"
				style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;我的通讯录
			</a></li>
		</div>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<!-- <h4>详情</h4> -->
			<input type="hidden" name="id" id="id" value="${BusinessCard.id}" />
			<input type="hidden" name="sex" id="sex" value="${BusinessCard.sex}" />
			<input type="hidden" name="partyId" id="partyId" value="${BusinessCard.partyId}" /> 
			<input type="hidden" name="headImageUrl" id="headImageUrl" value="${BusinessCard.headImageUrl}" /> 
			<input type="hidden" name="isSendMsg" id="isSendMsg" value="" />
			<input type="hidden" name="isValidation" id="isValidation" value="${BusinessCard.isValidation}" />
			<div class="list-group-item listview-item" style="padding: 8px;">
				<div style="width: 100%;">
					<div style="float: left;">
						<c:if
							test="${BusinessCard.headImageUrl ne '' and BusinessCard.headImageUrl ne null}">
							<img id="headImg" name="headImg"
								src="<%=path%>/contact/download?flag=dccrm&fileName=${BusinessCard.headImageUrl}"
								height="90px">
						</c:if>
						<c:if
							test="${BusinessCard.headImageUrl eq '' or BusinessCard.headImageUrl eq null}">
							<img id="headImg" name="headImg" src="${visitUser.headimgurl}"
								height="90px">

						</c:if>
						<div class="div_codebar_more"
							style="width: 100%; text-align: center;">
							<a style="font-family: 'Microsoft YaHei'; font-size: 14px;">名片二维码</a>
						</div>
						<div class="div_codebar_packup none"
							style="width: 100%; text-align: center;">
							<a style="font-family: 'Microsoft YaHei'; font-size: 14px;">名片二维码</a>
						</div>
					</div>
					<div style="margin-left: 100px; margin-top: -5px; font-size: 14px;">
						<c:if
							test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
						${BusinessCard.name}
					</c:if>
						<c:if
							test="${BusinessCard.position ne '' and BusinessCard.position ne null}">
							<span
								style="background-color: rgb(246, 185, 53); color: #fff; padding: 0px 5px; border-radius: 10px;">${BusinessCard.position}</span>
						</c:if>
					</div>
					<%-- 			<c:if test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
				<div style="float:right;margin-top:-40px;"><span class="icon icon-uniE603"></span>
				
				</div>
				</c:if> --%>
					<div
						style="margin-left: 100px; font-size: 14px; line-height: 20px;">
						<c:if
							test="${BusinessCard.company ne '' and BusinessCard.company ne null}">
						${BusinessCard.company}
					</c:if>

					</div>
					<div
						style="margin-left: 100px; color: #999; font-size: 12px; line-height: 20px;">
						<c:if
							test="${BusinessCard.phone ne '' and BusinessCard.phone ne null}">
					
						手机：
							<c:if test="${BusinessCard.partyId eq user.party_row_id}">
							${BusinessCard.phone}
							</c:if>
							<c:if test="${BusinessCard.partyId ne user.party_row_id}">
								<c:if
									test="${visitUser.contactConfig eq 'friend' and isfriend ==true}">${BusinessCard.phone}</c:if>
								<c:if
									test="${visitUser.contactConfig eq 'friend' and isfriend ==false}">好友可见</c:if>
								<c:if test="${visitUser.contactConfig eq 'all'}">${BusinessCard.phone}</c:if>
							</c:if>
							<c:if test="${'1' eq BusinessCard.isValidation}">
							 （已验证）
							 </c:if>
						</c:if>
					</div>
					<div
						style="margin-left: 100px; color: #999; font-size: 12px; line-height: 20px;">
						<c:if
							test="${BusinessCard.email ne '' and BusinessCard.email ne null}">
					邮箱：
					<c:if test="${BusinessCard.partyId eq user.party_row_id}">
							${BusinessCard.email}
					</c:if>
							<c:if test="${BusinessCard.partyId ne user.party_row_id}">
								<c:if
									test="${visitUser.contactConfig eq 'friend' and isfriend ==true}">${BusinessCard.email}</c:if>
								<c:if
									test="${visitUser.contactConfig eq 'friend' and isfriend ==false}">好友可见</c:if>
								<c:if test="${visitUser.contactConfig eq 'all'}">${BusinessCard.email}</c:if>

							</c:if>
						</c:if>
						<c:if test="${'1' eq BusinessCard.isEmailValidation}">
					 （已验证）
					 </c:if>
					</div>
					<div
						style="margin-left: 100px; color: #999; font-size: 12px; line-height: 20px;">
						<c:if
							test="${BusinessCard.address ne '' and BusinessCard.address ne null}">
						地址：${BusinessCard.address}
					</c:if>
					</div>
				</div>
			</div>
				<div style="width: 100%;font-size: 12px; text-align: center; line-height: 40px; background-color: #fff; border-bottom: 1px solid #ddd; height: 40px;">
					<div id="read_span"
						style="float: left; width: 33.333333%; text-align: center; border-right: 1px solid #efefef;">
						<img src="<%=path%>/image/visit_count.png" style="height: 18px;"/>&nbsp;${visitCount}
					</div>
					<div id="praise-span" style="float: left; width: 33.333333%; text-align: center; border-right: 1px solid #efefef;">
						<c:if test="${isPraise==true}">
							<a href="javascript:praise()" id="praise"> <img
								src="<%=path%>/image/parise_count.png" style="height: 18px;">&nbsp;${praiseCount}
							</a>
						</c:if>
						<c:if test="${isPraise==false}">
							<c:if test="${user.party_row_id ne partyId}">
								<a href="javascript:void(0)"
									onclick='$(".errMsgBox").css("display","").html("您已为ta点过赞");$(".errMsgBox").delay(2000).fadeOut();'>
									<img src="<%=path%>/image/parise_count.png"
									style="height: 18px;">&nbsp;${praiseCount}
								</a>
							</c:if>
							<c:if test="${user.party_row_id eq partyId}">
								<img src="<%=path%>/image/parise_count.png"
									style="height: 18px;"/>&nbsp;${praiseCount}
							</c:if>
						</c:if>
					</div>
					<div id="read_span"
						style="float: left; width: 33.333333%; text-align: center;">
						<img src="<%=path%>/image/share_count.png"
							style="height: 18px; opacity: 0.7;"/>&nbsp;${forwardcount}
					</div>
				</div>
			<div class="div_codebar none">
				<div class=" list-group-item listview-item"
					style="margin-top: 3px; border-top: 1px solid #ddd;">
					<div style="width: 100%; padding-top: 5px;">
						<div class="div_codebar_packup none"
							style="width: 100%; text-align: right;">
							<a style="font-family: 'Microsoft YaHei'; font-size: 14px;">收起</a>
						</div>

						<div style="float: left; margin-top: 0px; width: 100%; text-align: center;">
							<img src="<%=path%>/cache/${filename}">
						</div>
						<div style="width: 100%; text-align: center; font-size: 14px;">
							扫描即可以将名片信息保存到手机通讯录中</div>
					</div>
				</div>
			</div>

			<div class="list-group-item listview-item"
				style="margin-top: 8px; border-top: 1px solid #ddd;">
				<div style="width: 100%; padding-top: 5px;">

					<div style="font-size: 14px; margin-top: -10px">
						<img src="<%=path%>/image/tags_list.png" style="height: 20px;">&nbsp;标签
						<c:if test="${user.party_row_id eq partyId}">
							<span onclick="javascript:gotoTag()"
								style="border-radius: 5px; margin-top: 5px; padding-bottom: 20px; background: rgb(93, 204, 165); color: #fff; padding: 5px; margin-left: 20px; padding: 5px;">编辑</span>
						</c:if>
						<c:if test="${user.party_row_id ne partyId}">
							<span class="addTagBtn"
								style="margin-top: 5px; padding-bottom: 20px; background: rgb(143, 160, 245); color: #fff; padding: 5px; margin-left: 20px;">+
								给TA贴标签</span>
						</c:if>
					</div>
					<div
						style="float: left; margin-top: 10px; width: 100%; font-size: 14px;"
						class="tagList">
						<c:forEach items="${tagList}" var="tagList">

							<span class="tagchecked tag_${tagList.id}"
								style="margin: 5px; line-height: 20px; float: left;"
								onclick="javascript:praiseTag('${tagList.id}')"> <img
								src="<%=path%>/image/add_tag.png" style="height: 30px;"><span
								style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px;">${tagList.tagName}</span>
								<span
								style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;"
								id="tag_total_${tagList.id}">${tagList.total}</span>
							</span>
						</c:forEach>
					</div>
					<!-- 标签添加区域 -->
					<div class="addTagArea" style="display: none">
						<textarea name="introduction" id="introduction" rows="1" cols=""
							placeholder="请填写"></textarea>
						<div style="color: #999; font-size: 12px; text-align: right;">长度应少于等于10个汉字或16个字符</div>
						<div class="ui-body-d ui-corner-all info"
							style="padding: 1em; height: 65px; margin-top: -10px;">
							<span class="cancelTagBtn"
								style="background: #D3D5D8; color: #fff; padding: 5px; text-align: center; width: 44%; cursor: pointer; font-size: 14px; float: left; margin-right: 10px; border-radius: 10px;">取消</span>
							<span class="saveTagBtn"
								style="background: rgb(143, 160, 245); color: #fff; padding: 5px; text-align: center; width: 48%; cursor: pointer; font-size: 14px; float: right; margin-left: 10px; border-radius: 10px;">添加</span>
						</div>
					</div>
					<!-- 标签添加区域结束-->
				</div>
			</div>
			<!-- 最近访客 -->
			<div class="list-group-item listview-item print_list"
				style="margin-top: 8px; border-top: 1px solid #ddd;">
				<div class="myprintcon w100">
					<div style="font-size: 14px; margin-top: -10px">
						<img src="<%=path%>/image/visit_list.png" style="height: 20px;">&nbsp;动态
						<div class="permore" style="float: right;">全部 ></div>
					</div>
					<div class="content"
						style="float: left; margin-top: 10px; width: 100%; font-size: 14px; line-height: 25px;">
					</div>

				</div>
			</div>

			<!-- 最近访客 -->
			<div class="list-group-item listview-item visit_list"
				style="margin-top: 8px; border-top: 1px solid #ddd;">
				<div class="visitusercon w100">
					<div style="font-size: 14px; margin-top: -10px">
						<img src="<%=path%>/image/visit_list.png" style="height: 20px;">&nbsp;最近访客
						<div class="permore" style="float: right;">全部 ></div>
					</div>
					<div class="content"
						style="float: left; margin-top: 10px; width: 100%; font-size: 14px; line-height: 25px;">
					</div>

				</div>
			</div>
			<!-- 最近留言与私信 -->
			<div class="list-group-item listview-item pmb50"
				style="margin-top: 8px; border-top: 1px solid #ddd;">
				<div class="personalmsgcon w100">
					<div class="ptitle" style="font-size: 14px;">
						<img src="<%=path%>/image/comments_list.png" style="height: 20px;">&nbsp;最近留言
						<div class="permore" style="float: right;">全部 ></div>
						<div class="content" style="margin-top: 5px;"></div>

					</div>
					<div style="clear: both;"></div>
					<%--不能自己给自己留言 --%>
					<c:if test="${user.party_row_id ne partyId}">
						<div class="t2 liuyanandsixin"
							style="text-align: center; margin-top: 5px;">
							<c:if test="${isfriend ==true}">
								<span class="sendLiuMsgBtn">留言</span>
							</c:if>
							<c:if
								test="${isfriend ==false and visitUser.messageConfig eq 'all'}">
								<span class="sendLiuMsgBtn">留言</span>
							</c:if>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<c:if test="${isfriend ==true}">
								<span class="sendPersonalBtn">私信</span>
							</c:if>
							<c:if test="${isfriend ==false and visitUser.msmConfig eq 'all'}">
								<span class="sendPersonalBtn">私信</span>
							</c:if>
						</div>
					</c:if>
					<div class="sendcontpl none" style="display: none">
						<textarea name="sendcontent" rows="" cols=""
							style="margin-top: 5px; font-size: 14px;" placeholder="请输入回复内容"></textarea>
						<div class="sendbtn savesend"
							style="background-color: rgb(93, 204, 165); color: #FFF; font-size: 14px;">发送</div>
						<div class="sendbtn cannelsend"
							style="color: #8F9090; font-size: 14px;">取消</div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<div class="_menu">
		<c:if test="${user.party_row_id eq partyId}">
			<div align="center"
				style="margin-top: -41px; opacity: 1; background-color: #fff; height: 41px; line-height: 41px; border-top: 1px solid #ddd; font-size: 14px;">
				<div style="width: 100%;">
					<div
						style="float: left; width: 100%; border-right: 1px solid #ddd;">
						<a id="wxshare" hrer="javascript:void()"> <img
							src="<%=path%>/image/share_sms.png" style="height: 26px">&nbsp;微信分享
						</a>
					</div>
					<%-- 		<div style="float:left;width:33%;border-right:1px solid #ddd;">
							<a href="<%=path%>/businesscard/share?partyId=${BusinessCard.partyId}&shareType=msg">
								<img src="<%=path %>/image/share_sms.png" style="height:26px">&nbsp;短信分享
							</a>
						</div>
						<div style="float:left;width:33%;">
							<a href="<%=path%>/businesscard/share?partyId=${BusinessCard.partyId}&shareType=mail">
								<img src="<%=path %>/image/share_email.png" style="height:26px">&nbsp;邮件分享
							</a>
						</div> --%>
				</div>
			</div>
			<div style="clear: both;"></div>
		</c:if>
		<c:if test="${user.party_row_id ne partyId}">
			<c:if test="${isfriend ==false}">
				<div align="center"
					style="margin-top: -41px; opacity: 1; background-color: #fff; height: 41px; line-height: 41px; border-top: 1px solid #ddd; font-size: 14px;">
					<div style="width: 100%;">
						<div
							style="float: left; width: 50%; border-right: 1px solid #ddd;">
							<a id="changecard" href="javascript:addFriend();"> <span
								id="addfriend"> <img
									src="<%=path%>/image/add_friends.png" style="height: 20px">加好友
							</span>
							</a>
						</div>
						<%-- 	<div class="sms_share" style="float:left;width:25%;border-right:1px solid #ddd;">
									<a href="<%=path%>/businesscard/share?partyId=${BusinessCard.partyId}&shareType=msg">
										<img src="<%=path %>/image/share_sms.png" style="height:24px">短信
									</a>
								</div>
								<div class="email_share" style="float:left;width:25%;border-right:1px solid #ddd;">
									<a href="<%=path%>/businesscard/share?partyId=${BusinessCard.partyId}&shareType=mail">
										<img src="<%=path %>/image/share_email.png" style="height:24px">邮件
									</a>
								</div> --%>
						<div class="add_busicard" style="float: left; width: 50%;">
							<a href="<%=path%>/businesscard/modify"> <img
								src="<%=path%>/image/add_busicard.png" style="height: 24px">写名片
							</a>
						</div>
					</div>
				</div>
			</c:if>

			<c:if test="${isfriend != false}">
				<jsp:include page="/common/menu.jsp"></jsp:include>
			</c:if>

		</c:if>
	</div>


	<%-- <jsp:include page="/common/footer.jsp"></jsp:include> --%>
	<!-- 交换名片审核 -->
	<c:if test="${changecardflag == true}">
		<div class="flooter auditchangecard"
			style="background-color: #fff; border-top: 1px solid #ddd; opacity: 1;">
			<div class="button-ctrl" style="margin-top: -2px;">
				<fieldset class="">
					<div class="ui-block-a cancelcard">
						<a href="javascript:void(0)" class="btn btn-default btn-block"
							style="font-size: 14px;">拒绝</a>
					</div>
					<div class="ui-block-a agreecard">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
							style="font-size: 14px;">同意</a>
					</div>
				</fieldset>
			</div>
		</div>
	</c:if>
	<div class="g-mask none">&nbsp;</div>
	<div class="errMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; line-height: 30px;">&nbsp;</div>
	<div class="successMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(44, 234, 39); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; line-height: 30px;">&nbsp;</div>
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	    var img = "${BusinessCard.headImageUrl}";
	    if(!img){
	    	img = "${weixinHeadImage}";
	    }
	    var name = '${BusinessCard.name}';
	    if(!name){
	    	name = "${weixinNickName}";
	    }
		wx.ready(function () {
		  var opt = {
			  title : name + "的名片",
		      desc : "公司：${BusinessCard.company}\r\n职位：${BusinessCard.position}",
			  link: "<%=shortUrl%>",
			  imgUrl: img 
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>