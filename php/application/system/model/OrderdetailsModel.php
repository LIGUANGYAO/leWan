<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/12
 * Time: 15:53
 * 订单查询
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class OrderdetailsModel extends BaseModel{

    static private  $Data        = null;//订单详情
    static private  $Goods       = null;//订单商品
    static private  $Calendar    = null;//日历信息
    static private  $Reservation = null;//电子码和预约信息
    static private  $ConsumeCode = null;
    static private  $Delivery    = null;//快递预约发货
    static private  $OrderCode   = null;//电子码
    static private  $OrderMarkup = null;//电子码加价信息
    static private  $Orderuser   = null;//佣金获取人
    static private  $I           = 0;//佣金获取人
    static private  $Temp        = array();//佣金获取人


    public static function TableName(){
        return Db::name("order");
    }

    /**
     * @param $Number 订单号
     * @return mixed
     * 根据订单号获取订单id
     * 肖亚子
     */
    public static function OrderIdFind($Number){
        $OrderId = self::TableName()->where("order_no","=",$Number)->value("order_id");

        return $OrderId;
    }

    /**
     * @param $OrderId  订单id
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取订单相关详情
     * 肖亚子
     */
    public static function OrderFind($OrderId){
        $Field  = "o.*,af.cash,af.points,af.commission,af.coupon,af.payamount,u.nickname,u.mobile,a.contact,a.mobile as amobile,a.ssq,a.address";
        $Gfield = "op.*,m.merchant_name";
        $Cfield = "cc.consume_code_id,cc.consume_code,cc.status,cc.addtime,cc.uptime,rd.week,rd.calendar,rp.addprice,rp.totalnum,rp.usenum";

        //获取订单相关信息
        self::$Data = self::TableName()
                        ->alias("o")
                        ->field($Field)
                        ->Join("order_affiliated af","af.order_id = o.order_id","left")
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("user_address a","a.address_id = o.address_id","left")
                        ->where(array("o.order_id"=>$OrderId))
                        ->find();

        //获取订单商品信息相关数据
        self::$Goods  = Db::name("order_product")
                            ->alias("op")
                            ->field($Gfield)
                            ->Join("product p","p.product_id = op.product_id","left")
                            ->Join("merchant m","m.merchant_id = p.merchant_id","left")
                            ->where(array("op.order_id"=>$OrderId))
                            ->find();

        self::$Goods["userid_first"]            = Db::name("user")->field("mobile,nickname")->where("user_id","=",self::$Goods["userid_first"])->find();
        self::$Goods["userid_second"]           = Db::name("user")->field("mobile,nickname")->where("user_id","=",self::$Goods["userid_second"])->find();
        self::$Goods["userid_operations"]       = Db::name("user")->field("mobile,nickname")->where("user_id","=",self::$Goods["userid_operations"])->find();
        self::$Goods["userid_operations_child"] = Db::name("user")->field("mobile,nickname")->where("user_id","=",self::$Goods["userid_operations_child"])->find();
        self::$Goods["userid_playerhost_child"] = Db::name("user")->field("mobile,nickname")->where("user_id","=",self::$Goods["userid_playerhost_child"])->find();


//        if(self::$Goods["price_type"] == 2){
//            //获取免预约到店选择的日历相关信息
//            self::$Calendar = Db::name("product_pricecalendar")
//                                ->where(array("calendar_id" => array("in",self::$Goods["pricecalendar_id"])))
//                                ->select();
//        }

        if (self::$Data["order_isexpress"] == 1){//判断是不是到店
            if(self::$Data["order_reservation"] == 1){//判断是不是预约制

                self::$OrderCode = Db::name("order_consume_code")
                                    ->field("consume_code_id,consume_code,status")
                                    ->where(array("order_id" => $OrderId))
                                    ->select();

                $FieldOr = ",or.reservation_id,or.reservation_no,or.reservation_transaction_id,or.reservation_payment,or.reservation_calendar,or.reservation_week,or.reservation_property,or.reservation_addprice,or.reservation_status,or.reservation_paytime,or.reservation_uptime,or.reservation_addtime";
                //获取预约制电子消费码和消费码预约表时间

                self::$Reservation = Db::name("order_user_reservation")
                                        ->alias("or")
                                        ->field($Cfield.$FieldOr)
                                        ->Join("order_consume_code cc","cc.consume_code_id = or.consume_code_id","left")
                                        ->Join("product_reservationday rd","rd.reservationday_id = or.reservationday_id","left")
                                        ->Join("product_reservationprice rp","rp.id = or.reservationprice_id","left")
                                        ->where(array("or.order_id"=>$OrderId))
                                        ->select();
                $Markup = array();

                if (self::$Reservation){ //消费码预约信息获取是否加价
                    foreach (self::$Reservation as $Key => $Val){
                        if ($Val["reservation_no"]){
                            $Data["consume_code"]               = $Val["consume_code"];
                            $Data["reservation_no"]             = $Val["reservation_no"];
                            $Data["reservation_transaction_id"] = $Val["reservation_transaction_id"];
                            $Data["reservation_payment"]        = $Val["reservation_payment"];
                            $Data["reservation_status"]         = $Val["reservation_status"];
                            $Data["reservation_paytime"]        = $Val["reservation_paytime"];
                            $Markup[] = $Data;
                        }
                    }
                    self::$OrderMarkup = $Markup;
                }


            }elseif (self::$Data["order_reservation"] == 2){

                if(self::$Goods["price_type"] == 2){
                    //获取免预约到店选择的日历相关信息
                    self::$Calendar = Db::name("product_pricecalendar")
                                        ->where(array("calendar_id" => array("in",self::$Goods["pricecalendar_id"])))
                                        ->select();
                }

                self::$OrderCode = Db::name("order_consume_code")
                                        ->field("consume_code_id,consume_code,status")
                                        ->where(array("order_id"=>$OrderId))
                                        ->select();
            }
        }elseif (self::$Data["order_isexpress"] == 2 && self::$Data["order_reservation"] == 1){
            //获取快递商品预约制，预约发货信息
            self::$Delivery = Db::name("order_user_reservation_fahuo")
                                ->field("day,remark,addtime")
                                ->where(array("order_id"=>array("eq",$OrderId)))
                                ->find();
        }

        return array(self::$Data,self::$Goods,self::$Calendar,self::$Reservation,self::$Delivery,self::$OrderCode,self::$OrderMarkup);
    }

    /**
     * @param $Uid   用户uid
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取购买用户的上级
     * 肖亚子
     */
    public static function OrderUser($Uid){
        $UserData = Db::name("user")->field("reid,sid")->where("user_id","=",$Uid)->find();

        if ($UserData["reid"]){
            $Condition["user_id"] = array("eq",$UserData["reid"]);
            self::UserSuperior($Condition);
        }elseif($UserData["sid"]){
            $Condition["user_id"] = array("eq",$UserData["sid"]);
            self::UserSuperior($Condition);
        }

        return self::$Temp;
    }

    /**
     * @param array $Condition  查询条件
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取购买人的所有上级
     * 肖亚子
     */
    public static function UserSuperior($Condition = array()){
        $Data         = Db::name("user")->field("avatar,mobile,nickname,reid,level")->where($Condition)->find();

        if ($Data){
            switch($Data["level"]){
                case 1:$Data["level"] = "普通用户";break;
                case 2:$Data["level"] = "超级会员";break;
                case 3:$Data["level"] = "分享达人";break;
                case 4:$Data["level"] = "运营达人";break;
                case 5:$Data["level"] = "玩主";break;
            }
        }
        self::$Temp[] = $Data;

        if ($Data && $Data["reid"]){
            $Condition["user_id"] = array("eq",$Data["reid"]);
            $Sup = self::UserSuperior($Condition);
            if ($Sup){
                $SuperiorData[] = $Sup;
            }
        }
    }

}