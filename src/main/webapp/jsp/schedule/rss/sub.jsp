<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
$(function(){
	initSpan();
	initButton();
});

//遍历活动流,用户是否订阅
function showSubscribe(obj){
	var type=$(obj).parent().find("input[type=hidden]").val();
	var dataObj=[];
	dataObj.push({name:'openId',value:'${openId}'});
	dataObj.push({name:'publicId',value:'${publicId}'});
	dataObj.push({name:'type',value:type});
	$.ajax({
		url:'<%=path%>/news/isSub',
		type:'post',
		data:dataObj,
		dataType: 'text',
		success:function(data){
			if(!data){
	    		return;
	    	} 
	    	var d = JSON.parse(data);
	    	if(d.errorCode && d.errorCode !== '0'){
	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    		$(".myMsgBox").delay(2000).fadeOut();
    	    	return;
    	    }else{
    	    	var flag = d.errorMsg;
    	    	if(flag=='false'){
    	    		obj.parentNode.getElementsByTagName('input')[0].style.color='green';
    	    		obj.parentNode.getElementsByTagName('input')[0].value='已订阅';
    	    	}
    	    }
		}
	});
}

function initSpan(){
	var divs = $("#feeds > div");
	for(var index = 0; index < divs.length;index++){
		if(divs[index].className.indexOf('rsslist') != -1){
		var spans = divs[index].getElementsByTagName('span');
		for(var i = 0;i < spans.length; i ++){
			var node = document.createElement('input');
			node.type='button';
	    	node.value='订阅';
	    	spans[i].parentNode.insertBefore(node,spans[i]);
			showSubscribe(spans[i]);
			if(spans[i].className != ''){
				spans[i].onclick = function(){
				if(this.className == 'close'){
					this.className = 'open';
					this.parentNode.getElementsByTagName('ul')[0].style.display = 'block';
					this.title = '点击收起列表';
				}else{
					this.className = 'close';
					this.parentNode.getElementsByTagName('ul')[0].style.display = 'none';
					this.title = '点击展开列表';
				}
					}
				}
			}
		}
	}
}

function initButton(){
	var keybtn = $(":button");
	keybtn.click(function(){
		var obj = $(this);
		if(obj.val()=='已订阅'){
			return;
		}
		var dataObj = [];
		dataObj.push({name:'openId',value:'${openId}'});
		dataObj.push({name:'publicId',value:'${publicId}'});
		var flag = obj.attr("flag");
		var word=null;
		var type=null;
		if(flag){
			word = $("input[name=word]").val();
			if(!word){
				$("input[name=word]").attr("placeholder","关键字不能为空,请重新输入!");	
				return;
			}
			word=$("#rssnews:checked").val()+word;
			type="keywords";
		}else{
			word = obj.parent().find("span:first").html();
			type= obj.parent().find(":hidden:first").val();
		}
	 	dataObj.push({name:'content',value:word});
	  	dataObj.push({name:'type',value:type});
	 	 $.ajax({
    		url: '<%=path%>/news/saveRss',
    		type: 'post',
    		data: dataObj,
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	} 
    	    	var d = JSON.parse(data);
    	    	if(d.errorCode && d.errorCode !== '0'){
    	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    		$(".myMsgBox").delay(2000).fadeOut();
	    	    	  	return;
	    	    }else{
	    	    	if(flag){
	    	    		$(".myMsgBox").css("display","") .html("订阅成功!");
    	    			$(".myMsgBox").delay(2000).fadeOut();
    	    			$("input[name=word]").val('');
    	    			$("input[name=word]").attr("placeholder","请输入35个字符以内的字符");
	    	    	}else{
	    	    		obj.attr("value","已订阅");
  		    	    	obj.css("color","green");
  		    	    	obj.unbind("click");
	    	    	}
	    	    }
    	    }
    	});
	});
}

</script>
<style>
	li {
		display: list-item;
		text-align: -webkit-match-parent;
	}
	.rsslist ul li ul{
		margin-left:2em;
	}
	.rsslist ul li{
		margin-top:0.4em;
	}
	.rsslist ul, #focusnews li {
		margin: 0;
		padding: 0;
		list-style: none;
		line-height: 24px;
	}
	table {
		display: table;
		border-collapse: separate;
		border-spacing: 2px;
		border-color: gray;
	}
	TD {
		FONT-FAMILY: arial;
	}
	.rsslist li span {
		font-size: 15px;
		font-weight: bold;
		padding-left: 14px;
	}
	.rsslist input {
		width: 390px;
		cursor: pointer;
		color: #03c;
		border: none;
		border-bottom: 1px solid #03c;
		font-family: arial;
		font-size: 14px;
	}
	#feeds input[type="button"]{
		align-items: flex-start;
		text-align: center;
		cursor: pointer;
		color: buttontext;
		border: 2px outset buttonface;
		border-image-source: initial;
		border-image-slice: initial;
		border-image-width: initial;
		border-image-outset: initial;
		border-image-repeat: initial;
		background-color: buttonface;
		box-sizing: border-box;
		width: 50px;
		float: right;
		padding: 0px 2px 2px 2px;
	}
