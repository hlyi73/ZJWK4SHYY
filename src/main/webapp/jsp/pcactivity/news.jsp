<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指尖活动</title>
<%@ include file="/common/comlibs.jsp"%>
<link href="<%=path%>/css/pc/zjwk.module.css" rel="stylesheet">
<link href="<%=path%>/css/pc/style.css" rel="stylesheet"> 
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
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<link href="<%=path%>/css/public.css" rel="stylesheet">
<link href="<%=path%>/css/mylive.css" rel="stylesheet">

<script type="text/javascript">
	$(function() {
		var height = screen.height;
		$(".dashboard-wrapper").css("min-height", parseInt(height) * 0.9);
		var width = screen.width;
		//实例化编辑器
		var um = UM.getEditor('myEditor', {
		    imagePath: '<%=path%>/attachment/download',
		    initialFrameHeight:200
		});
		um.setContent("");
		initForm(um);
	});
	
	function initForm(obj){
		if(parseInt('${fn:length(msglist)}')<=0){
			var html = '<li class="nodata"><div style="text-align:center;padding-top:50px;">暂时还没有评论哦！</div></li>';
			$("#ul2").append(html);
		}
		//发送消息
		$(".sendMsg").click(function(){
			var content = obj.getContent();
			if(!content||''==content.trim()){
				$(".myMsgBox").css("display","").html("评论不能为空，请输入评论！！");
		    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			if(content.indexOf("<img")!=-1){
				$(":hidden[name=msg_type]").val("img");
			}else if(content.indexOf("<a")!=-1){
				$(":hidden[name=msg_type]").val("link");
			}else{
				$(":hidden[name=msg_type]").val("txt");
			}
			$(":hidden[name=content]").val(content);
			//判断是不是主持人
			if('${sourceid}'=='${activity.createBy}'){
				$(":hidden[name=compere]").val('1');				
			}
			var dataObj = [];
			$("form[name=directform]").find(":hidden").each(function(){
				var v = $(this).val();
				var n = $(this).attr("name");
				dataObj.push({name:n,value:v});
			});
			var dateStr = dateFormat(new Date(), "MM-dd hh:mm");
			$.ajax({
				type: 'post',
		      	url: '<%=path%>/activity/savedirect',
				data : dataObj,
				dataType : 'text',
				success : function(data) {
					if(data){
						start = parseInt(start) +1;
						$(".nodata").remove();
						var html = '<li id="'+data+'"><div class="patch"><div class="patch_con"><div class="top"></div>'
							 + '<div class="left" style="background:url(<%=path%>/image/direct/center.png) 0 0 repeat-y;padding:5px 10px;line-height:25px;">'
							 + '<div>'+dateStr+'</div>'
							 + '<div>'+content+'</div></div><div class="bottom"></div><div class="jiantou"></div></div>'
							 + '<div class="time"><span></span><p>';
						if('${user.headImageUrl}'==''){
			   				html +='<img class="msgheadimg" style="border-radius:5px" src="<%=path %>/image/defailt_person.png" width="40px">';
						}else{
							html +='<img class="msgheadimg" style="border-radius:5px" src="${user.headImageUrl}" width="40px">';
						}  			
						html +='</p><br><p><em>${user.nickName}</em></p></div></div></li>';
						$("#ul2").prepend(html);
						obj.setContent("");
					}else{
						$(".myMsgBox").css("display","").html("操作失败，请联系开发人员！！！");
				    	$(".myMsgBox").delay(2000).fadeOut();
					}
				}
			});
		});
		t1 = window.setInterval(load,second); 
	}
	
	//定时刷新
	var seq = 0; //
	var second=5000; //间隔时间2秒钟
	var t1;
	var errcount = 0;
	var start = "${fn:length(msglist)}";
	
	function load(){
		$.ajax({
			url: '<%=path%>/activity/readdirect',
			dataType: 'text',
			data: {
				activity_id: '${activity.id}',
				source: 'P',
				start: start
			},
			success: function(data){
				errcount = 0;
		    	if(!data){
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	if(d){
		    		start = parseInt(start) + $(d).size();
		    		$(d).each(function(){
		    			var dateStr = dateFormat(new Date(this.created_time), "MM-dd hh:mm");
		    			var html = '<li id="'+this.id+'"><div class="patch"><div class="patch_con"><div class="top"></div>'
		   				 + '<div class="left" style="background:url(<%=path%>/image/direct/center.png) 0 0 repeat-y;padding:5px 10px;line-height:25px;">'
		   				 + '<div>'+dateStr+'</div>'
		   				 + '<div>'+this.content+'</div></div><div class="bottom"></div><div class="jiantou"></div></div>'
		   				 + '<div class="time"><span></span><p>';
			   			if(this.headimgurl==''){
			      			html +='<img class="msgheadimg" style="border-radius:5px" src="<%=path %>/image/defailt_person.png" width="40px">';
			   			}else{
			   				html +='<img class="msgheadimg" style="border-radius:5px" src="'+this.headimgurl+'" width="40px">';
			   			}  			
			   			html +='</p><br><p><em>'+this.create_name+'&nbsp;</em></p></div></div></li>';
			   			$("#ul2").prepend(html);
		    		});
		    	}
		    },
		    error:function(){
		    	errcount ++;
		    	if(errcount > 5){
		    		window.clearInterval(t1); 
		    	}
		    }
		});
	}
</script>
</head>
<body style="font-family: '宋体';font-size: 12px;margin: 0;padding: 0;background:#F7F7F7;">
	<!-- 菜单结束 -->
	<div id="wrap" style="position:relative;float:left;min-height:400px;">
    <div id="main" style="position:relative;width:95%;">
        <div class="head_images">
        	<h1 style="text-align:center;">${activity.title}---图文直播</h1>
        </div>
        <div class="main" style="font-family: Microsoft Yahei;">
            <div class="con">
                <div class="deliver_button"><p></p></div>
                <div class="con_title">
                    <p><span class="state" status="2">发起人：${activity.createName}</span><span class="create_time" style="padding-left:50px;">${activity.start_date} 开始</span><span class="style">${activity.place }</span></p>
                </div>
                <div class="con_nr" style="background: url(<%=path%>/image/direct/mylive_conbg.png) 105px 0 repeat-y;">
                    <dl>
                    </dl>
                    <ul id="ul1"><li></li></ul>
                    <ul id="ul2">
                    <c:forEach items="${msglist}" var = "msg">
                        <li id="${msg.id}">
                        	<div class="patch">
                        		<div class="patch_con">
                        			<div class="top"></div>  
                        			<div class="left" style="background:url(<%=path%>/image/direct/center.png) 0 0 repeat-y;padding:5px 10px;line-height:25px;">
                        				<div>
                        					${msg.created_time}
                        				</div>
                        				<div>
											${msg.content}
										</div>
                        			</div>
                        			<div class="bottom"></div>
                        			<div class="jiantou"></div>
                        		</div>
                        		<div class="time">
                        		<span></span>
                        			<p>
	                        			<c:if test="${msg.headimgurl ne ''}">
	                        				<img class="msgheadimg" style="border-radius:5px" src="${msg.headimgurl}" width="40px">
	                        			</c:if>
	                        			<c:if test="${msg.headimgurl eq ''}">
	                        				<img class="msgheadimg" style="border-radius:5px" src="<%=path %>/image/defailt_person.png" width="40px">
	                        			</c:if>
                        			</p>
                        			<br>
                        			<p>
                        				<em>${msg.create_name}</em>
                        			</p>
                        		</div>
                        	</div>
                        </li>
                      </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        
       <form id="directform" name="directform"  method="post"  >
			<input type="hidden" name="content" value="" />
			<input type="hidden" name="created_by" value="${sourceid}" /> 
			<input type="hidden" name="activity_id" value="${id}" /> 
			<input type="hidden" name="headimgurl" value="${user.headImageUrl}" />
			<input type="hidden" name="create_name" value="${user.nickName}" />
			<input type="hidden" name="msg_type" value="" />
			<input type="hidden" name="source" value="P" />
			<input type="hidden" name="compere" value="" />
		</form>
        
    </div>
    <div class="clear"></div>
	</div>
	
    <div class="patch" style="position:fixed;right:5px;top:10px;padding-bottom: 10px;width:40%;font-family: Microsoft Yahei;">
        	<script type="text/plain" id="myEditor" style="min-height:280px;">
			</script>
	   <div style="margin-top: 15px;width:100%;text-align:center;">
			<a class="myButton sendMsg" href="javascript:void(0);" style="color:#fff;font-family: Microsoft Yahei;" >发布</a>
	   </div>
    </div>
    
    <div style="clear:both"></div>
    <!-- Left Sidebar End -->
    <div class="right-sidebar zjwk_common_zindex999" >
    </div>
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
</body>
</html>