/**
 * [ 公共JS模块 ]
 * @auth liulin@takshine.com                                                                                       alert("初始化codeManager数据失败 " +                e);                                }                                                } [description]
 * @return {[type]}          [description]
 */
//ajax调用封装
var asyncInvoke = function(p){
	$.ajax({
      type: p.type || 'get',
      url: p.url || '',
      async: p.async || true,
      data: p.data || {},
      dataType: p.dataType || 'text',
      success: function(data){
		if(data && p.callBackFunc) p.callBackFunc(data);     
      }
   });
};

/*
 * DATE时间格式化 创建时间：2011/11/22 10:12 创建者：zhangming
 *
 * 示例： var dateUTC = strToDate("2011-11-22 10:12");
 * dateFormat(dateUTC,"yyyy-MM-dd hh:mm"); 返回：2011-11-22 10:12
 */
var dateFormat = function(date, format) {
  var o = {
    "M+": date.getMonth() + 1,
    "d+": date.getDate(),
    "h+": date.getHours(),
    "m+": date.getMinutes(),
    "s+": date.getSeconds(),
    "q+": Math.floor((date.getMonth() + 3) / 3),
    "S": date.getMilliseconds()
  };
  if(/(y+)/.test(format)) {
    format = format.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
  }
  for(var k in o) {
    if(new RegExp("(" + k + ")").test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
    }
  }
  return format;
};


var date2utc = function(date) {
  if(!date) {
    return '';
  }
  var d = new Date(date.replace(/-/g, "/"));
  if(!d) {
    return '';
  }
  return d.getTime();
};

var utc2date = function(n_utc) {
  if(!n_utc || n_utc === "null" || n_utc === "无" || +n_utc === 0) return "";
  var date = new Date();
  date.setTime((parseInt(n_utc, 10) + (8 * 3600 * 1000)));
  var s = date.getUTCFullYear() + "-";
  if((date.getUTCMonth() + 1) < 10) {
    s += "0" + (date.getUTCMonth() + 1) + "-";
  } else {
    s += (date.getUTCMonth() + 1) + "-";
  }
  if(date.getUTCDate() < 10) {
    s += "0" + date.getUTCDate();
  } else {
    s += date.getUTCDate();
  }
  if(date.getUTCHours() < 10) {
    s += " 0" + date.getUTCHours() + ":";
  } else {
    s += " " + date.getUTCHours() + ":";
  }
  if(date.getMinutes() < 10) {
    s += "0" + date.getUTCMinutes() + ":";
  } else {
    s += date.getUTCMinutes() + ":";
  }
  if(date.getUTCSeconds() < 10) {
    s += "0" + date.getUTCSeconds();
  } else {
    s += date.getUTCSeconds();
  }

  return s;
};

/**
 * [daysBetween 获得两个日期字符串之间的天数差]
 * @param  {[String]} startDate [传入的开始日期]
 * @param  {[String]} endDate [传入的结束日期]
 * @param  {[boolean]} requiredAbs [是否需要取绝对值,false 用于判断时间先后]
 * @param  {[float]} ratio [时间差系数,默认是8640000,表示一天]
 * @author liulin 2013/01/29
 * @return {[Integer]}     [差值]
 */
var daysBetween = function(startDate, endDate, requiredAbs, ratio) {
  //系数,默认为天数
  var quotient = 86400000;
  if(!!ratio && parseFloat(ratio) > 0){
    quotient = ratio;
  }
  var cha = (Date.parse(startDate.replace("-", "/")) - Date.parse(endDate.replace("-", "/")));
  if(requiredAbs){
    return Math.abs(cha) / quotient;
  }else{
    return cha / quotient;
  }
};