</style>
</head>
<body style="background-color: #fff;min-height:100%;">
	<div id="site-nav" class="navbar">
		<div style="float: left">
		<a href="<%=path %>/news/list?openId=${openId}&publicId=${publicId}" style="color: #fff;padding:5px;">
			<img src="<%=path %>/image/back.png" width="40px" style="padding:5px;">
		</a>
		</div>
		<h3 style="padding-right:63px;">新闻订阅</h3>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box">
			<h3 class="wrapper">1.关键词订阅</h3>
	        	<div class="search_div" style="padding-top:0px;">
					<div style="float: right;padding: 7px 5px 10px 10px;"> 
						<input type="button" style="box-sizing: border-box;width: 50px;border: 2px outset buttonface;background-color: buttonface;" flag="key" value="订阅">
					</div>
					<div style="line-height: 25px;padding-right:25px;margin-left: 0.9em;">
						<input placeholder="请输入35个字符以内的字符" type="text" size="35" name="word" style="width: 80%"/>
						<p class="uptInput" style="line-height: 25px; padding-top: 10px;">
						    <input type="radio" name="rssnews" id="rssnews" value="" style="width:20px;" checked="checked">新闻全文
							<input type="radio" name="rssnews" id="rssnews" value="title:" style="width:20px;">新闻标题
						</p>
					</div>
				</div>
          		<input type="hidden" value="${openId}" name="openId"> 
          		<input type="hidden" value="${publicId}" name="publicId"> 
				<h3 class="wrapper">2.分类新闻订阅</h3>
				<div id="feeds">
<!-- 					<div style="margin: 1em 1em 0.5em 2em;">分类焦点新闻</div> -->
<!-- 					<div class="rsslist" style="margin-left: 2em;"> -->
<!-- 					<ul style="border:1px solid #ccc;width:580px;padding:4px 6px;"> -->
<!-- 					<li> -->
<!-- 						<span class="close">国内焦点</span> -->
<!-- 			            <input name="text" type="hidden" value="cmd=1&class=civilnews" >   -->
<!-- 			            <input type="button" value="订阅">           -->
<!-- 			            <ul style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>台湾焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=taiwan" > -->
<!-- 							</li> -->
			 
<!-- 							<li> -->
<!-- 								<span>港澳焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=gangaotai" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<span class="close">国际焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=internews" > -->
<!-- 						<ul style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>环球视野焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=hqsy" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>国际人物焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=renwu" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 			        <li> -->
<!-- 						<span class="close">军事焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=mil" > -->
<!-- 						<ul  style="display:none;"> -->
			 
<!-- 							<li> -->
<!-- 								<span>中国军情焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=zhongguojq" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>台海聚焦焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=taihaijj" > -->
<!-- 							</li> -->
			 
<!-- 			                <li> -->
<!-- 								<span>国际军情焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=guojijq" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
			        
<!-- 					<li> -->
<!-- 						<span class="close">财经焦点</span> -->
			 
<!-- 			            <input name="text" type="hidden" value="cmd=1&class=finannews" >             -->
<!-- 			            <ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>股票焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=stock" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>理财焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=money" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>宏观经济焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=hongguan" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>产业经济焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=chanye" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">互联网焦点</span> -->
<!-- 			            <input name="text4" type="hidden" value="cmd=1&class=internet" >             -->
<!-- 			            <ul  style="display:none;"> -->
<!-- 							<li> -->
			 
<!-- 								<span>人物动态焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=rwdt" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>公司动态焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=gsdt" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
			 
<!-- 								<span>搜索引擎焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=search_engine" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>电子商务焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=e_commerce" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
			 
<!-- 								<span>网络游戏焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=online_game" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">房产焦点</span> -->
<!-- 			            <input name="text5" type="hidden" value="cmd=1&class=housenews" >             -->
<!-- 			            <ul style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>各地动态焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=gddt" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>政策风向焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=zcfx" > -->
<!-- 							</li> -->
			 
<!-- 							<li> -->
<!-- 								<span>市场走势焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=shichangzoushi" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>家居焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=fitment" > -->
<!-- 							</li>               -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">汽车焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=autonews" > -->
<!-- 						<ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>新车焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=autobuy" > -->
			 
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>导购焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=daogou" >				</li> -->
<!-- 							<li> -->
<!-- 								<span>各地行情焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=hangqing" > -->
			 
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>维修养护焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=weixiu" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
			 
