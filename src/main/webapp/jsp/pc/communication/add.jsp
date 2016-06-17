<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html >

<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>




<head>
<script>
$(function () {
	type();
});

var path = "<%=path%>";


function initDate(){   
	//初始化渲染日期
	$("input[name=bxDateInput]").val(dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss"));
} 

function type(){
	var typeName= "<%=request.getParameter("type") %>";
	var typeId = "<%=request.getParameter("id") %>";
	var assignerid = "<%=request.getParameter("assignerid") %>";
	var orgId =  "<%=request.getParameter("orgId") %>";
	
	 $("input[name=orgId]").val(orgId);
	 $("input[name=assignerid]").val(assignerid);
	 $("input[name=typeId]").val(typeId);
	 $("input[name=typeName]").val(typeName);
}
</script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.colors.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.styles.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.syntax.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/xhtml.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.min.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.full.js"
	type="text/javascript"></script>
<script language="Javascript"
	src="<%=path%>/scripts/plugin/communication/js/htmlbox.undoredomanager.js"
	type="text/javascript"></script>
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/slider.css" />
<title>新增页面</title>

<script>
	function submit() {
		$("input[name=status]").val('1');
		var content=$("#ha_html").contents().find("body").html();
		$("input[name=bxDateInput]").val(dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss"));
		$("input[name=content]").val(content);
		$("#addFrm").submit();
	}

	function save() {
		$("input[name=status]").val('0');
		var content=$("#ha_html").contents().find("body").html();
		$("input[name=bxDateInput]").val(dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss"));
		$("input[name=content]").val(content);
		$("#addFrm").submit();
	}

	function desc() {
		$("#descrition").css("display", "");
		
	}

	/* function getContent() {
		alert($("#ha_html").contents().find("body").html());
	}
	 */
	function cancle(){
		 $("input[name=content]").val('');
		 $("input[name=title]").val('');
		 $("input[name=desc]").val('');
	}
	 
	//异步上传头像
	 function ajaxFileUpload(){
	 	$.ajaxFileUpload({
	 		//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
	 		url:'<%=path%>/contact/upload',
	 		secureuri:false,                       //是否启用安全提交,默认为false 
	 		fileElementId:'uploadFile',           //文件选择框的id属性
	 		dataType:'text',                       //服务器返回的格式,可以是json或xml等
	 		success:function(data, status){        //服务器响应成功时的处理函数
	 			$("#fileLoc").empty();
	 			if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
	 				var path = "<%=path%>/contact/download?fileName="+data.substring(1);
	 				$(":hidden[name=filename]").val(data.substring(1));
	 				$("#fileLoc").append('<img class="hello"width="70px;" height="70px;" src="'+path+'"></img>');
	 				
	 			}else{
	 				$("#result").css("display",'');
	 				$('#result').html('图片上传失败，请重试！！');
	 			}
	 			$("#fileLoc").append('<input type="file" onchange="ajaxFileUpload();"  class="fileInput" name="uploadFile" id="uploadFile">');
	 			//下一步
	 			$("#div_contact_phone_label").css("display","");
	 			$("#div_contact_phone_operation").css("display","");
	 		},
	 		error:function(data, status, e){ //服务器响应失败时的处理函数
	 			$("#result").css("display",'');
	 			$('#result').html('图片上传失败，请重试！！');
	 			$("#fileLoc").empty();
	 			$("#fileLoc").append('<input type="file" onchange="ajaxFileUpload();" class="fileInput" name="uploadFile" id="uploadFile">');
	 		}
	 	});
	 }
	 
</script>

</head>

<body style="background-color: rgb(155, 171, 199);">
	<div class="main_bd"
		style="line-height: 1.6; font-family: 'Microsoft YaHei'; color: #222; font-size: 16px; width: 50%; margin: 0 auto;">
		<form name="addFrm" id="addFrm"	action="<%=path%>/pccomm/save" method="post">
		   <input type="hidden" name="crmId" value="${crmId}" >
			    <input type="hidden" name="publicId" value="${publicId}" >
			    <input type="hidden" name="openId" value="${openId}" >
			    <input type="hidden" name="parentId" value="${parentId}" >
			    <input type="hidden" name="parentType" value="${parentType}" >
		        <input type="hidden" name="assignerid" value="" > 
		         <input type="hidden" name="orgId" value="" > 
		          <input type="hidden" name="filename" value="" > 
		          <input type="hidden" name="typeId" value="" >
		          <input type="hidden" name="typeName" value="" >  
		         <input type="hidden" name="status" value="" >     
			<div class="media_edit_area"
				style="display: table-cell; vertical-align: top; float: none; width: auto;">
				<div id="js_appmsg_editor">
					<div class="appmsg_editor" style="margin-top: 0px;">
						<div class="inner">
							<div class="appmsg_edit_item">
								<label for="" class="frm_label">标题</label> <span
									class="frm_input_box"> <input type="text" id="title" name="title"
									class=" title"></span>
							</div>
							<p>
								<a class="news_desc" href="javascript:void(0);"
									onclick="desc();">添加摘要</a>
							</p>
							<div class="descrition" id="descrition" style="display: none;">
								<label for="" class="frm_label">摘要</label> <span
									class="frm_textarea_box"> <textarea name="descrition"
										style="height: 100px; width: 100%"
										class="descrition">
										</textarea>
								</span>
							</div>
						
						<div class="chatItemContent">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="float:left">请上传头像：</div>
								</div>
								<div style="clear:both;"></div>
									<div id="fileLoc" class="fileInputContainer" style="margin-top:5px;">
										<input type="file" onchange="ajaxFileUpload();" class="fileInput"  name="uploadFile" id="uploadFile">
									</div>
									<div id="result" style="display:none;"></div>
								
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
						
								<div id="js_ueditor" class="appmsg_edit_item content_edit">
									<label for="" class="frm_label"> <strong class="news">正文</strong>
										<p class="tips">
											<em id="js_auto_tips">（已载入2014/08/05 09:42:40的草稿）</em> <a
												id="js_cancle" style="" href="javascript:void(0); " 
												onclick="cancle();">取消</a>
										</p>
									</label>
								</div>
								<div style="">
									<!-- 编辑器 -->
									<textarea id='ha' class="ha" style=""></textarea>
									<script language="Javascript" type="text/javascript">
										$("#ha")
												.css("height", "400px")
												.css("width", "100%")
												.htmlbox(
														{
															toolbars : [
																	[
																			// Cut, Copy, Paste
																			"separator",
																			"cut",
																			"copy",
																			"paste",
																			// Undo, Redo
																			"separator",
																			"undo",
																			"redo",
																			// Bold, Italic, Underline, Strikethrough, Sup, Sub
																			"separator",
																			"bold",
																			"italic",
																			"underline",
																			"strike",
																			"sup",
																			"sub",
																			// Left, Right, Center, Justify
																			"separator",
																			"justify",
																			"left",
																			"center",
																			"right",
																			// Ordered List, Unordered List, Indent, Outdent
																			"separator",
																			"ol",
																			"ul",
																			"indent",
																			"outdent",
																			// Hyperlink, Remove Hyperlink, Image
																			"separator",
																			"link",
																			"unlink",
																			"image"

																	],
																	[// Show code
																			"separator",
																			"code",
																			// Formats, Font size, Font family, Font color, Font, Background
																			"separator",
																			"formats",
																			"fontsize",
																			"fontfamily",
																			"separator",
																			"fontcolor",
																			"highlight", ],
																	[
																			//Strip tags
																			"separator",
																			"removeformat",
																			"striptags",
																			"hr",
																			"paragraph",
																			// Styles, Source code syntax buttons
																			"separator",
																			"quote",
																			"styles",
																			"syntax" ] ],
															skin : "blue"
														});
									</script>
								</div>
								<!--  <input type="button" value="获取源代码" onclick="getContent()"> -->
						</div>
					</div>
				</div>
				<div id="con" class="con" style="display:none;">
				   	<input name="content" id="content" value="">
				</div>
				<div id="date" class="date"  style="display:none;">
				   	<input name="bxDateInput" id="bxDateInput" value="">
				</div>
			</div>
		</form>
		<div class="tool_area">
			<div class="tool_bar border tc">
				<span id="js_submit" onclick="submit()">
					<button>提交</button>
				</span> <span id="js_preview" onclick="save()">
					<button>暂存草稿</button>
				</span>
			</div>
		</div>
	</div>
</body>
</html>
