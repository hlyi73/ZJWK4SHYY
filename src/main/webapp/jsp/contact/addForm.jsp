<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=yes" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

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
	
	<script type="text/javascript">
		$(function () {
			initForm();
			initDatePicker();
		});
		
		function initForm(){
			$(".event_type").click(function(){
				$(".event_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=salutation]").val($(this).attr('key'));
			});
			
			$(".period_type").click(function(){
				$(".period_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=cycliKey]").val($(this).attr('key'));
			});
			
			$(".open_type").click(function(){
				$(".open_type").removeClass("selected").addClass("noselected");
				$(this).removeClass("noselected").addClass("selected");
				$(":hidden[name=ispublic]").val($(this).attr('key'));
			});
			
			$(".save").click(function(){
				var regMail = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/; //验证邮箱
				var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证国内手机号码
				var mobile = $("#phonemobile").val();
				var email =  $("#email0").val();
				var zw = $("#conjob").val();
					
				if (''!=$.trim(zw))
				{
					//如果输入的职位名称内容超过16个字节则提示信息
				    var char = zw.match(/[^\x00-\xff]/ig);
					var slength = zw.length + (char == null ? 0 : char.length);
					if(Number(slength)>16)
					{
			  			showMyMsg('职位名称太长，请重新输入');
			  			return false;
					}
				}
								
				if (''!=$.trim(mobile))
				{
					if(!regPhone.test($.trim(mobile)))
					{
						$("#phonemobile").val('');
			  			showMyMsg('请务必输入正确的手机号码');
			  			return false;
					}
				}
				if (''!=$.trim(email))
				{
					if(!regMail.test($.trim(email)))
					{
						$("#email0").val('');
			  			showMyMsg('请务必输入正确的邮箱地址');
			  			return false;
					}
				}
				var conname =  $("#conname").val();
				if (''==$.trim(conname) || 'null' == $.trim(conname))
				{
		  			showMyMsg('请务必输入联系人姓名');
		  			return false;
				}
			});
			
			$(".savebtn").click(function(){
				var regMail = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/; //验证邮箱
				var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证国内手机号码
				var mobile = $("#phonemobile").val();
				var email =  $("#email0").val();
				if (''!=$.trim(mobile))
				{
					if(!regPhone.test($.trim(mobile)))
					{
						$("#phonemobile").val('');
						showMyMsg('请务必输入正确的手机号码');
				        return false;
					}
				}
				if (''!=$.trim(email))
				{
					if(!regMail.test($.trim(email)))
					{
						$("#email0").val('');
						showMyMsg('请务必输入正确的邮箱地址');
				        return false;
					}
				}
				var conname =  $("#conname").val();
				if (''==$.trim(conname) || 'null' == $.trim(conname))
				{
					showMyMsg('请务必输入联系人姓名');
					return false;
				}
				$("#phonebook-form").submit();
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
			
			$("input[name=birthdate]").attr("format","yy-mm-dd");
			
			$('#birthdate').val(birthdate).scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		}
		
		
		//修改日期控件
		function modifyDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'date', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 5  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			var birthdate = $("input[name=birthdate]").val();
			if(birthdate){
				birthdate = birthdate.substr(0,10);
			}
			
			$("#birthdate").attr("type","text");
			
			$('#birthdate').val(birthdate).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		}
		
		//选择客户
		function chooseCust()
		{
			customerjs_choose({
        		success: function(res){
        			$(":hidden[name=accountid]").val(res.key);
        			$("input[name=accountname]").val(res.val);
        		}
        	});
		}
		
	  	function showMyMsg(t){
	  		$(".myMsgBox").css("display","").html(t);
	  		$(".myMsgBox").delay(2000).fadeOut();
	  	}
		
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

.period_type{
	padding: 3px 5px;
}

.event_type {
	padding: 3px 5px;
}

.open_type {
	padding: 3px 5px;
}

a{
	color:#555;
}
</style>
</head>

<body>
	<!-- 新增联系人 -->
	<div id="task-create" class=" ">
		<!-- <div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"/>
			<div class="act-secondary savebtn" style="padding: 0px 15px;">
				保存
			</div>
			<h3 style="padding-right:45px;">创建联系人</h3>
		</div> -->
		
		<div class="zjwk_fg_nav">
			<a href="javascript:void(0)" onclick='history.go(-1);' style="padding:5px 8px;" class="con_del">取消</a>
			<a href="javascript:void(0)" style="padding:5px 8px; " class="con_new savebtn">保存</a>
		</div>
		
		<input type="hidden" name="currpage" value="1"/>
		<input type="hidden" name="firstchar"/>
		<input type="hidden" name="pagecount" value="10"/>
		
		
		<div class="wrapper" style="margin:0px;font-size:14px;">
			<form id="phonebook-form" action="<%=path%>/contact/save?flag=${flag}&source=${source}" method="post" novalidate="true" >
			    <input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="assignerId" value="${crmId}" />
			    <input type="hidden" name="orgId" value="${orgId}" />
			    <input type="hidden" name="parentType" value="${parentType }"/>
			    <input type="hidden" name="parentId" value="${parentId }"/>
			    <%--基本信息 --%>
			    <div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group">
						<input name="conname" id="conname" required="required" id="title" value="" type="text"
							class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="姓名" style="border: 0px;border-bottom: 1px solid #ddd;"/>
						<div class="help-block empty">请填写姓名</div>
					</div>
					
					<div style="line-height:40px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="float:left;color:#666;padding-left:5px;">称谓</div>
						<div style="padding-left:100px;">
							<input type="hidden" name="salutation"/>
							<a href="javascript:void(0)" class="event_type" key='Mrs.' style="">女士</a>
							&nbsp;&nbsp;&nbsp;
							<a href="javascript:void(0)" class="event_type" key='Mr.' style="">先生</a>
						</div>
					</div>
					<!-- 
					<div class="form-group">
						<input name="salutation"  value="Mr." type="radio" class="form-control"  style="margin-left: 0px"/>先生
						<input name="salutation"  value="Mrs." type="radio" class="form-control" />女士
					</div> -->
					
					<div class="form-group" style="margin:0.5em 0;">
						<input name="accountid"  type="hidden"/>
						<input name="accountname" readonly="readonly" onclick="chooseCust()"   type="text" class="form-control" placeholder="公司" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					
					<div class="form-group" style="margin:0.5em 0;">
						<input name="department"   type="text" class="form-control" placeholder="部门" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					
					<div class="form-group" style="margin:0.5em 0;">
						<input name="conjob"  id="conjob"  type="text" class="form-control" placeholder="职位" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
				</div>
				<br/>
				
				<%--联系信息--%>
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group" style="margin:0.5em 0;">
						<input name="phonemobile" id="phonemobile"   type="text" class="form-control" placeholder="移动电话" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					<div class="form-group" style="margin:0.5em 0;">
						<input name="phonework"   type="text" class="form-control" placeholder="办公电话" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					<div class="form-group" style="margin:0.5em 0;">
						<input name="email0" id="email0"   type="text" class="form-control" placeholder="电子邮箱" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					<div class="form-group" style="margin:0.5em 0;">
						<input name="conaddress"   type="text" class="form-control" placeholder="地址" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
					<div class="form-group" style="margin:0.5em 0;display: none">
						<input name="relarowid"   type="text" class="form-control" placeholder="介绍人" style="border: 0px;border-bottom: 1px solid #ddd;"/>
					</div>
				</div>
				
				<br/>
				<%--特殊日期 --%>
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group">
						<div style="position: absolute;margin-top: 8px;margin-left: 5px;color:#666;">生日</div>
						<input name="birthdate" id="birthdate" value="" type="text" format="yy-mm-dd"  class="form-control" readonly="readonly" style="border: 0px;border-bottom: 1px solid #ddd;padding-left:100px;"/> 
					</div>
				</div>
				<%--备注 --%>
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group">
						<textarea name="desc" id="desc" rows="2" style="border: 0px;min-height: 3em;border-bottom: 1px solid #ddd;"
							class="form-control" placeholder="备注"></textarea> 
					</div>
				</div>
				
				<br/>
				<div style="margin:10px 80px;">
					<input type="submit" class="btn btn-block btn-success save" value="保存">
				</div>
			</form>
			<br/>
			<br/>
			<br/>
			<br/>
			<br/>
		</div>
	</div>
<jsp:include page="/common/rela/selcust.jsp">
		<jsp:param value="${orgId}" name="orgId"/>
	</jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	
</body>
</html>