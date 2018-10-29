// JavaScript Document
$(function(){
	$('#xgshdzclose').click(function(){
		$('.xiugaidizhi').fadeOut();								 
	})		   
	
	$('.d_jian').click(function(){
		var numberbox = $(this).siblings('.d_num');
		var odata = $(this).siblings('.odata');
		var odata_price = $(this).siblings('.odata_price');
		resizeDingdan(numberbox, odata, odata_price, -1);
	})
	$('.d_jia').click(function(){
		var numberbox = $(this).siblings('.d_num');
		var odata = $(this).siblings('.odata');
		var odata_price = $(this).siblings('.odata_price');
		resizeDingdan(numberbox, odata, odata_price, 1);
	})
	setTimeout(function(){
		if($('#orderid').val() > 0)
			return;
		$('.d_all_heji b').html($('#d_all_pnum').val());
		$('.d_all_money').html('￥'+$('#d_all_money').val()+'.00');
		$('.d_num').each(function(k,v){
			var pid = $(v).attr('pid');
			var productsize_id = $(v).attr('productsize_id');
			var price = $(v).attr('price');
			var money = $(v).val()*price;
			$('#d_zongjia_df_'+pid+'_'+productsize_id).html('￥'+money+'.00');
			if(money > 0)
				$('#d_zongjia_df_'+pid+'_'+productsize_id).addClass('cur');
			else
				$('#d_zongjia_df_'+pid+'_'+productsize_id).removeClass('cur');
			//toshi
			var storetype = $(v).attr('storetype');
			var storenum = $(v).attr('storenum');
			if(storetype==1){
				if($(v).val() > parseInt(storenum) && $(v).val() > 0){
					var toshitxt = $('#toshi_'+pid+'_'+productsize_id).html();
					$('#toshi_'+pid+'_'+productsize_id).html(toshitxt.replace('n',storenum));	
					$('#toshi_'+pid+'_'+productsize_id).fadeIn(function(){
						hideToshi($(this));												
					});
				}
			}
		})
	},300)
})

function resizeDingdan(numberbox, odata, odata_price, flag){
	//获取目前的数字
	var psum = $(numberbox).val();
	var tempsum = parseInt(psum)+parseInt(flag);
	if(tempsum <= 0){
		tempsum=0;	
	}
	var pid = $(numberbox).attr('pid');
	var productsize_id = $(numberbox).attr('productsize_id');
	var price_id = $(numberbox).attr('price_id');
	var infoid = $(numberbox).attr('infoid');
	//判断商品类型直邮还是库存
	if($(numberbox).attr('storetype') == 1){
		//库存
		var storenum = $(numberbox).attr('storenum');
		if(storenum < tempsum){
			tempsum=storenum;
			var toshitxt = $('#toshi_'+pid+'_'+productsize_id).html();
			$('#toshi_'+pid+'_'+productsize_id).html(toshitxt.replace('n',storenum));
			$('#toshi_'+pid+'_'+productsize_id).fadeIn(function(){
				hideToshi($(this));												
			});
		}
	}
	//单品总金额
	var money = tempsum*$(numberbox).attr('price');
	$('#d_zongjia_df_'+pid+'_'+productsize_id).html('￥'+money+'.00');
	$(odata_price).val(money);
	if(money > 0)
		$('#d_zongjia_df_'+pid+'_'+productsize_id).addClass('cur');
	else
		$('#d_zongjia_df_'+pid+'_'+productsize_id).removeClass('cur');
	$(numberbox).val(tempsum);
	//odata数据； 格式=
	var odataline = pid+'+'+productsize_id+'+'+price_id+'+'+tempsum+'+'+infoid;
	$(odata).val(odataline);
	//订单商品总是
	var all_p_num = 0;
	$('.d_num').each(function(k,v){
		all_p_num += parseInt($(v).val());
	})
	$('.d_all_heji b').html(all_p_num);
	$('#d_all_pnum').val(all_p_num);
	//总金额
	var all_p_money = 0;
	$('.odata_price').each(function(k,v){
		all_p_money += parseInt($(v).val());
	})
	$('.d_all_money').html('￥'+all_p_money+'.00');
	$('#d_all_money').val(all_p_money);
}

function hideToshi(v){
	setTimeout(function(){
		$(v).fadeOut();				
	},3000)	
}

function keyPress(v) {    
    var keyCode = event.keyCode;    
    if ((keyCode >= 48 && keyCode <= 57))    
	{    
		 event.returnValue = true;    
	 } else {    
		 event.returnValue = false;    
	}   
	
}  
function keyup(t){
	if(t.value == '')
		t.value=0;
	var odata = $(t).siblings('.odata');
	var odata_price = $(t).siblings('.odata_price');
	resizeDingdan(t , odata, odata_price, 0);
}

function xiugaidz(){
	$('.xiugaidizhi').fadeIn();						
}

function saveshdz(){
	var rc_id = $("input[name='or_id']").val();
	var p_id = $("input[name='p_id']").val();
	var c_id = $("input[name='c_id']").val();
	var address = $("input[name='address']").val();
	var shouhuoren = $("input[name='shouhuoren']").val();
	var lianxifangshi = $("input[name='lianxifangshi']").val();
	re = /^1\d{10}$/
	if (!re.test(lianxifangshi)) {
		alert('联系方式格式不正确');   
		return false;
	}
	$.ajax({
	   type: "POST",
	   url: "/Order/editrecipt",
	   data: "rc_id="+rc_id+"&p_id="+p_id+"&c_id="+c_id+"&address="+address+"&shouhuoren="+shouhuoren+"&lianxifangshi="+lianxifangshi,
	   dataType:'json',
	   success: function(msg){
		   if(msg!=0){
			    $('.shdz__ .zhdz1').html(msg.pname);
				$('.shdz__ .zhdz2').html(msg.cname);
				$('.shdz__ .zhdz3').html(msg.address);
				$('.shdz__ .zhdz4').html("（"+msg.shouhuoren+" 收）");
				$('.shdz__ .zhdz5').html(msg.lianxifangshi);
			    $('.xiugaidizhi').fadeOut(); 
				$('#xgdz').val(1);
		   }else{
				alert('请填写完整的收货地址信息');   
		   }
	   }
	});
}
function commitorder(){
	if($('#d_all_pnum').val() < 1){
		alert('请设置订货数量');	
		return false;	
	}
	
}