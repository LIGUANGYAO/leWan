/** layui-v1.0.9_rls MIT License By http://www.layui.com */
 ;!function(e){"use strict";var t=function(){this.v="1.0.9_rls"};t.fn=t.prototype;var n=document,o=t.fn.cache={},i=function(){var e=n.scripts,t=e[e.length-1].src;return t.substring(0,t.lastIndexOf("/")+1)}(),r=function(t){e.console&&console.error&&console.error("Layui hint: "+t)},l="undefined"!=typeof opera&&"[object Opera]"===opera.toString(),a={layer:"modules/layer",laydate:"modules/laydate",laypage:"modules/laypage",laytpl:"modules/laytpl",layim:"modules/layim",layedit:"modules/layedit",form:"modules/form",upload:"modules/upload",tree:"modules/tree",table:"modules/table",element:"modules/element",util:"modules/util",flow:"modules/flow",carousel:"modules/carousel",code:"modules/code",jquery:"modules/jquery",mobile:"modules/mobile","layui.all":"dest/layui.all"};o.modules={},o.status={},o.timeout=10,o.event={},t.fn.define=function(e,t){var n=this,i="function"==typeof e,r=function(){return"function"==typeof t&&t(function(e,t){layui[e]=t,o.status[e]=!0}),this};return i&&(t=e,e=[]),layui["layui.all"]||!layui["layui.all"]&&layui["layui.mobile"]?r.call(n):(n.use(e,r),n)},t.fn.use=function(e,t,u){function s(e,t){var n="PLaySTATION 3"===navigator.platform?/^complete$/:/^(complete|loaded)$/;("load"===e.type||n.test((e.currentTarget||e.srcElement).readyState))&&(o.modules[m]=t,y.removeChild(p),function i(){return++v>1e3*o.timeout/4?r(m+" is not a valid module"):void(o.status[m]?c():setTimeout(i,4))}())}function c(){u.push(layui[m]),e.length>1?f.use(e.slice(1),t,u):"function"==typeof t&&t.apply(layui,u)}var f=this,d=o.dir=o.dir?o.dir:i,y=n.getElementsByTagName("head")[0];e="string"==typeof e?[e]:e,window.jQuery&&jQuery.fn.on&&(f.each(e,function(t,n){"jquery"===n&&e.splice(t,1)}),layui.jquery=jQuery);var m=e[0],v=0;if(u=u||[],o.host=o.host||(d.match(/\/\/([\s\S]+?)\//)||["//"+location.host+"/"])[0],0===e.length||layui["layui.all"]&&a[m]||!layui["layui.all"]&&layui["layui.mobile"]&&a[m])return c(),f;var p=n.createElement("script"),h=(a[m]?d+"lay/":o.base||"")+(f.modules[m]||m)+".js";return p.async=!0,p.charset="utf-8",p.src=h+function(){var e=o.version===!0?o.v||(new Date).getTime():o.version||"";return e?"?v="+e:""}(),o.modules[m]?!function g(){return++v>1e3*o.timeout/4?r(m+" is not a valid module"):void("string"==typeof o.modules[m]&&o.status[m]?c():setTimeout(g,4))}():(y.appendChild(p),!p.attachEvent||p.attachEvent.toString&&p.attachEvent.toString().indexOf("[native code")<0||l?p.addEventListener("load",function(e){s(e,h)},!1):p.attachEvent("onreadystatechange",function(e){s(e,h)})),o.modules[m]=h,f},t.fn.getStyle=function(t,n){var o=t.currentStyle?t.currentStyle:e.getComputedStyle(t,null);return o[o.getPropertyValue?"getPropertyValue":"getAttribute"](n)},t.fn.link=function(e,t,i){var l=this,a=n.createElement("link"),u=n.getElementsByTagName("head")[0];"string"==typeof t&&(i=t);var s=(i||e).replace(/\.|\//g,""),c=a.id="layuicss-"+s,f=0;a.rel="stylesheet",a.href=e+(o.debug?"?v="+(new Date).getTime():""),a.media="all",n.getElementById(c)||u.appendChild(a),"function"==typeof t&&!function d(){return++f>1e3*o.timeout/100?r(e+" timeout"):void(1989===parseInt(l.getStyle(n.getElementById(c),"width"))?function(){t()}():setTimeout(d,100))}()},t.fn.addcss=function(e,t,n){layui.link(o.dir+"css/"+e,t,n)},t.fn.img=function(e,t,n){var o=new Image;return o.src=e,o.complete?t(o):(o.onload=function(){o.onload=null,t(o)},void(o.onerror=function(e){o.onerror=null,n(e)}))},t.fn.config=function(e){e=e||{};for(var t in e)o[t]=e[t];return this},t.fn.modules=function(){var e={};for(var t in a)e[t]=a[t];return e}(),t.fn.extend=function(e){var t=this;e=e||{};for(var n in e)t[n]||t.modules[n]?r("模块名 "+n+" 已被占用"):t.modules[n]=e[n];return t},t.fn.router=function(e){for(var t,n=(e||location.hash).replace(/^#/,"").split("/")||[],o={dir:[]},i=0;i<n.length;i++)t=n[i].split("="),/^\w+=/.test(n[i])?function(){"dir"!==t[0]&&(o[t[0]]=t[1])}():o.dir.push(n[i]),t=null;return o},t.fn.data=function(t,n){if(t=t||"layui",e.JSON&&e.JSON.parse){if(null===n)return delete localStorage[t];n="object"==typeof n?n:{key:n};try{var o=JSON.parse(localStorage[t])}catch(i){var o={}}return n.value&&(o[n.key]=n.value),n.remove&&delete o[n.key],localStorage[t]=JSON.stringify(o),n.key?o[n.key]:o}},t.fn.device=function(t){var n=navigator.userAgent.toLowerCase(),o=function(e){var t=new RegExp(e+"/([^\\s\\_\\-]+)");return e=(n.match(t)||[])[1],e||!1},i={os:function(){return/windows/.test(n)?"windows":/linux/.test(n)?"linux":/iphone|ipod|ipad|ios/.test(n)?"ios":void 0}(),ie:function(){return!!(e.ActiveXObject||"ActiveXObject"in e)&&((n.match(/msie\s(\d+)/)||[])[1]||"11")}(),weixin:o("micromessenger")};return t&&!i[t]&&(i[t]=o(t)),i.android=/android/.test(n),i.ios="ios"===i.os,i},t.fn.hint=function(){return{error:r}},t.fn.each=function(e,t){var n,o=this;if("function"!=typeof t)return o;if(e=e||[],e.constructor===Object){for(n in e)if(t.call(e[n],n,e[n]))break}else for(n=0;n<e.length&&!t.call(e[n],n,e[n]);n++);return o},t.fn.stope=function(t){t=t||e.event,t.stopPropagation?t.stopPropagation():t.cancelBubble=!0},t.fn.onevent=function(e,t,n){return"string"!=typeof e||"function"!=typeof n?this:(o.event[e+"."+t]=[n],this)},t.fn.event=function(e,t,n){var i=this,r=null,l=t.match(/\(.*\)$/)||[],a=(t=e+"."+t).replace(l,""),u=function(e,t){var o=t&&t.call(i,n);o===!1&&null===r&&(r=!1)};return layui.each(o.event[a],u),l[0]&&layui.each(o.event[t],u),r},e.layui=new t}(window);
 


var layer;
var form;
var element;
var laydate;
var chooseNum = 0; //CheckBox选择数量
/**
 * 全局注册对象，避免到处layui.use()
 */
layui.use(['layer', 'form', 'upload', 'element', 'laydate'], function(){
   layer = layui.layer;
   laydate = layui.laydate;
   form = layui.form();
   
   //1、列表页面全选/反选控制
   form.on('checkbox(allChoose)', function(data){
     var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]');
     chooseNum = 0;
     child.each(function(index, item){
       item.checked = data.elem.checked;
       if(data.elem.checked){
    	   chooseNum++;
       }else{
    	   chooseNum--;
       }
     });
     form.render('checkbox');
     if(chooseNum < 0){
    	 chooseNum = 0;
     }
     if(chooseNum > 0){
		  $('a.batchdel').removeClass('layui-btn-disabled');
	  }else{
		  $('a.batchdel').addClass('layui-btn-disabled');
	  }	
   });
   
   //2、checkbox监听-列表页面
   form.on('checkbox(idchoose)', function(data){
	  if(data.elem.checked){
		  chooseNum++;
	  }else{
		  chooseNum--;
	  }
	  if(chooseNum > 0){
		  $('a.batchdel').removeClass('layui-btn-disabled');
	  }else{
		  $('a.batchdel').addClass('layui-btn-disabled');
	  }
   });
   
   //3、监听指定开关-列表页面
   form.on('switch(switchAjax)', function(data){

       data_type = $(this).attr('data-type');
       idkey    = $(this).attr('idkey');
	   itemid    = $(this).attr('itemid');
	   url       = $(this).attr('url');
	   table     = $(this).attr('tbname');
	  _field     = $(this).attr('filed');

      if(itemid > 0){

		if(data_type == 1){
			values = (this.checked)?1:2;
		}else {
			values = (this.checked)?1:0;
		}

		post({type:data_type, idkey:idkey, value:values, id:itemid, tbname:table, code:_field}, url, function(obj){

			if(obj.status == 1){
				  layer.msg(obj.info, {icon: 1});
			}else{
                layer.msg(obj.info, {icon: 2});
                var flag=$(obj.data).prop("checked");
				$(obj.data).prop("checked",!flag);
				form.render("checkbox");
			}
		});
      }
   });

  
   
   
   //4、监听编辑页面自定义验证规则
   form.verify({
	   //必填的规则，lay-verify="require"
	   require: function(value){
	      if(value.length < 1){
	        return '必填';
	      }
	   },
	   min6: function(value, obj){
		  if(value.length < 6){
			  return '至少6个字符';
		  }
	   },
	   min0_6: function(value, obj){
		   if(value.length > 0 && value.length < 6){
			   return '至少6个字符';
		   }
	   },
	   mobile:[/^1(3|4|5|7|8){1}[0-9]{1}[0-9]{8}$/, '格式不正确'],
	   string:[/^[a-zA-Z0-9]+$/, '格式不正确'],
	   money:[/^[0-9]{1,}(.[0-9]{1,})?$/, '格式不正确'],
	   number:[/^[0-9]+$/, '格式不正确'],
	   idcard:[/^[1-9]{1}[0-9]{5}[1-2]{1}[0-9]{7}[0-9]{3}([0-9]{1}|X|x)$/, '格式不正确'],
	   email:[/^([a-zA-Z0-9_-]){1,}@([a-zA-Z0-9_-]){1,}\.([a-zA-Z0-9_-]){1,}$/, '格式不正确'],
   });
   
   
   //5、节点授权页面全选/反选控制
   form.on('checkbox(modulchoose)', function(data){
     var child = $(data.elem).parent().siblings('.items').find('input[name="nodes[]"]');
     child.each(function(index, item){
         item.checked = data.elem.checked;
     });
     form.render('checkbox');
   });
   form.on('checkbox(modul2choose)', function(data){
	   var child = $(data.elem).siblings('input[name="nodes[]"]');
	   var nocheck = 0;
	   child.each(function(index, item){
		   //item.checked = data.elem.checked;
		   if(item.checked){
			   nocheck++;
		   }
	   });
	   if(data.elem.checked){
		   nocheck++;
	   }
	   modulc = $(data.elem).parent().siblings('.modul').find('input[name="modul[]"]');
	   modulc.each(function(index, item){
		   item.checked = (nocheck==0)?false:true;
	   });
	   
	   form.render('checkbox');
   });
   
    //6、单个文件（图片上传）
    layui.upload({
	   url: '/system/ajax/uploadSingleImage',
	   success: function(res, input){
    	  textfield = $(input).attr('textname');
	      $('.'+textfield).html('<img src="'+res.data.url+'">');
	      $("input[name='"+textfield+"']").val(res.data.filename);
	   }
    });  
    
    //7、监听省市区下拉框
    form.on('select(provence_id)', function(data){
    	loadcity(data.value);
    	//获取文本内容
    	$("select[name='provence_id']").attr('text', data.othis.find('.layui-this').text());
    });
    form.on('select(city_id)', function(data){
    	loadarea(data.value);
    	$("select[name='city_id']").attr('text', data.othis.find('.layui-this').text());
    });
    form.on('select(area_id)', function(data){
    	$("select[name='area_id']").attr('text', data.othis.find('.layui-this').text());
    });
    
});

/**
 * 添加按钮打开窗口
 */
function openWindow(title, url, w='650px', h='450px'){
	layer.open({
		title: [title, 'font-size:13px;'],
		type:2,   //0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
		content:url,
		area: [w, h],
		end:function(){
			
		}
	})
}


/**
 * 按下esc
 */
$(document).keyup(function(e){
	switch(e.keyCode) {
	  case 27:
		 layer.closeAll();
		 break;
	  case 96:
		  layer.closeAll();
		 break;
	}
});

/**
 * 加载二级菜单
 */
function loadcity(provenceCode){
	$.ajax({
	   type: "POST",
	   url: '/index.php/system/ajax/loadcity',
	   data: {'pcode':provenceCode},
	   dataType:'json',
	   success: function(res){
		  vars = res.data;
		  html = '<option value="">城市</option>';
		  for(var i = 0; i<vars.length; i++){
			  html += '<option value="'+vars[i]['code']+'">'+vars[i]['city']+'</option>';
		  }
		  $("select[name='city_id']").html(html);
		  form.render('select');
	   }
	});
}
/**
 * 加载三级菜单
 */
function loadarea(cityCode){
	$.ajax({
		type: "POST",
		url: '/index.php/system/ajax/loadarea',
		data: {'ccode':cityCode},
		dataType:'json',
		success: function(res){
			vars = res.data;
			html = '<option value="">区县</option>';
			for(var i = 0; i<vars.length; i++){
				html += '<option value="'+vars[i]['code']+'">'+vars[i]['area']+'</option>';
			}
			$("select[name='area_id']").html(html);
			form.render('select');
		}
	});
}


$(function () {
    /*图片删除*/
    $('.img_preview').mouseover(function () {
        if($(this).find('img').attr('src').length > 20){
            if($(this).find('a.del').length == 0){
                $(this).append('<a href="javascript:;" class="del" title="删除图片"><img src="/static/images/close2.png"></a>');
            }
        }
    });

    $('.del').live('click', function () {
        $(this).parent().siblings("input[type='hidden']").val('');
        $(this).siblings("img").remove();
        $(this).remove();
    })
})