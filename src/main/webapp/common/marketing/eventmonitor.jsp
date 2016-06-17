<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String eventmonitor = request.getContextPath();
	String attenopenid = request.getParameter("atten_openid");
			attenopenid = (attenopenid == null) ? "" : attenopenid;
%>
<script>
//事件执行监测
function eventsMonitor(op) {
	
	var defaultSetting = {
		eventsStr : "click focus blur",
		splitStr : " "
	};
	
	var ops = $.extend(true, defaultSetting, op);
	
	$.each(ops.eventsStr.split(ops.splitStr), function(i, v) {
		    $("img").each(function(){
		    	$(this).removeAttr("onclick");
		     });
	    
		    $("img").bind(v, function(e) {
		    	var v = $(this).attr("onclick");
		    	if(v === "swicthUpMenu('flootermenu')"){
		    		$(this).removeAttr("onclick");
		    	}
		    	return false;
		    });
		    
		    $("div").bind(v, function(e) {
		    	return false;
		    });
		    
			$("a").not('.examinerSend').not('.showAllMsg').bind(v, function(e) {
					
				var t = e.target, n = t.nodeName, i = t.id, nm = t.Name;
				$("._menu").css("display", "none");
				$("._submenu").css("display", "none");
				$("#botbounceInUp").unbind("click");
				return false;
			});
	});
}

$(function(){
	//attenopenid
	var attenopenid = '<%=attenopenid%>';
	if(attenopenid){//click blur focus select scroll mousewheel resize
		eventsMonitor({
			eventsStr : "click blur focus select mousewheel "
		});
	}	
});
</script>