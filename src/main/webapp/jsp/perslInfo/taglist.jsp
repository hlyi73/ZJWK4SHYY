<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	function showDoc(){
		var disnew = $("#newSign").css("display");
		if("none"==disnew){
			$("#oldSign").css("display","none");
			$("#newSign").css("display","");
			$("#editimg").attr("src","<%=path%>/image/oper_success.png");
		}else{
			$("#oldSign").css("display","");
			$("#newSign").css("display","none");
			//$("#editimg").attr("src","<%=path%>/image/edit_information.png");
			conform();
		}
	}
	
	function initElem(){
		//添加显示输入框
		$(".addTagBtn").click(function(){
			$(".addTagArea").css("display", "");
		});
		
		//删除按钮
		$(".clearTagBtn").click(function(){
		  var tagName;
		  if( $(".tagList span:not(.addTagBtn , .clearTagBtn)").hasClass("tagunchecked")){
		  $(".tagList span:not(.addTagBtn , .clearTagBtn)").each(function(){
				if($(this).hasClass("tagunchecked")){
					 tagName =  $(this).html();
						$.ajax({
						      type: 'post',
						      url: '<%=path%>/modelTag/delete',
						      data: {id:this.id},
						      dataType: 'text',
						      success: function(data){
	 					    		$(".myMsgBox").css("display","").html("删除标签成功!");
						    		$(".myMsgBox").delay(2000).fadeOut();
	 				      }
						 }); 
						 $(this).remove();
				}
			}); 
		  }
		  else{
				$(".myMsgBox").css("display","").html("请选择要删除的标签!");
	  			$(".myMsgBox").delay(2000).fadeOut();
		  }
			$(".addTagArea").css("display", "none");
		});
		
		//删除按钮
		$(".clearTagBtn2").click(function(){
		  var tagName;
		  if( $(".tagList2 span:not(.addTagBtn2 , .clearTagBtn2)").hasClass("tagunchecked")){
		  $(".tagList2 span:not(.addTagBtn2 , .clearTagBtn2)").each(function(){
				if($(this).hasClass("tagunchecked")){
					 tagName =  $(this).html();
						$.ajax({
						      type: 'post',
						      url: '<%=path%>/modelTag/delete',
						      data: {id:this.id},
						      dataType: 'text',
						      success: function(data){
	 					    		$(".myMsgBox").css("display","").html("删除标签成功!");
						    		$(".myMsgBox").delay(2000).fadeOut();
	 				      }
						 }); 
						 $(this).remove();
				}
			}); 
		  }
		  else{
				$(".myMsgBox").css("display","").html("请选择要删除的标签!");
	  		$(".myMsgBox").delay(2000).fadeOut();
			}
			/* $(".addTagArea").css("display", "none"); */
		});
		
		
		//取消按钮
		$(".cancelTagBtn").click(function(){
			$(".addTagArea").css("display", "none");
			$("textarea[name=introduction]").val('');
			$("textarea[name=introduction]").attr("placeholder", "请填写");
		});
		//保存
		$(".saveTagBtn${parenttype}").click(function(){
			var introbj = $("textarea[name=introduction${parenttype}]");
			var tagName = $.trim(introbj.val());
			if(!tagName){
				introbj.attr("placeholder","请填写");
				return;
			}
			
			//判断长度
			var myReg = /^[\u4e00-\u9fa5]+$/;
			if (myReg.test(tagName)) {
                //中文
				if(tagName.length>10){
					introbj.val('');
                	introbj.attr("placeholder","标签长度超出限制，请重新输入");
    				return;
                }
            } else {
                //英文
                if(tagName.length>16){
                	introbj.val('');
                	introbj.attr("placeholder","标签长度超出限制，请重新输入");
    				return;
                }
            }
			var isExists = false;
			$(".tag_list_item").each(function(){
				if($(this).html() == tagName){
					isExists = true;
					return;
				}
			});
			if(isExists){
				introbj.val('');
				introbj.attr("placeholder","该标签已存在，请输入其他标签");
				return;
			}
			//判断是否有重复标签
			
			//绑定到后台
			var modelType = $(":hidden[name=modelTagType]").val();
			var obj = [];
			obj.push({name :'modelId', value :'${user.party_row_id}'});
			obj.push({name :'modelType', value : modelType});
			obj.push({name :'tagName', value : tagName});
			//发送保存标签申请
			$.ajax({
		  	      url: '<%=path%>/modelTag/add',
		  	      data: obj,
		  	      success: function(data){
		  	    	 var d= JSON.parse(data);
		    	      if(d && d.errorCode === "success"){
		    	    	  introbj.val('');
		    	    	  var tag='	<span id="'+d.rowId+'" class="tagchecked tag_'+d.rowId+'" style="margin: 5px; line-height: 20px; float: left;">';
		    	    	  tag+='<span class="tag_list_item" style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;">'+tagName+'</span>';
		    	    	  tag+='<span style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">0</span>';
		    	    	  tag+='</span>';
		    	    	  $(".tagList ."+modelType).prepend(tag);
		    	    	  initUserTagElem();
		    	    	  //changeColor();
		    	    	  $("textarea[name=introduction]").attr("placeholder", "请填写");
		    	    	  $(".addTagArea").css("display","none");
		    	      }
		  	      }
		  	 });
		});
	}


