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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<script type="text/javascript">
  mxBasePath = '<%=path%>/scripts/plugin/mxGraph/';
</script>
<script type="text/javascript"
	src="<%=path%>/scripts/plugin/mxGraph/mxClient.js"></script>
<script type="text/javascript">
var graph;
var parent;
var selEdges = null;
$(function () {
	var gxml = "";
	main(document.getElementById("graphContainer"),gxml);
	deleteEdges();
	loadData();
	
	$(".shade").click(function(){
		if($(".nodediv").css("display") == "block"){
			$(".nodediv").css("display","none");
			$(".operdiv").css("display","");
			$(".shade").css("display","none");
		}
	});
});

var currSelCellId = null,sourceCell,targetCell = null;
function main(container,gxml)
{
	// Checks if the browser is supported
	if (!mxClient.isBrowserSupported())
	{
		// Displays an error message if the browser is not supported.
		mxUtils.error('Browser is not supported!', 200, false);
	}
	else
	{
		mxConnectionHandler.prototype.connectImage = new mxImage('<%=path%>/scripts/plugin/mxGraph/images/connector.gif', 16, 16);//设置连接
		// Enables guides
		mxGraphHandler.prototype.guidesEnabled = true;
	    // Alt disables guides
	    mxGraphHandler.prototype.useGuidesForEvent = function(me)
	    {
	    	return !mxEvent.isAltDown(me.getEvent());
	    };
	    // Defines the guides to be red (default)
		//mxConstants.GUIDE_COLOR = 'blue';
	    // Defines the guides to be 1 pixel (default)
		//mxConstants.GUIDE_STROKEWIDTH = 1;
		// Enables snapping waypoints to terminals
		//mxEdgeHandler.prototype.snapToTerminals = true;
		// Enables crisp rendering of rectangles in SVG
		mxRectangleShape.prototype.crisp = false;
		mxArrow.prototype.crisp = false;
		
		// Creates the graph inside the given container
		graph = new mxGraph(container);
		graph.setConnectable(true);
		graph.setCellsResizable(false);
		graph.setPanning(true);
		//graph.extendParents = false;
		//graph.setAllowLoops(false);
		//graph.disconnectOnMove = false;
		graph.foldingEnabled = false;
		//graph.setCellsMovable(false);
		//graph.panningHandler.useLeftButtonForPanning = true;
		
		
		
		var outline = document.getElementById('outlineContainer');
		var outln = new mxOutline(graph, outline);

	    var style = graph.getStylesheet().getDefaultVertexStyle();
		style[mxConstants.STYLE_SHAPE] = 'label';
		style[mxConstants.STYLE_VERTICAL_ALIGN] = mxConstants.ALIGN_TOP; 
    	style[mxConstants.STYLE_ALIGN] = mxConstants.ALIGN_LEFT;
		style[mxConstants.STYLE_SPACING_LEFT] = 45; 

		style[mxConstants.STYLE_GRADIENTCOLOR] = '#ffffff';//'#7d85df';
		style[mxConstants.STYLE_STROKECOLOR] = '#999'; 
		style[mxConstants.STYLE_FILL] = '#ffffff';//'#5d65df';
		style[mxConstants.STYLE_FILLCOLOR] = '#ffffff';
		
		style[mxConstants.STYLE_FONTCOLOR] = '#1d258f';
		style[mxConstants.STYLE_FONTFAMILY] = 'Microsoft YaHei';
		style[mxConstants.STYLE_FONTSIZE] = '12';
		style[mxConstants.STYLE_FONTSTYLE] = '0';
		
		style[mxConstants.STYLE_ROUNDED] = '1';

		style[mxConstants.STYLE_IMAGE_WIDTH] = '35';
		style[mxConstants.STYLE_IMAGE_HEIGHT] = '35';
		style[mxConstants.STYLE_IMAGE_VERTICAL_ALIGN] = mxConstants.ALIGN_TOP; 
    	style[mxConstants.STYLE_IMAGE_ALIGN] = mxConstants.ALIGN_LEFT;
		
		// Sets the default style for edges
		style = graph.getStylesheet().getDefaultEdgeStyle();
		style[mxConstants.STYLE_ROUNDED] = true;
		style[mxConstants.STYLE_STROKEWIDTH] = 3;
		style[mxConstants.STYLE_EDGE] = mxEdgeStyle.TopToBottom;
			// Creates a style with an indicator
		//var style = graph.getStylesheet().getDefaultEdgeStyle();
		style[mxConstants.STYLE_EDGE] = mxEdgeStyle.ElbowConnector;
		style[mxConstants.STYLE_ELBOW] = mxConstants.ELBOW_VERTICAL;
		

		mxConnectionHandler.prototype.isValidTarget = function(cell)
		{
			
			if(graph.getModel().isVertex(cell)  && cell.id.substr(-2,1) != "_"){
				var parent = graph.getDefaultParent();
				var model = graph.getModel();
				//获取所有节点信息
				var cells = new Array();
				graph.getCells(0, 0, 10000, 10000, parent, cells);
				for (var i = 0; i < cells.length; i++) {
					if(model.isEdge(cells[i])) {
						if((cells[i].source.getId() == sourceCell.id && cells[i].target.getId() == cell.id)
							|| (cells[i].source.getId() == cell.id && cells[i].target.getId() == sourceCell.id)){
							return null;
						}
					}
				}
				
				//时间控件
				//var source_gt = sourceCell.type.substr(0,2);
				//var target_gt = cell.type.substr(0,2);
				//alert(gt);
				//if(sourceCell.type == "Schedule"){
				//	if(cell.type == "Query" || cell.type == "History Group" || cell.type == "Leads Group" || target_gt == "GT"){
				//		return cell;
				//	}
				//}
				targetCell = cell;
				return cell;
				
			}else{
				return null;
			}
		};
		
		mxConnectionHandler.prototype.isValidSource = function(cell)
		{
			if(graph.getModel().isVertex(cell)){
				sourceCell = cell;
				return cell;
			}
		};
			
		//鼠标双击事件
		graph.dblClick = function(evt, cell) {
		
			if (graph.getModel().isVertex(cell)) {
				if (!graph.cellsLocked) {
					//var offsetW = evt.offsetX - cell.geometry.x;
					//var offsetH = evt.offsetY - cell.geometry.y;
					//if(offsetW <= 40 && offsetH <= 40){
					/////	window.location.href = "<%=path%>/contact/effect?openId=${openId}&publicId=${publicId}&rowId="+cell.id+"&cname="+cell.value;
					//}else{
						currSelCellId = cell.getId();
						displayEditArea("display",cell);
					//}
				}
			} else {	//$(".deleteEdges").css("display","");
				if(typeof(cell) != 'undefined' && cell.edge){
					selEdges = cell;
					//
					displayEditEdgeArea("display",cell);
					//graph.removeCells([cell]); 
				}
			}
		};

		//单击事件
		graph.addListener(mxEvent.CLICK, function(sender, evt) {
			if (graph.getModel().isVertex(cell)) {
			} else {
				//displayEditAreca("none",null);
			}
		});
		parent = graph.getDefaultParent();

	 }
};

