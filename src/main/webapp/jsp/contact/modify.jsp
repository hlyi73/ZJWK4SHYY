<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
	<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
	
	<!-- 百度地图API -->
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=134eca242394acd37ffbae329150e589"></script>
	<!--框架样式-->
    <link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
    <script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    	initVariable();
    	initButton();
    	initDatePicker();
    	$(".shade").click(function(){
    		$(".shade").css("display","none");
    		$("#contactmap").css("display","none");
    	});
    	var width = $(window).width();
    	var width1=0;
    	if(width>640){
    		width=640-90;
    		width1=640-240;
    	}else{
    		width = width-90;
    		width1=width-100;
    	}
    	$("#conImg").css("padding-left",width);
    	$("#search_div").css("width",width1);
    	var flag="${flag}";
    	if(flag=='modify'){
    		$(".operbtn").trigger("click");
    	}
    });
    
	  var p = {};
	    
    function initVariable(){
    	
    	p.shareform = $("form[name=shareform]");
   	    p.openId = p.shareform.find(":hidden[name=openId]");
   	    p.publicId = p.shareform.find(":hidden[name=publicId]");
   	    p.parentid = p.shareform.find(":hidden[name=parentid]");
   	    p.parenttype = p.shareform.find(":hidden[name=parenttype]");
   	    p.shareuserid = p.shareform.find(":hidden[name=shareuserid]");
   	    p.shareusername = p.shareform.find(":hidden[name=shareusername]");
   	    p.type = p.shareform.find(":hidden[name=type]");
   	 	p.teamCon=$(".teamCon");
        p.particDiv = $("#shareuser-more");
        p.particFstChar = p.particDiv.find(":hidden[name=fstChar]");
        p.particCurrType = p.particDiv.find(":hidden[name=currType]");
    	p.particCurrPage = p.particDiv.find(":hidden[name=currPage]");
    	p.particPageCount = p.particDiv.find(":hidden[name=pageCount]");
        p.particChartList = p.particDiv.find(".chartList");
        p.particList = p.particDiv.find(".shareUserList");
        p.particBtn = p.particDiv.find(".shareuserbtn");
        
        p.msgCon = $(".msgContainer");
   	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
   	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
  	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
  	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
  	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
  	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
  	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
  	    
  	    p.nativeDiv = $("#site-nav");
        p.contactDetailDiv = $("#contactDetail");
        p.contactDetailFormDiv = p.contactDetailDiv.find(".contactDetailForm");
        
        p.shareusertab = p.particDiv.find(".shareusertab");
        p.followUserList = p.particDiv.find(".followUserList");
        p.followuserbtn = p.particDiv.find(".followuserbtn");
        p.followform = $("form[name=followform]");
        p.followuserid = p.followform.find(":hidden[name=openId]");
        p.follownickname = p.followform.find(":hidden[name=nickName]");
   	    p.followrelaid = p.followform.find(":hidden[name=relaId]");
    }
    
    
    
    function getContactMap(addr){
    	if(!addr){
    		return;
    	}
    	$(".shade").css("display","");
    	var screenHeight = $(window).height();
    	$("#contactmap").css("height",screenHeight-100);
    	$("#contactmap").css("top",50 + $(document).scrollTop());
    	$("#contactmap").css("display","");
    	// 百度地图API功能
		var map = new BMap.Map("contactmap");
		var point = new BMap.Point(116.331398,39.897445);
		map.centerAndZoom(point,12);
		// 创建地址解析器实例
		var myGeo = new BMap.Geocoder();
		// 将地址解析结果显示在地图上,并调整地图视野
		myGeo.getPoint(addr, function(point){
			 if (point) {
				 map.centerAndZoom(point, 16);
				 map.addOverlay(new BMap.Marker(point));
				 var opts = {
					width : 200,     // 信息窗口宽度
					height: 60,     // 信息窗口高度
					title : "${sd.conname}" //, // 信息窗口标题
					//enableMessage:true,//设置允许信息窗发送短息
					//message:"客户的地址是XXXX~"
				 };
				
				var infoWindow = new BMap.InfoWindow("地址："+addr, opts);  // 创建信息窗口对象
				map.openInfoWindow(infoWindow,point); //开启信息窗口
				
			}
		}, "");
		                         //启用滚轮放大缩小
    }
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    //选择联系人称谓
   function selectsalutation(obj,sex){
	   var search_div = $("#search_div");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
	   $(":hidden[name=salutation]").val(sex);
   }
    
	 //初始化按钮
    function initButton(){
    	
		 //发送消息按钮
		 $(".examinerSend").click(function(){
			 sendMessage();
		 });
		 
    	//修改按钮
    	$(".operbtn").click(function(){
    		$(".operbtn").css("display","none");
    		//$("#update").css("display","none");
    		$(".nextCommitExamDiv").css("display","");
    		$(".uptShow").css("display","none");
    		$(".uptInput").css("display","");
    		//判断是否点击了修改按钮
    		$(":hidden[name=flag]").val("upt");
    	});
    	
    	//取消按钮
    	$(".canbtn").click(function(){
    		$(".operbtn").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$("#update").css("display","");
    		$(".uptShow").css("display","");
    		$(".uptInput").css("display","none");
    		$(":hidden[name=flag]").val('');
    	});
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		$(":hidden[name=modifydate]").val(new Date());
    		$(":hidden[name=desc]").val($("#input_desc").val());
    		var name = $(":text[name=conname]").val();
    		var email = $("input[name=email0]").val();
    		var zw = $(":text[name=conjob]").val();
    		/*if(!email){
    			$(".myMsgBox").css("display","").html("请填写邮箱!");
			    $(".myMsgBox").delay(2000).fadeOut();
    			return;
    		}*/
    		if(!name){
    			$(".myMsgBox").css("display","").html("请输入姓名!");
			    $(".myMsgBox").delay(2000).fadeOut();
    			return;
    		}

			if (''!=$.trim(zw))
			{
				//如果输入的职位名称内容超过16个字节则提示信息
			    var char = zw.match(/[^\x00-\xff]/ig);
				var slength = zw.length + (char == null ? 0 : char.length);
				if(Number(slength)>16)
				{
	    			$(".myMsgBox").css("display","").html("职位名称太长，请重新输入!");
				    $(".myMsgBox").delay(2000).fadeOut();
	    			return;
				}
			}

    		var phonework = $("input[name=phonework]");
    		if(phonework.val() && phonework.val().length > 20){
    			$(".myMsgBox").css("display","").html("办公电话输入过长!");
			    $(".myMsgBox").delay(2000).fadeOut();
    			return;
    		}
    		$("form[name=contactform]").submit();
    	});
    	
    	//是否显示修改按钮
    	var assignerid = '${sd.assignerId}';
    	if('${crmId}'!=assignerid){
    		$(".operbtn").css("display","none");
    		$(".delCon").css("display","none");
    		$(".replybtn").css("margin-left","45px");
    		$(".replybtn").css("padding-right","120px");
    	}
    	
    	
    }

	
  //修改联系人频率
	function selectContactTimefre(obj,value) {
	    var search_div = $("#search_div1");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=timefre]").val(value);
	}
  

  
  	var prefile = "";
	//异步上传头像
	function ajaxFileUpload(){
		if(prefile == ""){
			prefile = $(".fileInput").val();
		}else if(prefile == $(".fileInput").val()){
			return;
		}
		$.ajaxFileUpload({
			//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
			url:'<%=path%>/contact/upload',
			secureuri:false,                       //是否启用安全提交,默认为false 
			fileElementId:'uploadFile',           //文件选择框的id属性
			dataType:'text',                       //服务器返回的格式,可以是json或xml等
			success:function(data, status){        //服务器响应成功时的处理函数
				prefile = "";
				$("#conImg").empty();
				if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
					var path = "<%=path%>/contact/download?fileName="+data.substring(1);
					$(":hidden[name=filename]").val(data.substring(1));
					$("#conImg").append('<img style="background-color:#ffffff;width:80px;height:80px;" src="'+path+'"></img>');
					var flag = $(":hidden[name=flag]").val();
					if("upt"!=flag){
						$("form[name=contactform]").submit();
					}
				}else{
					$(".myMsgBox").css("display","").html("图片上传失败,请重试!");
				    $(".myMsgBox").delay(2000).fadeOut();
				}
				$("#conImg").append('<input type="file" onchange="ajaxFileUpload();" style="width: 80px;height: 80px;" accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg" class="fileInput" name="uploadFile" id="uploadFile">');
			},
			error:function(data, status, e){ //服务器响应失败时的处理函数
				prefile = "";
				$(".myMsgBox").css("display","").html("图片上传失败,请联系管理员!");
			    $(".myMsgBox").delay(2000).fadeOut();
				$("#conImg").empty();
				$("#conImg").append('<input type="file" onchange="ajaxFileUpload();" style="width: 80px;height: 80px;" accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg" class="fileInput" name="uploadFile" id="uploadFile">');
			}
		});
	}
	
    //删除实体对象
    function delContact(){
    	if(!confirm("确定删除吗?")){
			return;
		}
	  	$.ajax({
    		url: '<%=path%>/contact/delContact',
    		type: 'post',
    		data: {rowid:'${sd.rowid}',optype:'del'},
    		dataType: 'text',
    	    success: function(data){
    	    	var d = JSON.parse(data);
    	    	if(d.errorCode&&d.errorCode!='0'){
    	    		$(".myMsgBox").css("display","").html(d.errorMsg());
				    $(".myMsgBox").delay(2000).fadeOut();
					return;
    	    	}
    	    	//window.location.replace("<%=path%>/contact/clist");
    	    	window.location.replace("<%=path%>/cbooks/list");
    	    }
    	});
    }
	 
  //初始化日期控件
	function initDatePicker(){
		var opt = {
			date : {preset : 'date'},
			datetime : { preset : 'date', minDate: new Date(1900,1,1), maxDate: new Date(2099,7,30), stepMinute: 5  },
			time : {preset : 'time'},
			tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
			image_text : {preset : 'list', labels: ['Cars']},
			select : {preset : 'select'}
		};
		
		var birthdate = $("input[name=birthdate]").val();
		/* if(!birthday){
			birthday = dateFormat(new Date(), "yyyy-MM-dd hh:mm");
		}else if(birthday.length <=10){
			birthday = birthday + " 00:00:00";
		} */
		
		$("#birthdate").attr("type","date");
		
		$('#birthdate').val(birthdate).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
    </script>
	</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">联系人详情</h3>
		<!-- <a onclick="delContact()" class="delCon" style="/* font-size: 18px; font-weight: bold; */ color: #fff; padding: 0px 10px 0px 10px;margin-top: -50px;float: right;">删除</a> -->
	</div>
	
	<input name="flag" type="hidden" value="">
	
	<div id="contactDetail">
		<div class="recommend-box contactDetailForm">
			<form action="<%=path%>/contact/updatec" name="contactform"method="post" novalidate="true" >
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="orgId" value="${sd.orgId}" />
				<input type="hidden" name="salutation" value="${sd.salutation}" />
				<input type="hidden" name="assigner" value="${sd.assigner}" />
				<input type="hidden" name="creater" value="${sd.creater}" />
				<input type="hidden" name="createdate" value="${sd.createdate}" />
				<input type="hidden" name="modifier" value="${sd.modifier}" />
				<input type="hidden" name="modifydate" value="${sd.modifydate}" />
				<input type="hidden" name="desc" value="${sd.desc}" />
				<input type="hidden" name="assignerId" value="${sd.assignerId}" />
				<input type="hidden" name="timefre" value="${sd.timefre}" >
				<input type="hidden" name="timefrename" value="${sd.timefrename}" >
				<input type="hidden" name="filename" value="${sd.filename}" >
				<div style="padding-left: 5px;padding-right: 5px;padding-top: 5px;">
				<div class="site-card-view _border_">
					<div id="conImg" style="position: absolute;right:10px;margin-top: 5px;height: 1px;">
					<c:if test="${sd.iswbuser eq 'ok'}">
						<img src="${sd.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff; border-radius:8px;">
					</c:if>
					<c:if test="${sd.iswbuser ne 'ok'}">
						<c:if test="${sd.filename ne ''}">
							<img src="<%=path %>/contact/download?fileName=${sd.filename}" style="background-color:#ffffff;width:80px;height:80px">
						</c:if>
						<c:if test = "${sd.filename eq ''}">
							<img src="<%=path %>/image/defailt_person.png" style="background-color:#ffffff;width:80px;height:80px; border-radius:8px;">
						</c:if>
					</c:if>
						<input type="file" onchange="ajaxFileUpload();" style="width: 80px;height: 80px;" accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg" class="fileInput" name="uploadFile" id="uploadFile">
					</div>
					
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>姓名：</th>
									<td class="uptShow">${sd.conname}&nbsp;&nbsp;&nbsp;<a href="<%=path%>/contact/make?rowId=${rowId}"><img style="width: 25px;height: 25px;"src="<%=path%>/image/all-qr.png"></img></a></td>
									<td class="uptInput" style="display: none"><input
										type="text" name="conname" value="${sd.conname}"
										placeholder="请输入联系人姓名"></td>
								</tr>
								<tr>
									<th>称谓：</th>
									<c:if test="${sd.salutation eq 'Mrs.'}">
										<td class="uptShow">女士</td>
									</c:if>
									<c:if test="${sd.salutation eq 'Mr.'}">
										<td class="uptShow">先生</td>
									</c:if>
									<c:if test="${sd.salutation ne 'Mr.' && sd.salutation ne 'Mrs.'}">
										<td class="uptShow">&nbsp;</td>
									</c:if>
									<td class="uptInput"style="display: none;">
										<div id="search_div" style="line-height: 25px;padding-top: 0px; padding-left: 0px;" class="search_div">
												<a href="javascript:void(0)"onclick="selectsalutation(this,'Mr.')" 
													<c:if test="${sd.salutation eq 'Mr.'}">
														class="selected" </c:if> 
												>先生</a>
												<a href="javascript:void(0)"onclick="selectsalutation(this,'Mrs.')" 
													<c:if test="${sd.salutation eq 'Mrs.'}">
												class="selected" </c:if>>女士</a>
										  	
										</div>
									</td>
								</tr>
								<%--<c:if test="${sd.parenttype eq 'Account'}">
								 <tr>
									<th>客户名称：</th>
									<td>
										<c:if test="${sd.parentid ne '' && !empty(sd.parentid)}">
											<a href="<%=path%>/customer/detail?rowId=${sd.parentid}">${sd.parentname}</a>
										</c:if>
										<c:if test="${sd.parentid eq '' || empty(sd.parentid)}">
											${sd.parentname }
										</c:if>
									</td>
								</tr> 
								</c:if>--%>
								<tr>
									<th>移动电话：</th>
									<td class="uptShow">
										<c:if test="${sd.phonemobile ne '' }">
											<a href="tel:${sd.phonemobile}"><img src="<%=path %>/image/mb_card_contact_method_2.png" width="20px"></a>&nbsp;
										</c:if>
										${sd.phonemobile}
									</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="phonemobile"  value="${sd.phonemobile}"
										placeholder="请输入联系人移动电话"></td>
								</tr>
								<tr>
									<th>邮箱：</th>
									<td class="uptShow">${sd.email0}
									</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="email0" value="${sd.email0}"
										placeholder="请输入联系人邮箱"></td>
								</tr>
								<tr>
									<th>部门：</th>
									<td class="uptShow">${sd.department}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="department" value="${sd.department}"
										placeholder="请输入联系人部门"></td>
								</tr>
								<tr>
									<th>职称：</th>
									<td class="uptShow">${sd.conjob}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="conjob"value="${sd.conjob}"
										placeholder="请输入联系人职称"></td>
								</tr>
							</tbody>
						</table>
					</div></div>
					<br/>
					</div>
					<div style="padding-left: 5px;padding-right: 5px;">
					<div class="site-card-view _more_information _border_" >
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>办公电话：</th>
									<td class="uptShow">
									<c:if test="${sd.phonework ne '' }">
											<a href="tel:${sd.phonework}"><img src="<%=path %>/image/mb_card_contact_tel.png" width="20px"></a>&nbsp;
									</c:if>
									${sd.phonework}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="phonework" value="${sd.phonework}" 
										placeholder="请输入联系人办公电话"></td>
								</tr>
								<tr>
									<th>地址：</th>
									<td class="uptShow">
										<c:if test="${sd.conaddress ne ''}">
											<a href="javascript:void(0)" onclick="getContactMap('${sd.conaddress}')"><img src="<%=path%>/image/wx_oppty_tas_val.png" width="24px"></a>&nbsp;
										</c:if>
									${sd.conaddress}
									</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="conaddress" value="${sd.conaddress}"
										placeholder="请输入联系人地址"></td>
								</tr>
								<tr>
									<th>生日：</th>
									<td class="uptShow">${sd.birthdate}	</td>
									<td class="uptInput" style="display: none">
									<input name="birthdate" id="birthdate" value="${sd.birthdate}" type="text" readonly="readonly" /></td>
								</tr>
								<tr>
									<th>联系频率：</th>
									<td class="uptShow">${sd.timefrename}</td>
									<td class="uptInput" style="display: none">
										<div id="search_div1" style="line-height: 25px;padding-top: 0px; padding-left: 0px;" class="search_div">
											<c:forEach items="${timefres}" var="item">
											<c:if test="${item.value ne ''}">
												<a href="javascript:void(0)" onclick="selectContactTimefre(this,'${item.key}')"
													<c:if test="${sd.timefrename eq item.value}">
														class="selected" </c:if> 
												>${item.value}</a>
											</c:if>
											</c:forEach>
										</div>
									</td>
								</tr>
								<tr>
									<th>责任人：</th>
									<td>${sd.assigner}</td>
								</tr>
								<tr>
									<th>备注：</th>
									<td class="uptShow">${sd.desc}</td>
									<td class="uptInput" style="display:none">
										<textarea id="input_desc" rows="" cols="" placeholder="请输入备注信息" >${sd.desc}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div></div>
					<br/>
					</div>
					
					<div style="padding-left: 5px;padding-right: 5px;">
					<div class="site-card-view _border_" >
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>创建人：</th>
									<td>${sd.creater}&nbsp;&nbsp;${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改人：</th>
									<td>${sd.modifier}&nbsp;&nbsp;${sd.modifydate}</td>
								</tr>
								
							</tbody>
						</table>
					</div>
					</div>
				</div>
				</form>
				
		    </div>
				
			
			<!-- 修改按钮 -->
			<div id="update" class="flooter" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;">
				<div class="ui-block-a" style="float: left;margin: 10px 0px 10px 10px;">
					<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('update')">
				</div>
				<c:if test="${sd.orgId ne 'Default Organization'}">
					<div class="ui-block-a operbtn"
						style="width: 95%;margin: 5px 0px 1px 0px;margin-left: 50px;margin-bottom: 5px;">
						<a href="javascript:void(0)" class="btn"
							style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">修改</a>
					</div>
				</c:if>
				
				<c:if test="${sd.orgId eq 'Default Organization' }">
					<div class="button-ctrl" style="margin-left:50px;margin-top:-2px;">
						<fieldset class="">
							<div class="ui-block-a operbtn">
								<a href="javascript:void(0)" class="btn btn-default btn-block"
									style="font-size: 14px; background-color:RGB(75, 192, 171)">修改</a>
							</div>
							<div class="ui-block-a _importbtn">
								<a href="javascript:void(0)" class="btn btn-default btn-block"
									style="font-size: 14px; background-color:RGB(75, 192, 171)">导入</a>
							</div>
						</fieldset>
					</div>
					<jsp:include page="/common/orglist.jsp">
						<jsp:param value="${sd.orgId }" name="sourceOrgId"/>
						<jsp:param value="${sd.rowid}" name="parentid"/>
						<jsp:param value="Contacts" name="parenttype"/>
					</jsp:include>
				</c:if>
				
			</div>	
			<!--确定/取消按钮-->
			<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display: none;z-index:99999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;">
				<div class="ui-block-a" style="float: left;margin: 10px 0px 10px 10px;">
						<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('confirmdiv')">
				</div>
				<div class="button-ctrl" style="margin-left:50px;margin-top:-2px;margin-bottom: 5px;">
					<fieldset class="">
						<div class="ui-block-a canbtn">
							<a href="javascript:void(0)" 
								class="btn btn-default btn-block" style="font-size: 14px;background-color:#999;">取消</a>
						</div>
						<div class="ui-block-a conbtn">
							<a href="javascript:void(0)"
								class="btn btn-success btn-block" style="font-size: 14px;">确定</a>
						</div>
					</fieldset>
				</div>
			</div>
	</div>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
 	<div class="shade" style="z-index:999999;display:none"></div>
 	<div id="contactmap" style="z-index:9999999;display:none;width:80%;height:300px;left:10%;position: absolute;"></div>
 	<br><br><br>
 	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>