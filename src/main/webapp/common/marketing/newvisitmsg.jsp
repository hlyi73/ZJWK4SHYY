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
<script src="<%=path%>/scripts/plugin/firstchar/slidernav.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/bar.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/slidernav.css"/>
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<script type="text/javascript">
$(function(){
	$(".backbtn").click(function(){
		if("meet"=='<%=model%>'){
			$("#activity_conlist").css("display","none");
			$(".workplan_menu").css("display","");
			$("#customerDetail").css("display","");
			$("._menu").css("display","");
			$(".nodata").removeClass("none");
			$(".contact_list").css('display',"");
			$("input[name=search]").val('');
			$("input[name=search]").attr('placeholder',"按名字、电话搜索");
		}else if("act_meet" == '<%=model%>'){
			$("#activity_conlist").css("display","none");
			$(".meet_div__").css("display","");
		}
	});
	var con = $("#activity_conlist");
	//选择框
	con.find(".contact_list .check-radio").click(function(){
		var nums = $(".selected_contact_nums").html();
		if($(this).hasClass("rsel")){
			$(this).removeClass("rsel");
			nums = parseInt(nums) - 1;
		}else{
			$(this).addClass("rsel");
			nums = parseInt(nums) + 1;
		}
		$(".selected_contact_nums").html(nums);
	}).end().find(".cannelbtn").click(function(){//重选
		con.find(".contact_list .check-radio").removeClass("rsel");
		$(".selected_contact_nums").html("0");
	}).end().find(".okbtn").click(function(){//确定
		var cids = '';
		con.find(".contact_list").each(function(){
			var obj = $(this).find(".rsel");
			if(obj.length > 0){
				var cid = $(this).attr("contactid");
				var cname = $(this).attr("conname");
				var cphone = $(this).attr("conmobile");
				if(cid){
					cids += cid + ','+cname+","+cphone+";";
				}
			}
		});
		if(!cids){
			$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择联系人!"); 
  		    $(".myvisitMsgBox").delay(2000).fadeOut();
			return;
		}
		$(".g-mask").removeClass("none");
		$(".send_msg_loading").removeClass("none");
		$(this).attr("disabled","true");
		//异步调用发送给后台
		$.ajax({
			url: "<%=path%>/zjwkactivity/saveconlist",
			data: {cids: cids,id:'<%=rowId%>',sourceid:'<%=sourceid%>',model:'<%=model%>'},
		 	success: function(data){
		 		if(data === "success"){
		 			$(".send_msg_loading").addClass("none");
		 			$(".myvisitMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("邀请发送成功!");
		  		    $(".myvisitMsgBox").delay(2000).fadeOut();
		  		    if("meet"=='<%=model%>'){
			 			window.location.replace('<%=path%>/zjwkactivity/manager_jh?id=<%=rowId%>&sourceid=<%=sourceid%>');
		  		    }else if("act_meet" == '<%=model%>'){
		  		    	window.location.replace('<%=path%>/zjwkactivity/manage_invit?id=<%=rowId%>');
		  		    }
		 		}else {
		 			$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("邀请失败!");
		  		    $(".myvisitMsgBox").delay(2000).fadeOut();
		  		    $(".g-mask").addClass("none");
		  		    $(".send_msg_loading").addClass("none");
		 		}
		    }
		});
	});
	initMsgBtn();
});

//搜索联系人
function searchContact(){
	var searchContent = $("input[name=search]").val();
	if(searchContent){
		var isSearch = false;
		$(".contact_list").css('display',"");
		$(".imgchoose").css('display',"none");
		$(".contact_list").each(function(){
			var name = $(this).attr("conname");
			var mobile = $(this).attr("conmobile");
			if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1){
				isSearch = true;
				$(this).css("display","");
			}
		});
		if(!isSearch){
			$(".nodata").removeClass("none");
		}else{
			$(".nodata").addClass("none");
		}
	}else{
		$(".contact_list").css('display',"none");
		$(".imgchoose").css('display',"");
		$(".nodata").addClass("none");
	}
}

