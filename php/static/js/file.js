// JavaScript Document

var choosefilehandle;  //上传文件按钮
$(function(){
	//选择文件
	//$('.choosefile').click(function(){
	$(".choosefile").live("click", function(){
		$(this).siblings('.tempajaxform').find('.ajaxfile').click();
		choosefilehandle = $(this).parent().parent().siblings('.uploadfile');
	});
	//点击上传文件
	//$('.uploadfile').click(function(){
	$(".uploadfile").live("click", function(){
		//验证状态
		if($(this).attr('status') == '0'){
			window.myalert('请选择文件');
			return;
		}
		$(this).siblings('.uploadjindu').html('正在上传...');
		$(this).siblings('.tbsitem').find('.tempajaxform').submit();
		choosefilehandle = $(this);
	});
	$('.tempajaxform').ajaxForm({
		complete: function(xhr) {
			var res = eval('(' + xhr.responseText + ')');			
			if (res.status == 1) {
				$(choosefilehandle).siblings('.uploadjindu').html('上传成功');

				$(choosefilehandle).attr('status', '0');
				
				filemsg = $(choosefilehandle).siblings('.tbsitem').find("input[name='filemsg']"); //存上传文件数据对象
				vv = $(filemsg).attr('tempid')+","+res.data.name.replace(/&/g, '')+","+res.data.savename;
				$(filemsg).val(vv);
				
			} else {
				window.myalert(res.info);
				$(choosefilehandle).siblings('.uploadjindu').html('请重新选择文件');
			}

		},
		error:function(str){
			alert(JSON.stringify(str));
			$(choosefilehandle).siblings('.uploadjindu').html('请重新选择文件');
		}

	});
});

function getFileURL(v){
	$(v).parent().siblings("input[name='filename']").val($(v).val());
	//更改为可上传状态
	$(choosefilehandle).attr('status', '1');
}