<!-- 						<span class="close">体育焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=sportnews" > -->
<!-- 						<ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>NBA焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=nba" > -->
<!-- 							</li> -->
<!-- 							<li> -->
			 
<!-- 								<span>国际足球焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=worldsoccer" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>国内足球焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=chinasoccer" > -->
<!-- 							</li> -->
<!-- 							<li> -->
			 
<!-- 								<span>CBA焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=cba" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>综合体育焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=othersports" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
			 
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">娱乐焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=enternews" > -->
<!-- 						<ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>明星焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=star" > -->
			 
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>电影焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=film" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>电视焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=tv" > -->
			 
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>音乐焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=music" > -->
<!-- 							</li> -->
<!-- 			                				<li> -->
<!-- 								<span>综艺焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=zongyi" > -->
			 
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>演出焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=yanchu" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>奖项焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=jiangxiang" > -->
			 
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">游戏焦点</span> -->
<!-- 			            <input name="text" type="hidden" value="cmd=1&class=gamenews" >             -->
<!-- 			            <ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>网络游戏焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=netgames" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>电视游戏焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=tvgames" > -->
<!-- 							</li> -->
<!-- 			                				<li> -->
<!-- 								<span>电子竞技焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=dianzijingji" > -->
<!-- 							</li> -->
<!-- 			                				<li> -->
<!-- 								<span>热门游戏焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=remenyouxi" > -->
<!-- 							</li> -->
<!-- 			                				<li> -->
<!-- 								<span>魔兽世界焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=WOW" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<!-- 					<li> -->
<!-- 						<span class="close">教育焦点</span> -->
<!-- 			            <input name="text" type="hidden" value="cmd=1&class=edunews" >             -->
<!-- 			            <ul  style="display:none;"> -->
<!-- 							<li> -->
			 
<!-- 								<span>考试焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=exams" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>留学焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=abroad" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
			 
<!-- 								<span>就业焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=jiuye" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
				
<!-- 					<li> -->
<!-- 						<span class="close">女人焦点</span> -->
<!-- 			            <input name="text" type="hidden" value="cmd=1&class=healthnews" >             -->
<!-- 			            <ul  style="display:none;"> -->
			 
<!-- 							<li> -->
<!-- 								<span>潮流服饰焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=chaoliufs" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>美容护肤焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=meironghf" > -->
<!-- 							</li> -->
			 
<!-- 			                <li> -->
<!-- 								<span>减肥健身焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=jianfei" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>情感两性焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=qinggan" > -->
<!-- 							</li> -->
			 
<!-- 			                <li> -->
<!-- 								<span>健康养生焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=jiankang" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<span class="close">科技焦点</span> -->
			 
<!-- 						<input type="hidden" value="cmd=1&class=technnews" > -->
<!-- 						<ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>手机焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=cell" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>数码焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=digital" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>电脑焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=computer" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>科普焦点</span> -->
			 
<!-- 								<input type="hidden" value="cmd=1&class=discovery" > -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<span class="close">社会焦点</span> -->
<!-- 						<input type="hidden" value="cmd=1&class=socianews" > -->
<!-- 						<ul  style="display:none;"> -->
<!-- 							<li> -->
<!-- 								<span>社会与法焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=shyf" > -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span>社会万象焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=shwx" > -->
<!-- 							</li> -->
			 
<!-- 							<li> -->
<!-- 								<span>真情时刻焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=zqsk" > -->
<!-- 							</li> -->
<!-- 			                <li> -->
<!-- 								<span>奇闻异事焦点</span> -->
<!-- 								<input type="hidden" value="cmd=1&class=qwys" > -->
<!-- 							</li> -->
			 
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 				  </ul> -->
<!-- 				</div> -->
					<div class="rsslist" style="margin-left: 2em;">
						<ul style="border:1px solid #ccc;margin-right:30px;padding:4px 6px;">
							<li>
								<span class="close" title="点击展开列表">国内最新</span>
								<input name="text1" type="hidden" value="cmd=4&class=civilnews" >            
								<ul style="display: none;margin-left: 2em;">
									<li>
										<span class="close" title="点击收起列表">时政要闻最新</span>
										<input type="hidden"  value="cmd=4&class=shizheng" >
										<ul style="display: none;margin-left: 2em;">
									<li>
										<span>高层动态最新</span>
										<input type="hidden" value="cmd=4&class=gaoceng" >
									</li>
				               </ul>
				                    </li><li>
				 
										<span class="close">台湾最新</span>
										<input type="hidden" value="cmd=4&class=taiwan" >
									<ul  style="display:none;margin-left: 2em;">
									<li>
										<span>历史档案最新</span>
										<input type="hidden" value="cmd=4&class=lishi" >
									</li>
				                    <li>
										<span>台湾民生最新</span>
										<input type="hidden" value="cmd=4&class=twms" >
									</li>
				                </ul>   
				                    </li>
								</ul>
							</li>
							<li>
								<span class="close">国际最新</span>
								<input type="hidden" value="cmd=4&class=internews" >
								<ul  style="display:none;">
									<li>
										<span>环球视野最新</span>
										<input type="hidden" value="cmd=4&class=hqsy" >
									</li>
				                    <li>
										<span>国际人物最新</span>
										<input type="hidden" value="cmd=4&class=renwu" >
									</li>
								</ul>
							</li>
