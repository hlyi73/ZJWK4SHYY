<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String tagpath = request.getContextPath();
    String relaId = request.getParameter("relaId");
    String relaType = request.getParameter("relaType");
    String reqSource = request.getParameter("reqSource");
%>
<script>
var res_rela_id = "";
$(function(){
	$("._tag_backup___").click(function(){
		hide_taglist();
		tagFunction = null;
	});
	
	//添加标签
	$(".tag_save_btn").click(function(){
		var tagname = $("#tag_txt").val();
		if(!$.trim(tagname)){
			$("#tag_txt").attr("placeholder","请输入标签名称");
			return;
		}
		else
		{
			//如果输入的标签内容超过20个字节则提示信息
		    var char = tagname.match(/[^\x00-\xff]/ig);
			var slength = tagname.length + (char == null ? 0 : char.length);
			if(Number(slength)>20)
			{
				$("#tag_txt").val('');
				$("#tag_txt").attr("placeholder","长度为10个汉字或20个字符");
				return;
			}
		}

		if(!tag_relaType){
			tag_relaType == '<%=relaType%>';
		}
		if(res_rela_id == ""){
			res_rela_id = "<%=relaId%>";
		}
		$.ajax({
		    type: 'post',
		      url: '<%=tagpath%>/modelTag/add',
		      data: {modelId:res_rela_id,tagName:tagname,modelType:tag_relaType},
		      dataType: 'text',
		      success: function(data){
		    	  if(!data){
		    		  alert('添加失败');
		    		  return;
		    	  }
		    	  var d = JSON.parse(data);
		    	  if(!d){
		    		  alert('添加失败');
		    		  return;
		    	  }
		    	  initTagForm();
		    	  $(".tag_list").append('<div class="tag_list_item"><span class="tag_name" key="'+d.rowId+'">'+tagname+'</span><span style="padding: 5px;" onclick="syncDelTags(this)" key="'+d.rowId+'"><img class="del_tag" src="<%=tagpath%>/image/fasdel.png"></span></div>');
		      }
		});
	});
	
	//是否展示已有标签
	if('<%=reqSource%>' == 'resource')
	{
		$("._tag_add_have_").removeClass("none");
		$("._tag_add_have_").find("a").each(function(){
			$(this).click(function(){
				$("#tag_txt").val($(this).html());
			});
		})
	}
});

function initTagForm(){
	$("#tag_txt").val('');
}

var tag_relaType = "";
var tagFunction = null;

function tagjs_choose(tags,relaType,setting){
	if(!setting){
		setting = {};
	}
	tagFunction = setting;
	tag_relaType = relaType;
	
	$(".tag_list").empty();
	if(tags){
		tags.each(function(key,value,index){ 
			if(key == 'res_rela_id'){
				res_rela_id = value;
				return;
			}
			$(".tag_list").append('<div class="tag_list_item"><span class="tag_name" key="'+key+'">'+value+'</span><span style="padding: 5px;" onclick="syncDelTags(this)" key="'+key+'"><img class="del_tag" src="<%=tagpath%>/image/fasdel.png"></span></div>');
		});
	}
	
	$("#tag_div").removeClass("none");
}

function hide_taglist(){
	var tags = new TAKMap();
	$(".tag_name").each(function(){
		var key = $(this).attr("key");
		var val = $(this).html();
		tags.put(key,val);
	});
	if(tagFunction && tagFunction.success){
		tagFunction.success(tags);
	}
	initTagForm();
	$("#tag_div").removeClass("none").addClass("none");
	tagFunction = null;
}

//删除标签
function syncDelTags(obj){
	if(!obj){
		return;
	}
	var id = $(obj).attr("key");
	if(!id){
		return;
	}
	$.ajax({
	    type: 'post',
	      url: '<%=tagpath%>/modelTag/delete',
	      data: {id:id},
	      dataType: 'text',
	      success: function(data){
	    	  if(data && data == 'success'){
	    		  $(obj).parent().remove();
	    	  }else{
	    		  alert('删除标签失败');
	    	  }
	      }
	});
}
</script>

<style>
.none{
	display:none;
}

.tag_list{
	padding:10px;
}
.tag_list_item{
	float:left;
	line-height: 35px;
	padding:0px 5px;
	background-color:#4ECF8F;
	color:#fff;
	margin: 5px;
	border-radius: 5px;
}

#tag_div{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #FFF;
	top: 0px;
	left:0px;
	height: 100%;
	font-size:14px;
}

._tag_backup___{
	background: #D3D5D8; 
	color: #fff; 
	padding:5px 10px;
	text-align: center; 
	border-radius: 10px;
	line-height: 25px;
}

.tag_save_btn{
	background: #338dff; 
	color: #fff; 
	padding:5px 10px; 
	text-align: center;
	border-radius: 10px;
	line-height: 25px;
}

._tag_add_con____{
	border-top:1px solid #ddd;
	margin-top:10px;
}

.del_tag{
	width:20px;
}
</style>

<div id="tag_div" class="none">
	<%--tag --%>
	<div style="width:100%;" class="tag_list">
		<div class="tag_list_item"><span class="tag_name" key="1">标签一</span><span style="padding: 5px;" onclick="syncDelTags(this)" key=""><img class="del_tag" src="<%=tagpath%>/image/fasdel.png"></span></div>
	</div>

	<div style="clear:both;"></div>
	<div class="_tag_add_con____">
		<div class="ui-body-d ui-corner-all info" style="padding: 1em;">
			<textarea name="tag_txt" id="tag_txt" rows="1" cols=""
				placeholder="标签名称" style="border:0px;border-bottom:1px solid #ddd;"></textarea>
			<div style="color: #999; font-size: 12px; text-align: right;">长度为10个汉字或20个字符</div>
		</div>
		<div style="width:100%;text-align:center;">
			<a href="javascript:void(0)" class="_tag_backup___">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:void(0)" class="tag_save_btn">添加</a>
		</div>
	</div>
	<!-- 已有的标签 -->
	<div style="clear:both;"></div>
	<div class="_tag_add_have_ none" style="line-height: 40px;">
		<c:if test="${fn:length(tgNList) > 0}">
		    <img  src="<%=tagpath%>/image/tags_list.png" style="width: 20px;">&nbsp;&nbsp;
			<c:forEach items="${tgNList }" var="tgName">
				<a>${tgName}</a>
			</c:forEach>
		</c:if>
	</div>
</div>