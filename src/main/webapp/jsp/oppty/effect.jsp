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
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
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
});

var currSelCell = null;
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
		mxRectangleShape.prototype.crisp = true;
		mxArrow.prototype.crisp = false;
		
		graph = new mxGraph(container);
		graph.setConnectable(true);
		graph.setCellsResizable(false);
		graph.setPanning(true);
		graph.foldingEnabled = false;
		
		
		//var outline = document.getElementById('outlineContainer');
		//var outln = new mxOutline(graph, outline);

	    var style = graph.getStylesheet().getDefaultVertexStyle();
		style[mxConstants.STYLE_SHAPE] = 'label'; 
		style[mxConstants.STYLE_VERTICAL_ALIGN] = mxConstants.ALIGN_MIDDLE;
    	//style[mxConstants.STYLE_ALIGN] = mxConstants.ALIGN_LEFT;
		//style[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_ELLIPSE; 
		//style[mxConstants.STYLE_PERIMETER] = mxPerimeter.EllipsePerimeter;
		style[mxConstants.STYLE_FONTCOLOR] = 'red';
		//style[mxConstants.STYLE_FONTSTYLE] = mxConstants.FONT_BOLD;

		style[mxConstants.STYLE_FILL] = '#ffffff';//'#5d65df';
		style[mxConstants.STYLE_FILLCOLOR] = '#ffffff'; 
		style[mxConstants.STYLE_IMAGE_WIDTH] = '35';
		style[mxConstants.STYLE_IMAGE_HEIGHT] = '35';
		style[mxConstants.STYLE_ROUNDED] = '1'; 
		
		style = graph.getStylesheet().getDefaultEdgeStyle();
		style[mxConstants.STYLE_STROKEWIDTH] = 2;
		style[mxConstants.STYLE_STROKECOLOR] = 'red'; 
		
		//鼠标双击事件 
		graph.dblClick = function(evt, cell) {
		
			if (graph.getModel().isVertex(cell)) {
				if (!graph.cellsLocked) {
				}
			} else {
				//graph.removeCells(cell);
			}
		}; 

		//单击事件
		graph.addListener(mxEvent.CLICK, function(sender, evt) {
			if (graph.getModel().isVertex(cell)) {
				if(null != currSelCell && cell.id != currSelCell.id){
					
				}
			} else {
			}
		});
		parent = graph.getDefaultParent();

	 }
};

function addNodes(contact){
	graph.getModel().beginUpdate();
	try { 
		var v1 =  new mxCell( contact.name,  new mxGeometry(contact.x, contact.y, 45, 45),'verticalLabelPosition=bottom;image='+contact.image,true);
		v1.id = contact.id;
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
		graph.removeCells(selEdges);
		selEdges = null;
		$(".deleteEdges").css("display","none");
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
	if("" != '${effectgxml}'){
		loadXML('${effectgxml}');
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
				var edgesArray = new Array();
				//获取所有节点信息
				var cells = new Array();
				graph.getCells(0, 0, 10000, 10000, p, cells);
				for (var k = 0; k < cells.length; k++) {
					if (model.isVertex(cells[k])) {
						vertexsArray.push(cells[k]);
					} else if (model.isEdge(cells[k])) {
						//edgesArray.push(cells[i]);
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
	 			  //错误信息判断
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
	 					 }
	 				  }
	 				  //添加新节点
				      $(d).each(function(){
				    	  for (var j = 0; j < vertexsArray.length; j++) {
				    		  if(this.rowid == vertexsArray[j].getId()){
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
	dataObj.push({name:'effectxml', value:sXml});
	$.ajax({
		type: 'post',
		url: '<%=path%>/oppty/updategxml',
		data: dataObj || {},
		dataType: 'text',
		success: function(data){
			var obj  = JSON.parse(data);
			if(obj.errorCode && obj.errorCode !== '0'){
    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
    		   $(".myMsgBox").delay(2000).fadeOut();
	    	}else{
				$(".myMsgBox").css("display","").html("保存成功!");
				$(".myMsgBox").delay(2000).fadeOut();
			}
		}
	});
}
</script>
</head>

<body>
		<div id="site-nav" class="navbar">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse">
<!-- 				<i class="icon-menu"><b></b></i> -->
			</div>
			影响力
		</div>
<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="graphContainer" style="background-image:url(<%=path %>/image/effect_bg.png);background-position: center;background-repeat: no-repeat;background-size:100% 100%; overflow:visible;position: relative;"> </div>  
	<div id="outlineContainer"
		style="display:none;z-index:1;position:absolute;overflow:hidden;top:62px;right:0px;width:100px;height:70px;background:transparent;border-style:solid;border-color:lightgray;">
	</div>
	<div class="flooter operdiv"
		style="background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
		<div
			style="width: 60%; height: 40px; float: left; line-height: 40px; text-align: left; padding-left: 10px;display:none;">
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
		<a class="btn btn-block " type="button" onclick="saveXML();"
				style="width: 95%;margin: 3px 0px 3px 8px;font-size: 14px; height: 2.8em; line-height: 2.8em">保&nbsp;存</a>
		<div style="float: right; width: 100px;display:none;">
			
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<!--脚页面 
	<jsp:include page="/common/footer.jsp"></jsp:include> -->
</body>
</html>