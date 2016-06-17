<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.collapse.js"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path %>/css/auth.css">
<style>
.selected{
	float: left;
	background-color: rgb(96, 111, 186);
	color: #fff;
	padding:5px;
	margin:5px;
}
.noselected{
	float: left;
	padding:5px;
	margin:5px;
}
</style>


<script>
function selectthis(obj){
	if($(obj).hasClass("selected")){
		$(obj).addClass("noselected");
		$(obj).removeClass("selected");
	}else{
		$(obj).removeClass("noselected");
		$(obj).addClass("selected");
	}
}

/**
 * 保存权限
 */
function saveRoles(){
	var dataObj = [];
	dataObj.push({name:'roleId', value: '${roleId}' });
	dataObj.push({name:'orgId', value: '${orgId}' });
	var params = "";
	//获取权限下的用户
	$("._role_user_").find("div").each(function(){
		if($(this).attr("opid") && $(this).hasClass("selected")){
			params += $(this).attr("opid") +",";
		}
	});
	dataObj.push({name:'params', value:params });
	
	//保存角色用户
	$.ajax({
	      type: 'post',
	      url: '<%=path%>/userFunc/saveroleuser' || '',
	      data: dataObj || {},
	      dataType: 'text',
	      success: function(data){
	    	  if(!data || data === ''){
	    		  $(".myMsgBox").css("display","").html("保存失败！");
				  $(".myMsgBox").delay(2000).fadeOut();
	    	  }else{
	    		  $(".myMsgBox").css("display","").html("保存成功！");
				  $(".myMsgBox").delay(2000).fadeOut();
	    	  }
	      }
	});
	
	params = "";
	//获取角色功能集
	$(".content").each(function(){
		var tmp = false;
		$(this).find("div").each(function(){
			if($(this).attr("funid") && $(this).hasClass("selected")){
				params += $(this).attr("funid") +",";
				tmp = true;
			}
		});
		if(tmp){
			params += $(this).attr("funid")+",";
		}
	});
	
	dataObj.push({name:'params1', value:params });
	
	//保存角色功能
	$.ajax({
	      type: 'post',
	      url: '<%=path%>/userFunc/saverolefunc' || '',
	      data: dataObj || {},
	      dataType: 'text',
	      success: function(data){
	    	  if(!data || data === ''){
	    		  $(".myMsgBox").css("display","").html("保存失败！");
				  $(".myMsgBox").delay(2000).fadeOut();
	    	  }else{
	    		  $(".myMsgBox").css("display","").html("保存成功！");
				  $(".myMsgBox").delay(2000).fadeOut();
	    	  }
	      }
	});
}

