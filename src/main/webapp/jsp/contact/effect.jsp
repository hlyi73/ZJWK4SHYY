<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!--框架样式-->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jOrgChart/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<style type="text/css">
#box{width:100%;height:500px;position:relative;}
.host{position:absolute;width:90px;height:90px;padding-top:32px;text-align:center;color:#fff;background-color:#3e6790;border:#A8E54C 3px solid;font-weight:bolder;border-radius: 45px;}
.guest{position:absolute;width:70px;font-size:14px;height:70px;padding-top:23px;text-align:center;color:#999999;background-color:#efefef;border:#ddd 1px solid;cursor:pointer;border-radius: 35px;}
.relationship{position:absolute;width:60px;height:20px;color:#3e6790;line-height:20px;font-size:12px;text-align:center;}
</style>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script type="text/javascript">

var relation = {
        radius:150,
        boxW:500,
        boxH:500,
        hostW:100,
        hostH:50,
        guestW:80,
        guestH:40,
        relationW:60,
        relationH:20,
        angle:0,
        id:"box",
        init:function(array,n){//传入参数1：数组 参数2：第几个
        this.array = array;
                this.appendHost(this.array,n);
                this.appendQuest(this.array,n);
                this.appendRelationShip(this.array,n);
        },
        appendHost:function(array,n){
                var box = $("#"+this.id);
                var host ="<span class='host'>"+array[n].name+"</span>";
                box.append(host)
                this.postHost();
        },
        postHost:function(){
                var x = (this.boxW - this.hostW)/2 -50;
                var y = (this.boxH - this.hostH)/2 -20;
                $(".host").css({
                        left:x,
                        top:y
                });
                $(".host").click(function(){
                	$(".shade").css("display","");
                	$(".addcontact").css("display","");
                });
        },
        appendQuest:function(array,n){
                var box = $("#"+this.id);
                var guests="";
                var that = this;
                for(var i=0; i<array[n].friend.length; i++){
                	var style = 'style="';
                	if(array[n].friend[i].effect == '1'){
                		style += 'background-color:red;color:#fff;border: 3px solid rgb(253, 205, 52);'; 
                	}else if(array[n].friend[i].effect == '2'){
                		style += 'background-color:orange;color:#fff;border:3px solid #A2B0BD;'; 
                	}else{
                		style += 'background-color:#efefef;color:#999999;border:3px solid #E6DFE2;'; 
                	}
                	style += '"';
                    guests+="<span class='guest' "+style+" id='"+array[n].friend[i].rowid+"'>"+array[n].friend[i].name+"</span>";
                }
                $(guests).appendTo(box);
                //$(".guest").live("click",function(){
                //	that.move(that,this);
                //});
                $(".guest").click(function(){
                	//alert(this.id);
                	$(".addcontact").css("display","none");
	                var rowid =this.id;
	                var cname = this.innerText;
	                syncGetContactRela(rowid,cname);
                });
                this.postQuest();
        },
        postQuest:function(){
                var guests = $(".guest");
                var that = this;
                guests.each(function(i){
                        guests.eq(i).css({
                                left:that.setQuestPose(guests.length,that.radius,i,that.guestW,that.guestH,that.angle).left,
                                top:that.setQuestPose(guests.length,that.radius,i,that.guestW,that.guestH,that.angle).top
                        }).attr("angle",i/guests.length)
                })
        },
        setQuestPose:function(n,r,i,w,h,d){//n代表共几个对象 r代表周长 i代表第几个对象 w代表外面对象的宽带 h代表外面对象的高度 d代表其实角度
                var p = i/n*Math.PI*2+Math.PI*2*d;
                var x = r * Math.cos(p);
                var y = r * Math.sin(p);
                return {
                        "left":parseInt(this.boxW/2+ x - w/2-50),
                        "top":parseInt(this.boxH/2 + y - h/2-20)
                }
        },
        appendRelationShip:function(array,n){
                var box = $("#"+this.id);
                var relation="";
                for(var i=0; i<array[n].friend.length; i++){
                	var style = 'style="';
                	if(array[n].friend[i].effect == '1'){
                		style += 'color:red;'; 
                	}else if(array[n].friend[i].effect == '2'){
                		style += 'color:orange;'; 
                	}else{
                		style += 'color:#666;'; 
                	}
                	style += '"';
                    relation+="<span class='relationship' "+style+" id='"+array[n].friend[i].rowid+"'>"+array[n].friend[i].relationship+"</span>";
                }
                box.append(relation);
                $(".relationship").click(function(){
	                var relaid =this.id;
	                popupContactEffect(relaid);
                });
                this.postRelationShip();
        },
        postRelationShip:function(){
                var guests = $(".relationship");
                var that = this;
                guests.each(function(i){
                        guests.eq(i).css({
                                left:that.setQuestPose(guests.length,that.radius/2,i,that.relationW,that.relationH,that.angle).left-6,
                                top:that.setQuestPose(guests.length,that.radius/2,i,that.relationW,that.relationH,that.angle).top+18
                        })
                })
        },
        move:function(t,i){
        		$(".addcontact").css("display","none");
                var n = $(".guest").index($(i));
                var rowid = $(".guest")[n].id;
                var cname = $(".guest")[n].innerText;
                syncGetContactRela(rowid,cname);
                /*
                this.angle = parseFloat($(i).attr("angle"))+0.5;
                this.delect(n);
                this.moveHost(i);
                this.moveQuest(i);
                this.moveRelationship(i);
                this.changeClass();
                setTimeout(function(){t.newAppend(i)},500);
                */
        }
};
$(document).ready(function(){
	syncGetContactRela('${rowId}','${cname}');  
	initForm();
	
	//联系人增加页面返回
	$(".contactGoBak").click(function(){
		$("#contactformdiv").addClass("modal");
		$("#contactnavbar").css("display","none");
		$("#contact_more").removeClass("modal");
		initContactPage();
	});
	
});

var relationName = [];
var subrelaname = [];
//异步获取联系人关系
function syncGetContactRela(rowId,cname){
	$(":hidden[name=rowid]").val(rowId);
	$(":hidden[name=cname]").val(cname);
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'rowId', value:rowId});
	dataObj.push({name:'publicId', value:'${publicId}'});
	$.ajax({
		type: 'post',
		url: '<%=path%>/contact/relation',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d){
					return;
				}
				relationName = [];
				subrelaname = [];
				$("#box").html('');
				
				$(d).each(function(i){
					subrelaname.push({'name':this.conname,'relationship':this.relationname,'rowid':this.rowid,'effect':this.effect});
				});
				relationName.push({'name':cname,'friend':subrelaname});
				relation.init(relationName,0);
			}
	});
	//
}

