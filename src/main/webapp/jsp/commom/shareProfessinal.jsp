<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<!-- css -->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" />
 <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
$(function () {
	initAproveBtn();//初始化批量审批
	initWeixinFunc();
	
	initForm();
	
	$('#slider').sliderNav();
	$('#transformers').sliderNav({items:['autobots','decepticons'], debug: true, height: '300', arrows: false});
	$(".nulldiv").css("display","none");
});

//微信网页按钮控制
function initWeixinFunc(){
	//隐藏顶部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('hideOptionMenu');
	});
	//隐藏底部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('hideToolbar');
	});
}

//初始化全选和不全选按钮
function initAproveBtn(){
	
	//若没有好友，则只显示跳过
	var userList = '${isEmpty}';
	if("true"==userList){
		$(".confirmdiv").css("display","none");
		$(".skipdiv").css("width","100%");
	}
	
	//单选或多选
	$("#div_expense_list > a").unbind("click").bind("click", function(){
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
	
	$(".skip").click(function(){
		$(":hidden[name=optype]").val('skip');
		$("form[name=directsendform]").submit();
	});
	
	//提交到活动那边保存
	$(".confirm").click(function(){
		var id="";
		$("#div_expense_list > a.checked").each(function(){
			var userid = $(this).find(":hidden[name=userid]").val();
			var phone = $(this).find(":hidden[name=phonenumber]").val();
			if(null!=userid&&null!=phone){
				id += userid+","+phone+";";
			}
		});
		if(!id){
			$(".myMsgBox").css("display","").html("联系不能为空，请重新选择！");
			$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		$(":hidden[name=id]").val(id);
		$("form[name=directsendform]").submit();
	});
		
	//初始化表单
	function initForm(){
		$(".menu-group").click(function() {
			if ($(".dropdown-menu-group").hasClass("none")) {
				$(".dropdown-menu-group").removeClass("none");
				$(".g-mask").removeClass("none");
			} else {
				$(".dropdown-menu-group").addClass("none");
				$(".g-mask").addClass("none");
			}
		});
		$(".g-mask").click(function() {
			$(".dropdown-menu-group").addClass("none");
			$(".g-mask").addClass("none");
		});
		
		$("input[name=search]").keyup(function(){
			searchContact();
		});
	}
	
	function add(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('contact/add?flag=addCon');
	}
	
	function searchContact(){
		var searchContent = $("input[name=search]").val();
		if(searchContent){
			var isSearch = false;
			$(".firstname_list").css("display","none");
			$(".contact_list").css('display',"none");
			$(".contact_list").each(function(){
				var name = $(this).attr("conname");
				var mobile = $(this).attr("conmobile");
				if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1){
					isSearch = true;
					$(this).css("display","");
				}
			});
			if(!isSearch){
				$(".nodata").removeClass("none")
			}else{
				$(".nodata").addClass("none");
			}
		}else{
			$(".firstname_list").css("display","");
			$(".contact_list").css('display',"");
			$(".nodata").addClass("none");
		}
	}
}
</script>
<div id="site-nav" class="navbar" >
	<jsp:include page="/common/back.jsp"></jsp:include>
	<c:if test="${shareType eq 'msg' }">
		<h3 style="padding-right:45px;">短信分享</h3>
	</c:if>
	<c:if test="${shareType eq 'mail' }">
		<h3 style="padding-right:45px;">邮件分享</h3>
	</c:if>
</div>
<input type="hidden" name="partyId" value="${partyId}">
<%-- <div>
	<a href="<%=path%>/cbooks/list?source=share">选择联系人</a>
	<jsp:include page="../perslInfo/conlist.jsp"></jsp:include>
</div> --%>
	 <!-- 搜索区域 -->
	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:5px;">
		<div style="height:44px;padding-top:3px;">
			<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
			<input type="text" value="" placeholder="按名字、电话搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	
	   <!-- 导航END -->
	   <div id="slider">
		<div class="slider-content" id="div_expense_list" style="margin-top:5px;margin-bottom:65px;">
			<ul>
				<c:forEach items="${charList }" var="char1">
					<li id="${char1}" class=""><a name="${char1}" class="title firstname_list">${char1}</a>
						<ul>
							<c:forEach items="${contactList}" var="contact" >
								<c:if test="${contact.firstname eq char1 }">
									<li class="contact_list" contactid="${contact.rowid}" conname="${contact.conname}" conmobile="${contact.phonemobile}">
											<a href="#"   class="list-group-item listview-item radio" style="border-left: 0px;">
												<div style="width:100%; background-color:#fff;">
													<div class="content" style="text-align: left">
														<div style="float:left;line-height:25px;"><h1>${contact.conname }</h1></div>
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
												<div class="input-radio" title="选择该条记录"></div>
											</a>
									</li>
								</c:if>	
							</c:forEach>
						</ul>
					</li>
				</c:forEach>
				<c:if test="${fn:length(contactList) == 0 }">
					<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
				</c:if>
			</ul>
		</div>
	</div>
	<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
	<div class="g-mask none">&nbsp;</div>	
<div class="button-ctrl flooter">
	<fieldset class="">
		<div class="ui-block-a skipdiv" style="width:50%">
			<a href="javascript:void(0)" class="btn btn-block skip" 
			    style="font-size: 16px;margin-left:10px;margin-right:10px;">重选</a>
		</div>
		<div class="ui-block-a confirmdiv" style="width:50%">
			<a href="javascript:void(0)" class="btn btn-block confirm" 
			    style="font-size: 16px;margin-left:10px;margin-right:10px;">分享</a>
		</div>
	</fieldset>
</div>
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>