function addNodes(contact){
	graph.getModel().beginUpdate();
	try { 
		var v1 =  new mxCell( contact.name,  new mxGeometry(contact.x, contact.y, 115, 125),'align=left;verticalAlign=top;fontSize=16;fontWeight:bold;image='+contact.image,true);
		v1.id = contact.id;
		//graph.updateCellSize(v1);
		var v11 = graph.insertVertex(v1, contact.id+'_1',"拜访:    "+contact.tasknum, -1, 1, 10, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:\'Microsoft YaHei\'', true);
		v11.geometry.offset = new mxPoint(80, -80);
		var v12 = graph.insertVertex(v1, contact.id+'_2', "处境:    "+contact.plight, -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:\'Microsoft YaHei\'', true);
		v12.geometry.offset = new mxPoint(80, -60);
		var v13 = graph.insertVertex(v1, contact.id+'_3', contact.title, -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:Microsoft YaHei', true);
		v13.geometry.offset = new mxPoint(115, -98);
		var v14 = graph.insertVertex(v1, contact.id+'_4', "特点:    "+contact.nature, -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:Microsoft YaHei', true);
		v14.geometry.offset = new mxPoint(80, -40); 
		var v15 = graph.insertVertex(v1, contact.id+'_5', "角色:    "+contact.att, -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:Microsoft YaHei', true);
		v15.geometry.offset = new mxPoint(80, -20); 
		v1.setVertex(true);
		graph.addCell(v1);
	}finally{ 
		graph.getModel().endUpdate(); 
	}
}

//放大与缩小画板
function zoomInOut(type){
	if(type == "in"){
		graph.zoomIn();
	}else if(type=="out"){
		graph.zoomOut();
	}else{
		graph.zoomActual();
	}
}

function deleteEdges(){
	$(".deleteEdges").click(function(){
		if(selEdges){
			graph.removeCells(selEdges);
			selEdges = null;
			$(".deleteEdges").css("display","none");
		}
	});
	
}

function displayEditArea(flag,cell){
	if(cell != null && flag == "display" && cell.id.substr(-2,1) != "_"){
		$("input[name=conId]").val(cell.id);
		//var tasknum = cell.getChildAt(0).getValue();
		//if(tasknum == ""){
		//	tasknum = "0";
		//}
		$("#conname").html(cell.value);//+"(拜访"+tasknum+"次)");
		$(".nodediv").css("display","");
		$(".operdiv").css("display","none");
		$(".shade").css("display","");
	}else{
		window.location.href = "<%=path%>/contact/effect?openId=${openId}&publicId=${publicId}&rowId="+$("input[name=conId]").val()+"&cname="+$("#conname").html();
		$("input[name=conId]").val('');
		$(".nodediv").css("display","none");
		$(".operdiv").css("display","");
		$(".shade").css("display","none");
	}
}

//添加关系
function displayEditEdgeArea(flag,cell){
	if(cell != null && flag == "display"){
		if(selEdges == null || selEdges.source == null || selEdges.target == null){
			$(".saverelaben").css("display","none");
			$(".relationdiv").css("display","none");
			$(".delrelaedge").css("width","100%");
		}else{
			$(".saverelaben").css("display","");
			$(".relationdiv").css("display","");
			$(".delrelaedge").css("width","50%");
		}
		
		$(".edgediv").css("display","");
		$(".operdiv").css("display","none");
		$(".shade").css("display","");
	}else{
		$(".edgediv").css("display","none");
		$(".operdiv").css("display","");
		$(".shade").css("display","none");
	}
}

//关系处理
function contactRela(type){
	if(type == 'del'){
		graph.removeCells([selEdges]);
		displayEditEdgeArea("none",null);
	}else if(type == 'save'){
		displayEditEdgeArea("none",null);
		var relaname = $("select[name=relation] option:selected").text();
		var parent = graph.getDefaultParent();
		var model = graph.getModel();
		//获取所有节点信息
		var cells = new Array();
		graph.getCells(0, 0, 10000, 10000, parent, cells);
		for (var i = 0; i < cells.length; i++) {
			if(model.isEdge(cells[i])) {
				if(cells[i].getId() == selEdges.getId()){
					createEdges(cells[i].source,cells[i].target,relaname,selEdges.getId());
					break;
				}
			}
		}
		
	}
}


//创建线条
function createEdges(sCell,tCell,title,id){
	
	var parent = graph.getDefaultParent();
	graph.stopEditing(false);
	if(selEdges){
		graph.removeCells([selEdges]);
		selEdges = null;
	}
	graph.insertEdge(parent, id, title,sCell, tCell, 'strokeColor=blue;fontSize=14');
	sourceCell = null;
	targetCell = null;
	
	saveXML();
}

//修改业务机会联系人属性
function updateContactTAS(){
	var dataObj = [];
	var conid = $("input[name=conId]").val();
	var plight = $("select[name=plight]").val();
	var roles = $("select[name=userroles]").val();
	var adapting = $("select[name=adaptingchange]").val();
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'parentType', value:'Opportunities'});
	dataObj.push({name:'parentId', value:'${rowId}'});
	dataObj.push({name:'rowid', value:conid});
	dataObj.push({name:'plight', value:plight});
	dataObj.push({name:'roles', value:roles});
	dataObj.push({name:'adapting', value:adapting});
	$.ajax({
		type: 'get',
		url: '<%=path%>/contact/update',
		data: dataObj || {},
		dataType: 'text',
		success: function(data){
			var d  = JSON.parse(data);
			if(d.errorCode && d.errorCode !== '0'){
			   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
			   $(".myMsgBox").delay(2000).fadeOut();
			   return;
			}else{
				if(graph.getSelectionCell()){
					graph.getModel().beginUpdate();
	 				try {
	 					var v1 = graph.getModel().getCell(conid).getChildAt(1);
	 					var v2 = graph.getModel().getCell(conid).getChildAt(3);
	 					var v3 = graph.getModel().getCell(conid).getChildAt(4);
	 					graph.getModel().remove(v1);
	 					graph.getModel().remove(v2);
	 					graph.getModel().remove(v3);
	 					
	 					var v12 = graph.insertVertex(graph.getModel().getCell(conid), conid+'_2', "处境:    "+$("select[name=plight] option:selected").text(), -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:\'Microsoft YaHei\'', true);
	 					v12.geometry.offset = new mxPoint(80, -60);
	 					
	 					var v13 = graph.insertVertex(graph.getModel().getCell(conid),conid+'_4', "特点:    "+$("select[name=adaptingchange] option:selected").text(), -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:Microsoft YaHei', true);
	 					v13.geometry.offset = new mxPoint(80, -40); 
	 					
	 					var v15 = graph.insertVertex(graph.getModel().getCell(conid), conid+'_5', "角色:    "+$("select[name=userroles] option:selected").text(), -1, 1, 0, 0, 'align=left;verticalAlign=top;fontSize=10;fontFamily:Microsoft YaHei', true);
	 					v15.geometry.offset = new mxPoint(80, -20); 
	 					
	 					//graph.getModel().getCell(conid).getChildAt(1).setValue("处境:    "+$("select[name=plight] option:selected").text());
	 					//graph.getModel().getCell(conid).getChildAt(3).setValue("特点:    "+$("select[name=adaptingchange] option:selected").text());
	 					//graph.getModel().getCell(conid).getChildAt(4).setValue("角色:    "+$("select[name=userroles] option:selected").text());	 	
	 					
	 					
	 				}finally{
	 					graph.getModel().endUpdate(); 
	 				}
				}
				displayEditArea("none",null);
				saveXML();
			}
		}
	});
}

//加载设计数据
function loadXML(gxml){
	graph.getModel().beginUpdate();
	try {
		var doc = null;
		var root = null;
		if(gxml!=null){
			root = mxUtils.parseXml(gxml);
			doc = root.documentElement;
			var dec = new mxCodec(root);  
			dec.decode(doc, graph.getModel()); 
		}
	  }finally{ 
		 graph.getModel().endUpdate(); 
	 }
}

//加载数据
function loadData(){
	if("" != '${gxml}'){
		loadXML('${gxml}');
	}
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'parentType', value:'Opportunities'});
	dataObj.push({name:'parentId', value:'${rowId}'});
	dataObj.push({name:'currpage', value:'1'});
	dataObj.push({name:'pagecount', value:'100'});
	$.ajax({
		   type: 'get',
		   url: '<%=path%>/contact/rela',
		   data: dataObj || {},
		   dataType: 'text',
		   success: function(data){
			   var p = graph.getDefaultParent();
				var model = graph.getModel();
				var vertexsArray = new Array();
				//获取所有节点信息
				var cells = new Array();
				graph.getCells(0, 0, 10000, 10000, p, cells);
				for (var k = 0; k < cells.length; k++) {
					if (model.isVertex(cells[k])) {
						vertexsArray.push(cells[k]);
					}
				}
			   if(data == ''){
				   for (var j = 0; j < vertexsArray.length; j++) {
	 					tmp =  vertexsArray[j];
	 					graph.removeCells([tmp]);
	 				}
	 				  return;
	 		   }
			   
	 			  var d = JSON.parse(data);
	 			  if(d.errorCode && d.errorCode !== '0'){
 				     $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
 				     $(".myMsgBox").delay(2000).fadeOut();
 				     return;
 				  }
	 			  var i = 0;
	 			  var flag = false;
	 			  if(d){
	 				  //删除多余的节点
	 				  var tmp = null;
	 				  var exists = false;
	 				  vertexsArray.splice(0,vertexsArray.length);
	 				  graph.getCells(0, 0, 10000, 10000, p, cells);
		 			 	for (var k = 0; k < cells.length; k++) {
		 					if (model.isVertex(cells[k])) {
		 						vertexsArray.push(cells[k]);
		 					}
		 				}
	 				  for (var j = 0; j < vertexsArray.length; j++) {
	 					 exists = false;
	 					 tmp =  vertexsArray[j];
	 					 $(d).each(function(){
	 						 if(tmp.getId() == this.rowid){
	 						 	exists = true;
	 					 	}
	 					 });
	 					 if(!exists){
	 						 graph.removeCells([tmp]);
	 						 vertexsArray.splice(j,1);
	 						 j = j-1;
	 					 }
	 				  }
	 				  //添加新节点
				      $(d).each(function(){
				    	  flag = false;
				    	  for (var j = 0; j < vertexsArray.length; j++) {
				    		  if(this.rowid == vertexsArray[j].getId()){
				    			    graph.getModel().beginUpdate();
				    				try {
				    					 vertexsArray[j].getChildAt(0).setValue("拜访:    "+this.tasknum);
				    					 if(this.plightname){
						    			 	vertexsArray[j].getChildAt(1).setValue("处境:    "+this.plightname);
				    					 }
				    					 if(this.conjob){
						    				 vertexsArray[j].getChildAt(2).setValue(this.conjob);
				    					 }
				    					 if(this.adaptingname){
						    			 	vertexsArray[j].getChildAt(3).setValue("特点:    "+this.adaptingname);
				    					 }
				    					 if(this.rolesname){
							    			 vertexsArray[j].getChildAt(4).setValue("角色:    "+this.rolesname);
					    				 }
				    					 
				    				}finally{ 
				    					 graph.getModel().endUpdate(); 
				    				}
				    			    
				    		  		flag = true;
				    		  		break;
				    		  }
				    	  }
				    	  if(!flag){
				    		  i++;
					    	  var contact = new Object();
					    	  contact.id=this.rowid;
					    	  contact.title = this.conjob;
					    	  contact.name = this.conname;
					    	  if(null == this.filename || '' == this.filename){
					    		  contact.image = '<%=path%>/image/defailt_person.png';
					    	  }else{
					    	 	  contact.image = '<%=path%>/contact/download?fileName='+this.filename;
					    	  }
					    	  contact.tasknum = this.tasknum;
					    	  contact.att = this.rolesname + ' ';
					    	  contact.nature = this.adaptingname + ' ';
					    	  contact.plight = this.plightname + ' ';
					    	  if(i%2 == 0){
					    		  contact.x = 170;
					    		  contact.y = i*40 - 30 - 40; 
					    		  addNodes(contact);
					    	  }else{
					    		  contact.x = 20;
					    		  contact.y = i*40 - 30;
					    		  addNodes(contact);
					    	  }
					    	 
				    	  }
				    	  
		 			  });
	 			  }
		   }
	});
}