<!-- 				            <li> -->
<!-- 								<span class="close">军事最新</span> -->
<!-- 								<input type="hidden" value="cmd=4&class=mil" > -->
<!-- 								<ul  style="display:none;"> -->
<!-- 									<li> -->
<!-- 										<span>中国军情最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=zhongguojq" > -->
<!-- 									</li> -->
				 
<!-- 				                    <li> -->
<!-- 										<span>台海聚焦最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=taihaijj" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>国际军情最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=guojijq" > -->
<!-- 									</li> -->
				 
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 							<span class="close">财经最新</span> -->
<!-- 				            <input name="text3" type="hidden" value="cmd=4&class=finannews" >             -->
<!-- 				            <ul  style="display:none;margin-left: 2em;"> -->
<!-- 								    <li> -->
<!-- 									<span class="close">股票最新</span> -->
				 
<!-- 									<input type="hidden" value="cmd=4&class=stock" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 										<li> -->
<!-- 											<span>大盘最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=dapan" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>个股最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=gegu" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>新股最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=xingu" > -->
<!-- 										</li> -->
<!-- 				                        <li> -->
<!-- 											<span>权证最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=warrant" > -->
<!-- 										</li> -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">理财最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=money" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
				 
<!-- 										<li> -->
<!-- 											<span>基金最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=fund" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>银行最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=bank" > -->
<!-- 										</li> -->
				 
<!-- 										<li> -->
<!-- 											<span>贵金属最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=nmetal" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>保险最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=insurance" > -->
<!-- 										</li> -->
				 
<!-- 										<li> -->
<!-- 											<span>外汇最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=forex" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>期货最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=futures" > -->
<!-- 										</li>				 -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">宏观经济最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=hongguan"> -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 				                <li> -->
<!-- 									<span>国内最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=hg_guonei" > -->
				 
<!-- 									</li> -->
<!-- 									<li> -->
<!-- 									<span>国际最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=hg_guoji" > -->
<!-- 										</li>				 -->
<!-- 									</ul> -->
<!-- 								</li>	 -->
<!-- 				               <li> -->
<!-- 									<span>产业经济最新</span> -->
				 
<!-- 									<input type="hidden" value="cmd=4&class=chanye" > -->
<!-- 								</li>			  -->
<!-- 					  </ul> -->
<!-- 							</li> -->
								<li>
								<span class="close">互联网最新</span>
								<input name="text4" type="hidden" value="cmd=4&class=internet" >            
								<ul  style="display:none;">
									<li>
										<span>人物动态最新</span>
										<input type="hidden" value="cmd=4&class=rwdt" >
									</li>
									<li>
										<span>公司动态最新</span>
										<input type="hidden" value="cmd=4&class=gsdt" >
									</li>
				                    					<li>
										<span>搜索引擎最新</span>
				 
										<input type="hidden" value="cmd=4&class=search_engine" >
									</li>
				                    					<li>
										<span>电子商务最新</span>
										<input type="hidden" value="cmd=4&class=e_commerce" >
									</li>
				                    					<li>
										<span>网络游戏最新</span>
				 
										<input type="hidden" value="cmd=4&class=online_game" >
									</li>
								</ul>
							</li>
<!-- 							<li> -->
<!-- 								<span class="close">房产最新</span> -->
<!-- 								<input name="text5" type="hidden" value="cmd=4&class=housenews" >             -->
<!-- 								<ul  style="display:none;"> -->
<!-- 									<li> -->
				 
<!-- 										<span>各地动态最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=gddt" > -->
<!-- 									</li> -->
<!-- 									<li> -->
<!-- 										<span>政策风向最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=zcfx" > -->
<!-- 									</li> -->
<!-- 									<li> -->
				 
