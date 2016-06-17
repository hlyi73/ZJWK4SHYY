<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
String currUserName = UserUtil.getCurrUser(request).getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"type="text/javascript"></script>

<link href="<%=path%>/scripts/plugin/umeditor1/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/third-party/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.js"></script>
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/lang/zh-cn/zh-cn.js"></script>

<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/jbox.css" />

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
var um;
$(function (){
	$(".act_team").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage?id=${act.id}");
	});
	$(".act_yaoyue").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_invit?id=${act.id}");
	});
	$(".act_analytics").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_analytics?id=${act.id}");
	});
	
	//推荐
	$(".istuijian").click(function(){
		lovjs_choose('activiey_tuijian',{
    		success: function(res){
    			if($(":hidden[name=ispublish]").val() != res.key){
    				$(":hidden[name=ispublish]").val(res.key);
    				$(".tuijian_title").html('是否推荐：'+res.val);
    				updateAct('recommend');
    			}
    		}
    	});
	});
	
	//推荐
	$(".act_atten_set").click(function(){
		lovjs_choose('act_meet_attend',{
    		success: function(res){
    			if($(":hidden[name=resopentime]").val() != res.key){
    				//调用后台异步更新
    				//.........
    				$(":hidden[name=resopentime]").val(res.key);
    				$(".res_open_time__").html('资料公开时间：'+res.val);
    				updateAct('resopentime');
    			}
    		}
    	});
	});
	
	
	$(".act_content").click(function(){
		$(".basic_info__").css("display","none");
		$(".activity_content___").css("display","");
		$(".activity_resource__").css("display","none");
	});
	
	
	
	//返回
	$(".canceleditcontent").click(function(){
		$(".basic_info__").css("display","");
		$(".activity_content___").css("display","none");
		$(".activity_resource__").css("display","none");
	});
	
	$(".act_resource").click(function(){
		$(".basic_info__").css("display","none");
		$(".activity_content___").css("display","none");
		$(".activity_resource__").css("display","");
	});
	
	//$(".act_baseinfo_link").click(function(){
	//	window.location.href = '<%=path%>/zjwkactivity/manage_basic_info?id=${act.id}';		
	//});
	
	
	//上传资料
	$(".select_file").click(function(){
		$("#uploadResource").trigger("click");
	});
	var client = getClientBrower();
	if(client == 'mobile'){ 
		$(".client_model").css("display","");
	}else{
		$(".import_div").css("display","");
		$(".import_title").css("display","");
	}
	
	
	//实例化编辑器
	try{
		um = UM.getEditor('myEditor', {
	   	 	imagePath: '<%=path%>/mkattachment/download'
		});
		um.setContent('${act.content}');
	}catch(e){}
});  

function saveContent(type){
	if(type == 'mcontent'){
		var content = $("textarea[name=actcontent]").val();
		if($.trim(content) == ''){
			alert("活动内容不能为空！");
			return;
		}
		updateAct("mcontent");
	}else if(type == "pcontent"){
		if(um){
			var content = um.getContent();
			if($.trim(content) == ''){
				alert("活动内容不能为空！");
				return;
			}
			updateAct("pcontent");
		}
	}
}

var prefile = "";
//异步上传头像
function ajaxFileUpload(){
	if(prefile == ""){
		prefile = $(".fileInput").val();
	}else if(prefile == $(".fileInput").val()){
		return;
	}
	$.ajaxFileUpload({
		//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
		url:'<%=path%>/mkattachment/upload',
		secureuri:false,                       //是否启用安全提交,默认为false 
		fileElementId:'uploadFile',           //文件选择框的id属性
		dataType:'text',                       //服务器返回的格式,可以是json或xml等
		success:function(data, status){        //服务器响应成功时的处理函数
			prefile = "";
			$(".form-logo").empty();
			if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
				var path = "<%=path%>/mkattachment/download?fileName="+ data.substring(1) + "&flag=headImage";
				$(":hidden[name=logo]").val(data.substring(1));
				$(".form-logo").append('<img style="width: 100%;" src="' + path+ '"></img>');
				var modelImg = '<div style="margin-top: 10px; margin-left: 10px; float: left;">'
							 + '<img style="width: 65px; height: 65px;border: 2px solid #F4A421;"'
							 + 'src="'+path+'" alt="'+data.substring(1)+'"></div>';
				$(".imgchooselist").append(modelImg);
				updateAct('logo');
			} else {
				$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("图片上传失败，请重试或者联系管理员!"); 
	  		    $(".myvisitMsgBox").delay(2000).fadeOut();
			}
		},
		error : function(data, status, e) { //服务器响应失败时的处理函数
			prefile = "";
			$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("图片上传失败，请重试或者联系管理员!"); 
  		    $(".myvisitMsgBox").delay(2000).fadeOut();
			return;
		}
	});
}