//保存数据
function saveXML(){
	var encoder = new mxCodec();
	var node = encoder.encode(graph.getModel());
	var sXml=mxUtils.getPrettyXml(node);

	var dataObj = [];
	dataObj.push({name:'crmId', value:'${crmId}'});
	dataObj.push({name:'rowId', value:'${rowId}'});
	dataObj.push({name:'gxml', value:sXml});
	$.ajax({
		type: 'post',
		url: '<%=path%>/oppty/updategxml',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var obj  = JSON.parse(data);
				if(obj.errorCode && obj.errorCode !== '0'){
	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
	    		   $(".myMsgBox").delay(2000).fadeOut();
		    	} else {
					$(".myMsgBox").css("display","").html("保存成功");
					$(".myMsgBox").delay(2000).fadeOut();
				}
			}
		});
	}
</script>
</head>

<body style="background-color:#fff;min-height:100%;">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a href="<%=path%>/contact/list?parentType=Opportunities&parentId=${rowId}&openId=${openId}&publicId=${publicId}"style="color:#fff;">列表</a>
		</div>
		关系层次结构图
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="graphContainer"
		style="background-color: #fff; overflow: visible; position: relative;"></div>
	<div id="outlineContainer"
		style="z-index: 1; position: absolute; overflow: hidden; top: 62px; right: 0px; width: 100px; height: 70px; background: transparent; border-style: solid; border-color: lightgray;">
	</div>
	<div class="flooter operdiv"
		style="border-top: 1px solid #999; background-color: #eee;">
		<div
			style="width: 60%; height: 40px; float: left; line-height: 40px; text-align: left; padding-left: 10px;">
			<span style="padding-right: 10px;"><img
				src="<%=path%>/scripts/plugin/mxGraph/images/106.png" width="30px;"
				onclick="zoomInOut('in')"></span> <span style="padding-right: 10px;"><img
				src="<%=path%>/scripts/plugin/mxGraph/images/16.png" width="30px;"
				onclick="zoomInOut('act')"></span> <span style="padding-right: 10px;"><img
				src="<%=path%>/scripts/plugin/mxGraph/images/107.png" width="30px;"
				onclick="zoomInOut('out')"></span> <span class="deleteEdges"
				style="display: none; padding-right: 10px;"><img
				src="<%=path%>/scripts/plugin/mxGraph/images/delete.png"
				width="30px;"></span>
		</div>
		<div style="float: right; width: 100px;">
			<a class="btn btn-block " type="button" onclick="saveXML();"
				style="font-size: 14px; height: 2.8em; line-height: 2.8em">保&nbsp;存</a>
		</div>
	</div>
	<div class="shade" style="display: none"></div>
	<div class="flooter nodediv"
		style="z-index: 99999; background: #FFF; border-top: 1px solid #A2A2A2; opacity: 1; display: none; color: #000; font-size: 14px;">
		<input type="hidden" name="conId" value="">
		<table style="width: 100%; font-size: 14px;">
			<tr>
				<td width="100px"
					style="text-align: right; height: 40px; vertical-align: middle;">姓名：</td>
				<td style="text-align: left;">
					<div id="conname"
						style="float: left; line-height: 40px; height: 40px;">&nbsp;</div>
				</td>
			</tr>
			<tr>
				<td style="text-align: right; height: 40px;">特点：</td>
				<td style="text-align: left;">
					<div style="line-height: 40px; height: 40px;">
						<select name="adaptingchange" style="width: 200px; height: 38px;">
							<c:forEach var="item" items="${adapting_change_list}"
								varStatus="status">
								<option value="${item.key}" selected>${item.value}</option>
							</c:forEach>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td style="text-align: right; height: 40px;">角色：</td>
				<td style="text-align: left;"><select name="userroles"
					style="width: 200px; height: 38px;">
						<c:forEach var="item" items="${contact_role_list}"
							varStatus="status">
							<option value="${item.key}" selected>${item.value}</option>
						</c:forEach>
				</select></td>
			</tr>
			<tr>
				<td style="text-align: right; height: 40px;">处境：</td>
				<td style="text-align: left;"><select name="plight"
					style="width: 200px; height: 38px;">
						<c:forEach var="item" items="${plight_list}" varStatus="status">
							<option value="${item.key}" selected>${item.value}</option>
						</c:forEach>
				</select></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">
				
					<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-b">
							<a href="javascript:void(0)"  onclick="displayEditArea('none',null)"
								class="btn btn-block" style="background-color: orange;color:#fff;" style="font-size: 14px;"> 影响力 </a>
						</div>
						<div class="ui-block-a">
							<a href="javascript:void(0)" 
								class="btn btn-success btn-block" style="background-color: #49af53" style="font-size: 14px;" onclick="updateContactTAS()"> 保 存 </a>
						</div>
					</fieldset>
					</div>
				</td>
			</tr>
		</table>
	</div>

	<div class="flooter edgediv"
		style="z-index: 99999; background: #FFF; border-top: 1px solid #A2A2A2; opacity: 1; display: none; color: #000; font-size: 14px;">

		<div style="line-height: 40px; height: 40px;width:100%;" class="relationdiv">
			<div style="float:left">关系类型：</div>
			<div style="width:100%;margin-left:80px;margin-right:10px;">
				<select name="relation" style="height: 38px;">
					<option value="r1" selected>朋友</option>
					<option value="r2" selected>同事</option>
					<option value="r3" selected>上下级</option>
					<option value="r4" selected>夫妻</option>
					<option value="r5" selected>合作</option>
				</select>
			</div>
		</div>
		<div style="clear:both"></div>
		<div class="button-ctrl">
			<fieldset class="">
				<div class="ui-block-b">
					<a href="javascript:void(0)" 
						onclick="contactRela('save')" class="btn btn-success btn-block saverelaben"
						style="background-color: #49af53" style="font-size: 14px;">
						保存关系 </a>
				</div>
				<div class="ui-block-a delrelaedge">
					<a href="javascript:void(0)" 
						class="btn  btn-block" style="background-color: #999999"
						style="font-size: 14px;" onclick="contactRela('del')"> 删除连线 </a>
				</div>
			</fieldset>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>