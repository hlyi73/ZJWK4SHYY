<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-cn" class="no-js">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Content-Type">
		<meta content="text/html; charset=utf-8">
		<meta charset="utf-8">
		<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
		<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
		<meta name="format-detection" content="telephone=no">
		<meta name="format-detection" content="email=no">
		<link rel="stylesheet" type="text/css" href="<%=path %>/scripts/plugin/zepto/css/reset.css">
		<link rel="stylesheet" type="text/css" href="<%=path %>/css/guide.css">
		<link rel="stylesheet" type="text/css" href="<%=path %>/scripts/plugin/zepto/css/animations.css">
		
		<script src="<%=path %>/scripts/plugin/zepto/zepto.min.js"></script>
		<script src="<%=path %>/scripts/plugin/zepto/touch.js"></script>
		<style>
		.flooter
		{
			text-align: center;
			color:Yellow;
			vertical-align: middle;
			font-size: 20px;
			z-index: 999px;
			left: 0px;
			position: fixed;
			bottom: 0;
			width: 100%;
			z-index: 9999;
			opacity: .90;
			filter: alpha(opacity=90);
			_bottom: auto;
			_width: 100%;
			_position: absolute;
			overflow: hidden;
			_top: expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight-this.offsetHeight- (parseInt(this.currentStyle.marginTop, 10)||0)-(parseInt(this.currentStyle.marginBottom, 10)||0)));
		}
		
		.selected{float:left;background-color:#eee;border-radius:5px;width:10px;height:10px;line-height:10px;margin-left:10px;}
		.noselected{float:left;background-color:#999;border-radius:5px;width:10px;height:10px;line-height:10px;margin-left:10px;}
		
		</style>
		<script>
		$(function(){
		    var colSize = "${vcSize}";
			var now = { row:1, col:1 }, last = { row:0, col:0};
			const towards = { up:1, right:2, down:3, left:4};
			var isAnimating = false;

			s=window.innerHeight/$(window).height();
			ss=250*(1-s);
			$('.wrap').css('-webkit-transform','scale('+s+','+s+') translate(0px,-'+ss+'px)');

			document.addEventListener('touchmove',function(event){
				event.preventDefault(); },false);

			/*$(document).swipeUp(function(){
				if (isAnimating) return;
				last.row = now.row;
				last.col = now.col;
				if (last.row != 5) { now.row = last.row+1; now.col = 1; pageMove(towards.up);}	
			})

			$(document).swipeDown(function(){
				if (isAnimating) return;
				last.row = now.row;
				last.col = now.col;
				if (last.row!=1) { now.row = last.row-1; now.col = 1; pageMove(towards.down);}	
			})*/

			$(document).swipeLeft(function(){
				if (isAnimating) return;
				last.row = now.row;
				last.col = now.col;
				
				if (last.row==1 && last.col<colSize) { 
					now.row = last.row; now.col = last.col+1; 
					pageMove(towards.left);
					$(".navdiv").each(function(){
						$(this).removeClass("selected");
						$(this).addClass("noselected");
					});
					$(".nav_"+now.col).removeClass("noselected").addClass("selected");
				}	
			})

			$(document).swipeRight(function(){
				if (isAnimating) return;
				last.row = now.row;
				last.col = now.col;
				
				if (last.row==1 && last.col >1 ) { 
					now.row = last.row; now.col = last.col-1; 
					pageMove(towards.right);
					$(".navdiv").each(function(){
						$(this).removeClass("selected");
						$(this).addClass("noselected");
					});
					$(".nav_"+now.col).removeClass("noselected").addClass("selected");
				}	
			})

			function pageMove(tw){
				var lastPage = ".page-"+last.row+"-"+last.col,
					nowPage = ".page-"+now.row+"-"+now.col;
				
				switch(tw) {
					case towards.up:
						outClass = 'pt-page-moveToTop';
						inClass = 'pt-page-moveFromBottom';
						break;
					case towards.right:
						outClass = 'pt-page-moveToRight';
						inClass = 'pt-page-moveFromLeft';
						break;
					case towards.down:
						outClass = 'pt-page-moveToBottom';
						inClass = 'pt-page-moveFromTop';
						break;
					case towards.left:
						outClass = 'pt-page-moveToLeft';
						inClass = 'pt-page-moveFromRight';
						break;
				}
				isAnimating = true;
				$(nowPage).removeClass("hide");
				
				$(lastPage).addClass(outClass);
				$(nowPage).addClass(inClass);
				
				setTimeout(function(){
					$(lastPage).removeClass('page-current');
					$(lastPage).removeClass(outClass);
					$(lastPage).addClass("hide");
					$(lastPage).find("img").addClass("hide");
					
					$(nowPage).addClass('page-current');
					$(nowPage).removeClass(inClass);
					$(nowPage).find("img").removeClass("hide");
					
					isAnimating = false;
				},600);
			}

			});
		</script>
	</head>
	<body>
		<div>
			<c:forEach items="${vcList}" var="ver" varStatus="stat">
				<c:if test="${stat.index == 0 }">
					<div class="page page-1-${stat.index+1} page-current">
				</c:if>
				
				<c:if test="${stat.index > 0 }">
					<div class="page page-1-${stat.index+1} hide">
				</c:if>
				
				<div class="wrap">
					<img class="img_${stat.index+1} " src="<%=path%>/sharefiles/vers?fileName=${ver.imgurl}" style="margin-top:10px;">
					<%--<div style="width:100%;font-size:16px;color:#fff;">
						${ver.content }
					</div> --%>
					<c:if test="${stat.index == vcSize-1 }">
						<div class="flooter" style="width:100%;margin-bottom:30px;">
							<a href="<%=path %>/home/index" style="background-color:green;color:#fff;height:50px;line-height:50px;text-align:center;font-size:18px;padding:10px 20px 10px 20px;font-family: 'Microsoft YaHei';border: 1px solid #efefef;">马上体验</a>
						</div>
					</c:if>
				</div>
				</div>
			</c:forEach>
			
			<div class="flooter" style="left:50%;margin-bottom:100px;margin-left:-35px;">
		      	<c:forEach items="${vcList}" var="ver" varStatus="stat">
		      		<c:if test="${stat.index == 0 }">
						<div class="navdiv nav_${stat.index+1} selected">&nbsp;</div>
					</c:if>
					<c:if test="${stat.index > 0 }">
						<div class="navdiv nav_${stat.index+1} noselected">&nbsp;</div>
					</c:if>
				</c:forEach>
		     </div>
</body></html>