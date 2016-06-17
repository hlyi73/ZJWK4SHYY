<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String itempath = request.getContextPath();
	String targetObj = request.getParameter("targetObj");
	String rowid = request.getParameter("rowid");
%>

<script>

$(function(){
	$("._shade_div").click(function(){
		displayorhidden("hidden");
	});
	
	$(".saveItemBtn").click(function(){
		saveMeetingItem();
	});
});

//添加会议议程
function saveMeetingItem(){
	
	if(validate_items()){
		return;
	}
	
	var dataObj = [];
	dataObj.push({name:'activity_id', value: '<%=rowid%>' });
	dataObj.push({name:'start_date', value: $("input[name=start_date]").val()});
	dataObj.push({name:'end_date', value: $("input[name=end_date]").val() });
	dataObj.push({name:'content', value: $("textarea[name=content]").val() });
	dataObj.push({name:'experts', value: $("input[name=experts]").val() });
	
	$.ajax({
	      type: 'get',
	      url: '<%=itempath%>/activity/saveitem' || '',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				if(!data || data === '-1'){
					$(".myMsgBox").css("display","").html("保存失败!");
	    	    	$(".myMsgBox").delay(2000).fadeOut();
				}else{
					var starttime=$("input[name=start_date]").val().substring(10,16)
							var item = '<dt style="line-height: 34px;">'+starttime+'<span style="top: 16px;"></span></dt>';
						item+= '<dd style="width: 70%; cursor: pointer" class="">';
						item+= '<div style="border: 1px solid #ededed; border-radius: 3px; background: #f8f8f8; line-height: 24px; text-indent: 0; padding: 4px 4px 4px 6px;">';
						item += $("textarea[name=content]").val();
						item+= '</div>';
						item+= '</dd>';
					$(".<%=targetObj%>").append(item);
					displayorhidden("hidden");
					initControl();
				}
			}
		});
	}
	
	function initControl(){
		$("input[name=start_date]").val('');
		$("input[name=end_date]").val('');
		$("textarea[name=content]").val('');
		$("input[name=experts]").val('');
	}

	//验证所有的参数是否都已经填写
	function validate_items() {
		var flag = false;
		$("#activity_item_form").find("input").each(function() {
			var val = $(this).val();
			if (!val && $(this).attr("name") != 'experts') {
				flag = true;
			}
		});
		if (!($("textarea[name=content]").val())) {
			flag = true;
		}
		if (flag) {
			$(".myMsgBox").css("display", "").html("填写不完整!请您将带有*标签的字段都填上!");
			$(".myMsgBox").delay(2000).fadeOut();
		}
		return flag;
	}

	//显示或隐藏
	function displayorhidden(type) { 
		if (type == 'hidden') {
			$("._activity_item_div").animate({
				height : '0px'
			}, [ 5000 ]);
			$("._shade_div").css("display", "none");
			$(".msgContainer").css("display", "");
		} else if (type == 'display') {
			$("._shade_div").css("display", "");
			$(".msgContainer").css("display", "none");
			$("._activity_item_div").animate({
				height : '360px'
			}, [ 5000 ]);
		}
	}
</script>
<style>
._activity_item_div{
	width:100%;
	background-color:#fff;
	border-top:1px solid #eee;
	z-index:99;
	opacity: 1;
	padding:10px;
	font-size:14px;
	height:0px;
	overflow:auto;
}
</style>
<form name="activity_item_form" id="activity_item_form">
<div class="_activity_item_div flooter">
	<div class="form-group">
		<input name="start_date" id="start_date"
			value="" type="text" format="yy-mm-dd HH:ii:ss" placeholder="点击选择开始时间">
	</div>
	<div class="form-group">
		<input name="end_date" id="end_date"
			value="" type="text" format="yy-mm-dd HH:ii:ss" placeholder="点击选择结束时间">
	</div>
	<!-- 内容-->
	<div class="form-group">
		<textarea name="content" id="content" rows="4" style="min-height: 3em"
			class="form-control" placeholder="请输入内容"></textarea>
	</div>
	<div class="form-group">
		<input name="experts" id="experts" value=""
			type="text" class="form-control" placeholder="可选，专家姓名" />
	</div>
	<div class="button-ctrl">
		<fieldset class="">
			<div class="ui-block-a" style="width: 100%;">
				<a href="javascript:void(0)" class="btn btn-block saveItemBtn"
					style="font-size: 16px;"> 保存</a>
			</div>
		</fieldset>
	</div>
</div>
<div class="shade1 _shade_div" style="display:none;">&nbsp;</div>
</form>
