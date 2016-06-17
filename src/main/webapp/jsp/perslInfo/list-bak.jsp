<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
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
	
	//异步修改签名
	function conform(){
		var opSignature = $("input[name=signature]").val();
		if(opSignature.length>25){
			$("input[name=signature]").val('');
			$("input[name=signature]").attr("placeholder","请输入25个字符以内的个性签名");
			return;
		}
		$("input[name=opSignature]").val(opSignature);
		var dataobj=[];
		var form = $("form[name=dccrmModify]");
		form.find("input").each(function(){
			var n = $(this).attr("name");
			var v = $(this).attr("value");
			dataobj.push({name:n,value:v});
		});
		$.ajax({
			url:"<%=path%>/dcCrm/asyupdate",
			type:'post',
			data:dataobj,
		 	success: function(data){
		 		if(data.errorCode && data.errorCode !== '0'){
   	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + data.errorCode + "错误描述:" + data.errorMsg);
   	    		   $(".myMsgBox").delay(2000).fadeOut();
   	    		   return;
	   	    	}else if("ok"==data){
	    	    	$("#oldSign").css("display","");
	    			$("#newSign").css("display","none");
	    			$("#oldSign").html(opSignature);
	    			
	    			$("#editimg").attr("src","<%=path%>/image/edit_information.png");
	   	    	}
    	    }
		});
	}
	
	var prefile = "";
	//异步修改
	function ajaxFileUpload(){
		if(prefile === ""){
			prefile = $(".fileInput").val();
		}else if(prefile == $(".fileInput").val()){
			return;
		}
// 		var files = document.getElementById("uploadFile").files;
// 		if(files[0].size){
// 			$(".myMsgBox").css("display","").html("图片尺寸过大,请上传小于10M的图片!");
//     		$(".myMsgBox").delay(2000).fadeOut();
//     		return;
// 		}
		$.ajaxFileUpload({
			//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
			url:'<%=path%>/dcCrm/upload',
			secureuri:false,                       //是否启用安全提交,默认为false 
			fileElementId:'uploadFile',           //文件选择框的id属性
			dataType:'text',                       //服务器返回的格式,可以是json或xml等
			success:function(data, status){        //服务器响应成功时的处理函数
				prefile = "";
				$(".uptImg").empty();
				if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
					var width = $(window).width();
					if(width > 640){
						width = 640;
					}
					var path = "<%=path%>/contact/download?flag=dccrm&fileName="+data.substring(1);
					$(".uptImg").append('<img style="height: 200px; width:'+width+'px ;" src="'+path+'"></img>');
					$(":hidden[name=opImage]").val(data.substring(1));
					conform();
				}else{
					$(".myMsgBox").css("display","").html("图片上传失败,请重试");
		    		$(".myMsgBox").delay(2000).fadeOut();
				}
				$(".uptImg").append('<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">');
			},
			error:function(data, status, e){ //服务器响应失败时的处理函数
				prefile = "";
				$(".myMsgBox").css("display","").html("图片上传失败,请联系管理员");
	    		$(".myMsgBox").delay(2000).fadeOut();
	    		$(".uptImg").empty();
	    		$(".uptImg").append('<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif, image/x-png,image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">');
			}
		});
	}
	$(function () { 
		var width = $(window).width();
		if(width > 640){
			width = 640;
		}
		$(".bgimg").attr("width",width);

	});

