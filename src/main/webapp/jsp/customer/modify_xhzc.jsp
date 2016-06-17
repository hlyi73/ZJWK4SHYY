<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<!-- 百度地图API -->
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=134eca242394acd37ffbae329150e589"></script>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
    function getCustomerMap(addr){
    	if(!addr){
    		return;
    	}
    	$(".shade").css("display","");
    	var screenHeight = $(window).height();
    	$("#custmap").css("height",screenHeight-100);
    	$("#custmap").css("top",50 + $(document).scrollTop());
    	$("#custmap").css("display","");
    	// 百度地图API功能
		var map = new BMap.Map("custmap");
		var point = new BMap.Point(116.331398,39.897445);
		map.centerAndZoom(point,12);
		// 创建地址解析器实例
		var myGeo = new BMap.Geocoder();
		// 将地址解析结果显示在地图上,并调整地图视野
		myGeo.getPoint(addr, function(point){
			 if (point) {
				 map.centerAndZoom(point, 16);
				 map.addOverlay(new BMap.Marker(point));
				 var opts = {
					width : 200,     // 信息窗口宽度
					height: 60,     // 信息窗口高度
					title : "${sd.name}" //, // 信息窗口标题
					//enableMessage:true,//设置允许信息窗发送短息
					//message:"客户的地址是XXXX~"
				 };
				
				var infoWindow = new BMap.InfoWindow("地址："+addr, opts);  // 创建信息窗口对象
				map.openInfoWindow(infoWindow,point); //开启信息窗口
				
			}
		}, "");
    }	
    
    function gotoWebsite(website){
    	if(!website){
    		return;
    	}
    	if(website.indexOf("http://") == -1){
    		website = "http://"+website;
    	}
    	window.location.href= website;
    }
