<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/22
 * Time: 13:56
 * 订单管理模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class OrderModel extends BaseModel{

    static private  $Data        = null;
    static private  $Goods       = null;
    static private  $Calendar    = null;
    static private  $Reservation = null;
    static private  $ConsumeCode = null;

    public static function TableName(){
        return Db::name("order");
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        分页数默认第一页
     * @param int $PageSize     分页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取订单数据
     * 肖亚子
     */
    public function OrderList($Condition=array(), $Psize=1, $PageSize=50){
        $Field     = "o.*,u.mobile,u.nickname,m.merchant_name";
        $Count     = self::TableName()
                        ->alias("o")
                        ->field($Field)
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('o.order_id desc')
                        ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("o")
                        ->field($Field)
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order("o.order_id desc")
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        $Payfee     = self::TableName()
                        ->alias("o")
                        ->field("sum(o.order_payfee) as payfee")
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('o.order_id desc')
                        ->find();

        return array($PaginaTion,$Payfee);
    }

    public  function OrderFind($OrderId){
        $Field  = "o.*,af.cash,af.points,af.commission,af.coupon,af.payamount,u.nickname,u.mobile,a.contact,a.mobile as amobile,a.ssq,a.address";
        $Gfield = "op.*,m.merchant_name";
        $Cfield = "cc.consume_code_id,cc.consume_code,cc.status,cc.addtime,cc.uptime,or.*,rd.week,rd.calendar,rp.addprice,rp.totalnum,rp.usenum";

        //获取订单相关信息
        self::$Data   = self::TableName()
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

        if(self::$Goods["price_type"] == 2){
            //获取免预约到店选择的日历相关信息
            self::$Calendar = Db::name("product_pricecalendar")
                                ->where(array("calendar_id" => array("in",self::$Goods["pricecalendar_id"])))
                                ->select();
        }

        if(self::$Data["order_reservation"] == 1){
            //获取预约制电子消费码和消费码预约表时间
            self::$Reservation = Db::name("order_consume_code")
                                    ->alias("cc")
                                    ->field($Cfield)
                                    ->Join("order_user_reservation or","or.consume_code_id = cc.consume_code_id","left")
                                    ->Join("product_reservationday rd","rd.reservationday_id = or.reservationday_id","left")
                                    ->Join("product_reservationprice rp","rp.id = or.reservationprice_id","left")
                                    ->where(array("cc.order_id"=>$OrderId))
                                    ->select();
        }elseif (self::$Data["order_reservation"] == 2 && self::$Data["order_isexpress"] == 1){
            self::$Reservation = Db::name("order_consume_code")
                                    ->field("consume_code_id,consume_code,status")
                                    ->where(array("order_id"=>$OrderId))
                                    ->select();
        }

        return array(self::$Data,self::$Goods,self::$Calendar,self::$Reservation);
    }

    /**
     * @param $Condition        修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改订单消费码状态
     * 肖亚子
     */
    public function OrderConsumeCodeUp($Condition,$Data){
        $CodeUp = Db::name("order_consume_code")->where($Condition)->update($Data);

        return $CodeUp;
    }

    /**
     * @param $Data        添加内容
     * @return int|string
     * 添加订单消费码刚给日志
     * 肖亚子
     */
    public function OrderCodeLogAdd($Data){
        $LogAdd = Db::name("order_consume_code_log")->insert($Data);

        return $LogAdd;
    }
    /**
     * @param array $Condition       搜索查询条件
     * @param array $CountCondition  单独订单状态条件
     * @param $Type                  查询订单状态类型
     * @param $Status                列表展示类型状态
     * @return int|string
     * 查询订单状态数量
     * 肖亚子
     */
    public function OrderCount($Condition = array(),$CountCondition = array(),$Type,$Status){
        if ($Type == $Status){
            $Count = self::TableName()
                        ->alias("o")
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('o.order_id desc')
                        ->count();
        }else{
            $Count = self::TableName()
                        ->alias("o")
                        ->Join("user u","u.user_id = o.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($CountCondition)
                        ->order('o.order_id desc')
                        ->count();
        }

        return $Count;
    }

}