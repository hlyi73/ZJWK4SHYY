<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String sessionid =  session.getId();
%>
<!DOCTYPE html>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指尖活动</title>
<%@ include file="/common/comlibs.jsp"%>
<link href="<%=path%>/css/pc/zjwk.module.css" rel="stylesheet">
<link href="<%=path%>/scripts/plugin/uploadify/uploadify.css" rel="stylesheet">
<link href="<%=path%>/css/pc/style.css" rel="stylesheet"> 
<link href="<%=path%>/css/pc/wx.css" rel="stylesheet"> 
<link href="<%=path%>/css/pc/wxedit.css" rel="stylesheet"> 
<link href="<%=path%>/css/pc/font-awesome.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/bootstrap.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/charts-graphs.css" rel="stylesheet">
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/css/pc/bootstrap.min.js"></script>
<link href="<%=path%>/scripts/plugin/umeditor1/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/third-party/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.js"></script>
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/lang/zh-cn/zh-cn.js"></script>
<script src="<%=path%>/scripts/plugin/uploadify/jquery.uploadify-3.1.min.js"></script>
<script src="<%=path%>/scripts/plugin/uploadify/swfobject.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<meta charset="UTF-8">
<script type="text/javascript">
var host = "";
$(function(){
	
	var height = screen.height;
	var width = screen.width;
	$(".dashboard-wrapper").css("min-height",parseInt(height)*0.9);
	$(".media_edit_area").css("width",parseInt(width)*0.5);
	$(".main_bd").css("margin-left",parseInt(width)*0.1);
	
	//显示摘要
	$(".js_addDesc").click(function(){
		$(".js_desc_area").css("display","");
	});
	
	//实例化编辑器
	var um = UM.getEditor('myEditor', {
	    imagePath: '<%=path%>/mkattachment/download'
	});
	um.setContent("");
    uploadImg();
    host = location.host;
    if(host.indexOf(":")!=-1){
    	host = host.substring(0,host.indexOf(":"));
    }
    initButton(um);
});
var time = (new Date()).getTime();
function uploadImg(){
	 //上传图片
	$("#uploadify").uploadify({
		//后台处理的页面
        'uploader': '<%=path%>/mkattachment/upload;',
        //是否自动上传
        'auto':true,
        'multi' : false,
        'swf': '<%=path%>/scripts/plugin/uploadify/uploadify.swf?var1='+time,
        //服务器端脚本使用的文件对象的名称 $_FILES个['upload']
        'fileObjName':'uploadFile',
        //浏览按钮的宽度
        'width':'100',
        'buttonText':"上传图片",
        //浏览按钮的高度
        'height':'32',
        //在浏览窗口底部的文件类型下拉菜单中显示的文本
        'fileTypeDesc':'支持的格式：',
        //允许上传的文件后缀
        'fileTypeExts':'*.jpg;*.jpeg;*.gif;*.png;*.bmp',
        //上传文件的大小限制
        'fileSizeLimit':'10MB',
        //返回一个错误，选择文件的时候触发
        'onSelectError':function(file, errorCode, errorMsg){
            switch(errorCode) {
                case -100:
                    alert("上传的文件数量已经超出系统限制的"+$('#uploadify').uploadify('settings','queueSizeLimit')+"个文件！");
                    break;
                case -110:
                    alert("文件 ["+file.name+"] 大小超出系统限制的"+$('#uploadify').uploadify('settings','fileSizeLimit')+"大小！");
                    break;
                case -120:
                    alert("文件 ["+file.name+"] 大小异常！");
                    break;
                case -130:
                    alert("文件 ["+file.name+"] 类型不正确！");
                    break;
            }
        },
        //检测FLASH失败调用
        'onFallback':function(){
            alert("您未安装FLASH控件，无法上传图片！请安装FLASH控件后再试。");
        },
        'onError': function(event, queueID, fileObj){
        	alert("文件:" + fileObj.name + " 上传失败");  
        },
        //上传到服务器，服务器返回相应信息到data里
        'onUploadSuccess':function(file, data, response){
        	if($(".upload_preview").has("img")){
        		$(".upload_preview").find("img").remove();	
        	};
        	$(".js_removeCover").css("display","none");
        	if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
  				var path = "<%=path%>/mkattachment/download?fileName="+data.substring(1)+"&flag=headImage";
  				$(":hidden[name=logo]").val(data.substring(1));
  				$(".js_removeCover").before('<img src="'+path+'"></img>');
  				$(".js_removeCover").css("display","");
  				$(".js_appmsg_thumb").removeClass("appmsg_thumb");
  				$(".js_appmsg_thumb").css("width","100%");
  				$(".js_appmsg_thumb").attr("src",path);
  			}else{
  				$(".upload_preview").html('图片上传失败，请重试！！');
  			}
        }
    });
}

