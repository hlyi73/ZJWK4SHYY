<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String participantpath = request.getContextPath();
	String rowId = request.getParameter("rowId");
	String rela_type = request.getParameter("rela_type");
	String eval_type = request.getParameter("eval_type");
	String crmId = request.getParameter("crmId");
	String orgId = request.getParameter("orgId");
	eval_type = (null == eval_type ? "" : eval_type);
	String partyId = UserUtil.getCurrUser(request).getParty_row_id();
	String username = UserUtil.getCurrUser(request).getNickname();
%>
<script>
	$(function(){
		$("._shade_div").click(function(){
			showorhidden("hidden");
		});
		$(".saveParticipantBtn").click(function(){
			saveParticipant();
		});
	    //进入页面加载评论消息
	    loadMsgPraise('0','10');
	});

	function stopDefault(e){
	    if(e && e.preventDefault)
	           e.preventDefault();
	    else
	           window.event.returnValue = false;
	    return false;
	};
	
	//保存评价
	function saveParticipant(){
		var grade = $("#_comments_grade").val();
		if(!grade){
			$(".myMsgBox").css("display","").html("请打分!");
	    	$(".myMsgBox").delay(2000).fadeOut();
	    	return;
		}
		if(isNaN(grade)){
			$(".myMsgBox").css("display","").html("请输入数字!");
			$("#_comments_grade").val('');
	    	$(".myMsgBox").delay(2000).fadeOut();
	    	return;
		}
		
		if(parseFloat(grade) > 5 || parseFloat(grade) <0){
			$(".myMsgBox").css("display","").html("打分超出范围!");
	    	$(".myMsgBox").delay(2000).fadeOut();
	    	return;
		}
		var content = $("textarea[name=content]").val();
		if(!content){
			$(".myMsgBox").css("display","").html("请输入评价!");
	    	$(".myMsgBox").delay(2000).fadeOut();
	    	return;
		}
		$(":hidden[name=comments_grade]").val(grade);
		$(":hidden[name=comments]").val(content);
		$(":hidden[name=rela_id]").val('<%=rowId%>');
		$(":hidden[name=rela_type]").val('<%=rela_type%>');
		var dataObj = [];
		$("form[name=activity_participant_form]").find(":hidden").each(function(){
			var n = $(this).attr("name");
			var v = $(this).val();
			dataObj.push({name:n,value:v});
		});
		//发送异步请求
		$.ajax({
			url:'<%=participantpath%>/workplan/saveComments',
			type:'post',
			dataType:'text',
			data:dataObj,
			success:function(data){
				if(!data){
					showorhidden("hidden");
					$(".myMsgBox").css("display","").html("评价失败！");
			    	$(".myMsgBox").delay(2000).fadeOut();
				}else{
					$("._nocommentsdata").css("display","none");
					var eval_type = $(":hidden[name=eval_type]").val();
					var html = "";
					var liclass = "";
					if(eval_type && eval_type == 'lead' && $(".lead_user_<%=partyId%>").size() == 0){
						liclass = "lead_user_<%=partyId%> lead_user_li";
					}else if(eval_type && eval_type == 'friend' && $(".friend_user_<%=partyId%>").size() == 0){
						liclass = "friend_user_<%=partyId%> friend_user_li";
					}else if(eval_type && eval_type == 'partner' && $(".partner_user_<%=partyId%>").size() == 0){
						liclass = "partner_user_<%=partyId%> partner_user_li";
					}else if(eval_type && eval_type == 'owner' && $(".owner_user_<%=partyId%>").size() == 0){
						liclass = "owner_user_<%=partyId%> owner_user_li";
					}
					var html = "";
					if(liclass == ''){
						html = '<li style="display: block;position: relative;padding: 8px 0px">'
							 + '<div class="ct-box" style="display: block;margin-left: 5px;">'
							 + '<div style="margin-left:60px"><p class="ct-user" style="margin-bottom: 6px;">'
							 + '<a target="_blank" style="margin-left: 0px;" href="javascript:void(0)"><%=username%></a>  :  '
							 + '修改评价：<span class="scroe_list score_list_<%=partyId%>" evaltype="'+eval_type+'">'+toDecimal2(grade,1) +'</span>' ;
					    html += '<span style="float:right;font-size: 12px;color:#bdbdbd;padding-right: 8px;">'+dateFormat(new Date(), "MM-dd hh:mm");+'</span>';
						html +='</p><p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">'
							 + content +'</p></div></div></li><div style="clear:both;"></div>';
					}else{
						html = '<li class="'+liclass+'" assignerid=<%=partyId%>" style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 8px 0px">'
							 + '<div class="ct-box" style="display: block;margin-left: 5px;">'
							 + '<div style="float:left"><img class="msgheadimg" style="border-radius:5px;margin: 5px;" userid="<%=partyId%>" src="" width="40px">'
							 + '</div><div style="margin-left:60px"><p class="ct-user" style="margin-bottom: 6px;">'
							 + '<a target="_blank" style="margin-left: 0px;" href="javascript:void(0)"><%=username%></a>  :  '
							 + '<span class="scroe_list" evaltype="'+eval_type+'">'+toDecimal2(grade,1) +'</span>' ;
					    html += '<span style="float:right;font-size: 12px;color:#bdbdbd;padding-right: 8px;">'+dateFormat(new Date(), "MM-dd hh:mm");+'</span>';
						html +='</p><p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">'
							 + content +'</p></div></div></li><div style="clear:both;"></div>';
					}
					if(eval_type == 'lead'){
						if(liclass == ''){
							$(".appraiseDiv .lead_list .lead_user_<%=partyId%>").after(html);
						}else{
							$(".appraiseDiv .lead_list").append(html);
						}
					}else if(eval_type == 'friend'){
						if(liclass == ''){
							$(".appraiseDiv .friend_list .friend_user_<%=partyId%>").after(html);
						}else{
							$(".appraiseDiv .friend_list").append(html);
						}
					}else if(eval_type == 'partner'){
						if(liclass == ''){
							$(".appraiseDiv .partner_list .partner_user_<%=partyId%>").after(html);
						}else{
							$(".appraiseDiv .partner_list").append(html);
						}
					}else if(eval_type == 'owner'){
						if(liclass == ''){
							$(".appraiseDiv .owner_list .owner_user_<%=partyId%>").after(html);
						}else{
							$(".appraiseDiv .owner_list").append(html);
						}
					}
					if($(".appraiseDiv .lead_list .scroe_list").size() != ''){ 
						$(".lead_list_title").css("display","");
					}
					if($(".appraiseDiv .friend_list .scroe_list").size() != ''){ 
						$(".friend_list_title").css("display","");
					}
					if($(".appraiseDiv .partner_list .scroe_list").size() != ''){ 
						$(".partner_list_title").css("display","");
					}
					if($(".appraiseDiv .owner_list .scroe_list").size() != ''){ 
						$(".owner_list_title").css("display","");
					}
					if(liclass != ''){
						//追加单条图像数据
				    	loadMsgImg('<%=partyId%>', $(".appraiseDiv").find("img[userid=<%=partyId%>]"));
					}
					showorhidden("hidden");
				    //计算分享
					calcEvaluation();
				    //setParise(eval_type,'<%=partyId%>');
				}
			}
		});
	}
	function setParise(type,userid){
		if(type == 'lead'){
			if($(".lead_user_").size() ==0){
				$(".appraise").css("display","");
			}else{
				$(".appraise").css("display","none");
				$(".update_appraise_lead").css("display","");
			}
		}else{
			if($(".comm_user_"+userid).size() ==0){
				$(".appraise").css("display","");
			}else{
				$(".appraise").css("display","none");
				if($(".comm_user_"+userid +" .update_appraise_comm"+userid).size() == 0){
					$(".comm_user_"+userid).append('<div class="update_appraise_comm_'+userid+'" style="width:100%;text-align:center;line-height:35px;font-size:14px;">修改</div>');
					$(".update_appraise_comm_"+userid).click(function(){
			    		showorhidden('display');
			    	});
				}
			}
		}
	}
	
	function toDecimal2(x,digit) {  
        var f = parseFloat(x);  
        if (isNaN(f)) {  
            return false;  
        }  
        var f = 0;
        if(digit == 2){
        	f = Math.round(x*100)/100;  
        }else{
        	f = Math.round(x*10)/10;  
        }
        var s = f.toString();  
        var rs = s.indexOf('.');  
        if (rs < 0) {  
            rs = s.length;  
            s += '.';  
        }  
        while (s.length <= rs + digit) {  
            s += '0';  
        }  
        return s;  
    }  
	
	function loadMsgPraise(currpage,pagecount){
		var dataObj = [];
		dataObj.push({name:'rela_type', value:'<%=rela_type%>'});
		dataObj.push({name:'rela_id', value: '<%=rowId%>'});
		dataObj.push({name:'currpage', value: currpage });
		dataObj.push({name:'pagecount', value: pagecount });
		dataObj.push({name:'flag', value: 'asc' });
		$.ajax({
		   type: 'post',
		   url: '<%=participantpath%>/workplan/asynclist',
		   data: dataObj,
		   dataType: 'text',
		   success: function(data){
			   if(!data){
				   return;
			   }
			   var d = JSON.parse(data);
			   if(!d){
				   return;
			   }
			   if($(d).length >0){
			   	 $("._nocommentsdata").css("display","none");
			   }
			   var comsize = 0;
			   var total = $(d).size();
			   $(d).each(function(){
				   comsize++;
				   var html = "";
				   var liclass = "";
				  if(this.eval_type && this.eval_type == 'lead' && $(".lead_user_"+this.assignerid).size() == 0){
						liclass = "lead_user_"+this.assignerid+" lead_user_li";
					}else if(this.eval_type && this.eval_type == 'friend' && $(".friend_user_"+this.assignerid).size() == 0){
						liclass = "friend_user_"+this.assignerid+" friend_user_li";
					}else if(this.eval_type && this.eval_type == 'partner' && $(".partner_user_"+this.assignerid).size() == 0){
						liclass = "partner_user_"+this.assignerid+" partner_user_li";
					}else if(this.eval_type && this.eval_type == 'owner' && $(".owner_user_"+this.assignerid).size() == 0){
						liclass = "owner_user_"+this.assignerid+" owner_user_li";
					}
				   var cTime = this.create_time.substr(5, 11);
				   if(liclass == ''){
					   html = '<li style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 8px 0px">';
					   html += '<div class="ct-box" style="display: block;margin-left: 5px;">' 
							 + '<div style="margin-left:60px"><p class="ct-user" style="margin-bottom: 6px;">'
							 + '<a style="margin-left: 0px;" href="<%=participantpath%>/businesscard/detail?partyId='+this.assignerid+'">'+this.creator+'</a>  :  '
							 + '修改评价：<span class="scroe_list score_list_'+this.assignerid+'" evaltype="'+this.eval_type+'">'+toDecimal2(this.comments_grade,1) +'</span>';
						html += '<span style="float:right;font-size: 12px;color:#bdbdbd;padding-right: 8px;">'+cTime;+'</span>';
						html +='</p><p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">'
							 + this.comments +'</p></div></div></li><div style="clear:both;"></div>';
				   }else{
					   html = '<li class="'+liclass+'" assignerid="'+this.assignerid+'" style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 8px 0px">';
					   html += '<div class="ct-box" style="display: block;margin-left: 5px;">'
							 + '<div style="float:left"><img class="msgheadimg" style="border-radius:5px;margin: 5px;" userid="'+this.assignerid+'" src="" width="40px">'
							 + '</div><div style="margin-left:60px"><p class="ct-user" style="margin-bottom: 6px;">'
							 + '<a style="margin-left: 0px;" href="<%=participantpath%>/businesscard/detail?partyId='+this.assignerid+'">'+this.creator+'</a>  :  '
							 + '<span class="scroe_list" evaltype="'+this.eval_type+'">'+toDecimal2(this.comments_grade,1) +'</span>';
						html += '<span style="float:right;font-size: 12px;color:#bdbdbd;padding-right: 8px;">'+cTime;+'</span>';
						html +='</p><p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">'
							 + this.comments +'</p></div></div></li><div style="clear:both;"></div>';
				   }
					if(this.eval_type == 'lead'){
						if(liclass == ''){
							$(".appraiseDiv .lead_list .lead_user_"+this.assignerid).after(html);
						}else{
							$(".appraiseDiv .lead_list").append(html);
						}
					}else if(this.eval_type == 'friend'){
						if(liclass == ''){
							$(".appraiseDiv .friend_list .friend_user_"+this.assignerid).after(html);
						}else{
							$(".appraiseDiv .friend_list").append(html);
						}
					}else if(this.eval_type == 'partner'){
						if(liclass == ''){
							$(".appraiseDiv .partner_list .partner_user_"+this.assignerid).after(html);
						}else{
							$(".appraiseDiv .partner_list").append(html);
						}
					}else if(this.eval_type == 'owner'){
						if(liclass == ''){
							$(".appraiseDiv .owner_list .owner_user_"+this.assignerid).after(html);
						}else{
							$(".appraiseDiv .owner_list").append(html);
						}
					}
					if(liclass != ''){
						//追加单条图像数据
				    	loadMsgImg(this.assignerid, $(".appraiseDiv").find("img[userid="+this.assignerid+"]")); 
					}
					//setParise(this.eval_type,this.assignerid);
			   });
				if($(".appraiseDiv .lead_list .scroe_list").size() != ''){ 
					$(".lead_list_title").css("display","");
				}
				if($(".appraiseDiv .friend_list .scroe_list").size() != ''){ 
					$(".friend_list_title").css("display","");
				}
				if($(".appraiseDiv .partner_list .scroe_list").size() != ''){ 
					$(".partner_list_title").css("display","");
				}
				if($(".appraiseDiv .owner_list .scroe_list").size() != ''){ 
					$(".owner_list_title").css("display","");
				}
			   //计算分享
			   calcEvaluation();
			   moreComments();  
		   }
		});
	}
	
	function moreComments(){
		$(".more_comments").click(function(){
			$(this).css("display",'none');
			$(".more_list").css('display','');
		});
	}
	
	//计算分数
	function calcEvaluation(){
		var total_lead_avg = 0;
		var total_lead_size = 0;
		var total_friend_avg = 0;
		var total_friend_size = 0;
		var total_partner_avg = 0;
		var total_partner_size = 0;
		var total_owner_avg = 0;
		var total_avg = 0;
		var assignerid = "";
		$(".lead_user_li").each(function(){
			assignerid = $(this).attr("assignerid");
			total_lead_size ++;
			if($(".scroe_list").hasClass("score_list_"+assignerid)){
				total_lead_avg += parseFloat($(".score_list_"+assignerid).first().html());
			}else{
				total_lead_avg += parseFloat($(this).find(".scroe_list").html());
			}
		});
		$(".friend_user_li").each(function(){
			assignerid = $(this).attr("assignerid");
			total_friend_size ++;
			if($(".scroe_list").hasClass("score_list_"+assignerid)){
				total_friend_avg += parseFloat($(".score_list_"+assignerid).first().html());
			}else{
				total_friend_avg += parseFloat($(this).find(".scroe_list").html());
			}
		});
		$(".partner_user_li").each(function(){
			assignerid = $(this).attr("assignerid");
			total_partner_size ++;
			if($(".scroe_list").hasClass("score_list_"+assignerid)){
				total_partner_avg += parseFloat($(".score_list_"+assignerid).first().html());
			}else{
				total_partner_avg += parseFloat($(this).find(".scroe_list").html());
			}
		});
		//自我评价
		var length = $(".owner_list").find("li").size();
		if(length>1){
			total_owner_avg = parseFloat($(".owner_list li:eq(1)").find(".scroe_list").html());
		}else{
			total_owner_avg = parseFloat($(".owner_list li:first").find(".scroe_list").html());
		}
		var avg = '';
		var index = 0;
		var f= 0;
		if(total_lead_avg >0){
// 			$(".total_evaluation_lead").html('上级：'+toDecimal2(total_lead_avg/total_lead_size,2));
			f = toDecimal2(total_lead_avg/total_lead_size,2);
			$(".lead_avg").html('平均：'+toDecimal2(total_lead_avg/total_lead_size,2));
			index++;
			avg += "上级平均："+toDecimal2(total_lead_avg/total_lead_size,2)+"&nbsp;&nbsp;";
		}
		if(total_friend_avg >0){
			$(".friend_avg").html('平均：'+toDecimal2(total_friend_avg/total_friend_size,2));
			f = toDecimal2(parseFloat(f)+parseFloat(total_friend_avg/total_friend_size),2);
			index++;
		}
		if(total_partner_avg >0){
			$(".partner_avg").html('平均：'+toDecimal2(total_partner_avg/total_partner_size,2));
			f = toDecimal2(parseFloat(f)+parseFloat(total_partner_avg/total_partner_size),2);
			index++;
		}
		if(total_owner_avg >0){
			$(".owner_avg").html('评分：'+toDecimal2(total_owner_avg,2));
			f = toDecimal2(parseFloat(f)+parseFloat(total_owner_avg),2);
			index++;
		}
		if(f>0){
			$(".total_evaluation_avg").html('总平均：'+toDecimal2(f/index,2));
			avg += $(".total_evaluation_avg").html()+"&nbsp;&nbsp;";
		}
		loadCalc(avg);
	}
	
	//加载分数保存到redies里面
	function loadCalc(avg){
		$.ajax({
			url:'<%=participantpath%>/workplan/saveCalcAvg',
			data:{rowId:'<%=rowId%>',total:avg},
			type:'post',
			dataType:'text',
			success:function(data){
				
			}
		});
	}
	
	var loadMsgImg = function(userId, img){
	  	if(sessionStorage.getItem(userId + "_headImg")){
	  		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
	  		return;
	  	}
		if(userId){
	  		//异步调用获取消息数据
	      	$.ajax({
	   		url: '<%=participantpath%>/wxuser/getHeader',
	   		type: 'get',
	   		data: {partyId: userId},
	   		dataType: 'text',
	   	    success: function(data){
	   	    	if(data){
	   	    		
	    	    	  $(img).attr("src",data);
	    	    	  //本地缓存
	    	          sessionStorage.setItem(userId + "_headImg",data);
	    	    }
	   	    }
	   	});
		}
	};
	
	//显示或隐藏
	function showorhidden(type) { 
		if (type == 'hidden') {
			$("._activity_participant_div").animate({
				height : '0px'
			}, [ 5000 ]);
			$("._shade_div").css("display", "none");
			$("#flootermenu").css("display", "");
			$("input[name=_comments_grade]").val('');
			$("textarea[name=content]").val("");			
			$("._menu").css("display", "");
		} else if (type == 'display') {
			$("._shade_div").css("display", "");
			$("#flootermenu").css("display", "none");
			$("._menu").css("display", "none");
			$("._activity_participant_div").animate({
				height : '230px'
			}, [ 5000 ]); 
		}
	}
	
