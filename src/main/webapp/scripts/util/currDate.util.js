/** 
* 获取本周、本季度、本月、上月的开端日期、停止日期 
*/ 
var now = new Date(); //当前日期 
var nowDayOfWeek = now.getDay(); //今天本周的第几天 
var nowDay = now.getDate(); //当前日 
var nowMonth = now.getMonth(); //当前月 
var nowYear = now.getYear(); //当前年 
nowYear += (nowYear < 2000) ? 1900 : 0; //

var lastMonthDate = new Date(); //上月日期 
lastMonthDate.setDate(1); 
lastMonthDate.setMonth(lastMonthDate.getMonth()-1); 
var lastYear = lastMonthDate.getYear(); 
var lastMonth = lastMonthDate.getMonth();

//格局化日期：yyyy-MM-dd 
function formatDate(date) { 
var myyear = date.getFullYear(); 
var mymonth = date.getMonth()+1; 
var myweekday = date.getDate();

if(mymonth < 10){ 
mymonth = "0" + mymonth; 
} 
if(myweekday < 10){ 
myweekday = "0" + myweekday; 
} 
return (myyear+"-"+mymonth + "-" + myweekday); 
}
//获得某月的天数 
function getMonthDays(myMonth){ 
var monthStartDate = new Date(nowYear, myMonth, 1); 
var monthEndDate = new Date(nowYear, myMonth + 1, 1); 
var days = (monthEndDate - monthStartDate)/(1000 * 60 * 60 * 24); 
return days; 
}

//获得本季度的开端月份 
function getQuarterStartMonth(){ 
var quarterStartMonth = 0; 
if(nowMonth<3){ 
quarterStartMonth = 0; 
} 
if(2<nowMonth && nowMonth<6){ 
quarterStartMonth = 3; 
} 
if(5<nowMonth && nowMonth<9){ 
quarterStartMonth = 6; 
} 
if(nowMonth>8){ 
quarterStartMonth = 9; 
} 
return quarterStartMonth; 
}

//获得本周的开端日期 
function getWeekStartDate() { 
var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek); 
return formatDate(weekStartDate); 
}

//获得本周的停止日期 
function getWeekEndDate() { 
var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek)); 
return formatDate(weekEndDate); 
}

//获得本月的开端日期 
function getMonthStartDate(){ 
var monthStartDate = new Date(nowYear, nowMonth, 1); 
return formatDate(monthStartDate); 
}

//获得本月的停止日期 
function getMonthEndDate(){ 
var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth)); 
return formatDate(monthEndDate); 
}

//获得上月开端时候 
function getLastMonthStartDate(){ 
var lastMonthStartDate = new Date(nowYear, lastMonth, 1); 
return formatDate(lastMonthStartDate); 
}

//获得上月停止时候 
function getLastMonthEndDate(){ 
var lastMonthEndDate = new Date(nowYear, lastMonth, getMonthDays(lastMonth)); 
return formatDate(lastMonthEndDate); 
}

//获得本季度的开端日期 
function getQuarterStartDate(){

var quarterStartDate = new Date(nowYear, getQuarterStartMonth(), 1); 
return formatDate(quarterStartDate); 
}

//或的本季度的停止日期 
function getQuarterEndDate(){ 
var quarterEndMonth = getQuarterStartMonth() + 2; 
var quarterStartDate = new Date(nowYear, quarterEndMonth, getMonthDays(quarterEndMonth)); 
return formatDate(quarterStartDate); 
} 
function formatDateStr(date){
	var a = new Date(date);
	var em=a.getMonth() + 1 ,ed = a.getDate();
	if(em < 10){
		em = '0' + em;
	}
	if(ed < 10){
		ed = '0' + ed;
	}
	return a.getFullYear()+"-"+em+"-"+ed;
}


//+--------------------------------------------------- 
//| 日期计算 
//+--------------------------------------------------- 
Date.prototype.DateAdd = function(strInterval, Number) {
	var dtTmp = this;
	switch (strInterval) {
	case 's':
		return new Date(Date.parse(dtTmp) + (1000 * Number));
	case 'n':
		return new Date(Date.parse(dtTmp) + (60000 * Number));
	case 'h':
		return new Date(Date.parse(dtTmp) + (3600000 * Number));
	case 'd':
		return new Date(Date.parse(dtTmp) + (86400000 * Number));
	case 'w':
		return new Date(Date.parse(dtTmp) + ((86400000 * 7) * Number));
	case 'q':
		return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number
				* 3, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(),
				dtTmp.getSeconds());
	case 'm':
		return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number,
				dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(),
				dtTmp.getSeconds());
	case 'y':
		return new Date((dtTmp.getFullYear() + Number), dtTmp.getMonth(),
				dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(),
				dtTmp.getSeconds());
	}
}

//+--------------------------------------------------- 
//| 字符串转成日期类型 
//| 格式 MM/dd/YYYY MM-dd-YYYY YYYY/MM/dd YYYY-MM-dd 
//+--------------------------------------------------- 
function StringToDate(strDate) 
{ 
    var date = eval('new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
    function (a) { return parseInt(a, 10) - 1; }).match(/\d+/g) + ')');
    return date;
} 


function sortByKeys(myObj) {
	var keys = new Array();
	myObj.each(function(key, value, index) {
		keys.push(key);
	});
	var tkeys = keys.sort(function(left, right) {
		var b = StringToDate(left) > StringToDate(right);
		return b ? -1 : 1;
	});
	var sortedObject = new TAKMap();
	for (i in tkeys) {
		key = tkeys[i];
		sortedObject.put(key, myObj.get(key));
	}

	return sortedObject;

}

//计算天数差的函数，通用  
function  DateDiff(sDate1,  sDate2){    //sDate1和sDate2是2002-12-18格式  
     var  aDate,  oDate1,  oDate2,  iDays  
     aDate  =  sDate1.split("-")  
     oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])    //转换为12-18-2002格式  
     aDate  =  sDate2.split("-")  
     oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])  
     iDays  =  parseInt(Math.abs(oDate1  -  oDate2)  /  1000  /  60  /  60  /24)    //把相差的毫秒数转换为天数  
     return  iDays  
}