function initMsgBtn(){
	$(".imgchoose").click(function(){
		var arr = $(this).attr("arr");
		var contype = $(this).attr("contype");
		var modelId = $(this).attr("modelId");
		var tagName = $(this).attr("contagname");
		if("down"==arr){
			$(this).attr("src","<%=path%>/image/form_more2x-click.png");
			$(this).attr("arr","");
			$(".choosetaga").css("display","none");
			$(this).parent().parent().parent().css("display","");
			if("all"==contype){
				$(".contact_list").css("display","");
			}else if("friend"==contype){
				$(".contact_list").each(function(){
					if($(this).find(".userfriend").size()>0){
						$(this).css("display","");
					}
				});
			}else{
				if("batch"==modelId){
					$(".contact_list").each(function(){
						var conno = $(this).attr("conno");
						if(conno&&contype==conno){
							$(this).css("display","");
						}
					});	
				}else{
					findContactByTagName(tagName);
				}
			}
		}else{
			$(this).attr("src","<%=path%>/image/form_more2x.png");
			$(this).attr("arr","down");
			$(".choosetaga").css("display","");
			$(".contact_list").css("display","none");
			$(".nodatadiv").css("display","none");
		}
		
	});
	
	//全选按钮
	$(".checkall").click(function(){
		var flag = "";
		if($(this).hasClass("rsel")){
			$(this).removeClass("rsel");
			flag = "n";
		}else{
			$(this).addClass("rsel");
			flag = "y";
		}
		var presize = sessionStorage.getItem("visitmsgpresize");
		if(null==presize){
			presize=0;
		}
		var total = sessionStorage.getItem("visitmsgtotal");
		var contype = $(this).attr("contype");
		var modelId = $(this).attr("modelId");
		var tagName = $(this).attr("contagname");
		var size = 0;
		if("all"==contype){
			if("n"==flag){
				size = parseInt(presize)-parseInt(total);
				$(".contact_list").find(".check-radio").removeClass("rsel");
			}else if("y"==flag){
				$(".contact_list").find(".check-radio").addClass("rsel");
				total = $(".contact_list").find(".check-radio").size();
				size = total;
				size = parseInt(presize)+size;
				sessionStorage.setItem("visitmsgtotal",total+"");
			}
		}else if("friend"==contype){
			$(".contact_list").each(function(){
				if($(this).find(".userfriend").size()>0){
					presize = sessionStorage.getItem("visitmsgpresize");
					if("n"==flag){
						$(this).find(".check-radio").removeClass("rsel");
						size = parseInt(presize)-1;
					}else if("y"==flag){
						$(this).find(".check-radio").addClass("rsel");
						size = parseInt(presize)+1;
					}
						sessionStorage.setItem("visitmsgpresize",size+"");
				}
			});
		}else{
			if("batch"==modelId){
				$(".contact_list").each(function(){
					var conno = $(this).attr("conno");
					if(conno&&contype==conno){
						presize = sessionStorage.getItem("visitmsgpresize");
						if("n"==flag){
							$(this).find(".check-radio").removeClass("rsel");
							size = parseInt(presize)-1;
						}else if("y"==flag){
							$(this).find(".check-radio").addClass("rsel");
							size = parseInt(presize)+1;
						}
						sessionStorage.setItem("visitmsgpresize",size+"");
					}
				});	
			}else{
				size = findContactByTagName(tagName,flag);
			}
		}
		if($(".choosetaga").find(".rsel").size()==0){
			size = 0;
		}
		sessionStorage.setItem("visitmsgpresize",size+"");
		$(".selected_contact_nums").html(size);
	});
	
}