<!-- 										<span>市场走势最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=shichangzoushi" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>家居最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=fitment" > -->
<!-- 									</li> -->
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span class="close">汽车最新</span> -->
<!-- 								<input type="hidden" value="cmd=4&class=autonews" > -->
<!-- 								<ul  style="display:none;"> -->
<!-- 									<li> -->
<!-- 										<span>新车最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=autobuy" > -->
<!-- 									</li> -->
<!-- 				                    					<li> -->
<!-- 										<span>导购最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=daogou" > -->
<!-- 									</li> -->
<!-- 				                    					<li> -->
<!-- 										<span>各地行情最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=hangqing" > -->
<!-- 									</li> -->
<!-- 				                    					<li> -->
<!-- 										<span>维修养护最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=weixiu" > -->
<!-- 									</li> -->
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 							<span class="close">体育最新</span> -->
<!-- 				            <input name="text3" type="hidden" value="cmd=4&class=sportnews" >             -->
<!-- 				            <ul  style="display:none;margin-left: 2em;"> -->
<!-- 								<li> -->
<!-- 									<span class="close">NBA最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=nba" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 										<li> -->
				 
<!-- 											<span>姚明-火箭最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=yaoming" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>易建联-篮网最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=yijianlian" > -->
<!-- 										</li>				 -->
<!-- 									</ul> -->
				 
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">国际足球最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=worldsoccer" > -->
<!-- 									   <ul  style="display:none;margin-left: 2em;"> -->
<!-- 									   <li> -->
<!-- 											<span>英超最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Yingchao" > -->
				 
<!-- 									   </li> -->
<!-- 										<li> -->
<!-- 											<span>意甲最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Yijia" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>西甲最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Xijia" > -->
				 
<!-- 										</li>		 -->
<!-- 				                        <li> -->
<!-- 											<span>足球明星最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Zq_star" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>曼联最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Manutd" > -->
				 
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>阿森纳最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Arsenal" > -->
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>切尔西最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Chelsea" > -->
				 
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>利物浦最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Liverpool" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>AC米兰最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=ACMilan" > -->
				 
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>国际米兰最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=InterMilan" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>尤文图斯最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Juventus" > -->
				 
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>皇马最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=RealMadrid" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>巴塞罗那最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Barcelona" > -->
				 
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>拜仁最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Bayen" > -->
<!-- 										</li>				 -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">国内足球最新</span> -->
				 
<!-- 									<input type="hidden" value="cmd=4&class=chinasoccer" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 									    <li> -->
<!-- 											<span>男足最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=nanzu" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>女足最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=nvzu" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>中超最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=zhongchao" > -->
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>球迷最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=cn_qiumi" > -->
<!-- 										</li>					 -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">CBA最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=cba" > -->
<!-- 								 <ul  style="display:none;margin-left: 2em;"> -->
<!-- 									    <li> -->
				 
<!-- 											<span>赛事最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=cba_match" >		 -->
<!-- 									</li></ul> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<span class="close">综合体育最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=othersports" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
				 
<!-- 									    <li> -->
<!-- 											<span>排球最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=volleyball" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>乒乓球最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=table-tennis" > -->
<!-- 										</li> -->
				 
<!-- 										<li> -->
<!-- 											<span>羽毛球最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=badminton" > -->
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>田径最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Athletics" > -->
<!-- 										</li>		 -->
<!-- 				                        <li> -->
				 
<!-- 											<span>游泳最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=swimming" > -->
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>体操最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=Gymnastics" > -->
<!-- 										</li> -->
<!-- 				                        <li> -->
				 
<!-- 											<span>网球最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=volleyball" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>赛车最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=F1" > -->
<!-- 										</li> -->
<!-- 				                        <li> -->
				 
<!-- 											<span>拳击最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=boxing" > -->
<!-- 									    </li> -->
<!-- 										<li> -->
<!-- 											<span>台球最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=billiards" > -->
<!-- 										</li>		 -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 									</ul>			</li> -->
<!-- 							<li> -->
<!-- 								<span class="close">娱乐最新</span> -->
<!-- 								<input type="hidden" value="cmd=4&class=enternews" > -->
<!-- 				            <ul  style="display:none;margin-left: 2em;"> -->
<!-- 								<li> -->
<!-- 									<span class="close">明星最新</span> -->
				 
<!-- 									<input type="hidden" value="cmd=4&class=star" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 										<li> -->
<!-- 											<span>爆料最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=star_chuanwen&pn=1" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>港台最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=star_gangtai&pn=1" > -->
<!-- 										</li>	 -->
<!-- 				                        <li> -->
<!-- 											<span>内地最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=star_neidi&pn=1" > -->
<!-- 										</li> -->
<!-- 										<li> -->
<!-- 											<span>欧美最新</span> -->
				 
