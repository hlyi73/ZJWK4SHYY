//菜单模板
var menuTemp = ['<div class="site-card-view bxFlowContent">',
					'<div id="div_parent_label" class="chatItem you" style="background: #FFF;">',
						'<div class="chatItemContent">',
							'<img class="avatar" src="..//scripts//plugin//wb//css//images//dc.png">',
							'<div class="cloud cloudText">',
								'<div class="cloudPannel">',
									'<div class="cloudBody">',
										'<div class="cloudContent links">',
											'<div style="word-wrap: break-word; font-family: \'Microsoft YaHei\';">',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="followOppty();">业务机会推进</a><div style="float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="updClosedDate();">调整关闭日期</a><div style="margin-left:40px;float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="toTasks(2);">添加任务</a><div style="float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="toContact(2);">添加联系人</a><div style="float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="updAmount();">调整金额</a><div style="float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="succOppty();">成单结束</a><div style="float:right">&gt;</div></div>',
												'<div class="follow_menu"><a style="line-height:30px;" href="javascript:void(0)" onclick="closeOppty();">关闭业务机会</a><div style="float:right">&gt;</div></div>',
											'</div>',
										'</div>',
									'</div>',
									'<div class="cloudArrow "></div>',
								'</div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

//任务列表模板
var listTemp = ['<div id="div_parent_list" class="chatItem you" style="background: #FFF;">',
					'<div class="chatItemContent">',
						'<img class="avatar" src="..//scripts//plugin//wb//css//images//dc.png">',
						'<div class="cloud cloudText" >',
							'<div class="cloudPannel">',
								'<div class="cloudBody">',
									'<div class="cloudContent links">',
										'<div style="width:100%;text-align:left;margin-bottom:3px;">',
											'请选择：',
										'</div>',
										'<div id="fristChartsList" style="word-wrap: break-word;word-break:break-all; font-family: \'Microsoft YaHei\';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">',
										'</div>',
										'<div style="width:100%;text-align:center;display:none;" id="div_prev" >',
											'<a href="javascript:void(0)"><img src="..//image/prevpage.png" width="32px"/></a>',
										'</div>',
										'<div id="list_item" style="word-wrap: break-word; font-family: \'Microsoft YaHei\';min-width:240px;"></div>',
										'<div style="width:100%;text-align:center;display:none;" id="div_next">',
											'<a href="javascript:void(0)"><img src="..//image/nextpage.png" width="32px"/></a>',
										'</div>',
									'</div>',
								'</div>',
								'<div class="cloudArrow "></div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

//me 内容回复响应模板
var respTemp = ['<div id="" class="chatItem me" style="background: #FFF;display:none;">',
					'<div class="chatItemContent">',
					'<img class="avatar" src="..//scripts//plugin//wb//css//images//user.png">',
						'<div class="cloud cloudText" style="margin: 0 15px 0 0;">',
							'<div class="cloudPannel" >',
								'<div class="cloudBody">',
									'<div class="cloudContent">',
										'<div id="oppty_attr" style="white-space: pre-wrap; font-family: \'Microsoft YaHei\';"></div>',
									'</div>',
								'</div>',
								'<div class="cloudArrow "></div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

//业务机会跟进
var requTemp = ['<div class="site-card-view bxFlowContent">',
					'<div id="div_parent_label" class="chatItem you" style="background: #FFF;">',
						'<div class="chatItemContent">',
							'<img class="avatar" src="..//scripts//plugin//wb//css//images//dc.png">',
							'<div class="cloud cloudText">',
								'<div class="cloudPannel">',
									'<div class="cloudBody">',
										'<div class="cloudContent links">',
											'<div id="request_div" style="font-size:14px;word-wrap: break-word; font-family: \'Microsoft YaHei\';">',
												'<div style="color: #99CCFF;font-weight: bold;">请选择销售阶段:</div>',
												'<div style="font-size:15px;color: #99CCFF;" class="screenbg salesStageBar">',
													'<div style="float:left;padding-left: 3px;padding-top: 20px;">阶段：<span style="color:red">销售前景</span></div>',
													'<div style="float:left;padding-left: 3px;padding-top: 20px;">--<span style="color:red" class="stepTickShowSp" > 销售前景</span></div>',
													'<div style="float:right;margin: 5px 0;">',
														'<a class="mini-button notlog stepSave" style="height:33px;line-height: 33px;" target="_brack" href="javascript:void(0)">确定</a>',
													'</div>',
												'</div>',
											'</div>',
										'</div>',
									'</div>',
									'<div class="cloudArrow "></div>',
								'</div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

//业务机会跟进 滑动条
var slideTemp =	['<div class="site-card-view opptyStepContainer">',
					'<div id="div_parent_label" class="chatItem you" style="background: #FFF;">',
						'<div class="chatItemContent">',
							'<div class="range-date">',
								'<div class="ui-date-slider liulin" data-widget-cid="widget-3">',
								    '<div class="ui-slider-line ui-slider ui-slider-horizontal" seed="f-consume-standard-shijianzhou" data-widget-cid="widget-4">',
										'<a class="ui-slider-handle ui-state-default stepTickShowHf" href="javascript:void(0)" seed="f-consume-standard-youbiao1" style="left: 5px;"></a>',
									'</div>',
								    '<div class="ui-date-slider-scales salesStageCon" style="margin-left: -27px;">',
								        '<div class="ui-date-slider-scale " style="visibility: hidden;">',
								             '<span class="ui-date-slider-month"></span>',
								             '<span class="ui-date-slider-line"></span>',
								         '</div>',
								    '</div>',
								    '<span class="ui-slider-handle-date stepTickShowSp" style="position: absolute; left: 5px; top: 11px;">销售前景</span>',
							   '</div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];