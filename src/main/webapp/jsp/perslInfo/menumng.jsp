<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs2.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css"/>
<script type="text/javascript">
	$(function(){
		loadSelmenu();
		loadAllmenu();
		saveSelMenu();
	});
	
	function loadSelmenu(){
		$.ajax({
			url:"<%=path%>/urperf/urperflist",
			async: false,
		 	success: function(data){
		 		if(data){
		 			var data = JSON.parse(data);
		 			$(data).each(function(){
		 				var c = this.contents;
		 				if(c){
		 					var ar = c.split(",");
		 					for(var i = 0 ; i < ar.length ; i++){
		 						if(ar[i]){
		 							var ar01 = ar[i].split("|");
			 						var h = '';
					 				h += '<div class="mitem" style="float: left;border: 1px solid #C2BABA">';
					 				h += '	<div class="val" mid="'+ar01[0]+'"  mimage="'+ar01[2]+'" mlink="'+ar01[3]+'">'+ar01[1]+'</div><div class="subitem">-</div>';
					 				h += '</div>';
			 						$(".seletedmenucon").append(h);	
			 						subItem();
		 						}
		 					}
		 				}
		 			});
		 		}
    	    }
		});
	}
	
	function loadAllmenu(){
		$.ajax({
			url:"<%=path%>/urperf/menulist",
			data: {type: 'menu'},
		 	success: function(data){
		 		if(data){
		 			var data = JSON.parse(data);
		 			$(data).each(function(){
		 				var h = '';
		 				h += '<div class="mitem" style="float: left;border: 1px solid #C2BABA">';
		 				h += '	<div class="val" mid="'+this.menu_id+'" mimage="'+this.menu_image+'" mlink="'+this.menu_link+'">'+this.menu_name+'</div><div class="additem">+</div>';
		 				h += '</div>';
		 				if(!jdExst(this.menu_id)){
		 					$(".allmenucon").append(h);
		 				}
		 			});
		 			addItem();
		 		}
    	    }
		});
	}
	
	function saveSelMenu(){
		$("input[name=btnsave]").click(function(){
			var h = '';
			var parentid = '${parentid}';
			$(".seletedmenucon .mitem").each(function(){
				var o = $(this).find(".val");
				var mid = o.attr("mid");
				var mimage = o.attr("mimage");
				var mlink = o.attr("mlink");
				var mv = o.html();
				h += mid + "|" + mv + "|" + mimage + "|" + mlink + "|" + parentid +',';
			});
			if(!h){
				alert('请选择菜单');
			}
			//保存关联关系
			$.ajax({
				url:"<%=path%>/urperf/savemenuurperf",
				data: {
					contents: h
				},
			 	success: function(data){
			 		if(data === 'success'){
			 			alert('保存成功');
			 			window.location.reload();
			 		}else{
			 			alert('保存失败');
			 		}
	    	    }
			});
			
		});
	}
	
	function addItem(){
		//添加项目
		$(".allmenucon .additem").unbind("click").bind("click", function(){
			var o = $(this).siblings(".val");
			var mid = o.attr("mid");
			var mimage = o.attr("mimage");
			var mlink = o.attr("mlink");
			var mv = o.html();
			$(this).parent().remove();
			var h = '';
				h += '<div class="mitem" style="float: left;border: 1px solid #C2BABA">';
				h += '	<div class="val" mid="'+mid+'" mimage="'+mimage+'" mlink="'+mlink+'">'+mv+'</div><div class="subitem">-</div>';
				h += '</div>';
			$(".seletedmenucon").append(h);	
			subItem();
		});
	}
	function subItem(){
		//减少项目
		$(".seletedmenucon .subitem").unbind("click").bind("click", function(){
			var o = $(this).siblings(".val");
			var mid = o.attr("mid");
			var mimage = o.attr("mimage");
			var mlink = o.attr("mlink");
			var mv = o.html();
			$(this).parent().remove();
			var h = '';
				h += '<div class="mitem" style="float: left;border: 1px solid #C2BABA">';
				h += '	<div class="val" mid="'+mid+'" mimage="'+mimage+'" mlink="'+mlink+'">'+mv+'</div><div class="additem">+</div>';
				h += '</div>';
			$(".allmenucon").append(h);	
			addItem();
		});
	}
	
	function jdExst(mid){
		if($(".seletedmenucon .val[mid="+mid+"]").length > 0) return true;
		else return false;
	}

</script>

</head>
<body>
	<div id="site-nav" class="navbar" style="background-color:RGB(75, 192, 171);width: 100%;">
		<jsp:include page="/common/back.jsp"/>
		<h3 style="padding-right:45px;">自定义菜单</h3>
	</div>
	<div class="menulabeltitle"><span class="val">已选菜单</span></div>
    <div class="seletedmenucon"></div>
	<div style="clear: both;"></div>
	<div class="menulabeltitle"><span class="val">可选菜单</span></div>
	<div class="allmenucon" ></div>
	<div style="clear: both;"></div>
	<div class="menusubmitdiv">
		<input name="btnsave" type="button" value="保存" class="menusubmitbtn btn" />
	</div>
</body>
</html>