<!-- 											<input type="hidden" value="cmd=4&class=star_oumei&pn=1" > -->
<!-- 										</li>	 -->
<!-- 				                       <li> -->
<!-- 											<span>日韩最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=star_rihan&pn=1" > -->
<!-- 										</li>			 -->
<!-- 									</ul> -->
<!-- 								</li> -->
<!-- 				                <li> -->
<!-- 									<span class="close">电影最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=film" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 										<li> -->
<!-- 											<span>电影花絮最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=film_huaxu" > -->
<!-- 										</li> -->
<!-- 									</ul> -->
<!-- 								 </li> -->
<!-- 				                <li> -->
<!-- 									<span class="close">电视最新</span> -->
<!-- 									<input type="hidden" value="cmd=4&class=tv" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 										<li> -->
<!-- 											<span>剧评最新</span> -->
<!-- 											<input type="hidden" value="cmd=4&class=tv_jupin"> -->
				 
<!-- 										</li> -->
<!-- 									</ul> -->
<!-- 								 </li> -->
<!-- 								<li> -->
<!-- 										<span>音乐最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=music" > -->
<!-- 									</li>          -->
<!-- 				            				<li> -->
<!-- 										<span>综艺最新</span> -->
				 
<!-- 										<input type="hidden" value="cmd=4&class=zongyi" > -->
<!-- 									</li> -->
<!-- 				            				<li> -->
<!-- 										<span>演出最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=yanchu" > -->
<!-- 									</li> -->
<!-- 										<span>奖项最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=jiangxiang" > -->
<!-- 								</ul> -->
<!-- 							</li>  <li>   -->
				                  
<!-- 								<span class="close">游戏最新</span> -->
<!-- 								<input name="text" type="hidden" value="cmd=4&class=gamenews" >             -->
<!-- 								<ul  style="display:none;margin-left: 2em;"> -->
<!-- 									<li> -->
<!-- 										<span>网络游戏最新</span> -->
				 
<!-- 										<input type="hidden" value="cmd=4&class=netgames" > -->
<!-- 									</li> -->
<!-- 									<li> -->
<!-- 										<span>电视游戏最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=tvgames" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>电子竞技最新</span> -->
				 
<!-- 										<input type="hidden" value="cmd=4&class=dianzijingji" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>热门游戏最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=remenyouxi" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>魔兽世界最新</span> -->
				 
<!-- 										<input type="hidden" value="cmd=4&class=WOW" > -->
<!-- 									</li> -->
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span class="close">教育最新</span> -->
<!-- 								<input name="text" type="hidden" value="cmd=4&class=edunews" >             -->
<!-- 								<ul  style="display:none;margin-left: 2em;">	 -->
<!-- 								  <li> -->
				 
<!-- 										<span class="close">考试最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=exams" > -->
<!-- 								  <ul  style="display:none;margin-left: 2em;">	 -->
<!-- 				                  <li> -->
<!-- 										<span>中考最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=zhongkao" > -->
<!-- 									</li> -->
<!-- 									<li> -->
				 
<!-- 										<span>高考最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=gaokao" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>考研最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=kaoyan" > -->
<!-- 									</li> -->
<!-- 									<li> -->
				 
<!-- 										<span>公务员考试最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=gongwuyuan" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>资格考试最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=zigekaoshi" > -->
<!-- 										</li> -->
<!-- 									</ul> -->
				 
<!-- 								</li> -->
<!-- 									<li> -->
<!-- 										<span>留学最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=abroad" > -->
<!-- 				                    </li> -->
<!-- 				                    <li> -->
<!-- 										<span>就业最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=jiuye" > -->
				 
<!-- 									</li> -->
				 
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<span class="close">女人最新</span> -->
<!-- 								<input name="text" type="hidden" value="cmd=4&class=healthnews" >             -->
<!-- 								<ul  style="display:none;margin-left: 2em;"> -->
<!-- 									<li> -->
				 
<!-- 										<span class="close">潮流服饰最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=chaoliufs" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 									<li> -->
<!-- 										<span>女性职场最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=nvrentx" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
				 
<!-- 										<span>型男时尚最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=xingnanss" > -->
<!-- 									</li> -->
<!-- 				                   </ul> -->
<!-- 								</li> -->
				                
<!-- 									<li> -->
<!-- 										<span class="close">美容护肤最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=meironghf" > -->
				 
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 				                    <li> -->
<!-- 										<span>亲子母婴最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=qinzimy" > -->
<!-- 									</li> -->
<!-- 									<li> -->
<!-- 										<span>婚嫁新人最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=hunjia" > -->
				 
