/*全局方法
 * 
 */

var log = console.log.bind(console); //简写打印台
//域名
var API_SERVER = "http://weixin.lewan6.ren/api/"
var BASE_SERVER = "http://weixin.lewan6.ren/"
window.APPID = 'wx9639c4a683f9ce86'

//时间戳转年月日
//getDateTime(时间戳, 'Y/MM/dd hh:mm:ss')   getDateTime(1536278730, "Y年MM月dd日 hh时mm分ss秒")
function getDateTime(timestamp, format) {
	const date = new Date(timestamp * 1000); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
	const o = {
		'Y+': date.getFullYear(),
		'M+': date.getMonth() + 1, // 月份
		'd+': date.getDate(), // 日
		'h+': date.getHours(), // 小时
		'm+': date.getMinutes(), // 分
		's+': date.getSeconds(), // 秒
		'q+': Math.floor((date.getMonth() + 3) / 3), // 季度
		S: date.getMilliseconds(), // 毫秒
	};

	if(/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}
	for(var k in o) {
		if(new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length))
		}
	}
	return format;
}

// 表单验证规则
/*使用方式  var isOk = validate(
			[businessPhone, ['required', 'telephone'],
				['请输入联系电话', '请输入正确联系电话']
			] //联系人电话
		);
		if(!isOk) return;
*/
var validateRules = {
	required: /^.+$/m, // 必填
	phone: /^([01][3456789]\d{9})?$/, // 电话
	email: /^([\w-_]+@[\w-_]+\.[\w-_]+)?$/i, // 邮箱
	username: /^([01][34578]\d{9})?$/, // 用户名
	password: /^([\w0-9]{6,11})?$/, // 密码
	nickname: /^([\u4e00-\u9fa5_a-zA-Z0-9]{1,7})?$/, // 昵称
	name: /^([\u4e00-\u9fa5]{2,6}|[a-zA-Z]{3,10})?$/, // 真实姓名
	code: /^\d{6}$/, // 验证码
	idCard: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, //身份证
	telephone: /(^0\d{2,3}-\d{7,8}(-\d{1,6})?$)|(^1[34578]\d{9}$)/, //座机或者电话
	tel_qq: /^(\d{5,11})?$/, //意见反馈QQ或者电话
	invitecode: /^(?:|[a-z\d]{7})$/i, //邀请码格式
	bankcode: /^([1-9]{1})(\d{15}|\d{18})$/, //银行卡号
	times: /^\d{13}$/, // 13位时间戳
};

//表单验证方法
function validate() {
	var args = Array.prototype.slice.call(arguments);
	for(var i = 0, j = args.length; i < j; i++) {
		var value = args[i][0],
			rules = args[i][1],
			msg = args[i][2],
			cb = args[i][3];
		for(var m = 0, n = rules.length; m < n; m++) {
			var nowRule = null;

			if('function' === typeof rules[m])
				nowRule = rules[m];
			else if('string' === typeof rules[m]) {
				var ivalRul = validateRules[rules[m]];
				'function' === typeof ivalRul ?
					nowRule = ivalRul :
					nowRule = function() {
						return ivalRul.test(value);
					};
			} else if(rules[m] instanceof RegExp)
				nowRule = function() {
					return rules[m].test(value);
				};
			else
				throw '验证规则格式错误！';

			//  验证失败
			if(!nowRule(value)) {
				typeof cb === 'function' ? cb(false, msg[m]) : mui.toast(msg[m]);
				return false;
			}
		}
		typeof cb === 'function' && cb(true);
	}
	return true;
}

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

