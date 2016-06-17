<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
  <script type="text/javascript">
    $(function () {
    	//shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
	});
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    function showAllContent(id){
    	$("#more_a_"+id).css("display","none");
    	$("#more_content_"+id).css("display","");
    }
    
    function showAllSum(id){
    	$("#more_b_"+id).css("display","none");
    	$("#more_sum_"+id).css("display","");
    }
    
    function showAllQue(id){
    	$("#more_c_"+id).css("display","none");
    	$("#more_que_"+id).css("display","");
    }
    
  </script>
</head>
<body>
<div id="task-create">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">${week.reporttypename}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend">
		<div class="recommend-box">
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>填报人：</th>
									<td class="upShow">${week.assigner}</td>
								</tr>
								<tr>
									<th>部门：</th>
									<td class="upShow">${week.department}</td>
								</tr>
								<tr>
									<th>填报时间：</th>
									<td class="upShow">${week.date}</td>
								</tr>
							<c:forEach var="sd" items="${details}" varStatus="status">
								<c:if test="${reporttype eq '1'}">
								<tr>
									<td class="upShow" colspan="2" style="text-align:center;background-color:#eee;">${sd.ordinal}.${sd.typename}</td>
								</tr>
								<tr>
									<th>时间：</th>
									<td class="upShow">${sd.startdate}~${sd.enddate}</td>
								</tr>
								<c:if test="${sd.parentid !=null && sd.parenttype eq 'Contract'}">
									<tr>
										<th>相关：</th>
										<td><img src="<%=path%>/image/acounts.png" width="20px" border=0>
											<a href="<%=path%>/contract/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
											class="list-group-item listview-item">${sd.parentname}</a></td>
									</tr>
								</c:if>
								<c:if test="${sd.parentid !=null && sd.parenttype eq 'Opportunities'}">
									<tr>
										<th>相关：</th>
										<td>
											<img src="<%=path%>/image/opptys.png" width="20px" border=0>
											<a href="<%=path%>/oppty/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
											class="list-group-item listview-item">${sd.parentname}</a></td>
									</tr>
								</c:if>
								<tr>
									<th>工作内容：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.content) > 60}">
											${fn:substring(sd.content,0,60)}
											<a  href="javascript:void(0)" onclick="showAllContent('${status.index}');">
												<span id="more_a_${status.index}">...全部展开</span>
											</a>
											<span id="more_content_${status.index}" style="display:none;">${fn:substring(sd.content,60,fn:length(sd.content)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.content) <= 60}">
											${sd.content}
										</c:if>
									</td>
								</tr>
								<c:if test="${sd.summarize ne ''}">
									<tr>
										<th>总结：</th>
										<td class="upShow">
											<c:if test="${fn:length(sd.summarize) > 60}">
												${fn:substring(sd.summarize,0,60)}
												<a href="javascript:void(0)" onclick="showAllSum('${status.index}');">
													<span id="more_b_${status.index}">...全部展开</span></a>
												<span id="more_sum_${status.index}" style="display:none;">${fn:substring(sd.summarize,60,fn:length(sd.summarize)) }</span>
											</c:if>
											<c:if test="${fn:length(sd.summarize) <=60}">
												${sd.summarize}
											</c:if>
										</td>
									</tr>
								</c:if>
								<c:if test="${sd.product ne ''}">
									<tr>
										<th>未交付产品：</th>
										<td class="upShow">${sd.product}</td>
									</tr>
								</c:if>
							</c:if>
							<c:if test="${reporttype eq '2'}">
								<tr>
									<th>序号：</th>
									<td class="upShow">${sd.ordinal}</td>
								</tr>
								<tr>
									<th>相关：</th>
									<td>
										<img src="<%=path%>/image/opptys.png" width="20px" border=0>
										<a href="<%=path%>/oppty/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
										class="list-group-item listview-item">${sd.parentname}</a></td>
								</tr>
								<tr>
									<th>主要目标：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.goal) > 60}">
											${fn:substring(sd.goal,0,60)}
											<a href="javascript:void(0)" onclick="showAllContent('${status.index}');" >
												<span id="more_a_${status.index}">...全部展开</span>
											</a>
											<span id="more_content_${status.index}" style="display:none;">${fn:substring(sd.goal,60,fn:length(sd.goal)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.goal) <= 60}">
											${sd.goal}
										</c:if>
									</td>
								</tr>
								<tr>
									<th>项目动态：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.projectdynamic) > 60}">
											${fn:substring(sd.projectdynamic,0,60)}
											<a href="javascript:void(0)" onclick="showAllSum('${status.index}');" >
												<span id="more_b_${status.index}">...全部展开</span>
											</a>
											<span id="more_sum_${status.index}" style="display:none;">${fn:substring(sd.projectdynamic,60,fn:length(sd.projectdynamic)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.projectdynamic) <= 60}">
											${sd.projectdynamic}
										</c:if>
									</td>
								</tr>
								<c:if test="${sd.qutorsugg ne ''}">
								<tr>
									<th>问题和建议：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.qutorsugg) > 60}">
											${fn:substring(sd.qutorsugg,0,60)}
											<a href="javascript:void(0)" onclick="showAllQue('${status.index}');" >
											<span id="more_c_${status.index}">...全部展开</span></a>
											<span id="more_que_${status.index}" style="display:none;">${fn:substring(sd.qutorsugg,60,fn:length(sd.qutorsugg)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.qutorsugg) <= 60}">
											${sd.qutorsugg}
										</c:if>
									</td>
								</tr>
								</c:if>
								</c:if>
							<c:if test="${reporttype eq '3'}">
								<tr>
									<th>序号：</th>
									<td class="upShow">${sd.ordinal}</td>
								</tr>
								<tr>
									<th>类型：</th>
									<td class="upShow">${sd.questtypename}</td>
								</tr>
								<tr>
									<th>内容：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.content) > 60}">
											${fn:substring(sd.content,0,60)}
											<a  href="javascript:void(0)" onclick="showAllContent('${status.index}');">
												<span id="more_a_${status.index}">...全部展开</span>
											</a>
											<span id="more_content_${status.index}" style="display:none;">${fn:substring(sd.content,60,fn:length(sd.content)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.content) <= 60}">
											${sd.content}
										</c:if>
									</td>
								</tr>
							</c:if>
							</c:forEach>
							</tbody>
						</table>
					</div></div>	
		</div>
	</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	  <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",  
			title:"",  
			desc:"",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>