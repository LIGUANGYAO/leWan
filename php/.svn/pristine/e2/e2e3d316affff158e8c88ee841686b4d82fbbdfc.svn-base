//使用时必须先引入<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>和JQ和serverApi
//本js作用：重定向获取token，获取个人用户信息拿到邀请码(recode),配置到分享朋友圈或者发送给好友 会直接跳转到首页
//本js除开  ==》 商品详情(productDetails.html)，首页(homePage.html)，邀请注册(inviteFriends.html) 不引入 《== 单独配。
//其他页面必须有，全局锁粉(否则出现右上角三个点分享出去会出现账号不存在 或者 锁不了粉 或者页面缓存清除后不重新获取token)
var code = getUrlParam("code");
var token = localStorage.getItem("token");

if(getUrlParam("recode")) {
	localStorage.setItem("leaderRecode", getUrlParam("recode"))
}

if(token) {
	$.ajax({
		url: API_SERVER + 'Wechat/hasToken',
		async: false,
		data: {token: token},
		success: function(data) {
			if(data.code == 200) {
				log(data)
				if(data.data.count == 0) {
					localStorage.setItem("token", "")
					window.location.href = location.href;
				}
			}
		}
	});
}

if(token == 'undefined' || token == null || token == "") {
	if(code == 'undefined' || code == null || code == "") {
		var redirectUrl = location.href;
		window.location.replace('https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + APPID + '&redirect_uri=' + redirectUrl + '&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect')
	} else {
		//获取token
		$.ajax({
			url: API_SERVER + "Wechat/WechatAuthorize",
			async: false,
			data: {
				code: code + "&state",
				recode: localStorage.getItem("leaderRecode") || null,
			},
			success: function(data) {
				log(data)
				if(data.code == 200) {
					localStorage.setItem("token", data.data.token); //token
					token = data.data.token;
				} else {
					mui.toast(data.message)
				}
			}
		})
	}
}

//获取用户个人基本信息
allGetUSerMessage();
function allGetUSerMessage() {
	$.ajax({
		url: API_SERVER + 'User/UserPersonal',
		async: false,
		data: {
			token: token
		},
		success: function(data) {
			if(data.code == 200) {
				log(data)
				var myRecode = data.data.recode;
				localStorage.setItem("token", data.data.token); //token
				localStorage.setItem("level", data.data.level); //用户等级==》1=普通用户；2超级达人；3营销达人；4=运营达人；5=玩主
				sharePYQ(myRecode);
			}
		}
	});
}

//锁粉
if(localStorage.getItem("leaderRecode") && token){
	suofen()
	function suofen(){
		$.ajax({
			url: API_SERVER + 'User/UserLockPowder',
			async: false,
			data:{
				token: token,
				recode: localStorage.getItem("leaderRecode")
			},
			success: function(data) {
				log(data)
			}
		});
	}
}

//分享朋友圈				
function sharePYQ(myRecode) {
	var shareUrl;
	if(myRecode){
		shareUrl = BASE_SERVER + "wechat_html/page/homePage/homePage.html"+"?recode="+myRecode
	}else{
		shareUrl = BASE_SERVER + "wechat_html/page/homePage/homePage.html"
	}
	getWechatSignature(location.href.split('#')[0]);
	wx.ready(function() {
		wx.onMenuShareTimeline({
			title: '乐玩联盟--最懂你的吃喝玩乐小助手',
			link: shareUrl,
			imgUrl: 'http://oss.lewan6.ren/uploads/logo/logo-w.png',
			trigger: function(res) {
				// 不要尝试在trigger中使用ajax异步请求修改本次分享的内容，因为客户端分享操作是一个同步操作，这时候使用ajax的回包会还没有返回
			},
			fail: function(res) {
				mui.toast(res);
			}
		});
		wx.onMenuShareAppMessage({
			title: '乐玩联盟',
			desc: '最懂你的吃喝玩乐小助手,更多精彩尽在乐玩联盟！快来体验吧，你省他也赚！',
			link: shareUrl,
			imgUrl: 'http://oss.lewan6.ren/uploads/logo/logo-w.png',
			trigger: function(res) {
				// 不要尝试在trigger中使用ajax异步请求修改本次分享的内容，因为客户端分享操作是一个同步操作，这时候使用ajax的回包会还没有返回
			},
			fail: function(res) {
				mui.toast(res);
			}
		});
	});
}