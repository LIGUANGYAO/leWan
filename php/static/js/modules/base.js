/**
 * Created by Administrator on 2017/3/17 0017.
 */
//自定义radio点击样式
$(".cb-enable").click(function(){
    alert(1);
    var parent = $(this).parents('.onoff');
    $('.cb-disable',parent).removeClass('selected');
    $('.cb-other',parent).removeClass('selected');
    $(this).addClass('selected');
    $('.checkbox',parent).attr('checked', true);
});
$(".cb-other").click(function(){
    var parent = $(this).parents('.onoff');
    $('.cb-disable',parent).removeClass('selected');
    $('.cb-enable',parent).removeClass('selected');
    $(this).addClass('selected');
    $('.checkbox',parent).attr('checked', false);
});
$(".cb-disable").click(function(){
    var parent = $(this).parents('.onoff');
    $('.cb-enable',parent).removeClass('selected');
    $('.cb-other',parent).removeClass('selected');
    $(this).addClass('selected');
    $('.checkbox',parent).attr('checked', false);
});

$(function(){
    $('#checkAll').click(function(){
        $('input[name="choose"]').attr('checked',this.checked);
        $('.check_imgages').css('background-position',this.checked == true ? '-15px 0':'5px 0');
        $('.check_imgage').css('background-position',this.checked == true ? '-15px 0':'5px 0');
    });
    var $choose = $('input[name="choose"]');
    $('input[name="choose"]').click(function(){
        $("#checkAll").attr('checked',$choose.length == $('input[name="choose"]:checked').length ? true:false);
        $('.check_imgages').css('background-position',$choose.length == $('input[name="choose"]:checked').length ? '-15px 0':'5px 0');
        $(this).next().css('background-position',$(this)[0].checked == true ? '-15px 0':'5px 0');
    })
})

function batchdel(url,jurisdiction,event_id){
    var r=confirm("确认删除？");
    if(r == true){
        var choose_ajax = new Array();
        var choose_str;
        var choose_length = $('input[name="choose"]').length;
        for(var i=0;i<choose_length;i++){
            var choose_pd = $('input[name="choose"]')[i].checked;
            if(choose_pd == true){
                var choose_choose = $('input[name="choose"]')[i].value;
                choose_ajax.push(choose_choose);
                choose_str = choose_ajax.join(',');
            }
        }-

        $.ajax({
            type: "get",
            url: url,
            data: {id:choose_str,jurisdiction_id:jurisdiction,event_id:event_id},
            dataType: "json",
            success: function(data){
                if (data.result == 1) {
                    window.location.reload();
                }
            }
        });
    }else{
        return false;
    }
}