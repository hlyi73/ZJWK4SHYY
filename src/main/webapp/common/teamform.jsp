<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 共享用户列表DIV -->
	<div id="shareuser-more" class="modal">
		<div id="" class="zjwk_fg_nav" style="display:none;">
		    <a href="#" onclick="javascript:void(0)" class="shareuserGoBak">取消</a>
		</div>
		
		<!-- 用户类别TAB -->
		<div class="nav nav-tabs nav-normal shareusertab" style="font-size:14px;">
			<div class="nav-item active systemuser">
				<a href="javascript:void(0)">系统用户</a>
			</div>
			<div class="nav-item attentionuser" style="font-size:14px;">
				<a href="javascript:void(0)">指尖好友 </a>
			</div>
		</div>
		
		<div class="page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currType" value="userList" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="1000" />
		    
		     <input type="hidden" name="fstChar1" />
		    <input type="hidden" name="currType1" value="followList" />
		    <input type="hidden" name="currPage1" value="1" />
		    <input type="hidden" name="pageCount1" value="1000" />
		    
			<!-- 字母区域 -->
			<div class="list-group-item listview-item  chartList" style="background: #fff;line-height: 30px;">
				<div style="font-size:14px;line-height:30px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span class="chartListSpan" ></span>
				</div>
			</div>
			<div class="list-group-item listview-item  chartList1" style="display:none;background: #fff;line-height: 30px;">
				<div style="font-size:14px;line-height:30px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span class="chartListSpan1" ></span>
				</div>
			</div>
			<div class="list-group listview  shareUserList">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0;font-size:14px;">
					无数据
				</div>
			</div>
			<!-- 关注者用户 -->
			<div class="list-group listview  followUserList" style="display:none">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0;font-size:14px;">
					无数据
				</div>
			</div>
			<div class=" flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:5x;">
				<input class="btn btn-default shareuserGoBak" type="button" value="取&nbsp;消" style="float:left;width: 48.5%;margin: 3px 0px 3px 3px;" />
				<input class="btn btn-block shareuserbtn" type="button" value="确&nbsp;定" style="float:left;width: 48.5%;margin: 3px 0px 3px 3px;" />
				<input class="btn btn-block followuserbtn" type="button" value="确&nbsp;定" style="float:left;display:none;width: 48.5%;margin: 3px 0px 3px 3px;" />
			</div>
		</div>
	</div>