var throttle = function(a, b, c){
    var d, e, f, g = null,
    h = 0;
    c || (c = {});
    var i = function() {
        h = c.leading === !1 ? 0 : new Date,
        g = null,
        f = a.apply(d, e)
    };
    return function() {
        var j = new Date;
        h || c.leading !== !1 || (h = j);
        var k = b - (j - h);
        return d = this,
        e = arguments,
        0 >= k ? (clearTimeout(g), g = null, h = j, f = a.apply(d, e)) : g || c.trailing === !1 || (g = setTimeout(i, k)),
        f
    }
};

//滚动
var scrollToButtom = function(obj){
	if(obj){
		var y = $(obj).offset().top;
	    if(!y) y = 0;
		window.scrollTo(100, y);
	}else{
		window.scrollTo(100, 99999);
	}
	return false;
};

//千分位
function formatNumber(num,cent,isThousand) {  
    num = num.toString().replace(/\$|\,/g,'');  

    // 检查传入数值为数值类型  
      if(isNaN(num))  
        num = "0";  

    // 获取符号(正/负数)  
    sign = (num == (num = Math.abs(num)));  

    num = Math.floor(num*Math.pow(10,cent)+0.50000000001);  // 把指定的小数位先转换成整数.多余的小数位四舍五入  
    cents = num%Math.pow(10,cent);              // 求出小数位数值  
    num = Math.floor(num/Math.pow(10,cent)).toString();   // 求出整数位数值  
    cents = cents.toString();               // 把小数位转换成字符串,以便求小数位长度  

    // 补足小数位到指定的位数  
    while(cents.length<cent)  
      cents = "0" + cents;  

    if(isThousand) {  
      // 对整数部分进行千分位格式化.  
      for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)  
        num = num.substring(0,num.length-(4*i+3))+','+ num.substring(num.length-(4*i+3));  
    }  

    if (cent > 0)  
      return (((sign)?'':'-') + num + '.' + cents);  
    else  
      return (((sign)?'':'-') + num);  
}  


$(function() {
    "use strict";
    $(document).on("click", "[data-toggle]", function(a) {
        a.preventDefault();
    }),
    $(document).on("click", '[data-toggle="navbar"]', function() {
        $("#" + $(this).data("target")).toggleClass("open"),
        $(".navbar").toggleClass("active"),
        $(this).parent().find(".toggleTitle").toggle($(".navbar").hasClass("active"));
    }),
    $(".navbar-menu").on("click", "li", function(a) {
        a.stopPropagation();
    }),
    $(document).on("click", ".navbar-menu", function() {
        $('[data-toggle="navbar"]').click();
    }),
    $(document).on("focus", ".input-group input", function() {
        $(this).parents(".input-group").addClass("active");
    }),
    $(document).on("blur", ".input-group input", function() {
        $(this).parents(".input-group").removeClass("active");
    }),
    $(document).on("click", '[data-toggle="open"]', function() {
        $(this).toggleClass("active"),
        $("#" + $(this).data("target")).toggleClass("open");
    }),
    $(window).on("scroll", throttle(function() {
        $(this).scrollTop() >= $(window).height() / 2 ? $(".gotop").show() : $(".gotop").hide();
    }, 10)),
    $(".gotop").on("click", function() {
        $(window).scrollTop(0);
    }),
    $(document).on("click", ".accordion .accordion-hd", function(a) {
        a.preventDefault(),
        $(this).parent().toggleClass("open");//,
    }),
    $(".select").each(function() {
        var a = $(this).find(".select-box"),
        b = $(this).find("option").filter(":selected");
        b.size() > 0 && a.text(b.text());
    }),
    $(document).on("change", ".select select", function() {
        var a = $(this).parents(".select"),
        b = a.find(".select-box"),
        c = $(this).find("option").filter(":selected");
        c.size() > 0 && b.text(c.text()),
        a.triggerHandler("change", $(this).val());
    }),
    $("input[type=radio]").each(function() {
        var a = $(this).parents(".radio");
        a.attr("radio", $(this).attr("name")),
        $(this).prop("checked") && a.addClass("checked");
    }),
    $(document).on("click", ".radio", function(a) {
        if (a.preventDefault(), !$(this).hasClass("checked")) {
            var b = $(this).attr("radio");
            $("[radio=" + b + "]").removeClass("checked"),
            $('input[type=radio][name="' + b + '"]').prop("checked", !1),
            $(this).addClass("checked"),
            $(this).find("input[type=radio]").prop("checked", !0).trigger("change");
        }
    }),
    $("input[type=checkbox]").filter(":checked").each(function() {
        $(this).parents(".checkbox").addClass("checked");
    }),
    $(document).on("click", ".checkbox", function(a){
        a.preventDefault(),
        $(this).toggleClass("checked");
        var b = $(this).hasClass("checked");
        $(this).find("input[type=checkbox]").prop("checked", b).trigger("change");
    }),
    $(document).on("click", '[data-toggle="tab"]',function(a) {
	        a.preventDefault(),
	        $(this).parent().addClass("active").siblings().removeClass("active");
	        var b = $($(this).attr("href"));
	        b.size() > 0 && b.addClass("active").siblings().removeClass("active");
	}),
    $('form[data-validate="auto"]').each(function() {
        $(this).validator({
            isErrorOnParent: !0,
            errorCallback: function(a) {
                a.length > 0 && $(window).scrollTop(a[0].$el.offset().top - 50);
            },
            after: function() {
                $(this).find("[type=submit]").prop("disabled", !0);
            }
        });
    }),
    $(document).on("keydown", "input",function(a) {
	        return 13 != a.which;
	}); 
});


