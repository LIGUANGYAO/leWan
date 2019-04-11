<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/10
 * Time: 9:15
 * 分销商订单模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;
use think\Config;

class RetailadminorderModel extends BaseModel{

    static private  $Data        = null;//订单详情
    static private  $Goods       = null;//订单商品
    static private  $Calendar    = null;//日历信息
    static private  $Reservation = null;//电子码和预约信息
    static private  $ConsumeCode = null;
    static private  $Delivery    = null;//快递预约发货
    static private  $OrderCode   = null;//电子码
    static private  $OrderMarkup = null;//电子码加价信息

    public static function TableName(){
        //return Db::connect('database_distr')->name($Name);
        $Database = Config::get('database');
        $Database = $Database["database"].".".$Database["prefix"];
        $DatabaseDistr = Config::get('database_distr');
        $DatabaseDistr = $DatabaseDistr["database"].".".$DatabaseDistr["prefix"];

        return array($Database,$DatabaseDistr);
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        查询页数
     * @param int $PageSize     分页条数
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取分销商订单列表数据
     * 肖亚子
     */
    public static function OrderList($Condition = array(),$Psize = 1,$PageSize = 50){
        $Field     = "o.*,fa.company,p.num,p.price,pr.distributiontag,pp.product_property,u.mobile,u.nickname,m.merchant_name,
                     r.refund_uptime,r.refund_status,md.dboss_name";

        $Table      = self::TableName();


        $Count     = Db::table($Table[0]."order")
                    ->alias("o")
                    ->field($Field)
                    ->join($Table[1]."admin_user fa","fa.id=o.fx_admin_user_id","left")
                    ->Join($Table[0]."order_product p","p.order_id = o.order_id","left")
                    ->Join($Table[0]."product pr","pr.product_id = p.product_id","left")
                    ->Join($Table[0]."product_price pp","pp.price_id = p.price_id","left")
                    ->Join($Table[0]."user u","u.user_id = o.user_id","left")
                    ->Join($Table[0]."order_refund r","r.order_id = o.order_id","left")
                    ->Join($Table[0]."merchant m","m.merchant_id = o.merchant_id","left")
                    ->Join($Table[0]."merchant_dboss md","md.id = m.dboss_id","left")
                    ->where($Condition)
                    ->order('o.order_id desc')
                    ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = Db::table($Table[0]."order")
                        ->alias("o")
                        ->field($Field)
                        ->join($Table[1]."admin_user fa","fa.id=o.fx_admin_user_id","left")
                        ->Join($Table[0]."order_product p","p.order_id = o.order_id","left")
                        ->Join($Table[0]."product pr","pr.product_id = p.product_id","left")
                        ->Join($Table[0]."product_price pp","pp.price_id = p.price_id","left")
                        ->Join($Table[0]."user u","u.user_id = o.user_id","left")
                        ->Join($Table[0]."order_refund r","r.order_id = o.order_id","left")
                        ->Join($Table[0]."merchant m","m.merchant_id = o.merchant_id","left")
                        ->Join($Table[0]."merchant_dboss md","md.id = m.dboss_id","left")
                        ->where($Condition)
                        ->order("o.order_id desc")
                        ->page($Psize,$PageSize)
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        $Payfee     = Db::table($Table[0]."order")
                        ->alias("o")
                        ->field("sum(o.order_payfee) as payfee")
                        ->join($Table[1]."admin_user fa","fa.id=o.fx_admin_user_id","left")
                        ->Join($Table[0]."order_product p","p.order_id = o.order_id","left")
                        ->Join($Table[0]."product pr","pr.product_id = p.product_id","left")
                        ->Join($Table[0]."product_price pp","pp.price_id = p.price_id","left")
                        ->Join($Table[0]."user u","u.user_id = o.user_id","left")
                        ->Join($Table[0]."order_refund r","r.order_id = o.order_id","left")
                        ->Join($Table[0]."merchant m","m.merchant_id = o.merchant_id","left")
                        ->Join($Table[0]."merchant_dboss md","md.id = m.dboss_id","left")
                        ->where($Condition)
                        ->order('o.order_id desc')
                        ->find();

        return array($PaginaTion,$Payfee);
    }

    /**
     * @param $OrderId  订单id
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取分销商订单详情
     * 肖亚子
     */
    public static function OrderFind($OrderId){
        $Field  = "o.*,fa.company,fa.concat,fa.mobile as fxmobile,af.cash,af.points,af.commission,af.coupon,af.payamount,u.nickname,u.mobile,a.contact,a.mobile as amobile,a.ssq,a.address,r.refund_uptime,r.refund_status";
        $Gfield = "op.*,p.distributiontag,p.distributiontag,m.merchant_name";
        $Cfield = "cc.consume_code_id,cc.consume_code,cc.status,cc.addtime,cc.uptime,rd.week,rd.calendar,rp.addprice,rp.totalnum,rp.usenum";

        $Table   = self::TableName();

        //获取订单相关信息
        self::$Data   = Db::table($Table[0]."order")
                            ->alias("o")
                            ->field($Field)
                            ->join($Table[1]."admin_user fa","fa.id=o.fx_admin_user_id","left")
                            ->Join($Table[0]."order_affiliated af","af.order_id = o.order_id","left")
                            ->Join($Table[0]."order_refund r","r.order_id = o.order_id","left")
                            ->Join($Table[0]."user u","u.user_id = o.user_id","left")
                            ->Join($Table[0]."user_address a","a.address_id = o.address_id","left")
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

//        if(self::$Goods["price_type"] == 2){
//            //获取免预约到店选择的日历相关信息
//            self::$Calendar = Db::name("product_pricecalendar")
//                                ->where(array("calendar_id" => array("in",self::$Goods["pricecalendar_id"])))
//                                ->select();
//        }

        if (self::$Data["order_isexpress"] == 1){//判断是不是到店
            if (self::$Goods["distributiontag"] == 0){
                self::$OrderCode = Db::name("order_consume_code")
                                    ->alias("c")
                                    ->field("c.consume_code_id,c.consume_code,c.status,m.merchant_alias as merchant_name")
                                    ->join("merchant m","m.merchant_id = c.fen_merchant_id","left")
                                    ->where(array("c.order_id"=>$OrderId))
                                    ->select();
            }

            if(self::$Data["order_reservation"] == 1){//判断是不是预约制
                $FieldOr = ",or.reservation_id,or.reservation_no,or.reservation_transaction_id,or.reservation_payment,
                or.reservation_calendar,or.reservation_week,or.reservation_property,or.reservation_addprice,
                or.reservation_status,or.reservation_paytime,or.reservation_uptime,or.reservation_addtime";
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
            }

        }elseif (self::$Data["order_isexpress"] == 2 && self::$Data["order_reservation"] == 1){
            //获取快递商品预约制，预约发货信息
            self::$Delivery = Db::name("order_user_reservation_fahuo")
                                ->alias("f")
                                ->field("f.day,f.remark,f.addtime,m.merchant_alias as merchant_name")
                                ->join("merchant m","m.merchant_id = f.merchant_id","left")
                                ->where(array("f.order_id"=>array("eq",$OrderId)))
                                ->find();
        }

        return array(self::$Data,self::$Goods,self::$Calendar,self::$Reservation,self::$Delivery,self::$OrderCode,self::$OrderMarkup);
    }

    /**
     * @param array $Condition       搜索查询条件
     * @param array $CountCondition  单独订单状态条件
     * @param $Type                  查询订单状态类型
     * @param $Status                列表展示类型状态
     * @return int|string
     * 查询订单状态数量
     * 肖亚子
     *
     */
    public static function OrderCount($Condition = array()){
        $Table  = self::TableName();

        $Data  = Db::table($Table[0]."order")
                    ->alias("o")
                    ->field("count('o.order_id') as count,o.order_status")
                    ->join($Table[1]."admin_user fa","fa.id=o.fx_admin_user_id","left")
                    ->Join($Table[0]."order_product p","p.order_id = o.order_id","left")
                    ->Join($Table[0]."product pr","pr.product_id = p.product_id","left")
                    ->Join($Table[0]."product_price pp","pp.price_id = p.price_id","left")
                    ->Join($Table[0]."user u","u.user_id = o.user_id","left")
                    ->Join($Table[0]."order_refund r","r.order_id = o.order_id","left")
                    ->Join($Table[0]."merchant m","m.merchant_id = o.merchant_id","left")
                    ->Join($Table[0]."merchant_dboss md","md.id = m.dboss_id","left")
                    ->where($Condition)
                    ->group('o.order_status')
                    ->select();

        $Count = array('unpaid'=>0,'hair'=>0,'collect'=>0,'fulfil'=>0,'cancel'=>0,'refund'=>0,'barter'=>0,'expire'=>0);
        $Total = 0;
        foreach ($Data as $Val){
            $Total+=$Val['count'];
            switch ($Val['order_status']){
                case 1:if(isset($Val['count'])) $Count['unpaid']  = $Val['count']; break;
                case 2:if(isset($Val['count'])) $Count['hair']    = $Val['count']; break;
                case 3:if(isset($Val['count'])) $Count['collect'] = $Val['count']; break;
                case 4:if(isset($Val['count'])) $Count['fulfil']  = $Val['count']; break;
                case 5:if(isset($Val['count'])) $Count['cancel']  = $Val['count']; break;
                case 6:if(isset($Val['count'])) $Count['refund']  = $Val['count']; break;
                case 7:if(isset($Val['count'])) $Count['barter']  = $Val['count']; break;
                case 0:if(isset($Val['count'])) $Count['expire']  = $Val['count']; break;
                default: ;break;
            }
        }
        $Count['whole'] = $Total;
        return $Count;
    }

    /**
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 第三方对接平台信息
     * 肖亚子
     */
    public static function MerchantDboss(){
        $List = Db::name("merchant_dboss")->field("id,dboss_name")->select();

        return $List;
    }

}