<%-- 	function loadTag(){
		//绑定到后台
		var obj = [];
		obj.push({name :'modelId', value :'${parentid}'});
		obj.push({name :'modelType', value :''});
		//加载标签
		$.ajax({
	  	      url: '<%=path%>/modelTag/list',
	  	      data: obj,
	  	      success: function(data){
	    	      if(data){
	    	    	  var tag = "";
	    	    	  var d= JSON.parse(data);
	    	    	  $(d).each(function(){
	    	    		  tag += '<span class="tagchecked tag_'+this.id+'" style="margin:5px;line-height:20px;float: left;">'+this.tagName+'</span>';
	    	    	  });
	    	    	  $(".tagList").prepend(tag);
	    	    	  initUserTagElem();
	    	    	  changeColor();
	    	      }
	  	      }
	  	 });
	} --%>

	//tag事件点击事件
	function initUserTagElem(){
		$(".tagList span:not(.addTagBtn , .clearTagBtn)").unbind("click").click(function(){
			if($(this).hasClass("tagchecked")){
				$(this).removeClass("tagchecked");
				$(this).addClass("tagunchecked");
			}else{
				$(this).removeClass("tagunchecked");
				$(this).addClass("tagchecked");
			}
		});
	}

	//tag事件点击事件
	function initUserTagElem2(){
		$(".tagList2 span:not(.addTagBtn2 , .clearTagBtn2)").unbind("click").click(function(){
			if($(this).hasClass("tagchecked")){
				$(this).removeClass("tagchecked");
				$(this).addClass("tagunchecked");
			}else{
				$(this).removeClass("tagunchecked");
				$(this).addClass("tagchecked");
			}
		});
	}
	//随机获得 候选背景颜色 
	function randomColor(){
		var arrHex = ["#4A148C","#01579B","#004D40","#00838F","#33691E"];
		var strHex = arrHex[Math.floor(Math.random() * arrHex.length + 1)-1];
		return strHex;
	}

	//改变个人标签背景色
	function changeColor(){
		$(".tagchecked").each(function() {
			var hex = randomColor();
			$(this).css("color", hex);
		});	 
	}
	$(function() {
		var width = $(window).width();
		if (width > 640) {
			width = 640;
		}
		$(".bgimg").attr("width", width);

		//loadTag();
		initElem();
		initUserTagElem();
		initUserTagElem2();
		changeColor();
		
		$(".model_tag_type").click(function(){
			$(".model_tag_type").removeClass("selected").addClass("noselected");
			$(this).removeClass("noselected").addClass("selected");
			$(":hidden[name=modelTagType]").val($(this).attr('key'));
		});
	});

