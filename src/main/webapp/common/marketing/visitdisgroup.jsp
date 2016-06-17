<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String model = request.getParameter("model");
	String rowId = request.getParameter("rowId");
	String sourceid = request.getParameter("sourceid");
%>
<html lang="zh-cn">
<head>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<script type="text/javascript">
$(function(){
	$(".backbtn1").click(function(){
		if("meet"=='<%=model%>'){
			$("#activity_dislist").css("display","none");
			$(".workplan_menu").css("display","");
			$("#customerDetail").css("display","");
			$("._menu").css("display","");
			$(".nodata1").css("display","none");
			$(".disgroup_list").css('display',"");
			$("input[name=search1]").val('');
			$("input[name=search1]").attr('placeholder',"按名字搜索");
			
		}else if("act_meet" == '<%=model%>'){
			$("#activity_dislist").css("display","none");
			$(".meet_div__").css("display","");
		}
	});
	var con = $("#activity_dislist");
	//搜索事件
	con.find("input[name=search1]").keyup(function(){
		var searchContent = $("input[name=search1]").val();
		if(searchContent){
			var isSearch = false;
			$(".disgroup_list").css('display',"none");
			$(".disgroup_list").each(function(){
				var name = $(this).attr("disname");
				if(name.indexOf(searchContent) != -1){
					isSearch = true;
					$(this).css("display","");
				}
			});
			if(!isSearch){
				$(".nodata1").removeClass("none1")
			}else{
				$(".nodata1").addClass("none1");
			}
		}else{
			$(".disgroup_list").css('display',"");
			$(".nodata1").addClass("none1");
		}
	});
	//选择框
	con.find(".disgroup_list .check-radio").click(function(){
		var nums = $(".selected_disgroup_nums").html();
		var key = $(this).attr("key");
		if($(this).hasClass("rsel")){
			$(this).removeClass("rsel");
			nums = parseInt(nums) - parseInt(key);
		}else{
			$(this).addClass("rsel");
			nums = parseInt(nums) +parseInt(key) ;
		}
		$(".selected_disgroup_nums").html(nums);
	}).end().find(".cannelbtn1").click(function(){//重选
		con.find(".disgroup_list .check-radio").removeClass("rsel");
		$(".selected_disgroup_nums").html("0");
	}).end().find(".okbtn1").click(function(){//确定
		var cids = '';
		con.find(".disgroup_list").each(function(){
			var obj = $(this).find(".rsel");
			if(obj.length > 0){
				var cid = $(this).attr("disgroupid");
				var cname = $(this).attr("disname");
				if(cid){
					cids += cid + ","+cname+";";
				}
			}
		});
		if(!cids){
			$(".myvisitMsgBox1").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择讨论组!"); 
  		    $(".myvisitMsgBox1").delay(2000).fadeOut();
			return;
		}
		$(".g-mask1").removeClass("none1");
		$(".send_msg_loading1").removeClass("none1");
		$(this).attr("disabled","true");
		//异步调用发送给后台
		$.ajax({
			url: "<%=path%>/zjwkactivity/savegrouplist",
			data: {cids: cids,id:'<%=rowId%>',sourceid:'<%=sourceid%>',model:'<%=model%>'},
		 	success: function(data){
		 		if(data === "success"){
		 			$(".send_msg_loading1").addClass("none1");
		 			$(".myvisitMsgBox1").removeClass("error_tip").addClass("success_tip").css("display","").html("邀请发送成功!");
		  		    $(".myvisitMsgBox1").delay(2000).fadeOut();
		  		    if("meet"=='<%=model%>'){
			 			window.location.replace('<%=path%>/zjwkactivity/manager_jh?id=<%=rowId%>&sourceid=<%=sourceid%>');
		  		    }else if("act_meet" == '<%=model%>'){
		  		    	window.location.replace('<%=path%>/zjwkactivity/manage_invit?id=<%=rowId%>');
		  		    }
		 		}else {
		 			$(".myvisitMsgBox1").removeClass("success_tip").addClass("error_tip").css("display","").html("邀请失败!");
		  		    $(".myvisitMsgBox1").delay(2000).fadeOut();
		  		    $(".g-mask1").addClass("none1");
		  		    $(".send_msg_loading1").addClass("none1");
		 		}
		    }
		});
		
	});
	
});
</script>
<style>
.none1 {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.2;
	z-index: 998; 
}
</style>
</head>
<div id="activity_dislist" style="display:none">
	<div id="site-nav1" class="disgroup_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
		    <a href="javascript:void(0)" class="backbtn1"  style="float:left;padding-left:5px;">后退</a>
		    <a href="javascript:void(0)" class="cannelbtn1" style="padding:5px 8px;">重新筛选</a>
		    <a href="javascript:void(0)" class="okbtn1" style="padding:5px 8px;">邀请</a>
		</div>
		
		<div class="selected_infos" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;padding:5px 20px;color:#999;line-height:18px;">
			您选择了<span style="color:red;padding:0px 5px;font-weight:bold;" class="selected_disgroup_nums">0</span>个人。
			<Br/>
			系统将自动过滤重复邀请，请不必担心。
		</div>
		
		<!-- 搜索区域 -->
		<div style="width:100%;height:50px;background-color:#fff;padding:5px;">
			<div style="height:44px;padding-top:3px;">
				<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
				<input type="text" value="" placeholder="按名字搜索" name="search1" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;">
			</div>
		</div>
		<!-- 导航END -->
		<div class="slider-content" id="div_accnt_list1" style="background-color:#fff;margin-top:5px;margin-bottom:25px;font-size:14px;">
			<ul>
					<c:forEach items="${dgList}" var="disgroup" >
						<li class="disgroup_list" disname="${disgroup.name}" disgroupid ="${disgroup.id}" disgroupnum ="${disgroup.dis_user_count}" style="border: 1px solid #ddd;line-height: 60px;">
							<a href="javascript:void(0)" style="background-color:#fff;"> 
								<div style="width:90%; background-color:#fff;float: left;">
									<div style="float: left;">
										<img src="<%=path%>/image/mygroup.png" style="margin-right: 10px;width: 40px; border-radius: 20px;">
									</div>
									<div class="content" style="text-align: left;margin-top: 5px;">
										<p style="line-height:25px;">【讨论组】${disgroup.name}</p>
										<p style="line-height:25px;">人数：${disgroup.dis_user_count}</p>
									</div>
								</div>
								<div class="check-radio" key="${disgroup.dis_user_count}" style=""></div>
								<div style="clear:both"></div>
							</a>
						</li>
					</c:forEach>
				<c:if test="${fn:length(dgList) == 0 }">
					<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
				</c:if>
			</ul>
		</div>
		 <div class="send_msg_loading1 none1" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 50px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 15px;background-color: #fff;border:1px solid #ddd;">
		 	<div><img src="<%=path%>/image/loading.gif"></div>
		 	发送邀请中
		 </div>
		 <div class="g-mask1 none">&nbsp;</div>
		<div class="none1 nodata1" style="position:fixed;width:100%;text-align:center;margin-top: 150px;">没有找到匹配的数据！</div>
		<div class="myvisitMsgBox1" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
</div>
