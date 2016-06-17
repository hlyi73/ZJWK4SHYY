<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />

<style type="text/css">
* {
	margin: 0;
	padding: 0;
}

/* .wrapper {
	width:700px;
	margin:0 auto;
	padding-bottom:50px;
} 
 */
/* analytics */
#analytics {
	left: 0px;
	width: 700px;
	min-height: 400px;
	overflow: hidden;
	position: relative;
	margin: 8px;
}

#analytics ul {
	height: 380px;
	position: absolute;
}

#analytics ul li {
	float: left;
	width: 700px;
	min-height: 400px;
	overflow: hidden;
}

#analytics .pre {
	left: 0;
}

#analytics .next {
	  width: 25px;
  height: 50px;
  position: absolute;
  top: 140px;
  right: 0;
  cursor: pointer;
  background: url('/ZJWK/image/sprite.gif');
  background-position: right;
  opacity:0.1;
}

#analytics .preNext {
	width: 25px;
	height: 50px;
	position: absolute;
	top: 140px;
	cursor: pointer;
	background: url('<%=path%>/image/sprite.gif') no-repeat 0 0;
}
</style>



<script type="text/javascript">
    $(function () {
    	//只有teamview时，才查询责任人
		if("${viewtype}" == "teamview"){
	    	initSystemForm_();
			initSystemFriChar_();
			initSystemData_();
		}
    	
    	//如果是从客户进入，去掉头部信息
    	if ('${source}' == 'true')
    	{
    		$("#site-nav").css("display","none");
    		$(".operArea").css("display","none");
    	}
    	//end
    	initDatePickerOppty();
    	initForm();
    	initstar();
    	initCondition();
    	initreprot();
    	
	});
    
    var systemObj_={};
	function initSystemForm_(){
		systemObj_.fstchar = $(":hidden[name=assignerfstChar_]");
		systemObj_.currtype = $(":hidden[name=assignercurrType_]");
		systemObj_.currpage = $(":hidden[name=assignercurrPage_]");
		systemObj_.pagecount = $(":hidden[name=assignerpageCount_]");
		systemObj_.chartlist = $(".assignerChartList_");
		systemObj_.assignerlist = $(".assignerList_");
		systemObj_.assignerNoData = $("#assignerNoData_");
	}
	


	//选择修改时间
	function selectQuoteMdate(obj, days) {
		var search_div = $("#search_div6");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		if('quarter'===days){
			var date = getQuarter();
			$("input[name=startDate]").val(date.split(";")[0]);
			$("input[name=endDate]").val(date.split(";")[1]);
		}else if('year'==days){
			var year = new Date().getFullYear();
			$("input[name=startDate]").val(year+"-"+"01-01");
			$("input[name=endDate]").val(year+"-"+"12-31");
		}else{
			var startdate = dateFormat(new Date(),"yyyy-MM-dd");
			var enddate=getQueryDate(new Date(),days);
			$("input[name=startDate]").val(startdate);
			$("input[name=endDate]").val(enddate);
		}	
		$(":hidden[name=modifydateflag]").val(days);
	}
	
	//判断当前月属于哪个季度,并得到开始和结束日期
	function getQuarter(){
		var month = new Date().getMonth()+1;
		var year = new Date().getFullYear();
		var startdate = '';
		var enddate = '';
		if(month>=10){
			startdate = year+"-"+"10-01";
			enddate = year+"-"+"12-31";
		}else if(month>=7&&month<10){
			startdate = year+"-"+"07-01";
			enddate = year+"-"+"09-30";
		}else if(month>=4&&month<7){
			startdate = year+"-"+"04-01";
			enddate = year+"-"+"06-30";
		}else if(month<4&&month>=1){
			startdate = year+"-"+"01-01";
			enddate = year+"-"+"03-31";
		}
		return startdate+";"+enddate;
	}

	//获取开始日期
	function getQueryDate(theDate,days){
		if(days != 'undefined' && days){
			theDate = new Date(theDate.getTime()+ days * 24 * 60 * 60 * 1000);
		} 
	    var year = theDate.getFullYear();
	    var month = theDate.getMonth()+1;
	    var day = theDate.getDate();
	    if(month < 10){
	    	month = "0"+month;
	    }
	    if(day < 10){
	    	day = "0"+day;
	    }
	    return year + "-" + month + "-"+day; 
	}
	
	
	
	//选择星标
	function star(cmark,id){
		if('mark'== cmark){
			$("."+id+"_star1flag").css("display","none");
			$("."+id+"_star2flag").css("display","");
			
			$.ajax({
			      type: 'post',
			      url: '<%=path%>/starModel/save',
			      data: {parentType:'Opportunities',parentId:id},
			      dataType: 'text',
			      success: function(data){
			    	  
			      }
			 });
			
		}else if('unmark' == cmark){
			$("."+id+"_star1flag").css("display","");
			$("."+id+"_star2flag").css("display","none");
			
			$.ajax({
			      type: 'post',
			      url: '<%=path%>/starModel/delStar',
			      data: {parentType:'Opportunities',parentId:id},
			      dataType: 'text',
			      success: function(data){
			      }
			 });
		}
	}
	
	//初始化星标
	function initstar(){
		var cust_len = "${fn:length(oppList)}";
		if(cust_len <=0){
			return;
		}
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/starModel/isStar',
		      data: {parentType:'Opportunities'},
		      dataType: 'text',
		      success: function(data){
		    	  if(data){
		    		  var d = JSON.parse(data);
		    		  $(d).each(function(){
		    			$("."+this.parentId+"_star1flag").css("display","none");
		    			$("."+this.parentId+"_star2flag").css("display","");
		    		  });
		    	  }
		      }
		 });	
	}
	
	
	//选择是否为星标
	function selectStar(flag){
		if("yes" == flag){
			$("#staryes").addClass("selected");
			$("#starno").removeClass("selected");
		}else{
			$("#staryes").removeClass("selected");
			$("#starno").addClass("selected");
		}
			 $(":hidden[name=starflag]").val(flag);
	}
	
	//异步加载首字母
	function initSystemFriChar_(){
		systemObj_.chartlist.empty();
		systemObj_.fstchar.val('');
		var type=systemObj_.currtype.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/fchart/list',
		      data: {crmId: '${crmId}',type: type},
		      dataType: 'text',
		      success: function(data){
		    	    if(!data) return;
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	systemObj_.chartlist.html("操作失败!错误描述:" + d.errorMsg);
		    	    	$(".systemdiv_").css("display","none");
		    	    	return;
	    	    	}
		    	    var ahtml = '';
		    	    $(d).each(function(i){
		    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseFristCharts_(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
		    	    });
		    	    systemObj_.chartlist.html(ahtml);
		      }
		 });
	}

	//选择字母查询
	function chooseFristCharts_(obj){
		systemObj_.currpage.val(1);
		systemObj_.fstchar.val($(obj).html());
		initSystemData_();
	}

	//异步查询责任人
	function initSystemData_(){
		var currpage = systemObj_.currpage.val();
		var pagecount = systemObj_.pagecount.val();
		var firstchar = systemObj_.fstchar.val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/lovuser/userlist',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    if(null==data||""==data){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerNoData.css("display","");
		    	    		systemObj_.assignerlist.empty();
		    	    	}
		    	    	return;
		    	    }
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerNoData.css("display","");
		    	    		systemObj_.assignerlist.empty();
		    	    	}
		    	    	return;
		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	if(currpage === "1"){
		    	    		systemObj_.assignerlist.empty();
		    	    		systemObj_.assignerlist.html(d.errorMsg);
		    	    	}
		    	    	return;
		    	    }else{
						$(d).each(function(i){
							val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
								+  '<div class="list-group-item-bd"><input type="hidden" name="assId" value="'+this.userid+'"/>'
								+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
								+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
						});
						systemObj_.chartlist.css("display",'');
			    	}
		    	    systemObj_.assignerlist.html(val);
		      }
		 });
	}
    
  //初始化报表切换
	function initreprot(){
		var width = $("#site-nav").width()-10;
		
		$("#analytics").css("width",width);
		$("#analytics ul li").css("width",width);

		var len = $("#analytics ul li").length; //获取焦点图个数
		var index = 0;

		//以下代码添加数字按钮和按钮后的半透明条，还有上一页、下一页两个按钮
		var btn = "<div class='btnBg'></div><div class='btn'>";
		for(var i=0; i < len; i++) {
			btn += "<span></span>";
		}
		btn += "</div><div class='preNext pre'></div><div class='next'></div>";
		$("#analytics").append(btn);
		$("#analytics .btnBg").css("opacity",0.1);

		//上一页、下一页按钮透明度处理
		$("#analytics .preNext").css("opacity",0.1).hover(function() {
			$(this).stop(true,false).animate({"opacity":"0.1"},300);
		},function() {
			$(this).stop(true,false).animate({"opacity":"0.1"},300);
		});

		//上一页按钮
		$("#analytics .pre").click(function() {
			index -= 1;
			if(index == -1) {index = len - 1;}
			showPics(index);
		});

		//下一页按钮
		$("#analytics .next").click(function() {
			index += 1;
			if(index == len) {index = 0;}
			showPics(index);
		});
	}
  
	//显示报表函数，根据接收的index值显示相应的内容
	function showPics(index) { //普通切换
		var sWidth = $("#analytics").width();
		var nowLeft = -index*sWidth; //根据index值计算ul元素的left值
		$("#analytics ul").stop(true,false).animate({"left":nowLeft},300); //通过animate()调整ul元素滚动到计算出的position
	}
	
     
    function initForm(){
    	var selObj = $("select[name=viewtype]");
    	//下拉框初始化
    	selObj.change(function(){
    		$("form[name=viewtypeForm]").submit();
    		return false ;
    	});
    	//获取类型值
    	selObj.val('${viewtype}');
    	$(".viewtypelabel").html(selObj.find("option:selected").text());
    	
    	//责任人选择事件
    	$(".assignerChoose_").click(function() {
    		$("#div_search_content").addClass("modal");
    		$("#assigner-more_").removeClass("modal");
    		$("._menu").css("display","none");
   	       	$("._submenu").css("display","none");
    	});
    	$(".assignerGoBak_").click(function() {
    		$("#div_search_content").removeClass("modal");
    		$("#assigner-more_").addClass("modal");
    		$("._menu").css("display","");
   	       	$("._submenu").css("display","");
    	});

    	// 责任人 的 确定按钮
    	$(".assignerbtn_").click(function() {
    		var assId = null;
    		var assName = null;
    		$("#search_div3").find("#searchedasslist").empty();
    		$("#addAssigner_").empty();
    		var i = 0;
    		var size = $(".assignerList_ > a.checked").size();
    		$(".assignerList_ > a.checked").each(function() {
    			i++;
    			assId += $(this).find(":hidden[name=assId]").val() + ",";
    			assName = $(this).find(".assName").html() + ",";
    			assName = assName.replace("null", "");
    			if (i == size) {
    				assName = assName.substring(0, assName.lastIndexOf(","));
    			}
    			$("#addAssigner_").append("<span>" + assName + "</span>");
    		});
    		if(assId==""||null==assId){
				$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
    		assId = assId.replace("null", "");
    		assId = assId.substring(0, assId.lastIndexOf(","));
    		$("input[name=assignerId]").val(assId);
    		$("#div_search_content").removeClass("modal");
    		$("#assigner-more_").addClass("modal");
    		$(".assignerGoBak_").trigger("click");
    		$("._menu").css("display","");
   	       	$("._submenu").css("display","");
    	});
    }
    
    //初始化日期控件
    function initDatePickerOppty(){
    	var opt = {
    		datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
    	};
   		var optSec = {
   			theme: 'default', 
   			mode: 'scroller', 
   			display: 'modal', 
   			lang: 'zh'
   		};
   		$('#startDate').val('').scroller('destroy').scroller($.extend(opt['datetime'], optSec));
   		$('#endDate').val('').scroller('destroy').scroller($.extend(opt['datetime'], optSec));
    }
    
    function topage(){
    	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
    	$(".nextspan").text('努力加载中...');
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		var orgId = $(":hidden[name=orgId]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/oppty/opplist' || '',
		      //async: false,
		      data: {orgId:orgId,salesstage:'${salesstage}',failure:'${failure}',endDate:'${endDate}',opptyname:'${opptyname}',customername:'${customername}',assignId:'${assignId}',startDate:'${startDate}',viewtype:'${viewtype}',cstartdate:'${cstartdate}',cenddate:'${cenddate}',dateclosed:'${dateclosed}',currpage:currpage,pagecount:'10',orderString:'${orderString}'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_oppty_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
						$("#div_next").css("display",'none');	    	    	  
						return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/oppty/detail?rowId='
								+ this.rowid +"&orgId="+this.orgId
								+ '" class="list-group-item listview-item">'
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'
								+ this.probability
								+ '%</b> </div>';
							if(this.orgId=='Default Organization'){
								 val += '<img src="<%=path %>/image/private.png" style="float:right;margin-right:-65px;margin-top:-15px;width:40px;">';
							}
							val += '<div class="content" style="text-align: left">'
								+ '<h1>'
								+ this.name
								+ '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
								+ this.assigner
								+ '</span></h1>'
								+ '<p class="text-default">金额:<span style="color:blue">￥'
								+ formatNumber(this.amount,2,1)
								+ '</span>元&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:<span style="color:blue">'
								+ this.salesstage
								+ '</span></p>'
								+ '<p>关闭日期:'
								+ this.dateclosed
								+ '&nbsp;&nbsp;&nbsp;&nbsp</p>'
								+ '</div></div> '
								+ '<div class="list-group-item-fd">'
								+ '<span class="'+this.rowid+'_star1flag" style="display: ;">'
			                    +'<img  onclick="star(\'mark\',\''+this.rowid+'\');return false;" src="<%=path%>/image/star1.png" width="60px" style="padding: 18px;margin-right:-15px;">'
				                + '</span >'
				                + ' <span class="'+this.rowid+'_star2flag" style="display:none">'
				                + ' <img onclick="star(\'unmark\' ,\''+this.rowid+'\');return false;" src="<%=path%>/image/star2.png" width="60px" style="padding: 18px;margin-right:-15px;">' 
				                + '</span>'
								+'</div>'
								+ '</a>';
								});
						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_oppty_list").html(val);
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
						$(".nextspan").text('下一页');
					}
				});
	}
	//取消查询
	function closeSearch() {
		$("#div_search_content").addClass("modal");
		$("#div_oppty_list").removeClass("modal");
		$("#div_next").removeClass("modal");
		$("#analytics").removeClass("modal");
	}

	function displayDiv(){
		if($("#analytics").hasClass("modal")){
			$("#analytics").removeClass("modal");
			load1();
			load2();
			load3();
		}else{
			$("#analytics").addClass("modal");
		}
		$("#div_search_content").addClass("modal");
		$("#div_next").removeClass("modal");
	}
		
	//查询
	function searchOppty111() {
		if(!$("#div_search_content").hasClass("modal")){
			$("#div_search_content").addClass("modal");
			$("#div_oppty_list").removeClass("modal");
			$("#div_next").removeClass("modal");
			return;
		}
		$("#div_search_content").removeClass("modal");
		$("#div_oppty_list").addClass("modal");
		$("#div_next").addClass("modal");
		$("#analytics").addClass("modal");
		 //加载最后一次查询的条件
		$.ajax({
			type : 'get',
			url : '<%=path%>/oppty/searchlastcache',			
	        data: {},
		    success: function(data){
		    	var d = JSON.parse(data);
		    	//遍历
		    	$.each(d, function(i, v){
		    		var arr = v.split("|");
					$("input[name=opptyname]").val(arr[0]);
					$("input[name=salesstage]").val(arr[1]);
					$("input[name=startDate]").val(arr[2]);
					$("input[name=endDate]").val(arr[3]);
				
				   
					if(arr[1] != 'null' && arr[1]!= ''){
					$("#search_div").find("li a").each(function(){
						var atr = $(this).attr("onclick");
						if(atr.indexOf(arr[1]) !== -1){
							$(this).addClass("selected");
						}
					});
					}
				  if(arr[4] != 'null' && arr[4]!= ''){
					  $(":hidden[name=assignerId]").val(arr[4]);
					  
						var as = arr[4].split(",");
						$(as).each(function(){
							var s = '<input name="searchedassid" id="searchedassid" value="'+ this +'" type="hidden" class="form-control">';
							    s += '<span style="margin-left: 10px;" id="searchedassid"><span>' + getsssname(this) +'</span></span>';
							    $("#search_div3").find("#searchedasslist").append(s);
						});
				  }
		    	});
		    }
	     }
	  );
	}

	//提交查询
	function searchList() {
		savelastsearch();
		var orgId = $(":hidden[name=orgId]").val();
		$("form[name=alistForm]").attr("action",$("form[name=alistForm]").attr("action") + "?orgId="+orgId);
		$("form[name=alistForm]").submit();
	}
	
	//清空
	function clearSearch(){
		$.ajax({
			url : '<%=path%>/oppty/dellastcache',			
	        data: {},
		    success: function(data){
				$("input[name=opptyname]").val('');
				$("input[name=startDate]").val('');
				$("input[name=endDate]").val('');
				$("#search_div").find("li a").removeClass("selected");
				$("#search_div3").find("#searchedasslist").empty();
				$("#search_div3").find("#addedasslist").find("span").empty();
				//
				$("input[name=searchname]").val('');
				$("input[name=salesstage]").val('');
		    }
	    });
	}
	
	//保存查询条件
	function savesearchList(){
	  var salesstage=$("input[name=salesstage]").val();
	  var searchname=$("input[name=searchname]").val();
	  var opptyname=$("input[name=opptyname]").val();
	  var startdate=$("input[name=startDate]").val();
	  var enddate = $("input[name=endDate]").val();
	  var viewtype ='${viewtype}';
	  var assignerid = $(":hidden[name=assignerId]").val();
	  var length = fucCheckLength(searchname);
	  if(''==opptyname&&''==salesstage&&''==assignerid&&''==startdate&&''==enddate){
		  $(".myMsgBox").css("display","").html("请至少选择查询一个条件!");
		  $(".myMsgBox").delay(2000).fadeOut();
		  return; 
	  }
	  if(length==0){
		  $(".myMsgBox").css("display","").html("名称不能为空,请输入查询名称!");
		  $(".myMsgBox").delay(2000).fadeOut();
		  return; 
	  }
	  if(length>10){
		$(".myMsgBox").css("display","").html("请输入十个字符以内的查询名称!");
	    $(".myMsgBox").delay(2000).fadeOut();
		return;
	  }
	  $.ajax({
			type : 'post',
			url : '<%=path%>/oppty/savesearch' || '',			
		    //async: false,
	        data: {salesstage:salesstage,opptyname:opptyname,startdate:startdate,enddate:enddate,searchname:searchname,assignerid:assignerid},
		    dataType: 'text',
		    success: function(data){
		    	var d = JSON.parse(data);
		    	if(d&&d.errorCode=='0'){
		    		$(".myMsgBox").css("display","") .html("保存成功！");
    	    		$(".myMsgBox").delay(2000).fadeOut();
    	    		if($("#viewdiv").css("display")=='none'){
    	    			$("#viewdiv").css("display","");
    	    		}
    	    		var div ='<a href="<%=path%>/oppty/opptylist?assignerid='+assignerid+"&startdate="+startdate+"&enddate="+enddate+"&salesstage="+salesstage+"&viewtype="+viewtype+"&opptyname="+opptyname+'">'
							 + '<div style="float:left;padding:10px;width:50%;"><img src="<%=path%>/image/icon_cirle.png">&nbsp;'+searchname+'<span onclick="delCon(this,\''+ searchname +'\');" style="cursor:default;color:red;margin-left:5px">x</span></div></a>';
		          	
					$("#viewdiv").after(div);
	    	    	 return;
		    	}else if(d.errorCode=='9'){
		    		$(".myMsgBox").css("display","") .html("保存失败，请联系管理员！");
	    	        $(".myMsgBox").delay(2000).fadeOut();
		    	    return;
		    	}else{
		    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	        $(".myMsgBox").delay(2000).fadeOut();
		    	    return;
		    	}
		    }
	     }
	  );
	}
	
	function delCon(obj,name,flag){
		//删除
			var parent = $(obj).parent().parent();
			$(parent).attr("href","#");
		$.ajax({
			type : 'post',
			url : '<%=path%>/oppty/delcache',			
		    //async: false,
	        data: {name:name},
		    dataType: 'text',
		    success: function(data){
		    	var d = JSON.parse(data);
		    	if(d&&d.errorCode=='0'){
    	    		$(obj).parent().parent().remove();
	    	    	return;
		    	}else if(d.errorCode=='9'){
		    		$(".myMsgBox").css("display","") .html("保存失败，请联系管理员！");
	    	        $(".myMsgBox").delay(2000).fadeOut();
		    	    return;
		    	}else{
		    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	        $(".myMsgBox").delay(2000).fadeOut();
		    	    return;
		    	}
		    }
		});
	}
	
	
	//保存最后一次查询条件
	function savelastsearch(){
		  var opptyname=$("input[name=opptyname]").val();
		  var salesstage=$("input[name=salesstage]").val();
		  var startdate=$("input[name=startDate]").val();
		  var enddate = $("input[name=endDate]").val();
		  var assignerid = $(":hidden[name=assignerId]").val();
	  $.ajax({
			type : 'post',
			url : '<%=path%>/oppty/savelastsearch' || '',
			//async : false,
			data : {
				opptyname : opptyname,
				salesstage : salesstage,
				startdate : startdate,
				enddate : enddate,
				assignerid : assignerid
			},
			dataType : 'text',
		});
	}
	
	//从缓存中得到查询的条件
	function initCondition(){
		$.ajax({
			type : 'post',
			url : '<%=path%>/oppty/searchcache',			
		    data:{},
		    success: function(data){
		    	if(''==data||null==data){
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	$(d).each(function(j){
		    		var arr = this.split("|");
		    		var div = '<a href="<%=path%>/oppty/opptylist';
		    		var opptyname = '';
		    		var salesstage = '';
		    		var startdate = '';
		    		var enddate = '';
		    		var assignerid='';
		    		for(var i=0;i<arr.length;i++){
		    			if(arr[i].indexOf("opptyname:")!=-1){
		    				opptyname = arr[i].split(":")[1];
		    				div+='&opptyname='+opptyname;
		    			}else if(arr[i].indexOf("assignerid:")!=-1){
		    				assignerid = arr[i].split(":")[1];
		    				div+='&assignerId='+assignerid;
		    			}else if(arr[i].indexOf("salesstage:")!=-1){
		    				salesstage = arr[i].split(":")[1];
		    				div+='&salesstage='+salesstage;
		    			}
		    			else if(arr[i].indexOf("startdate:")!=-1){
		    				startdate = arr[i].split(":")[1];
		    				div+='&startdate='+startdate;
		    			}
		    			else if(arr[i].indexOf("enddate:")!=-1){
		    				enddate = arr[i].split(":")[1];
		    				div+='&enddate='+enddate;
		    			}
		    		}
		    		if((j+1)==$(d).size()){
	    				$("input[name=opptyname]").val(opptyname);
	    				$("input[name=startDate]").val(startdate);
	    				$("input[name=endDate]").val(enddate);
	    				$("#search_div").find("li a").each(function(){
							var atr = $(this).attr("onclick");
							if(''!=salesstage&&null!=salesstage&&atr.indexOf(salesstage) !== -1){
								$(this).addClass("selected");
							}
						});
	    				if(assignerid!= 'null'){
							$("#addedasslist").find(":hidden[name=assignerId]").val(assignerid);
							var as = assignerid.split(",");
							$(as).each(function(){
								var s = '<input name="searchedassid" id="searchedassid" value="'+ this +'" type="hidden" class="form-control">';
								    s += '<span style="margin-left: 10px;" id="searchedassid"><span>' + getsssname(this) +'</span></span>';
								    $("#search_div3").find("#searchedasslist").append(s);
							});
						}
	    			}
		    		div += '"><div style="float:left;padding:10px;width:50%;"><img src="<%=path%>/image/icon_cirle.png">&nbsp;'+arr[0]+'<span onclick="delCon(this,\''+ arr[0] +'\');" style="color:red;margin-left:5px;cursor:default">x</span></div></a>';
					$("#viewdiv").css("display","");
		    		$("#viewdiv").after(div);
		    	});
		    	
		    }
		});
	}
	
	
	//检查字符的长度
	 function fucCheckLength(strTemp) { 
		  var i,sum;
		  sum=0;
		  for(i=0;i<strTemp.length;i++) { 
		    if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255)) {
		      sum=sum+1;
		    }else {
		      sum=sum+2;
		    }
		  }
		  return sum; 
		}

	function changeSearchVal() {
		//clean
		$("input[name=opptyname]").val('');
		$("input[name=startDate]").val('');
		$("input[name=endDate]").val('');
		$("#search_div").find("li a").removeClass("selected");
		$("#search_div3").find("#searchedasslist").empty();
		$("#search_div3").find("#addedasslist").find("span").empty();

		var v = $("select[name=searchSel]").find("option:selected").val();
		if (v) {
			var arr = v.split("|");
			$("input[name=searchname]").val(arr[0]);
			$("input[name=opptyname]").val(arr[1]);
			$("input[name=salesstage]").val(arr[2]);
			$("input[name=startDate]").val(arr[3]);
			$("input[name=endDate]").val(arr[4]);
			if (arr[2] != 'null') {
				$("#search_div").find("li a").each(function() {
					var atr = $(this).attr("onclick");
					if (atr.indexOf(arr[2]) !== -1) {
						$(this).addClass("selected");
					}
				});
			}
			if (arr[5] != 'null') {
				$(":hidden[name=assignerId]").val(arr[5]);
				var as = arr[5].split(",");
				$(as)
						.each(
								function() {
									var s = '<input name="searchedassid" id="searchedassid" value="'+ this +'" type="hidden" class="form-control">';
									s += '<span style="margin-left: 10px;" id="searchedassid"><span>'
											+ getsssname(this)
											+ '</span></span>';
									$("#search_div3").find("#searchedasslist")
											.append(s);
								});
			}
		}
	}

	function getsssname(assId) {
		var o = $("#assigner-more_").find(
				":hidden[name=assId][value=" + assId + "]");
		return o.siblings("h2").html();
	}

	function selectSalesStage(obj, stage) {
		var search_div = $("#search_div");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=salesstage]").val(stage);
	}
	
	function add(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/oppty/get?campaigns=${campaigns}&parentType=${parentType}');
		//window.location.href = "<%=path%>/oppty/get?campaigns=${campaigns}&parentType=${parentType}";
	}
	//选择orgId
	function searchDataByOrgId(orgId)
	{
		window.location.replace("<%=path%>/oppty/opptylist?salesstage=${salesstage}&failure=${failure}&endDate=${endDate}&assignId=${assignId}&startDate=${startDate}&cstartdate=${cstartdate}&cenddate=${cenddate}&dateclosed=${dateclosed}&viewtype=${viewtype}&orgId=" + orgId);
	}
	
	function sortOppty(type){
		var orgId = $(":hidden[name=orgId]").val();
		if(type == 'dcdate'){
			window.location.replace('<%=path%>/oppty/opptylist?salesstage=${salesstage}&failure=${failure}&endDate=${endDate}&assignId=${assignId}&startDate=${startDate}&cstartdate=${cstartdate}&cenddate=${cenddate}&dateclosed=${dateclosed}&viewtype=${viewtype}&orderString=dcdate&orgId='+orgId);
		}else if(type == 'acdate'){
			window.location.replace('<%=path%>/oppty/opptylist?salesstage=${salesstage}&failure=${failure}&endDate=${endDate}&assignId=${assignId}&startDate=${startDate}&cstartdate=${cstartdate}&cenddate=${cenddate}&dateclosed=${dateclosed}&viewtype=${viewtype}&orderString=acdate&orgId='+orgId);
		}else if(type == 'dclosedate'){
			window.location.replace('<%=path%>/oppty/opptylist?salesstage=${salesstage}&failure=${failure}&endDate=${endDate}&assignId=${assignId}&startDate=${startDate}&cstartdate=${cstartdate}&cenddate=${cenddate}&dateclosed=${dateclosed}&viewtype=${viewtype}&orderString=dclosedate&orgId='+orgId);	
		}else if(type == 'aname'){
			window.location.replace('<%=path%>/oppty/opptylist?salesstage=${salesstage}&failure=${failure}&endDate=${endDate}&assignId=${assignId}&startDate=${startDate}&cstartdate=${cstartdate}&cenddate=${cenddate}&dateclosed=${dateclosed}&viewtype=${viewtype}&orderString=aname&orgId='+orgId);	
		}
	}
