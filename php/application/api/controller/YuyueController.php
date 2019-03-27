<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/8
 * Time: 14:41
 */

namespace app\api\controller;
use app\api\model\CommissionModel;
use think\Db;
use Think\Exception;
use app\api\model\HelpModel;
use app\common\model\Paymodel;
use app\api\model\UserModel;
use app\api\model\OrderModel;
use app\api\model\UserAddressModel;
use app\api\model\ProductModel;
use app\api\model\OpenTmModel;
/**
 * 预约中心
 * Class YuyueController
 * @package app\api\controller
 */
class YuyueController extends ApiBaseController
{
    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取预约中心未预约列表
     * 肖亚子
     */
    public function ConsumeBespokeAll(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Page  = intval(input("post.page","1"));//分页默认第一页

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Uid   = UserModel::UserFindUid($Token);

            $OrderAll = array();
            $OrderId  = "";

            $Condition[] = array("exp","o.order_status = 2");
            $Condition["o.user_id"]           = $Uid;
            $Condition["o.order_reservation"] = 1;
            $Condition["pr.distributiontag"]  = 0;

            $OrdersId = OrderModel::OrderReservationList($Condition,1,999999);

            foreach ($OrdersId as $Key => $Val){
                if ($Val["express"] == 1){//获取预约到店电子消费码
                    $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                    $CodeCondition["cc.user_id"]  = array("eq",$Uid);
                    $CodeCondition["cc.status"]   = array("eq",1);

                    $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                    if ($CodeList){
                        foreach ($CodeList as $K => $V){
                            if (!$V["reservation_id"] || ($V["reservation_status"] == 0 || $V["reservation_status"] > 2)){
                                if (!$OrderId){
                                    $OrderId .= "{$Val['order_id']}";
                                }else{
                                    $OrderId .= ",{$Val['order_id']}";
                                }
                                unset($CodeList);
                                break;
                            }
                        }
                    }

                    unset($CodeList);
                } else{//获取订单预约快递信息
                    $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                    $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                    $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                    if (!$Express){
                        if (!$OrderId){
                            $OrderId .= "{$Val['order_id']}";
                        }else{
                            $OrderId .= ",{$Val['order_id']}";
                        }
                    }
                }
            }

            if($OrderId){
                $Condition[] = array("exp","o.order_id in({$OrderId})");
                unset($OrdersId);

                //获取预约订单
                $Orders = OrderModel::OrderReservationList($Condition,$Page,10);

                foreach ($Orders as $Key => $Val){

                    if ($Val["product_endusetime"] < time()){
                        $EndTime = 2;//订单商品结束时间过期等于2
                    }else{
                        $EndTime = 1;//订单商品结束时间未过期等于1
                    }

                    if ($Val["express"] == 1){//获取预约到店电子消费码

                        $OrderCode = array();

                        $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                        $CodeCondition["cc.user_id"]  = array("eq",$Uid);
                        $CodeCondition["cc.status"]   = array("eq",1);

                        $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                        if ($CodeList){
                            foreach ($CodeList as $K => $V){
                                if (!$V["reservation_id"] || ($V["reservation_status"] == 0 || $V["reservation_status"] > 2)){
                                    $Codes["consume_code"] = $V["consume_code"];
                                    $Codes["status"]       = $V["status"];
                                    $OrderCode[]           = $Codes;
                                }
                            }
                        }

                        $Count = count($OrderCode);

                        if ($Count){
                            $Data["order_id"]     = $Val["order_id"];
                            $Data["ordernumber"]  = $Val["ordernumber"];
                            $Data["express"]      = $Val["express"];
                            $Data["product_name"] = $Val["product_name"];
                            $Data["startusetime"] = $Val["product_startusetime"];
                            $Data["endusetime"]   = $Val["product_endusetime"];
                            $Data["endtime"]      = $EndTime;
                            $Data["code_count"]   = $Count;
                            $Data["code"]         = $OrderCode;

                            $OrderAll[] = $Data;
                        }

                        unset($CodeList);
                        unset($OrderCode);
                        unset($Data);
                    } else{//获取订单预约快递信息

                        $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                        $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                        $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                        $Data["order_id"]     = $Val["order_id"];
                        $Data["ordernumber"]  = $Val["ordernumber"];
                        $Data["express"]      = $Val["express"];
                        $Data["product_name"] = $Val["product_name"];
                        $Data["startusetime"] = $Val["product_startusetime"];
                        $Data["endusetime"]   = $Val["product_endusetime"];
                        $Data["endtime"]      = 1;
                        $Data["code_count"]   = 0;
                        $Data["code"]         = [];

                        if (!$Express){
                            $OrderAll[] = $Data;
                        }

                        unset($Express);
                        unset($Data);
                    }
                }

                unset($Orders);
            }

            $this->returnApiData("获取成功", 200,$OrderAll);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取已预约列表数据
     * 肖亚子
     */
    public function ConsumeBookedAll(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Page  = intval(input("post.page","1"));//分页默认第一页

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Uid = UserModel::UserFindUid($Token);
            $OrderAll = array();

            $Condition[] = array("exp"," (o.order_isexpress = 1 or o.order_isexpress = 2 and o.order_reservation = 1) and o.order_status >= 2 and o.order_status <= 4");
            $Condition["o.user_id"]           = $Uid;
            $Condition["o.order_reservation"] = 1;
            $Condition["pr.distributiontag"]  = 0;

            $OrdersId = OrderModel::OrderReservationList($Condition,1,999999);
            $OrderId  = "";

            foreach ($OrdersId as $Key => $Val){
                if ($Val["express"] == 1 && $Val["reservation"] == 1){//获取预约到店电子消费码
                    $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                    $CodeCondition["cc.user_id"]  = array("eq",$Uid);

                    $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                    if ($CodeList){
                        foreach ($CodeList as $K => $V){
                            if ($V["reservation_status"] == 1 || $V["reservation_status"] == 2){
                                if (!$OrderId){
                                    $OrderId .= "{$Val['order_id']}";
                                }else{
                                    $OrderId .= ",{$Val['order_id']}";
                                }

                                unset($CodeList);
                                break;
                            }
                        }
                    }

                    unset($CodeList);
                }elseif($Val["express"] == 2 && $Val["reservation"] == 1){//获取订单预约快递信息

                    $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                    $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                    $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                    if ($Express){
                        if (!$OrderId){
                            $OrderId .= "{$Val['order_id']}";
                        }else{
                            $OrderId .= ",{$Val['order_id']}";
                        }
                    }

                    unset($Express);
                }
            }

            if ($OrderId){
                $Condition[] = array("exp","o.order_id in({$OrderId})");
                unset($OrdersId);

                //获取预约订单
                $Orders = OrderModel::OrderReservationList($Condition,$Page,10);

                foreach ($Orders as $Key => $Val){
                    $Data = array();

                    if ($Val["product_endusetime"] < time()){
                        $EndTime = 2;//订单商品结束时间过期等于2
                    }else{
                        $EndTime = 1;//订单商品结束时间未过期等于1
                    }

                    if ($Val["express"] == 1 && $Val["reservation"] == 1){//获取预约到店电子消费码
                        $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                        $CodeCondition["cc.user_id"]  = array("eq",$Uid);

                        $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                        if ($CodeList){
                            foreach ($CodeList as $K => $V){
                                if ($V["reservation_status"] == 1 || $V["reservation_status"] == 2){
                                    $Data["order_id"]     = $Val["order_id"];
                                    $Data["ordernumber"]  = $Val["ordernumber"];
                                    $Data["express"]      = $Val["express"];
                                    $Data["product_name"] = $Val["product_name"];
                                    $Data["startusetime"] = $Val["product_startusetime"];
                                    $Data["endusetime"]   = $Val["product_endusetime"];
                                    $Data["endtime"]      = $EndTime;
                                    $Data["consume_code"] = $V["consume_code"];
                                    $Data["status"]       = $V["status"];

                                    $OrderAll[] = $Data;
                                }
                            }
                        }

                        unset($CodeList);
                    }elseif($Val["express"] == 2 && $Val["reservation"] == 1){//获取订单预约快递信息

                        $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                        $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                        $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                        if ($Express){
                            $Data["order_id"]     = $Val["order_id"];
                            $Data["ordernumber"]  = $Val["ordernumber"];
                            $Data["express"]      = $Val["express"];
                            $Data["product_name"] = $Val["product_name"];
                            $Data["startusetime"] = $Val["product_startusetime"];
                            $Data["endusetime"]   = $Val["product_endusetime"];
                            $Data["endtime"]      = 1;
                            $Data["deliveryid"]   = $Express["yy_id"];

                            $OrderAll[] = $Data;
                        }

                        unset($Express);
                    }
                }

                unset($Orders);
            }

            $this->returnApiData("获取成功", 200,$OrderAll);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 预约制快递商品预约发货时间
     * 肖亚子
     */
    public function ExpressReservation(){
        try{
            $Token      = input("post.token","","htmlspecialchars,strip_tags");
            $OrderId    = intval(input("post.order_id"));
            $MerchantId = intval(input("post.merchant_id"));
            $Address_id = intval(input("post.address_id"));
            $DayTime    = strtotime(date("Y-m-d H:i",input("post.day")));
            $Remark     = input("post.remark","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            parent::Tpl_Empty($OrderId,"请求错误",2);
            parent::Tpl_Empty($MerchantId,"请选择预约商家",2);
            parent::Tpl_Empty($Address_id,"请选择收货地址",2);
            parent::Tpl_Empty($DayTime,"请选择发货日期",2);

            $Day      = strtotime(date("Y-m-d",$DayTime));
            $Tomorrow = strtotime("+1 day",$Day);
            $Time     = strtotime("+18 hours",$Day);

            if ($DayTime > $Time){
                $this->returnApiData("预约时间不能下午六点以后,请重新选择", 400);
            }

            if ($DayTime < time()){
                $this->returnApiData("预约发货日期不能小于当前日期", 400);
            }

            if ($Remark){
                parent::Tpl_StringLength($Remark,"备注不能小于6字大于30字",3,6,30,2);
            }

            $Uid = UserModel::UserFindUid($Token);

            $RessCondition["address_id"] = array("eq",$Address_id);
            $RessCondition["user_id"]    = array("eq",$Uid);
            $RessCondition["status"]     = array("eq",1);

            $AddressFind = UserAddressModel::UserAddressFind($RessCondition);

            if (!$AddressFind){
                $this->returnApiData("请选择收获地址", 400);
            }

            $Condition["rf.order_id"] = array("eq",$OrderId);
            $Condition["rf.user_id"]  = array("eq",$Uid);

            $FahuoFind = OrderModel::OrderReservationFahuoFind($Condition);

            if ($FahuoFind){
                $this->returnApiData("已预约请勿重复预约", 400);
            }
            $Order = OrderModel::OrderProductId(array("o.order_id"=>$OrderId));
            $Kucun = OrderModel::ExpressReservationStock(array("fen_merchant_id"=>$MerchantId));
            $NumCondition[] = array("exp","op.product_id = {$Order["product_id"]} and f.merchant_id = {$MerchantId} and f.day > {$Day} and f.day < $Tomorrow");
            $Num   = OrderModel::BookedNumber($NumCondition);
            $Num   = empty($Num)?0:$Num;

            if ($Kucun > 0){
                if ($Kucun < $Num){
                    $this->returnApiData("该商家当日已预约满,请选择其它日期", 400);
                }

                if (($Kucun - $Num) < $Order["num"]){
                    $this->returnApiData("该商家当日可预约数量不足,请选择其它日期", 400);
                }
            }

            $Cash  = OrderModel::TableName();
            $Cash->startTrans();//开启事务

            $FahuoData["order_id"]    = $OrderId;
            $FahuoData["user_id"]     = $Uid;
            $FahuoData["merchant_id"] = $MerchantId;
            $FahuoData["day"]         = $DayTime;
            $FahuoData["remark"]      = $Remark;
            $FahuoData["addtime"]     = time();

            $Data = OrderModel::OrderReservationFahuoUpdate($FahuoData);

            if (!$Data){
                $Cash->rollback();
                $this->returnApiData("预约发货失败", 400);
            }

            $OrCondition["user_id"] = array("eq",$Uid);
            $OrCondition["order_id"] = array("eq",$OrderId);

            $Order = OrderModel::OrderUpdate($OrCondition,array("address_id"=> $Address_id));

            if (!$Order){
                $Cash->rollback();
                $this->returnApiData("预约发货失败", 400);
            }

            $Cash->commit();//成功提交事务
            $this->returnApiData("预约发货成功", 200);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取订单商品所有商家
     * 肖亚子
     */
    public function AllBusinesses(){
        try{
            $Token   = input("post.token","","htmlspecialchars,strip_tags");
            $OrderId = intval(input("post.order_id"));//订单id

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($OrderId,"请求失败",2);

            $List = OrderModel::OrderMercha(array("o.order_id"=>$OrderId));

            $this->returnApiData("获取成功", 200,$List);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

    /**
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * h5预约
     * 肖亚子
     */
    public function ConsumeBookedConfirm(){
        try{
            $Product = $this->headerData['product'];
            $Code  = input("post.code","","htmlspecialchars,strip_tags");
            $Phone = input("post.phone","","htmlspecialchars,strip_tags");
            $Hash  = input("post.hash","","htmlspecialchars,strip_tags");

            if ($Product != "h5"){
                $this->returnApiData("请求失败", 400);
            }

            parent::Tpl_Empty($Code,"请输入电子码",2);
            parent::Tpl_FullSpace($Code,"请输入电子码");

            $Condition["o.order_status"]  = 2;
            $Condition["cc.consume_code"] = $Code;

            $Order = OrderModel::OrderConfirm($Condition);

            if (!$Order){
                $this->returnApiData("请选择正确的预约消费码链接", 400);
            }else{
                if ($Order["hash"]){
                    parent::Tpl_Empty($Hash,"非法请求",2);
                    parent::Tpl_StringLength($Hash,"非法请求",3,32,32,2);
                    parent::Tpl_Contrast($Hash,$Order["hash"],"非法请求",6,2);
                }else{
                    parent::Tpl_Phone($Phone,"非法请求",2);
                    parent::Tpl_Contrast($Phone,$Order["order_mobile"],"非法请求",6,2);
                }

                if ($Order["order_isexpress"] != 1){
                    $this->returnApiData("请选择正确的预约消费码链接", 400);
                }

                if ($Order["order_reservation"] != 1){
                    $this->returnApiData("该订单是免平台预约,请电话联系商家进行预约", 400);
                }

                switch ($Order["status"]){
                    case 2:$this->returnApiData("消费码已经使用过啦", 400);break;
                    case 3:$this->returnApiData("消费码已经过期啦", 400);break;
                    case 4:$this->returnApiData("消费码已被冻结,请联系商家咨询详情", 400);break;
                    default : break;
                }

                if($Order["reservation_status"]){
                    switch ($Order["reservation_status"]){
                        case 1:$this->returnApiData("消费码已经预约过啦", 400);break;
                        case 2:$this->returnApiData("消费码已经使用过啦", 400);break;
                        case 3:$this->returnApiData("消费码已经过期啦", 400);break;
                        default : break;
                    }
                }
            }

            $Data["token"]    = $Order["token"];
            $Data["order_id"] = $Order["order_id"];

            unset($Order);

            $this->returnApiData("获取成功", 200,$Data);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取可预约商品列表
     * 肖亚子
     */
    public function ConsumeBookedProduct(){
        try{
            $ProCode  = intval($this->headerData["provincecode"]);//省code
            $CityCode = intval($this->headerData["citycode"]);//城市code
            $Token    = input("post.token","","htmlspecialchars,strip_tags");
            $Type     = intval(input("post.type"));//1未定位 2已定位
            $Psize    = intval(input("post.paging",1));//分页默认第一页
            $Title    = input("post.title","","htmlspecialchars,strip_tags");

            if ($Token){
                $Punfu = new PubfunController();
                $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            }
            if (!array($Type,array(1,2))){
                $this->returnApiData('获取失败', 400);
            }
            if($Type == 2){
                parent::Tpl_Empty($ProCode,"请选择城市",2);
                parent::Tpl_Empty($CityCode,"请选择城市",2);
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
            if ($Type == 2 ){
                $Condition[] = array("exp", "((m.merchant_pcode = {$ProCode} and m.merchant_ccode = {$CityCode}) or  m.merchant_pcode = {$ProCode})");
            }else{
                $Condition[] = array("exp","find_in_set(4,p.product_cateids)");
                $Condition["p.product_cateids"] = array("eq",4);
            }
            if ($Title){
                $Condition["p.product_name"] = array("LIKE", "%$Title%");
            }

            $Condition["p.product_endusetime"]  = array("gt", time());
            $Condition["p.product_isexpress"]   = array("eq", 1);
            $Condition["p.product_reservation"] = array("eq", 1);
            $Condition["r.status"]              = array("eq", 1);
            $Condition["p.product_del"]         = array("eq", 0);
            $Condition["p.distributiontag"]     = array("eq", 0);

            $List = ProductModel::ShopBookedProductList($Condition, $Psize,10);

            $this->returnApiData("获取成功", 200,$List);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 可预约商品详情获取
     * 肖亚子
     */
    public function ConsumeBookedProductDet(){
        try{
            $Prid  = input("post.pr_id");
            $Token = input("post.token","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($Prid,"请求错误",2);
            parent::Tpl_FullSpace($Prid,"请求错误",2);

            $Uid = UserModel::UserFindUid($Token);

            $Condition["product_id"] = $Prid;

            $Data = ProductModel::ShopBookedProductData($Condition);

            if (!$Data){
                $this->returnApiData("获取失败", 400);
            }
            if ($Data["product_isexpress"] != 1 || $Data["product_reservation"] != 1){
                $this->returnApiData("获取失败", 400);
            }

            if ($Data["product_tags"]){
                $Tags               = ProductModel::ShopTags(array("tag_id"=>array("in",$Data["product_tags"])));
                $Tags[]["tag_name"] = ProductModel::ProductGenre($Data["product_isexpress"],$Data["product_reservation"]);
                $Data["product_tags"] = $Tags;
            }

            $ShopCondition[] = array("exp","(m.merchant_id = {$Data["merchant_id"]} or m.parent_id = {$Data["merchant_id"]}) and m.merchant_status = 2 and m.merchant_open = 1 and r.status = 1");
            $PriceCondition["product_id"]   = array("eq",$Prid);
            $PriceCondition["price_status"] = array("eq",1);

            $ShopList  = ProductModel::ShopList($ShopCondition);
            $PriceList = ProductModel::ShopProductPrice($PriceCondition,"price_id,product_property");//获取商品规格

            $Data["shop"]  = $ShopList;
            $Data["price"] = $PriceList;

            unset($Data["product_isexpress"]);
            unset($Data["product_reservation"]);
            unset($Data["merchant_id"]);

            $OrderCondition["o.user_id"]           = array("eq",$Uid);
            $OrderCondition["o.order_isexpress"]   = array("eq",1);
            $OrderCondition["o.order_reservation"] = array("eq",1);
            $OrderCondition[] = array("exp","o.order_status > 1 and o.order_status < 4");
            $OrderCondition["p.product_id"]        = array("eq",$Prid);
            $OrderCondition["cc.status"]            = array("eq",1);

            $CodeList = OrderModel::OrderCodeList($OrderCondition);

            if ($CodeList){
                if ($CodeList){
                    foreach ($CodeList as $K => $V){
                        if (!$V["reservation_id"] || ($V["reservation_status"] == 0 || $V["reservation_status"] > 2)){
                            $Data["booked"] = 1;break;
                        }else{
                            $Data["booked"] = 2;
                        }
                    }
                }else{
                    $Data["booked"] = 2;
                }
            }else{
                $Data["booked"] = 2;
            }

            $this->returnApiData("获取成功", 200,$Data);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

    /**
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取可预约商品日历
     * 肖亚子
     */
    public function ConsumeBookedProductCalendar(){
        $Pr_Id    = input("post.pr_id");
        $Mid      = input("post.merchant_id");
        $Price_Id = input("post.price_id");
       // $Date = strtotime(date("Y-m-d",time()));

        //获取日历信息
        $Condition['r.product_id']  = $Pr_Id;
        $Condition['r.price_id']    = $Price_Id;
        $Condition['r.merchant_id'] = $Mid;
        $Condition['r.calendar']    = ['gt', time()-86400];
        $Condition['p.product_id']  = ['exp', 'is not null '];

        $List = ProductModel::ShopProductCalendarList($Condition);

        foreach ($List as $Key => $Val){
            $List[$Key]['day']       = date('m月d日', $Val['calendar']);
            $List[$Key]['status']    = $Val['totalnum']<=$Val['usenum']?0:1;
            $List[$Key]['lastnumber'] = $Val['totalnum'] - $Val['usenum'];
        }

        $this->returnApiData('查询成功', 200, $List);
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取电子码预约详情
     * 肖亚子
     */
    public function ConsumeBookedReservation(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Code  = input("post.code","","htmlspecialchars,strip_tags");;//电子码

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($Code,"获取失败",2);

            $Uid = UserModel::UserFindUid($Token);


            $Condition["cc.user_id"]          = array("eq",$Uid);
            $Condition["cc.consume_code"]     = array("eq",$Code);
            $Condition["o.order_isexpress"]   = array("eq",1);
            $Condition["o.order_reservation"] = array("eq",1);

            $Order = OrderModel::OrderCodeFind($Condition);

            if (!$Order){
                $this->returnApiData("获取失败", 400);
            }

            $ReCondition["r.user_id"]         = array("eq",$Uid);
            $ReCondition["r.order_id"]        = array("eq",$Order["order_id"]);
            $ReCondition["r.consume_code_id"] = array("eq",$Order["consume_code_id"]);

            $ReservationData = OrderModel::OrderReservationFind($ReCondition);

            if (!$ReservationData){
                $this->returnApiData("未预约", 400);
            }else{
                $Day =  floor(($ReservationData["calendar"] - time())/(3600*24));
                $Cance["reservation_id"]  = $ReservationData["reservation_id"];
                $Cance["merchant_id"]     = $ReservationData["merchant_id"];
                $Cance["fen_merchant_id"] = $ReservationData["fen_merchant_id"];

                $CancelFind = OrderModel::BookedCancelFind($Cance);

                if ($CancelFind["status"] == 1){
                    $ReservationData["status"] = 3;
                }else{
                    if ($Day >= 1){
                        if ($ReservationData["status"] == 1 && $ReservationData["reservation_status"] == 1){
                            if ($ReservationData["reservation_transaction_id"] && $ReservationData["reservation_payment"] > 0){
                                $ReservationData["status"] = 1;
                            }else{
                                $ReservationData["status"] = 2;
                            }
                        }else{
                            $ReservationData["status"] = 1;
                        }
                    }else{
                        $ReservationData["status"] = 1;
                    }
                }

            }

            unset($ReservationData["reservation_transaction_id"]);
            unset($ReservationData["reservation_payment"]);
            unset($ReservationData["reservation_status"]);
            unset($ReservationData["merchant_id"]);
            unset($ReservationData["fen_merchant_id"]);

            $this->returnApiData("获取成功", 200,$ReservationData);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 用户取消,消费码预约,加价不能进行取消预约
     * 肖亚子
     */
    public function ConsumeBookedCancel(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $RId   = input("post.r_id","","htmlspecialchars,strip_tags");
            $Url   = input("post.url","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            parent::Tpl_Empty($RId,"获取失败",2);

            $Uid = UserModel::UserFindUid($Token);
            $Condition["r.reservation_id"]     = $RId;
            $Condition["r.user_id"]            = $Uid;
            $Condition["r.reservation_status"] = 1;
            $Condition["c.status"]             = 1;

            $CancelData = OrderModel::ReservationBookedCancelFind($Condition);

            if (!$CancelData){
                $this->returnApiData("该消费码不能进行取消预约", 400);
            }
            $Cance["reservation_id"]  = $RId;
            $Cance["merchant_id"]     = $CancelData["merchant_id"];
            $Cance["fen_merchant_id"] = $CancelData["fen_merchant_id"];
//            $Cance["user_id"]        = $Uid;

            $CancelFind = OrderModel::BookedCancelFind($Cance);

            if ($CancelFind["status"] == 1){
                $this->returnApiData("取消预约正在等待商家确认,请耐心等待哦亲", 400);
            }
//            elseif ($CancelFind["status"] == 2){
//                $this->returnApiData("取消预约商家已经通过,您可以在预约中心重新预约啦", 400);
//            }

            $Data["merchant_id"]     = $CancelData["merchant_id"];
            $Data["fen_merchant_id"] = $CancelData["fen_merchant_id"];
            $Data["reservation_id"]  = $RId;
            $Data["status"]          = 1;
            $Data["remark"]          = "用户取消预约";
            $Data["addtime"]         = time();

            $CancelAdd = OrderModel::BookedCancelAdd($Data);

            if ($CancelAdd === false){
                $this->returnApiData("取消预约失败", 400);
            }

             self::WeChatBusiness($RId,$Uid,$Url);

            $this->returnApiData("申请成功", 200);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取快递预约商品发货信息
     * 肖亚子
     */
    public function ConsumeBookedDelivery(){
        try{
            $Token   = input("post.token","","htmlspecialchars,strip_tags");
            $OrderId = intval(input("post.order_id"));//订单id

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($OrderId,"获取失败",2);

            $Uid = UserModel::UserFindUid($Token);

            $Condition["o.order_id"]          = array("eq",$OrderId);
            $Condition["o.user_id"]           = array("eq",$Uid);
            $Condition["o.order_isexpress"]   = array("eq",2);
            $Condition["o.order_reservation"] = array("eq",1);

            $OrderFind = OrderModel::OrderFind($Condition,"o.order_id");

            if (!$OrderFind){
                $this->returnApiData("订单未找到", 400);
            }

            $RfCondition["rf.order_id"] = array("eq",$OrderId);
            $RfCondition["rf.user_id"] = array("eq",$Uid);

            $Delivery = OrderModel::OrderReservationFahuoFind($RfCondition,"m.merchant_alias as merchant_name,rf.day as calendar,rf.remark");

            if (!$Delivery){
                $this->returnApiData("未预约发货", 400);
            }

            $this->returnApiData("获取成功", 200,$Delivery);

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }


    private function getOrderBycode(){
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where[] = array("exp","o.order_status >=2 and o.order_status <= 4 and o.order_reservation = 1");

        $order = Db::name('order_consume_code c')
            ->field('o.order_id, o.order_no, o.order_paytime, o.order_addtime, o.merchant_id, c.consume_code_id, '.
                ' p.op_id, p.product_name, p.product_property, p.`num`, p.product_startusetime, p.product_endusetime, p.product_id, p.price_id,'.
                ' m.product_info, m.product_useinfo, m.product_notice, m.fen_merchant_ids')
            ->join('jay_order o', 'o.order_id = c.order_id', 'left')
            ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
            ->join('jay_product m', 'm.product_id = p.product_id', 'left')
            ->where($where)
            ->find();
        return ['order'=>$order, 'code'=>$code, 'user'=>$user];
    }


    /**
     * 查询订单
     */
    public function search(){
        $orderData = $this->getOrderBycode();
        $order = $orderData['order'];
        $code = $orderData['code'];
        $user = $orderData['user'];
        if($order){
            $this->verifyCode($order, $code, $user);
            $order['order_paytime'] = date('Y-m-d H:i:s', $order['order_paytime']);
            $order['order_addtime'] = date('Y-m-d H:i:s', $order['order_addtime']);
            $order['product_endusetime'] = date('Y-m-d H:i:s', $order['product_endusetime']);
            $order['product_startusetime'] = date('Y-m-d H:i:s', $order['product_startusetime']);
            $this->returnApiData('查询成功', 200, $order);
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }


    /**
     * 获取门店
     */
    public function getFenDian(){
        $user = getUserByToken();
        $order_id = $this->post('order_id', 0);
        $order = Db::name('order')->find($order_id);
        $mlist = Db::name('merchant')->field('merchant_id,merchant_alias as merchant_name ')->where(['parent_id|merchant_id'=>$order['merchant_id'], 'merchant_open'=>1])->order('parent_id asc')->select();
        $this->returnApiData('查询成功', 200, $mlist);
    }



    /**
     * 万年历表
     */
    public function calandar()
    {
        $orderData = $this->getOrderBycode();
        $order = $orderData['order'];
        $code = $orderData['code'];
        $user = $orderData['user'];
        if($order){
            if($order['product_startusetime'] > time()){
                //$this->returnApiData('暂时没到开放预约时间：'.date('Y-m-d', $order['product_startusetime']), 400);
            }
            if($order['product_endusetime'] < time()){
                $this->returnApiData('预约已经结束', 400);
            }
            $this->verifyCode($order, $code, $user);
            //更新订单预约分店
            $fen_merchant_id = $this->post('fen_merchant_id', 0);
            $fenmch = Db::name('merchant')->where(['merchant_id'=>$fen_merchant_id])->find();
            if($fenmch['parent_id'] != $order['merchant_id'] && $fenmch['merchant_id'] != $order['merchant_id']){
                $this->returnApiData('分店不匹配', 400);
            }
            if($fenmch['merchant_id'] == $order['merchant_id']){
                $fen_merchant_id = $order['merchant_id'];
            }
            //更新电子码选择的门店
            Db::name('order')->where(['order_id'=>$order['order_id']])->update(['fen_merchant_id'=>$fen_merchant_id]);
            Db::name('order_consume_code')->where(['order_id'=>$order['order_id'], 'consume_code_id'=>$order['consume_code_id']])->update(['fen_merchant_id'=>$fen_merchant_id, 'merchant_id'=>$order['merchant_id']]);
            //获取日历信息

            $w2['r.product_id'] = $order['product_id'];
            $w2['r.price_id'] = $order['price_id'];
            $w2['r.merchant_id'] = $fen_merchant_id;
            $w2['r.calendar'] = ['gt', time()-86400];
            $w2['p.product_id'] = ['exp', 'is not null '];
            $calendarlist = Db::name('product_reservationday r')
                            ->field('r.*, sum(`p`.`totalnum`) totalnum, sum(`p`.`usenum`) usenum')
                            ->join('jay_product_reservationprice p', 'p.reservationday_id = r.reservationday_id', 'left')
                            ->where($w2)->group('p.reservationday_id')
                            ->order('r.calendar asc')
                            ->limit(0,30)
                            ->select();
            foreach ($calendarlist as $k=>$v){
                $calendarlist[$k]['day'] = date('m月d日', $v['calendar']);
                $calendarlist[$k]['status'] = $v['totalnum'] <= $v['usenum']?0:1;
                $calendarlist[$k]['lastnumber'] = $v['totalnum']-$v['usenum'];
            }
            $this->returnApiData('查询成功', 200, $calendarlist);
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }

    /**
     * 获取套餐
     */
    public function getCase(){
        $reservationday_id = $this->post('reservationday_id', 0);
        $user = getUserByToken();
        $pricelist = Db::name('product_reservationprice p')
                    ->field('p.id, p.reservationday_id, p.property, p.addprice, p.totalnum,  p.usenum, pt.product_name, pp.product_property')
                    ->join('jay_product pt', 'pt.product_id = p.product_id', 'left')
                    ->join('jay_product_reservationday r', 'r.reservationday_id = p.reservationday_id', 'left')
                    ->join('jay_product_price pp', 'pp.price_id = r.price_id', 'left')
                    ->where(['p.reservationday_id'=>$reservationday_id])
                    ->select();
        foreach ($pricelist as $k=>$v){
            $pricelist[$k]['lastnumber'] = $v['totalnum']-$v['usenum'];
        }
        $this->returnApiData('获取成功', 200, $pricelist);
    }


    public function submit(){
        $reservationprice_id = $this->post('reservationprice_id', 0);
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where['o.order_status'] = 2;
        $order = Db::name('order_consume_code c')
            ->field('c.consume_code_id, c.`status`, o.order_id, o.order_no, o.order_paytime, o.order_addtime,'.
                ' p.product_name, p.price_id, p.product_property, p.product_id, p.product_startusetime, p.product_endusetime'.
                '')
            ->join('jay_order o', 'o.order_id = c.order_id', 'left')
            ->join('jay_order_product p', 'p.op_id = c.op_id', 'left')
            ->where($where)
            ->find();
        if($order){
            if($order['product_startusetime'] > time()){
                //$this->returnApiData('暂时没到开放预约时间：'.date('Y-m-d', $order['product_startusetime']), 400);
            }
            if($order['product_endusetime'] < time()){
                $this->returnApiData('预约已经结束', 400);
            }
            if($order['status'] == 3){
                $this->returnApiData('电子码已过期', 400);
            }
            if($order['status'] == 4){
                $this->returnApiData('电子码已作废', 400);
            }
            $this->verifyCode($order, $code, $user);
            Db::startTrans();
            $reservationprice = Db::name('product_reservationprice')->lock(true)->find($reservationprice_id);
            if($reservationprice){
                //已预约数量
                $usenum = Db::name('order_user_reservation')->where(['reservationprice_id'=>$reservationprice_id, 'reservation_status'=>['in', '1,2']])->count();
                if($usenum >= $reservationprice['totalnum']){
                    $this->returnApiData('当日预约名额已被抢完，请重新选择其他日期预约', 400);
                }
                $reserDay = Db::name('product_reservationday')->find($reservationprice['reservationday_id']);
                //提前预约+自然日判断
                if($reserDay['preday']*24*60*60+strtotime(date('Y-m-d',time())) > $reserDay['calendar'] && $reserDay['pretype'] == 1){
                    $this->returnApiData('请提前'.$reserDay['preday'].'天预约', 400);
                }
                //24小时制判断
                if($reserDay['pretype'] == 2){
                    if(stripos($reservationprice['property'], '-') !== false && stripos($reservationprice['property'], ':') !== false){
                        $beginyytime = explode('-',$reservationprice['property']);
                        $beginyytimeexp = strtotime(date('Y-m-d').' '.$beginyytime[0]);
                        if($reserDay['preday']*60*60+time() > $beginyytimeexp){
                            $this->returnApiData('请提前'.$reserDay['preday'].'小时预约'.$reservationprice['property'], 400);
                        }
                    }
                }
                //是否已经预约过
                $rw['order_id'] = $order['order_id'];
                $rw['user_id'] = $user['user_id'];
                $rw['consume_code_id'] = $order['consume_code_id'];
                $hasReservation = Db::name('order_user_reservation')->where($rw)->find();
                if($hasReservation['reservation_status']==1 || $hasReservation['reservation_status']==2){
                    $this->returnApiData('该电子码'.$code.'已经预约成功了，不可重复预约', 400);
                }
                if($hasReservation['reservation_status']==3){
                    $this->returnApiData('该电子码'.$code.'已过期', 400);
                }
                $hm = new HelpModel();
                $rwdata['order_id'] = $order['order_id'];
                $rwdata['user_id'] = $user['user_id'];
                $rwdata['consume_code_id'] = $order['consume_code_id'];
                $rwdata['reservationday_id'] = $reservationprice['reservationday_id'];
                $rwdata['reservationprice_id'] = $reservationprice['id'];
                $rorder_no = $hm->makeROrderNumber();
                $reback['orderNo'] = $rorder_no;
                $rwdata['reservation_no'] = $rorder_no;
                $rwdata['reservation_calendar'] = $reserDay['calendar'];
                $rwdata['reservation_week'] = $reserDay['week'];
                $rwdata['reservation_property'] = $reservationprice['property'];
                $rwdata['reservation_addprice'] = $reservationprice['addprice'];
                $rwdata['reservation_uptime'] = time();
                $rwdata['reservation_addtime'] = time();
                if($reservationprice['addprice'] > 0){
                    $rwdata['reservation_status'] = 0;
                    $reback['needpay'] = 1;
                }else{
                    $rwdata['reservation_status'] = 1;
                    $reback['needpay'] = 0;
                    //减库存
                    Db::name('product_reservationprice')->where(['id'=>$reservationprice_id])->update(['usenum'=>['exp','usenum+1']]);
                }
                if($hasReservation){
                    $res = Db::name('order_user_reservation')->where($rw)->update($rwdata);
                }else{
                    $res = Db::name('order_user_reservation')->insert($rwdata);
                }
                if($res !== false){
                    Db::commit();
                    $this->returnApiData('预约成功', 200, $reback);
                }else{
                    Db::rollback();
                    $this->returnApiData('预约失败', 400);
                }
            }else{
                Db::rollback();
                $this->returnApiData('预约日期不存在', 400);
            }
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }

    /**
     * 立即支付
     */
    public function payNow(){
        $user = getUserByToken();
        $orderNo = $this->post('orderNo', '');
        $payway = $this->post('payway', 1); //1微信公众号支付 2支付宝app；3银行卡；4微信APP
        $order = Db::name('order_user_reservation')->where(['user_id'=>$user['user_id'], 'reservation_no'=>$orderNo])->find();
        if($order){
            if($order['reservation_addprice'] == 0){
                $this->returnApiData('订单不需要支付', 400);
            }
            if($order['reservation_status'] != 0){
                $this->returnApiData('订单状态异常', 400);
            }
            if($payway == 1){
                Db::name('order_user_reservation')->where(['reservation_no'=>$orderNo])->update(['reservation_payment'=>$payway]);
                $openId = Db::name('user_connect')->where(['user_id'=>$user['user_id'], 'platform'=>'wechat'])->value('openid');
                if(!$openId){
                    $this->returnApiData('账号未授权登录服务号', 400);
                }
                $pm = new Paymodel();
                $res = $pm->wxJsPay($openId, $orderNo, $order['reservation_addprice'], 'Notify/yuyue');
                $this->returnApiData('获取成功', 200, ['jsApiParameters'=>$res]);
            }elseif($payway == 2){
                $this->returnApiData('支付宝支付尚未开通', 400);
            }elseif($payway == 3){
                $this->returnApiData('银行卡支付尚未开通', 400);
            }elseif($payway == 4){
                $pm  = new Paymodel();
                $res = $pm->wxAPPPay($orderNo, $order['reservation_addprice'], 'Notify/yuyue');
                $this->returnApiData('获取成功', 200, ['jsApiParameters'=>$res]);
            }
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }

    /**
     * 自动更新过期电子码
     * @param $order
     * @param $code
     * @param $user
     */
    private function verifyCode($order, $code, $user){
        //判断电子码是否过期
        if($order['product_endusetime'] < time()){
            Db::name('order_consume_code')->where(['consume_code'=>$code, 'user_id'=>$user['user_id']])->update(['status'=>3, 'uptime'=>time()]);
            $this->returnApiData('该订单已经过期,过期时间：'.date('Y-m-d H:i:s', $order['product_endusetime']));
        }
    }

    /**
     * @param $Rid  预约id
     * @param $Uid  用户id
     * @param $Url  跳转路径
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 用户取消预约，向商家绑定的员工发送公众号取消预约消息
     * 肖亚子
     */
    private function WeChatBusiness($Rid,$Uid,$Url){

        $Url = $Url."&isCancel=1&reservation_id={$Rid}";

        $Condition["r.reservation_id"] = $Rid;
        $Condition["r.user_id"]        = $Uid;
        $Condition["u.reg_type"]       = 1;
        $Condition["u.status"]         = 1;
//        $Condition["uc.subscribe"]     = 1;
        $Condition["uc.platform"]      = "wechat";

        $List         =  OrderModel::UserWriteOffClerk($Condition);
        $AccessToken  = Db::name('access_token')->value("access_token");

        if ($List){
            foreach ($List as $Key => $Val){
                $Data["title"]    = "用户取消预约,请前往审核";
                $Data["keyword1"] = $Val["product_name"];
                $Data["keyword2"] = date("Y年m月d日 H:i",$Val["reservation_calendar"]);
                $Data["keyword3"] = "用户取消预约";
                $Data["remark"]   = "乐玩联盟官方通知,请及时处理";

                OpenTmModel::sendTplmsg9($Val["openid"],$Data,$AccessToken,$Url);
            }
        }

        unset($List);
    }
}
