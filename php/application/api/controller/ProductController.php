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
use think\Config;
use Think\Exception;
use think\Url;
use think\Request;
use think\Db;
use app\api\model\ProductModel;
use app\api\model\UserModel;
use app\api\model\CommissionModel;
use app\api\model\OrderModel;

class ProductController extends ApiBaseController{

    /**
     * 获取商品列表
     * 肖亚子
     */
    public function ProductList(){
        try {
            $Condition = array();
            $ProCode   = intval($this->headerData["provincecode"]);//省code
            $CityCode  = intval($this->headerData["citycode"]);//城市code
            $Token     = input("post.token","","htmlspecialchars,strip_tags");
            $Bursting  = intval(input("post.bursting"));//爆款商品
            $Type      = intval(input("post.type"));//1未定位 2已定位
            $Psize     = intval(input("post.paging",1));//分页默认第一页
            $Paged     = intval(input("post.paged",10));//分页条数默认10条
            $Title     = input("post.title","","htmlspecialchars,strip_tags");//搜索条件
            $Cateids   = intval(input("post.cateid"));//商品分类
            $Sales     = intval(input("post.sales"));//销售量 0取消 1降序 2升序
            $Price     = intval(input("post.price"));//价格   0取消 1降序 2升序
            $Distance  = intval(input("post.distance"));//距离 0取消距离 1离我最近
            $Lat       = input("post.lat");//用户纬度
            $Lng       = input("post.lng");//用户经度

            if ($Token){
                $Punfu = new PubfunController();
                $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            }
            if (!array($Type,array(1,2))){
                $this->returnApiData('获取失败', 400);
            }

            if($Type == 2 || ($Type == 1 && $Cateids && $Cateids != 4) || $Bursting == 1){
                parent::Tpl_Empty($ProCode,"请选择城市",2);
                parent::Tpl_Empty($CityCode,"请选择城市",2);
                parent::Tpl_Empty($Lat,"请在手机设置里开启位置",2);
                parent::Tpl_Empty($Lng,"请在手机设置里开启位置",2);
            }

            if ($Token){
                $User  = UserModel::UserFinds($Token);
                $Look  = $User["lookover"];
            }

            if ($Look == 1){
                $Condition["p.product_reviewstatus"] = array("neq", 1);
            }else{
                $Condition["p.product_reviewstatus"] = array("eq", 2);
                $Condition["p.product_status"]       = array("eq", 1);
            }

            if ($Type == 2 || $Bursting == 1){
                $Condition[] = array("exp", "((m.merchant_pcode = {$ProCode} and m.merchant_ccode = {$CityCode}) or  m.merchant_pcode = {$ProCode})");
            }else{
                if (!$Cateids){
                    $Condition[] = array("exp","find_in_set(4,p.product_cateids)");
                    $Condition["p.product_cateids"] = array("eq",4);
                }
            }

            if ($Cateids){
                if ($Cateids == 1){
                    $Condition["p.product_returnall"] = array("eq",1);
                }else{
                    $Condition[] = array("exp","find_in_set({$Cateids},p.product_cateids) and p.product_returnall = 0");
                }
            }else{
                $Condition["p.product_returnall"]= array("eq",0);
            }

            if ($Title){
                $Condition["p.product_name"] = array("LIKE", "%$Title%");
            }
            if ($Bursting == 1){
                $Condition["p.product_explosion"] = array("eq", 1);
            }
            $Field = "";

            if ($Type == 2 || $Bursting == 1){
                $Field = ",ceil(convert((round(6367000 * 2 * asin(sqrt(pow(sin(((m.merchant_lat * pi()) / 180 - ({$Lat} * pi()) / 180) / 2), 2) + cos(({$Lat} * pi()) / 180) * cos((m.merchant_lat * pi()) / 180) * pow(sin(((m.merchant_lng * pi()) / 180 - ({$Lng} * pi()) / 180) / 2), 2)))))/1000,decimal(12,2))) AS distance";

            }

            if (!$Sales && !$Price && !$Distance){
                $Order = "p.sold_out asc,p.product_toplevel desc,p.product_uptime desc";
            }else{
                if ($Distance){
                    $Order = "distance asc,p.sold_out asc";
                }else{
                    $Order = "p.sold_out asc";
                }
            }

            if ($Sales) {
                if ($Sales == 1) {
                    $Order .= ",p.product_sold+p.product_sales_volume desc";
                } elseif ($Sales == 2) {
                    $Order .= ",p.product_sold+p.product_sales_volume asc";
                }
            }
            if ($Price) {
                if ($Price == 1) {
                    $Order .= ",p.temp_price desc";
                } elseif ($Price == 2) {
                    $Order .= ",p.temp_price asc";
                }
            }

          //  $Time        = strtotime("-7 day", time());
          //  $Condition[] = array("exp"," (p.sold_out = 0 or (p.sold_out = 1 and p.sold_out_time > {$Time}))");
            $Condition["r.status"]      = array("eq", 1);
            $Condition["p.product_del"] = array("eq", 0);

            $List      = ProductModel::ShopProductList($Condition,$Field, $Order, $Psize,$Paged);
            $Parameter = UserModel::UserParameterList();

            foreach ($List as $Key => $Val) {

                if ($Val["product_pic"]) {
                    $List[$Key]["product_pic"] = $Val["product_pic"];
                }

                $Product_Sold = 0;

                if ($Token){
                    $List[$Key]["temp_commission"] = CommissionModel::getRewardByUser($Val["temp_commission"],$User["level"],$Parameter);
                }else{
                    $List[$Key]["temp_commission"] = array();
                }

                $PriceCondition["product_id"]   = $Val["product_id"];
                $PriceCondition["price_status"] = 1;

//                $Price = ProductModel::ShopProdictPriceFind($PriceCondition);

                $PriceList = ProductModel::ShopProductPrice($PriceCondition);//获取商品规格

                if ($PriceList){
                    foreach ($PriceList as $K => $V){
                        $Product_Sold += $Val["product_sold"];
                        $List[$Key]["product_totalnum"] += $V["product_totalnum"];
                    }
                }else{
                    $List[$Key]["product_totalnum"] = 0;
                }

                $List[$Key]["product_sold"] = $Product_Sold + $Val["product_sales_volume"];


//                if ($Price){
//                    $List[$Key]["product_totalnum"] = $Price["product_totalnum"] + $Product_Sold;
//                }else{
//                    $List[$Key]["product_totalnum"] = 0;
//                }

                $List[$Key]["now_time"] =  time();

                unset($List[$Key]["product_sales_volume"]);
            }

            $this->returnApiData('获取成功', 200, $List);
        }catch (Exception $e) {
            parent::Tpl_Abnormal($e->getMessage());  //数据库异常抛出
        }
    }