function cloneText(obj){
	$(".appmsg_title").html($(obj).val());
	if(null==$(obj).val()||''==$(obj).val()){
		$(".appmsg_title").html("主题");
	}
}

//初始化按钮
function initButton(obj){
	
	//删除按钮
	$(".js_removeCover").click(function(){
		if($(".upload_preview").has("img")){
    		$(".upload_preview").find("img").remove();	
    	};
    	$(".js_removeCover").css("display","none");
		$(".js_appmsg_thumb").addClass("appmsg_thumb");
	});
	
	//直播改变事件
	$("#islive").change(function(){
		var value = $(this).val();
		if("open" == value){
    		$(".live_type").css("display","");
    	}else{
    		$(".live_type").css("display","none");
    	}
	});
	
	//提交按钮
	$("#js_submit").click(function(){
		if(!validates(obj)){
			var dataObj = getData();
			$("form[name=activityform]").submit();
// 			$.ajax({
// 				type: 'post',
<%-- 		      	url: '<%=path%>/activity/asysave', --%>
// 				data : dataObj,
// 				dataType : 'text',
// 				success : function(data) {
// 					var d = JSON.parse(data);
// 					if(d.errorCode&&d.errorCode=='0'){
// 						$(".myMsgBox").css("display","").html(d.errorMsg);
// 				    	$(".myMsgBox").delay(2000).fadeOut();
// 				    	document.domain=host;
// 				    	parent.redirectUrl(d.rowId);
// 					}else if(d.errorCode&&d.errorCode=='1'){
// 						$(".myMsgBox").css("display","").html(d.errorMsg);
// 				    	$(".myMsgBox").delay(2000).fadeOut();
// 					}else{
// 						$(".myMsgBox").css("display","").html(d.errorMsg);
// 				    	$(".myMsgBox").delay(2000).fadeOut();
// 					}
// 				}
// 			});
		}
	});
	
	//预览按钮
	$("#js_view").click(function(){
		if(!validates(obj)){
			var dataObj = getData();
			$.ajax({
				type: 'post',
		      	url: '<%=path%>/zjwkactivity/view',
				data : dataObj,
				dataType : 'text',
				success : function(data) {
					var d = JSON.parse(data);
					if(d.errorCode&&d.errorCode=='0'){
						$(".myMsgBox").css("display","").html(d.errorMsg);
				    	$(".myMsgBox").delay(2000).fadeOut();
				    	$(":hidden[name=rowid]").val(d.rowId);
					}else if(d.errorCode&&d.errorCode=='1'){
						$(".myMsgBox").css("display","").html(d.errorMsg);
				    	$(".myMsgBox").delay(2000).fadeOut();
					}else{
						$(".myMsgBox").css("display","").html(d.errorMsg);
				    	$(".myMsgBox").delay(2000).fadeOut();
					}
				}
			});
		}
	});
}

function getData(){
	var dataObj = [];
	$("form[name=activityform]").find(":hidden").each(function(){
		var name = $(this).attr("name");
		var value  = $(this).val();
		if('rowid'==name||'openId'==name||'source'==name||'sourceid'==name||'logo'==name||'remark'==name||'content'==name){
			dataObj.push({name:name,value:value});
		}
	});
	$("form[name=activityform]").find("input").each(function(){
		var name = $(this).attr("name");
		var value  = $(this).val();
		if('title'==name||'place'==name||'start_date'==name||'end_date'==name||'limit_number'==name){
			dataObj.push({name:name,value:value});
		}
	});
	$("form[name=activityform]").find("select").each(function(){
		var name = $(this).attr("name");
		var value  = $(this).val();
		if('charge_type'==name||'status'==name||'type'==name||'ispublish'==name||'isregist'==name||'islive'==name||'live_parameter'==name||'display_member'==name){
			dataObj.push({name:name,value:value});
		}
	});
	return dataObj;
}