function selectAll(target,flag){
	$("."+target).find("div").each(function(){
		if($(this).attr("funid")){
			if(flag ==='Y'){
				$(this).removeClass("noselected").addClass("selected");
			}else{
				$(this).removeClass("selected").addClass("noselected");
			}
			
		}
	});
}
</script>
 </head>
  <body style="width:100%;background-color:#fff;font-family:'Microsoft Yahei';">
  	  <div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h4 style="padding-right:30px;font-size: 16px;">权限配置</h4>
			<div class="act-secondary" onclick="saveRoles();">
				<span style="border: 1px solid #fff;border-radius: 5px;padding:5px;">保&nbsp;存</span>
			</div>
	  </div>
	  
	  <!-- 角色下的用户 -->
	  <div style="width:100%;padding:10px;height:45px;line-height:25px;font-size:16px; font-weight:bold;background-color:#efefef;">用户列表</div>
	  <div style="clear:both"></div>
	  <div style="margin:10px;" class="_role_user_">
		  <c:forEach items="${userList}" var="user">
		  	  <c:if test="${sessionScope.admin_crmId ne user.crmId}">
			  	  <c:if test="${roleUserMap[user.opId] ne '' && !empty roleUserMap[user.opId] }">
			  	  	  <div class="selected" onclick="selectthis(this);" opid="${user.opId}" crmId="${roleUserMap[user.opId]}" roleId="${roleId }">${user.opName }</div>
			  	  </c:if>
			  	  <c:if test="${roleUserMap[user.opId] eq '' || empty roleUserMap[user.opId]  }">
			  	  	  <div class="noselected" onclick="selectthis(this);" opid="${user.opId}" roleId="${roleId }">${user.opName }</div>
			  	  </c:if>
		  	  </c:if>
		  </c:forEach>
	  </div>
	  <div style="clear:both"></div>
	  <!-- 角色权限 -->
	   <div style="width:100%;padding:10px;height:45px;line-height:25px;font-size:16px; font-weight:bold;background-color:#efefef;">用户权限</div>
	  <div style="clear:both"></div>
	  <div style="border-bottom: 1px solid #ccc;">
	      <div id="css3-animated-example" class="_role_func_">
	      	<c:forEach items="${menuList}" var="menu">
	      		<c:if test="${menu.funId ne 'ZJWK_ROLE_ZJWKROLE'}">
		      		 <h3>${menu.funName }</h3>
		      		 <div>
			      		 <div class="content div_${menu.funId }" funid="${menu.funId }">
			      		 	 <div style="float:left;margin:5px;width:60px;border-radius:10px;text-align:center;padding:5px;background-color:#3e6790;color:#fff;cursor:pointer" onclick="selectAll('div_${menu.funId}','Y')">全选</div>
			            	 <div style="float:left;margin:5px;width:80px;border-radius:10px;text-align:center;padding:5px;background-color:#3e6790;color:#fff;cursor:pointer" onclick="selectAll('div_${menu.funId}','N')">取消全选</div>
			            	 <div style="clear:both;"></div>
			            	 <c:forEach items="${allFuncList}" var="func">
			            	 	<c:if test="${func.funParentId eq menu.funId }">
			            	 		<c:if test="${roleMap[func.funId] ne '' && !empty roleMap[func.funId] }">
			            	 			<div class="selected" onclick="selectthis(this);" roleId="${roleId}" funid="${func.funId}">${func.funName }</div>
			            	 		</c:if>
			            	 		<c:if test="${roleMap[func.funId] eq '' || empty roleMap[func.funId] }">
			            	 			<div class="noselected" onclick="selectthis(this);" roleId="${roleId}" funid="${func.funId}">${func.funName }</div>
			            	 		</c:if>
			            	 	</c:if>
			            	 </c:forEach>
			            	 <div style="clear:both;"></div>
			          	 </div>
		          	 </div>
	          	 </c:if>
	          	 <c:if test="${sessionScope.admin_crmId eq crmId && menu.funId eq 'ZJWK_ROLE_ZJWKROLE'}">
	          	 	 <h3>${menu.funName }</h3>
		      		 <div>
			      		 <div class="content div_${menu.funId }" funid="${menu.funId }">
			      		 	 <div style="float:left;margin:5px;width:60px;border-radius:10px;text-align:center;padding:5px;background-color:#3e6790;color:#fff;cursor:pointer" onclick="selectAll('div_${menu.funId}','Y')">全选</div>
			            	 <div style="float:left;margin:5px;width:80px;border-radius:10px;text-align:center;padding:5px;background-color:#3e6790;color:#fff;cursor:pointer" onclick="selectAll('div_${menu.funId}','N')">取消全选</div>
			            	 <div style="clear:both;"></div>
			            	 <c:forEach items="${allFuncList}" var="func">
			            	 	<c:if test="${func.funParentId eq menu.funId }">
			            	 		<c:if test="${roleMap[func.funId] ne '' && !empty roleMap[func.funId] }">
			            	 			<div class="selected" onclick="selectthis(this);" roleId="${roleId}" funid="${func.funId}">${func.funName }</div>
			            	 		</c:if>
			            	 		<c:if test="${roleMap[func.funId] eq '' || empty roleMap[func.funId] }">
			            	 			<div class="noselected" onclick="selectthis(this);" roleId="${roleId}" funid="${func.funId}">${func.funName }</div>
			            	 		</c:if>
			            	 	</c:if>
			            	 </c:forEach>
			            	 <div style="clear:both;"></div>
			          	 </div>
		          	 </div>
	          	 </c:if>
	      	</c:forEach>
	      </div>
      </div>
      <script>
        $("#css3-animated-example").collapse({
          accordion: true,
          open: function() {
            this.addClass("open");
            this.css({ height: this.children().outerHeight() });
          },
          close: function() {
            this.css({ height: "0px" });
            this.removeClass("open");
          }
        });
      </script>
      
      <div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
  </body>
</html>