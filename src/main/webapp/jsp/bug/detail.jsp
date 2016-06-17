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
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	
	<!-- 日历控件 -->
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
	
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
  <script type="text/javascript">
    $(function () {
    	initMsgVar();
    	
    	//完成状态 控制现实区域
    	var compStatus = '${sd.status}';
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initButton();
    	initDatePicker();
    	
    	initScheduleForm();
    	initTeamCon();//团队成员
    	renderTeamImgHead();//显示图片头像
    	renderTeamPerm();//初始化团队的权限
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
    
    //初始化日期控件 
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date'},
    		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
    		time : {preset : 'time'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	
    }
  
    
    function initScheduleForm(){
    	//参与人选择事件
		$(".participantChoose").click(function(){
			$("#task-create").addClass("modal");
			$("#participant-more").removeClass("modal");
		});
    	
    	//默认设置结束时间 
    	
	 	//相关值选择事件
		relaModule();
	 	
	    //联系人选择事件
		$(".contactChoose").click(function(){
			$("#task-create").addClass("modal");
			$("#contact-more").removeClass("modal");
			var parentId = $("input[name=parentId]").val();
			var parenttype = $("select[name=relamoduleSel]").val() ;
			if(parentId==''||parenttype==''){
				$("#task-create").removeClass("modal");
				$("#contact-more").addClass("modal");
				$(".myMsgBox").css("display","").html("请选择相关值!");
			    $(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			$.ajax({
			      type: 'get',
			      url: '<%=path%>/contact/rela',
			      //async: false,
			      data: {parentType:parenttype,parentId:parentId,openId:'${openId}',publicId:'${publicId}'},
			      dataType: 'text',
			      success: function(data){
			    	    if(!data){
			    	    	$(".contactList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
			    	    	return;
			    	    }
			    	    var d = JSON.parse(data);
			    	    if(d.errorCode && d.errorCode !== '0'){
			    	    	   $(".contactList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">操作失败!错误编码:' + d.errorCode + "错误描述:" + d.errorMsg+'</div>');
			    	    	   return;
			    	    }
			    	    var val = "";
			    		$(d).each(function(i){
							val += '<a href="javascript:void(0)" onclick="selectContact(this)" class="list-group-item listview-item radio">'
								+ '<div class="list-group-item-bd">'
								+ '<input type="hidden" name="partId" value="'+this.rowid+'"/>'
								+ '<input type="hidden" name="partName" value="'+this.conname+'"/>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.conname+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
								+ this.salutation+'</span></h1><p>'
								+ this.conjob+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+this.phonemobile+'</p></div></div> '
								+ '<div class="input-radio" title="选择该条记录"></div>'
								+ '</a>';
						});
			    		$(".contactdiv").css("display","");
			    		$(".contactList").html(val);
			      }
		    });
		});
		//相关退回
		$(".parentGoBak").click(function(){
			$("#task-create").removeClass("modal");
			$("#parent-more").addClass("modal");
		});
		
		//参与人退回
		$(".participantGoBak").click(function(){
			$("#task-create").removeClass("modal");
			$("#participant-more").addClass("modal");
		});
		//联系人退回
		$(".contactGoBak").click(function(){
			$("#task-create").removeClass("modal");
			$("#contact-more").addClass("modal");
		});
	
		//勾选参与人 的超链接
		$(".participantList > a").click(function(){
			$(this).addClass("checked");
			//开始遍历
			var pIds = "", pNames = "";
			$(".participantList > a.checked").each(function(){
				pIds += $(this).find(":hidden[name=partId]").val() + ",";
				pNames += $(this).find(".partName").html() + ",";
			});
			$(":hidden[name=participantId]").val(pIds);
			$("input[name=participantName]").val(pNames);
		});
		
		//参与人 的 确定按钮
		$(".participantbtn").click(function(){
			$(".participantGoBak").trigger("click");
		});
		// 客户  的 确定按钮
		$(".parentbtn").click(function(){
			var v =  $("select[name=relamoduleSel]").val();//$(":hidden[name=relaname]").val(); // $("select[name=parentType]").val();
			var tmpId = $("input[name=parentId]").val();
			var parentId, parentName;
			if(v === "Accounts"){
				$(".customerList > a.checked").each(function(){
					parentId = $(this).find(":hidden[name=customerId]").val();
					parentName = $(this).find(":hidden[name=customerName]").val();
				});
			}
			if(v === "Opportunities"){
				$(".opptyListSub > a.checked").each(function(){
					parentId = $(this).find(":hidden[name=opptyId]").val();
					parentName = $(this).find(":hidden[name=opptyName]").val();
				});
			}
			if(v === "Project"){
				$(".projectList").find("a.checked").each(function(){
					parentId = $(this).find(":hidden[name=proId]").val();
					parentName = $(this).find(":hidden[name=proName]").val();
				});
			}
			$("input[name=parentId]").val(parentId);
			$("input[name=parentName]").val(parentName);
			if(tmpId != parentId){
				//联系人清空
				$("input[name=contactId]").val('');
				$("input[name=phonemobile]").val('');
			}
			$(".parentGoBak").trigger("click");
		});
		//联系人 的超链接
		$(".contactList > a").click(function(){
		
			$(".contactList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
		//联系人 的 确定按钮
		$(".contactbtn").click(function(){
			var pIds = "", pNames = "";
			$(".contactList > a.checked").each(function(){
				pIds = $(this).find(":hidden[name=partId]").val();
				pNames = $(this).find(":hidden[name=partName]").val();
			});
			$("input[name=contactId]").val(pIds);
			$("input[name=phonemobile]").val(pNames);
			$(".contactGoBak").trigger("click");
		});
		opptyListSubSel();
		customerListSel()
		projectListSel();

		//发送消息
    	p.examinerSend.click(function(){
    		sendMessage();
    	});
		
		/*
    	//文本输入框点击事件
    	p.inputTxt.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
    		var v = $(this).val();
    		
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    	});
		*/
		
   }
    
   var p = {};
    
   function initMsgVar(){
	    p.msgCon = $(".msgContainer");
   	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
   	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
  	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
  	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
  	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
  	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
  	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
  	    
  	    p.nativeDiv = $("#site-nav");
        p.scheduleDetailDiv = $("#scheduleDetail");
        p.scheduleDetailFormDiv = p.scheduleDetailDiv.find(".scheduleDetailForm");
   }
   
   //获取 获取团队成员
   function getTeamLeas(){
	   	var tArr = [];
	   	$(".teamCon > div.teamPeason").each(function(){
	   		var uid = $(this).find(":hidden[name=assId]").val();
	   		var uname = $(this).find(":hidden[name=assName]").val();
	   		tArr.push({uid:uid, uname:uname});
	   	});
	   	return tArr;
   }
   
   //勾选某个 业务机会  的超链接
   //选择.opptyListSyb下属的a节点
   function opptyListSubSel(){
		$(".opptyListSub > a").click(function(){
			$(".opptyListSub > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
   }
	  
	  //相关值修改
	  function relaModule(){
		  $(".parentChoose").click(function(){
				$("#task-create").addClass("modal");
				$("#parent-more").removeClass("modal");
				var v = $("select[name=relamoduleSel]").val();
				if(v === "Accounts"){
					$(".customerList").removeClass("modal");
					$(".opptyList").addClass("modal");
					$(".projectList").addClass("modal");
				}else if(v === "Opportunities"){
					$(".customerList").addClass("modal");
					$(".opptyList").removeClass("modal");
					$(".projectList").addClass("modal");
				}else if(v === "Project"){
					$(".customerList").addClass("modal");
					$(".opptyList").addClass("modal");
					$(".projectList").removeClass("modal");
				}
				//查询首字母事件
				var v = $("select[name=relamoduleSel]").val();
				var type="";
		    	if("Accounts"===v){
		    		type="accntList";
		    	}else if("Opportunities"===v){
		    		type="opptyList";
		    	}else if("Project"===v){
		    		type="projectList";
		    	}
		    	searchFristCharts(type);
			});
	 }
	  
    //勾选某个 客户 的超链接
	function customerListSel(){
		$(".customerList > a").click(function(){
			$(".customerList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
    }
    
    //勾选某个项目的超链接
	function projectListSel(){
		$(".projectList > a").click(function(){
			$(".projectList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
    }
    
    //初始化按钮
    function initButton(){
		 //是否显示修改按钮
	   	 var assignerid = '${sd.assignerid}';
	   	 if('${crmId}'==assignerid){
	   		$("#update").css("display","");
	   	 }else{
	   		//$(".msgdiv").css({"margin-left":"40px","padding-right":"120px"});
	   	 }
		//修改按钮
   	    $(".operbtn").click(function(){
	   		$("#update").css("display","none");
	   		$(".nextCommitExamDiv").css("display","");
	   		$(".upShow").css("display","none");
	   	    $(".uptInput").css("display","");
	   	 	$("#navTitle").html("缺陷修改");
	   	    
	   	});
    	//取消按钮
    	$(".canbtn").click(function(){
    		$("#update").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$(".upShow").css("display","");
    		$(".uptInput").css("display","none");
    	});
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		$(":hidden[name=log]").val($("#log").val());
    		//status
    		var obj = $("select[name=statusSel]");
   	   	 	var v = obj.val();
   	   		$(":hidden[name=status]").val(v);
   	   		//driority
   	   		obj = $("select[name=analyzeSel]");
   	   	 	v = obj.val();
   	   		$(":hidden[name=analyze]").val(v);
    		//relamodul   	
    		$("form[name=bugDetail]").submit();
    	});
    }
    
    // 修改状态
    function updateStatus(){
    	var obj = $("select[name=statusSel]");
		var v = obj.val();
		$(":hidden[name=statusname]").val(v);
    }
    
    //修改优先级
    function updateDriority(){
    	 var obj = $("select[name=drioritySel]");
    	 var v = obj.val();
    	 $(":hidden[name=driorityname]").val(v);
    }
    //修改分析
    function updateAnalyze(){
    	 var obj = $("select[name=analyzeSel]");
    	 var v = obj.val();
    	 $(":hidden[name=analyzename]").val(v);
    }
    //修改相关
    function updateRelamodule(){
    	var obj = $("select[name=relamoduleSel]");
    	var v = obj.val();
    	$(":hidden[name=relaname]").val(v);
    	$("input[name=parentId]").val('');
    	$("input[name=parentName]").val('');
    	$("input[name=currpage]").val(1);
    	$("#div_prev").css("display","none");
    	$("#div_next").css("display","none");
    	$(":hidden[name=firstchar]").val("");
    }
    //修改周期
    function updateCycli(){
    	var obj = $("select[name=cycliSel]");
    	var objCheck = $("select[name=cycliSel] option:checked");
    	var v = obj.val();
    	$(":hidden[name=cycliKey]").val(v);
    	$(":hidden[name=cycliValue]").val(objCheck.html());
    }
    //修改参与人
    function upContact(){
	     var obj = $("select[name=participantSel]");
	   	 var v = obj.val();
	   	 $(":hidden[name=participantname]").val(v);
    }
  /*   //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    function selectContact(obj){
    	$(".contactList > a").removeClass("checked");
		if($(obj).hasClass("checked")){
			$(obj).removeClass("checked");
		}else{
			$(obj).addClass("checked");
		}
    }
    
    //查询模块的首字母
    function searchFristCharts(type){
    	$.ajax({
	  	      type: 'get',
	  	      url: '<%=path%>/fchart/list',
	  	      data: {crmId: '${crmId}',type: type},
	  	      dataType: 'text',
	  	      success: function(data){
	  	    	    if(!data) return;
	  	    	    var d = JSON.parse(data);
	  	    	    if(d.errorCode && d.errorCode !== '0'){
	  	    	  		$("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
			    	    return;
			    	}
	  	    	    var ahtml = '';
	  	    	    $(d).each(function(i){
	  	    	    	ahtml += '<a href="javascript:void(0)" style="margin: 0px 12px 0px 12px;" onclick="chooseFristCharts(this)">'+ this +'</a>';
	  	    	    });
	  	    	    $("#fristChartsList").html(ahtml);
	  	    	    scheduleReleation(type,null);
	  	      }
    	 });
    }

    //点击首字母事件
    function chooseFristCharts(obj){
    	$(":hidden[name=firstchar]").val($(obj).html());
    	var v = $("select[name=relamoduleSel]").val();
    	if(v == "Accounts"){
    		$("input[name=currpage]").val(1);
    		scheduleReleation("accntList","CHAR");
    	}else if(v == "Opportunities"){
    		$("input[name=currpage]").val(1);
    		scheduleReleation("opptyList","CHAR");
    	}else if(v == "Project"){
    		$("input[name=currpage]").val(1);
    		scheduleReleation("projectList","CHAR");
    	}
    }
    
  	//相关
    function scheduleReleation(type,oper){
    	var currpage = $("input[name=currpage]").val();
    	if(currpage == 1){
    		$("#div_prev").css("display",'none');
    	}else{
    		$("#div_prev").css("display",'');
    	}
    	var pagecount = $("input[name=pagecount]").val();
    	var firstchar = $("input[name=firstchar]").val();
    	if(type == "opptyList"){
    		var parenttype = "Opportunities";
    		$.ajax({
    		      type: 'get',
    		      url: '<%=path%>/oppty/list' || '',
    		      //async: false,
    		      data: {crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
    		      dataType: 'text',
    		      success: function(data){
    		    	    var val = '';
    		    	    var d = JSON.parse(data);
    					if(d == ""){
    		    	    	val = "没有找到数据";
    		    	    	$("#div_next").css("display",'none');
    		    	    	$(".opptyList").empty();
    		    	    }else{
    		    	    		if($(d).size() == pagecount){
    		    	    			$("#div_next").css("display",'');
    		    	    		}else{
    		    	    			$("#div_next").css("display",'none');
    		    	    		}
    							$(d).each(function(i){
    								val +='<a href="javascript:void(0)"class="list-group-item listview-item radio">'
    									+'<div class="list-group-item-bd"> <div class="thumb list-icon"><b>'+this.probability+'%</b></div>'
    									+'<div class="content"> <input type="hidden" name="opptyId" value="'+this.rowid+'"/>'
    							        +'<input type="hidden" name="opptyName" value="'+this.name+'"/><h1>'+this.name+'&nbsp;<span'
    									+'style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1><p class="text-default">'
    									+'预期:￥'+this.amount+'&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:'+this.salesstage+'</p>'
    									+'<p>关闭日期:'+this.dateclosed+'&nbsp;&nbsp;&nbsp;&nbsp;跟进天数:'+this.createdate+'</p>'
    									+'</div></div><div class="input-radio" title="选择该条记录"></div></a>';
    							});
    							$("#fristChartsList").css("display",'');
    		    	    }
    					$(".opptyListSub").html(val);
    					opptyListSubSel();
    		      }
    		 });
    		
    	}else if(type == "accntList"){
	    		var parenttype = "Accounts";
	    		$.ajax({
	  		      type: 'get',
	  		      url: '<%=path%>/customer/list' || '',
	  		      //async: false,
	  		      data: {crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
	  		      dataType: 'text',
	  		      success: function(data){
		  		    	    var val = '';
		  		    	    var d = JSON.parse(data);
		  					if(d == ""){
		  		    	    	val = "没有找到数据";
		  		    	    	$("#div_next").css("display",'none');
		  		    	    	$(".customerList").empty();
		  		    	    }else if(d.errorCode && d.errorCode != '0'){
		  		    	    	$("#div_next").css("display",'none');
				    	    	$(".customerList").html("没有找到数据");//d.errorMsg
				    	    	return;
				    	    }else{
		  		    	    		if($(d).size() == pagecount){
		  		    	    			$("#div_next").css("display",'');
		  		    	    		}else{
		  		    	    			$("#div_next").css("display",'none');
		  		    	    		}
		  							$(d).each(function(i){
		  								val += '<a href="javascript:void(0)"class="list-group-item listview-item radio"'
		  									+'style="border-left: 4px solid #F9FDFF;"><div class="list-group-item-bd">'
		  									+'<input type="hidden" name="customerId" value="'+this.rowid+'"/>'
		  									+'<input type="hidden" name="customerName" value="'+this.name+'"/>'
		  									+'<h2 class="title">'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
		  									+this.assigner+'</span></h2><p style="margin-left:1.5em;"></p></div>' 
		  									+'<div class="input-radio" title="选择该条记录"></div></a>';
		  							});
		  							$("#fristChartsList").css("display",'');
		  		    	    }
		  					$(".customerList").html(val);
		  					customerListSel();
		  		      }
		  		 });
    	}else if(type == "projectList"){
    		var parenttype = "Project";
    		$.ajax({
  		      type: 'get',
  		      url: '<%=path%>/project/asyList',
  		      //async: false,
  		      data: {crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
  		      dataType: 'text',
  		      success: function(data){
  		    	    var val = '';
  		    	    var d = JSON.parse(data);
  					if(d == ""){
  		    	    	val = "没有找到数据";
  		    	    	$("#div_next").css("display",'none');
  		    	    	$(".projectList").empty().html('<div class="list-group listview "><div style="margin-top:40px;text-align:center">'+ val +'</div></div>');
  		    	    	return;
  		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	$(".projectList").html(d.errorMsg);
		    	    	return;
		    	    }else{
  		    	    		if($(d).size() == pagecount){
  		    	    			$("#div_next").css("display",'');
  		    	    		}else{
  		    	    			$("#div_next").css("display",'none');
  		    	    		}
  							$(d).each(function(i){
			  					var vtmp =  ['<a href="javascript:void(0)" ',
			  									'class="list-group-item listview-item radio" style="border-left: 4px solid #F9FDFF;">',
			  									'<div class="list-group-item-bd">',
			  										'<div class="content">',
			  										    '<input type="hidden" name="proId" value="'+ this.rowid +'"/>',
			  								            '<input type="hidden" name="proName" value="'+ this.name +'"/> ',       
			  											'<h1>'+ this.name +'&nbsp;</span></h1>',
			  											'<p>开始日期:'+ this.startdate,
			  											'&nbsp;&nbsp;&nbsp;&nbsp;</p>',
			  											'<p>结束日期:' + this.enddate,
			  											'&nbsp;&nbsp;&nbsp;&nbsp;</p>',
			  										'</div>',
			  									'</div>',
			  									'<div class="input-radio" title="选择该条记录"></div>',
			  								'</a>'];
			  					
			  					val += vtmp.join("");
		  					
  							});
  							$("#fristChartsList").css("display",'');
  		    	    }
  					$(".projectList div").eq(0).html(val);
  					projectListSel();
  		      }
  		 });
    	}
  	}
  	
  	//翻页
    function topage(type){
    	var parenttype = $("select[name=relamoduleSel]").val();
    	var currpage = $("input[name=currpage]").val();
    	if(type == "prev"){
    		$("input[name=currpage]").val(parseInt(currpage) - 1);
    	}else if(type == "next"){
    		$("input[name=currpage]").val(parseInt(currpage) + 1);
    	}
    	if(parenttype == "Accounts"){
    		scheduleReleation("accntList","XXX");
    	}else if(parenttype == "Opportunities"){
    		scheduleReleation("opptyList","XXX");
    	}else if(parenttype == "Project"){
    		scheduleReleation("projectList","XXX");
    	}
    }
    
    var p = {};
    //初始化团队容器对象
    function initTeamCon(){
    	p.teamCon = $(".teamCon");
    	p.teamTitle = $(".teamTitle");
    	p.teamPeason = p.teamCon.find(".teamPeason");
    	p.teamAdd = p.teamCon.find(".teamAdd");
    	p.teamSub = p.teamCon.find(".teamSub");
   	    //分享区域
   	    p.taskCreateCon =$("#task-create");
   	    p.shareUserCon = $("#shareuser-more");
   	    p.shareUserList = p.shareUserCon.find(".shareUserList");
   	    
   	    p.shareUserFstChar = p.shareUserCon.find(":hidden[name=fstChar]");
        p.shareUserCurrType = p.shareUserCon.find(":hidden[name=currType]");
 	    p.shareUserCurrPage = p.shareUserCon.find(":hidden[name=currPage]");
 	    p.shareUserPageCount = p.shareUserCon.find(":hidden[name=pageCount]");
 	    p.shareUserChartList = p.shareUserCon.find(".chartList");
   	    
   	    p.shareBtn = p.shareUserCon.find(".shareuserbtn");
   	    p.shareUserGoBak = p.shareUserCon.find(".shareuserGoBak");
   	    
	   	p.shareusertab = p.shareUserCon.find(".shareusertab");
	    p.followUserList = p.shareUserCon.find(".followUserList");
	    p.followuserbtn = p.shareUserCon.find(".followuserbtn");
	    p.followform = $("form[name=followform]");
	    p.followuserid = p.followform.find(":hidden[name=openId]");
	    p.follownickname = p.followform.find(":hidden[name=nickName]");
	    p.followrelaid = p.followform.find(":hidden[name=relaId]");

   	    initTeamBtn();
   	    initTeamShareBtn();
   	    initTeamDelBtn();
    }
    
    function initTeamBtn(){
    	//添加成员
    	p.teamAdd.click(function(){
    		p.shareUserCon.removeClass("modal");
    		p.taskCreateCon.addClass("modal");
    		p.shareUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}
			});
			p.followUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}
			});
    		p.shareUserFstChar.val('');
    		initShareUserData();
    		renderAttenUser();//渲染关注用户
    		window.scrollTo(100, 0);//滚动到顶部
    	});
    	
    	//删除成员
    	p.teamSub.click(function(){
    		var f = p.teamSub.attr("flag");
    		if(f === "true"){
    			p.teamSub.attr("flag", "false");
    			//遍历团队成员 出现删除按钮
        		p.teamCon.find(".delImg").css("display", "none");
    		}else{
    			p.teamSub.attr("flag", "true");
    			//遍历团队成员 出现删除按钮
        		p.teamCon.find(".delImg").css("display", "");
        		initTeamDelBtn();
    		}
    	});
    }
    
    function initTeamDelBtn(){
    	//删除按钮 点击事件
    	p.teamCon.find(".delImg").unbind("click").click(function(){
    		var assId = $(this).parent().parent().find(":hidden[name=assId]").val();
    		var assName = $(this).parent().parent().find(":hidden[name=assName]").val();
    		var type = $(this).parent().parent().find(":hidden[name=type]").val();
    		if(type === "sysuser"){
    			//数组对象
        		var dataObj = [], dataObjSec = [];
        	    	dataObj.push({name:'openId', value: '${openId}'});
        	    	dataObj.push({name:'publicId', value: '${publicId}'});
        	    	dataObj.push({name:'parentid', value: '${rowId}' });
        	    	dataObj.push({name:'parenttype', value: 'Bugs' });
    	        	dataObj.push({name:'type', value: 'cancel' });
    	        	dataObj.push({name:'shareuserid', value: assId });
    				dataObj.push({name:'shareusername', value: assName });
    				
    	    	//调用后台接口 发送 团队成员数据
    			renderTeamPeason(dataObj, []);
    		}else if(type === "attenuser"){
    			$("form[name=followform]").find(":hidden[name=openId]").val(assId);
    			delFollowUser();
    		}
	    	//删除节点
			$(this).parent().parent().remove();
		});
    }
    
    function initTeamShareBtn(){
    	//分享按钮 点击确定触发的事件
    	p.shareBtn.click(function(){
        	//数组对象
    		var dataObj = [], dataObjSec = [];
    	    	dataObj.push({name:'openId', value: '${openId}'});
    	    	dataObj.push({name:'publicId', value: '${publicId}'});
    	    	dataObj.push({name:'parentid', value: '${rowId}' });
    	    	dataObj.push({name:'parenttype', value: 'Bugs' });
    			dataObj.push({name:'type', value: 'share' });
    			dataObj.push({name:'crmname', value: '${assigner}' });
    			dataObj.push({name:'projname', value: '${sd.title}' });
			//遍历选择的人
	        p.shareUserList.find("a.checked").each(function(){
    			var assId = $(this).find(":hidden[name=assId]").val();
    			var assName = $(this).find(":hidden[name=assName]").val();
	    			dataObj.push({name:'shareuserid', value: assId });
	    			dataObj.push({name:'shareusername', value: assName });
	    			if(teamUniqJudge(assId)){
	    				dataObjSec.push({id: assId, name: assName, type: 'sysuser'});
	    			}
    		});
        	//调用后台接口 发送 团队成员数据
    		renderTeamPeason(dataObj, dataObjSec);
    		//回退
    		p.shareUserGoBak.trigger("click");
		});
    	p.shareUserGoBak.click(function(){
    		p.shareUserCon.addClass("modal");
    		p.taskCreateCon.removeClass("modal");
    	});
    	
    	//关注用户确定按钮
		p.followuserbtn.click(function(){
			var shareuserid="";
			var shareusername = "";
			var data=[];
			p.followUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					var id=$(this).find(":hidden[name=userid]").val();
					var name=$(this).find(":hidden[name=username]").val();
					shareuserid += id+",";
					shareusername += name+",";
					data.push({id:id , name:name, type: 'attenuser'});
				}
			});
			if(shareuserid==""){
				$(".myMsgBox").css("display","").html("请选择共享用户!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			p.followuserid.val(shareuserid);
			p.follownickname.val(shareusername);
			//新增或者删除团队成员
			saveFollowUser(data);
		});
    	
    	//团队用户列表 TAB页切换
    	p.shareusertab.find("div").click(function(){
    		$(this).siblings().removeClass("active");
    		$(this).addClass("active");
    		if($(this).hasClass("systemuser")){
    			p.shareUserChartList.css("display", "");
    	        p.shareUserList.css("display", "");
    	        p.followUserList.css("display", "none");
    	        p.shareBtn.css("display", "");
    	        p.followuserbtn.css("display", "none");
    		}
    		if($(this).hasClass("attentionuser")){
    			p.shareUserChartList.css("display", "none");
    	        p.shareUserList.css("display", "none");
    	        p.followUserList.css("display", "");
    	        p.shareBtn.css("display", "none");
    	        p.followuserbtn.css("display", "");
    		}
    	});
    	
    	renderAttenCheckedUser();//渲染选择的关注用户
    }
    
  //加载关注用户列表
    function renderAttenUser(){
 	   asyncInvoke({
 	   		url: '<%=path%>/lovuser/attenuserlist',
	 	   	data: {
	   			relaId: '${rowId}',
	   			openId:'${openId}'
	   		},
 	   	    callBackFunc: function(data){
 	   	    	if(!data) return;
 	   	    	var d = JSON.parse(data);
 	   	    	compileAttenUserData(d);
 	   	    }	
 	   	});
    }
    
    //异步加载用户
    function compileAttenUserData(d){
 		if(d.length === 0){
 			p.followUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
 	    	return;
 	    }
 		//组装数据
 		var val = '';
 		$(d).each(function(i){
 			if(!this.openId) return;
 				val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
 	         		+ '<div class="">'
 	         		+ '<img style="border-radius: 10px;" width="50px" src="'+ this.headImgurl +'"/>'
 	         		+ '</div>'
 	         		+ '<div class="list-group-item-bd" style="margin-left: 10px;">'
 	         		+ '<input type="hidden" name="userid" value="'+this.openId+'">'
 	         		+ '<input type="hidden" name="username" value="'+this.nickname+'">'
 	         		+ '<h2 class="title ">'+this.nickname+'</h2>'
 	         		+ '<p>地址：' + this.country + ' ' + this.province + ' ' + this.city + ' </p>'
 	         		+ '</div><div class="input-radio" title="选择该条记录"></div>'
 	         		+'</a>';
 		});
 		p.followUserList.html(val);
    }
    
    //加载选中的关注用户列表
    function renderAttenCheckedUser(){
 	   asyncInvoke({
 	   		url: '<%=path%>/teampeason/asynclist',
 	   		data: {
 	   			relaId: '${rowId}'
 	   		},
 	   	    callBackFunc: function(data){
 	   	    	if(!data) return;
 	   	    	var d = JSON.parse(data);
 	   	    	compileAttenCheckedUserData(d);
 	   	    	initTeamDelBtn();
 	   	        renderTeamImgHead();//显示图片头像
 	   	    }	
 	   	});
    } 
    
    //异步加载选中的用户
    function compileAttenCheckedUserData(d){
 		if(d.length === 0){
 			return;
 	    }
 		//组装数据
 		$(d).each(function(i){
 			if(!this.openId) return;
        		var val = '<div id="'+ this.openId +'" class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">'
        			+ '<input type="hidden" name="assId" value="'+ this.openId +'">'
        			+ '<input type="hidden" name="assName" value="'+this.nickName+'">'
        			+ '<input type="hidden" name="assFlag" value="Y">'
        			+ '<input type="hidden" name="type" value="attenuser">'
        			+ '<div style="text-align: center;">'
        			+ '<img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">'
        			+ '<img src="<%=path%>/image/defailt_person.png" class="headImg" id="'+ this.openId +'" style="width: 50px;height: 50px;border-radius: 10px;">'
        			+ '</div>'
        			+ '<div style="margin-top: 10px;text-align: center;"><span>'+this.nickName+'</span></div>'
        			+ '</div>';
 	         	
        		$(val).insertAfter(".teamCon .teamPeason:last");
 		});
    }
    
    //调用后台接口 发送 团队成员数据
    function renderTeamPeason(d, dSec){
    	asyncInvoke({
    		url: '<%=path%>/shareUser/upd',
    		data: d,
    	    callBackFunc: function(rst){
    	    	if(!rst) return;
    	    	rst = JSON.parse(rst);
    	    	if(rst && rst.errorCode != '0'){
    	    		alert(rst.errorMsg);
    	    		return;
    	    	}
    	    	//显示层
    	    	p.shareUserCon.addClass("modal");
    	    	p.taskCreateCon.removeClass("modal");
    	    	//拼装数据到前台
    	    	compTeamPeason(dSec);
    	    }
    	});
    }
    
    //编译团队成员数据
    function compTeamPeason(d){
    	if(!d || d.length == 0) return;
    	//组装模板数据
    	var imgUrl = "<%=path%>/image/defailt_person.png";
    	var tmp =['<div class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">',
					'<div style="text-align: center;">',
					  '<input type="hidden" name="assId" value="$$assId" />',
					  '<input type="hidden" name="assName" value="$$assName" />',
					  '<input type="hidden" name="assFlag" value="" />',
					  '<input type="hidden" name="type" value="$$type">',
					  '<img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">',
					  '<img src="$$imgUrl" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">',
					'</div>',
				    '<div style="margin-top: 10px;text-align: center;"><span>$$text</span></div>',
				'</div>'];
    	//遍历数据追加到DOM节点
    	var v = '';
    	$(d).each(function(){
    		var t = tmp.join("");
    		    t = t.replace("$$imgUrl", imgUrl);
    		    t = t.replace("$$assId", this.id);
    		    t = t.replace("$$assName", this.name);
    		    t = t.replace("$$text", this.name);
    		    t = t.replace("$$type", this.type);
    		    v += t;
    	});
    	$(v).insertBefore(p.teamAdd);
    	
    	renderTeamImgHead();//显示图片头像
    	renderTeamPerm();//初始化团队的权限
    }
    
  //保存非关注用户
    function saveFollowUser(d){
    	//组装数据
   		compTeamPeason(d);
   		
		$("#task-create").removeClass("modal");
		$("#site-nav").css("display","");
		p.shareUserCon.addClass("modal");
		$("._menu").css("display","");
		
		//初始化分享删除按钮
	    initTeamDelBtn();
			
 	    //组装数据异步提交 
 	   	var dataObj = [];
 	   	p.followform.find("input").each(function(){
 	   		var n = $(this).attr("name");
 	   		var v = $(this).val();
 	   		dataObj.push({name: n, value: v});
 	   	});
 	   	
 	   	$.ajax({
 	   		url: '<%=path%>/teampeason/save',
 	   		type: 'get',
 	   		data: dataObj,
 	   		dataType: 'text',
 	   	    success: function(data){
 	   	    	if(!data) return;
 	   	    	var obj  = JSON.parse(data);
 	   	    	if(obj.errorCode && obj.errorCode !== '0'){
 	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
 	    		   $(".myMsgBox").delay(2000).fadeOut();
 	   	    	}
 	   	    }
 	   	});
    }
    
    //删除非关注用户
    function delFollowUser(d){
 	 //组装数据异步提交 
 	   	var dataObj = [];
 	   	p.followform.find("input").each(function(){
 	   		var n = $(this).attr("name");
 	   		var v = $(this).val();
 	   		dataObj.push({name: n, value: v});
 	   	});
 	   	
 	   	$.ajax({
 	   		url: '<%=path%>/teampeason/del',
 	   		type: 'get',
 	   		data: dataObj,
 	   		//async: false,
 	   		dataType: 'text',
 	   	    success: function(data){
 	   	    	if(!data) return;
 	   	    	var obj  = JSON.parse(data);
 	   	    	if(obj.errorCode && obj.errorCode !== '0'){
 	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
 	    		   $(".myMsgBox").delay(2000).fadeOut();
 	   	    	}
 	   	    	renderAttenUser();
 	   	    }
 	   	});
    }
    
    //初始化团队的权限
    function renderTeamPerm(){
    	//遍历业务机会跟进数据列表
    	$(".teamPeason").each(function(){
    		var assId = $(this).find(":hidden[name=assId]").val();
    		var assName = $(this).find(":hidden[name=assName]").val();
    		var assFlag = $(this).find(":hidden[name=assFlag]").val();
    		if('${crmId}' === assId){
    			if(assFlag === 'Y'){
       				p.teamAdd.css("display", "none");
           			p.teamSub.css("display", "none");
       			}else{
       				p.teamAdd.css("display", "");
           			p.teamSub.css("display", "");
       			}
   			}
   			if(assFlag === 'N'){
   				var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
   				o.parent().find(".delImg").remove();
   			}
    	});
    }
    
    //显示图片头像
    function renderTeamImgHead(){
    	//遍历业务机会跟进数据列表
    	$(".teamPeason").each(function(){
    		var img = $(this).find(".headImg");
    		var readFlag = img.attr("readFlag");
    		if(readFlag === 'Y'){
    			return;
    		}
    		var userId = $(this).find(":hidden[name=assId]").val();
    		//显示单个图片头像
	   	   	if(sessionStorage.getItem(userId + "_headImg")){
	   	   		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
	   	   		return;
	   	   	}
    		//异步调用获取消息数据
        	asyncInvoke({
        		url: '<%=path%>/wxuser/getImgHeader',
        		data: {crmId: userId},
        	    callBackFunc: function(data){
        	    	if(data)
        	    	  $(img).attr({"src":data, "readFlag":'Y'});
        	    	  //本地缓存
	     	          sessionStorage.setItem(userId + "_headImg",data);
        	    }
        	});
    	});
    }
    
    //团队用户唯一性判断
    function teamUniqJudge(assId){
    	var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
    	if(o && o.length > 0) return false;
    	return true;
    }
    
    //异步加载分享用户数据  shareUserList
    function initShareUserFstChart(){
		asyncInvoke({
			url: '<%=path%>/fchart/list',
			async: 'false',
			data: {
			   crmId: '${crmId}',
			   type: p.shareUserCurrType.val(),
			   parenttype:"Bugs",
			   parentid:"${rowId}"
			},
		    callBackFunc: function(data){
		    	if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	$(".myMsgBox").delay(2000).fadeOut();
		    	   return;
		    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    p.shareUserChartList.html(ahtml);
	    	    
	    	    //点击字母
	    		$("#shareuser-more").find(".chartList").find("a").unbind("click").bind("click", function(event){
	    			p.shareUserCurrPage.val("1");
	    			p.shareUserFstChar.val($(this).html());
	    			initShareUserData();
	    		});
		    }
		});
    }
    
    //查询分享用户列表
    function initShareUserData(){
    	asyncInvoke({
    		url: '<%=path%>/lovuser/userlist',
    		data: {
    			crmId: '${crmId}',
    			firstchar: p.shareUserFstChar.val(), 
	 			flag: 'share',
	 			parentid: "${rowId}",
	 			parenttype: "Bugs",
	 			currpage: p.shareUserCurrPage.val(),
	 			pagecount: p.shareUserPageCount.val()  
    		},
    	    callBackFunc: function(data){
    	    	if(!data) return;
    	    	var d = JSON.parse(data);
    	    	initShareUserFstChart();
    	    	compileShareUserData(d);
    	    }	
    	});
     }
    
    function compileShareUserData(d){
 		if(d.length === 0){
 			p.shareUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
 	    	return;
 	    }
 		//组装数据
 		var val = '';
 		$(d).each(function(i){
 			if(!this.userid) return;
 			val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
          		+ '  <div class="list-group-item-bd">'
          		+ '  <input type="hidden" name="assId" value="'+this.userid+'">'
          		+ '  <input type="hidden" name="assName" value="'+this.username+'">'
          		+ '  <h2 class="title ">'+this.username+'</h2>'
          		+ '  <p>职称：'+this.title+'</p>'
          		+ '  <p>部门：<b>'+this.department+'</b></p></div><div class="input-radio" title="选择该条记录"></div>'
          		+'</a>';
 		});
 		p.shareUserList.html(val);
 	}
    
  </script>
</head>
<body>
<div id="task-create">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div id="update" class="operbtn" style="display:none;float:right;padding:0px 12px 0px 12px;cursor:pointer; ">修改</div>
		<h3 id="navTitle" style="padding-right:45px;">缺陷详情</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="scheduleDetail">
		<div class="recommend-box scheduleDetailForm">
				<!-- <h4>详情</h4> -->
				<input type="hidden" name="currpage" value="1"/>
				<input type="hidden" name="firstchar"/>
				<input type="hidden" name="pagecount" value="10"/>
		
				<form  name="bugDetail" action="<%=path%>/bug/updatestatus" method="post" novalidate="true" >
					<input type="hidden" name="publicId" value="${publicId}" />
					<input type="hidden" name="openId" value="${openId}" />
					<input type="hidden" name="rowId" value="${rowId}" />
					<input type="hidden" name="analyze" value="${sd.analyze}" />
					<input type="hidden" name="status" value="${sd.status}" />
			         <input type="hidden" name="log" value="${sd.log}" />
				
					
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>主题：</th>
									<td>${sd.title}</td>
								</tr>
								<tr>
									<th>开始时间：</th>
									<td>${sd.createdate}</td>
									<%-- <td class="upShow">${sd.createdate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxStartDateInput" id="bxStartDateInput" value="${sd.createdate}" 
										     type="text" format="yy-mm-dd HH:ii:ss" placeholder="点击选择日期" readonly="">
									</td> --%>
								</tr>
								<tr>
									<th>状态：</th>
									<td class="upShow">${sd.statusname}</td>
									<td class="uptInput" style="display:none">
										<select name="statusSel" onchange="updateStatus()" style="height:2.2em">
									       <c:forEach var="item" items="${statusDom}" varStatus="status">
												<c:if test="${item.value eq sd.statusname}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.statusname}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>
								<tr>
									<th>分析：</th>
									<td class="upShow">${sd.analyzename}</td>
									<td class="uptInput" style="display:none">
										<select name="analyzeSel" onchange="updateAnalyze()" style="height:2.2em">
									       <c:forEach var="item" items="${resolutionDom}" varStatus="status">
												<c:if test="${item.key eq sd.analyze}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.analyzename}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>
								<tr>
									<th>优先级：</th>
									<td>${sd.driorityname}</td>
									<%-- <td class="upShow">${sd.driorityname}</td>
									<td class="uptInput" style="display:none">
										<select name="drioritySel" onchange="updateDriority()" style="height:2.2em">
									       <c:forEach var="item" items="${priorityDom}" varStatus="status">
												<c:if test="${item.key eq sd.driority}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.driorityname}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td> --%>
								</tr>
									<tr>
									<th>相关类别：</th>
									<td><c:if test="${sd.parenttype != null && sd.parenttype eq 'Project' }">项目</c:if></td>
									<%-- 	<td class="upShow"><c:if test="${sd.parenttype != null && sd.parenttype eq 'Project' }">项目</c:if>
										 
											<c:if test="${sd.relamodule != null && sd.relamodule eq 'Accounts' }">企业</c:if>
											<c:if test="${sd.relamodule != null && sd.relamodule eq 'Opportunities' }">商业机会</c:if>
											<c:if test="${sd.relamodule != null && sd.relamodule eq 'Project' }">项目</c:if>
											<c:if test="${sd.relamodule != null && sd.relamodule eq 'Tasks' }">任务</c:if>
										</td>
										<td class="uptInput" style="display: none">
										<select style="height:2.2em"
											name="relamoduleSel"  onchange="updateRelamodule()" id="parentType">
										</td> --%>
									</tr>
									
									<tr>
									<th>相关值：</th>
											<td>${sd.parentname}</td>
							
								</tr>
								
							</tbody>
						</table>
					</div></div>
					<br/>
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>责任人：</th>
									<td>${sd.assigner}</td>
								</tr>
								<tr class="compStatsDiv">
									<th>说明：</th>
									<td><c:if test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc,0,60)}<a href="javascript:void(0)" onclick='$("#more_desc_a").css("display","none");$("#more_desc").css("display","");' ><span id="more_desc_a">...全部展开</span></a>
											<span id="more_desc" style="display:none;">${fn:substring(sd.desc,60,fn:length(sd.desc)) }<a href="javascript:void(0)"onclick='$("#more_desc_a").css("display","");$("#more_desc").css("display","none");' >...隐藏</a></span>
										</c:if>
										<c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if></td>
									<%-- <td class="upShow">
										<c:if test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc,0,60)}<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");' ><span id="more_a">...全部展开</span></a>
											<span id="more_desc" style="display:none;">${fn:substring(sd.desc,60,fn:length(sd.desc)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if>
									</td>
									<td class="uptInput" style="display:none">
									    <textarea name="desc" id="desc" rows="" cols="" placeholder="请输入备注信息">${sd.desc}</textarea>
									</td> --%>
								</tr>
									<tr class="compStatsDiv">
									<th>日志：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.log) > 60}">
											${fn:substring(sd.log,0,60)}<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_log").css("display","");' ><span id="more_a">...全部展开</span></a>
											<span id="more_log" style="display:none;">${fn:substring(sd.log,60,fn:length(sd.log)) } <a href="javascript:void(0)"onclick='$("#more_a").css("display","");$("#more_log").css("display","none");' >...隐藏</a></span>
										</c:if>
										<c:if test="${fn:length(sd.log) <= 60}">
											${sd.log}
										</c:if>
									</td>
									<td class="uptInput" style="display:none">
									    <textarea name="log" id="log" rows="" cols="" placeholder="请输入日志信息">${sd.log}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					</div>	
					
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>创建：</th>
									<td>${sd.creater} ${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier} ${sd.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				</form>
		
				<!-- 团队成员 -->
				<h3 class="wrapper teamTitle" style="display:'';">团队成员</h3>
				<div class="container hy bgcw teamCon" style="font-size: 14px;background: #fff;">
					<c:if test="${fn:length(shareusers) > 0}">
						    <c:forEach items="${shareusers}" var="user">
								<div class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">
								    <input type="hidden" name="assId" value="${user.shareuserid}" />
							  		<input type="hidden" name="assName" value="${user.shareusername}" />
							  		<input type="hidden" name="assFlag" value="${user.flag}" />
							  		<input type="hidden" name="type" value="sysuser">
									<div style="text-align: center;">
									  <img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">
									  <img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
									</div>
								    <div style="margin-top: 10px;text-align: center;"><span>${user.shareusername}</span></div>
								</div>
							</c:forEach>
					</c:if>
					<div class="teamAdd" at="teamAdd" style="cursor:pointer;float: left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;display:none;">
							<div style="text-align: center;">
							   <img src="<%=path%>/image/mem_add.png" style="width: 50px;height: 50px;">
							</div>
						</div>
						<div class="teamSub" style="cursor: pointer;float:left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;display:none;">
							<div style="text-align: center;">
								<img src="<%=path%>/image/mem_sub.png" style="width: 50px;height: 50px;">
							</div>
						</div>
						<div style="clear: both;">&nbsp;</div>
				</div>
				<!-- 消息显示区域 -->
				<jsp:include page="/common/messages.jsp"></jsp:include>
		</div>
		<!-- 发送消息的区域 -->
		<div class="flooter" id="flootermenu" 
		       style="z-index: 99999;background: #FFF;background: rgb(253, 253, 255);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!--发送消息的区域  -->
			<div class="msgContainer">
			    <div class="ui-block-a" style="float: left;margin: 5px 0px 10px 10px;">
					<img src="<%=path %>/scripts/plugin/menu/images/upmenu.png" style="position:fixed;bottom:10px;" width="30px" onclick="swicthUpMenu('flootermenu')">
				</div>
				<div class="ui-block-a msgdiv" style="width: 100%;margin: 5px 0px 5px 40px;padding-right: 110px;">
				    <!-- 目标用户ID -->
					<input type="hidden" name="targetUId" value="${sd.assignerid}" />
					<!-- 目标用户名 -->
					<input type="hidden" name="targetUName" value="${sd.assigner}" />
					<!-- 子级关联ID -->
					<input type="hidden" name="subRelaId" />
					<!-- 消息模块 -->
					<input name="msgModelType" type="hidden" value="schedule" />
					<!-- 消息类型 txt img doc-->
					<input name="msgType" type="hidden" value="txt" />
					
					<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
				</div>
				<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 0px 5px 0px;">
						<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;">发送</a>
					</div>
				<div style="clear: both;"></div>
			</div>
		</div>
		
		<!--确定/取消按钮-->
		<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display:none;z-index:999999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;height:56px;margin-top:8px;">
				<div class="button-ctrl" style="margin-top:-2px;">
				<fieldset class="">
					<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;">取消</a>
					</div>
					<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-success btn-block"
										style="font-size: 14px;">确定</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	</div>
	
	<!-- 参与人列表DIV -->
	<div id="participant-more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary participantGoBak"><i class="icon-back"></i></a>
			参与人查询
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header participantList">
				<c:forEach items="${userList}" var="pitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<input type="hidden" name="partId" value="${pitem.userid}"/>
							<h2 class="title partName">${pitem.username}</h2>
							<p>职称：${pitem.title}</p>
							<p>
								部门：<b>${pitem.department}</b>
							</p>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(userList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<c:if test="${fn:length(userList) > 0}">
				<div id="phonebook-btn" class=" flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
					<input class="btn btn-block participantbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
				</div>
			</c:if>
		</div>
	</div>
	
	
	<!-- 联系人列表DIV -->
	<div id="contact-more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary contactGoBak"><i class="icon-back"></i></a>
			联系人查询
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header contactList">
				
			</div>
			<div id="phonebook-btn" class=" flooter contactdiv" style="z-index:999999;display:none;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				 <input class="btn btn-block contactbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>

		</div>
	</div>
	
	<!-- 关注用户form -->
	<form method="post" name="followform" action="" >
		<input type="hidden" name="crmId" value="${crmId}">
	    <!-- 数据拥有者的openId -->
	    <input type="hidden" name="ownerOpenId" value="${openId}">
		<input type="hidden" name="openId" value="">
		<input type="hidden" name="nickName" value="">
		<input type="hidden" name="relaId" value="${rowId}">
		<input type="hidden" name="relaModel" value="Bug">
		<input type="hidden" name="relaName" value="${sd.title}">
		<input type="hidden" name="assigner" value="${assigner}">
	</form>	
	
	<!-- 共享用户列表DIV -->
	<div id="shareuser-more" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary shareuserGoBak"><i class="icon-back"></i></a>
			用户列表
		</div>
		
		<!-- 用户类别TAB -->
		<div class="nav nav-tabs nav-normal shareusertab">
			<div class="nav-item active systemuser">
				<a href="javascript:void(0)">系统用户</a>
			</div>
			<div class="nav-item attentionuser">
				<a href="javascript:void(0)">指尖好友 </a>
			</div>
		</div>
		
		<div class="page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currType" value="userList" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="1000" />
			<!-- 字母区域 -->
			<div class="list-group-item listview-item radio chartList" style="background: #fff;padding: 10px;line-height: 30px;">
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span class="chartListSpan" ></span>
				</div>
			</div>
			<div class="list-group listview  shareUserList">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			<!-- 关注者用户 -->
			<div class="list-group listview  followUserList" style="display:none">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			<div class=" flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
				<input class="btn btn-block shareuserbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
				<input class="btn btn-block followuserbtn" type="button" value="确&nbsp;定" style="display:none;width: 100%;margin: 3px 0px 3px 8px;" >
			</div>
		</div>
	</div>
	
	<!-- 相关列表DIV -->
	<div id="parent-more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary parentGoBak"><i class="icon-back"></i></a>
			数据列表
		</div>
		<div class="page-patch">
		    <!-- 字母区域 -->
			<div class="list-group-item listview-item radio" style="background: #fff;">
				<!-- 字母区域 -->
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span id="fristChartsList" ></span>
				</div>
			</div>
			<!-- 上一页 -->
			<div style="width:100%;text-align:center;display:none;" id="div_prev" >
					<a href="javascript:void(0)" onclick="topage('prev')">
						<img  src="<%=path%>/image/prevpage.png" width="32px" >
					</a>
			</div>
			<!-- 客户 -->
			<div class="list-group listview listview-header customerList" style="margin: 2px;">
				<c:forEach items="${cList }" var="customer">
					<a href="javascript:void(0)"
						class="list-group-item listview-item radio" style="border-left: 4px solid #F9FDFF;">
						<div class="list-group-item-bd">
						    <input type="hidden" name="customerId" value="${customer.rowid }"/>
						    <input type="hidden" name="customerName" value="${customer.name }"/>
							<h2 class="title">${customer.name }&nbsp;
							   <span style="color: #AAAAAA; font-size: 12px;">${customer.assigner }</span>
							</h2>
							<p style="margin-left:1.5em;"></p>	
						</div> 
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(cList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<!-- 业务机会 -->
			<div class="site-recommend-list page-patch opptyList" style="margin: 2px;">
				<div class="list-group listview opptyListSub">
					<c:forEach items="${oppList}" var="opp">
						<a href="javascript:void(0)" 
							class="list-group-item listview-item radio" style="border-left: 4px solid #F9FDFF;">
							<div class="list-group-item-bd">
								<div class="thumb list-icon">
									<b>${opp.probability}%</b>
								</div>
								<div class="content">
								    <input type="hidden" name="opptyId" value="${opp.rowid }"/>
						            <input type="hidden" name="opptyName" value="${opp.name }"/>        
									<h1>${opp.name }&nbsp;<span
											style="color: #AAAAAA; font-size: 12px;">${opp.assigner }</span></h1>
									<p class="text-default">预期:￥${opp.amount }&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:${opp.salesstage}</p>
									<p>关闭日期:${opp.dateclosed }&nbsp;&nbsp;&nbsp;&nbsp;跟进天数:${opp.createdate }</p>
								</div>
							</div>
							<div class="input-radio" title="选择该条记录"></div>
						</a>
					</c:forEach>
				</div>
				<c:if test="${fn:length(oppList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<!-- 项目 -->
			<div class="site-recommend-list page-patch projectList" style="margin: 2px;">
				<div class="list-group listview ">
					<c:forEach items="${proList}" var="pro">
						<a href="javascript:void(0)" 
							class="list-group-item listview-item radio" style="border-left: 4px solid #F9FDFF;">
							<div class="list-group-item-bd">
								<div class="content">
								    <input type="hidden" name="proId" value="${pro.rowid }"/>
						            <input type="hidden" name="proName" value="${pro.name }"/>        
									<h1>${pro.name }&nbsp;</span></h1>
									<p>开始日期:${pro.startdate}
									&nbsp;&nbsp;&nbsp;&nbsp;</p>
									<p>结束日期:${pro.enddate}
									&nbsp;&nbsp;&nbsp;&nbsp;</p>
								</div>
							</div>
							<div class="input-radio" title="选择该条记录"></div>
						</a>
					</c:forEach>
				</div>
				<c:if test="${fn:length(proList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<!-- 下一页-->
			<div style="width:100%;text-align:center;display:none;" id="div_next">
				<a href="javascript:void(0)" onclick="topage('next')">
					<img  src="<%=path%>/image/nextpage.png" width="32px" >
				</a>
			</div>
			<!-- 确定按钮 -->
			<div id="phonebook-btn" class="flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				<input class="btn btn-block parentbtn" type="button" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>
		</div>
	</div>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	  <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",  
			title:"${sd.title}",  
			desc:"${sd.desc}",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>