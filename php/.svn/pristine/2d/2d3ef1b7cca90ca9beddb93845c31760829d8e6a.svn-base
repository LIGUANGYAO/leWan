/*
 * @Author: huazi 
 * @Date: 2018-01-22 13:21:31 
 * @Last Modified by: huazi
 * @Last Modified time: 2018-01-24 17:05:47
 */
window.onload = init; //异步加载地图


function init(){
    //定义地图信息相关
    var nowzoom,bounds,youxiajiao,zuoshangjiao;
    // 创建地图实例  
    var map = new BMap.Map("bdMap");  
    //自动初始化地图
    var myGeo = new BMap.Geocoder();
    var markers = [];
    var markerClusterer;
    myGeo.getPoint(city, function(point){ //city数据从html中得到
          if (point) {
              map.centerAndZoom(point, 14); // 初始化地图，设置中心点坐标和地图级别
              markerClusterer = new BMapLib.MarkerClusterer(map, {markers:markers});
          }else{
              //alert("您选择地址没有解析到结果!");
          }
    },city);

    //添加各种地图控件
    map.enableScrollWheelZoom(true);//启用滚轮放大缩小
    map.enableKeyboard(true);//启用键盘上下左右键移动地图 
    map.addControl(new BMap.NavigationControl({//添加地图缩放控件
        anchor:BMAP_ANCHOR_BOTTOM_RIGHT,
    }));
    map.addControl(new BMap.ScaleControl());//添加比例尺控件
	var pCtrl = new BMap.PanoramaControl(); //构造全景控件
	pCtrl.setOffset(new BMap.Size(20, 50));
	map.addControl(pCtrl);//添加全景控件
    //添加地图类型控件
    map.addControl(new BMap.MapTypeControl({
        mapTypes:[
            BMAP_NORMAL_MAP,
            BMAP_HYBRID_MAP
    ]}));	
    //获取地图的信息
    function getMapInfo(){
        nowzoom = map.getZoom();
        //获取地图窗口区域坐标
        bounds = map.getBounds();
        youxiajiao = bounds.getSouthWest();     //右下角坐标
        zuoshangjiao = bounds.getNorthEast();   //左上角坐标
     }

   
    map.addEventListener('zoomend',function(){
        getMapInfo();
        //大于15层级时，展示单个信息；否则展示总数
        loadData(nowzoom, youxiajiao.lng, youxiajiao.lat, zuoshangjiao.lng, zuoshangjiao.lat);
    });
    map.addEventListener("dragend", function(){
        getMapInfo();
        //大于15层级时，展示单个信息；否则展示总数
        loadData(nowzoom, youxiajiao.lng, youxiajiao.lat, zuoshangjiao.lng, zuoshangjiao.lat);
    });

    $('#level').change(function () {
        loadData(nowzoom, youxiajiao.lng, youxiajiao.lat, zuoshangjiao.lng, zuoshangjiao.lat);
    });
    $('#daytag').change(function () {
        loadData(nowzoom, youxiajiao.lng, youxiajiao.lat, zuoshangjiao.lng, zuoshangjiao.lat);
    });

    //ajax载入信息
    function loadData(zoom, zxlnt, zxlat, yslnt, yslat){
        var level = $("#level").val();
        var daytag = $("#daytag").val();
        var param = "level="+level+"&daytag="+daytag+"&zoom="+zoom+"&zxlnt="+zxlnt+"&zxlat="+zxlat+"&yslnt="+yslnt+"&yslat="+yslat;
        $.ajax({
            type: "POST",
            url: ajaxUrl,
            data: param,
            dataType:'json',
            success: function(msg){
                //清除之前的覆盖
                markers = [];
                map.clearOverlays();
                markerClusterer.clearMarkers();
                len = msg.length;
                if(len == 0){
                    return;
                }
                var pt = null;
                for(var i = 0; i<len; i++) {
                    pt = new BMap.Point(msg[i].lng, msg[i].lat);
                    myIcon = new BMap.Icon(msg[i].avatar, new BMap.Size(30,30));
                    tempmarker = new BMap.Marker(pt,{icon:myIcon});
                    if(zoom > 17){
                        tempmarker.setLabel(new BMap.Label(msg[i].nickname+'['+msg[i].level+']'));
                    }
                    markers.push(tempmarker);
                    addClickHandler(msg[i], tempmarker);
                }
                markerClusterer.addMarkers(markers);
                //渲染完成提示
                layer.msg('渲染完成', {icon: 1});
            }
        });
    }


    function addClickHandler(content,marker){
        marker.addEventListener("click",function(e){
            openInfo(content,e)}
        );
    }

    var opts = {
        width : 250,     // 信息窗口宽度
        height: 80,     // 信息窗口高度
        title : "会员信息" , // 信息窗口标题
        enableMessage:true//设置允许信息窗发送短息
    };
    function openInfo(content,e){
        html = '<div><span>昵称：</span>'+content.nickname+'</div>' +
            '<div><span>等级：</span>'+content.level+'</div>'+
            '<div><span>手机：</span>'+content.mobile+'</div>';
        var p = e.target;
        var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
        var infoWindow = new BMap.InfoWindow(html,opts);  // 创建信息窗口对象
        map.openInfoWindow(infoWindow,point); //开启信息窗口
    }

}