//分页查询联系人
function contoPage() {
	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
	var currpage = $("input[name=currPage]").val();
	$("input[name=currPage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=currPage]").val();
	$.ajax({
		type : 'get',
		url : '<%=path%>/contact/asyclist' || '',			
	    //async: false,
        data: {viewtype:'allview',currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10'} || {},
	    dataType: 'text',
	    success: function(data){
	    	if(!data){
	    		$(".contact_div").css("display","");
	    		$("#div_next").css("display", 'none');
	    		return;
	    	}
	    	$("#contactbook-btn").css("display","");
			$("#div_next_con").css("display",'');
	   	    var val = $(".acctList").html();
	   	    var d = JSON.parse(data);
			if(d != ""){
	   	    	if($(d).size() == 10){
	   	    		$("#div_next_con").css("display",'');
	   	    	}else{
	   	    		$("#div_next_con").css("display",'none');
	   	    	}
				$(d).each(function(i){
					val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
						+  '<div class="list-group-item-bd"> <input type="hidden" name="conId" value="'+this.rowid+'"/>'
						+  '<input type="hidden" name="conName" value="'+this.conname+'"/>'
						+  '<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">';
					if(""==this.filename){
						val +='<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
					}else{
						if("ok"==this.iswbuser){
							val +='<img src="'+this.filename+'" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
						}else{
							val +='<img src="<%=path %>/contact/download?fileName='+this.filename+'" border=0 width="60px" height="60px;"style="background-color:#ffffff;">';
						}
					}
					val +='</div><div class="content" style="text-align: left"><h1>'+this.conname+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
					    + this.salutation+'</span></h1><p>'+this.conjob+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+this.phonemobile+'</p></div></div>'
						+ '<div class="input-radio" title="选择该条记录"></div></a>';
				});
			} else {
				$("#div_next_con").css("display", 'none');
			}
			$(".acctList").html(val);

			$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
			initForm();
	    }
	});
}


function initForm(){
	//勾选某个 已有联系人 的超链接
	$(".acctList > a").click(function(){
		$(".acctList > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
	});
	
	// 联系人 的 确定按钮
	$(".acctbtn").click(function(){
		var conName = "";
		var conId="";
		$(".acctList > a.checked").each(function(){
			conId = $(this).find(":hidden[name=conId]").val();
			conName = $(this).find(":hidden[name=conName]").val();
		});
		$(":hidden[name=relaid]").val(conId);
		$(":hidden[name=relaname]").val(conName);
		$("#tmpcontactlist").val(conName);
		retMainPage();
	});
	
	$(".shade").click(function(){
		$(".shade").css("display","none");
		$(".addcontact").css("display","none");
		$(".updcontact").css("display","none");
	});
}


function saveEffect(){
	var relaid = $(":hidden[name=relaid]").val();
	var rowid = $(":hidden[name=rowid]").val();
	var rela = $("select[name=contactRela]").val();
	var effect = $("select[name=contactEffect]").val();
	if(relaid == '' || rowid == '' || relation == '-999' || relaid == rowid){
		$(".myMsgBox").css("display","").html("请填写完整!");
		$(".myMsgBox").delay(2000).fadeOut();
		return;
	}
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'rowid', value:rowid});
	dataObj.push({name:'relation', value:rela});
	dataObj.push({name:'relaid', value:relaid});
	dataObj.push({name:'effect',value:effect});
	dataObj.push({name:'publicId', value:'${publicId}'});
	$.ajax({
		type: 'post',
		url: '<%=path%>/contact/saverela',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d){
					return;
				}
				
				if(d.errorCode != '0'){
					$(".myMsgBox").css("display","").html(d.errorMsg);
					$(".myMsgBox").delay(2000).fadeOut();
					return;
				}
				
				if(d.rowId != ''){
					relationName = [];
					subrelaname.push({'name':$(":hidden[name=relaname]").val(),'relationship':$("select[name=contactRela] option:selected").text(),'rowid':d.rowId,'effect':effect});
					$("#box").html('');
					relationName.push({'name':$(":hidden[name=cname]").val(),'friend':subrelaname});
					relation.init(relationName,0);
					
					init();
					
					$(".addcontact").css("display","none");
					$(".shade").css("display","none");
				}
				
			}
	});
}

