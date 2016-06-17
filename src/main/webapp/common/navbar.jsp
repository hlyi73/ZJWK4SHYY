<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>

<div id="nav-collapse" class="navbar-menu" style="position: absolute;opacity:1">
	<div class="navbar-wrap-menu" style=""></div>
</div>
<script>
	var testMenu=[
    {
        "name": "费用报销",
        "type":"expense",
        "submenu": [
            {
                "name": "报销费用",
                "url": "<%=path%>/expense/get?openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的待审批报销",
                "url": "<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approval&approval=approving&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "驳回的报销",
                "url": "<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的待提交的报销",
                "url": "<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_new&approval=new&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的历史报销",
                "url": "<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approved&approval=approved&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "待我审批的报销",
                "url": "<%=path%>/expense/list?viewtype=approvalview&viewtypesel=approvalview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "团队报销",
                "url": "<%=path%>/expense/list?viewtype=teamview&viewtypesel=teamview&openId=${openId}&publicId=${publicId}"
            },
            {
	            "name": "费用分析",
	            "submenu": [
	                {
	                    "name": "按用途统计费用",
	                    "url": "<%=path%>/analytics/expense/type?openId=${openId}&publicId=${publicId}"
	                },
	                {
	                    "name": "按类型统计费用",
	                    "url": "<%=path%>/analytics/expense/subtype?openId=${openId}&publicId=${publicId}"
	                },
	                {
	                    "name": "按部门统计费用",
	                    "url": "<%=path%>/analytics/expense/depart?openId=${openId}&publicId=${publicId}"
	                }
	            ]
   		    }
        ]
    },
    {
        "name": "业务机会",
        "type":"oppty",
        "submenu": [
            {
                "name": "添加业务机会",
                "url": "<%=path%>/oppty/get?openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的正在跟进的业务机会",
                "url": "<%=path%>/oppty/opptylist?viewtype=myfollowingview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的已成单的业务机会",
                "url": "<%=path%>/oppty/opptylist?viewtype=mywonview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的已关闭的业务机会",
                "url": "<%=path%>/oppty/opptylist?viewtype=myclosedview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "团队业务机会",
                "url": "<%=path%>/oppty/opptylist?viewtype=teamview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "业务机会分析",
                "submenu": [
                    {
                        "name": "业务机会分析-by月统计",
                        "url": "<%=path%>/analytics/oppty/stage?openId=${openId}&publicId=${publicId}"
                    },
                    {
                        "name": "销售管道分析",
                        "url": "<%=path%>/analytics/oppty/pipeline?openId=${openId}&publicId=${publicId}"
                    },
                    {
                        "name": "业务机会失败原因分析",
                        "url": "<%=path%>/analytics/oppty/failure?openId=${openId}&publicId=${publicId}"
                    },
                    {
                        "name": "业务机会阶段停留时间分析",
                        "url": "<%=path%>/analytics/oppty/salestage?openId=${openId}&publicId=${publicId}"
                    }
                ]
            }
        ]
    },
    {
        "name": "联系人",
        "type":"contact",
        "submenu": [
            {
                "name": "添加联系人",
                "url": "<%=path%>/contact/add?openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的联系人",
                "url": "<%=path%>/contact/clist?viewtype=myview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "团队联系人",
                "url": "<%=path%>/contact/clist?viewtype=teamview&openId=${openId}&publicId=${publicId}"
            }
        ]
    },
    {
        "name": "任务",
        "type":"schedule",
        "submenu": [
            {
                "name": "创建任务",
                "url": "<%=path%>/schedule/get?openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "当日任务",
                "url": "<%=path%>/schedule/list?viewtype=todayview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "历史任务",
                "url": "<%=path%>/schedule/list?viewtype=historyview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "计划任务",
                "url": "<%=path%>/schedule/list?viewtype=planview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "团队任务",
                "url": "<%=path%>/schedule/list?viewtype=teamview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "关注任务",
                "url": "<%=path%>/schedule/list?viewtype=focusview&openId=${openId}&publicId=${publicId}"
            }
        ]
    },
    {
        "name": "企业",
        "type":"customer",
        "submenu": [
            {
                "name": "添加企业",
                "url": "<%=path%>/customer/get?openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的企业",
                "url": "<%=path%>/customer/acclist?viewtype=myview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "团队企业",
                "url": "<%=path%>/customer/acclist?viewtype=teamview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "企业分析",
                "submenu": [
                    {
                        "name": "行业分析",
                        "url": "<%=path%>/analytics/customer/industry?openId=${openId}&publicId=${publicId}"
                    }
                ]
            }
        ]
    },
    {
        "name": "合同",
        "type":"contract",
        "submenu": [
            {
                "name": "正在履行的合同",
                "url": "<%=path%>/contract/list?viewtype=myview&viewtypesel=myview_effective&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "已完工的合同",
                "url": "<%=path%>/contract/list?viewtype=teamview&viewtypesel=myview_finish&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "我的团队合同",
                "url": "<%=path%>/contract/list?viewtype=teamview&viewtypesel=teamview&openId=${openId}&publicId=${publicId}"
            },
            {
                "name": "回款分析",
                "submenu": [
                    {
                        "name": "按月份统计回款",
                        "url": "<%=path%>/analytics/gathering/month?openId=${openId}&publicId=${publicId}"
                    },
                    {
                        "name": "按部门统计回款",
                        "url": "<%=path%>/analytics/gathering/depart?openId=${openId}&publicId=${publicId}"
                    },
                    {
                        "name": "企业回款统计分析",
                        "url": "<%=path%>/analytics/gathering/customer?openId=${openId}&publicId=${publicId}"
                    }
                ]
            }
        ]
    },
    {
        "name": "活动流",
        "type":"feed",
        "submenu": [
            {
                "name": "活动流",
                "url": "<%=path%>/feed/list?openId=${openId}&publicId=${publicId}"
            }
        ]
    }
];
	$(function(){
		new AccordionMenu({menuArrs:testMenu});
	});
	
	function AccordionMenu(options) {
		//
		this.config = {
			containerCls        : '.navbar-wrap-menu',                // 外层容器
			menuArrs            :  '',                         //  JSON传进来的数据
			type                :  'click',                    // 默认为click 也可以mouseover
			renderCallBack      :  null,                       // 渲染html结构后回调
			clickItemCallBack   : null                         // 每点击某一项时候回调
		};
		this.cache = {
			
		};
		this.init(options);
	 }

	 
	 AccordionMenu.prototype = {

		constructor: AccordionMenu,

		init: function(options){
			this.config = $.extend(this.config,options || {});
			var self = this,
				_config = self.config,
				_cache = self.cache;
			
			// 渲染html结构
			$(_config.containerCls).each(function(index,item){
				self._renderHTML(item);

				// 处理点击事件
				self._bindEnv(item);
			});
		},
		_renderHTML: function(container){
			var self = this,
				_config = self.config,
				_cache = self.cache;
			var ulhtml = $('<ul></ul>');
			$(_config.menuArrs).each(function(index,item){
				var lihtml = $('<li><h2><img src="<%=path%>/image/icon_cirle.png">'+item.name+'</h2></li>');
				if(item.submenu && item.submenu.length > 0) {
					self._createSubMenu(item.submenu,lihtml);
				}
				$(ulhtml).append(lihtml);
			});
			$(container).append(ulhtml);
			
			_config.renderCallBack && $.isFunction(_config.renderCallBack) && _config.renderCallBack();
			
			// 处理层级缩进
			self._levelIndent(ulhtml);
		},
		/**
		 * 创建子菜单
		 * @param {array} 子菜单
		 * @param {lihtml} li项
		 */
		_createSubMenu: function(submenu,lihtml){
			var self = this,
				_config = self.config,
				_cache = self.cache;
			var subUl = $('<ul></ul>'),
				callee = arguments.callee,
				subLi;
			
			$(submenu).each(function(index,item){
				var url = item.url || 'javascript:void(0)';

				subLi = $('<li><a href="'+url+'">'+item.name+'</a></li>');
				if(item.submenu && item.submenu.length > 0) {

					$(subLi).children('a').prepend('<img src="<%=path%>/image/blank.gif" alt=""/>');
	                callee(item.submenu, subLi);
				}
				$(subUl).append(subLi);
			});
			$(lihtml).append(subUl);
		},
		/**
		 * 处理层级缩进
		 */
		_levelIndent: function(ulList){
			var self = this,
				_config = self.config,
				_cache = self.cache,
				callee = arguments.callee;
		   
			var initTextIndent = 2,
				lev = 1,
				$oUl = $(ulList);
			
			while($oUl.find('ul').length > 0){
				initTextIndent = parseInt(initTextIndent,10) + 2 + 'em'; 
				$oUl.children().children('ul').addClass('lev-' + lev)
							.children('li').css('text-indent', initTextIndent);
				$oUl = $oUl.children().children('ul');
				lev++;
			}
			
			$(ulList).find('ul').hide();			
			$(ulList).find('ul:first').show();	
		},
		/**
		 * 绑定事件
		 */
		_bindEnv: function(container) {
			var self = this,
				_config = self.config;

			$('h2,a',container).unbind(_config.type);
			$('h2,a',container).bind(_config.type,function(e){
				if($(this).siblings('ul').length > 0) {
					$(this).siblings('ul').slideToggle('slow').end().children('img').toggleClass('unfold');
				}

				$(this).parent('li').siblings().find('ul').hide()
					   .end().find('img.unfold').removeClass('unfold');
				_config.clickItemCallBack && $.isFunction(_config.clickItemCallBack) && _config.clickItemCallBack($(this));

			});
		}
	 };

</script>