// JavaScript Document


var shijian = 10;

var ss = 0;

var hh = 0;

var mm = 0;

function getDays(shijian){

	if(shijian / (3600*24) > 1){

		return parseInt(shijian / (3600*24));

	}else{

		return 0;

	}

}

function getHour(shijian){

	var hour = shijian / 3600;
	var sh = hour % 24;
	if(sh > 1){

		return hour % 24;

	}else{

		return 0;

	}

}

function getMinu(shijian){

	var mins = shijian % 3600;

	if(mins / 60 > 1){

		return parseInt(mins / 60);

	}else{

		return 0;

	}

}

function getSec(shijian){

	var mins = shijian % 3600;

	var sec = mins % 60;

	return sec;

}

function format(m){

	if(m < 10){

		return '0'+m;

	}else{

		return m;

	}

}

$(function(){
	setInterval(function(){
		$('.djs').each(function(k,v){
			
			shijian = parseInt($(v).attr('sjc'));
			if(shijian <= 0){
				return true;	
			}
			dd = parseInt(getDays(shijian));
			
			hh = parseInt(getHour(shijian));

			mm = parseInt(getMinu(shijian));

			ss = parseInt(getSec(shijian));
			
			ss--;

			if(ss < 0){

				ss=59;

				mm--;

			}

			if(mm < 0){

				mm=59;

				hh--;

			}

			if(hh < 0){

				hh=23;
				dd--;
			}
			
			if(dd < 0){

				dd=0;

			}
			$(v).find('._d_').html(format(dd)+'天');
			
			$(v).find('._h_').html(format(hh)+'时');

			$(v).find('._m_').html(format(mm)+'分');

			$(v).find('._s_').html(format(ss)+'秒');
			
			$(v).attr('sjc', shijian-1);
		});

	}, 1000)

})