</script>
</head>
<body>
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Workpalan" name="relaModule"/>
	</jsp:include>
	<div id="site-nav" class="zjwk_fg_nav">
		<a href="javascript:void(0)" onclick='searchOppty111()' style="padding:5px 8px; ">筛选</a>
		<a href="javascript:void(0)" onclick="displayDiv()" style="padding:5px 8px;">报表</a>
		<a href="javascript:void(0)" onclick='$("#sort_div").removeClass("modal");$(".sortshade").css("display","");' style="padding:5px 8px;">排序</a>
		<a href="javascript:void(0)" onclick='add()' style="padding:5px 8px;">创建</a>
	</div>
		<%-- <jsp:include page="/common/back.jsp"></jsp:include>

		<div class="act-secondary">
			<a onclick="add()"
				style="font-size: 35px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">+</a>
		</div>
		<input type="hidden" name="currpage" value="1" /> <a
			href="javascript:void(0)" class="list-group-item listview-item">
			<form name="viewtypeForm" action="<%=path%>/oppty/opptylist?parentType=${parentType}" method="post">
				<div class="list-group-item-bd"
					style="width: 180px; margin: 0 auto; padding-top: 5px;">
					<p>
					<div class="form-control select _viewtype_select">
						<c:if test="${viewtype eq 'analyticsview' }">
							<span style="color: white">业务机会列表</span>
						</c:if>
						<c:if test="${viewtype eq 'noticeview' }">
							<span style="color: white">超过15天未跟进的业务机会</span>
						</c:if>
						<c:if test="${viewtype eq 'noclosedview' }">
							<span style="color: white">过期未关闭的业务机会</span>
						</c:if>
						<c:if
							test="${viewtype ne 'analyticsview' && viewtype ne 'noclosedview' && viewtype ne 'noticeview'}">
							<div class="select-box2"><span class="viewtypelabel"></span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
							<select name="viewtype" id="viewtype" style="display: none;">
								<option value="myfollowingview">跟进的业务机会</option>
								<option value="mywonview">成单的业务机会</option>
								<option value="myclosedview">关闭的业务机会</option>
								<option value="teamview">我下属的业务机会</option>
								<option value="shareview">我参与的业务机会</option>
								<option value="myallview">所有的业务机会</option>
							</select>
						</c:if>
					</div>
					</p>
				</div>
			</form>
		</a> --%>

	<!-- 下拉菜单选项 -->
	<script>
		$(function() {
			$("._viewtype_select").click(function() {
				viewtypeClick();
			});

			$("body").click(
					function(e) {
						if ($("#_viewtype_menu").css("display") == "block"
								&& e.target.className == '') {
							viewtypeClick();
						}
					});
		});

		function viewtypeClick() {
			if ($("#_viewtype_menu").css("display") == "none") {
				$("#_viewtype_menu").css("display", "");
				$("#_viewtype_menu").animate({
					height : 190
				}, [ 10000 ]);
				$(".opptyList").css("display", "none");
			} else {
				$("#_viewtype_menu").animate({
					height : 0
				}, [ 10000 ]);
				$("#_viewtype_menu").css("display", "none");
				$(".opptyList").css("display", "");
			}
		}
		
		//选择查询视图
		function selectViewType(obj,stage)
		{
			var search_div = $("#search_div0");
			search_div.find("a").each(function(index) {
				search_div.find("a").removeClass("selected");
			});
			obj.className = "selected";
			$("input[name=viewtype]").val(stage);
		}
	</script>

	<div style="clear: both"></div>
	<div class="site-recommend-list page-patch opptyList">
		<!-- 查询区域 -->
		<div id="div_search_content" class="site-card-view modal"
			style="font-size: 14px; width: 100%; margin-top: 5px; z-index: 999; background: #fff; padding-bottom: 10px;">
			<div style="width: 100%;">
				<form name="alistForm" method="post"
					action="<%=path%>/oppty/opptylist">
					<input type="hidden" name="salesstage" value="" />
					<input type="hidden" name="viewtype" value="${viewtype}" />
					<input type="hidden" name="currpage" value="1" />
					<!-- 查询视图 -->
					<div style="clear: both;"></div>
					<div id="search_div0" class="search_div">
						<div style="float: left; padding-top: 4px;width: 70px;">查询区间：</div>
						<div style="line-height: 25px; padding-left: 72px">
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myview')">我负责的生意</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'teamview')">我下属的生意</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myallview')">所有的生意</a></li>																		
						</div>
					</div>
					
					<div style="clear: both;"></div>
					<div id="search_div1" class="search_div">
						<div
							style="float: left; padding-top: 4px; text-align: right; width: 70px;">机会名称：</div>
						<div style="line-height: 25px; padding-left: 72px">
							<input type="text" name="opptyname" id="opptyname"
								style="width: 90%">
						</div>
					</div>

					<div style="clear: both;"></div>
					<div id="search_div" class="search_div">
						<div
							style="float: left; line-height: 30px; text-align: right; width: 70px;">销售阶段：</div>
						<div style="line-height: 25px; padding-left: 72px">
							<c:forEach items="${salesStageList}" var="item">
								<li><a href="javascript:void(0)"
									onclick="selectSalesStage(this,'${item.key}')">${item.value}</a></li>
							</c:forEach>
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div6" class="search_div">
						<div style="float: left; line-height: 30px;width: 70px;">关闭区间：</div>
						<div style="line-height: 25px; padding-left: 72px">
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'30')">未来30天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'90')">未来90天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'120')">未来120天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'quarter')">本季度</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'year')">本年度</a>
							</li>
						</div>
					</div>
					<div style="clear: both;"></div>
					<c:if test="${viewtype eq 'teamview' }">
						<div id="search_div3" class="search_div" style="">
							<div
								style="float: left; margin-top: 3px; text-align: right; width: 70px;">责&nbsp;任&nbsp;人：</div>
							<div>
								<div id="addedasslist" style="float: left; padding-top: 6px;">
									<input name="assignerId" id="assignerId" value="" type="hidden"
										class="form-control"> <span style="margin-left: 10px;"
										id="addAssigner_"> </span>
								</div>

								<div id="searchedasslist" style="float: left; padding-top: 6px;"></div>
								<img src="<%=path%>/image/addusers.png" width="30px" border="0"
									name="assignerName" id="assignerName" class="assignerChoose_"
									style="margin-left: 15px; cursor: pointer;" />
							</div>
						</div>
					</c:if>
					<div id="search_div2" class="search_div">
						<div
							style="float: left; line-height: 30px; text-align: right; width: 70px;">关闭日期：</div>
						<div style=" padding-left: 72px">
							<input name="startDate" id="startDate" value=""
								style="width: 35%; vertical-align: middle;" type="text"
								placeholder="开始" readonly=""> <span>-</span> <input
								name="endDate" id="endDate" value="" style="width: 35%;"
								type="text" placeholder="结束" readonly="">
						</div>
					</div>
					<div style="clear: both;"></div>
					
						<div id="searchtag_div" class="search_div">
						<div style="float: left; line-height: 30px;">标签名称：</div>
						<div style="line-height: 25px; padding-left: 72px">
							<input type="text" name="tagName" id="tagName" style="width: 90%">
						</div>
					</div>
					<div style="clear: both;"></div>
					
					<div id="searchstar_div" class="search_div">
						<div style="float: left; line-height: 30px;width: 70px;">星标商机：</div>
						<div style="line-height: 25px; padding-left: 72px">
								<li id="staryes"><a href="javascript:void(0)"   onclick="selectStar('yes')">是</a></li>
								<li id="starno"><a href="javascript:void(0)"  onclick="selectStar('no')">否</a></li>
							<input type="hidden" name="starflag" value="" />
						</div>
					</div>
					<div style="clear: both;"></div>
					
				</form>
			</div>
			<div class="wrapper" style="margin-top: 20px;">
				<div class="button-ctrl">
					<fieldset class="">
					<div class="ui-block-a" style="width:50%">
						<input style="height: 2.8em;" type="text" name="searchname" id="searchname" placeholder="请输入查询名称" maxlength="10"/>
					</div>
					<div class="ui-block-a" style="width:25%">
						<a href="javascript:void(0)" class="btn btn-block"
							style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
							onclick="savesearchList()">保存</a>
					</div>
					<div class="ui-block-a" style="width:25%">
						<a class="btn btn-block"
								style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
								onclick="clearSearch();">清空
						</a>
					</div>
					<div style="padding-top:80px;">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
							style="background-color: #49af53;font-size: 14px;margin:0px 20px 0px 20px;"
							onclick="searchList()"> 查 询 </a>
					</div>
					</fieldset>
				</div>
			</div>
		</div>
		<!-- 查询区域End -->
		<!-- 排序 -->
		<div id="sort_div" class="modal _sort_div_" style="position: fixed;margin-top: -45px;">
			<a href="javascript:void(0)" onclick="sortOppty('dcdate')">
				<div style="width: 100%; border-bottom: 1px solid #efefef;">&nbsp;按创建时间倒序</div>
			</a> 
			<a href="javascript:void(0)" onclick="sortOppty('acdate')">
				<div style="width: 100%; border-bottom: 1px solid #efefef;">&nbsp;按创建时间升序</div>
			</a> 
			<a href="javascript:void(0)" onclick="sortOppty('dclosedate')">
				<div style="width: 100%; border-bottom: 1px solid #efefef;">&nbsp;按关闭日期倒序</div>
			</a> 
			<a href="javascript:void(0)" onclick="sortOppty('aname')">
				<div style="width: 100%;">&nbsp;按业务机会名称排序</div>
			</a>
		</div>
		<div class="shade sortshade" style="display: none; opacity: 0.3;"
			onclick='$("#sort_div").addClass("modal");$(".sortshade").css("display","none");'></div>
		<!-- 排序结束 -->

		<!-- 报表 -->
		<div class="analytics modal" id="analytics">
			<ul>
				<li>
					<div id="include_div1">
						<jsp:include page="/jsp/analytics/topic/oppty/oppty_pipeline.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="opptyname" value="${opptyname }" />
							<jsp:param name="startDate" value="${startDate }" />
							<jsp:param name="endDate" value="${endDate }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="salestage" value="${salestage}" />
							<jsp:param name="recordcount" value="${fn:length(oppList)}" />
						</jsp:include>
					</div>
				</li>
				<li>
					<div id="include_div3">
						<jsp:include page="/jsp/analytics/topic/oppty/oppty_stage.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="opptyname" value="${opptyname }" />
							<jsp:param name="startDate" value="${startDate }" />
							<jsp:param name="endDate" value="${endDate }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="salestage" value="${salestage}" />
							<jsp:param name="recordcount" value="${fn:length(oppList)}" />
						</jsp:include>
					</div>
				</li>

				<li>
					<div id="include_div2">
						<jsp:include page="/jsp/analytics/topic/oppty/oppty_failure.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="opptyname" value="${opptyname }" />
							<jsp:param name="startDate" value="${startDate }" />
							<jsp:param name="endDate" value="${endDate }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="salestage" value="${salestage}" />
							<jsp:param name="recordcount" value="${fn:length(oppList)}" />
						</jsp:include>
					</div>
				</li>
			</ul>
		</div>

		<!-- 加载报表 end -->

		<div class="list-group listview" id="div_oppty_list"
			style="margin-top: 5px;">
			<c:forEach items="${oppList }" var="opp">
				 
				<a
					href="<%=path%>/oppty/detail?rowId=${opp.rowid}&orgId=${opp.orgId}&viewtype=${viewtype}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b>${opp.probability}%</b>
						</div>
						<c:if test="${opp.orgId eq 'Default Organization' }">
							<img src="<%=path %>/image/private.png" style="float:right;margin-right:-65px;margin-top:-15px;width:40px;">
						</c:if>
						<div class="content">
							<h1>${opp.name }&nbsp;
								<span style="color: #AAAAAA; font-size: 12px;">${opp.assigner }</span>
							</h1>
							<p class="text-default">
								金额:<span style="color: blue">￥<fmt:formatNumber value="${opp.amount}" pattern="#,#00.00"/></span>元&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:<span
									style="color: blue">${opp.salesstage}</span>
							</p>
							<p>关闭日期:${opp.dateclosed }&nbsp;&nbsp;&nbsp;&nbsp;</p>
							
							<p class="text-default">
								<!-- 成交概率-->
								<c:if test="${opp.probability ne '' && !empty opp.probability && opp.probability ne '0'}">
											成交概率：${opp.probability} %
								</c:if>
								<c:if test="${opp.residence ne '' && !empty opp.residence }">
									停留时间：${opp.residence}
								</c:if>
						   </p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="${opp.rowid }_star1flag" style="display: ;"  >
		                    <img  onclick="star('mark' , '${opp.rowid}');return false;" src="<%=path%>/image/star1.png" width="60px" style="padding: 18px;margin-right:-15px;">
		                 </span >
		                 <span class="${opp.rowid }_star2flag" style="display:none">
		                    <img onclick="star('unmark' ,'${opp.rowid}');return false;" src="<%=path%>/image/star2.png" width="60px" style="padding: 18px;margin-right:-15px;">	 
		                 </span>
					</div>
				</a>
			</c:forEach>

			<c:if test="${fn:length(oppList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
		<c:if test="${fn:length(oppList)==10 }">
			<div
				style="width: 100% auto; text-align: center; background-color: #fff; margin: 8px; padding: 8px; border: 1px solid #ddd;"
				id="div_next">
				<a href="javascript:void(0)" onclick="topage()"> <span class="nextspan">下一页</span>&nbsp;<img
					id="nextpage" src="<%=path %>/image/nextpage.png" width="24px" />
				</a>
			</div>
		</c:if>
	</div>


	<!-- 责任人列表DIV -->
	<div id="assigner-more_" class=" modal"
		style="position: absolute; top: 0; width: 100%;">
		<div id="" class="navbar">
			<a href="#" onclick="javascript:void(0)"
				class="act-primary assignerGoBak_"><i class="icon-back"></i></a>
			责任人列表
		</div>
		<input type="hidden" name="assignerfstChar_" /> <input type="hidden"
			name="assignercurrType_" value="userList" /> <input type="hidden"
			name="assignercurrPage_" value="1" /> <input type="hidden"
			name="assignerpageCount_" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList_"
			style="background: #fff; padding: 10px; line-height: 30px;"></div>
		<div class="list-group listview listview-header assignerList_"
			style="margin-bottom: 65px;">
			<div id="assignerNoData_"
				style="text-align: center; padding-top: 50px; display: none">没有找到数据</div>
		</div>
		<div id="phonebook-btn" class="flooter systemdiv_"
			style="border-top: 1px solid #FFF; padding-top: 4px; background-color: #C0BCBC;">
			<a class="btn btn-block assignerbtn_"
				style="font-size: 14px; width: 98%; margin-left: 5px;">确&nbsp定</a>
		</div>
	</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>