//判断访问终端
var browser = {
	versions: function() {
		var u = navigator.userAgent,
			app = navigator.appVersion;
		return {
			trident: u.indexOf('Trident') > -1, //IE内核
			presto: u.indexOf('Presto') > -1, //opera内核
			webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
			gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
			mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
			ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
			android: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, //android终端
			iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
			iPad: u.indexOf('iPad') > -1, //是否iPad
			webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
			weixin: u.indexOf('MicroMessenger') > -1, //是否微信
			qq: u.match(/\sQQ/i) == " qq" //是否QQ
		};
	}(),
	language: (navigator.browserLanguage || navigator.language).toLowerCase()
}
var browserType;
if(browser.versions.android) {
	browserType = "android"
} else if(browser.versions.ios) {
	browserType = "ios"
} else {
	browserType = "android"
}
(function($) {
	//首先备份下jquery的ajax方法
	var _ajax = $.ajax;
	//重写jquery的ajax方法
	$.ajax = function(opt) {
		//扩展增强处理
		var _opt = $.extend({
			type: "POST",
			cache: false,
			dataType: "json", //默认后不显示图片上传中
			headers: {
				"product": "wechat",
				"platform": browserType
			},
			beforeSend: function(XHR) {
				//提交前回调方法
				$('body').append("<div id='ajaxBox'><div><img id='ajaxInfo' src='../../img/loading.gif'/><div id='ajaxText'>加载中..</div></div></div>");
			},
			complete: function(XHR, TS) {
				//请求完成后回调函数 (请求成功或失败之后均调用)。
				$("#ajaxBox").remove();
			},
			error: function(d) {
				console.log(d)
				mui.toast("网络异常");
			}
		},opt);
		return _ajax(_opt);
	};
})(jQuery);

//每个页面获取token
var token = localStorage.getItem("token"); //0009b229c26fb257ab130cec8f313df6
//log(location.href)
//if(token == 'undefined' || token == null || token == "") {
//	localStorage.setItem("currentPageUrl",location.href)
//	var redirectUrl = BASE_SERVER + "wechat_html/index.html"
//	window.location.href='https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9639c4a683f9ce86&redirect_uri=' + redirectUrl + '&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect'
//}

//获取微信签名方法/*必传获取签名页面地址****location.href.split('#')[0]****/
function getWechatSignature(reqUrl){
	log("获取微信签名")
	$.ajax({
		url: API_SERVER + 'Wechat/WechatPosition',
		async: false,
		data: {
			token: token,
			url: reqUrl
		},
		success: function(data) {
			if(data.code == 200) {
				log(data);
				wx.config({
					debug: false, // 开启调试模式,调用的所有api的赚回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
					appId: data.data.appId, // 必填，公众号的唯一标识
					timestamp: data.data.timestamp, // 必填，生成签名的时间戳
					nonceStr: data.data.nonceStr, // 必填，生成签名的随机串
					signature: data.data.signature, // 必填，签名
					jsApiList: ['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone',
					        'hideMenuItems','showMenuItems','hideAllNonBaseMenuItem','showAllNonBaseMenuItem','translateVoice','startRecord',
					        'stopRecord', 'onVoiceRecordEnd','playVoice','onVoicePlayEnd', 'pauseVoice','stopVoice', 'uploadVoice',
					        'downloadVoice', 'chooseImage','previewImage', 'uploadImage','downloadImage', 'getNetworkType','openLocation',
					        'getLocation','hideOptionMenu', 'showOptionMenu','closeWindow','scanQRCode','chooseWXPay','openProductSpecificView',
					        'addCard', 'chooseCard', 'openCard'
					        ]
				});
			}
		}
	});
}

//全局获取用户个人基本信息
//getUserMessage()
function getUserMessage(){
	$.ajax({
		url: API_SERVER + 'User/UserPersonal',
		async: false,
		data:{token: token},
		success: function(data) {
			if(data.code == 200) {
				log(data)
				localStorage.setItem("token", data.data.token); //token
				localStorage.setItem("subscribe", data.data.subscribe); //是否关注公众号==》等于1 用户已关注公众号
				localStorage.setItem("level", data.data.level); //用户等级==》1=普通用户；2超级达人；3营销达人；4=运营达人；5=玩主
			}
		}
	});
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