    /**
     * 获取商品详情
     * 肖亚子
     */
    public function ProductDetails(){
        try{
            $Data      = array();
            $HotPush   = array();
            $Condition = array();
            $Token     = input("post.token","","htmlspecialchars,strip_tags");
            $ProCode   = intval($this->headerData["provincecode"]);//省code
            $CityCode  = intval($this->headerData["citycode"]);//城市code
            $Type      = intval(input("post.type"));//1未定位 2已定位
            $Prid      = intval(input("post.pr_id"));//商品id
            $Lat       = input("post.lat");//用户纬度
            $Lng       = input("post.lng");//用户经度

            if ($Token){
                $Punfu = new PubfunController();
                $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            }

            if (!in_array($Type,array(1,2))){
                $this->returnApiData("获取失败", 400);
            }

            if ($Type == 2){
                parent::Tpl_Empty($ProCode,"请选择城市",2);
                parent::Tpl_Empty($CityCode,"请选择城市",2);
                parent::Tpl_Empty($Lat,"请开启定位",2);
                parent::Tpl_Empty($Lng,"请开启定位",2);
            }

            parent::Tpl_Empty($Prid,"获取失败",2);

            if ($Type == 2){
                $Condition[]  = array("exp", "((m.merchant_pcode = {$ProCode} and m.merchant_ccode = {$CityCode}) or m.merchant_pcode = {$ProCode})");
            }else{
                $Condition[] = array("exp","find_in_set(4,p.product_cateids)");
            }

            $Condition["p.product_id"]           = array("eq", $Prid);
            $Condition["p.product_reviewstatus"] = array("eq", 2);
            $Condition["p.product_del"]          = array("eq", 0);
            $Condition["r.status"]               = array("eq", 1);

            $DataFind = ProductModel::ShopProductData($Condition);

           // $this->returnApiData('获取成功', 200, $DataFind);
            if ($DataFind){
                $Cateids = $DataFind["product_cateids"];

                if ($Type == 1 && $Cateids != 4){//未定位查看的商品不是礼品商品
                    $this->returnApiData('请开启定位', 400);
                }

                unset($DataFind["product_cateids"]);

                if ($DataFind["product_numlimit"] == 1){
                    $Uid = UserModel::UserFindUid($Token);

                    $OrCondition["o.user_id"]    = array("eq",$Uid);
                    $OrCondition[]               = array("exp","o.order_status >= 2 and o.order_status < 5");
                    $OrCondition["p.product_id"] = array("eq",$Prid);

                    $NumlimitCount = OrderModel::OrderNumlimitCount($OrCondition);

                    $DataFind["numlimitcount"] = $NumlimitCount;
                }else{
                    $DataFind["numlimitcount"] = 0;
                }

                if ($DataFind["product_returnall"] == 1){

                        $Freesheet = UserModel::UserFreesheet($Uid,$Prid);

                        if ($Freesheet){
                            $DataFind["freesheet"] = 2;
                        }else{
                            $DataFind["freesheet"] = 1;
                        }
                }

                if ($DataFind["product_tags"]){
                    $DataFind["product_tags"] = ProductModel::ShopTags(array("tag_id"=>array("in",$DataFind["product_tags"])));
                }

                if ($DataFind["product_carousel"]){
                    $Carousel = explode(",",$DataFind["product_carousel"]);

                    foreach ($Carousel as $Key => $Val){
                        $Carousel[$Key] = $Val;
                    }
                    $DataFind["product_carousel"] = $Carousel;
                }else{
                    $DataFind["product_carousel"] = array();
                }

                $DataFind["now_time"]       = time();
                $Data["details"]            = $DataFind;

                $Data["details"]  = $DataFind;
                $Data["details"]  = $DataFind;
                $User      = UserModel::UserFinds($Token);
                $Parameter = UserModel::UserParameterList();

                if ($DataFind["product_isexpress"] == 1 && $DataFind["product_reservation"] == 2){//判断商品是不是到店免预约
                    //到店选日历一期暂不做
                    $PriceCondition["product_id"]   = array("eq",$DataFind["product_id"]);
                    $PriceCondition["price_status"] = array("eq",1);

                    $PriceList = ProductModel::ShopProductPrice($PriceCondition);//获取商品规格

                    if ($PriceList){
                        foreach ($PriceList as $Key => $Val){
//                            $PriceList[$Key]["product_totalnum"] = $Val["product_totalnum"] + $DataFind["product_sold"];
                            $PriceList[$Key]["product_buynum"]   = $Val["product_buynum"] + $DataFind["product_sold"];
                        }
                    }
                    if ($Token){
                        $Data["price"] = self::ProduCommission($PriceList,$User["level"],$Parameter);
                    }else{
                        $Data["price"] = [];
                    }
                }else{
                    //到店预约商品,快递商品,获取规格价格
                    $PriceCondition["product_id"]   = array("eq",$DataFind["product_id"]);
                    $PriceCondition["price_status"] = array("eq",1);

                    $PriceList = ProductModel::ShopProductPrice($PriceCondition);//获取商品规格

                    if ($PriceList){
                        foreach ($PriceList as $Key => $Val){
//                            $PriceList[$Key]["product_totalnum"] = $Val["product_totalnum"] + $DataFind["product_sold"];
                            $PriceList[$Key]["product_buynum"]   = $Val["product_buynum"] + $DataFind["product_sold"];
                        }
                    }

                    if ($Token){
                        $Data["price"] = self::ProduCommission($PriceList,$User["level"],$Parameter);
                    }else{
                        $Data["price"] = [];
                    }
                }

                //获取热推商品
                if ($Type == 2){//已定位位置查询
                    $Order = "p.sold_out asc,p.product_sales_volume+p.product_sold desc";
                    $Field = "p.product_id,p.product_pic,p.product_name,p.temp_price,p.temp_commission,p.sold_out,m.merchant_name,r.name as region";

                    $Field .= ",ceil(convert((round(6367000 * 2 * asin(sqrt(pow(sin(((m.merchant_lat * pi()) / 180 - ({$Lat} * pi()) / 180) / 2), 2) + cos(({$Lat} * pi()) / 180) * cos((m.merchant_lat * pi()) / 180) * pow(sin(((m.merchant_lng * pi()) / 180 - ({$Lng} * pi()) / 180) / 2), 2)))))/1000,decimal(12,2))) AS distance";

                    $PushCondition[] = array("exp", "((m.merchant_pcode = {$ProCode} and m.merchant_ccode = {$CityCode}) or m.merchant_pcode = {$ProCode})");
                }else{//未定位礼包商品查询
                    $PushCondition[] = array("exp","find_in_set(4,p.product_cateids)");
                    $Order = "p.sold_out asc,p.product_toplevel desc,p.product_sales_volume+p.product_sold desc,p.product_uptime desc";
                    $Field = "p.product_id,p.product_pic,p.product_name,p.temp_price,p.temp_commission,p.sold_out,m.merchant_name,r.name as region";
                }

                if ($Token){
                    $Look  = $User["lookover"];
                }

                if ($Look == 1){
                    $PushCondition["p.product_reviewstatus"] = array("neq", 1);
                }else{
                    $PushCondition["p.product_reviewstatus"] = array("eq", 2);
                    $PushCondition["p.product_status"]       = array("eq", 1);
                }

                $PushCondition["p.product_id"]  = array("neq", $Prid);
                $PushCondition["p.product_del"] = array("eq", 0);

                $HotPushList = ProductModel::ShopProductList($PushCondition,$Field, $Order, 1,8,true);//获取推荐商品

                foreach ($HotPushList as $Key => $Val){
//                    $HotPush[$Key]["product_id"]  = $Val["product_id"];
                    if ($Val["product_pic"]){
                        $HotPushList[$Key]["product_pic"] = $Val["product_pic"];
                    }else{
                        $HotPushList[$Key]["product_pic"] = "";
                    }

//                    $HotPush[$Key]["product_name"]= $Val["product_name"];

                    if ($Token){
                        $HotPushList[$Key]["temp_commission"] = CommissionModel::getRewardByUser($Val["temp_commission"],$User["level"],$Parameter);
                    }else{
                        $HotPushList[$Key]["temp_commission"] = [];
                    }
                }

                $Data["hotpush"] = $HotPushList;//商品详情追加热推商品
            }else{
                $this->returnApiData('商品已下架', 400);
            }
            $this->returnApiData('获取成功', 200, $Data);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());  //数据库异常抛出
        }

    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 用户海报分享商品
     * 肖亚子
     */
    public function ProductShare(){
        try{
            $Token  = input("post.token","","htmlspecialchars,strip_tags");
            $Prid   = intval(input("post.pr_id"));//商品id
            $Url    = input("post.url","","htmlspecialchars,strip_tags");//商品id

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($Prid,"获取失败",2);
            parent::Tpl_Empty($Url,"获取失败",2);

            $User      = UserModel::UserFinds($Token);
            $Poster    = ProductModel::ShopProductPoster($Prid);

            if ($Poster){
                $Data["url"]    = $Url."?productId={$Prid}&recode={$User['recode']}";
                $Data["poster"] = $Poster;
                $Data["productId"] = $Prid;
                if ($User["recode"]){
                    $Data["Picturename"] = $User["recode"];
                }else{
                    $Data["Picturename"] = $Token;
                }
                $Invitation = generateQrCode($Data,3);//生成分享海报
                $this->returnApiData('获取成功', 200,$Invitation);
            }else{
                $this->returnApiData('获取失败', 400);
            }

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());  //数据库异常抛出
        }
    }

    /**
     * @param $List      数据列表
     * @param $Level     用户等级
     * @param $Parameter 佣金配置
     * @return mixed
     * 根据用户等级转换商品佣金
     * 肖亚子
     */
    private function ProduCommission($List,$Level,$Parameter){

        foreach ($List as $Key=>$Val){
            $List[$Key]["price_commission"] = CommissionModel::getRewardByUser($Val["price_commission"],$Level,$Parameter);
        }

        return $List;
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