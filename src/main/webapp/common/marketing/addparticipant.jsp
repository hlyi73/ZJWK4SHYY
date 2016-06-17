<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String participantpath = request.getContextPath();
	String participanttargetObj = request.getParameter("targetObj");
	String participanttargetObjTitle = request.getParameter("targetObjTitle");
	String participantrowid = request.getParameter("rowid");
	String participantsourceid = request.getParameter("sourceid");
	String participantsource = request.getParameter("source");
%>
<script>
$(function(){
	$("._shade_div").click(function(){
		showorhidden("hidden");
	});
	
	$(".saveParticipantBtn").click(function(){
		saveParticipant();
	});
	
});
function initUserDate(){
	$.ajax({
	      type: 'get',
	      url: '<%=participantpath%>/out/dcrmoper/search/<%=participantsourceid%>',
			data : {},
			dataType : 'text',
			success : function(data) {
				if(data){
					var d = JSON.parse(data);
					$("input[name=opName]").val(d.opName);
					$("input[name=opDuty]").val(d.opDuty);
					$("input[name=opCompany]").val(d.opCompany);
					$("input[name=opMobile]").val(d.opMobile);
				}
			}
		});
	
}
//添加报名
function saveParticipant(){
	
	if(validate_participant()){
		return;
	}
	$("#applyButton").css("display", "none");
	$("#applyButton").remove();
	if($(".attention1").attr("flag")=='show'){
		$(".attention1").css("display","none");
	}else if($(".attention").css("flag")=='show'){
		$(".attention").css("display","none");
	}
	var username = $("input[name=opName]").val();
	var dataObj = [];
	dataObj.push({name:'activityid', value: '<%=participantrowid%>' });
	dataObj.push({name:'sourceid', value: '<%=participantsourceid%>' });
	dataObj.push({name:'source', value: '<%=participantsource%>' });
	dataObj.push({name:'opName', value: username });
	dataObj.push({name:'opDuty', value: $("input[name=opDuty]").val()});
	dataObj.push({name:'opCompany', value: $("input[name=opCompany]").val() });
	dataObj.push({name:'opSignature', value: $("textarea[name=opSignature]").val() });
	dataObj.push({name:'opMobile', value: $("input[name=opMobile]").val() });
	dataObj.push({name:'code', value: $("input[name=code]").val() });
	$.ajax({
	      type: 'post',
	      url: '<%=participantpath%>/participant/save' || '',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				if(!data || data === '-1'){
					showorhidden('hidden');
					$("#myMsgBox").css("display","").html("报名失败!");
	    	    	$("#myMsgBox").delay(2000).fadeOut();
	    	    	return;
				}else if(data&&data=='errorCode'){
					$("#myMsgBox").css("display","").html("验证码不正确，请核实后再输入！");
	    	    	$("#myMsgBox").delay(2000).fadeOut();
	    	    	return;
				}else{
					 var d = JSON.parse(data);
					 if($("#noTeamuser")){
					 	$("#noTeamuser").css("display", "none"); 
						}
					 var item = '<div style="padding-bottom:5px;"><div class="teamPeason" style="float: left;width:65px;">';
						item +='<div style="text-align: center;margin-bottom: 5px;">';
						if(d[0].opImage&&d[0].opImage!=''){
							item +='<img src="'+d[0].opImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
						}else{
						item +='<img src="<%=participantpath%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
						}
						item +='</div></div>';
					    item +='<div style="padding-left:70px;"><div style="margin-top: 20px;line-height:15px;height:15px;">'+$("input[name=opName]").val()+'</div>';
						item+='<div style="margin-top: 10px;line-height:15px;height:15px;">公司/职位：'+$("input[name=opCompany]").val()+'&nbsp;/&nbsp;'+$("input[name=opDuty]").val();
						item+='<span style="color: #bdbdbd;float: right;font-size: 12px;" ><a href="javascript:void(0)">刚刚</a></span>';
					    item+= '</div>';
					$("#<%=participanttargetObj%>").prepend(item); 
					$("#<%=participanttargetObjTitle%> span").html(parseInt($("#<%=participanttargetObjTitle%> span").html())+1);
					$("#applyButton").css("display", "none");
					$("#applyButton").remove();
					//本地缓存
	     	        sessionStorage.setItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Apply","already");
					showorhidden("hidden");
					initControl();
	    	    	$("html,body").animate({scrollTop:$("#<%=participanttargetObjTitle%>").offset().top},1000);
	    	    	var sourceid= "<%=participantsourceid%>";
					$("#myMsgBox").css("display","").html("报名成功，感谢参与!");
	    	    	$("#myMsgBox").delay(2000).fadeOut();
	    			//如果是从new_detail进来的，则不需要获取用户信息
	    			if(sourceid){
		    	    	window.location.replace("<%=participantpath%>/participant/msg?username="+username+"&id=<%=participantrowid%>");
	    			}
				}
			}
		});
	}
	
	function initControl(){
		$("input[name=opName]").val('');
		$("input[name=opDuty]").val('');
		$("textarea[name=opSignature]").val('');
		$("input[name=opCompany]").val('');
		$("input[name=opMobile]").val('');
	}
	//验证所有的参数是否都已经填写
	function validate_participant() {
		var flag = false;
		$("#activity_participant_form").find(":hidden").each(function() {
			var val = $(this).val();
			if (!val) {
				flag = true;
			}
		});
		$("#activity_participant_form").find("input").each(function() {
			var val = $(this).val();
			if (!val) {
				flag = true;
			}
			if( $(this).attr("name")== 'opMobile'){
  				var exp = /^1[3|4|5|8][0-9]{9}$/;
  				var r = exp.test($("input[name=opMobile]").val());
	  				if (!r) {
	  					$("input[name=opMobile]").val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
	  					return true;
	  				}
  				}
		});
		if (flag) {
			$("#myMsgBox").css("display",'');
			$("#myMsgBox").html("填写不完整!请您将相关信息都填上!");
			$("#myMsgBox").delay(2000).fadeOut();
			return true;
		}
	}

	//显示或隐藏
	function showorhidden(type) { 
		var sourceid= "<%=participantsourceid%>";
		//如果是从new_detail进来的，则不需要获取用户信息
		if(sourceid){
			initUserDate();
		}
		if (type == 'hidden') {
			$("._activity_participant_div").animate({
				height : '0px'
			}, [ 5000 ]);
			$("._shade_div").css("display", "none");
			$(".msgContainer").css("display", "");
			$("#applyButton").css("display", "");
			$("#update").css("display","none");
    		if($(".attention1").attr("flag")=='show'){
				$(".attention1").css("display","");
			}else if($(".attention").css("flag")=='show'){
				$(".attention").css("display","");
			}
		} else if (type == 'display') {
			$("._shade_div").css("display", "");
			$(".msgContainer").css("display", "none");
			$("#applyButton").css("display", "none");
			$("#update").css("display","none");
    		if($(".attention1").attr("flag")=='show'){
				$(".attention1").css("display","none");
			}else if($(".attention").css("flag")=='show'){
				$(".attention").css("display","none");
			}
			$("._activity_participant_div").animate({
				height : '300px'
			}, [ 5000 ]);
		}
	}
	
	var InterValObj; //timer变量，控制时间  
	var count = 90; //间隔函数，1秒执行  
	var curCount;//当前剩余秒数  
	var code = ""; //验证码  
	var codeLength = 6;//验证码长度 
	
	//获取短信验证码
	function sendMsg(){
	     var jbPhone = $("#opMobile").val();  
	     var exp = /^1[3|4|5|8][0-9]{9}$/;
	     var r = exp.test(jbPhone);
		 if (!r) {
			$("input[name=opMobile]").val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
			return;
		 }
		 curCount = count;  
          // 产生验证码  
          for ( var i = 0; i < codeLength; i++) {  
             code += parseInt(Math.random() * 9).toString();  
          }  
          // 设置button效果，开始计时  
          $("#btnSendCode").attr("disabled", "true");  
          $("#btnSendCode").val("请在" + curCount + "秒内输入验证码");  
          InterValObj = window.setInterval(SetRemainTime, 1000); // 启动计时器，1秒执行一次  
          // 向后台发送处理数据  
          $.ajax({  
             type: "post", // 用POST方式传输  
             dataType: "text", // 数据格式:JSON  
             url: "<%=participantpath%>/participant/sendMsg", // 目标地址  
             data: {"phonenumber":jbPhone,"code":code,"activityid":'<%=participantrowid%>',"sourceid":'<%=participantsourceid%>'},  
             success: function (data){   
                 data = parseInt(data);
                 //短信获取成功
                 if(data == 0){  
                	$("#myMsgBox").css("display",'');
         			$("#myMsgBox").html("验证码已发送，请查看您的手机输入验证码！");
         			$("#myMsgBox").delay(2000).fadeOut();
                 }else if(data == 1){//短信获取失败
                	window.clearInterval(InterValObj);// 停止计时器  
         	        $("#btnSendCode").removeAttr("disabled");// 启用按钮  
         	        $("#btnSendCode").val("重新发送验证码"); 
         	        code="";
                 }else if(data == -1){
                	 window.clearInterval(InterValObj);// 停止计时器 
          	         $("#btnSendCode").val("重新发送验证码"); 
          	         code="";
          	        $("#myMsgBox").css("display",'');
        			$("#myMsgBox").html("您已报名了此活动，感谢您的参与！");
        			$("#myMsgBox").delay(2000).fadeOut();
        			showorhidden("hidden");
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
	        code="";
	    }else {  
	        curCount--;  
	        $("#btnSendCode").val("请在" + curCount + "秒内输入验证码");  
	    }  
	} 
	
</script>
<style>
._activity_participant_div{
	width:100%;
	background-color:#fff;
	border-top:1px solid #eee;
	z-index:101;
	opacity: 1;
	padding:0px 10px;
	font-size:14px;
	height:0px;
	overflow:auto;
}
</style>
<form name="activity_participant_form" id="activity_participant_form">
<div class="_activity_participant_div flooter">
	<div class="form-group">
		<input name="opName" id="opName"
			value="" type="text" placeholder="您的姓名">
	</div>
	<div class="form-group">
		<input name="opMobile" id="opMobile"
			value="" type="number"  placeholder="联系电话">
	</div>
	<% 
		String serviceOpen = PropertiesUtil.getMsgContext("service.open");	
		if("1".equals(serviceOpen)){
	%>
		<div class="form-group">
			<input name="code" style="width:40%"id="code" type="number" value="" maxLength="6" placeholder="请输入验证码">
			<input type="button" style="font-size:14px;float: right;height: 2.2em;width:55%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);" id="btnSendCode" name="btnSendCode" value="免费获取验证码" onclick="sendMsg()" />
		</div>
		<%} %>
	<div class="form-group">
		<input name="opCompany" id="opCompany"
			value="" type="text"  placeholder="公司名称">
	</div>
	<div class="form-group">
		<input name="opDuty" id="opDuty"
			value="" type="text"  placeholder="您的职位">
	</div>
	<div class="button-ctrl">
		<fieldset class="">
			<div class="ui-block-a" style="width: 100%;">
				<a href="javascript:void(0)" class="btn btn-block saveParticipantBtn"
					style="font-size: 16px;">提交</a>
			</div>
		</fieldset>
	</div>
</div>
<div class="shade _shade_div" style="display:none;z-index:99;">&nbsp;</div>
</form>