<!-- 									</li> -->
<!-- 				                   </ul> -->
<!-- 								</li> -->
				                
<!-- 				                    <li> -->
<!-- 										<span>减肥健身最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=jianfei" > -->
<!-- 									</li> -->
				                    
<!-- 									<li> -->
				 
<!-- 										<span class="close">情感两性最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=qinggan" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
				                    
<!-- 				                    <li> -->
<!-- 										<span>星座最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=xingzuo"> -->
<!-- 									</li> -->
				 
<!-- 				                   </ul> -->
<!-- 								</li> -->
<!-- 				                     <li> -->
<!-- 										<span class="close">健康养生最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=jiankang" > -->
<!-- 									<ul  style="display:none;margin-left: 2em;"> -->
<!-- 									<li> -->
<!-- 										<span>美食健康最新</span> -->
				 
<!-- 										<input type="hidden" value="cmd=4&class=meishijk" > -->
<!-- 									</li> -->
<!-- 				                    <li> -->
<!-- 										<span>保健养生最新</span> -->
<!-- 										<input type="hidden" value="cmd=4&class=baojian" > -->
<!-- 									</li> -->
<!-- 				                   </ul> -->
<!-- 								</li> -->
<!-- 				                          </ul> -->
<!-- 								</li> -->
							<li>
								<span class="close">科技最新</span>
								<input name="text" type="hidden" value="cmd=4&class=technnews" >
								<ul  style="display:none;margin-left: 2em;">
									<li>
										<span class="close">手机最新</span>
				 
										<input type="hidden" value="cmd=4&class=cell" >
									<ul  style="display:none;margin-left: 2em;">
				                    <li>
										<span>手机新品最新</span>
										<input type="hidden" value="cmd=4&class=cell_xinpin">
									</li>
									<li>
										<span>手机导购最新</span>
				 
										<input type="hidden" value="cmd=4&class=cell_daogou" >
									</li>
									<li>
										<span>手机行情最新</span>
										<input type="hidden" value="cmd=4&class=cell_hangqing" >
										</li>
									</ul>
								</li>
									<li>
										<span class="close">数码最新</span>
										<input type="hidden" value="cmd=4&class=digital" >
									<ul  style="display:none;margin-left: 2em;">
				                    <li>
				                    <span>数码新品最新</span>
										<input type="hidden" value="cmd=4&class=digital_xinpin" >
									</li>
				 
									<li>
										<span>数码导购最新</span>
										<input type="hidden" value="cmd=4&class=digital_daogou" >
									</li>
									<li>
										<span>数码行情最新</span>
										<input type="hidden" value="cmd=4&class=digital_hq" >
									</li>
				 
								</ul>
							</li>
									<li>
										<span class="close">电脑最新</span>
										<input type="hidden" value="cmd=4&class=computer" >
									<ul  style="display:none;margin-left: 2em;">
				                     <li>
				                    <span>电脑新品最新</span>
										<input type="hidden" value="cmd=4&class=comp_xinpin" >
									</li>
									<li>
										<span>电脑导购最新</span>
										<input type="hidden" value="cmd=4&class=comp_daogou" >
									</li>
									<li>
										<span>电脑行情最新</span>
										<input type="hidden" value="cmd=4&class=comp_hangqing" >
									</li>
								</ul>
							</li>
									<li>
										<span>科普最新</span>
										<input type="hidden" value="cmd=4&class=discovery" >
									</li>
				 
								</ul>
							</li>
							<li>
							<span class="close" title="点击展开列表">社会最新</span>
							<input type="hidden" value="cmd=4&class=socianews" >
							<ul style="display: none;margin-left: 2em;">
								<li>
									<span>社会与法最新</span>
			 
									<input type="hidden" value="cmd=4&class=shyf" >
								</li>
								<li>
									<span>社会万象最新</span>
									<input type="hidden" value="cmd=4&class=shwx" >
								</li>
								<li>
									<span>真情时刻最新</span>
			 
									<input type="hidden" value="cmd=4&class=zqsk" >
								</li>
			                   <li>
									<span>奇闻异事最新</span>
									<input type="hidden" value="cmd=4&class=qwys" >
								</li>
							</ul>
						</li>
						</ul>
				 	 </div>
				</div>