//根据tagType查询联系人信息
function findContactByTagName(tagName,flag){
	var size = 0;
	var presize = sessionStorage.getItem("visitmsgpresize");
	if(null==presize){
		presize=0;
	}
	$.ajax({
		url:"<%=path%>/contact/asyclist",
		data:{viewtype:'myview',tagtype:tagName},
		dataType:'text',
		type:'post',
		success:function(data){
			if(!data){
				$(".nodatadiv").css("display","");
			}else{
				var d = JSON.parse(data);
				$(d).each(function(){
					var rowid = this.rowid;
					presize = sessionStorage.getItem("visitmsgpresize");
					if("n"==flag){
						$("."+rowid).find(".check-radio").removeClass("rsel");
						size = parseInt(presize)-1;
					}else if("y"==flag){
						$("."+rowid).find(".check-radio").addClass("rsel");
						size = parseInt(presize)+1;
					}
					sessionStorage.setItem("visitmsgpresize",size+"");
					$("."+rowid).css("display","");
				});
			}
		}
	});
	return size;
}
</script>
<style>
.slider .slider-nav{
	position: fixed;
	right: 0;
	top: 150;
	background: #eee;
	min-height: 250px;
}
.none {
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
<div id="activity_conlist" style="display:none">
<!-- 按钮区域 -->
<div id="site-nav" class="contact_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
    <a href="javascript:void(0)" class="backbtn"  style="float:left;padding-left:5px;">后退</a>
    <a href="javascript:void(0)" class="cannelbtn" style="padding:5px 8px;">重新筛选</a>
    <a href="javascript:void(0)" class="okbtn" style="padding:5px 8px;">邀请</a>
</div>
<!-- 文字描述区域 -->	
<div class="selected_infos" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;padding:5px 20px;color:#999;line-height:18px;">
	您选择了<span style="color:red;padding:0px 5px;font-weight:bold;" class="selected_contact_nums">0</span>个联系人。
	<Br/>
	系统将自动过滤重复邀请，请不必担心。
</div>
<!-- 搜索区域 -->
<div style="width:100%;height:50px;background-color:#fff;padding:5px;">
	<div style="height:44px;padding-top:3px;">
		<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
		<input type="text" value="" placeholder="按名字、电话搜索" oninput="searchContact(event)" onpropertychange="searchContact(event)" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;">
	</div>
</div>
<!-- 选择不同分组区域 -->
<div class="site-recommend-list page-patch acclist" style="font-size:14px;margin-top: 2px;">
	<div class="list-group1 listview">
		<c:forEach var="tag" items="${taglist}">
			<a href="javascript:void(0);" class="list-group-item listview-item choosetaga" style="">
				<div style="width:100%;">
				<div style="">${tag.tagName}</div>
				<div style="margin-top:-20px;float: right; cursor: pointer;" class="">
					<span class="check-radio checkall" contype="${tag.modelType}" contagname = "${tag.tagName}"modelId="${tag.modelId}" style="margin-right:10px;"></span>
					<img class="imgchoose" src="<%=path%>/image/form_more2x.png" style="width: 14px;" contype="${tag.modelType}" arr="down" contagname = "${tag.tagName}"modelId="${tag.modelId}">
				</div>
				</div>
			</a>
		</c:forEach>
	<input type="hidden" name="checkallflag" value="0">
	<!-- 导航END -->
	<div id="slider" class="slider" style="padding-right:0;">  
	  <div class="slider-content" id="div_accnt_list" style="margin-top:5px;margin-bottom:25px;font-size:14px;">
		<ul style="margin-bottom: 45px;">
				<li id="" class="">
					<ul>
						<c:forEach items="${contactList}" var="contact" >
								<li class="contact_list ${contact.rowid}"  style="display:none;" conno="${contact.batchno}" contactid="${contact.rowid}" conname="${contact.conname}" conmobile="${contact.phonemobile}">
									<c:if test="${contact.type eq 'friend'}">
										<a href="javascript:void(0)" style="background-color:#fff;"> 
											<div style="width:90%; background-color:#fff;float: left;">
												<div class="content" style="text-align: left">
													<div style="float:left;line-height:25px;">${contact.conname }</div>
													<div class="userfriend" style="float:left;line-height: 19px;background-color: orange;color: #fff;border-radius: 10px;margin-top: 3px;margin-left: 5px;padding: 0px 3px;font-size: 12px;">友</div>
													<div style="clear:both"></div>
												</div>
												<div style="line-height:25px;">
													<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
														职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
													</c:if>
													
													<c:if test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
														电话：${contact.phonemobile}
													</c:if>
												</div>
											</div>
											<div class="check-radio " style="float: right;margin-right:10px;"></div>
											<div style="clear:both"></div>
										</a>
									</c:if>
									<c:if test="${contact.type ne 'friend'}">
										<a href="javascript:void(0)" style="background-color:#fff;">
											<div style="width:90%; background-color:#fff;float: left">
												<div class="content" style="text-align: left">
													<div style="float:left;line-height:25px;">${contact.conname }</div>
													<div style="clear:both"></div>
												</div>
												<div style="line-height:25px;">
													<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
														职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
													</c:if>
													
													<c:if test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
														电话：${contact.phonemobile}
													</c:if>
												</div>
											</div>
										    <div class="check-radio" style="float: right;margin-right:10px;"></div>
											<div style="clear:both"></div>
										</a>
									</c:if>
								</li>
						</c:forEach>
						<div class="nodatadiv"style="display:none;text-align: center; padding-top: 50px;">没有找到数据</div>
					</ul>
				</li>
			<c:if test="${fn:length(contactList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</ul>
	</div>
  </div>
 </div>
</div>
<div class="send_msg_loading none" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 50px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 15px;background-color: #fff;border:1px solid #ddd;">
	<div><img src="<%=path%>/image/loading.gif"></div>
	发送邀请中
</div>
<div class="g-mask none">&nbsp;</div>
<div class="none nodata" style="position:fixed;width:100%;text-align:center;">没有找到匹配的数据！</div>
<div class="myvisitMsgBox" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
</div>