</script>
<style> 
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}

.model_tag_type{
	padding: 3px 5px;
}

</style>
</head>

<body style="min-height: 100%;">
	<%--<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right: 45px;">我的标签</h3>

	</div> --%>
	<input type="hidden" name="modelTagType" value="personage">
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<!-- <h4>详情</h4> -->
			<div class="" style="">
				<div style="width: 100%;">
					<!-- <div style="float:left;padding-left:15px;"><img src="<%=path%>/image/zjwk_qrcode.png" height="20px"></div> -->
					<div style="float: left; width: 100%; font-size: 14px;">
						<div class="view site-recommend">
							<div class="recommend-box" style="margin: 0px;">
								<div class="tagList ui-body-d ui-corner-all info"
									style="padding: 0.5em; float: left; width: 100%; margin: 0px; font-size: 14px;">

									<div style="line-height: 35px;">
										<img src="<%=path%>/image/tags_list.png" height="16px">&nbsp;个人标签
									</div>
									<div class="personage">
									<c:forEach items="${myTagList}" var="myList">
										<c:if
											test="${myList.modelType eq 'personage' || myList.modelType eq '' || empty(myList.modelType)}">
											<span id="${myList.id}" class="tagchecked tag_${myList.id}"
												style="margin: 5px; line-height: 20px; float: left;">
												<span
												style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;"
												class="tag_list_item">${myList.tagName}</span> <span
												style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">${myList.total}</span>
											</span>
										</c:if>
									</c:forEach>
									</div>
									<div style="clear: both;"></div>
									<div style="line-height: 35px;">
										<img src="<%=path%>/image/tags_list.png" height="16px">&nbsp;商品标签
									</div>
									<div class="goods">
									<c:forEach items="${myTagList}" var="myList">
										<c:if test="${myList.modelType eq 'goods'}">
											<span id="${myList.id}" class="tagchecked tag_${myList.id}"
												style="margin: 5px; line-height: 20px; float: left;">
												<span
												style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;"
												class="tag_list_item">${myList.tagName}</span> <span
												style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">${myList.total}</span>
											</span>
										</c:if>
									</c:forEach>
									</div>
									<div style="clear: both;"></div>
									<div style="line-height: 35px;">
										<img src="<%=path%>/image/tags_list.png" height="16px">&nbsp;客户群体标签
									</div>
									<div class="clientBase">
									<c:forEach items="${myTagList}" var="myList">
										<c:if test="${myList.modelType eq 'clientBase'}">
											<span id="${myList.id}" class="tagchecked tag_${myList.id}"
												style="margin: 5px; line-height: 20px; float: left;">
												<span
												style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;"
												class="tag_list_item">${myList.tagName}</span> <span
												style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">${myList.total}</span>
											</span>
										</c:if>
									</c:forEach>
									</div>
									<div style="clear: both;"></div>
									<div style="text-align:center;height:35px;margin-top:8px;padding-top:8px;"> 
										
										<span class="addTagBtn"
											style="margin-top: 5px; padding-bottom: 20px;  background: rgb(143, 160, 245); color: #fff; padding: 5px; margin-left: 20px;">+
											标签</span> <span class="clearTagBtn"
											style="margin-top: 5px; padding-bottom: 20px; background: #FCB5A4; color: #fff; padding: 5px; margin-left: 20px;">-
											删除</span>
									</div>
								</div>

								<div style="clear: both;"></div>
								<!-- 标签添加区域 -->
								<div class="addTagArea" style="display: none">
									
									<div class="ui-body-d ui-corner-all info" style="padding: 1em;">
										<div style="line-height:40px;margin:0.5em 0;">
											<div style="">
												<a href="javascript:void(0)" class="model_tag_type selected" key='personage' style="">个人标签</a>
												&nbsp;&nbsp;&nbsp;
												<a href="javascript:void(0)" class="model_tag_type " key='goods' style="">商品标签</a>
												&nbsp;&nbsp;&nbsp;
												<a href="javascript:void(0)" class="model_tag_type " key='clientBase' style="">客户群体标签</a>
											</div>
										</div>
										<textarea name="introduction" id="introduction" rows="1"
											cols="" placeholder="请填写"></textarea>
										<div style="color: #999; font-size: 12px; text-align: right;">长度为10个汉字或16个字符</div>
									</div>
									<div class="ui-body-d ui-corner-all info"
										style="padding: 1em; height: 65px; margin-top: -10px;">
										<span class="cancelTagBtn"
											style="background: #D3D5D8; color: #fff; padding: 5px; text-align: center; width: 44%; cursor: pointer; font-size: 14px; float: left; margin-right: 10px; border-radius: 10px;">取消</span>
										<span class="saveTagBtn"
											style="background: rgb(143, 160, 245); color: #fff; padding: 5px; text-align: center; width: 48%; cursor: pointer; font-size: 14px; float: right; margin-left: 10px; border-radius: 10px;">添加</span>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
			<div style="clear: both;"></div>
			<div class="list-group-item listview-item" style="margin-top: 8px;">
				<div style="width: 100%;">
					<div style="font-size: 14px; margin-top: -10px"><img src="<%=path%>/image/tags_list.png" height="16px">&nbsp;访客标记的</div>
					<div style="float: left; margin-top: 10px; width: 100%;">
						<div class="view site-recommend">
							<div class="recommend-box" style="margin: 0px;">
								<div class="tagList2 ui-body-d ui-corner-all info"
									style="padding: 0.5em; float: left; width: 100%; margin: 0px;">
									<c:forEach items="${otherTagList}" var="otherList">
									
									
											<span id="${otherList.id}" class="tagchecked tag_${otherList.id}"
												style="margin: 5px; line-height: 20px; float: left;">
												<span
												style="background: rgb(93, 204, 165); padding: 4px 5px 7px 5px; color: #fff;"
												class="tag_list_item">${otherList.tagName}</span> <span
												style="background-color: rgb(76, 187, 148); color: #F0EBEB; padding: 4px 5px 7px 5px; margin-right: -5px; margin-left: -5px;">${otherList.total}</span>
											</span>					
									</c:forEach>
									<span class="clearTagBtn2"
										style="margin-top: 5px; padding-bottom: 20px; float: left; background: #FCB5A4; color: #fff; padding: 5px; margin-left: 20px;">-
										删除</span>
								</div>

								<div style="clear: both;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>


			<div class="list-group-item listview-item" style="margin-top: 8px;">
				<div style="width: 100%;">
					<div style="font-size: 14px; margin-top: -10px"><img src="<%=path%>/image/title-feed.png" height="16px">&nbsp;标签历史</div>
					<div
						style="float: left; margin-top: 10px; width: 100%; font-size: 14px; padding-left: 5px;">
						<c:forEach items="${printList}" var="printList">
							<div style="font-size: 14px; color: #666; line-height: 25px;">
								<div style="width: 90px; float: left; color: #999;">
									<fmt:formatDate pattern="MM-dd HH:mm"
										value="${printList.createTime}" type="both" />
								</div>
								<div style="margin-left: 90px;">
									<c:if test="${printList.operativeid eq user.party_row_id}">
										<a href="<%=path%>/businesscard/detail?partyId=${printList.operativeid}">
											我
										</a>
									</c:if>
									<c:if test="${printList.operativeid ne user.party_row_id}">
										<a href="<%=path%>/businesscard/detail?partyId=${printList.operativeid}">
											${printList.operativename}
										</a> 
									</c:if>

									认可了
									<c:if test="${printList.ownid eq user.party_row_id}">我 </c:if>
									<c:if test="${printList.ownid ne user.party_row_id}">${printList.ownname} </c:if>
									的标签 <span style="color: rgb(93, 204, 165)">
										${printList.objectname} </span>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; text-align: center; height: 30px; line-height: 30px;">&nbsp;</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>