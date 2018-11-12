<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 13:56
 * 订单管理模型
 * author@yihong
 */

namespace app\api\model;
use think\Db;

class OrderModel{

    public static function TableName(){
        return Db::name("order");
    }

    /**
     * 获取订单列表
     * @param array $Condition  查询条件
     * @param int $Psize        分页数默认第一页
     * @param int $PageSize     分页条数默认10条
     * @return array
     */
    public static function OrderList($Condition=array(), $Page=1, $PageSize=10){
        $Field     = "o.order_id,o.order_no,o.order_totalfee,o.order_status,m.merchant_name,
        m.merchant_lat,m.merchant_lng,m.merchant_address,m.merchant_ssq,p.product_id,p.product_name,
        p.product_property,p.num,p.product_startusetime,p.product_endusetime";
        $Count      =   self::TableName()
                        ->alias("o")
                        ->field($Field)
                        ->Join("order_product p","p.order_id = o.order_id")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)->count();

        $List       =   self::TableName()
                        ->alias("o")
                        ->field($Field)
                        ->Join("order_product p","p.order_id = o.order_id")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order("order_id desc")
                        ->page($Page,$PageSize)
                        ->select();
        $totalPage = ceil($Count/$PageSize);
        return array('list'=>$List,'totalPage'=>$totalPage);

    }

    /**
     * 获取订单详情
     * @param $OrderId
     * @return array
     */
    public static function getOrderInfoByOrderId($OrderId){
        if($OrderId){
            $Condition["o.order_id"] = $OrderId;
            $Field     = "o.order_addtime,o.order_no,o.order_fullname,o.order_mobile,o.order_status,
       p.product_id,p.product_name,p.price,p.num,p.product_startusetime,p.product_endusetime,
       oa.cash,oa.points,oa.commission,oa.coupon,oa.payamount";
            $orderInfo      = self::TableName()
                ->alias("o")
                ->field($Field)
                ->Join("order_product p","p.order_id = o.order_id","left")
                ->Join("order_affiliated oa","oa.order_id = o.order_id","left")
                ->where($Condition)
                ->find();
            return $orderInfo;

        }else{
             return false;
        }
    }

    /**
     * 根据用户ID获取订单数量
     * @param $UserId 用户ID
     * @param int $status 订单状态
     * @return bool|int|string
     */
    public static function GetOrderCountByUserId($UserId,$status= ''){
        if($UserId){
            if($status){
                $OrderCondition["o.order_status"] = $status;
            }
            $OrderCondition["o.user_id"] = $UserId;
            return self::TableName()
                ->alias("o")
                ->Join("user u","u.user_id = o.user_id","left")
                ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                ->where($OrderCondition)
                ->order('o.order_id desc')
                ->count();
        }else{
            return false;
        }
    }

}