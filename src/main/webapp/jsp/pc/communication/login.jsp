<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%
	String path = request.getContextPath();
%>
<HTML>
<HEAD>
<TITLE>传播管理中心登陆 V1.0</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="css/admin.css" type="text/css" rel="stylesheet">
</HEAD>
<BODY onload=document.form1.name.focus();>
<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%" bgColor=#002779 
border=0>
    <TR>
        <TD align=middle><TABLE cellSpacing=0 cellPadding=0 width=468 border=0>
                <TR>
                    <TD><IMG height=23 src="<%=path %>/scripts/plugin/communication/images/bg_left_bl.gif/login_1.jpg" 
          width=468></TD>
                </TR>
                <TR>
                    <TD><IMG height=147 src="<%=path %>/scripts/plugin/communication/images/bg_left_bl.gif/login_2.jpg" 
            width=468></TD>
                </TR>
            </TABLE>
            <TABLE cellSpacing=0 cellPadding=0 width=468 bgColor=#ffffff border=0>
                <TR>
                    <TD width=16><IMG height=122 src="<%=path %>/scripts/plugin/communication/images/bg_left_bl.gif/login_3.jpg" 
            width=16></TD>
                    <TD align=middle><TABLE cellSpacing=0 cellPadding=0 width=230 border=0>
                            <FORM name=form1 action=? method=post>
                                <TR height=5>
                                    <TD width=5></TD>
                                    <TD width=56></TD>
                                    <TD></TD>
                                </TR>
                                <TR height=36>
                                    <TD></TD>
                                    <TD>用户名</TD>
                                    <TD><INPUT 
                  style="BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; BORDER-LEFT: #000000 1px solid; BORDER-BOTTOM: #000000 1px solid" 
                  maxLength=30 size=24 value="www.mycodes.net" name=name></TD>
                                </TR>
                                <TR height=36>
                                    <TD>&nbsp;</TD>
                                    <TD>口　令</TD>
                                    <TD><INPUT 
                  style="BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; BORDER-LEFT: #000000 1px solid; BORDER-BOTTOM: #000000 1px solid" 
                  type=password maxLength=30 size=24 value="www.mycodes.net" 
                name=pass></TD>
                                </TR>
                                <TR height=5>
                                    <TD colSpan=3></TD>
                                </TR>
                                <TR>
                                    <TD>&nbsp;</TD>
                                    <TD>&nbsp;</TD>
                                    <TD><INPUT type=image height=18 width=70 
                  src="<%=path %>/scripts/plugin/communication/images/bt_login.gif"></TD>
                                </TR>
                            </FORM>
                        </TABLE></TD>
                    <TD width=16><IMG height=122 src="<%=path %>/scripts/plugin/communication/images/login_4.jpg" 
            width=16></TD>
                </TR>
            </TABLE>
            <TABLE cellSpacing=0 cellPadding=0 width=468 border=0>
                <TR>
                    <TD><IMG height=16 src="<%=path %>/scripts/plugin/communication/images/login_5.jpg" 
          width=468></TD>
                </TR>
            </TABLE>
            <TABLE cellSpacing=0 cellPadding=0 width=468 border=0>
                <TR>
                    <TD align=right><A href="http://www.mycodes.net/" target=_blank><IMG 
            height=26 src="<%=path %>/scripts/plugin/communication/images/bg_left_bl.gif/login_6.gif" width=165 
            border=0></A></TD>
                </TR>
            </TABLE></TD>
    </TR>
</TABLE>
</BODY>
</HTML>