</script>
<style>
._activity_participant_div{
	width:100%;
	background-color:#fff;
	border-top:1px solid #eee;
	z-index:99;
	opacity: 1;
	padding:0px 10px;
	font-size:14px;
	height:0px;
}
</style>

<form name="activity_participant_form" id="activity_participant_form">
	<input type="hidden" name="comments">
	<input type="hidden" name="comments_grade" value="0">
	<input type="hidden" name="rela_id">
	<input type="hidden" name="rela_type">
	<input type="hidden" name="eval_type" value="<%=eval_type%>">
	<input type="hidden" name="crmId" value="<%=crmId%>">
	<input type="hidden" name="orgId" value="<%=orgId%>">
<div class="_activity_participant_div flooter">
	<div class="form-group" style="margin: 1.5em 0;">
		<div style="color:#666;">评分（0-5）<input type="number" id="_comments_grade" name="_comments_grade" value="" style="width: 80px;border: 0px;border-bottom: 1px solid #ddd;"></div>
	</div>
	<div class="form-group">
		<textarea name="content" rows="2" placeholder="请输入评价"></textarea>
	</div>
	<div class="button-ctrl">
		<fieldset class="">
			<div class="ui-block-a" style="width: 100%;">
				<a href="javascript:void(0)" class="btn btn-block saveParticipantBtn"
					style="font-size: 16px;">评价</a>
			</div>
		</fieldset>
	</div>
</div>
<div class="shade1 _shade_div" style="display:none;z-index: 20;position: fixed;width: 100%;height: 100%;top: 0px;left: 0px;opacity: 0.5;background-color: rgb(75, 192, 171);">&nbsp;</div>
</form>