</script>
<script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    	initButton();
    	
    	$(".shade").click(function(){
    		$(".shade").css("display","none");
    		$("#custmap").css("display","none");
    	});
    	
    	empty("hide");
    	
		//初始化标签控件
		//品牌标签
    	$(".brand_tag").click(function(){
    		var tagMap = new TAKMap();
    		$(".brand_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'brand_tag',{
        		success: function(res){
        			if(res){
        				$(".brand_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".brand_tag").append('<a class="brand_tag_item" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        			}
        		}
        	});
    	});
		
    	//销售区域标签
    	$(".salesregions_tag").click(function(){
    		var tagMap = new TAKMap();
    		$(".salesregions_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'salesregions_tag',{
        		success: function(res){
        			if(res){
        				$(".salesregions_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".salesregions_tag").append('<a class="salesregions_tag_item" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        			}
        		}
        	});
    	});
    	
    	//客户群体标签
    	$(".customer_tag").click(function(){
    		var tagMap = new TAKMap();
    		$(".customer_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'customer_tag',{
        		success: function(res){
        			if(res){
        				$(".customer_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".customer_tag").append('<a class="customer_tag_item" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        			}
        		}
        	});
    	});
    	//主营产品标签
    	$(".product_tag").click(function(){
    		var tagMap = new TAKMap();
    		$(".product_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'product_tag',{
        		success: function(res){
        			if(res){
        				$(".product_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".product_tag").append('<a class="product_tag_item" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        			}
        		}
        	});
    	});
    	//行业标签
    	/* $(".industry_tag").click(function(){
    		var tagMap = new TAKMap();
    		$(".industry_tag_item").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'industry_tag',{
        		success: function(res){
        			if(res){
        				$(".industry_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".industry_tag").append('<a class="industry_tag_item" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;');
        				});
        			}
        		}
        	});
    	}); */
    	
    	//$(".allShow").css("display",""); 
		//end
    	//选择责任人
    	$("input[name=assigner]").click(function(){
    		//var cid = $(".detailContainer :hidden[name=parentId]").val();
    		//var ctype = "Users";
    		userjs_choose({
        		success: function(res){
        			$(":hidden[name=assignerid]").val(res.key);
        			$("input[name=assigner]").val(res.val);
        			$("input[name=optype]").val("allot");
        		}
        	});
    	});
    	
	});
    
  //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
    //初始化按钮
    function initButton(){
    	$(".morebtn").click(function(){
    		$(".morebtn").css("display","none");
    		$(".more").css("display","");
    	});
    	
    	//修改按钮
    	$(".operbtn").click(function(){
    		$(".operbtn").css("display","none");
    		$("#update").css("display","none");
    		$(".nextCommitExamDiv").css("display","");
    		$(".uptShow").css("display","none");
    		//$(".allShow").css("display","");
    		$(".uptInput").css("display","");
    		$(".more").css("display","");
    		$("#more_alink").css("display","none");
    		empty("show");
    		
    		//控制标签添加删除按钮显示
    		//$(".info")
    	});
    	
    	//取消按钮
    	$(".canbtn").click(function(){
    		$(".operbtn").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$("#update").css("display","");
    		$(".uptShow").css("display","");
    		$(".uptInput").css("display","none");
    		$(".more").css("display","none");
    		$("#more_alink").css("display","");
    	});
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		$(":hidden[name=dateclosed]").val($("#bxDateInput").val());
    		$(":hidden[name=nextstep]").val($("#nextStep").val());
    		$(":hidden[name=desc]").val($("#expDesc").val());
    		$(":hidden[name=modifyDate]").val(new Date());
    		
    		
    		//客户名称必填
    		var cust_name = $("input[name=name]").val();
    		if (cust_name == "")
    		{
    			$("input[name=name]").attr("placeholder","客户名称必填");
    			return;
    		}
    		$("form[name=customerModify]").submit();
    	});
    	
    	//是否显示修改按钮 2015-04-24修改  上级和自己可以修改
    	var assignerid = '${sd.assignerid}';
    	if('${crmId}'==assignerid ||'Y'== '${sd.authority}'){
    		$(".operbtn").css("display","");
    		$(".cust_oper_modify").css("display","");
    	}
    	
    }
    
    
    //修改客户类型
    function updateAccnttypename(){
    	var value = $("select[name=accnttypenameSel]").val();
    	$(":hidden[name=accnttype]").val(value);
    }
    
    //修改行业
    function updateIndustryname(){
    	var value = $("select[name=industrynameSel]").val();
    	$(":hidden[name=industry]").val(value);
    }
    
    //修改客户性质
    function updateNaturename(){
    	var value = $("select[name=naturenameSel]").val();
    	$(":hidden[name=nature]").val(value);
    }
    
  //修改客户来源
    function updateSourcename(){
    	var value = $("select[name=sourcenameSel]").val();
    	$(":hidden[name=source]").val(value);
    }
    
    //修改市场活动
    function updateCampaigns(){
    	var value = $("select[name=campaignsSel]").val();
    	$(":hidden[name=campaigns]").val(value);
    }
    
    function goBack(){
    	window.location.href = "<%=path%>/customer/detail?rowId=${rowId}&orgId=${sd.orgId}";
    }
    
    function empty(type){
    	$(".site-card-view").find("tr").each(function(){
    		var v = $(this).find(".uptShow").html();
    		v = trim(v);
    		if(!v && type === "hide"){
    			$(this).css("display", "none");
    		}else{
    			$(this).css("display", "");
    		}
    	});
    }
    
    function trim(v){ 
    	if(v){
    		return v.replace(/(^\s*)|(\s*$)/g, "");	
    	}else{
    		return "";
    	}
    }  
    
    //删除实体对象
    function delCustomer(){
    	if(!confirm("确定删除吗?")){
			return;
		}
	  	$.ajax({
    		url: '<%=path%>/customer/delCustomer',
    		type: 'post',
    		data: {rowid:'${sd.rowid}',optype:'del'},
    		dataType: 'text',
    	    success: function(data){
    	    	var d = JSON.parse(data);
    	    	if(d.errorCode&&d.errorCode!='0'){
    	    		$(".myMsgBox").css("display","").html(d.errorMsg());
				    $(".myMsgBox").delay(2000).fadeOut();
					return;
    	    	}
    	    	window.parent.location.replace("<%=path%>/customer/acclist");
    	    }
    	});
    }
    </script>
