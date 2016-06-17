<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String addOpptyFlag = request.getParameter("addOppty");
	String customername = request.getParameter("customername");
	customername = (null == customername ? "" : customername);
%>

<script>
	$(function() {
		if('addOppty'!='<%=addOpptyFlag%>'){
			initCustSystemForm();
			initCustSystemFriChar();
			initCustSystemData();
		}
		initCustForm();
	});

	
	var systemCustObj={};
	function initCustSystemForm(){
		systemCustObj.fstchar = $(":hidden[name=assignercustfstChar]");
		systemCustObj.currtype = $(":hidden[name=assignercustcurrType]");
		systemCustObj.currpage = $(":hidden[name=assignercustcurrPage]");
		systemCustObj.pagecount = $(":hidden[name=assignercustpageCount]");
		systemCustObj.chartlist = $(".assignercustChartList");
		systemCustObj.assignerlist = $(".assignercustList");
		systemCustObj.assignerNoData = $("#assignercustNoData");
		systemCustObj.systemdiv = $(".systemcustdiv");
	}

	//异步加载首字母
	function initCustSystemFriChar(){
		systemCustObj.chartlist.empty();
		systemCustObj.fstchar.val('');
		var type=systemCustObj.currtype.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/fchart/list',
		      data: {orgId:'${orgId}',crmId: '${crmId}',type: type},
		      dataType: 'text',
		      success: function(data){
		    	    if(!data) return;
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	systemCustObj.chartlist.html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
		    	    	systemCustObj.systemdiv.css("display","none");
		    	    	return;
	    	    	}
		    	    var ahtml = '';
		    	    $(d).each(function(i){
		    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseCustSystemFristCharts(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
		    	    });
		    	    systemCustObj.chartlist.html(ahtml);
		      }
		 });
	}

	//选择字母查询
	function chooseCustSystemFristCharts(obj){
		systemCustObj.currpage.val(1);
		systemCustObj.fstchar.val($(obj).html());
		initCustSystemData();
	}

	//异步查询责任人
	function initCustSystemData(){
		var currpage = systemCustObj.currpage.val();
		var pagecount = systemCustObj.pagecount.val();
		var firstchar = systemCustObj.fstchar.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/lovuser/userlist',
		      //async: false,
		      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    if(null==data||""==data){
		    	    	if(currpage === "1"){
		    	    		systemCustObj.assignerNoData.css("display","");
		    	    	}
		    	    	return;
		    	    }
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	if(currpage === "1"){
		    	    		systemCustObj.assignerNoData.css("display","");
		    	    		systemCustObj.chartlist.css("display",'none');
		    	    	}
		    	    	return;
		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	if(currpage === "1"){
		    	    		systemCustObj.assignerlist.html(d.errorMsg);
		    	    	}
		    	    	return;
		    	    }else{
						$(d).each(function(i){
							val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
								+  '<div class="list-group-item-bd"><input type="hidden" name="assId" value="'+this.userid+'"/>'
								+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
								+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
						});
						systemCustObj.chartlist.css("display",'');
			    	}
		    	    systemCustObj.assignerlist.html(val);
		    	    initUserCheck();
		      }
		 });
	}
	
	function valiInput(t, v) {
		if (!v.trim()) {
			$("input[name=inputMsg]").attr("placeholder", "输入的 " + t + " 不能为空");
			return false;
		}
		return true;
	}

	function initCustForm() {
		var inputMsg = $("input[name=inputMsg]"), nextStep = $(":hidden[name=nextStep]"),
		//企业名称
		addName = $(".addName"), addNameResp = $(".addNameResp"),
		//企业类型
		addAccnttype = $(".addAccnttype"), addAccnttypeResp = $(".addAccnttypeResp"),
		//企业行业
		addIndustry = $(".addIndustry"), addIndustryResp = $(".addIndustryResp"),
		//企业地址
		addStreet = $(".addStreet"), addStreetResp = $(".addStreetResp"),
		//企业电话
		addPhoneoffice = $(".addPhoneoffice"), addPhoneofficeResp = $(".addPhoneofficeResp"),
		//企业年营业额
		addAnnualrevenue = $(".addAnnualrevenue"), addAnnualrevenueResp = $(".addAnnualrevenueResp"),
		//企业网站
		addWebsite = $(".addWebsite"), addWebsiteResp = $(".addWebsiteResp"),
		//企业描述
		addDesc = $(".addDesc"),
		//regForm
		regForm = $("form[name=regForm]"), regFormName = regForm
				.find(":hidden[name=name]"), regFormAccnttype = regForm
				.find(":hidden[name=accnttype]"), regFormIndustry = regForm
				.find(":hidden[name=industry]"), regFormStreet = regForm
				.find(":hidden[name=street]"), regFormPhoneoffice = regForm
				.find(":hidden[name=phoneoffice]");
		regFormAnnualrevenue = regForm.find(":hidden[name=annualrevenue]");
		regFormWebsite = regForm.find(":hidden[name=website]");
		regTotal = $(".regTotal"), regTotalBtn = $(".regTotalBtn"),
				regInputCon = $(".regInputCon");
		$(".regInputBtn").click(function() {
			if (nextStep.val() === "企业名称") {
				var v = inputMsg.val();
				if (!valiInput("企业名称", v)) {
					return;
				}
				if(check(v)){
					return;
				}
				addNameResp.css("display", "").find(".showTxt")
						.html(v);
				regFormName.val(v);
				regInputCon.css("display", "none");
				addAccnttype.css("display", "");
			} else if (nextStep.val() === "企业地址") {
				var v = inputMsg.val();
				if (!valiInput("企业地址", v)) {
					return;
				}
				addStreetResp.css("display", "").find(
						".showTxt").html(v);
				regFormStreet.val(v);
				addPhoneoffice.css("display", "");
				inputMsg.val('')
						.attr("placeholder", "请输入 企业电话");
				nextStep.val("企业电话");

			} else if (nextStep.val() === "企业电话") {
				var v = inputMsg.val();
				if (!valiInput("企业电话", v)) {
					return;
				}
				addPhoneofficeResp.css("display", "").find(
						".showTxt").html(v);
				regFormPhoneoffice.val(v);
				addAnnualrevenue.css("display", "");
				inputMsg.val('').attr("placeholder",
						"请输入  年营业额");
				nextStep.val("年营业额");

			} else if (nextStep.val() === "年营业额") {
				var v = inputMsg.val();
				if (!valiInput("年营业额", v)) {
					return;
				}
				addAnnualrevenueResp.css("display", "").find(
						".showTxt").html(v);
				regFormAnnualrevenue.val(v);
				addWebsite.css("display", "");
				inputMsg.val('')
						.attr("placeholder", "请输入 企业官网");
				nextStep.val("企业官网");

			} else if (nextStep.val() === "企业官网") {
				var v = inputMsg.val();
				if (!valiInput("企业官网", v)) {
					return;
				}
				addWebsiteResp.css("display", "").find(
						".showTxt").html(v);
				regFormWebsite.val(v);
				$("#div_expense_message").css("display", "");
				addDesc.css("display", "");
				$(".regInputCon").css("display", "none");
				totalMsg();
			}
			scrollToButtom4Cust();
		});
			
		initUserCheck();
		
		$(".assignercustGoBak").click(function() {
			$("#customerAdd").removeClass("modal");
			$("#site-nav").removeClass("modal");
			$("#assigner-more-cust").addClass("modal");
		});

		// 责任人 的 确定按钮
		$(".assignercustbtn").click(function() {
			var assId = null;
			$(".assignercustList > a.checked").each(function() {
				assId = $(this).find(":hidden[name=assId]").val();
			});
			if(null==assId||''==assId){
				 $(".myMsgBox").css("display","").html("责任人不能为空,请选择责任人!");
				 $(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			$("form[name=regForm]").find("input[name=assignerid]").val(assId);
			commitExamBef();
		});
		
	}
	
	function initUserCheck(){
		//勾选某个 责任人 的超链接
		$(".assignercustList > a").click(function(){
			$(".assignercustList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
	}
     
	//检查是否有重名的情况
	function check(name){
		var flag=false;
		$.ajax({
			type: 'get',
		      url: '<%=path%>/checkName/check',
		      //async: false,
		      data: {
		    	    orgId:'${orgId}',
		    	    type:'accnt',
		    	    name:name
		      },
		      dataType: 'text',
		      success: function(data){
		    	  var d = JSON.parse(data);
		    	  if(d.errorCode && "0"!=d.errorCode){
		    		  $("input[name=inputMsg]").val('');
		    		  $(".myMsgBox").css("display","").html("操作失败！"+ "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
					  $(".myMsgBox").delay(2000).fadeOut();
		    		  flag=true;
		    	  }
		      }
		});
		return flag;
	}
	
	function valiInput(t, v){
		if(!v.trim()){
			$("input[name=inputMsg]").val("").attr("placeholder","输入的 "+ t + " 不能为空");
			return false;
		}
// 		if(t === "企业电话"){
// 			 var exp = /^\d{11,12}$/;
// 			 var r = exp.test(v);
// 			 if(!r){
// 				 $("input[name=inputMsg]").val('').attr("placeholder","输入的 "+ t + " 不合法,请重新输入");
// 				 return false;
// 			 }
// 		}
// 		if(t === "年营业额"){
// 			 var exp = /^\d{1,20}$/;
// 			 var r = exp.test(v);
// 			 if(!r){
// 				 $("input[name=inputMsg]").val('').attr("placeholder","输入的 "+ t + " 不合法,请重新输入");
// 				 return false;
// 			 }
// 		}
		return true;
	}
	
	//汇总信息
	function totalMsg() {
		//regForm
		var regForm = $("form[name=regForm]"), regFormName = regForm
				.find(":hidden[name=name]"), regFormAccnttype = regForm
				.find(":hidden[name=accnttypename]"), regFormIndustry = regForm
				.find(":hidden[name=industryname]"), regFormStreet = regForm
				.find(":hidden[name=street]"), regFormPhoneoffice = regForm
				.find(":hidden[name=phoneoffice]"), regFormAnnualrevenue = regForm
				.find(":hidden[name=annualrevenue]"), regFormWebsite = regForm
				.find(":hidden[name=website]"), regTotal = $(".regTotal");

		var tmp = [
				'<h1>您输入的信息汇总如下所示:</h1></br>',
				'企业名称: <span style="color: blue;">' + regFormName.val()
						+ '</span><br>',
				'企业类型: <span style="color: blue;">' + regFormAccnttype.val()
						+ '</span><br>',
				'企业行业: <span style="color: blue;">' + regFormIndustry.val()
						+ '</span><br>'
// 				,'企业地址: <span style="color: blue;">' + regFormStreet.val()
// 						+ '</span><br>',
// 				'企业电话: <span style="color: blue;">' + regFormPhoneoffice.val()
// 						+ '</span><br>',
// 				'年营业额: <span style="color: blue;">'
// 						+ regFormAnnualrevenue.val() + '</span><br>',
// 				'企业官网: <span style="color: blue;">' + regFormWebsite.val()
// 						+ '</span><br><br>'
					];
		regTotal.html(tmp.join(""));
	}

	//滚动到底部
	function scrollToButtom4Cust(obj) {
		if (obj) {
			var y = $(obj).offset().top;
			if (!y)
				y = 0;
			window.scrollTo(100, y);
		} else {
			window.scrollTo(100, 99999);
		}

		return false;
	}

	//选择客户类型
	function selectAccentType(obj, stage) {
		var search_div = $("#search_div");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		var name = search_div.find("a.selected").html();
		$("form[name=regForm]").find("input[name=accnttype]").val(stage);
		$("form[name=regForm]").find("input[name=accnttypename]").val(name);
		if (stage) {
			$(".addAccnttypeResp").css("display", "");
			$("#addAccnttypeResp").html(name);
			$(".addIndustry").css("display", "");
		}
		totalMsg();
	}

	//选择行业
	function selectIndustry(obj, stage) {
		var search_div = $("#search_div_indu");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		var name = search_div.find("a.selected").html();
		$("form[name=regForm]").find("input[name=industry]").val(stage);
		$("form[name=regForm]").find("input[name=industryname]").val(name);
		if (stage) {
			$(".addIndustryResp").css("display", "");
			$("#search_div_induresp").html(name);
			
			//直接显示汇总信息
			$("#div_expense_message").css("display", "");
			$(".addDesc").css("display", "");
			$(".regInputCon").css("display", "none");
			totalMsg();
			//暂时不往下走,直接跳转到最后一步
// 			$(":hidden[name=nextStep]").val("企业地址");
// 			$(".addStreet").css("display", "");
// 			$(".regInputCon").css("display", "");
// 			$("input[name=inputMsg]").val("");
// 			$("input[name=inputMsg]").attr("placeholder", "请输入企业地址");
		}
	}
	
	//分配给他人
	function addAmtSubType() {
		$("#customerAdd").addClass("modal");
		$("#userRegister").find("#site-nav").addClass("modal");
		$("#assigner-more-cust").removeClass("modal");
	}

	//分配给自己
	function commitExamBef() {
		$("form[name=regForm]").find("input[name=desc]").val($("#expense_description").val());
		$("form[name=regForm]").find("input[name=orgId]").val('${orgId}');
		$("form[name=regForm]").submit();
	}
	
	function initCustPage(){
		var form = $("#regForm");
		form.find("input").each(function(){
			var n = $(this).attr("name");
			if(n != "assignerid" && n != "crmId"){
				$(this).val('');
			}			
		});
		
		$(".addName").css("display","none");
		$(".addNameResp").css("display","none");
		$(".addNameResp").find(".showTxt").empty();
		
		$(".addIndustry").css("display","none");
		$(".addIndustryResp").css("display","none");
		$(".addIndustryResp").find(".showTxt").empty();
		
		$(".addAccnttype").css("display","none");
		$(".addAccnttypeResp").css("display","none");
		$(".addAccnttypeResp").find(".showTxt").empty();
		
		$(".addPhoneoffice").css("display","none");
		$(".addPhoneofficeResp").css("display","none");
		$(".addPhoneofficeResp").find(".showTxt").empty();
		
		$(".addStreet").css("display","none");
		$(".addStreetResp").css("display","none");
		$(".addStreetResp").find(".showTxt").empty();
		
		$(".addAnnualrevenue").css("display","none");
		$(".addAnnualrevenueResp").css("display","none");
		$(".addAnnualrevenueResp").find(".showTxt").empty();
		
		$(".addWebsite").css("display","none");
		$(".addWebsiteResp").css("display","none");
		$(".addWebsiteResp").find(".showTxt").empty();
		
		$("#div_expense_message").css("display","none");
		$("#div_expense_message").find(".regTotal").empty();
		
		$(".addDesc ").css("display","none");
		$(".addDesc ").find(".expense_description").empty();
		$("input[name=inputMsg]").val('<%=customername%>');
	}
	
	function clear(){
		var form = $("#regForm");
		form.find("input").each(function(){
			var n = $(this).attr("name");
			if(n != "assignerid" && n != "crmId"){
				$(this).val('');
			}			
		});
		
		$(".addNameResp").css("display","none");
		$(".addNameResp").find(".showTxt").empty();
		
		$(".addIndustry").css("display","none");
		$(".addIndustryResp").css("display","none");
		$(".addIndustryResp").find(".showTxt").empty();
		
		$(".addAccnttype").css("display","none");
		$(".addAccnttypeResp").css("display","none");
		$(".addAccnttypeResp").find(".showTxt").empty();
		
		$(".addPhoneoffice").css("display","none");
		$(".addPhoneofficeResp").css("display","none");
		$(".addPhoneofficeResp").find(".showTxt").empty();
		
		$(".addStreet").css("display","none");
		$(".addStreetResp").css("display","none");
		$(".addStreetResp").find(".showTxt").empty();
		
		$(".addAnnualrevenue").css("display","none");
		$(".addAnnualrevenueResp").css("display","none");
		$(".addAnnualrevenueResp").find(".showTxt").empty();
		
		$(".addWebsite").css("display","none");
		$(".addWebsiteResp").css("display","none");
		$(".addWebsiteResp").find(".showTxt").empty();
		
		$("#div_expense_message").css("display","none");
		$("#div_expense_message").find(".regTotal").empty();
		
		$(".addDesc ").css("display","none");
		$(".addDesc ").find(".expense_description").empty();
		
		$("input[name=inputMsg]").val('<%=customername%>');
	}
</script>

	<div id="customerAdd">
		<!-- 用户注册流程内容 -->
		<div class="site-card-view bxFlowContent">
			<!-- 提交用户注册数据的表单 -->
			<form id="regForm" name="regForm" action="<%=path%>/customer/save?module=${module}&opptyid=${opptyid}" method="post">
				<input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="name" value="" />
			    <input type="hidden" name="accnttype" value="" />
			    <input type="hidden" name="industry" value="" /> 
			    <input type="hidden" name="street" value="" />
			    <input type="hidden" name="phoneoffice" value="" /> 
				<input type="hidden" name="annualrevenue" value="" />
				<input type="hidden" name="website" value="" /> 
				<input type="hidden" name="accnttypename" value="" /> 
				<input type="hidden" name="industryname" value="" /> 
				<input type="hidden" name="assignerid" value="${assignerid}" />
				<input type="hidden" name="desc" value="" />
				<input type="hidden" name="parentid" value="${parentid}" />
				<input type="hidden" name="parenttype" value="${parentType}" />
				<input type="hidden" name="campaigns" value="${campaigns}" />
				<input type="hidden" name="orgId" value="" />
			</form>
		</div>


		<!-- 企业名称 -->
		<div class="chatItem you addName" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入企业名称?【1/3】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>


		<!-- 企业名称回复 -->
		<div class="chatItem me addNameResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业类型 -->
		<div class="chatItem you addAccnttype"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请选择企业类型?【2/3】</div>
									<div id="search_div">
										<c:forEach items="${accnttypedom}" var="item">
											<a href="javascript:void(0)"
												onclick="selectAccentType(this,'${item.key}')">${item.value}</a>
										</c:forEach>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业类型回复 -->
		<div class="chatItem me addAccnttypeResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="addAccnttypeResp" class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业行业 -->
		<div class="chatItem you addIndustry"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请选择企业行业?【3/3】</div>
									<div id="search_div_indu">
										<c:forEach items="${industrydom}" var="item">
											<a href="javascript:void(0)"
												onclick="selectIndustry(this,'${item.key}')">${item.value}</a>
										</c:forEach>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业行业回复 -->
		<div class="chatItem me addIndustryResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="search_div_induresp" class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业地址？ -->
		<div class="chatItem you addStreet"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入公司具体地址?【4/7】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业地址回复 -->
		<div class="chatItem me addStreetResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业电话？ -->
		<div class="chatItem you addPhoneoffice "
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入公司电话?【5/7】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业电话回复 -->
		<div class="chatItem me addPhoneofficeResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业营业额？ -->
		<div class="chatItem you addAnnualrevenue "
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入公司的年营业额?【6/7】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业营业额回复 -->
		<div class="chatItem me addAnnualrevenueResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业官网？ -->
		<div class="chatItem you addWebsite"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入企业的官网?【7/7】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 企业官网回复 -->
		<div class="chatItem me addWebsiteResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 汇总 -->
		<div id="div_expense_message" class="chatItem you"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div class="regTotal"
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 客户描述 -->
		<div class="addDesc"
			style="display: none; margin-top: 5px; text-align: center;">
			<div style="width: 96%; margin: 10px;">
				<textarea name="expense_description" id="expense_description"
					style="width: 100%" rows="3" placeholder="补充说明，可选"
					class="form-control"></textarea>
			</div>
			<div style="width: 100%;"></div>
			<div class="button-ctrl custsubmit">
				<fieldset class="">
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="addAmtSubType()"
							class="btn btn-block addExpType"
							style="font-size: 16px; margin-left: 10px; margin-right: 10px;">
							分&nbsp;配&nbsp;他&nbsp;人</a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="commitExamBef()"
							class="btn btn-block "
							style="font-size: 16px; margin-left: 10px; margin-right: 10px;">自&nbsp;已&nbsp;跟&nbsp;进</a>
					</div>
				</fieldset>
			</div>
			
			<div class="button-ctrl custsubmitinclude" style="display:none">
				<fieldset class="">
						<a href="javascript:void(0)" onclick="confirmCustform()" class="btn btn-block " 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">确定</a>
					
				</fieldset>
			</div>
		</div>

	<!-- 输入框 信息 -->
	<div id=""
		style="background-color: #e2e3e5; border-top: 1px solid #777575;"
		class="regInputCon flooter">
		<div
			style="width: 100%; margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
			<input type="hidden" name="nextStep" value="企业名称" /> <input
				name="inputMsg" style="border: 1px solid #949494; width: 100%" maxlength="30" value=""
				type="text" class="form-control" placeholder="请输入企业名称">
		</div>
		<div
			style="width: 80px; float: right; margin: -47px 8px 5px 5px;text-align:center">
			<a href="javascript:void(0)" onclick=""
				class="btn btn-block regInputBtn" style="font-size: 14px;">确定</a>
		</div>
	</div>
</div>

	<!-- 责任人列表DIV -->
	<div id="assigner-more-cust" class=" modal">
		<div id="" class="navbar">
			<a href="#" onclick="javascript:void(0)"
				class="act-primary assignercustGoBak"><i class="icon-back"></i></a>
			责任人列表
		</div>
		<input type="hidden" name="assignercustfstChar" />
	    <input type="hidden" name="assignercustcurrType" value="userList" />
	    <input type="hidden" name="assignercustcurrPage" value="1" />
	    <input type="hidden" name="assignercustpageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignercustChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="list-group listview listview-header assignercustList"
			style="margin: 0px;">
			<div id="assignercustNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		</div>
		<div id="phonebook-btn systemcustdiv" class="flooter"
			style="font-size: 14px; background: #F7F7F7; border-top: 1px solid #ADA7A7; padding-top: 4px;padding-right:20px;">
			<a class="btn btn-block assignercustbtn"
				style="width: 100%; margin: 3px 0px 3px 8px;">确&nbsp定</a>
		</div>
	</div>
	
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	