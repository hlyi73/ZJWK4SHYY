<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String ertpath = request.getContextPath();	
	String relaModule = request.getParameter("relaModule");
	relaModule = (null == relaModule ? "" : relaModule);
%>
<script src="<%=ertpath%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script type="text/javascript">

var ert = {};

function initErtUserForm(){
	ert.suSelectedDiv = $("#shareuser-more-selected");
	ert.suSelectedList = ert.suSelectedDiv.find(".suSelectedList");
}

//初始化@团队用户
function initErtUserBtn(){
	//分配 goback按钮
	$(".suSeletedGoBak").click(function(){
		ert.suSelectedDiv.addClass("modal");
		showErtUserListModel();
	});
}

function handlerErtUserList(v, tLeas){
	//内容改变事件
	valErtUserListModel(v);
	//@ 某人
    if(v && v.charAt(v.length-1) === "@"){
    	ert.suSelectedDiv.removeClass("modal");
        hideErtUserListModel();
        compileTeamLeas(tLeas);//组装团队成员
    }else{
    	ert.suSelectedDiv.addClass("modal");
        showErtUserListModel();
    }
}

//组装团队成员
function compileTeamLeas(tLeas){
	if(tLeas.length === 0){
		$(".suSelectedList").html('<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">无数据</div>');
		return;
	}
	
	var ertusrtpl =  ['<a href="javascript:void(0)" class="list-group-item listview-item radio" >',
			      		    '<div>',
				 	           '<img class="msgheadimg" style="border-radius:5px" userid="$$shareuserid"',
				 	                'src="<%=ertpath%>/image/defailt_person.png" width="40px">',
				 	        '</div>',
				 	 		'<div class="list-group-item-bd">',
				 	     		'<input type="hidden" name="userid" value="$$shareuserid02"/>',
				 	     		'<input type="hidden" name="username" value="$$shareusername"/>',
				 	     		'<h2 class="title " style="margin-left: 10px">$$shareusername02</h2>',
				 	 		'</div>',
				 		'</a>'];
	//遍历数组
	var html = '';
	$.each(tLeas, function(i, v){
		var subhtml = ertusrtpl.join("").replace("$$shareuserid", v.uid).replace("$$shareusername", v.uname);
		subhtml = subhtml.replace("$$shareuserid02", v.uid).replace("$$shareusername02", v.uname);
		html += subhtml;
	});
	//绑定事件
	$(".suSelectedList").html(html).find("img").each(function(){
		var userid = $(this).attr("userid");
		loadErtUserImg(userid, $(this));
		
	}).end().find("a").click(function(){
		
		var t = $(this).find("h2").html();
		p.inputTxt.val(p.inputTxt.val() + t+" ");
		
		ert.suSelectedDiv.addClass("modal");
		showErtUserListModel();
		return false;
	});
}

function valErtUserListModel(v){
	if(p.msgModelType.val() === "Opportunities"){
		if(v !== ''){
			$(".examinerSend").css("display","");
			$(".addBtn").css("display","none");
		}else{
			$(".examinerSend").css("display","none");
			$(".addBtn").css("display","");
		}
	}
}

function showErtUserListModel(){
	p.crmDetailForm.css("display","");
	p.nativeDiv.css("display", "");
}

function hideErtUserListModel(){
	p.nativeDiv.css("display", "none");
	p.crmDetailForm.css("display","none");
}

function loadErtUserImg(userId, img){
	//显示单个图片头像
   	if(sessionStorage.getItem(userId + "_headImg")){
   		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
   		return;
   	}
	if(userId){
   		//异步调用获取消息数据
       	$.ajax({
    		url: '<%=ertpath%>/wxuser/getImgHeader',
    		type: 'get',
    		data: {crmId: userId},
    		dataType: 'text',
    	    success: function(data){
    	    	if(data){
     	    	  $(img).attr("src",data);
     	    	  //本地缓存
     	          sessionStorage.setItem(userId + "_headImg",data);
     	    	}
    	    }
    	});
	}
}

$(function(){
	initErtUserForm();
	initErtUserBtn();
	$(".shade").click(function(){
		$(".shade").css("display","none");
		$("#contactmap").css("display","none");
	});
});
</script>

<!-- 已经选择的  共享用户列表DIV -->
<div id="shareuser-more-selected" class="modal">
	<div id="" class="navbar">
	    <a href="javascript:void(0)" class="act-primary suSeletedGoBak"><i class="icon-back"></i></a>
		选择用户
	</div>
	<div class="page-patch">
		<div class="list-group listview  suSelectedList">
		</div>
		<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
			<input class="btn btn-block suSelectedbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" />
		</div>
	</div>
</div>




 <script type="text/javascript">
    $(function(){
    	if(!document.getElementById("inputMsg")){
    		return;
    	}
    	$("#inputMsg").bind("propertychange",function(){
        	
        	if("<%=relaModule%>" != 'schedule' && '<%=relaModule%>' != 'WorkReport'){
        		var v = $(this).val();
	    		if(v !== ''){
	        		$(".examinerSend").css("display","");
	        		$(".addBtn").css("display","none");
	        	}else{
	        		$(".examinerSend").css("display","none");
	        		$(".addBtn").css("display","");
	        	}
        	}
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
        });
    	$("#inputMsg").bind("input",function(){
    		if("<%=relaModule%>" != 'schedule' && '<%=relaModule%>' != 'WorkReport'){ 
	        	var v = $(this).val();
	    		if(v !== ''){
	        		$(".examinerSend").css("display","");
	        		$(".addBtn").css("display","none");
	        	}else{
	        		$(".examinerSend").css("display","none");
	        		$(".addBtn").css("display","");
	        	}
    		}
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
        });
    	
    	autoTextArea("inputMsg");
    });
        
    function autoTextArea(elemid){
        //新建一个textarea用户计算高度
        if(!document.getElementById("_textareacopy")){
            var t = document.createElement("textarea");
            t.id="_textareacopy";
            t.style.position="absolute";
            t.style.left="-9999px";
            t.rows = "1";
            t.style.lineHeight="20px";
            t.style.fontSize="16px";
            document.body.appendChild(t);
        }
        function change(){
        	document.getElementById("_textareacopy").value= document.getElementById("inputMsg").value;
        	var height = document.getElementById("_textareacopy").scrollHeight;
        	if(height>100){
        		return;
        	}
        	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
        		document.getElementById("inputMsg").style.height= "40px";
        	}else{
            	document.getElementById("inputMsg").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
        	}
        }
        
        $("#inputMsg").bind("propertychange",function(){
        	change();
        });
        $("#inputMsg").bind("input",function(){
        	change();
        });

        document.getElementById("inputMsg").style.overflow="hidden";//一处隐藏，必须的。
        document.getElementById("inputMsg").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
    }
    
    function _initMessageControl(){
    	if(document.getElementById("inputMsg")){
    		document.getElementById("inputMsg").style.height = "40px";
    		document.getElementById("inputMsg").value = "";
    		document.getElementById("inputMsg").rows = "1";
    		document.body.removeChild(document.getElementById("_textareacopy"));
        	autoTextArea("inputMsg");
    	}
    }
    
</script>