</head>
<body>
	<div class="cust_oper_modify  zjwk_fg_nav" style="display:none;">
		<c:if test="${sd.orgId ne 'Default Organization'}">
			<a href="javascript:void(0)" class="operbtn" style="font-size: 14px;padding: 0px 10px 0px 10px;">修改</a>&nbsp;&nbsp;
		</c:if>
		<c:if test="${sd.orgId eq 'Default Organization'}">
			<a href="javascript:void(0)" class="operbtn" style="font-size: 14px;padding: 0px 10px 0px 10px;">修改</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="_importbtn" style="font-size: 14px; padding: 0px 10px 0px 10px;">导入</a>&nbsp;&nbsp;
			<jsp:include page="/common/orglist.jsp">
				<jsp:param value="${sd.orgId }" name="sourceOrgId"/>
				<jsp:param value="${sd.rowid}" name="parentid"/>
				<jsp:param value="Accounts" name="parenttype"/>
			</jsp:include>
		</c:if>
		<a onclick="delCustomer()" class="delAcc" style="font-size: 14px;padding: 0px 10px 0px 10px;">删除</a>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="customerModify" action="<%=path%>/customer/update" method="post" novalidate="true">
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="accnttype" value="${sd.accnttype}" />
				<input type="hidden" name="industry" value="${sd.industry}" />
				<input type="hidden" name="campaigns" value="${sd.campaigns}" />
				<input type="hidden" name="nature" value="${sd.nature}" />
				<input type="hidden" name="source" value="${sd.source}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="orgId" value="${sd.orgId}" />
				<br/>
				<div class="site-card-view _border_">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>客户姓名：</th>
									<td class="uptShow">${sd.name}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="name" id="name" value="${sd.name}" maxlength="30"
										placeholder="请输入客户姓名"/></td>
								</tr>
								
								<tr>
									<th>性别：</th>
									<td class="uptShow">
										<c:if test="${sd.postalcode eq 'm'}">
											男
										</c:if>
										<c:if test="${sd.postalcode eq 'f'}">
											女
										</c:if>
										&nbsp;
									</td>
									<td class="uptInput" style="display: none"><select
										name="postalcode" style="height: 2.2em">
										<option value="" >请选择您客户的性别</option>
										<option value="f">女</option>
										<option value="m">男</option>
									</select></td>
								</tr>
								
								<tr>
									<th>联系方式：</th>
									<td class="uptShow">
										<c:if test="${sd.phoneoffice ne '' }">
											<a href="tel:${sd.phoneoffice}"><img src="<%=path %>/image/mb_card_contact_tel.png" width="20px"></a>&nbsp;
										</c:if>
										${sd.phoneoffice}</td>
									<td class="uptInput" style="display: none"><input
										type="number" name="phoneoffice" id="phoneoffice"
										value="${sd.phoneoffice}" maxlength="15" placeholder="请填写客户的联系电话"/></td>
								</tr>
								<tr style="display:none;">
									<th>年龄：</th>
									<td class="uptShow">${sd.legal}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="legal" id="legal"
										value="${sd.legal}" placeholder="请填写年龄"/></td>
								</tr>
								
								<tr>
									<th>地址：</th>
									<td class="uptShow">
										<c:if test="${sd.street ne ''}">
											<a href="javascript:void(0)" onclick="getCustomerMap('${sd.street}')"><img src="<%=path%>/image/wx_oppty_tas_val.png" width="24px"></a>&nbsp;
										</c:if>
										${sd.street}
									</td>
									<td class="uptInput" style="display: none"><textarea
											name="street" id="street" rows="" cols="" placeholder="请填写您客户的地址">${sd.street}</textarea></td>
								</tr>
									<tr>
									<th>责任人：</th>
									<td class="uptShow">${sd.assigner}</td>
									<td class="uptInput" style="display:none">
											<div style="padding:3px 5px;border-bottom: 1px solid #ddd;">
												<input name="assignerid" id="assignerid" value="" type="hidden" />
												<input name="assigner" id="assigner" value="${sd.assigner}" type="text" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
												<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
											</div>
									</td>
								</tr>
								<tr>
									<th>接触时间 ：</th>
									<td class="uptShow">${sd.builddate}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="builddate" id="builddate"
										value="${sd.builddate}" placeholder="请填写客户的成立时间"/></td>
								</tr>
								<tr>
										<th>客户情况：</th>
										<td class="uptShow"><c:if
												test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc, 0, 60)}
											<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");'>
											<span id="more_a">...全部展开</span></a>
												<span id="more_desc" style="display: none;">${fn:substring(sd.desc, 60, fn:length(sd.desc)) }</span>
											</c:if> <c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if></td>
										<td class="uptInput" style="display: none"><textarea
												name="desc" id="desc" rows="" cols=""
												placeholder="请填写客户的描述">${sd.desc}</textarea></td>
									</tr>
						
								<tr>
									<th>创建：</th>
									<td>${sd.creater}&nbsp;&nbsp;${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier}&nbsp;&nbsp;${sd.modifyDate}</td>
								</tr>
							</tbody>
						</table>
					</div>
					
                </div>
			</form>
			<div id="update" class="flooter" style="background: #FFF;z-index:99999;opacity: 1;">

			</div>
			<!--确定/取消按钮-->
			<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display: none;z-index:99999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;">
				<div class="button-ctrl" style="margin-top:-2px;">
					<fieldset class="">
						<div class="ui-block-a canbtn">
							<a href="javascript:void(0)" 
								class="btn btn-default btn-block" style="font-size: 14px;">取消</a>
						</div>
						<div class="ui-block-a conbtn">
							<a href="javascript:void(0)" 
								class="btn btn-success btn-block" style="font-size: 14px;">确定</a>
						</div>
					</fieldset>
				</div>
			</div>
			
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<div class="shade" style="z-index:999999;display:none"></div>
	<div id="custmap" style="z-index:9999999;display:none;width:80%;height:300px;left:10%;position: absolute;"></div>
	<jsp:include page="/common/rela/tag.jsp">
		<jsp:param value="${rowId }" name="relaId"/>
	</jsp:include>
	<%-- 责任人 --%>
	<jsp:include page="/common/rela/seluser.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js"
		type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",
			url : window.location.href + "&shareBtnContol=yes",
			title : "${accName}",
			desc : "电话：${sd.phoneoffice}   地址：${sd.street}",
			fakeid : "",
			callback : function() {
			}
		};
	</script> --%>
</body>
</html>