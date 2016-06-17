<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String templatepath = request.getContextPath();
%>
<script src="<%=templatepath%>/scripts/plugin/tmpljs/mustache.js" type="text/javascript"></script>
<script id="helloword_tmpl" type="x-tmpl-mustache">
Hello {{ name }}!
</script>
<script id="ask_sample_tmpl" type="x-tmpl-mustache">
		<div class="chatItem you " style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=templatepath%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									{{ask_sample_label}}
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
</script>
<script id="ask_href_tmpl" type="x-tmpl-mustache">
		<div class="chatItem you modal " style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										    {{ask_href_label}}
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
</script>
<script id="ask_relation_tmpl" type="x-tmpl-mustache">
		<div class="chatItem you customer" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=templatepath%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
							    <input type="hidden" name="currType" />
							    <input type="hidden" name="seachUrl" />
							    <input type="hidden" name="fstChar" />
							    <input type="hidden" name="currPage" value="1" />
							    <input type="hidden" name="pageCount" value="10" />
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									     {{ask_relation_label}}
									</div>
									<div style="clear:both"></div>
									<!-- 字母区域 -->
									<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
									<!-- 上一页-->
									<div class="pre_cus" style="width:100%;text-align:center;display:none;" id="div_prev" >
										<a href="javascript:void(0)" >
											<img  src="<%=templatepath%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content rela_con" hreftype="" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
									<!-- 下一页-->
									<div class="next_cus" style="width:100%;text-align:center;display:none;" id="div_next">
										<a href="javascript:void(0)" >
											<img  src="<%=templatepath%>/image/nextpage.png" width="32px" >
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
</script>
<script id="answer_sample_tmpl" type="x-tmpl-mustache">
		<div class="chatItem me " style="background: #FFF">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="{{answer_headimgurl}}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';">{{answer_label}}</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
</script>