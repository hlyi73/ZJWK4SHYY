<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<!-- Meta -->
		<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
		<meta name="viewport"
			content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
		<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
		<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
        <script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
		<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
		<!--框架样式-->
		<script type="text/javascript">
		    $(function () {
		    	
			});
		    
		    //异步上传头像
		    function ajaxFileUpload(){
		    	$.ajaxFileUpload({
		    		//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
		    		url:'<%=path%>/lic/exportzip',
		    		secureuri:false,                       //是否启用安全提交,默认为false 
		    		fileElementId:'uploadFile',           //文件选择框的id属性
		    		dataType:'text',                       //服务器返回的格式,可以是json或xml等
		    		success:function(data, status){        //服务器响应成功时的处理函数
		    			$("#fileLoc").empty();
		    			if(data === "succ"){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
		    				alert('导入成功');
		    				
		    			}else{
		    				$("#result").css("display",'');
		    				$('#result').html('导入失败，请重试！！');
		    			}
		    			$("#fileLoc").append('<input type="file" onchange="ajaxFileUpload();"  class="fileInput" name="uploadFile" id="uploadFile">');
		    		},
		    		error:function(data, status, e){ //服务器响应失败时的处理函数
		    			$("#result").css("display",'');
		    			$('#result').html('导入失败，请重试');
		    			$("#fileLoc").empty();
		    			$("#fileLoc").append('<input type="file" onchange="ajaxFileUpload();" class="fileInput" name="uploadFile" id="uploadFile">');
		    		}
		    	});
		    }
		
		</script>
	</head>
	<body>
		<div id="fileLoc" class="fileInputContainer" style="margin-top:5px;">
			<input type="file" onchange="ajaxFileUpload();" class="fileInput"  name="uploadFile" id="uploadFile">
		</div>
		<div id="result" style="display:none;"></div>
	</body>
</html>