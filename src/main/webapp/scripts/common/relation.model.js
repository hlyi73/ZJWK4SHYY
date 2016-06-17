/**
 * 新增页面 公共 关联关系js
 */

var relation = {};

//ivk-> 对外提供接口 创建JS级的关联关系 
function ivk_createRelation(elementid, setting){
	initRelationElem(elementid, setting);
	loadFristCharListData(relation[elementid]);//加载首字母
	loadRelationListData(relation[elementid]);
}

//元素加载
function initRelationElem(elementid, setting){
	var obj = {};
	obj.curr_type = $("." + elementid).find(":hidden[name=curr_type]");
	obj.fst_char = $("." + elementid).find(":hidden[name=fst_char]");
	obj.curr_page = $("." + elementid).find(":hidden[name=curr_page]");
	obj.page_count = $("." + elementid).find(":hidden[name=page_count]");
	
	obj.fc_list = $("." + elementid).find(".fc_list");
	obj.pre_cus = $("." + elementid).find(".pre_cus");
	obj.content = $("." + elementid).find(".content");
	obj.next_cus = $("." + elementid).find(".next_cus");
	
	obj.crmid = setting.crmid;
	obj.openid = setting.openid;
	obj.publicid = setting.publicid;
	obj.flag = setting.flag;
	obj.viewtype = setting.viewtype;
	obj.parentid = setting.parentid;
	obj.parenttype = setting.parenttype;
	obj.type = setting.type;
	obj.async_flag = setting.async_flag;
	obj.callback_func = setting.callback_func;
	
	relation[elementid] = obj;
}

function loadRelationListData(obj){
	var search_url = '';
	if(obj.parenttype === "Opportunities"){
		search_url = getContentPath() + '/oppty/list'; //业务机会查询URL
		obj.curr_type.val('opptyList');
	}
	if(obj.parenttype === "Accounts"){
		search_url = getContentPath() + '/customer/list'; //客户查询URL
		obj.curr_type.val('accntList');
	}
	if(obj.parenttype === "Contract"){
		search_url = getContentPath() + '/contract/asylist'; //合同查询URL
		obj.curr_type.val('projectList');
	}
	if(obj.parenttype === "Contact"){
		search_url = getContentPath() + '/contact/asyclist'; //联系人查询URL
		obj.curr_type.val('contactList');
	}
	if(obj.parenttype === "Systemuser"){
		search_url = getContentPath() + '/lovuser/userlist'; //系统用户
	}
	if(obj.parenttype === "Serqexec"){
		search_url = getContentPath() + '/complaint/asycn_serexeclist'; //服务执行
	}
	$.ajax({
	      url: search_url,
	      data: {
			   crmId: obj.crmid,
			   openId: obj.openid,
			   publicId: obj.publicid,
			   openid: obj.openid,
			   publicid: obj.publicid,
			   flag: obj.flag,
			   viewtype: obj.viewtype,
			   parentid: obj.parentid,
			   parenttype: obj.parenttype,
			   firstchar: obj.fst_char.val(), 
			   currpage: obj.curr_page.val(),
			   pagecount: obj.page_count.val()
		  },
	      success: function(data){
	    	  var d = JSON.parse(data);
		      //初始化关联的数据列表
		      compRetionListData(obj, d);
		      //call back function
		      if(obj.callback_func){
		    	 obj.callback_func(d);
		      }    
	      }
	});
}

//查询模块的首字母
function loadFristCharListData(obj){
    var type='';
    if(obj.parenttype === "Opportunities"){
		type = "opptyList";
	}
	if(obj.parenttype === "Accounts"){
    	type="accntList";
	}
	if(obj.parenttype === "Contract"){
		type = "contractList";
	}
	if(obj.parenttype === "Contact"){
		type = "contactList";
	}
	obj.fc_list.empty();
    asyncInvoke({
		url: getContentPath() + '/fchart/list',
		async: obj.async_flag,
		data: {
		   crmId: obj.crmid,
		   type: obj.type,
		   parentid: obj.parentid,
		   parenttype: obj.parenttype
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode){
    	    	return;
    	    }
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)" onclick="javascript:void(0)">'+ this +'</a>';
    	    });
    	    obj.fc_list.html(ahtml);
    	    
    	    initCharCheckedBtn(obj);//字母选择事件
	    }
	});
}

//字母选择事件
function initCharCheckedBtn(obj){
	obj.fc_list.find("a").unbind("click").bind("click", function(){
		obj.curr_page.val("1");
		obj.fst_char.val($(this).html());
		loadRelationListData(obj);
	});
}

//初始化关联的数据列表
function compRetionListData(obj, data){
	//上一页 控制显示与否
	if(1 !== parseInt(obj.curr_page.val())){
		obj.pre_cus.css("display",'');
	}else{
		obj.pre_cus.css("display",'none');
	}
	//下一页 控制显示与否
	if(data.length === parseInt(obj.page_count.val())){
		obj.next_cus.css("display",'');
	}else{
		obj.next_cus.css("display",'none');
	}
	//data length 为0的判断
    if(data.length === 0){
    	return;
    }
    var v = '';
	$(data).each(function(){
		var name = '';
		var id = this.rowid;
		
		if(obj.parenttype === "Opportunities"){
			name = this.name;
		}
		if(obj.parenttype === "Accounts"){
			name = this.name;
		}
		if(obj.parenttype === "Contract"){
			name = this.title;
		}
		if(obj.parenttype === "Contact"){
			name = this.conname;
		}
		if(obj.parenttype === "Systemuser"){
			id = this.userid;
			name = this.username;
		}
		if(obj.parenttype === "Serqexec"){
			id = this.rowid;
			name = this.assigned_user_name + "于" + this.start_date + "执行： " + this.process_desc;
		}
		
		if(!id){
			return true;
		}
		
		v += '<div style="height:25px;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ id +'">'+ name +'</a>';
		v += '</div>';
	});

	if(v){
		obj.content.empty().html(v);
	}

	//绑定上一页
	obj.pre_cus.unbind("click").bind("click", function(event){
		var currpage = parseInt(obj.curr_page.val()) - 1;
		if(currpage < 1)  currpage = 1;
		obj.curr_page.val(currpage);
		loadRelationListData(obj);
	});
	//下一页
	obj.next_cus.unbind("click").bind("click", function(event){
		obj.curr_page.val( parseInt(obj.curr_page.val()) + 1);
		loadRelationListData(obj);
	});
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}