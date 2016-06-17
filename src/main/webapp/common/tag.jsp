<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String parentid = request.getParameter("parentid");
	String parenttype = request.getParameter("parenttype");
	if(parenttype==null){
		parenttype="";
	}
	request.setAttribute("parentid", parentid);
	request.setAttribute("parenttype", parenttype);
%>
<style>
.tagchecked{
cursor: pointer;
line-height: 40px;
background: #D0D9FF;
color: #fff;
padding: 5px;
margin-left: 20px;
float:left;
}
</style>
<script type="text/javascript">
$(function(){
	loadTag<%=parenttype%>();
	initElem<%=parenttype%>();
	initUserTagElem<%=parenttype%>();
	
	changeColor<%=parenttype%>();
});


function initElem<%=parenttype%>(){
	//添加显示输入框
	$(".addTagBtn${parenttype}").click(function(){
		$(".addTagArea${parenttype}").css("display", "");
	});
	
	//删除按钮
	$(".clearTagBtn${parenttype}").click(function(){
	  var tagName;
	  if( $(".tagList${parenttype} span:not(.addTagBtn${parenttype} , .clearTagBtn${parenttype})").hasClass("tagunchecked")){
	  $(".tagList${parenttype} span:not(.addTagBtn${parenttype} , .clearTagBtn${parenttype})").each(function(){
		    var tagobj = $(this);
			if($(this).hasClass("tagunchecked")){
				 	tagName =  $(this).html();
					$.ajax({
					      type: 'post',
					      url: '<%=path%>/modelTag/delTag',
					      data: {openId:'${openId}',publicId:'${publicId}',modelId:'${parentid}',modelType:'${parenttype}',tagName:tagName},
					      dataType: 'text',
					      success: function(data){
					    	  if (data == "success"){
					    		$(".myMsgBox").css("display","").html("删除标签成功!");
							    $(".myMsgBox").delay(2000).fadeOut();
							    tagobj.remove();
					    	  }else{
					    		$(".myMsgBox").css("display","").html("不能删除其他用户创建的标签!");
								$(".myMsgBox").delay(2000).fadeOut();
					    	  }
					      }
					 }); 
			}
		}); 
	  }
	  else{
			$(".myMsgBox").css("display","").html("请选择要删除的标签!");
  		$(".myMsgBox").delay(2000).fadeOut();
		}
		$(".addTagArea${parenttype}").css("display", "none");
	});
	
	
	//取消按钮
	$(".cancelTagBtn${parenttype}").click(function(){
		$(".addTagArea${parenttype}").css("display", "none");
		$("textarea[name=introduction${parenttype}]").val('');
		$("textarea[name=introduction${parenttype}]").attr("placeholder", "请填写");
	});
	//保存
	$(".saveTagBtn${parenttype}").click(function(){
		var introbj = $("textarea[name=introduction${parenttype}]");
		var tagName = $.trim(introbj.val());
		if(!tagName){
			introbj.attr("placeholder","请填写");
			return;
		}
		//判断长度
		var myReg = /^[\u4e00-\u9fa5]+$/;
		if (myReg.test(tagName)) {
            //中文
			if(tagName.length>10){
				introbj.val('');
            	introbj.attr("placeholder","标签长度超出限制，请重新输入");
				return;
            }
        } else {
            //英文
            if(tagName.length>16){
            	introbj.val('');
            	introbj.attr("placeholder","标签长度超出限制，请重新输入");
				return;
            }
        }
		var isExists = false;
		$(".tag_list_item").each(function(){
			if($(this).html() == tagName){
				isExists = true;
				return;
			}
		});
		if(isExists){
			introbj.val('');
			introbj.attr("placeholder","该标签已存在，请输入其他标签");
			return;
		}
		
		//绑定到后台
		var obj = [];
		obj.push({name :'modelId', value :'${parentid}'});
		obj.push({name :'modelType', value : '${parenttype}'});
		obj.push({name :'tagName', value : tagName});
		obj.push({name :'openId', value :'${openId}'});
		obj.push({name :'publicId', value :'${publicId}'});
		//发送保存标签申请
		$.ajax({
	  	      url: '<%=path%>/modelTag/save',
	  	      data: obj,
	  	      success: function(data){
	    	      if(data && data === "success"){
	    	    	  introbj.val('');
	    	    	  var tag = '<span class="tagchecked tag_list_item" style="margin-top:5px;line-height:20px;float: left;">'+tagName+'</span>';
	    	    	  $(".tagList${parenttype}").prepend(tag);
	    	    	  initUserTagElem<%=parenttype%>();
	    	    	  changeColor<%=parenttype%>();
	    	    	  $("textarea[name=introduction${parenttype}]").attr("placeholder", "请填写");
	    	    	  $(".addTagArea${parenttype}").css("display","none");
	    	      }
	  	      }
	  	 });
	});
}