//影响
function popupContactEffect(relaid){
	$(":hidden[name=relaid]").val(relaid);
	$(".shade").css("display","");
	$(".updcontact").css("display","");
}

function deleteEffect(){
		var relaid = $(":hidden[name=relaid]").val();
		var rowid = $(":hidden[name=rowid]").val();
		if(relaid == '' || rowid == ''){
			$(".myMsgBox").css("display","").html("请填写完整!");
			$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		var dataObj = [];
		dataObj.push({name:'openId', value:'${openId}'});
		dataObj.push({name:'rowid', value:rowid});
		dataObj.push({name:'relaid', value:relaid});
		dataObj.push({name:'publicId', value:'${publicId}'});
		$.ajax({
			type: 'post',
			url: '<%=path%>/contact/delrela',
				data : dataObj || {},
				dataType : 'text',
				success : function(data) {
					var d = JSON.parse(data);
					if(!d){
						return;
					}
					
					if(d.errorCode != '0'){
						$(".myMsgBox").css("display","").html(d.errorMsg);
						$(".myMsgBox").delay(2000).fadeOut();
						return;
					}else{
						var tmp = relationName[0]['friend'];
						for(var i=0;i<tmp.length;i++){
							if(tmp[i].rowid == relaid){
								tmp.splice(i,1);
								break;
							}
						}
						$("#box").html('');
						relationName.push({'name':relationName[0]['name'],'friend':tmp});
						relation.init(relationName,0);
						
						init();
						
						$(".shade").css("display","none");
						$(".updcontact").css("display","none");
					}
					
				}
		});
		
}

function updateEffect(){
	var relaid = $(":hidden[name=relaid]").val();
	var rowid = $(":hidden[name=rowid]").val();
	var rela = $("select[name=contactRela2]").val();
	var effect = $("select[name=contactEffect2]").val();
	if(relaid == '' || rowid == '' || relation == '-999'){
		$(".myMsgBox").css("display","").html("请填写完整!");
		$(".myMsgBox").delay(2000).fadeOut();
		return;
	}
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'rowid', value:rowid});
	dataObj.push({name:'relation', value:rela});
	dataObj.push({name:'relaid', value:relaid});
	dataObj.push({name:'effect',value:effect});
	dataObj.push({name:'publicId', value:'${publicId}'});
	$.ajax({
		type: 'post',
		url: '<%=path%>/contact/updrela',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d){
					return;
				}
				
				if(d.errorCode != '0'){
					$(".myMsgBox").css("display","").html(d.errorMsg);
					$(".myMsgBox").delay(2000).fadeOut();
					return;
				}else{
					
					$(".relationship").each(function(){
						if(this.id==relaid){
							this.innerText = $("select[name=contactRela2] option:selected").text();
							if(effect == 1){
								$(this).css("color","red");
							}else if(effect == 2){
								$(this).css("color","orange");
							}else if(effect ==3){
								$(this).css("color","#666");
							}
						}
					});
					$(".guest").each(function(){
						if(this.id==relaid){
							if(effect == 1){
								$(this).css("color","#FFF");
								$(this).css("background-color","red");
							}else if(effect == 2){
								$(this).css("color","#FFF");
								$(this).css("background-color","orange");
							}else if(effect ==3){
								$(this).css("color","#666");
								$(this).css("background-color","#efefef");
							}
						}
					});
					init();
					$(".shade").css("display","none");
					$(".updcontact").css("display","none");
				}
				
			}
	});
	
}