function TAKMap() {     
    /** 存放键的数组(遍历用到) */    
    this.keys = new Array();     
    /** 存放数据 */    
    this.data = new Object();     
         
    /**   
     * 放入一个键值对   
     * @param {String} key   
     * @param {Object} value   
     */    
    this.put = function(key, value) {     
        if(this.data[key] == null){     
            this.keys.push(key);     
        }     
        this.data[key] = value;     
    };     
         
    /**   
     * 获取某键对应的值   
     * @param {String} key   
     * @return {Object} value   
     */    
    this.get = function(key) {     
        return this.data[key];     
    };     
         
    /**   
     * 删除一个键值对   
     * @param {String} key   
     */    
    this.remove = function(key) {     
        this.keys.remove(key);     
        this.data[key] = null;     
    };     
         
    /**   
     * 遍历Map,执行处理函数   
     *    
     * @param {Function} 回调函数 function(key,value,index){..}   
     */    
    this.each = function(fn){     

        if(typeof fn != 'function'){     
            return;     
        }     
        var len = this.keys.length;     
        for(var i=0;i<len;i++){     
            var k = this.keys[i];     
            fn(k,this.data[k],i);     
        }     
    };     
         
    /**   
     * 获取键值数组(类似Java的entrySet())   
     * @return 键值对象{key,value}的数组   
     */    
    this.entrys = function() {     
        var len = this.keys.length;     
        var entrys = new Array(len);     
        for (var i = 0; i < len; i++) {     
            entrys[i] = {     
                key : this.keys[i],     
                value : this.data[i]     
            };     
        }     
        return entrys;     
    };     
         
    /**   
     * 判断Map是否为空   
     */    
    this.isEmpty = function() {     
        return this.keys.length == 0;     
    };     
         
    /**   
     * 获取键值对数量   
     */    
    this.size = function(){     
        return this.keys.length;     
    };     
         
    /**   
     * 重写toString    
     */    
    this.toString = function(){     
        var s = "{";     
        for(var i=0;i<this.keys.length;i++,s+=','){     
            var k = this.keys[i];     
            s += k+"="+this.data[k];     
        }     
        s+="}";     
        return s;     
    };     
} 


//判断浏览器客户端为移动端还是PC端
/*
function getClientBrower(){
	var source = "";
	var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
    	source = "mobile";
    }else{//否则就是电脑域名打开
    	source = "windows";
    }
    return source;
} 
*/