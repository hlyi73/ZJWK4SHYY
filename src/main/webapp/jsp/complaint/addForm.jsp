<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

<script type="text/javascript">
		$(function () {
		//	initWeixinFunc();
			initForm();
			initDom();
		});
		
	/* 	//微信网页按钮控制
		function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		} */
		
		var p={};
		//初始化dom节点
		function initDom(){
			p.fstChar = $(":hidden[name=fstChar]");
			p.seachUrl=$(":hidden[name=seachUrl]");
			p.currPage=$(":hidden[name=currPage]");
			p.pageCount=$(":hidden[name=pageCount]");
			p.currType=$(":hidden[name=currType]");
			p.customerid=$(":hidden[name=customerid]");
			p.customername=$("input[name=customername]");
			p.contactid=$(":hidden[name=contactid]");
			p.contactname=$("input[name=contactname]");
			p.contractid=$(":hidden[name=contractid]");
			p.contractname=$("input[name=contractname]");
			p.opptyid=$(":hidden[name=opptyid]");
			p.opptyname=$("input[name=opptyname]");
		}
		
		//初始化表单按钮和控件
		function initForm(){
			//发起人选择事件
			$(".assignerChoose").click(function(){
				$("#task-create").addClass("modal");
				$("#assigner-more").removeClass("modal");
				$("#systemtitle").html("投诉对象列表");
				$(window).scrollTop(0);
			});
			
			//发起人退回
			$(".assignerGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#assigner-more").addClass("modal");
			});
			
		 	// 发起人的确定按钮
			$(".assignerbtn").click(function(){
				$(".assignerList > a.checked").each(function(){
					var assId = $(this).find(":hidden[name=assId]").val();
					var assName = $(this).find(".assName").html();
					$("input[name=sponsorname]").val(assName);
					$(":hidden[name=complaint_target]").val(assId);
					$(".assignerGoBak").trigger("click");
					//$("form[name=complaintform]").submit();
				});
			}); 
			
			//相关选择事件
			$(".parentChoose").click(function(){
				var v = $(this).attr("val");
				var type="";
				var url="";
				if(v === "Accounts"){
					type="accntList";
					url='<%=path%>/customer/list';
				}else if(v === "Opportunities"){
					type="opptyList";
					url='<%=path%>/oppty/list';
				}else if(v === "Contract"){
					type="contractList";
					url='<%=path%>/contract/asylist';
				}else if(v === "Contact"){
					type="contactList";
					url='<%=path%>/contact/asyclist';
				}
				p.fstChar.val('');
				p.currPage.val('1');
				p.currType.val(v);
				p.seachUrl.val(url);
		    	searchFristCharts(type);
		    	scheduleReleation(type);
		    	$("#task-create").addClass("modal");
				$("#parent-more").removeClass("modal");
			});
		 	
			// 相关的确定按钮
			$(".parentbtn").click(function(){
				var v = p.currType.val();
				var parentId='', parentName='';
				$(".parentList > a.checked").each(function(){
					parentId = $(this).find(":hidden[name=parentId]").val();
					parentName = $(this).find(":hidden[name=parentName]").val();
				});
				if(v === "Accounts"){
					p.customerid.val(parentId);
					p.customername.val(parentName);
				}else if(v === "Opportunities"){
					p.opptyid.val(parentId);
					p.opptyname.val(parentName);
				}else if(v === "Contract"){
					p.contractid.val(parentId);
					p.contractname.val(parentName);
				}else if(v === "Contact"){
					p.contactid.val(parentId);
					p.contactname.val(parentName);
				}
				$(".parentGoBak").trigger("click");
			});
			
			//相关数据返回点击事件
			$(".parentGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#parent-more").addClass("modal");
			});
			
			//直接保存SR
			$(".submitBtn").click(function(){
				if(!validates()){
					$("form[name=complaintform]").submit();
					$(".submitBtn").unbind("click");
				}
			});
			
			//派工之后再保存
			$(".submitToOtherBtn").click(function(){
				if(!validates()){
					$("#task-create").addClass("modal");
					$("#assigner-more").removeClass("modal");
				}
			});
		}
		  
	   	 //勾选相关数据的超链接
		 function parentListSel(){
			$(".parentList > a").click(function(){
				$(".parentList > a").removeClass("checked");
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}else{
					$(this).addClass("checked");
				}
				return false;
			});
	    }
		
		 //查询模块的首字母
	    function searchFristCharts(type){
	    	$.ajax({
		  	      type: 'get',
		  	      url: '<%=path%>/fchart/list',
		  	      data: {crmId: '${crmId}',type: type},
		  	      dataType: 'text',
		  	      success: function(data){
		  	    		$("#fristChartsList").empty();
		  	    		
		  	    	    if(!data) return;
		  	    	    var d = JSON.parse(data);
		  	    	    if(d.errorCode && d.errorCode !== '0'){
		  	    	  		$("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
				    	    return;
				    	}
		  	    	  	
		  	    	    var ahtml = '';
		  	    	    $(d).each(function(i){
		  	    	    	ahtml += '<a href="javascript:void(0)" style="margin: 0px 12px 0px 12px;" onclick="chooseFristCharts(\''+ type +"','"+this+'\')">'+ this +'</a>';
		  	    	    });
		  	    	    $("#fristChartsList").html(ahtml);
		  	      }
	    	 });
	    }

	    //点击首字母事件
	    function chooseFristCharts(type,obj){
	    	p.fstChar.val(obj);
	    	p.currPage.val('1');
	    	scheduleReleation(type);
	    }
	    
	  	//相关
	    function scheduleReleation(type){
	    	var currpage = p.currPage.val();
	    	if(parseInt(currpage) == 1){
	    		$("#div_prev").css("display",'none');
	    	}else{
	    		$("#div_prev").css("display",'');
	    	}
	    	var firstchar=p.fstChar.val();
	    	var pagecount=p.pageCount.val();
	    	$.ajax({
    		      type: 'get',
    		      url: p.seachUrl.val(),
    		      async: false,
    		      data: {crmId: '${crmId}',openId:'${openId}',publicId:'${publicId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
    		      dataType: 'text',
    		      success: function(data){
    		    	  	if(!data){
	  		    	  		$(".parentList").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
	  		    	  		return;
	  		    	  	}
    		    	    var val = '';
    		    	    var d = JSON.parse(data);
    		    	    if(d.errorCode && d.errorCode !== '0'){
			  	    	  	$("#div_next").css("display",'none');
			    	    	$(".parentList").empty();
		  	    	  		$(".parentList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
		  	    	  		return;
				    	}
    					if(d == "" && $(d).size()==0){
    		    	    	val = "<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>";
    		    	    	$("#div_next").css("display",'none');
    		    	    	$(".parentList").empty();
    		    	    }else{
   		    	    		if($(d).size() == pagecount){
   		    	    			$("#div_next").css("display",'');
   		    	    		}else{
   		    	    			$("#div_next").css("display",'none');
   		    	    		}
   							$(d).each(function(i){
   								if(type === "accntList"){
   									var content="";
   									if(this.phoneoffice != ''){
   										content = '<p class="text-default"><img src="<%=path%>/image/mb_card_contact_tel.png" width="16px">' + this.phoneoffice+'</p>';
									}
   									content += '<p class="text-default">';
									if(this.source != ''){
										content += '来源：' + this.source;
									}
									if(this.industry != ''){
										content += '行业：' + this.industry;
									}
									content += '</p>';
   									val += '<a href="javascript:void(0)" class="list-group-item listview-item radio"'
	  									+'><div class="list-group-item-bd">'
	  									+'<div class="thumb list-icon"><b>'+this.accnttype+'</b></div>'
	  									+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
	  									+'<input type="hidden" name="parentName" value="'+this.name+'"/>'
	  									+'<h1 class="title">'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
	  									+this.assigner+'</span></h1>'+content
	  									+'</div><div class="input-radio" title="选择该条记录"></div></a>';
   								}else if(type === "opptyList"){
   									val +='<a href="javascript:void(0)" class="list-group-item listview-item radio">'
   	   									+'<div class="list-group-item-bd"> <div class="thumb list-icon"><b>'+this.probability+'%</b></div>'
   	   									+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
   	   							        +'<input type="hidden" name="parentName" value="'+this.name+'"/><h1 class="title">'+this.name+'&nbsp;<span '
   	   									+'style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1><p class="text-default">'
   	   									+'预期:￥'+this.amount+'&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:'+this.salesstage+'</p>'
   	   									+'<p>关闭日期:'+this.dateclosed+'&nbsp;&nbsp;&nbsp;&nbsp;跟进天数:'+this.createdate+'</p>'
   	   									+'</div><div class="input-radio" title="选择该条记录"></div></a>';
   								}else if(type === "contractList"){
   									val += '<a href="javascript:void(0)"'
	   								    +  ' class="list-group-item listview-item radio"><div class="list-group-item-bd">'
	   								 	+'<input type="hidden" name="parentId" value="'+this.rowid+'"/>'
										+'<input type="hidden" name="parentName" value="'+this.title+'"/>'
	   									+  '<div class="thumb list-icon"><b>'+this.contractstatusname+'</b></div>'
	   									+  '<div class="content" style="text-align: left"><h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
	   									+  this.assigner+'</span></h1><p class="text-default">开始日期：'+this.startDate+'&nbsp;&nbsp;结束日期：'+this.endDate+'</p>'
	   									+  '<p class="text-default">合同金额：￥'+this.cost+'万元&nbsp;&nbsp;已收：<span style="color:blue">￥'+this.recivedAmount+'万元</span></p>'
	   									+  '</div></div><div class="input-radio" title="选择该条记录"></div></a>';
   								}else if(type === "contactList"){
   									val +='<a href="javascript:void(0)" class="list-group-item listview-item radio">'
   									 +'<input type="hidden" name="parentId" value="'+this.rowid+'" >'
   									 +'<input type="hidden" name="parentName" value="'+this.conname+'" >'
   									 +'<div class="list-group-item-bd">'
   									 +'<div class="thumb list-icon" style="background-color:#ffffff;width:60px;height:40px;">';
	   								if(""==this.filename){
	   									val +='<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
	   								}else{
	   									val +='<img src="<%=path %>/contact/download?fileName='+this.filename+'" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
	   								}
   									val += '</div>'
   									 +'<div class="content" style="text-align: left">'
   									 +'<h1 class="title partName">'+this.conname+'</h1><p>'+this.conjob + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+this.phonemobile
   									 +'</p></div></div><div class="input-radio"></div></a>';
   								}
   							});
    						$("#fristChartsList").css("display",'');
    		    	    }
    					$(".parentList").html(val);
    					parentListSel();
	    		      }
	    		 });
	  	}
	  	
	  	//翻页
	    function topage(type){
	    	var parenttype = p.currType.val();
	    	var currpage = p.currPage.val();
	    	if(type == "prev"){
	    		p.currPage.val(parseInt(currpage) - 1);
	    	}else if(type == "next"){
	    		p.currPage.val(parseInt(currpage) + 1);
	    	}
	    	if(parenttype == "Accounts"){
	    		scheduleReleation("accntList");
	    	}else if(parenttype == "Opportunities"){
	    		scheduleReleation("opptyList");
	    	}else if(parenttype === "Contract"){
				scheduleReleation("contractList");
			}else if(parenttype === "Contact"){
				scheduleReleation("contactList");
			}
	    }
	  	
	  	//验证所有的参数是否都已经填写
	  	function validates(){
  			var flag= false ;
	  		$("#complaintform").find(":hidden").each(function(){
	  			var val=$(this).val();
	  			var name=$(this).val();
	  			if(name && 'contractid' != name && !val){
	  				flag=true;
	  			}
	  		});
	  		if(!($("textarea[name=name]").val())){
	  			flag=true;
	  		}
			if(flag){
				$(".myMsgBox").css("display","").html("填写不完整!请您将带有*标签的字段都填上!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return false;
			}	  			
	  	}
	  	
	</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar" >
			<div style="float: left">
				<a href="javascript:void(0)" onclick="javascript:history.go(-1)" style="color: #fff;padding:5px 5px 5px 0px;">
					<img src="<%=path%>/image/back.png" width="40px" style="padding:5px;">
				</a>
			</div>
			<h3 style="padding-right:45px;">创建投诉</h3>
		</div>
		<input type="hidden" name="currType" />
	    <input type="hidden" name="seachUrl" />
	    <input type="hidden" name="fstChar" />
	    <input type="hidden" name="currPage" value="1" />
	    <input type="hidden" name="pageCount" value="10" />
		<div class="wrapper">
			<form id="complaintform" name="complaintform" action="<%=path%>/complaint/save" method="post"  >
				<input type="hidden" name="crmid" value="${crmId}" /> 
				<input type="hidden" name="created_by" value="${assignerid}" /> 
				<input type="hidden" name="servertype" value="${servertype}" />
				<input type="hidden" name="status" value="Draft" />
				<!-- 服务请求信息编号 -->
				<div class="form-group">
					<label class="control-label" >投诉信息编号&nbsp;<span style="color:red;">*</span></label>
					<input name="case_number" id="case_number" value="" type="number"
						class="form-control" placeholder="请输入数字编号"/>
				</div>
				<!-- 相关客户 -->
				<div class="form-group">
					<label class="control-label" for="parent">客户 &nbsp;<span style="color:red;">*</span></label>
					<input name="customerid" id="customerid" type="hidden" class="form-control" >
					<input name="customername" id="customername" type="text" val="Accounts"
					       class="form-control parentChoose" value="" placeholder="【点击  选择相关客户】  >>  " readonly="readonly" >
				</div>
				<!-- 相关联系人 -->
				<div class="form-group">
					<label class="control-label" for="parent">联系人&nbsp;<span style="color:red;">*</span></label>
					<input name="contactid" id="contactid" type="hidden" class="form-control" >
					<input name="contactname" id="contactname"  type="text" val="Contact"
					       class="form-control parentChoose" value=""  placeholder="【点击  选择相关联系人】  >>  " readonly="readonly" >
				</div>
				<!-- 相关商机 -->
				<div class="form-group">
					<label class="control-label" for="parent">商机&nbsp;<span style="color:red;">*</span></label>
					<input name="opptyid" id="opptyid" type="hidden" class="form-control" >
					<input name="opptyname" id="opptyname" val="Opportunities" type="text" 
					       class="form-control parentChoose" value=""  placeholder="【点击  选择相关商机】  >>  " readonly="readonly" >
				</div>
				<!-- 相关合同 -->
				<div class="form-group">
					<label class="control-label" for="parent">合同</label>
					<input name="contractid" id="contractid" type="hidden" class="form-control" >
					<input name="contractname" id="contractname" val="Contract" type="text" 
					       class="form-control parentChoose" value="" placeholder="【点击  选择相关合同】  >>  " readonly="readonly" >
				</div>
				<!-- 投诉分类 -->
				<div class="form-group">
					<label class="control-label" for="driority">投诉分类&nbsp;<span style="color:red;">*</span></label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="subtype" id="subtype">
							<c:forEach var="item" items="${substypes_compt}">
								<option value="${item.key}">${item.value}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<!-- 投诉来源 -->
				<div class="form-group">
					<label class="control-label" for="driority">投诉来源&nbsp;<span style="color:red;">*</span></label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="complaint_source" id="complaint_source">
							<c:forEach var="item" items="${sources}">
								<c:if test="${item.key ne ''}">
									<option value="${item.key}">${item.value}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>
				</div>
				<!-- 投诉对象 -->
				<div class="form-group">
					<label class="control-label" for="assigner">投诉对象&nbsp;<span style="color:red;">*</span></label>
					<input name="complaint_target" id="complaint_target" type="hidden" class="form-control" >
					<input name="sponsorname" id="sponsorname" type="text" 
					       class="form-control assignerChoose" placeholder="【点击  选择投诉对象】  >>  " readonly="readonly" >
				</div>
				<!-- 投诉内容 -->
				<div class="form-group">
					<label class="control-label" for="participant">投诉内容&nbsp;<span style="color:red;">*</span></label>
					<textarea name="name" id="name" rows="4" style="min-height: 3em" 
					       class="form-control" placeholder="请输入投诉内容" ></textarea>
				</div>
				<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-a" style="width:100%;">
							<a href="javascript:void(0)" class="btn btn-block submitBtn" 
							    style="font-size: 16px;">
							   保存</a>
						</div>
					</fieldset>
				</div>
			</form>
		</div>
	</div>
	
		<!-- 投诉对象列表DIV -->
	  <jsp:include page="/common/systemuser.jsp">
			<jsp:param name="systemflag"  value="single"/>
			<jsp:param name="userflag"  value="all"/>
		</jsp:include>
	
	<!-- 相关数据列表 -->
	<div id="parent-more" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary parentGoBak"><i class="icon-back"></i></a>
				数据列表
		</div>
		<div class="site-recommend-list page-patch">
			<div class="list-group-item listview-item radio" style="background: #fff;">
				<!-- 字母区域 -->
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span id="fristChartsList" ></span>
				</div>
			</div>
			<div style="width:100%;text-align:center;display:none;" id="div_prev" >
				<a href="javascript:void(0)" onclick="topage('prev')">
					<img  src="<%=path%>/image/prevpage.png" width="32px" >
				</a>
			</div>
			<!-- 相关数据列表 -->
			<div class="list-group listview listview-header parentList" style="margin: 2px;margin-bottom: 30px;">
			</div>
			<div id="phonebook-btn" class="flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				<input class="btn btn-block parentbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>
			<div style="width:100%;text-align:center;display:none;" id="div_next">
					<a href="javascript:void(0)" onclick="topage('next')">
					<img  src="<%=path%>/image/nextpage.png" width="32px" >
				</a>
			</div>
		</div>
	</div>
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br><br><br><br>
</body>
</html>