//弹出联系人选择框
function popupContact(){
	$(".shade").css("display","none");
	$("input[name=currPage]").val(0);
	$(".acctList").html('');
	$(".main_rela_div").addClass("modal");
	$(".addcontact").css("display","none");
	$("#contact_more").removeClass("modal");
	contoPage();
}

function retMainPage(){
	$(".shade").css("display","");
	$(".main_rela_div").removeClass("modal");
	$(".addcontact").css("display","");
	$("#contact_more").addClass("modal");
}

function init(){
	$("#tmpcontactlist").val('');
	$("select[name=contactRela]").val('-999');
	$("select[name=contactRela2]").val('-999');
	$("select[name=contactEffect]").val('-999');
	$("select[name=contactEffect2]").val('-999');
	$(":hidden[name=relaid]").val('');
	$(":hidden[name=relaname]").val('');
	$(":hidden[name=effect]").val('');
	$(":hidden[name=effectname]").val('');
	
}

//显示联系人增加页面
function addCon(){
	$("#contactformdiv").removeClass("modal");
	$("#contactnavbar").css("display","");
	$("#contact_more").addClass("modal");
	initContactPage();
	$("#div_contact_parent_label").css("display","");
}

//异步增加联系人
function confirmConfirm(){
	var desc = $("#contact_description").val();
	var dataObj = [];
	var form = $("#contactForm");	
	form.find("input[name=desc]").val(desc);
	form.find("input").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});					
	});
	var name = form.find("input[name=conname]").val();
	$.ajax({
		url: '<%=path%>/contact/asynsave',
		type: 'post',
		data: dataObj,
	    success: function(data){
	    	if(!data) return;
	    	var obj = JSON.parse(data);
	    	if(obj.rowId){
				$("#contactformdiv").addClass("modal");
				$("#contactnavbar").css("display","none");
				$(":hidden[name=relaid]").val(obj.rowId);
				$(":hidden[name=relaname]").val(name);
				$("#tmpcontactlist").val(name);
				retMainPage();
	    	}else{
	    		$(".myMsgBox").css("display","").html("保存联系人失败！"+ "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
				$(".myMsgBox").delay(2000).fadeOut();
	    	}
	    }
	});
}
</script>