function validates(obj){
		var flag= false ;
		var errorMsg='填写不完整!请您将带有*标签的字段都填上!';
		var content = obj.getContent();
		$(":hidden[name=content]").val(content);
		var desc = $("textarea[name=desc]").val();
		if(!desc){
			var re=/\r\n/;
			var remark = obj.getContentTxt();
			if(remark.length>35){
				desc = remark.substring(0,35).trim().replace(re,"");
			}else{
				desc = remark.trim().replace(re,"");
			}
		}
		$(":hidden[name=remark]").val(desc+"...");
		$("#activityform").find(":hidden").each(function(){
			var val=$(this).val();
			var name = $(this).attr("name");
			if('sourceid'==name||'source'==name||'logo'==name||'content'==name){
				if(!val||''==val.trim()){
					flag=true;
				}
			}
		});
		$("#activityform").find("input").each(function(){
			var val=$(this).val();
			var name = $(this).attr("name");
			if('title'==name||'place'==name||'start_date'==name||'end_date'==name||'limit_number'==name){
				if(!val){
					flag=true;
				}
			}
		});
		
		var number = $("input[name=limit_number]").val();
		if(number&&/[^\d]/.test(number)){
			$("input[name=limit_number]").val('').attr("placeholder","请输入整数！！");
		}
		if(!obj.hasContents()|| !($("input[name=place]").val())){
			flag=true;
		}
		var start = date2utc($('#start_date').val());
		var end = date2utc($('#end_date').val()); 
	    if(end>start){
	    	$('#end_date').val('').attr("placeholder","报名截止时间不能大于开始时间,请重新选择报名截止时间!");
			flag=true;
			errorMsg='报名截止时间不能大于开始时间,请重新选择报名截止时间!'
		}
	    
	    var act_end_date = date2utc($('#act_end_date').val()); 
	    if(start > act_end_date){
	    	$('#act_end_date').val('').attr("placeholder","活动结束时间不能早于活动开始时间,请重新选择活动结束时间!");
			flag=true;
			errorMsg='活动结束时间不能早于活动开始时间,请重新选择活动结束时间!'
		}
	    
	    $(":hidden[name=content]").val(content);
	    var live_parameter = $("select[name=live_parameter]").val();
		var isregist = $("select[name=isregist]").val();
		if('regist'==live_parameter&&'N'==isregist){
			flag=true;
			errorMsg='您选择的直播方式与是否报名有冲突，请重新选择后在提交！';
		}
	    if(flag){
			$(".myMsgBox").css("display","").html(errorMsg);
	    	$(".myMsgBox").delay(3000).fadeOut();
		  }
			return flag;
		}

</script>

