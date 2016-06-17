<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String ipath = request.getContextPath();
    String parentid = request.getParameter("parentid");
    String parenttype = request.getParameter("parenttype");
    String sourceOrgId = request.getParameter("sourceOrgId");
    
%>
<script type="text/javascript">
$(function(){
	$("._importbtn").click(function(){
		$.ajax({
	   		url: '<%=ipath%>/operorg/synclist',
	   		type: 'post',
	   		data: {openId:'${openId}',orgIdNot:'Default Organization'},
	   		//async: false,
	   		dataType: "text",
	   	    success: function(data){
	   	    	if(!data){
	   	    		$("._orglist").html('没有企业！');
	   	    		return;
	   	    	}
	   	    	var d = JSON.parse(data);
	   	    	if(d){
	   	    		
	   	    		var val = '';
	   	    		$(d).each(function(){
	   	    			val += '<a style="line-height:50px;width:100%;text-align:center;" href="javascript:void(0)" onclick="importRecord(\''+this.orgId+'\')"><div style="border-bottom:1px solid #eee;">'+this.orgName+'</div></a>';
	   	    		});
	   	    		$("._orglist").html(val);
	   	    		$("._orglist").css('display','');
	   	    		
	   	    		$("._shade").css("display","");
	   	 		    $("._orglist").animate({height : $(d).size()*50}, [ 10000 ]);
	   	 		
	   	    	}else{
	   	    		$("._orglist").html('没有企业！');
	   	    	}
	   	    },
	   	    error:function(e){
	   	    	
	   	    }
		});
	});
	
	$("._shade").click(function(){
		$("._shade").css("display","none");
		$("._orglist").animate({height : 0}, [ 10000 ]);
	});
});

//导入数据
function importRecord(orgId){
	var parentid = "<%=parentid%>";
	var parenttype = "<%=parenttype%>";
	var sourceOrgId = "<%=sourceOrgId%>";
	if(!parentid || !parenttype || !orgId){
		$("._myMsgBox").css("display","").html("请选择！");
	    $("._myMsgBox").delay(2000).fadeOut();
		return;
	}
	$.ajax({
   		url: '<%=ipath%>/operorg/importRecord',
   		type: 'post',
   		data: {openId:'${openId}',sourceOrgId:sourceOrgId,targetOrgId:orgId,parentid:parentid,parenttype:parenttype},
   		//async: false,
   		dataType: "text",
   	    success: function(data){
   	    	if(data && data == "0"){
   	    		alert("导入成功！");
/*    	    		$("._myMsgBox").css("display","").html("导入成功！");
   	 	    	$("._myMsgBox").delay(2000).fadeOut(); */
   	    	}else{
   	    		$("._myMsgBox").css("display","").html("导入失败！");
   		 	    $("._myMsgBox").delay(2000).fadeOut();
   	    	}
   	    	$("._shade").css("display","none");
			$("._orglist").animate({height : 0}, [ 10000 ]);
   	    	
   	    },
   	    error:function(e){
   	    	$("._myMsgBox").css("display","").html("导入失败！");
	 	    $("._myMsgBox").delay(2000).fadeOut();
	 	    $("._shade").css("display","none");
			$("._orglist").animate({height : 0}, [ 10000 ]);
   	    }
	});
}
</script>

<!-- 责任人列表DIV -->
<div class="_orglist flooter" style="font-size:16px;z-index:999999;height:0px;background-color:#fff;opacity:1;display:none;width:100%;">
		
</div>

<div class="shade _shade" style="display:none;margin-top:0px;top:0px;z-index:1000"></div>
<div class="_myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 42px;padding: 3px 0px 2px 0px;">&nbsp;</div>