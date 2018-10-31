<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/30
 * Time: 16:40
 * 接口商品控制器
 * 肖亚子
 */
namespace app\api\controller;
use app\api\model\ProductModel;
use think\Config;
use Think\Exception;
use think\Url;
use think\Request;
use think\Db;

class ProductController extends ApiBaseController{


    public function ProductList(){
        try {
            $Condition = array();
            $CityCode  = intval($this->headerData["citycode"]);//城市code
            $Psize     = intval(input("post.paging",1));//分页默认第一页
            $Title     = input("post.title","","htmlspecialchars,strip_tags");//搜索条件
            $Sales     = intval(input("post.sales"));//销售量 0取消 1降序 2升序
            $Price     = intval(input("post.price"));//价格   0取消 1降序 2升序
            $Distance  = intval(input("post.distance"));//距离 0取消距离 1离我最近
            $Lat       = input("post.lat");//用户纬度
            $Lng       = input("post.lng");//用户经度

            parent::Tpl_Empty($CityCode,"请在手机设置里开启位置",2);

            $Condition["m.merchant_ccode"]       = array("eq", $CityCode);
            $Condition["p.product_reviewstatus"] = array("eq", 2);
            $Condition["p.product_del"]          = array("eq", 0);

            if($Distance){
                $Order = "distance asc";
                parent::Tpl_Empty($Lat,"请在手机设置里开启位置",2);
                parent::Tpl_Empty($Lng,"请在手机设置里开启位置",2);
                $Field = ",(round(6367000 * 2 * asin(sqrt(pow(sin(((m.merchant_lat * pi()) / 180 - ({$Lat} * pi()) / 180) / 2), 2) + cos(({$Lat} * pi()) / 180) * cos((m.merchant_lat * pi()) / 180) * pow(sin(((m.merchant_lng * pi()) / 180 - ({$Lng} * pi()) / 180) / 2), 2))))) AS distance";
            }else{
                $Order = "p.product_toplevel desc,p.product_addtime desc";
            }

            if ($Title){
                $Condition["p.product_name"] = array("LIKE", "%$Title%");
            }
            if ($Sales) {
                if ($Sales == 1) {
                    $Order .= ",p.product_sold desc";
                } elseif ($Sales == 2) {
                    $Order .= ",p.product_sold asc";
                }
            }
            if ($Price) {
                if ($Sales == 1) {
                    $Order .= ",p.temp_price desc";
                } elseif ($Sales == 2) {
                    $Order .= ",p.temp_price asc";
                }
            }

            $List = ProductModel::ShopProductList($Condition,$Field, $Order, $Psize);

            foreach ($List as $Key => $Val) {
                if ($Val["product_pic"]) {
                    $List[$Key]["product_pic"] = Config::get('picture') . $Val["product_pic"];
                }
            }

            $this->returnApiData('获取成功', 200, $List);
        }catch (Exception $e) {
            parent::Tpl_Abnormal($e->getMessage());  //数据库异常抛出
        }
    }

    public function ProductDetails(){
        try{
            $Condition = array();
            $CityCode  = intval($this->headerData["citycode"]);//城市code
            $Prid      = intval(input("post.pr_id"));//商品id

            parent::Tpl_Empty($Prid,"获取失败");

            parent::Tpl_Empty($Prid,"获取失败");

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());  //数据库异常抛出
        }

    }


    /*
 * 计算经纬度范围
 * $lat 纬度
 * $lon 经度
 * $raidus 半径(米)
 */
    /**
     * @param $Lat     用户纬度
     * @param $Lon     用户经度
     * @param $Raidus  用户距离范围
     * @return array
     * 根据用户经纬度以及距离范围计算周边经纬度
     * 肖亚子
     */
    private function getAround($Lat, $Lon, $Raidus) {

        //    $Lately = self::getAround(30.625761,104.096938,2000);
//            $Condition['m.merchant_lat'] = ['between',"{$Lately['minLat']},{$Lately['maxLat']}"];
//            $Condition['m.merchant_lng'] = ['between',"{$Lately['minLng']},{$Lately['maxLng']}"];

        $PI = 3.14159265;
        $EARTH_RADIUS = 6378137;
        $RAD = $PI / 180.0;

        $Latitude = $Lat;
        $Longitude = $Lon;
        $Degree = (24901 * 1609) / 360.0;
        $RaidusMile = $Raidus;
        $DpmLat = 1 / $Degree;
        $Data = array();
        $RadiusLat = $DpmLat * $RaidusMile;
        $MinLat = $Latitude - $RadiusLat;
        $MaxLat = $Latitude + $RadiusLat;
        $Data["maxLat"] = $MaxLat;
        $Data["minLat"] = $MinLat;
        $MpdLng = $Degree * cos($Latitude * ($PI / 180));
        $DpmLng = 1 / $MpdLng;
        $RadiusLng = $DpmLng * $RaidusMile;
        $MinLng = $Longitude - $RadiusLng;
        $MaxLng = $Longitude + $RadiusLng;
        $Data["maxLng"] = $MinLng;
        $Data["minLng"] = $MaxLng;
        //print_r($data);
        return $Data;
    }


}