</script>
</head>
<body style="background-color: #fff;min-height:100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:63px;">${operator.opName}</h3>
		<div class="act-secondary">
			<a href="<%=path%>/home/cancel?openId=${openId}&publicId=${publicId}" style="color:#fff;">取消绑定</a>
		</div>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="dccrmModify" method="post" novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="opName" value="${operator.opName}" /> 
				<input type="hidden" name="opDuty" value="${operator.opDuty}" />
				<input type="hidden" name="opDepart" value="${operator.opDepart}" />
				<input type="hidden" name="opCompany" value="${operator.opCompany}" /> 
				<input type="hidden" name="opMobile" value="${operator.opMobile}" />
				<input type="hidden" name="opPhone" value="${operator.opPhone}" />
				<input type="hidden" name="opEmail" value="${operator.opEmail}" /> 
				<input type="hidden" name="opFax" value="${operator.opFax}" />
				<input type="hidden" name="opCountry" value="${operator.opCountry}" />
				<input type="hidden" name="opProvince" value="${operator.opProvince}" /> 
				<input type="hidden" name="opCity" value="${operator.opCity}" />
				<input type="hidden" name="opStatus" value="${operator.opStatus}" />
				<input type="hidden" name="opGender" value="${operator.opGender}" />
				<input type="hidden" name="opAddress" value="${operator.opAddress}" />
				<input type="hidden" name="opId" value="${operator.opId}" />
				<input type="hidden" name="opImage" value="${operator.opImage}" />
				<input type="hidden" name="opSignature" value="${operator.opSignature}" />
				<div class="site-card-view">
					<div class="card-info fileInputContainer uptImg" 
						style="cursor:pointer;height: 200px; width: auto;">
						<c:if test="${operator.opImage eq ''}">
							<img style="height: 200px;" class="bgimg" src="<%=path%>/image/mvbg01.jpg"/>
						</c:if>
						<c:if test="${operator.opImage ne ''}"> 
							<img style="height: 200px; " class="bgimg" src="<%=path%>/contact/download?flag=dccrm&fileName=${operator.opImage}"/>
						</c:if>	
						<input type="file" onchange="ajaxFileUpload();" class="fileInput" accept="image/gif, image/x-ms-bmp, image/x-png,image/bmp,image/jpeg,image/png,image/jpg" style="height:200px;" name="uploadFile" id="uploadFile">
					</div>
					<div style="width: 100%; text-align: right; background: #fff;">
						<img src="${wxuser.headimgurl }"
							style="border-radius:0px; width: 100px; height: 100px; margin: -50px 15px 0 0; border: 5px solid #fff;position:relative;">
					</div>
					<div
						style="height: 100px; width: 100%;margin-top:-190px; text-align: center; font-family: 'Microsoft YaHei';">
							<div style="margin-top: 10px;">
								<img id="editimg" src="<%=path %>/image/edit_information.png" width="28px" onclick="showDoc();">
								<span id="oldSign" style="font-size: 17px; margin-top: 10px; color: #fff;font-weight:bold;font-size:20px;">${operator.opSignature }</span>
								<span  id="newSign" style="font-size: 17px; margin-top: 10px; color: #8D8B8B;display:none;"><input type="text" name="signature" placeholder="请输入个性签名" value="${operator.opSignature }"/></span>
							</div>
					</div>
					<div style="clear:both;margin-top:80px;"></div>
					<div class="card-info person_menu" style="text-align:center;z-index: 99999;opacity: 1;">
						<div style="float:left;width:25%; margin-top: 20px;">
							<a href="<%=path%>/dcCrm/detail?openId=${openId}&publicId=${publicId}">
								<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
								<div>
									<img src="<%=path%>/image/userinfo_p.png" style="width: 36px;">
								</div>
								<div style="text-align: center;margin-top:10px;">详情</div>
								</div>
							</a>
						</div>
						<div style="float:left;width:25%;margin-top: 20px;">
							<a href="<%=path%>/dcCrm/make?openId=${openId}&publicId=${publicId}">
								<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
								<div>
									<img src="<%=path%>/image/userinfo_qrcode.png" style="width: 36px;"/>
								</div>
								<div style="text-align: center;margin-top:10px;">二维码</div>
								</div>
							</a>
						</div>
						<div style="float:left;width:25%;margin-top: 20px;">
							<a href="<%=path%>/analytics/quota/quarter?openId=${openId}&publicId=${publicId}">
								<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
								<div>
									<img src="<%=path%>/image/userinfo_quota.png" style="width: 36px;"/>
								</div>
								<div style="text-align: center;margin-top:10px;">目标</div>
								</div>
							</a>
						</div>
						<c:if test="${SOCIAL_FLAG  eq '1'}">
							<div style="float:left;width:25%;margin-top: 20px;">
								<c:if test="${socialuser.uid eq '' || socialuser.uid == null}">
									<a href="${SOCIAL_URL}&state=${openId}">
										<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
										<div>
											<img src="<%=path%>/image/social_weibo.png" style="width: 36px;"/>
										</div>
										<div style="text-align: center;margin-top:10px;">微博</div>
										</div>
									</a>
								</c:if>
								<c:if test="${socialuser.uid ne '' && socialuser.uid != null }">
									<a href="<%=path%>/social/info?socialUID=${socialuser.uid}&openId=${openId}&publicId=${publicId}">
										<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
										<div>
											<img src="<%=path%>/image/social_weibo.png" style="width: 36px;"/>
										</div>
										<div style="text-align: center;margin-top:10px;">微博</div>
										</div>
									</a>
								</c:if>
							</div>
						</c:if>
						<div style="float:left;width:25%; margin-top: 20px;">
							<a href="<%=path%>/access/total?openId=${openId}&publicId=${publicId}&type=day">
								<div style="border:1px solid #efefef;margin:20px 5px 0px 5px;padding:10px;">
								<div>
									<img src="<%=path%>/image/userinfo_total.png" style="width: 36px;">
								</div>
								<div style="text-align: center;margin-top:10px;">访问统计</div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div style="clear:both;">&nbsp;</div>
	<div style="margin-top:80px;">&nbsp;</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>