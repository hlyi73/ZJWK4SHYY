<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String templatepath = request.getContextPath();
%>
<link rel="stylesheet" href="<%=templatepath%>/css/acttemp/tplist.css">
<Script>
	$(function() {
		$(".template_list").click(function() {
			$(".template_list").each(function() {
				$(this).removeClass("t_selected");
			});
			$(this).addClass("t_selected");
		});
	});
</Script>
<!-- temp01 -->
<div class="template_list t_selected h180">
	<div class="section table active temp01" data-anchor="page1">
		<div class="tableCell">
			<div contenteditable="false" class="dragDiv temp01-e1">
				<span class="temp01-e1-con">公司简介</span>
			</div>
			<div class="temp01-e2">
				<img class="element temp01-e2-con"
					src="http://res.eqxiu.com/group1/M00/C5/9D/yq0KA1SH1zuAFgkLAAAFgBR8hJs456.png">
			</div>
			<div contenteditable="false" class="dragDiv temp01-e3">
				<span class="temp01-e3-con">百度（Nasdaq简称：BIDU）是全球最大的中文搜索引擎，2000年1月由李彦宏、徐勇两人创立于北京中关村，
					致力于向人们提供“简单，可依赖”的信息获取方式。“百度”二字源于中国宋朝词人辛弃疾的《青玉案·元夕》词句“众里。 </span>
			</div>
		</div>
	</div>
</div>
<!-- temp02 -->
<div class="template_list h380">
	<div class="section table temp02" data-anchor="page2">
		<div class="tableCell">
			<div class="temp02-e1 dragDiv " contenteditable="false">
				<span class="temp02-e1-con">No</span>
			</div>
			<div class="temp02-e2 dragDiv " contenteditable="false">
				<span class="temp02-e2-con">DO WHAT YOU WANT</span>
			</div>
			<div class="temp02-e3 dragDiv" contenteditable="false">
				<span class="temp02-e3-con">Hey What do
				you want if you have superpower if i am omnipotent for a day i want
				world peacelook !!!the entire city is totally black outcan i borrow
				your phoneI want to call my apartment check onWhat 's my number</span>
			</div>
		</div>
	</div>
</div>
<!-- temp03 -->
<div class="template_list h280">
	<div class="section table temp03" data-anchor="page3">
		<div class="tableCell" >
			<div class="temp03-e1">
				<div class="dragDiv " contenteditable="false">
					<span class="temp03-e1-con">银杏叶的秋天</span>
				</div>
				<div class="dragDiv " contenteditable="false">
					<span class="temp03-e1-con2">- 欧洲古典旅行巡礼 -</span>
				</div>
			</div>
			<div class="temp03-e2">
				<div class=" dragDiv" contenteditable="false">
					<span class="temp03-e2-con">-遇见最美地中海秋色旅行... 畅享北欧银杏夜莺森林歌舞聚会...</span>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- temp04 -->
<div class="template_list h300">
	<div class="section table temp04" data-anchor="page4">
		<div class="tableCell">
			<div class="temp04-e1">
				<div class=" dragDiv" contenteditable="false">
					<span class="temp04-e1-con">曾经沧海难为水</span>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 脚 -->
<div class="flooter actfter">
	<a class="btn btn-block actfter_btn selecttemplate">确定</a>
</div>