</head>
<body style="background: #0B4364;">
	<!-- 菜单 -->
	<header style="">
    	<div style="float:left;padding-bottom:80px;">
	      <a href="javascript:void(0)" class="logo" data-original-title="" title="">
	        <span style="color:#fff;font-size:30px;font-weight:bold;">指尖微客</span>
	        <span style="color:#aaa;font-size:18px;">&nbsp;&nbsp;我的商务社交圈</span>
	      </a>
      </div>
      </header>
    <!-- Header End -->
    <!-- Main Container start -->
    <div class="dashboard-container" style="padding-top: 60px;margin-top:0px;">
      <div class="container">
        <!-- Top Nav Start -->
        <div class="top-nav hidden-xs hidden-sm">
          <div class="clearfix"></div>
        </div>
      </div>
    </div>
	<!-- 菜单结束 -->
	<div class="dashboard-wrapper" >
		<!-- Left Sidebar Start -->
			<div class="main_bd" style="">    
			<div class="media_preview_area">        
			    <div class="appmsg editing">            
			      <div id="js_appmsg_preview" class="appmsg_content">                                            
			        <div id="appmsgItem1" data-fileid="" data-id="1" class="js_appmsg_item">
				        <h4 class="appmsg_title" style="max-height: 60px;"><a onclick="return false;" class="title" href="javascript:void(0);" target="_blank">主题</a></h4>
				        <div class="appmsg_info">
				            <em class="appmsg_date"></em>
				        </div>
				        <div class="appmsg_thumb_wrp">
				            <img class="js_appmsg_thumb appmsg_thumb" src="">
				            <i class="appmsg_thumb default">封面图片</i>
				        </div>
	        			<p class="appmsg_desc"></p>
				    </div>
				   </div>                    
				 </div>    
			</div> 
			<div class="media_edit_area" style="display: block;margin-left:320px;min-width:870px;">          
	    	<div id="js_appmsg_editor"><div class="appmsg_editor" style="margin-top: 0px;padding-bottom:10px;">
	    	<form id="activityform" name="activityform" action="<%=path%>/zjwkactivity/save" method="post"  >
				<input type="hidden" name="content" value="" />
			    <input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="sourceid" value="${sourceid}" /> 
				<input type="hidden" name="source" value="${source}" /> 
				<input type="hidden" name="orgId" value="${orgId}" />
				<input type="hidden" name="logo" value="" />
				<input type="hidden" name="remark" value="" />
				<input type="hidden" name="return_url" value="${return_url}" />
				<input type="hidden" name="rowid" value="" />
				<div class="inner">
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动主题&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box">
							<input type="text" onkeyup="cloneText(this);" name="title" class="frm_input js_title">
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动地址&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box">
							<input type="text" name="place" class="frm_input js_author ">
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动开始时间&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box" style=" background-color: #efefef;">
							<jsp:include page="/common/marketing/datetime.jsp">
							    <jsp:param name="datetype" value="datetime" />
							    <jsp:param name="edit_flag" value="true"/>
							    <jsp:param name="fieldname" value="start_date"/>
							</jsp:include>
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动结束时间&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box" style=" background-color: #efefef;">
							<jsp:include page="/common/marketing/datetime.jsp">
							    <jsp:param name="datetype" value="datetime" />
							    <jsp:param name="edit_flag" value="true"/>
							    <jsp:param name="fieldname" value="act_end_date"/>
							</jsp:include>
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">报名截止时间&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box" style=" background-color: #efefef;">
							<jsp:include page="/common/marketing/datetime.jsp">
							    <jsp:param name="datetype" value="datetime" />
							    <jsp:param name="edit_flag" value="true"/>
							    <jsp:param name="fieldname" value="end_date"/>
							</jsp:include>
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">收费方式&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="charge_type" id="charge_type">
							<c:forEach items="${lov_charge_type }" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">是否公开&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="ispublish" id="ispublish">
							<c:forEach items="${lov_activity_ispublish}" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">是否需要直播&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="islive" id="islive">
							<c:forEach items="${lov_activity_islive}" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item live_type" >
						<label for="" class="frm_label">直播方式&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="live_parameter" id="live_parameter">
							<c:forEach items="${lov_activity_live_parameter}" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动是否需要报名&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="isregist" id="isregist">
							<c:forEach items="${lov_activity_isregist}" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">是否显示报名成员&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="display_member" id="display_member">
							<c:forEach items="${lov_activity_displaymenber}" var="item">
								<option value="${item.key }">${item.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动状态&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="status" id="status">
							<c:forEach items="${lov_activity_status}" var="item">
								<c:if test="${item.key eq 'publish' }">
									<option value="${item.key }" selected>${item.value}</option>
								</c:if>
								<c:if test="${item.key ne 'publish' }">
									<option value="${item.key }">${item.value}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">活动类型&nbsp;<span style="color:red;">*</span></label>
						<select class="frm_input_box" style="width:100%"name="type" id="type">
							<c:forEach items="${lov_activity_type }" var="item">
								<c:if test="${item.key ne 'meet'}">
									<option value="${item.key }">${item.value}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">人数限制&nbsp;<span style="color:red;">*</span></label>
						<span class="frm_input_box">
							<input type="text" name="limit_number" class="frm_input js_author ">
						</span>
					</div>
				</form>
			<div class="appmsg_edit_item">
				<label for="" class="frm_label">图片（大图片建议尺寸：900像素 * 500像素）</label>
				<input type="file" name="uploadFile" id="uploadify" />
				<p class="js_cover upload_preview">
					<a class="js_removeCover" href="javascript:void(0);" style="display:none;vertical-align: bottom;margin-left: 10px;">删除</a>
                </p>
			</div>
			<p style="padding-top:30px;">
				<a class="js_addDesc" href="javascript:void(0);" >添加摘要</a>
			</p>
			<div class="js_desc_area dn appmsg_edit_item" style="display: none;">
				<label for="" class="frm_label">摘要</label>
				<span class="frm_textarea_box">
					<textarea rows="3" style="width:100%;border:0px;" name="desc"></textarea> 
				</span>
			</div> 
			<div class="appmsg_edit_item">
				<label for="" class="frm_label">内容&nbsp;<span style="color:red;">*</span></label>
				<div style="padding-left: 5px;">
					<script type="text/plain" id="myEditor" style="min-width: 800px;height:240px;">
					</script>
				</div>
		</div>
		<i class="arrow arrow_out" style="margin-top: 0px;"></i>
		<i class="arrow arrow_in" style="margin-top: 0px;"></i>
	</div>
	</div>            
			</div>
			<div class="tool_area" style="clear: both;margin:0;padding:20px 0;">
		        <div class="tool_bar border tc" style="margin-left: 0;margin-right: 0;border-top: 1px solid #e7e7eb;text-align: center;-webkit-box-shadow: none;padding-bottom:15px;">
		            <span id="js_submit" class="btn btn_input btn_primary"><button>保存</button></span>
		            <span id="js_view" class="btn btn_input btn_primary"><button>预览</button></span>
		        </div>
		    </div>
	</div>
	</div>
	</div>
	<!-- 底栏 -->
	<footer style="margin-top:15px;">
	  <p>@2015 指尖活动</p>
	</footer>
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<!-- 底栏结束 -->	
</body></html>