function loadTag<%=parenttype%>(){
	//绑定到后台
	var obj = [];
	obj.push({name :'modelId', value :'${parentid}'});
	obj.push({name :'openId', value :'${openId}'});
	obj.push({name :'modelType', value :'${parenttype}'});
	//加载标签
	$.ajax({
  	      url: '<%=path%>/modelTag/list',
  	      data: obj,
  	      success: function(data){
    	      if(data){
    	    	  var tag = "";
    	    	  var d= JSON.parse(data);
    	    	  $(d).each(function(){
    	    		  tag += '<span class="tagchecked tag_list_item tag_'+this.id+'" style="margin:5px;line-height:20px;float: left;">'+this.tagName+'</span>';
    	    	  });
    	    	  $(".tagList${parenttype}").prepend(tag);
    	    	  initUserTagElem<%=parenttype%>();
    	    	  changeColor<%=parenttype%>();
    	      }
  	      }
  	 });
}

//tag事件点击事件
function initUserTagElem<%=parenttype%>(){
	$(".tagList${parenttype} span:not(.addTagBtn${parenttype} , .clearTagBtn${parenttype})").unbind("click").click(function(){
		if($(this).hasClass("tagchecked")){
			$(this).removeClass("tagchecked");
			$(this).addClass("tagunchecked");
		}else{
			$(this).removeClass("tagunchecked");
			$(this).addClass("tagchecked");
		}
	});
}

//随机获得 候选背景颜色 
function randomColor<%=parenttype%>(){
	var arrHex = ["#4A148C","#01579B","#004D40","#00838F","#33691E"];
	var strHex = arrHex[Math.floor(Math.random() * arrHex.length + 1)-1];
	return strHex; 
}

//改变个人标签背景色
function changeColor<%=parenttype%>(){
	$(".tagchecked").each(function() {
		var hex = randomColor<%=parenttype%>();
		$(this).css("color", hex);
	});	 
}

</script>

	<div class="view site-recommend">
		<div class="recommend-box" style="margin:0px;float: left;width:100%">
			<div class="tagList<%=parenttype%> ui-body-d ui-corner-all info" style="padding: 0.5em;float: left;width: 100%;margin:0px;">
				<span class="addTagBtn<%=parenttype%>" style="margin-top:5px;padding-bottom: 20px;float: left;background:rgb(143, 160, 245); color: #fff;padding: 5px; margin-left: 20px;" class="tag_list_item">+ 标签</span>
				<span class="clearTagBtn<%=parenttype%>" style="margin-top:5px;padding-bottom: 20px;float: left;background:#FCB5A4; color: #fff;padding: 5px; margin-left: 20px;">- 删除</span> 
			</div>

			<div style="clear: both;"></div>
			<!-- 标签添加区域 -->
			<div class="addTagArea<%=parenttype%>" style="display: none">
				<div class="ui-body-d ui-corner-all info" style="padding: 1em;">
					<textarea name="introduction<%=parenttype%>" id="introduction<%=parenttype%>" rows="1" cols="" placeholder="请填写"></textarea>
					<div style="color:#999;font-size:12px;text-align:right;">长度应少于等于10个汉字或16个字符</div>
				</div>
				<div class="ui-body-d ui-corner-all info" style="padding: 1em;height: 65px;margin-top: -10px;">
					<span class="cancelTagBtn<%=parenttype%>" style=" background: #D3D5D8; color: #fff;padding: 5px; text-align: center; width: 44%; cursor: pointer; float: left; margin-right: 10px; border-radius: 10px;">取消</span>
					<span class="saveTagBtn<%=parenttype%>" style=" background: #338dff; color: #fff;padding: 5px; text-align: center; width: 44%; cursor: pointer; float: right;  margin-left: 10px; border-radius: 10px;">添加</span>
				</div>
			</div>
		</div>
	</div>
