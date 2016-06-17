<%@page import="com.takshine.wxcrm.message.sugar.ScheduleAdd"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/model/discugroup_list.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<!-- template -->
<script type="text/html" id="singleDiscuGroupTemp">
<div style="padding: 6px; border-bottom: 1px solid #FAFAFA;" dgid="{{id}}">
	<div style="float: left;">
		{{if head_img_url != ''}}
			<img src="{{head_img_url}}"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
		{{if head_img_url == '' && wx_img_url != ''}}
			<img src="{{wx_img_url}}"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
		{{if wx_img_url == '' && head_img_url == ''}}
			<img src="<%=path %>/image/mygroup.png"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
	</div>
	<div style="float: left; margin-left: 15px; line-height: 20px;">
		<p style="text-align: left;color:#111;">{{name}}</p>
		<p style="text-align: left;color:#888;padding:2px 0px;">发起人：{{creator_name}}
        {{if orgId != '' && orgId != 'Default Organization'}}
			({{orgName}})
		{{/if}}
		&nbsp;&nbsp;
        </p>
        <p style="text-align: left;color:#888;padding:2px 0px;">
        	<span>人数：{{dis_user_count}}</span>&nbsp;&nbsp;<span>话题数：{{dis_topic_count}}</span>
        </p>
	</div>
	<div style="clear: both;"></div>
</div>
</script>
<script type="text/html" id="singleWeightDiscuGroupTemp">
<div style="padding: 6px; border-bottom: 1px solid #FAFAFA;" dgid="{{id}}">
	<div style="float: left;">
		{{if head_img_url != ''}}
			<img src="{{head_img_url}}"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
		{{if head_img_url == '' && wx_img_url != ''}}
			<img src="{{wx_img_url}}"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
		{{if wx_img_url == '' && head_img_url == ''}}
			<img src="<%=path %>/image/mygroup.png"
					style="width: 40px; border-radius: 20px;">
		{{/if}}
	</div>
	<div style="float: left; margin-left: 15px; line-height: 20px;">
		<p style="text-align: left;color:#111;">{{name}}<img style="margin-left: 12px;" src="<%=path %>/image/hot.png"/></p>
		<p style="text-align: left;color:#888;padding:2px 0px;">发起人：{{creator_name}}
		{{if orgId != '' && orgId != 'Default Organization'}}
			({{orgName}})
		{{/if}}
		&nbsp;&nbsp;</p>
        <p style="text-align: left;color:#888;padding:2px 0px;">
			<span>人数：{{dis_user_count}}</span>&nbsp;&nbsp;<span>话题数：{{dis_topic_count}}</span>
		</p>
	</div>
	<div style="clear: both;"></div>
</div>
</script>

<script type="text/javascript">
   var discuGroup;
   $(function(){
	   discuGroup = new DiscuGroup_List();	   
   });
   
   function searchDataByOrgId(orgId){
	   $("#discugroup_list .my_list .loadingdata").removeClass("none");
	   $("#discugroup_list .my_list .sub_content").empty();
	 	//清空当前页
	   discuGroup.currpages = 0;
	   discuGroup.orgId = orgId;
	   discuGroup._initDgListData({orgId:orgId});
   }
</script>
</head>
<body id="mybody">
	<div class="orgDiv">
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Discugroup" name="relaModule"/>
	</jsp:include>
	</div>
	<div id="discugroup_list" style="max-width:640px">
		
		<div class="search none zjwk_fg_nav_2">
			<div style="height: 44px;width: 75%;float: left;">
				<input type="text" value="" placeholder="讨论组搜索" name="searchtxt" style="border-radius: 5px; font-size: 14px; border: 1px solid #ddd; line-height: 30px;">
			</div>
			<div style="height: 44px;width: 25%;float: left;margin-top: 1px;text-align: center;">
				<a class="searchbtn" style="border-radius: 5px; font-size: 14px; border: 1px solid #eee; padding: 3px;margin-top: 20px;">查询</a>
				<a class="backbtn" style="border-radius: 5px; font-size: 14px; border: 1px solid #eee; padding: 3px;margin-top: 20px;">返回</a>
			</div>
			<div style="clear: both;"></div>
		</div>

		<div class="content_list" style="width: 100%;margin-top:8px;" class="content statusDom "> 
			<!-- 我的讨论组 -->
			<div class="my_list" style="width: 100%; text-align: center; color: #6D6B6B;background-color: #fff;border-bottom:1px solid #ddd;">
				<div class="sub_title zjwk_fg_nav" style="font-size: 14px; text-align: left; line-height: 40px; color: #0A0A0A;border-bottom:1px solid #eee;padding-left: 15px;">
					<div style="float: left;" class="my_list_group">
						<img class="arrleft none" style="margin-top: -3px" src="<%=path %>/image/arrleft.png" />
						<img class="arrdown " style="margin-top: -3px" src="<%=path %>/image/arrdown.png" />
						我的讨论组
					</div>
					<%-- <div class="addBtn" style="float: right;margin-right: 15px;"><img style="width: 35px;" src="<%=path %>/image/zjwk_qun.png"></div> --%>
					<div class="addBtn" style="float: right;margin-right: 21px;">创建</div>
					<div class="screeningBtn" style="float: right;margin-right: 21px;">筛选</div>
					<div style="clear: both;"></div>
				</div>
				<div class=" sub_content" style="margin-left: 5px; margin-right: 5px; margin-top: 5px;"></div>
				<div class="none nodata" style="line-height: 50px; width: 100%; text-align: center;">没有找到匹配的数据！</div>
				<div class="none loadingdata" style="line-height: 80px; width: 100%; text-align: center; color: #999;"><img src="<%=path %>/image/loading.gif"></div>
				<div class="more none" style="text-align: right;color: #6CCDF7;margin-left: 5px; padding-right: 35px; line-height: 44px;font-size: 12px;border-top: 1px solid #ECECEC;">更多...</div>
			</div>
			<!-- 系统推荐 -->
			<div class="weight_list ">
				<div class="zjwk_fg_nav" style="font-size: 14px; text-align: left; line-height: 40px; color: #0A0A0A;border-bottom:1px solid #eee;padding-left: 15px;">
					热门讨论组
				</div>
				<div class="none sub_content" style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
				</div>
				<div class="none nodata" style="line-height: 50px; width: 100%; text-align: center;">没有找到匹配的数据！</div>
				<div class="none loadingdata" style="line-height: 80px; width: 100%; text-align: center; color: #999;"><img src="<%=path %>/image/loading.gif"></div>
			</div>
		</div>
		<!-- 按照条件查询 -->
		<div class="search_list none"
			style="margin-bottom: 30px;width: 100%; text-align: center; color: #6D6B6B;margin-top:8px;border-bottom:1px solid #ddd;background-color: #fff">
			<div class="" style="font-size: 14px; text-align: left; line-height: 40px; color: #0A0A0A;padding-left: 15px;">
				讨论组搜索结果
			</div>
			<div class="none sub_content" style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
			</div>
			<div class="none nodata" style="line-height: 50px; width: 100%; text-align: center;">没有找到匹配的数据！</div>
			<div class="none loadingdata" style="line-height: 80px; width: 100%; text-align: center; color: #999;"><img src="<%=path %>/image/loading.gif"></div>
		</div>
		<!--tips提示框 -->
		<div class="myDefMsgBox " style="display: none">&nbsp;</div>
	</div>
	<div style="margin-bottom:20px;"></div>
	<!-- myMsgBox -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 9998; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>