function updateAct(type){
	var dataObj=[];
	if("logo" == type){//修改主题
		var logo = $(":hidden[name=logo]").val();
		dataObj.push({name:'logo',value:logo});
	}else if("recommend"==type){//修改是否推荐
		var ispublish = $(":hidden[name=ispublish]").val();
		dataObj.push({name:'ispublish',value:ispublish});
	}else if("resopentime"==type){//修改是否推荐
		var resopentime = $(":hidden[name=resopentime]").val();
		dataObj.push({name:'resopentime',value:resopentime});
	}else if("mcontent"==type){//修改是否推荐
		var mconent = $("textarea[name=actcontent]").val();
		dataObj.push({name:'content',value:mconent});
	}else if("pcontent" == type){
		if(um){
			var content = um.getContent(); 
			dataObj.push({name:'content',value:content});
		}else{
			return;
		}
	}else{
		return;
	}
	dataObj.push({name:'id',value:'${act.id}'});
	$.ajax({
		url:'<%=path%>/zjwkactivity/asyupd',
		type:'post',
		dataType:'text',
		data:dataObj,
		success:function(data){
			if('success'==data){
				if("mcontent"==type || "pcontent" == type){
					$(".canceleditcontent").trigger("click");
				}
			}else{
				$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败，请重试或者联系管理员!"); 
	  		    $(".myvisitMsgBox").delay(2000).fadeOut();
			}
		}
	});
}

