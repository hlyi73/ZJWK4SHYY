<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
	<%@ include file="/common/jquerylibs.jsp"%><!-- jquerylibs.jsp page -->
	
	<script type="text/javascript">
			//页面初始化
			function init() {
				//initWeixinFunc();
				initFormBtn();
				rstFunc();
			}
			//微信网页按钮控制
			/* function initWeixinFunc(){
				//隐藏顶部
				document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
					WeixinJSBridge.call('hideOptionMenu');
				});
				//隐藏底部
				document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
					WeixinJSBridge.call('hideToolbar');
				});
			} */
			//初始化查询区域按钮
			function initFormBtn(){
				//TODO 
			}
			function rstFunc(){
		        //TODO 
		    }
	</script>
	<!-- 初始化调用 -->
	<script type="text/javascript">
	$(function() {
		init();
	});
	</script>
</head>

<body>

<div class="container">		
	<div class="row">
        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3">
            <form class="reg-page">
                <div class="reg-header">            
                    <h2>登录<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></h2>
                </div>

                <div class="input-group margin-bottom-20">
                    <span class="input-group-addon"><i class="icon-user"></i></span>
                    <input type="text" placeholder="手机号" class="form-control">
                </div>                    
                <div class="input-group margin-bottom-20">
                    <span class="input-group-addon"><i class="icon-lock"></i></span>
                    <input type="text" placeholder="密码" class="form-control">
                </div>                    

                <div class="row">
                    <div class="col-md-6">
                        <label class="checkbox"><input type="checkbox"> 记住我</label>                        
                    </div>
                    <div class="col-md-6">
                        <button class="btn-u pull-right" type="submit">登录</button>                        
                    </div>
                </div>

                <hr>

                <h4>忘记登录密码 ?</h4>
                <p>别担心, <a class="color-green" href="#">点这里</a> 重置你的密码.</p>
            </form>            
        </div>
    </div><!--/row-->
</div>

</body>
</html>