<body style="background-color:#fff;">
	<div class="main_rela_div">
	<div id="site-nav" class="navbar" style="max-width:100%">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">影 响 力</h3>
	</div>
	
	<input type="hidden" name="currPage" value="0" >
	<input type="hidden" name="relaid" value="" >
	<input type="hidden" name="relaname" value="" >
	<input type="hidden" name="effect" value="" >
	<input type="hidden" name="effectname" value="" >
	<input type="hidden" name="rowid" value="" >
	<input type="hidden" name="cname" value="" >
	
	<div id="box">

	</div>
	</div>
	
	<div class="shade" style="display: none"></div>
	<!-- 添加联系人 -->
	<div class="flooter addcontact" style="z-index:999999;width:100%;min-height:50px;border-top:1px solid #ddd;background-color:#FFF;color:#666;font-size:16px;padding:8px;display:none;">
		<div style="float:left;width:100%;padding-right:88px;">
			<div style="width:100%;"><input type="text" id="tmpcontactlist" placeholder="选择联系人" readonly="readonly" onclick="popupContact()"></div>
			<div style="width:100%;margin-top:5px;">
				<div style="border:1px solid #b5b5b5;width:100%;height:35px;margin-top:3px;background-color:#fff;">
					<select name="contactRela" style="border:none;color:#999;font-size:16px;margin-top:5px;background-coolor:#fff;">
						<option value="-999">选择关系</option>
						<c:forEach items="${relaList }" var="rela">
						<option value="${rela.key }">${rela.value }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div style="width:100%;margin-top:5px;">
				<div style="border:1px solid #b5b5b5;width:100%;height:35px;margin-top:3px;background-color:#fff;">
					<select name="contactEffect" style="border:none;color:#999;font-size:16px;margin-top:5px;background-coolor:#fff;">
						<option value="-999">选择影响力</option>
						<c:forEach items="${effectList }" var="effect">
						<c:if test="${effect.key ne '' }">
						<option value="${effect.key }">${effect.value }</option>
						</c:if>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>
		<div style="float:right;width: 85px;padding-right:10px;margin-top:-110px;">
					<a href="javascript:void(0)" onclick="saveEffect()" class="save_contact_btn btn"
						style="font-size: 14px;width:100%;height:100px;line-height:100px;margin: 1px 10px 5px 10px;background-color:RGB(75, 192, 171)">保存</a>
		</div>
	</div>
	
	
	<div class="flooter updcontact" style="z-index:999999;width:100%;min-height:50px;border-top:1px solid #ddd;background-color:#FFF;color:#666;font-size:16px;padding:8px;display:none;">
		<div style="float:left;width:100%;padding-right:105px">
			<div style="width:100%;margin-top:5px;">
				<div style="border:1px solid #b5b5b5;width:100%;height:35px;margin-top:3px;background-color:#fff;">
					<select name="contactRela2" style="border:none;color:#999;font-size:16px;margin-top:5px;background-coolor:#fff;">
						<option value="-999">选择关系</option>
						<c:forEach items="${relaList }" var="rela">
						<option value="${rela.key }">${rela.value }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div style="width:100%;margin-top:5px;">
				<div style="border:1px solid #b5b5b5;width:100%;height:35px;margin-top:3px;background-color:#fff;">
					<select name="contactEffect2" style="border:none;color:#999;font-size:16px;margin-top:5px;background-coolor:#fff;">
						<option value="-999">选择影响力</option>
						<c:forEach items="${effectList }" var="effect">
						<c:if test="${effect.key ne '' }">
						<option value="${effect.key }">${effect.value }</option>
						</c:if>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>
		<div style="float:right;width:100px;padding-right:10px;margin-top:-75px;">
					<a href="javascript:void(0)" onclick="updateEffect()" class="save_effect_btn btn"
						style="font-size: 14px;width:100%;height:35px;line-height:35px;margin: 1px 10px 5px 10px;background-color:RGB(75, 192, 171)">保存</a>
					<a href="javascript:void(0)" onclick="deleteEffect()" class="delete_effect_btn btn"
						style="font-size: 14px;width:100%;height:35px;line-height:35px;margin: 1px 10px 5px 10px;background-color: #EFEFEF;color:#666">删除</a>
		</div>
	</div>
	
	<!-- 联系人列表 -->
	<div id="contact_more" class=" modal">
		<div id="" class="navbar">
		    <a href="javascript:void(0)" onclick="retMainPage()" class="act-primary acctGoBack"><i class="icon-back"></i></a>
			联系人列表
			<div class="act-secondary">
				<a href="javascript:void(0);" onclick="addCon();" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
			</div>
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
				<div class="list-group listview listview-header acctList">
					
				</div>
				<div class="alert-info text-center contact_div" style="display:none;padding: 2em 0; margin: 3em 0">
						无数据
				</div>
				<div style="width:100% auto;text-align:center;display:none;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next_con">
					<a href="javascript:void(0)" onclick="contoPage()">
						下一页&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
					</a>
				</div>
				<br/><br/><br/><br/>
				<div id="contactbook-btn" class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-right: 10px;display:none;">
					<input class="btn btn-block acctbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 10px 0px 3px 0px;" >
				</div>
		</div>
	</div>
	<div id="contactformdiv" class="modal">
		<div id="contactnavbar" class="navbar" style="display:none;">
			<a href="#" onclick="javascript:void(0)" class="act-primary contactGoBak"><i class="icon-back"></i></a>
			新建联系人
		</div>
		<jsp:include page="/common/contactform.jsp"></jsp:include>
	</div>
	<br><br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="z-index:999999;display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<!--脚页面  -->
</body>
</html>