//删除活动
function delActivity(id){
	var size = '${registSize}';
	var submit = function (v, h, f) {
        if (v == true){
        	$.ajax({
				type:'post',
				url:'<%=path%>/zjwkactivity/delAct',
				data:{id:id,type:'activity'},
				dataType:'text',
				success:function(data){
					if('0'==data){
						window.location.href="<%=path%>/zjactivity/list?viewtype=owner";
					}else{
						$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("删除失败，请联系管理员!"); 
			  		    $(".myvisitMsgBox").delay(2000).fadeOut();
					}
				}
			});
        }else{
        }
        return true;
    };
    if(size&&parseInt(size)>0){
		jBox.confirm("目前有"+(parseInt(size))+"个人已经报名，您确定要删除吗？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
	}else{
		jBox.confirm("您确定要删除吗？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
	}
}

var resFile = "";
function ajaxUploadResource(){
	if(resFile == ""){
		resFile = $("input[name=uploadResource]").val();
	}else if(resFile == $("input[name=uploadResource").val()){
		return;
	}
	//if(prefile.indexOf(".csv") == -1 && prefile.indexOf(".vcf") == -1 ){
	//	$("input[name=filename]").attr("placeholder","请选择csv或vcf文件");
	//	return;
	//}
	$("input[name=res_filename]").val(resFile);
	
	$(".shade").removeClass("none");
	$(".myDefMsgBox").removeClass("none");
	
	$.ajaxFileUpload({
		type:'post',
		url:'<%=path%>/mkattachment/uploadfile?id=${act.id}',
		secureuri:false,                       //是否启用安全提交,默认为false 
		fileElementId:'uploadResource',           //文件选择框的id属性
		dataType:'text',                       //服务器返回的格式,可以是json或xml等
		success:function(data, status){        //服务器响应成功时的处理函数
			$(".shade").addClass("none");
			$(".myDefMsgBox").addClass("none");
			if(!data){
				alert('上传失败！');
			}
			var d = JSON.parse(data);
			if(!d){
				alert('上传失败！');
			}
			var val = "";
			val +='<div style="padding: 8px 0px; font-size: 14px; border-bottom: 1px solid #eee;">';
			val +='<div style="float: left;">';
			if(d.file_type == 'doc' || d.file_type == 'docx'){
				val +='<img src="<%=path %>/image/attachment/attach_doc.png" width="36px" style="border-radius: 5px;">';
			}else if(d.file_type == 'xls' || d.file_type == 'xlsx'){
				val +='<img src="<%=path %>/image/attachment/attach_xls.png" width="36px" style="border-radius: 5px;">';
			}else if(d.file_type == 'ppt' || d.file_type == 'pptx'){
				val +='<img src="<%=path %>/image/attachment/attach_ppt.png" width="36px" style="border-radius: 5px;">';
			}else if(d.file_type == 'pdf'){
				val +='<img src="<%=path %>/image/attachment/attach_pdf.png" width="36px" style="border-radius: 5px;">';
			}else{
				val +='<img src="<%=path %>/image/attachment/attach_other.png" width="36px" style="border-radius: 5px;">';
			}
			val +='</div>';
			var fileName = resFile.split("\\");
			val +='<div style="line-height: 20px; padding-left: 50px;"><a href="${zjwk_file_service}/'+d.file_rela_name+'">'+fileName[fileName.length-1]+'</a></div>';
			val +='<div style="padding-left: 50px; line-height: 20px; color: #999;">文件大小：'+d.file_size+'KB';
			val += '</div></div>';
			$(".act_attachment_list").prepend(val);
			$("input[name=res_filename]").val('');
		},
		error:function(data, status, e){ //服务器响应失败时的处理函数
			$(".shade").addClass("none");
			$(".myDefMsgBox").addClass("none");
			alert('上传失败！');
		}
	}); 
}

//判断访问客户端
function getClientBrower(){
	var source = "";
	var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
    	source = "mobile";
    }else{//否则就是电脑域名打开
    	source = "windows";
    }
    return source;
} 

</script>
<style>
.tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
.canceleditcontent{
   background-color: #999;
   color: #fff;
   padding: 5px 20px;
   border-radius: 8px;
   font-size: 14px;
}
.saveeditcontent{
	background-color: RGB(75, 192, 171);
   color: #fff;
   padding: 5px 20px;
   border-radius: 8px;
   font-size: 14px;
}
.none{
	display:none;
}

.myDefMsgBox{
	width:140px;
	line-height:23px;
	position:fixed;
	left:50%;
	top:30%;
	background-color:#fff;
	border-radius:8px;
	border:1px solid #eee;
	margin-left:-70px;
	font-size: 14px;
  	padding: 10px;
  	z-index:999;
}
</style>
</head>
<body>
	<div id="task-create" class="font-size:14px;">
		<div id="site-nav" class="menu_activity zjwk_fg_nav">
		    <a href="javascript:void(0)" class="act_team" style="padding:5px 8px;">协同</a>
		    <a href="javascript:void(0)" class="tabselected act_baseinfo" style="padding:5px 8px;">基本信息</a>
		    <a href="javascript:void(0)" class="act_yaoyue" style="padding:5px 8px;">邀约</a>
		    <a href="javascript:void(0)" class="act_analytics" style="padding:5px 8px;">分析</a>
		</div>
		
		<div class="basic_info__">
			<div style="width:100%;background-color:#fff;padding:8px 15px;text-align:right;font-size:14px;">
				<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&sourceid=${sourceid}">预览</a>&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" onclick="delActivity('${act.id}');">删除</a>
			</div>
			
			<div style="width:100%;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;padding:5px;margin-top:5px;">
				<div>
					<div class="form-logo">
						<c:if test="${act.logo ne ''}">
							<img style="width: 100%;" src="${zjwk_file_service}/${act.logo}" alt="">
						</c:if>
						<c:if test="${act.logo eq ''}">
							<img style="width: 100%;" src="<%=path%>/image/default_activity.jpg"  alt="">
						</c:if>
					</div>
					<div>
						<a href="javascript:void(0)" style="position: absolute; right: 1em; margin-top: -2em; color: white;  background-color: #259933;border-radius: 10px;padding:3px;">
						<span class="text" style="box-sizing: border-box; color: rgb(255, 255, 255); cursor: pointer; display: inline; font-family: 'Microsoft YaHei'; font-size: 14px; height: auto; line-height: 16px; width: auto; word-wrap: break-word;">
							点击更换图片 <img src="<%=path%>/image/camera.png" style="width: 24px" alt="">
						</span> 
						<input type="file" onchange="ajaxFileUpload();" accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg" class="fileInput" name="uploadFile" id="uploadFile" style="height: 20px;">
					</a>
					</div>
					<input type="hidden" name="logo" value="${act.logo}">
				</div>
				<div style="text-align:center;font-size:16px;min-height:30px;margin-top:8px;border-bottom:2px solid #ddd;">${act.title}</div>
				<a href="<%=path%>/zjwkactivity/manage_basic_info?id=${act.id}" style="color:#333;">
					<div style="" class="act_baseinfo_link" >
						<div style="padding-left:10px;line-height:30px;font-size:14px;">
							<span>会议时间：${act.start_date} <c:if test="${act.act_end_date ne '' && !empty(act.act_end_date)}"> ~ ${act.act_end_date}</c:if></span>
						</div>
						<c:if test="${act.isregist eq 'Y' }">
							<div style="padding-left:10px;line-height:30px;font-size:14px;">
								<span>报名截止：${act.end_date}</span>
							</div>
						</c:if>
						<c:if test="${act.charge_type ne '' && !empty(act.charge_type)}">
							<div style="padding-left:10px;line-height:30px;font-size:14px;"><span>费&nbsp;&nbsp;用：${charge_type_value} <c:if test="${act.charge_type eq 'other' && act.expense ne '' && !empty(act.expense)}">(${act.expense}/人)</c:if></span></div>
						</c:if>
						<c:if test="${act.limit_number ne '' && !empty(act.limit_number)}">
							<div style="padding-left:10px;line-height:30px;font-size:14px;"><span>人&nbsp;&nbsp;数：${act.limit_number }人</span></div>
						</c:if>
						<!-- 联系人 -->
						<c:if test="${act.contactlistval ne '' && !empty(act.contactlistval)}">
							<div style="padding-left:10px;line-height:30px;font-size:14px;"><span>联系人：<a href="javascript:void(0)">${act.contactlistval }</a></span></div>
						</c:if>
						<!-- 主办 -->
						<c:if test="${act.customerlistval ne '' && !empty(act.customerlistval)}">
							<div style="padding-left:10px;line-height:30px;font-size:14px;"><span>主办：<a href="javascript:void(0)">${act.customerlistval }</a></span></div>
						</c:if>
					</div>
				</a>
				<div style="float: right;margin-top: -60px;margin-right: 10px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div class="act_content" style="width:100%;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;margin-top:25px;line-height:30px;">
				会议介绍
				<div style="float:right;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div class="act_resource" style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;margin-top:5px;line-height:30px;height:40px;">
				会议相关资料
				<div style="float:right;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div class="istuijian" style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;margin-top:5px;line-height:30px;">
				<input type="hidden" name="ispublish" value="${act.ispublish}">
				<c:if test="${act.ispublish eq 'open' }">
					<span class="tuijian_title">是否推荐：允许推荐</span>
				</c:if>
				<c:if test="${act.ispublish eq '' || empty(act.ispublish) || act.ispublish ne 'open' }">
					<span class="tuijian_title">是否推荐：不允许推荐</span>
				</c:if>
				<div style="float:right;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
		</div>
		
		<!-- 会议内容 -->
		<div class="activity_content___" style="display:none;">
			<!--  -->
			<c:if test="${isMobile eq true}">
				<c:if test="${act.source eq 'PC' }">
					<div style="background-color:#fff;font-size:14px;padding:5px 10px;color:red;line-height:20px;">此会议是由PC端创建，您可以通过PC端浏览器访问<a href="http://www.fingercrm.cn" style="border-bottom: 1px solid rgb(255, 136, 0);color: rgb(255, 136, 0);">www.fingercrm.cn</a>来修改，活动内容更丰富、更精彩！</div>
					<div style="padding:8px;">
						${act.content}
					</div>
					<br/>
					<div style="text-align:center;">
						<a href="javascript:void(0)" class="canceleditcontent">返回</a>
					</div>
				</c:if>
				<c:if test="${act.source ne 'PC' }">
					<textarea rows="10" cols="" name="actcontent">
						${act.content }
					</textarea>
					<br/><br/>
					<div style="text-align:center;">
						<a href="javascript:void(0)" class="canceleditcontent">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:void(0)" class="saveeditcontent" onclick="saveContent('mcontent')">保存</a>
					</div>
				</c:if>
			</c:if>
			<c:if test="${isMobile ne true}">
				<div>
					<script type="text/plain" id="myEditor" style="width:640px;height:280px;box-shadow:0"></script>
				</div>
				<br/>
				<div style="text-align:center;">
					<a href="javascript:void(0)" class="canceleditcontent">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:void(0)" class="saveeditcontent" onclick="saveContent('pcontent')">保存</a>
				</div>
			</c:if>
		</div>
		<!-- 会议资料 -->
		<div class="activity_resource__" style="display:none;">
			<div style="width:100%;line-height:30px;font-size:14px;padding-left:10px;">会议资料</div>
			<input type="hidden" name="resopentime" value="${act.resopentime}">
			<div class="act_atten_set" style="width:100%;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;margin-top:5px;line-height:30px;">
				<span class="res_open_time__">资料公开时间：
					<c:if test="${act.resopentime eq '0' || act.resopentime eq '' || empty(act.resopentime)}">马上公开</c:if>
					<c:if test="${act.resopentime eq '1'}">活动结束后公开</c:if>
				</span>
				<div style="float:right;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			
			<div class="client_model" style="display:none;margin-bottom:15px;background-color:#fff;padding:15px;margin-top:15px;line-height:25px;font-size:14px;">
				亲爱的<%=currUserName %>：<br/>
				<p>上传会议资料请在PC端导入，您可以通过PC端浏览器访问<a href="http://www.fingercrm.cn" style="border-bottom: 1px solid rgb(255, 136, 0);color: rgb(255, 136, 0);">www.fingercrm.cn</a>来导入文件！</p>
			</div>
			
			<br/>
			<!-- 活动资料 -->
			<div class="act_attachment_list" style="width:100%;padding:0px 10px;background-color:#fff;">
				<c:forEach items="${attList}" var="att">
					<div style="padding: 8px 0px; font-size: 14px; border-bottom: 1px solid #eee;">
						<div style="float: left;">
							<c:if test="${att.file_type eq 'doc' || att.file_type eq 'docx'}">
								<img src="<%=path %>/image/attachment/attach_doc.png" width="36px" style="border-radius: 5px;">
							</c:if>
							<c:if test="${att.file_type eq 'xls' || att.file_type eq 'xlsx'}">
								<img src="<%=path %>/image/attachment/attach_xls.png" width="36px" style="border-radius: 5px;">
							</c:if>
							<c:if test="${att.file_type eq 'ppt' || att.file_type eq 'pptx'}">
								<img src="<%=path %>/image/attachment/attach_ppt.png" width="36px" style="border-radius: 5px;">
							</c:if>
							<c:if test="${att.file_type eq 'pdf'}">
								<img src="<%=path %>/image/attachment/attach_pdf.png" width="36px" style="border-radius: 5px;">
							</c:if>
							<c:if test="${att.file_type ne 'pdf' && att.file_type ne 'ppt' && att.file_type ne 'pptx'&& att.file_type ne 'xlsx'&& att.file_type ne 'doc'&& att.file_type ne 'docx'}">
								<img src="<%=path %>/image/attachment/attach_other.png" width="36px" style="border-radius: 5px;">
							</c:if>
						</div>
						<div style="line-height: 20px; padding-left: 50px;"><a href="${zjwk_file_service}/${att.file_rela_name}">${att.file_name}</a></div>
						<div style="padding-left: 50px; line-height: 20px; color: #999;">
							文件大小：${att.file_size}KB
						</div>
					</div>
				</c:forEach>
			</div>
			<br/>
			
			<div class="import_div" style="display:none;background-color:#fff;padding:15px;margin-top:15px;line-height:25px;font-size:14px;text-align:center;border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
				<input type="text" name="res_filename" id="res_filename" style="border:0px;border-bottom:1px solid #ddd;" placeholder="未选择文件">
				<div style="margin-top:10px;">
					<a href="javascript:void(0)" class="canceleditcontent" style="padding:2px 15px;background-color:#fff;color:#666;">返回</a>
					<input type="button" name="selectfile" value="选择" class="btn select_file" style="width:25%;height:2em;line-height:2em;">
					<input type="button" name="upload_file" value="上传" class="btn upload_file" style="display:none;width:25%;height:2em;line-height:2em;">
					<input type="file" onchange="ajaxUploadResource();" style="width: 80px;height: 80px;display:none;" accept="*.*" name="uploadResource" id="uploadResource">
				</div>
			</div>
			<br/><br/><br/><br/><br/><br/><br/>
			<div class="myDefMsgBox none"><img src="<%=path %>/image/loading.gif" width="24px;">上传中。。。</div>
			<div class="shade none" style="z-index:10"></div>
		</div>
	</div>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	<div class="myvisitMsgBox" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
	</br></br></br></br></br></br>
</body>
</html>