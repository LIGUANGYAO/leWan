/*全局方法
 * 
 */

var log = console.log.bind(console); //简写打印台


//获取url方法    window.location.href    使用方式 var openId = getUrlParam("openId");		
function getUrlParam(name) {
	var pattern = new RegExp("[?&]" + name + "\=([^&]+)", "g");
	var matcher = pattern.exec(window.location);
	var items = null;
	if(matcher != null) {
		try {
			items = decodeURIComponent(decodeURIComponent(matcher[1]));
		} catch(e) {
			try {
				items = decodeURIComponent(matcher[1]);
			} catch(e) {
				items = matcher[1];
			}
		}
	}
	return items;
}


//首页底部页面跳转
//首页
mui('body').on('tap', '#homePage', function() {
	mui.openWindow({
		url: '../homePage/homePage.html',
		id: 'homePage.html'
	})
})
//每日爆款
mui('body').on('tap', '#everydayFaddish', function() {
	mui.openWindow({
		url: '../everydayFaddish/everydayFaddish.html',
		id: 'everydayFaddish.html'
	})
})
//预约中心
mui('body').on('tap', '#reservationCenter', function() {
	mui.openWindow({
		url: '../reservationCenter/reservationCenter.html',
		id: 'reservationCenter.html'
	})
})
//个人中心
mui('body').on('tap', '#personalCenter', function() {
	mui.openWindow({
		url: '../personalCenter/personalCenter.html',
		id: 'personalCenter.html'
	})
})
				