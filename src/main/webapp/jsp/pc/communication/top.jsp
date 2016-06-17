<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html >
<%
	String path = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<STYLE type=text/css>
* {
	FONT-SIZE: 12px;
	COLOR: white
}

#logo {
	COLOR: white
}

#logo A {
	COLOR: white
}

FORM {
	MARGIN: 0px
}
</STYLE>
<SCRIPT src="<%=path%>/scripts/plugin/communication/js/Clock.js" type=text/javascript></SCRIPT>
<META content="MSHTML 6.00.2900.5848" name=GENERATOR>
<title>头部导航</title>
</head>
<body>
<form id="form1">
		<DIV id=logo
			style="BACKGROUND-IMAGE: url(); BACKGROUND-REPEAT: no-repeat">

			<DIV style="DISPLAY: block; HEIGHT: 54px"></DIV>
			<DIV
				style="BACKGROUND-IMAGE: url(<%=path%>/scripts/plugin/communication/images/bg_nav.gif); BACKGROUND-REPEAT: repeat-x; HEIGHT: 30px">
				<TABLE cellSpacing=0 cellPadding=0 width="100%">
					<TBODY>
						<TR>
							<TD><DIV>
									<IMG src="<%=path%>/scripts/plugin/communication/images/nav_pre.gif" align=absMiddle> 欢迎 <SPAN
										id=lblBra>德成鸿业</SPAN> <SPAN id=lblDep>B2B研发部</SPAN> [系统管理员 ]
									光临
								</DIV></TD>
							<TD align=right width="70%"><SPAN
								style="PADDING-RIGHT: 50px"><A
									href="javascript:history.go(-1);"><IMG
										src="<%=path%>/scripts/plugin/communication/images/nav_back.gif" align=absMiddle border=0>后退</A> <A
									href="javascript:history.go(1);"><IMG
										src="<%=path%>/scripts/plugin/communication/images/nav_forward.gif" align=absMiddle border=0>前进</A>
									<A href="http://localhost:1479/Web/default.aspx" target=_top><IMG
										src="<%=path%>/scripts/plugin/communication/images/nav_changePassword.gif" align=absMiddle border=0>重新登录</A>
									<A href="http://localhost:1479/Web/sys/updatePwd.aspx"
									target=mainFrame><IMG src="<%=path%>/scripts/plugin/communication/images/nav_resetPassword.gif"
										align=absMiddle border=0>修改密码</A> <A
									href="http://localhost:1479/Web/sys/Top.aspx#" target=mainFrame><IMG
										src="<%=path%>/scripts/plugin/communication/images/nav_help.gif" align=absMiddle border=0>帮助</A> <IMG
									src="<%=path%>/scripts/plugin/communication/images/menu_seprator.gif" align=absMiddle> <SPAN
									id=clock></SPAN></SPAN></TD>
						</TR>
					</TBODY>
				</TABLE>
			</DIV>
		</DIV>
		<SCRIPT type=text/javascript>
			var clock = new Clock();
			clock.display(document.getElementById("clock"));
		</SCRIPT>
	</form>
</body>
</html>