<!-- 			<h3 class="wrapper">3.地区新闻订阅</h3> -->
<!-- 			<div> -->
<!-- 			   <table> -->
<!-- 		        <tbody> -->
<!--        			 <tr> -->
<!--         		 	 <td width="80%;" > -->
<!--         		  		<select style="margin-left: 30px;margin-right:50px;">  -->
<!-- 			              <option value="cmd=7&loc=0&name=%B1%B1%BE%A9" selected="">北京</option>  -->
<!-- 			              <option value="cmd=7&loc=2354&name=%C9%CF%BA%A3">上海</option>  -->
<!-- 			              <option value="cmd=7&loc=125&name=%CC%EC%BD%F2">天津</option>  -->
<!-- 			              <option value="cmd=7&loc=6425&name=%D6%D8%C7%EC">重庆</option>  -->
<!-- 			              <option value="cmd=7&loc=5495&name=%B9%E3%B6%AB">广东</option>  -->
<!-- 			              <option value="cmd=7&loc=250&name=%BA%D3%B1%B1">河北</option>  -->
<!-- 			              <option value="cmd=7&loc=1481&name=%C1%C9%C4%FE">辽宁</option>  -->
<!-- 			              <option value="cmd=7&loc=1783&name=%BC%AA%C1%D6">吉林</option>  -->
<!-- 			              <option value="cmd=7&loc=8534&name=%B8%CA%CB%E0">甘肃</option>  -->
<!-- 			              <option value="cmd=7&loc=812&name=%C9%BD%CE%F7">山西</option>  -->
<!-- 			              <option value="cmd=7&loc=6692&name=%CB%C4%B4%A8">四川</option>  -->
<!-- 			              <option value="cmd=7&loc=8205&name=%C9%C2%CE%F7">陕西</option>  -->
<!-- 			              <option value="cmd=7&loc=4371&name=%BA%D3%C4%CF">河南</option>  -->
<!-- 			              <option value="cmd=7&loc=3996&name=%C9%BD%B6%AB">山东</option>  -->
<!-- 			              <option value="cmd=7&loc=5161&name=%BA%FE%C4%CF">湖南</option>  -->
<!-- 			              <option value="cmd=7&loc=4811&name=%BA%FE%B1%B1">湖北</option>  -->
<!-- 			              <option value="cmd=7&loc=3636&name=%BD%AD%CE%F7">江西</option>  -->
<!-- 			              <option value="cmd=7&loc=2493&name=%BD%AD%CB%D5">江苏</option>  -->
<!-- 			              <option value="cmd=7&loc=2809&name=%D5%E3%BD%AD">浙江</option>  -->
<!-- 			              <option value="cmd=7&loc=3072&name=%B0%B2%BB%D5">安徽</option>  -->
<!-- 			              <option value="cmd=7&loc=3372&name=%B8%A3%BD%A8">福建</option>  -->
<!-- 			              <option value="cmd=7&loc=5886&name=%B9%E3%CE%F7">广西</option>  -->
<!-- 			              <option value="cmd=7&loc=7230&name=%B9%F3%D6%DD">贵州</option>  -->
<!-- 			              <option value="cmd=7&loc=9337&name=%CF%E3%B8%DB">香港</option>  -->
<!-- 			              <option value="cmd=7&loc=9436&name=%B0%C4%C3%C5">澳门</option>  -->
<!-- 			              <option value="cmd=7&loc=6245&name=%BA%A3%C4%CF">海南</option>  -->
<!-- 			              <option value="cmd=7&loc=9442&name=%CC%A8%CD%E5">台湾</option>  -->
<!-- 			              <option value="cmd=7&loc=7527&name=%D4%C6%C4%CF">云南</option>  -->
<!-- 			              <option value="cmd=7&loc=1167&name=%C4%DA%C3%C9%B9%C5">内蒙古</option>  -->
<!-- 			              <option value="cmd=7&loc=8782&name=%C7%E0%BA%A3">青海</option>  -->
<!-- 			              <option value="cmd=7&loc=8907&name=%C4%FE%CF%C4">宁夏</option>  -->
<!-- 			              <option value="cmd=7&loc=9001&name=%D0%C2%BD%AE">新疆</option>  -->
<!-- 			              <option value="cmd=7&loc=7915&name=%CE%F7%B2%D8">西藏</option>  -->
<!-- 			              <option value="cmd=7&loc=1967&name=%BA%DA%C1%FA%BD%AD">黑龙江</option> -->
<!-- 			             </select>  -->
<!--           			</td> -->
<!--           			<td> -->
<!-- 	          			<div class="search_div" style="padding-top:0px;"> -->
<!-- 							<div style="float: right;padding-top:7px;padding-right:10px;padding-bottom:10px;padding-left:150px;">  -->
<!-- 								<input type="button" style="border: 2px outset buttonface;background-color: buttonface;" value="订阅"> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!--           			</td> -->
<!--           		</tr> -->
<!--           	</tbody> -->
<!--           </table> -->
<!--          </div> -->
		</div>
	</div>
	<br><br><br><br>
<jsp:include page="/common/footer.jsp"></jsp:include>
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>