// 发送短信工具
var smsdjs = 0;
var smstimer;
var ddsj = 60;
$(function(){
	$('#_yzmbtn_').click(function(){
		//验证是否可以发送
		if(smsdjs > 0){
			return;
		}
		tel = $('#_yzmtel_').val();
		re= /^(13[0-9]{9})|(18[0-9]{9})|(15[0-9]{9})|(17[0-9]{9})$/;
		if(!re.test(tel)){
			alert('手机号格式不正确');
			$('#_yzmtel_').focus();
			return;
		}
		method = $(this).attr('a');
		send_code = $(this).attr('send_code');
		sendsms(method,send_code);
	})
})

function sendsms(method,send_code){
	smsdjs = ddsj;
	tel = $('#_yzmtel_').val();
	$.ajax({
	   type: "POST",
	   url: "/index.php?g=Shop&m=Sms&a="+method,
	   data:"mobile="+tel+"&send_code="+send_code,
	   dataType:'json',
	   success: function(res){
		   if(res.SubmitResult.code != "2"){
				alert(res.SubmitResult.msg);
		   }else{
				smstimer = setInterval("djs()", 1000);   
		   }
	   }
	}); 
}

function djs(){
	smsdjs--;
	$('#_yzmbtn_').html(smsdjs+'秒后可重新发送');
	if(smsdjs <= 0){
		clearInterval(smstimer);
		$('#_yzmbtn_').html('获取验证码');	
		smstimer=ddsj;
	}
}