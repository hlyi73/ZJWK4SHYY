<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html >
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta content="MSHTML 6.00.2900.5848" name=GENERATOR >
	<title>左侧导航</title>
	<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
	
	<style type=text/css>
		body{
		    font-size:12px
		}
		#menutree a {
			color: #566984;
			text-decoration: none
		}
	</style>
	
	<script src="<%=path%>/scripts/plugin/communication/js/TreeNode.js"
		type=text/javascript></script>
	<script src="<%=path%>/scripts/plugin/communication/js/Tree.js"
		type=text/javascript></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
		
	<script type=text/javascript>
		$(function(){
			initTreeData();
		});
	
	    function initTreeData(){
	    	asyncInvoke({
	    		url: '<%=path%>/articleType/asynlist',
	    		data: {},
	    	    callBackFunc: function(data){
	    	    	var d = JSON.parse(data);
	    	    	//初始化关联的数据列表
	    	    	compileTreeData(d);
	    	    }
	    	});
	    }
	    
	    
	    function compileTreeData(d){
	    	var root = new TreeNode('系统菜单');
	    	$(d).each(function(){
	    		var fun = new TreeNode(this.name);
	    	
				var fun_1 = new TreeNode('添加' + this.name, 'add.jsp?type='+ this.code + '&id=' + this.id+'&assignerid=<%=request.getParameter("assignerid")%>&orgId=<%=request.getParameter("orgId")%>', 'tree_node.gif', null,
						'tree_node.gif', null);
				var fun_2 = new TreeNode(this.name + '列表', '<%=path%>/pccomm/list?type='+ this.code + '&id=' + this.id+'&assignerid=<%=request.getParameter("assignerid")%>&orgId=<%=request.getParameter("orgId")%>', 'tree_node.gif',
						null, 'tree_node.gif', null);
				fun.add(fun_1);
				fun.add(fun_2);
				root.add(fun);
	    	});
			var tree = new Tree(root);
			    tree.show('menuTree')
	    }
	</script>
	
  </head>
<body>
	<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%" style="font-family: '微软雅黑'">
		<TBODY>
			<TR>
				<TD></TD>
				<TD id=menuTree
					style="PADDING-RIGHT: 10px; PADDING-LEFT: 10px; PADDING-BOTTOM: 10px; PADDING-TOP: 10px; HEIGHT: 100%; BACKGROUND-COLOR: white"
					vAlign=top></TD>
				<TD></TD>
			</TR>
			<TR>
				<TD width=10><IMG
					src="<%=path%>/scripts/plugin/communication/images/bg_left_bl.gif"></TD>
				<TD></TD>
				<TD width=10><IMG
					src="<%=path%>/scripts/plugin/communication/images/bg_left_br.gif"></TD>
			</TR>
		</TBODY>
	</TABLE>
	<SCRIPT type=text/javascript>
		/* var tree = null;
		var root = new TreeNode('系统菜单');
		
		var fun1 = new TreeNode('介绍管理');
		
		var fun1_1 = new TreeNode('添加介绍', 'add.jsp?type=?', 'tree_node.gif', null,
				'tree_node.gif', null);
		var fun1_2 = new TreeNode('介绍列表', 'detail.jsp?type=?', 'tree_node.gif',
				null, 'tree_node.gif', null);
		
		fun1.add(fun1_1);
		fun1.add(fun1_2);
		
		root.add(fun1);
		
		
		var fun5 = new TreeNode('新闻管理');
		var fun6 = new TreeNode('添加新闻', 'add.jsp?type=2', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun5.add(fun6);
		var fun7 = new TreeNode('新闻列表', 'detail.jsp?type=2', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun5.add(fun7);
		root.add(fun5);
		
		var fun9 = new TreeNode('产品管理');
		var fun10 = new TreeNode('添加产品', 'add.jsp?type=3', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun9.add(fun10);
		var fun11 = new TreeNode('产品列表', 'detail.jsp?type=3', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun9.add(fun11);
		root.add(fun9);
		var fun13 = new TreeNode('案例管理');
		var fun14 = new TreeNode('添加案例', 'add.jsp?type=4', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun13.add(fun14);
		var fun15 = new TreeNode('案例列表', 'detail.jsp?type=4', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun13.add(fun15);
		root.add(fun13);
		
		var fun16 = new TreeNode('市场活动管理');
		var fun17 = new TreeNode('添加市场活动', 'add.jsp?type=5', 'tree_node.gif', null,
				'tree_node.gif', null);
		fun16.add(fun17);
		var fun18 = new TreeNode('市场活动列表', 'detail.jsp?type=5', 'tree_node.gif',
				null, 'tree_node.gif', null);
		fun16.add(fun18);
		root.add(fun16);
		tree = new Tree(root);
		tree.show('menuTree') */
	</SCRIPT>
</body>
</html>