<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/23
 * Time: 13:59
 * 电子码预约模型
 * 肖亚子
 */
namespace app\system\model;
use think\Db;


class OrderreservationModel extends BankModel{

    public static function TableName(){
        return Db::name("order_user_reservation");
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        分页数默认第一页
     * @param int $PageSize     分页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取电子码预约列表
     * 肖亚子
     */
    public function OrderReservationList($Condition=array(), $Psize=1, $PageSize=50){

        $Field = "r.reservation_id,r.reservation_no,r.reservation_payment,r.reservation_calendar,r.reservation_week,r.reservation_property,
        r.reservation_addprice,r.reservation_status,r.reservation_addtime,r.reservation_payment,
        cc.consume_code,o.order_no,o.order_fullname,o.order_mobile,p.product_name,u.mobile,u.nickname,m.merchant_name";

        $Count = self::TableName()
                    ->alias("r")
                    ->field($Field)
                    ->Join("order_consume_code cc","cc.consume_code_id = r.consume_code_id","left")
                    ->Join("order o","o.order_id = r.order_id","left")
                    ->Join("order_product p","p.order_id = r.order_id","left")
                    ->Join("user u","u.user_id = r.user_id","left")
                    ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                    ->where($Condition)
                    ->order('r.reservation_id desc')
                    ->count();

        $PageCount = ceil($Count/$PageSize);
        $List      = self::TableName()
                        ->alias("r")
                        ->field($Field)
                        ->Join("order_consume_code cc","cc.consume_code_id = r.consume_code_id","left")
                        ->Join("order o","o.order_id = r.order_id","left")
                        ->Join("order_product p","p.order_id = r.order_id","left")
                        ->Join("user u","u.user_id = r.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('r.reservation_id desc')
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }

}